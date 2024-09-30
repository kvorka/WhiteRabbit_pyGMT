submodule(OutputOceanMod) Flux
  implicit none; contains

  module subroutine harm_analysis_flux_sub(filein, jmax, identifier)
    character(len=*),  intent(in)  :: filein, identifier
    integer,           intent(in)  :: jmax
    integer                        :: jm, jms, error, iph, ith, j, m
    real(kind=dbl)                 :: fac
    real(kind=dbl),    allocatable :: data_flux(:,:)
    complex(kind=dbl)              :: fluxjm
    complex(kind=dbl), allocatable :: spectra(:)
    
    jms = jmax*(jmax+1)/2+jmax+1
    
    allocate( spectra(jms) )
    
    open(unit=1, file=filein, status='old', action='read')
      do
        read(1,*,iostat=error) jm, fluxjm ; if (error /= 0) exit
        spectra(jm) = fluxjm
      end do
    close(1)
    
    fac        = sqrt(4*pi) / real( spectra(1), kind=dbl)
    spectra(1) = czero
    
    do j = 1, jmax
      jm = j*(j+1)/2+1
      
      !m = 0
        spectra(jm) = spectra(jm) * fac
      
      do m = 1, j
        spectra(jm+m) = czero
      end do
    end do
    
    allocate( data_flux(2*nth,0:nth) ); data_flux = 0._dbl
    
      call harmsy_sub(jmax, 1, spectra, data_flux)
    
    deallocate( spectra )
    
      open(unit=8, file=identifier//'-flux.range', status='new', action='write')
        write(8,*) maxval(data_flux)
        write(8,*) minval(data_flux)
      close(8)
      
      open(unit=8, file=identifier//'-flux.dat', status='new', action='write')
        do ith = 0, 180
          do iph = 1, 360
            write(8,*) iph, ith-90, data_flux(iph,ith)
          end do
        end do
      close(8)
    
    deallocate( data_flux )
    
  end subroutine harm_analysis_flux_sub
  
end submodule Flux
