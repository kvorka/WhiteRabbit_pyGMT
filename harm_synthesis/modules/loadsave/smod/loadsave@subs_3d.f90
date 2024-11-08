submodule (loadsave) subs_3D
  implicit none; contains
  
  module procedure load_spectra_3d_sub
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
    
  end procedure load_spectra_3d_sub
  
  module procedure save_data_3d_sub
    integer        :: ith, ir
    real(kind=dbl) :: dhelp, dmax, dmin, r_dim
    
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
          
          write(8,'(3F15.7)') r_dim, 90-ith*180._dbl/nth, dhelp
        end do
      end do
    close(8)
    
    open(unit=8, file=file_range, status='new', action='write')
      write(8,*) dmin
      write(8,*) dmax
    close(8)
    
  end procedure save_data_3d_sub
  
end submodule subs_3D