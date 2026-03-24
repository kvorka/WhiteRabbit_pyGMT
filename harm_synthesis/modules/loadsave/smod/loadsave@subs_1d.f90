submodule (loadsave) subs_1d
  implicit none; contains
  
  module procedure save_data_1d_sub
    integer :: iph, ith
    
    select case ( eqsim )
      case ('s')
        open(unit=8, file=file_data, status='new', action='write')
          do ith = 1, nth
            write(8,*) (ith-1)*180._dbl/(nth-1), sum( grddata(:,ith) + grddata(:,nth+1-ith) ) / 2 / (2*nth)
          end do
        close(8)
        
      case default
        open(unit=8, file=file_data, status='new', action='write')
          do ith = 1, nth
            write(8,*) (ith-1)*180._dbl/(nth-1), sum( grddata(:,ith) ) / (2*nth)
          end do
        close(8)
    end select
    
  end procedure save_data_1d_sub
  
end submodule subs_1d