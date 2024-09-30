module OutputIceMod
  use Math
  use Harmsy
  implicit none
  
  public  :: harm_analysis_surfDeform_sub
  private :: get_spectra_sub
 
  contains

  subroutine harm_analysis_surfDeform_sub(pathin, jmax, identifier)
    character(len=*),  intent(in)  :: pathin, identifier
    integer,           intent(in)  :: jmax
    complex(kind=dbl), allocatable :: spectra_up(:), spectra_dn(:)
    real(kind=dbl),    allocatable :: data_up(:,:), data_dn(:,:)
    
    allocate( spectra_up(jmax*(jmax+1)/2+jmax+1) ); spectra_up = czero
    allocate( spectra_dn(jmax*(jmax+1)/2+jmax+1) ); spectra_dn = czero
    
    call get_spectra_sub(pathin)
    
    allocate( data_up(2*nth,nth) ); data_up = zero
    allocate( data_dn(2*nth,nth) ); data_dn = zero
    
      !Preved spektrum na grid
      call harmsy_sub(jmax, 1, spectra_up, data_up)
      call harmsy_sub(jmax, 1, spectra_dn, data_dn)
    
    deallocate( spectra_up, spectra_dn )
    
      open(unit=8, file=identifier//'-up.range', status='new', action='write')
        write(8,*) maxval(data_up)
        write(8,*) minval(data_up)
      close(8)
      
      open(unit=8, file=identifier//'-up.dat', status='new', action='write')
        do ith = 0, 180
          do iph = 1, 360
            write(8,*) iph, ith-90, data_up(iph,ith)
          end do
        end do
      close(8)
      
      open(unit=8, file=identifier//'-dn.range', status='new', action='write')
        write(8,*) maxval(data_dn)
        write(8,*) minval(data_dn)
      close(8)
      
      open(unit=8, file=identifier//'-dn.dat', status='new', action='write')
        do ith = 0, 180
          do iph = 1, 360
            write(8,*) iph, ith-90, data_dn(iph,ith)
          end do
        end do
      close(8)
    
    deallocate( data_up, data_dn )
    
  end subroutine harm_analysis_surfDeform_sub

    subroutine get_spectra_sub(path)
      character(len=*), intent(in) :: path
      character(len=10)            :: subor
      integer                      :: j, m, n, error
      complex(kind=dbl)            :: u_dn, u_up
    
      !Najdi najnovsi subor s tvarovymi koeficientami
      n = 0
      do
        write(subor, '(1I4)') n
    
        open(unit=8, file=path//trim(adjustl(subor))//'.dat', status='old', action='read', iostat=error)
        if (error /= 0) then
          write(subor, '(1I4)') n-1
          exit
        end if
        close(8)
    
        n = n + 1
      end do
      
      !Nacitaj spektrum najnovsich koeficientov
      open(unit=8, file=path//trim(adjustl(subor))//'.dat', status='old', action='read')
    
      do
        read(8,*,iostat=error) j, m, u_dn, u_up; if (error /= 0) exit
        
        spectra_dn(j*(j+1)/2+m+1) = u_dn
        spectra_up(j*(j+1)/2+m+1) = u_up
      end do
    
      close(8)
      
    end subroutine get_spectra_sub
    
end module OutputIceMod
