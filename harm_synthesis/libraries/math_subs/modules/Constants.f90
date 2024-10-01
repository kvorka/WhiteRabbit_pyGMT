module Constants
  use Math
  implicit none
  
  real(kind=dbl), parameter :: r_ud_ocean = 0.80_dbl
  real(kind=dbl), parameter :: r_in  = 0._dbl
  real(kind=dbl), parameter :: r_out = 1._dbl
  integer,        parameter :: n_out = 101
  
end module Constants