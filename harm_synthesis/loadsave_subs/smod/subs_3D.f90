submodule (Load) subs_3D
  implicit none; contains
  
  module subroutine load_spectra_3d_sub(filein, dimjml, dimr, r, spectra)
    character(len=*),  intent(in)  :: filein
    integer,           intent(in)  :: dimjml, dimr
    real(kind=dbl),    intent(out) :: r(n_out)
    complex(kind=dbl), intent(out) :: spectra(dimjml,n_out)
    integer                        :: ir, iir
    real(kind=dbl),    allocatable :: r1(:)
    complex(kind=dbl), allocatable :: spectra1(:,:)
    
    allocate( r1(dimr+1), spectra1(dimjml,dimr+1) )
      
      open(unit=10, file=filein, status='old', action='read')
        do ir = 1, dimr+1
          read(10,*) r1(ir), spectra1(:,ir)
        end do
      close(10)
      
      !$omp parallel do private (iir)
      do ir = 1, n_out
        r(ir) = r_ud_ocean/(1-r_ud_ocean) + (ir-1._dbl)/(n_out-1._dbl)
        
        do iir = 1, dimr
          if ( ( r(ir) >= r1(iir) ) .and. ( r(ir) <= r1(iir+1) ) ) then
            spectra(:,ir) = ( ( r(ir)     - r1(iir) ) * spectra1(:,iir+1) + &
                            & ( r1(iir+1) - r(ir)   ) * spectra1(:,iir  )   ) / ( r1(iir+1) - r1(iir) )
            exit
          end if
        end do
      end do
      !$omp end parallel do
    
    deallocate( r1, spectra1 )
    
  end subroutine load_spectra_3d_sub
  
  module subroutine save_data_3d_sub(file_range, file_data, r, grddata, eqsim)
    character(len=*), intent(in) :: file_range, file_data
    real(kind=dbl),   intent(in) :: r(n_out), grddata(0:nth,n_out)
    character,        intent(in) :: eqsim
    integer                      :: ith, ir
    real(kind=dbl)               :: dhelp, dmax, dmin, r_dim
    
    dmax = zero
    dmin = huge(zero)
    
    open(unit=8, file=file_data, status='new', action='write')
      do ir = 1, n_out
        r_dim = (r_out-r_in) * r(ir) + (r_in - r_ud_ocean * r_out) / (1-r_ud_ocean)
        
        do ith = 0, nth
          if ( eqsim == 's' ) then
            dhelp = ( grddata(ith,ir) + grddata(nth-ith,ir) ) / 2
          else if ( eqsim == 'a' ) then
            dhelp = ( grddata(ith,ir) - grddata(nth-ith,ir) ) / 2
          else
            dhelp = grddata(ith,ir)
          end if
          
          dmax = max(dmax, dhelp)
          dmin = min(dmin, dhelp)
          
          write(8,'(3F15.7)') r_dim, ith*180._dbl/nth, dhelp
        end do
      end do
    close(8)
    
    open(unit=8, file=file_range, status='new', action='write')
      write(8,*) dmin
      write(8,*) dmax
    close(8)
    
  end subroutine save_data_3d_sub
  
end submodule subs_3D