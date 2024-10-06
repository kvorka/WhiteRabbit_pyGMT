submodule (tgt_cylinder) subs_2d
  implicit none; contains
  
  module subroutine print_tgtcylinder_2d_sub()
    integer :: ir, ith, iph
    
    open(unit=8, file='tgt-n.dat', status='new', action='write')
      
      do iph = 1, 2*nth
        write(8,*) iph*180._dbl/nth,  acos(r_ud_ocean) / pi * 180
      end do

    close(8)
    
    open(unit=8, file='tgt-s.dat', status='new', action='write')
      
      do iph = 1, 2*nth
        write(8,*) iph*180._dbl/nth,  -acos(r_ud_ocean) / pi * 180
      end do
      
    close(8)
    
  end subroutine print_tgtcylinder_2d_sub
  
end submodule subs_2d