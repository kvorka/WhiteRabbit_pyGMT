submodule (loadsave) subs_2D
  implicit none; contains
  
  module procedure load_spectra_2d_sub
    integer           :: ijm, ij, im, error
    complex(kind=dbl) :: valjm
    
    open(unit=1, file=filein, status='old', action='read')
      
      do
        read(1,*,iostat=error) ij, im, valjm !ijm, valjm
        
        ijm = ij*(ij+1)/2+im+1
        
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
            write(8,'(3f8.3)') iph*180._dbl/nth, 90-ith*180._dbl/nth, grddata(iph,ith)
          end do
        end do
      close(8)
      
    else if (eqsim == 's') then
      open(unit=8, file=file_data, status='new', action='write')
        do ith = 0, nth
          !val = sum( grddata(:,ith)+ grddata(:,nth-ith)) / 2 / (2*nth-1)
          do iph = 1, 2*nth
            write(8,*) iph*180._dbl/nth, 90-ith*180._dbl/nth, (grddata(iph,ith)+ grddata(iph,nth-ith)) / 2
          end do
        end do
      close(8)
    
    else if (eqsim == 'a') then
      open(unit=8, file=file_data, status='new', action='write')
        do ith = 0, nth
          !val = sum( grddata(:,ith)-grddata(:,nth-ith)) / 2 / (2*nth-1)
          do iph = 1, 2*nth
            val = grddata(iph,ith)
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