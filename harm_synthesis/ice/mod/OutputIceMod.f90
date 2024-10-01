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
      integer                      :: ijm, ierror
      complex(kind=dbl)            :: u_dn, u_up
      
      ijm = -1
      
      do
        ijm = ijm + 1
        write(subor,'(1I4)') in
        
        open(unit=8, file=path//trim(adjustl(subor))//'.dat', status='old', action='read', iostat=error)
          if (ierror /= 0) then
            write(subor,'(1I4)') ijm-1
            exit
          end if
        close(8)
      end do
      
      open(unit=8, file=path//trim(adjustl(subor))//'.dat', status='old', action='read')
      
        do
          read(8,*,iostat=ierror) ijm, u_dn, u_up
          
          if (idateerror /= 0) then
            exit
          else
            spectra_dn(ijm) = u_dn
            spectra_up(ijm) = u_up
          end if
        end do
        
      close(8)
      
    end subroutine get_spectra_sub
    
end module OutputIceMod
