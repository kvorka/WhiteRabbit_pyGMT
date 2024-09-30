module Math
  use iso_fortran_env, only: real64
  implicit none; public
  
  integer,           parameter :: dbl   = real64
  integer,           parameter :: nth = 180
  real(kind=dbl),    parameter :: zero  = 0._dbl
  real(kind=dbl),    parameter :: one   = 1._dbl
  real(kind=dbl),    parameter :: sq2_1 = 1 / sqrt(2._dbl)
  real(kind=dbl),    parameter :: pi    = acos(-one)
  complex(kind=dbl), parameter :: czero = cmplx(zero, zero, kind=dbl)
  complex(kind=dbl), parameter :: cunit = cmplx(zero, one , kind=dbl)
  complex(kind=dbl), parameter :: cone  = cmplx(one , zero, kind=dbl)
  
  contains
  
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
  
end module Math