submodule (sphvectors) xyz
  implicit none; contains
  
  module procedure vecxyz2zonvecrtp_sub
    integer        :: iph, ith
    real(kind=dbl) :: cphi, sphi, ctht, stht
    
    do ith = 0, nth
      vrtp(:,ith) = zero
      
      ctht = cos(ith*pi/nth)
      stht = sin(ith*pi/nth)
      
      do iph = 1, 2*nth
        cphi = cos((iph-1)*pi/nth)
        sphi = sin((iph-1)*pi/nth)
        
        vrtp(1,ith) = vrtp(1,ith) + vxyz(1,iph,ith) * cphi * stht + vxyz(2,iph,ith) * sphi * stht + vxyz(3,iph,ith) * ctht
        vrtp(2,ith) = vrtp(2,ith) + vxyz(1,iph,ith) * cphi * ctht + vxyz(2,iph,ith) * sphi * ctht - vxyz(3,iph,ith) * stht
        vrtp(3,ith) = vrtp(3,ith) - vxyz(1,iph,ith) * sphi        + vxyz(2,iph,ith) * cphi
      end do
      
      vrtp(:,ith) = vrtp(:,ith) / (2*nth)
    end do
    
  end procedure vecxyz2zonvecrtp_sub
  
  module procedure vecxyz2vecrtp_sub
    integer        :: iph, ith
    real(kind=dbl) :: cphi, sphi, ctht, stht
    
    do ith = 0, nth
      ctht = cos(ith*pi/nth)
      stht = sin(ith*pi/nth)
      
      do iph = 1, 2*nth
        cphi = cos((iph-1)*pi/nth)
        sphi = sin((iph-1)*pi/nth)
        
        vrtp(1,iph,ith) = + vxyz(1,iph,ith) * cphi * stht + vxyz(2,iph,ith) * sphi * stht + vxyz(3,iph,ith) * ctht
        vrtp(2,iph,ith) = + vxyz(1,iph,ith) * cphi * ctht + vxyz(2,iph,ith) * sphi * ctht - vxyz(3,iph,ith) * stht
        vrtp(3,iph,ith) = - vxyz(1,iph,ith) * sphi        + vxyz(2,iph,ith) * cphi
      end do
    end do
    
  end procedure vecxyz2vecrtp_sub
  
end submodule xyz