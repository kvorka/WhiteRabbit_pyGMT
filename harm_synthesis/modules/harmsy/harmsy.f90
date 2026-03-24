module harmsy
  use math
  implicit none
  
  real(kind=dbl),    allocatable, private :: cmm(:), amj(:), bmj(:), costheta(:), sintheta(:)
  complex(kind=dbl), allocatable, private :: expphi(:)
  
  public :: init_harmsy_sub
  public :: harmsy_sub
  public :: deallocate_harmsy_sub
  
  interface
    module subroutine init_harmsy_sub(jmax, ntheta)
      integer, intent(in) :: jmax, ntheta
    end subroutine init_harmsy_sub
    
    module subroutine deallocate_harmsy_sub()
    end subroutine deallocate_harmsy_sub
    
    module subroutine harmsy_sub(jmax, n, spectra, gridvals)
      integer,           intent(in)  :: jmax, n
      complex(kind=dbl), intent(in)  :: spectra(n,*)
      real(kind=dbl),    intent(out) :: gridvals(nth,n,2*nth)
    end subroutine harmsy_sub
    
    module subroutine harmsy3_sub(jmax, spectra, gridvals)
      integer,           intent(in)  :: jmax
      complex(kind=dbl), intent(in)  :: spectra(3,*)
      real(kind=dbl),    intent(out) :: gridvals(nth,3,2*nth)
    end subroutine harmsy3_sub
  end interface
  
end module harmsy