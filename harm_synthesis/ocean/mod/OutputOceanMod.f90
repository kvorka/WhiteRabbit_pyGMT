module OutputOceanMod
  use Math
  use Harmsy
  use Vector_analysis
  implicit none; public
  
  real(kind=dbl), parameter :: r_ud_ocean = 0.85_dbl
  real(kind=dbl), parameter :: r_in  = 0._dbl
  real(kind=dbl), parameter :: r_out = 1._dbl
  integer,        parameter :: n_out = 101
  
  interface
  module subroutine load_spectra_sub(filein, dimjml, dimr, r, spectra)
    character(len=*),  intent(in)  :: filein
    integer,           intent(in)  :: dimjml, dimr
    real(kind=dbl),    intent(out) :: r(n_out)
    complex(kind=dbl), intent(out) :: spectra(dimjml,n_out)
    end subroutine load_spectra_sub
    
    module subroutine save_data_sub(file_range, file_data, r, grddata, eqsim)
      character(len=*), intent(in) :: file_range, file_data
      real(kind=dbl),   intent(in) :: r(n_out), grddata(0:nth,n_out)
      character,        intent(in) :: eqsim
    end subroutine save_data_sub
    
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
    
    module subroutine print_tgtcylinder_sub(surface)
      logical, intent(in) :: surface
    end subroutine print_tgtcylinder_sub
  end interface
  
end module OutputOceanMod
  
