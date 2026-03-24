submodule (harmsy) init
  implicit none; contains
  
  module procedure init_harmsy_sub
    integer :: im, ij, imj, ip, it
    
    allocate( expphi(2*nth),            &
            & cmm(jmax),                &
            & amj((jmax+1)*(jmax+2)/2), &
            & bmj((jmax+1)*(jmax+2)/2), &
            & costheta(nth),            &
            & sintheta(nth)             )
    
    do concurrent ( im = 1:jmax )
      cmm(im) = -sqrt( (2*im+one) / (2*im) )
    end do
    
    do im = 0, jmax
      do ij = im+1, jmax
        imj = im*(jmax+1)-im*(im+1)/2+ij+1
        
        amj(imj) = sqrt( (2*ij-1) * (2*ij+one)                         / (            (ij-im) * (ij+im) ) )
        bmj(imj) = sqrt(            (2*ij+one) * (ij-im-1) * (ij+im-1) / ( (2*ij-3) * (ij-im) * (ij+im) ) )
      end do
    end do
    
    do concurrent ( ip = 1:2*ntheta )
      expphi(ip) = exp( cunit * (ip-1) * pi / ntheta )
    end do
    
    !$omp simd
    do it = 1, nth
      costheta(it) = cos( (it-1) * pi / (nth-1) )
      sintheta(it) = sin( (it-1) * pi / (nth-1) )
    end do
    
  end procedure init_harmsy_sub
  
  module procedure deallocate_harmsy_sub
    
    deallocate( amj, bmj, cmm, expphi, costheta, sintheta )
    
  end procedure deallocate_harmsy_sub
  
end submodule init