module OutputIceMod
  use Math
  use Constants
  use Harmsy
  use Loadsave
  implicit none; public; contains

  subroutine harm_analysis_surfDeform_sub(filein, jmax, identifier)
    character(len=*),  intent(in)  :: filein, identifier
    integer,           intent(in)  :: jmax
    integer                        :: ij, ijm, jms
    real(kind=dbl),    allocatable :: data_deform(:,:)
    complex(kind=dbl), allocatable :: spectra(:)
    
    jms = jmax*(jmax+1)/2+jmax+1
    
    allocate( spectra(jms), data_deform(2*nth,0:nth) )
      
      call load_spectra_2d_sub(filein, jms, spectra)
      call harmsy_sub(jmax, 1, spectra, data_deform)
      call save_data_2d_sub(identifier//'.range', identifier//'.dat', data_deform, 'n')
      
    deallocate( spectra, data_deform )
    
  end subroutine harm_analysis_surfDeform_sub
    
end module OutputIceMod
