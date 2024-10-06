submodule (loadsave) subs_1d
  implicit none; contains
  
  module subroutine save_data_1d_sub(file_data, grddata, eqsim)
    character(len=*), intent(in) :: file_data
    real(kind=dbl),   intent(in) :: grddata(2*nth,0:nth)
    character,        intent(in) :: eqsim
    integer                      :: iph, ith
    
    select case ( eqsim )
      case ('s')
        open(unit=8, file=file_data, status='new', action='write')
          do ith = 0, nth
            write(8,*) ith*180._dbl/nth-90, 1+sum( grddata(:,ith) + grddata(:,nth-ith) ) / 2 / (2*nth)
          end do
        close(8)
        
      case default
        open(unit=8, file=file_data, status='new', action='write')
          do ith = 0, nth
            write(8,*) ith*180._dbl/nth-90, 1+sum( grddata(:,ith) ) / (2*nth)
          end do
        close(8)
    end select
    
  end subroutine save_data_1d_sub
  
end submodule subs_1d