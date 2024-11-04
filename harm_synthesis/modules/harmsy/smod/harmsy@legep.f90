submodule (harmsy) legep
  implicit none; contains
  
  module procedure pmj_set0_sub
    
    ctheta = cos(it*pi/nth)
    stheta = sin(it*pi/nth)
    
  end procedure pmj_set0_sub
  
  module procedure pmj_set_sub
    
    if ( im > 0 ) then
      p0j = p0j * cmm(im) * stheta
    else
      p0j = 1 / sq4pi
    end if
    
    pmj2 = zero
    pmj1 = zero
    pmj  = p0j
    
  end procedure pmj_set_sub
  
  module procedure pmj_recursion_sub
    
    pmj2 = pmj1
    pmj1 = pmj
    pmj  = amj(imj) * ctheta * pmj1 - bmj(imj) * pmj2
    
  end procedure pmj_recursion_sub
  
  module procedure pmj_sum_sub
    integer :: in
    
    do concurrent ( in = 1:n )
      sumLege(in) = sumLege(in) + spectra(in) * pmj
    end do
    
  end procedure pmj_sum_sub
  
  module procedure pmj2_set0_sub
    integer :: i1
    
    do concurrent ( i1 = 1:2 )
      ctheta(i1) = cos((it+i1-1)*pi/nth)
      stheta(i1) = sin((it+i1-1)*pi/nth)
    end do
    
  end procedure pmj2_set0_sub
  
  module procedure pmj2_set_sub
    integer :: i1
    
    if ( im > 0 ) then
      do concurrent ( i1 = 1:2 )
        p0j(i1) = p0j(i1) * cmm(im) * stheta(i1)
      end do
    else
      do concurrent ( i1 = 1:2 )
        p0j(i1) = 1 / sq4pi
      end do
    end if
    
    do concurrent ( i1 = 1:2 )
      pmj2(i1) = zero
      pmj1(i1) = zero
      pmj(i1)  = p0j(i1)
    end do
    
  end procedure pmj2_set_sub
  
  module procedure pmj2_recursion_sub
    integer :: i1
    
    do concurrent ( i1 = 1:2 )
      pmj2(i1) = pmj1(i1)
      pmj1(i1) = pmj(i1)
      pmj(i1)  = amj(imj) * ctheta(i1) * pmj1(i1) - bmj(imj) * pmj2(i1)
    end do
    
  end procedure pmj2_recursion_sub
  
  module procedure pmj2_sum_sub
    integer :: i1, in
    
    do concurrent ( in = 1:n, i1 = 1:2 )
      sumLege(i1,in) = sumLege(i1,in) + spectra(in) * pmj(i1)
    end do
    
  end procedure pmj2_sum_sub
  
  module procedure pmj2_transpose_sub
    
    sumLege1 = transpose( sumL1 + sumL2 )
    sumLege2 = transpose( sumL1 - sumL2 )
    
  end procedure pmj2_transpose_sub
  
  module procedure pmj4_set0_sub
    integer :: i1
    
    do concurrent ( i1 = 1:4 )
      ctheta(i1) = cos((it+i1-1)*pi/nth)
      stheta(i1) = sin((it+i1-1)*pi/nth)
    end do
    
  end procedure pmj4_set0_sub
  
  module procedure pmj4_set_sub
    integer :: i1
    
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
    
  end procedure pmj4_set_sub
  
  module procedure pmj4_recursion_sub
    integer :: i1
    
    do concurrent ( i1 = 1:4 )
      pmj2(i1) = pmj1(i1)
      pmj1(i1) = pmj(i1)
      pmj(i1)  = amj(imj) * ctheta(i1) * pmj1(i1) - bmj(imj) * pmj2(i1)
    end do
    
  end procedure pmj4_recursion_sub
  
  module procedure pmj4_sum_sub
    integer :: i1, in
    
    do concurrent ( in = 1:n, i1 = 1:4 )
      sumLege(i1,in) = sumLege(i1,in) + spectra(in) * pmj(i1)
    end do
    
  end procedure pmj4_sum_sub
  
  module procedure pmj4_transpose_sub
    
    sumLege1 = transpose( sumL1 + sumL2 )
    sumLege2 = transpose( sumL1 - sumL2 )
    
  end procedure pmj4_transpose_sub
  
end submodule legep