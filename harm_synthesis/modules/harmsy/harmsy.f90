module harmsy
  use math
  implicit none
  
  public :: harmsy1_sub
  public :: harmsy3_sub
  public :: harmsy4_sub
  
  private :: init_lege_coeffs_sub
  private :: init_fft_coeffs_sub
  
  interface
    module pure subroutine init_lege_coeffs_sub(jmax, cmm, amj, bmj)
      integer,        intent(in)  :: jmax
      real(kind=dbl), intent(out) :: amj(*), bmj(*), cmm(*)
    end subroutine init_lege_coeffs_sub
    
    module pure subroutine init_fft_coeffs_sub(ntheta, expphi)
      integer,           intent(in)  :: ntheta
      complex(kind=dbl), intent(out) :: expphi(*)
    end subroutine init_fft_coeffs_sub
    
    module pure subroutine harmsy1_sub(jmax, spectra, gridvals)
      integer,            intent(in)  :: jmax
      complex(kind=dbl),  intent(in)  :: spectra(*)
      real(kind=dbl),     intent(out) :: gridvals(2*nth,0:nth)
    end subroutine harmsy1_sub
    
    module pure subroutine harmsy3_sub(jmax, spectra, gridvals)
      integer,            intent(in)  :: jmax
      complex(kind=dbl),  intent(in)  :: spectra(3,*)
      real(kind=dbl),     intent(out) :: gridvals(3,2*nth,0:nth)
    end subroutine harmsy3_sub
    
    module pure subroutine harmsy4_sub(jmax, spectra, gridvals)
      integer,            intent(in)  :: jmax
      complex(kind=dbl),  intent(in)  :: spectra(4,*)
      real(kind=dbl),     intent(out) :: gridvals(4,2*nth,0:nth)
    end subroutine harmsy4_sub
  end interface
  
end module harmsy