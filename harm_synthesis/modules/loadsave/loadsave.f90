module loadsave
  use math
  use constants
  implicit none

  interface
    module subroutine load_spectra_2d_sub(filein, dimjms, spectra)
      character(len=*),  intent(in)  :: filein
      integer,           intent(in)  :: dimjms
      complex(kind=dbl), intent(out) :: spectra(dimjms)
    end subroutine load_spectra_2d_sub
    
    module subroutine save_data_2d_sub(file_range, file_data, grddata, eqsim)
      character(len=*), intent(in) :: file_range, file_data
      real(kind=dbl),   intent(in) :: grddata(2*nth,0:nth)
      character,        intent(in) :: eqsim
    end subroutine save_data_2d_sub
    
    module subroutine load_spectra_3d_sub(filein, dimjml, dimr, r, spectra)
      character(len=*),  intent(in)  :: filein
      integer,           intent(in)  :: dimjml, dimr
      real(kind=dbl),    intent(out) :: r(n_out)
      complex(kind=dbl), intent(out) :: spectra(dimjml,n_out)
    end subroutine load_spectra_3d_sub
    
    module subroutine save_data_3d_sub(file_range, file_data, r, grddata, eqsim)
      character(len=*), intent(in) :: file_range, file_data
      real(kind=dbl),   intent(in) :: r(n_out), grddata(0:nth,n_out)
      character,        intent(in) :: eqsim
    end subroutine save_data_3d_sub
  end interface
  
end module loadsave