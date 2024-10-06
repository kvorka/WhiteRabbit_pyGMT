module harmsy
  use math
  implicit none
  
  real(kind=dbl),    allocatable, private :: cmm(:), amj(:), bmj(:)
  complex(kind=dbl), allocatable, private :: expphi(:)
  
  public :: init_harmsy_sub
  public :: harmsy_sub
  public :: deallocate_harmsy_sub
  
  private :: pmj_set0_sub
  private :: pmj_set_sub
  private :: pmj_recursion_sub
  private :: pmj_sum_sub
  
  private :: pmj4_set0_sub
  private :: pmj4_set_sub
  private :: pmj4_recursion_sub
  private :: pmj4_sum_sub
  private :: pmj4_transpose_sub
  
  private :: fourtrans_set_sub
  private :: fourtrans4_sum_sub
  
  interface
    module subroutine init_harmsy_sub(jmax, ntheta)
      integer, intent(in) :: jmax, ntheta
    end subroutine init_harmsy_sub
    
    module pure subroutine harmsy_sub(jmax, n, spectra, gridvals)
      integer,           intent(in)  :: jmax, n
      complex(kind=dbl), intent(in)  :: spectra(n,*)
      real(kind=dbl),    intent(out) :: gridvals(n,2*nth,0:nth)
    end subroutine harmsy_sub
    
    module subroutine deallocate_harmsy_sub()
    end subroutine deallocate_harmsy_sub
    
    module pure subroutine pmj_set0_sub(it, ctheta, stheta)
      integer,        intent(in)  :: it
      real(kind=dbl), intent(out) :: ctheta
      real(kind=dbl), intent(out) :: stheta
    end subroutine pmj_set0_sub
    
    module pure subroutine pmj_set_sub(im, stheta, p0j, pmj, pmj1, pmj2)
      integer,        intent(in)    :: im
      real(kind=dbl), intent(in)    :: stheta
      real(kind=dbl), intent(inout) :: p0j, pmj, pmj1, pmj2
    end subroutine pmj_set_sub
    
    module pure subroutine pmj_recursion_sub(imj, ctheta, pmj, pmj1, pmj2)
      integer,        intent(in)    :: imj
      real(kind=dbl), intent(in)    :: ctheta
      real(kind=dbl), intent(inout) :: pmj, pmj1, pmj2
    end subroutine pmj_recursion_sub
    
    module pure subroutine pmj_sum_sub(n, pmj, sumLege, spectra)
      integer,           intent(in)    :: n
      real(kind=dbl),    intent(in)    :: pmj
      complex(kind=dbl), intent(in)    :: spectra(n)
      complex(kind=dbl), intent(inout) :: sumLege(n)
    end subroutine pmj_sum_sub
    
    module pure subroutine pmj4_set0_sub(it, ctheta, stheta)
      integer,        intent(in)  :: it
      real(kind=dbl), intent(out) :: ctheta(4)
      real(kind=dbl), intent(out) :: stheta(4)
    end subroutine pmj4_set0_sub
    
    module pure subroutine pmj4_set_sub(im, stheta, p0j, pmj, pmj1, pmj2)
      integer,        intent(in)    :: im
      real(kind=dbl), intent(in)    :: stheta(4)
      real(kind=dbl), intent(inout) :: p0j(4), pmj(4), pmj1(4), pmj2(4)
    end subroutine pmj4_set_sub
    
    module pure subroutine pmj4_recursion_sub(imj, ctheta, pmj, pmj1, pmj2)
      integer,        intent(in)    :: imj
      real(kind=dbl), intent(in)    :: ctheta(4)
      real(kind=dbl), intent(inout) :: pmj(4), pmj1(4), pmj2(4)
    end subroutine pmj4_recursion_sub
    
    module pure subroutine pmj4_sum_sub(n, pmj, sumLege, spectra)
      integer,           intent(in)    :: n
      real(kind=dbl),    intent(in)    :: pmj(4)
      complex(kind=dbl), intent(in)    :: spectra(n)
      complex(kind=dbl), intent(inout) :: sumLege(4,n)
    end subroutine pmj4_sum_sub
    
    module pure subroutine pmj4_transpose_sub(n, sumLege1, sumLege)
      integer,           intent(in)  :: n
      complex(kind=dbl), intent(in)  :: sumLege1(4,n)
      complex(kind=dbl), intent(out) :: sumLege(n,4)
    end subroutine pmj4_transpose_sub
    
    module pure subroutine fourtrans_set_sub(im, ip, expmul)
      integer,           intent(in)    :: im, ip
      complex(kind=dbl), intent(inout) :: expmul
    end subroutine fourtrans_set_sub
    
    module pure subroutine fourtrans4_sum_sub(n, expmul, sumLege, gridvals)
      integer,           intent(in)    :: n
      complex(kind=dbl), intent(in)    :: expmul
      complex(kind=dbl), intent(in)    :: sumLege(n,4)
      real(kind=dbl),    intent(inout) :: gridvals(n,*)
    end subroutine fourtrans4_sum_sub
  end interface
  
end module harmsy