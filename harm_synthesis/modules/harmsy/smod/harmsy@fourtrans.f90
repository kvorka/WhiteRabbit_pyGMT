submodule (harmsy) fourtrans
  implicit none; contains
  
  module pure subroutine fourtrans_sum_sub(n, expmul, sumLege1, grd1)
    integer,           intent(in)    :: n
    complex(kind=dbl), intent(in)    :: expmul(2*nth)
    complex(kind=dbl), intent(in)    :: sumLege1(n)
    real(kind=dbl),    intent(inout) :: grd1(n,2*nth)
    integer                          :: in, ip
    
    do concurrent ( ip = 1:2*nth, in = 1:n )
      grd1(in,ip) = grd1(in,ip) + 2 * real( expmul(ip) * sumLege1(in) , kind=dbl )
    end do
    
  end subroutine fourtrans_sum_sub
  
  module pure subroutine fourtrans2_sum_sub(n, expmul, sumLege1, grd1, sumLege2, grd2)
    integer,           intent(in)    :: n
    complex(kind=dbl), intent(in)    :: expmul(2*nth)
    complex(kind=dbl), intent(in)    :: sumLege1(n,2), sumLege2(n,2)
    real(kind=dbl),    intent(inout) :: grd1(n,2*nth,2), grd2(n,2*nth,2)
    integer                          :: i1, in, ip
    
    do concurrent ( i1 = 1:2, ip = 1:2*nth, in = 1:n )
      grd1(in,ip,  i1) = grd1(in,ip,  i1) + 2 * real( expmul(ip) * sumLege1(in,i1) , kind=dbl )
      grd2(in,ip,3-i1) = grd2(in,ip,3-i1) + 2 * real( expmul(ip) * sumLege2(in,i1) , kind=dbl )
    end do
    
  end subroutine fourtrans2_sum_sub
  
  module pure subroutine fourtrans4_sum_sub(n, expmul, sumLege1, grd1, sumLege2, grd2)
    integer,           intent(in)    :: n
    complex(kind=dbl), intent(in)    :: expmul(2*nth)
    complex(kind=dbl), intent(in)    :: sumLege1(n,4), sumLege2(n,4)
    real(kind=dbl),    intent(inout) :: grd1(n,2*nth,4), grd2(n,2*nth,4)
    integer                          :: i1, in, ip
    
    do concurrent ( i1 = 1:4, ip = 1:2*nth, in = 1:n )
      grd1(in,ip,  i1) = grd1(in,ip,  i1) + 2 * real( expmul(ip) * sumLege1(in,i1) , kind=dbl )
      grd2(in,ip,5-i1) = grd2(in,ip,5-i1) + 2 * real( expmul(ip) * sumLege2(in,i1) , kind=dbl )
    end do
    
  end subroutine fourtrans4_sum_sub
  
end submodule fourtrans