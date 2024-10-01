submodule (Loadsave) subs_2D
  implicit none; contains
  
  module subroutine load_spectra_2d_sub(filein, dimjms, spectra)
    character(len=*),  intent(in)  :: filein
    integer,           intent(in)  :: dimjms
    complex(kind=dbl), intent(out) :: spectra(dimjms)
    integer                        :: ijm, error
    complex(kind=dbl)              :: valjm
    
    open(unit=1, file=filein, status='old', action='read')
      
      do
        read(1,*,iostat=error) ijm, valjm
        
        if (error /= 0) then
          exit
        else
          spectra(ijm) = valjm
        end if
      end do
      
    close(1)
    
  end subroutine load_spectra_2d_sub
  
  module subroutine save_data_2d_sub(file_range, file_data, grddata, eqsim)
    character(len=*), intent(in) :: file_range, file_data
    real(kind=dbl),   intent(in) :: grddata(2*nth,0:nth)
    character,        intent(in) :: eqsim
    integer                      :: iph, ith
    
    open(unit=8, file=file_data, status='new', action='write')
      do ith = 0, 180
        do iph = 1, 360
          write(8,*) iph, ith-90, grddata(iph,ith)
        end do
      end do
    close(8)
    
    open(unit=8, file=file_range, status='new', action='write')
      write(8,*) maxval(grddata)
      write(8,*) minval(grddata)
    close(8)
    
  end subroutine save_data_2d_sub
  
end submodule subs_2D