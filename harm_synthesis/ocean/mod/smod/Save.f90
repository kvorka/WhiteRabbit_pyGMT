submodule(OutputOceanMod) Save
  implicit none; contains
  
  module subroutine save_data_sub(file_range, file_data, r, grddata, eqsim)
    character(len=*), intent(in) :: file_range, file_data
    real(kind=dbl),   intent(in) :: r(n_out), grddata(0:nth,n_out)
    character,        intent(in) :: eqsim
    integer                      :: ith, ir
    real(kind=dbl)               :: dhelp, dmax, dmin, r_dim
    
    dmax = zero
    dmin = huge(zero)
    
    open(unit=8, file=file_data, status='new', action='write')
      do ir = 1, n_out
        r_dim = (r_out-r_in) * r(ir) + (r_in - r_ud_ocean * r_out) / (1-r_ud_ocean)
        
        do ith = 0, nth
          if ( eqsim == 's' ) then
            dhelp = ( grddata(ith,ir) + grddata(nth-ith,ir) ) / 2
          else if ( eqsim == 'a' ) then
            dhelp = ( grddata(ith,ir) - grddata(nth-ith,ir) ) / 2
          else
            dhelp = grddata(ith,ir)
          end if
          
          dmax = max(dmax, dhelp)
          dmin = min(dmin, dhelp)
          
          write(8,'(3F15.7)') r_dim, ith*180._dbl/nth, dhelp
        end do
      end do
    close(8)
    
    open(unit=8, file=file_range, status='new', action='write')
      write(8,*) dmin
      write(8,*) dmax
    close(8)
    
  end subroutine save_data_sub
  
end submodule Save