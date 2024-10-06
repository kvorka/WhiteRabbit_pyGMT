submodule (harmsy) legep
  implicit none; contains
  
  module pure subroutine pmj_set0_sub(it, ctheta, stheta)
    integer,        intent(in)  :: it
    real(kind=dbl), intent(out) :: ctheta
    real(kind=dbl), intent(out) :: stheta
    
    ctheta = cos(it*pi/nth)
    stheta = sin(it*pi/nth)
    
  end subroutine pmj_set0_sub
  
  module pure subroutine pmj_set_sub(im, stheta, p0j, pmj, pmj1, pmj2)
    integer,        intent(in)    :: im
    real(kind=dbl), intent(in)    :: stheta
    real(kind=dbl), intent(inout) :: p0j, pmj, pmj1, pmj2
    
    if ( im > 0 ) then
      p0j = p0j * cmm(im) * stheta
    else
      p0j = 1 / sq4pi
    end if
    
    pmj2 = zero
    pmj1 = zero
    pmj  = p0j
    
  end subroutine pmj_set_sub
  
  module pure subroutine pmj_recursion_sub(imj, ctheta, pmj, pmj1, pmj2)
    integer,        intent(in)    :: imj
    real(kind=dbl), intent(in)    :: ctheta
    real(kind=dbl), intent(inout) :: pmj, pmj1, pmj2
    
    pmj2 = pmj1
    pmj1 = pmj
    pmj  = amj(imj) * ctheta * pmj1 - bmj(imj) * pmj2
    
  end subroutine pmj_recursion_sub
  
  module pure subroutine pmj_sum_sub(n, pmj, sumLege, spectra)
    integer,           intent(in)    :: n
    real(kind=dbl),    intent(in)    :: pmj
    complex(kind=dbl), intent(in)    :: spectra(n)
    complex(kind=dbl), intent(inout) :: sumLege(n)
    integer                          :: in
    
    do concurrent ( in = 1:n )
      sumLege(in) = sumLege(in) + spectra(in) * pmj
    end do
    
  end subroutine pmj_sum_sub
  
  module pure subroutine pmj4_set0_sub(it, ctheta, stheta)
    integer,        intent(in)  :: it
    real(kind=dbl), intent(out) :: ctheta(4)
    real(kind=dbl), intent(out) :: stheta(4)
    integer                     :: i1
    
    do concurrent ( i1 = 1:4 )
      ctheta(i1) = cos((it+i1-1)*pi/nth)
      stheta(i1) = sin((it+i1-1)*pi/nth)
    end do
    
  end subroutine pmj4_set0_sub
  
  module pure subroutine pmj4_set_sub(im, stheta, p0j, pmj, pmj1, pmj2)
    integer,        intent(in)    :: im
    real(kind=dbl), intent(in)    :: stheta(4)
    real(kind=dbl), intent(inout) :: p0j(4), pmj(4), pmj1(4), pmj2(4)
    integer                       :: i1
    
    if ( im > 0 ) then
      do concurrent ( i1 = 1:4 )
        p0j(i1) = p0j(i1) * cmm(im) * stheta(i1)
      end do
    else
      do concurrent ( i1 = 1:4 )
        p0j(i1) = 1 / sq4pi
      end do
    end if
    
    do concurrent ( i1 = 1:4 )
      pmj2(i1) = zero
      pmj1(i1) = zero
      pmj(i1)  = p0j(i1)
    end do
    
  end subroutine pmj4_set_sub
  
  module pure subroutine pmj4_recursion_sub(imj, ctheta, pmj, pmj1, pmj2)
    integer,        intent(in)    :: imj
    real(kind=dbl), intent(in)    :: ctheta(4)
    real(kind=dbl), intent(inout) :: pmj(4), pmj1(4), pmj2(4)
    integer                       :: i1
    
    do concurrent ( i1 = 1:4 )
      pmj2(i1) = pmj1(i1)
      pmj1(i1) = pmj(i1)
      pmj(i1)  = amj(imj) * ctheta(i1) * pmj1(i1) - bmj(imj) * pmj2(i1)
    end do
    
  end subroutine pmj4_recursion_sub
  
  module pure subroutine pmj4_sum_sub(n, pmj, sumLege, spectra)
    integer,           intent(in)    :: n
    real(kind=dbl),    intent(in)    :: pmj(4)
    complex(kind=dbl), intent(in)    :: spectra(n)
    complex(kind=dbl), intent(inout) :: sumLege(4,n)
    integer                          :: i1, in
    
    do concurrent ( in = 1:n, i1 = 1:4 )
      sumLege(i1,in) = sumLege(i1,in) + spectra(in) * pmj(i1)
    end do
    
  end subroutine pmj4_sum_sub
  
  module pure subroutine pmj4_transpose_sub(n, sumLege1, sumLege)
    integer,           intent(in)  :: n
    complex(kind=dbl), intent(in)  :: sumLege1(4,n)
    complex(kind=dbl), intent(out) :: sumLege(n,4)
    
    sumLege = transpose( sumLege1 )
    
  end subroutine pmj4_transpose_sub
  
end submodule legep