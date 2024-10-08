module ice
  use math
  use loadsave
  use harmsy
  implicit none; public; contains

  subroutine harm_synthesis_surfDeform_sub(filein, jmax, identifier)
    character(len=*),  intent(in)  :: filein, identifier
    integer,           intent(in)  :: jmax
    integer                        :: ij, ijm, jms
    real(kind=dbl),    allocatable :: data_deform(:,:)
    complex(kind=dbl), allocatable :: spectra(:)
    
    jms = jmax*(jmax+1)/2+jmax+1
    
    allocate( spectra(jms), data_deform(2*nth,0:nth) )
      
      call load_spectra_2d_sub(filein, jms, spectra)
      
      call init_harmsy_sub(jmax, nth)
      call harmsy_sub(jmax, 1, spectra, data_deform)
      call deallocate_harmsy_sub()
      
      call save_data_2d_sub(identifier//'.range', identifier//'.dat', data_deform, 'n')
      
    deallocate( spectra, data_deform )
    
  end subroutine harm_synthesis_surfDeform_sub
    
end module ice