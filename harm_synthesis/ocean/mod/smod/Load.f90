submodule(OutputOceanMod) Load
  implicit none; contains
  
  module subroutine load_spectra_sub(filein, dimjml, dimr, r, spectra)
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
    
  end subroutine load_spectra_sub
  
end submodule Load