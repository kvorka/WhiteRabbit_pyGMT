submodule (sphvectors) vec2scals
  implicit none; contains
  
  module pure subroutine vec2scals_sub(jmax, vec, xyz)
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
  
end submodule vec2scals