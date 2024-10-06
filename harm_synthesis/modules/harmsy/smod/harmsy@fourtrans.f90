submodule (harmsy) fourtrans
  implicit none; contains
  
  module pure subroutine fourtrans_set_sub(im, ip, expmul)
    integer,           intent(in)    :: im, ip
    complex(kind=dbl), intent(inout) :: expmul
    
    select case ( im )
      case (0)
        expmul = cone / 2
      
      case (1)
        expmul = expphi(ip)
      
      case default
        expmul = expmul * expphi(ip)
      
    end select
    
  end subroutine fourtrans_set_sub
  
  module pure subroutine fourtrans4_sum_sub(n, expmul, sumLege, gridvals)
    integer,           intent(in)    :: n
    complex(kind=dbl), intent(in)    :: expmul
    complex(kind=dbl), intent(in)    :: sumLege(n,4)
    real(kind=dbl),    intent(inout) :: gridvals(n,*)
    integer                          :: i1, in
    
    do concurrent ( i1 = 1:4, in = 1:n )
      gridvals(in,1+(i1-1)*2*nth) = gridvals(in,1+(i1-1)*2*nth) + 2 * real( expmul * sumLege(in,i1) , kind=dbl )
    end do
    
  end subroutine fourtrans4_sum_sub
  
end submodule fourtrans