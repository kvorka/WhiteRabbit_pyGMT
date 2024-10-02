module vector_analysis
  use math
  implicit none; public; contains
  
  pure subroutine vec2scals_sub(jmax, vec, xyz)
    integer,           intent(in)  :: jmax
    complex(kind=dbl), intent(in)  :: vec(*)
    complex(kind=dbl), intent(out) :: xyz(3,*)
    integer                        :: s, j, m, l, jm, jml
    complex(kind=dbl)              :: sum1, sum2, sum3
    
    m = 0
      do j = m, jmax+1
        sum1 = czero
        sum2 = czero
        sum3 = czero
  
        s = +1
        do l = abs(j-1), min(jmax, j+1)
          s   = -s
          jml = 3*(l*(l+1)/2+m+1)+j-l
           
          sum1 = sum1 + s * conjg( vec(jml  ) ) * cleb1_fn(j,m,1,-1,l,m-1)
          sum3 = sum3 +            vec(jml-3)   * cleb1_fn(j,m,1, 0,l,m  )
          sum2 = sum2 +            vec(jml  )   * cleb1_fn(j,m,1,+1,l,m+1)
        end do
  
        jm = j*(j+1)/2+m+1
          xyz(1,jm) =          ( sum1 - sum2 ) * sq2_1
          xyz(2,jm) = -cunit * ( sum1 + sum2 ) * sq2_1
          xyz(3,jm) =          ( sum3        )
      end do
  
    do m = 1, jmax+1
      do j = m, jmax+1
        sum1 = czero
        sum2 = czero
        sum3 = czero
  
        do l = abs(j-1), min(jmax, j+1)
          if ( l > m ) then
            jml = 3*(l*(l+1)/2+m-1)+j-l
            
            sum1 = sum1 + vec(jml  ) * cleb1_fn(j,m,1,-1,l,m-1)
            sum3 = sum3 + vec(jml+3) * cleb1_fn(j,m,1, 0,l,m  )
            sum2 = sum2 + vec(jml+6) * cleb1_fn(j,m,1,+1,l,m+1)
          
          else if ( l == m ) then
            jml = 3*(l*(l+1)/2+m-1)+j-l
            
            sum1 = sum1 + vec(jml  ) * cleb1_fn(j,m,1,-1,l,m-1)
            sum3 = sum3 + vec(jml+3) * cleb1_fn(j,m,1, 0,l,m  )
          
          else
            jml = 3*(l*(l+1)/2+m-1)+j-l
            
            sum1 = sum1 + vec(jml) * cleb1_fn(j,m,1,-1,l,m-1)
          end if
        end do
  
        jm = j*(j+1)/2+m+1
          xyz(1,jm) =          ( sum1 - sum2 ) * sq2_1
          xyz(2,jm) = -cunit * ( sum1 + sum2 ) * sq2_1
          xyz(3,jm) =          ( sum3        )
      end do
    end do
  
  end subroutine vec2scals_sub
  
  pure subroutine vecxyz2zonvecrtp_sub(vxyz, vrtp)
    real(kind=dbl), intent(in)  :: vxyz(3,2*nth,0:nth)
    real(kind=dbl), intent(out) :: vrtp(3,0:nth)
    integer                     :: iph, ith
    real(kind=dbl)              :: cphi, sphi, ctht, stht
    
    do ith = 0, nth
      vrtp(:,ith) = zero
      
      ctht = cos(ith*pi/nth)
      stht = sin(ith*pi/nth)
      
      do iph = 1, 2*nth
        cphi = cos((iph-1)*pi/nth)
        sphi = sin((iph-1)*pi/nth)
        
        vrtp(1,ith) = vrtp(1,ith) + vxyz(1,iph,ith) * cphi * stht + vxyz(2,iph,ith) * sphi * stht + vxyz(3,iph,ith) * ctht
        vrtp(2,ith) = vrtp(2,ith) + vxyz(1,iph,ith) * cphi * ctht + vxyz(2,iph,ith) * sphi * ctht - vxyz(3,iph,ith) * stht
        vrtp(3,ith) = vrtp(3,ith) - vxyz(1,iph,ith) * sphi        + vxyz(2,iph,ith) * cphi
      end do
      
      vrtp(:,ith) = vrtp(:,ith) / (2*nth)
    end do
    
  end subroutine vecxyz2zonvecrtp_sub
  
  pure function cleb1_fn(j1, m1, j2, m2, j, m) result(cleb1)
    integer,       intent(in) :: j1, m1, j2, m2, j, m
    real(kind=dbl)            :: cleb1
    
    if ((j2 /= 1) .or. (abs(j1-j) > 1) .or. ((j1+j) == 0) .or. (abs(m2) > 1) .or. abs(m1) > j1) then
      cleb1 = zero
    
    else if (m2 == -1) then
      if (j1 == j-1) cleb1 = +sqrt((j-m-1._dbl)*(j-m       )/((2*j-1._dbl)*(  j       ))/2)
      if (j1 == j  ) cleb1 = +sqrt((j+m+1._dbl)*(j-m       )/((  j+1._dbl)*(  j       ))/2)
      if (j1 == j+1) cleb1 = +sqrt((j+m+2._dbl)*(j+m+1._dbl)/((  j+1._dbl)*(2*j+3._dbl))/2)
    
    else if (m2 == 0) then
      if (j1 == j-1) cleb1 = +sqrt((j+m       )*(j-m       )/ (2*j-1._dbl)/(  j       ))
      if (j1 == j  ) cleb1 = +sqrt((  m       )*(  m       )/ (  j+1._dbl)/(  j       ))
      if (j1 == j+1) cleb1 = -sqrt((j+m+1._dbl)*(j-m+1._dbl)/((  j+1._dbl)*(2*j+3._dbl)))
    
    else
      if (j1 == j-1) cleb1 = +sqrt((j+m-1._dbl)*(j+m       )/((2*j-1._dbl)*(  j       ))/2)
      if (j1 == j  ) cleb1 = -sqrt((j+m       )*(j-m+1._dbl)/((  j+1._dbl)*(  j       ))/2)
      if (j1 == j+1) cleb1 = +sqrt((j-m+1._dbl)*(j-m+2._dbl)/((  j+1._dbl)*(2*j+3._dbl))/2)
    end if
    
  end function cleb1_fn
  
end module vector_analysis