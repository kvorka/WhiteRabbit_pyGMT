submodule (ocean) flux
  implicit none; contains

  module procedure harm_synthesis_flux_sub
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
      
      spectra = spectra * fac
      
      !do ij = 1, jmax
      !  ijm = ij*(ij+1)/2+1
      !    spectra(ijm)          = spectra(ijm) * fac
      !    spectra(ijm+1:ijm+ij) = czero
      !end do
      
      call init_harmsy_sub(jmax, nth)
      call harmsy_sub(jmax, 1, spectra, data_flux)
      call deallocate_harmsy_sub()
      
      !call save_data_1d_sub(identifier//'-flux-1d.dat', data_flux, 's')
      call save_data_2d_sub(identifier//'-flux.range', identifier//'-flux.dat', data_flux, 'n')
      
    deallocate( spectra, data_flux )
    
  end procedure harm_synthesis_flux_sub
  
end submodule flux