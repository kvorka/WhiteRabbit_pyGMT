submodule (harmsy) fourtrans
  implicit none; contains
  
  module procedure fourtrans_sum_sub
    integer :: in, ip
    
    do concurrent ( ip = 1:2*nth, in = 1:n )
      grd1(in,ip) = grd1(in,ip) + expmul(ip)%re * sumLege1(in)%re - expmul(ip)%im * sumLege1(in)%im
    end do
    
  end procedure fourtrans_sum_sub
  
  module procedure fourtrans2_sum_sub
    integer :: i1, in, ip
    
    do concurrent ( i1 = 1:2, ip = 1:2*nth, in = 1:n )
      grd1(in,ip,  i1) = grd1(in,ip,  i1) + expmul(ip)%re * sumLege1(in,i1)%re - expmul(ip)%im * sumLege1(in,i1)%im
      grd2(in,ip,3-i1) = grd2(in,ip,3-i1) + expmul(ip)%re * sumLege2(in,i1)%re - expmul(ip)%im * sumLege2(in,i1)%im
    end do
    
  end procedure fourtrans2_sum_sub
  
  module procedure fourtrans4_sum_sub
    integer :: i1, in, ip
    
    do concurrent ( i1 = 1:4, ip = 1:2*nth, in = 1:n )
      grd1(in,ip,  i1) = grd1(in,ip,  i1) + expmul(ip)%re * sumLege1(in,i1)%re - expmul(ip)%im * sumLege1(in,i1)%im
      grd2(in,ip,5-i1) = grd2(in,ip,5-i1) + expmul(ip)%re * sumLege2(in,i1)%re - expmul(ip)%im * sumLege2(in,i1)%im
    end do
    
  end procedure fourtrans4_sum_sub
  
end submodule fourtrans