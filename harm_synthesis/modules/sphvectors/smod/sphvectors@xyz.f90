submodule (sphvectors) xyz
  implicit none; contains
  
  module pure subroutine vecxyz2zonvecrtp_sub(vxyz, vrtp)
    real(kind=dbl), intent(in)  :: vxyz(3,2*nth,0:nth)
    real(kind=dbl), intent(out) :: vrtp(3,0:nth)
    integer                     :: iph, ith
    real(kind=dbl)              :: cphi, sphi, ctht, stht
    
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
    
  end subroutine vecxyz2zonvecrtp_sub
  
end submodule xyz