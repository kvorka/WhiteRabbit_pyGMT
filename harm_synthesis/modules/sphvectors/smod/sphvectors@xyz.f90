submodule (sphvectors) xyz
  implicit none; contains
  
  module procedure vecxyz2zonvecrtp_sub
    integer        :: i1, iph, ith
    real(kind=dbl) :: cphi, sphi, ctht, stht
    
    !$omp simd
    do ith = 1, nth
      vrtp(ith,1) = zero
      vrtp(ith,2) = zero
      vrtp(ith,3) = zero
    end do
    
    do iph = 1, 2*nth
      cphi = cos((iph-1)*pi/nth)
      sphi = sin((iph-1)*pi/nth)
      
      !$omp simd
      do ith = 1, nth
        ctht = cos( (ith-1) *pi / (nth-1) )
        stht = sin( (ith-1) *pi / (nth-1) )
          
        vrtp(ith,1) = vrtp(ith,1) + vxyz(ith,1,iph) * cphi * stht + vxyz(ith,2,iph) * sphi * stht + vxyz(ith,3,iph) * ctht
        vrtp(ith,2) = vrtp(ith,2) + vxyz(ith,1,iph) * cphi * ctht + vxyz(ith,2,iph) * sphi * ctht - vxyz(ith,3,iph) * stht
        vrtp(ith,3) = vrtp(ith,3) - vxyz(ith,1,iph) * sphi        + vxyz(ith,2,iph) * cphi
      end do
    end do
    
    !$omp simd
    do ith = 1, nth
      vrtp(ith,1) = vrtp(ith,1) / (2*nth)
      vrtp(ith,2) = vrtp(ith,2) / (2*nth)
      vrtp(ith,3) = vrtp(ith,3) / (2*nth)
    end do
    
  end procedure vecxyz2zonvecrtp_sub
  
  module procedure vecxyz2vecrtp_sub
    integer        :: iph, ith
    real(kind=dbl) :: cphi, sphi, ctht, stht
    
    do ith = 1, nth
      ctht = cos( (ith-1) *pi / (nth-1) )
      stht = sin( (ith-1) *pi / (nth-1) )
      
      do iph = 1, 2*nth
        cphi = cos((iph-1)*pi/nth)
        sphi = sin((iph-1)*pi/nth)
        
        vrtp(iph,ith,1) = + vxyz(ith,1,iph) * cphi * stht + vxyz(ith,2,iph) * sphi * stht + vxyz(ith,3,iph) * ctht
        vrtp(iph,ith,2) = + vxyz(ith,1,iph) * cphi * ctht + vxyz(ith,2,iph) * sphi * ctht - vxyz(ith,3,iph) * stht
        vrtp(iph,ith,3) = - vxyz(ith,1,iph) * sphi        + vxyz(ith,2,iph) * cphi
      end do
    end do
    
  end procedure vecxyz2vecrtp_sub
  
end submodule xyz