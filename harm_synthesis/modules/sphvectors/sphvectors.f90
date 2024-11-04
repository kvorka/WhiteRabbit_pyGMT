module sphvectors
  use math
  implicit none
  
  public :: vec2scals_sub
  public :: vecxyz2vecrtp_sub, vecxyz2zonvecrtp_sub
  
  private :: cleb1_fn
  
  interface
    module pure subroutine vec2scals_sub(jmax, vec, xyz)
      integer,           intent(in)  :: jmax
      complex(kind=dbl), intent(in)  :: vec(*)
      complex(kind=dbl), intent(out) :: xyz(3,*)
    end subroutine vec2scals_sub
    
    module pure subroutine vecxyz2zonvecrtp_sub(vxyz, vrtp)
      real(kind=dbl), intent(in)  :: vxyz(3,2*nth,0:nth)
      real(kind=dbl), intent(out) :: vrtp(3,0:nth)
    end subroutine vecxyz2zonvecrtp_sub
    
    module pure subroutine vecxyz2vecrtp_sub(vxyz, vrtp)
      real(kind=dbl), intent(in)  :: vxyz(3,2*nth,0:nth)
      real(kind=dbl), intent(out) :: vrtp(3,2*nth,0:nth)
    end subroutine vecxyz2vecrtp_sub
    
    module pure function cleb1_fn(j1, m1, j2, m2, j, m) result(cleb1)
      integer,       intent(in) :: j1, m1, j2, m2, j, m
      real(kind=dbl)            :: cleb1
    end function cleb1_fn
  end interface
  
end module sphvectors