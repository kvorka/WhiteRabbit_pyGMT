module OutputOceanMod
  use Math
  use Constants
  use Harmsy
  use Vector_analysis
  use Loadsave
  implicit none; public
  
  interface
    module subroutine harm_analysis_flux_sub(filein, jmax, identifier)
      character(len=*), intent(in) :: filein, identifier
      integer,          intent(in) :: jmax
    end subroutine harm_analysis_flux_sub
    
    module subroutine harm_analysis_temp_sub(filein, nd, jmax, identifier)
      character(len=*), intent(in) :: filein, identifier
      integer,          intent(in) :: nd, jmax
    end subroutine harm_analysis_temp_sub
    
    module subroutine harm_analysis_velc_sub(filein, nd, jmax, fac, identifier)
      character(len=*), intent(in) :: filein, identifier
      integer,          intent(in) :: nd, jmax
      real(kind=dbl),   intent(in) :: fac
    end subroutine harm_analysis_velc_sub
  end interface
  
end module OutputOceanMod
  
