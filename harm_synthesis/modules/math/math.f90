module math
  use memloc
  implicit none; public
  
  integer,           parameter :: nth   = 180
  real(kind=dbl),    parameter :: zero  = 0._dbl
  real(kind=dbl),    parameter :: one   = 1._dbl
  real(kind=dbl),    parameter :: sq2_1 = 1 / sqrt(2._dbl)
  real(kind=dbl),    parameter :: pi    = acos(-one)
  real(kind=dbl),    parameter :: sq4pi = sqrt(4*pi)
  complex(kind=dbl), parameter :: czero = cmplx(zero, zero, kind=dbl)
  complex(kind=dbl), parameter :: cunit = cmplx(zero, one , kind=dbl)
  complex(kind=dbl), parameter :: cone  = cmplx(one , zero, kind=dbl)
  
  real(kind=dbl), parameter :: r_ud_ocean = 0.90_dbl
  real(kind=dbl), parameter :: r_in  = 0._dbl
  real(kind=dbl), parameter :: r_out = 1._dbl
  integer,        parameter :: n_out = 101
  
  integer, parameter :: size_d = c_sizeof(zero)
  
  interface
    module subroutine alloc_aligned_sub( n, c_arr, f_arr )
      integer,                 intent(in)  :: n
      type(c_ptr),             intent(out) :: c_arr
      real(kind=dbl), pointer, intent(out) :: f_arr(:)
    end subroutine alloc_aligned_sub
  end interface
  
end module math