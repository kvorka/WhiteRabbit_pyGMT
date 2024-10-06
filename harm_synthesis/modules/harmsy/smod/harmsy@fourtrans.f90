submodule (harmsy) fourtrans
  implicit none; contains
  
  module pure subroutine fourtrans_sum_sub(n, expmul, sumLege1, grd1)
    integer,           intent(in)    :: n
    complex(kind=dbl), intent(in)    :: expmul
    complex(kind=dbl), intent(in)    :: sumLege1(n)
    real(kind=dbl),    intent(inout) :: grd1(n)
    integer                          :: i1, in
    
    do concurrent ( in = 1:n )
      grd1(in) = grd1(in) + 2 * real( expmul * sumLege1(in) , kind=dbl )
    end do
    
  end subroutine fourtrans_sum_sub
  
  module pure subroutine fourtrans2_sum_sub(n, expmul, sumLege1, grd1, sumLege2, grd2)
    integer,           intent(in)    :: n
    complex(kind=dbl), intent(in)    :: expmul
    complex(kind=dbl), intent(in)    :: sumLege1(n,2), sumLege2(n,2)
    real(kind=dbl),    intent(inout) :: grd1(n,*), grd2(n,*)
    integer                          :: i1, in
    
    do concurrent ( i1 = 1:2, in = 1:n )
      grd1(in,1+(i1-1)*2*nth) = grd1(in,1+(i1-1)*2*nth) + 2 * real( expmul * sumLege1(in,i1) , kind=dbl )
      grd2(in,1-(i1-1)*2*nth) = grd2(in,1-(i1-1)*2*nth) + 2 * real( expmul * sumLege2(in,i1) , kind=dbl )
    end do
    
  end subroutine fourtrans2_sum_sub
  
  module pure subroutine fourtrans4_sum_sub(n, expmul, sumLege1, grd1, sumLege2, grd2)
    integer,           intent(in)    :: n
    complex(kind=dbl), intent(in)    :: expmul
    complex(kind=dbl), intent(in)    :: sumLege1(n,4), sumLege2(n,4)
    real(kind=dbl),    intent(inout) :: grd1(n,*), grd2(n,*)
    integer                          :: i1, in
    
    do concurrent ( i1 = 1:4, in = 1:n )
      grd1(in,1+(i1-1)*2*nth) = grd1(in,1+(i1-1)*2*nth) + 2 * real( expmul * sumLege1(in,i1) , kind=dbl )
      grd2(in,1-(i1-1)*2*nth) = grd2(in,1-(i1-1)*2*nth) + 2 * real( expmul * sumLege2(in,i1) , kind=dbl )
    end do
    
  end subroutine fourtrans4_sum_sub
  
end submodule fourtrans