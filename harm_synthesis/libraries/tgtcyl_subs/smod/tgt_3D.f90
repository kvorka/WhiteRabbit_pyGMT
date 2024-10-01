submodule (tgt_cylinder) tgt_3D
  implicit none; contains
  
  module subroutine print_tgtcylinder_3d_sub()
    integer             :: ir, ith, iph
    real(kind=dbl)      :: r1, r, r_dim, stheta
    
    r1 = r_ud_ocean / (1 - r_ud_ocean)
    
    open(unit=8, file='tgt.dat', status='new', action='write')
      
      do ir = 1, n_out
        r     = r1 + (ir-one)/(n_out-one)
        r_dim = (r_out-r_in) * r + (r_in - r_ud_ocean * r_out) / (1-r_ud_ocean)
        
        do ith = 0, nth
          stheta = sin( ith * (pi / nth) )
          
          if ( stheta >= r_ud_ocean-0.01_dbl ) then
            r     = r1 / stheta
            r_dim = (r_out-r_in) * r + (r_in - r_ud_ocean * r_out) / (1-r_ud_ocean)
            
            write(8,*) r_dim, ith * (180._dbl / nth )
          end if
        end do
      end do
      
    close(8)
    
  end subroutine print_tgtcylinder_3d_sub
  
end submodule tgt_3D