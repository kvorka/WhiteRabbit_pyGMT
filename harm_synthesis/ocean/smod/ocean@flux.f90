submodule (ocean) flux
  implicit none; contains

  module subroutine harm_synthesis_flux_sub(filein, jmax, identifier)
    character(len=*),  intent(in)  :: filein, identifier
    integer,           intent(in)  :: jmax
    integer                        :: ij, ijm, jms
    real(kind=dbl)                 :: fac
    real(kind=dbl),    allocatable :: data_flux(:,:)
    complex(kind=dbl), allocatable :: spectra(:)
    
    jms = jmax*(jmax+1)/2+jmax+1
    
    allocate( spectra(jms), data_flux(2*nth,0:nth) )
      
      call load_spectra_2d_sub(filein, jms, spectra)
      
      if ( abs(spectra(1)%re) > zero ) then
        fac        = sq4pi / real( spectra(1), kind=dbl)
        spectra(1) = czero
      else
        fac = one
      end if
      
      do ij = 1, jmax
        ijm = ij*(ij+1)/2+1
          spectra(ijm)          = spectra(ijm) * fac
          spectra(ijm+1:ijm+ij) = czero
      end do
      
      call harmsy_sub(jmax, 1, spectra, data_flux)
      
      call save_data_1d_sub(identifier//'-flux-1d.dat', data_flux, 's')
      call save_data_2d_sub(identifier//'-flux.range', identifier//'-flux.dat', data_flux, 'n')
      
    deallocate( spectra, data_flux )
    
  end subroutine harm_synthesis_flux_sub
  
end submodule flux