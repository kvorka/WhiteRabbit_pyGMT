submodule (loadsave) subs_2D
  implicit none; contains
  
  module procedure load_spectra_2d_sub
    integer           :: ijm, error
    complex(kind=dbl) :: valjm
    
    open(unit=1, file=filein, status='old', action='read')
      
      do
        read(1,*,iostat=error) ijm, valjm
        
        if ( (error /= 0) .or. (ijm > dimjms) ) then
          exit
        else
          spectra(ijm) = valjm
        end if
      end do
      
    close(1)
    
  end procedure load_spectra_2d_sub
  
  module procedure save_data_2d_sub
    integer        :: iph, ith
    real(kind=dbl) :: val
    
    if (eqsim == 'n') then
      open(unit=8, file=file_data, status='new', action='write')
        do ith = 0, nth
          do iph = 1, 2*nth
            write(8,*) iph*180._dbl/nth, 90-ith*180._dbl/nth, grddata(iph,ith)
          end do
        end do
      close(8)
      
    else
      open(unit=8, file=file_data, status='new', action='write')
        do ith = 0, nth
          val = sum( grddata(:,ith) ) / (2*nth-1)
          do iph = 1, 2*nth
            write(8,*) iph*180._dbl/nth, 90-ith*180._dbl/nth, val
          end do
        end do
      close(8)
    end if
    
    open(unit=8, file=file_range, status='new', action='write')
      write(8,*) maxval(grddata)
      write(8,*) minval(grddata)
    close(8)
    
  end procedure save_data_2d_sub
  
end submodule subs_2D