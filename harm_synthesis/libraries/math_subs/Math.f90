module Math
  use iso_fortran_env, only: real64
  implicit none; public
  
  integer,           parameter :: dbl   = real64
  integer,           parameter :: nth   = 180
  real(kind=dbl),    parameter :: zero  = 0._dbl
  real(kind=dbl),    parameter :: one   = 1._dbl
  real(kind=dbl),    parameter :: sq2_1 = 1 / sqrt(2._dbl)
  real(kind=dbl),    parameter :: pi    = acos(-one)
  real(kind=dbl),    parameter :: sq4pi = sqrt(4*pi)
  complex(kind=dbl), parameter :: czero = cmplx(zero, zero, kind=dbl)
  complex(kind=dbl), parameter :: cunit = cmplx(zero, one , kind=dbl)
  complex(kind=dbl), parameter :: cone  = cmplx(one , zero, kind=dbl)
  
end module Math