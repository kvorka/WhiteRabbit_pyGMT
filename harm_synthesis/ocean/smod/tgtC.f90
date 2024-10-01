submodule(OutputOceanMod) tgtC
  implicit none; contains
  
  module subroutine print_tgtcylinder_sub(surface)
    logical, intent(in) :: surface
    integer             :: ir, ith, iph
    real(kind=dbl)      :: r1, r, r_dim, stheta
    
    if (surface) then
      open(unit=8, file='tgt-n.dat', status='new', action='write')
        do iph = 1, 2*nth
          write(8,*) iph,  acos(r_ud_ocean) / pi * 180
        end do
      close(8)
      
      open(unit=8, file='tgt-s.dat', status='new', action='write')
        do iph = 1, 2*nth
          write(8,*) iph,  -acos(r_ud_ocean) / pi * 180
        end do
      close(8)
      
    else
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
    end if
    
  end subroutine print_tgtcylinder_sub
  
end submodule tgtC