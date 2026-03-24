submodule (harmsy) harmsy1
  implicit none; contains
  
  module procedure harmsy_sub
    integer                        :: it, ip, ij, im, in, ijm, imj, i1
    real(kind=dbl),    allocatable :: p0j(:), pmj(:), pmj1(:), pmj2(:), costheta(:), sintheta(:)
    complex(kind=dbl), allocatable :: sumLege(:,:,:), expmul(:), spectramj(:,:)
    
    !!**************************************************************************************!!
    !!* Prepare output array.                                                              *!!
    !!**************************************************************************************!!
    do ip = 1, 2*nth
      do in = 1, n
        !$omp simd
        do it = 1, nth
          gridvals(it,in,ip) = zero
        end do
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Allocatation of temporal arrays, step is set to 4, everything is reused for lower  *!!
    !!* stepping and a  case of equator (a little unoptimized).                            *!!
    !!**************************************************************************************!!
    allocate( sumLege(nth,n,0:jmax), p0j(nth), pmj(nth), pmj1(nth), pmj2(nth), costheta(nth), sintheta(nth), &
            & expmul(2*nth), spectramj(n,jmax*(jmax+1)/2+jmax+1)                                             )
    
    do im = 0, jmax
      do ij = im, jmax
        ijm = ij*(ij+1)/2+im+1
        imj = im*(jmax+1)-im*(im+1)/2+ij+1
        
        !$omp simd
        do in = 1, n
          spectramj(in,imj) = spectra(in,ijm)
        end do
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Main cycle over latitudes. As nth=180, 360, ..., vectorization is handled by com-  *!!
    !!* puting 4 latitudes at once.                                                        *!!
    !!**************************************************************************************!!
    !$omp simd
    do it = 1, nth
      costheta(it) = cos( (it-1) * pi / (nth-1) )
      sintheta(it) = sin( (it-1) * pi / (nth-1) )
    end do
    
    do im = 0, jmax
      imj = im*(jmax+1)-im*(im+1)/2+im+1
      
      if ( im > 0 ) then
        !$omp simd
        do it = 1, nth
          p0j(it)  = p0j(it) * cmm(im) * sintheta(it)
          pmj2(it) = zero
          pmj1(it) = zero
        end do
      else
        !$omp simd
        do it = 1, nth
          p0j(it)  = 1 / sq4pi
          pmj2(it) = zero
          pmj1(it) = zero
        end do
      end if
      
      !$omp simd
      do it = 1, nth
        pmj(it) = p0j(it)
      end do
      
      do in = 1, n
        !$omp simd
        do it = 1, nth
          sumLege(it,in,im) = spectramj(in,imj) * pmj(it)
        end do
      end do
      
      do ij = 1, jmax-im
        imj = imj + 1
        
        !$omp simd
        do it = 1, nth
          pmj2(it) = pmj1(it)
          pmj1(it) = pmj(it)
          pmj(it)  = amj(imj) * costheta(it) * pmj1(it) - bmj(imj) * pmj2(it)
        end do
        
        do in = 1, n
          !$omp simd
          do it = 1, nth
            sumLege(it,in,im) = sumLege(it,in,im) + spectramj(in,imj) * pmj(it)
          end do
        end do
      end do
      
      !$omp simd collapse (2)
      do in = 1, n
        do it = 1, nth
          sumLege(it,in,im) = 2 * sumLege(it,in,im)
        end do
      end do
    end do
    
    im = 0
      !$omp simd
      do ip = 1, 2*nth
        expmul(ip) = cone
      end do
      
      !$omp simd collapse (3)
      do ip = 1, 2*nth
        do in = 1, n
          do it = 1, nth
            gridvals(it,in,ip) = gridvals(it,in,ip) + sumLege(it,in,im)%re
          end do
        end do
      end do
    
    do im = 1, jmax
      !$omp simd
      do ip = 1, 2*nth
        expmul(ip) = expmul(ip) * expphi(ip)
      end do
      
      !$omp simd collapse (3)
      do ip = 1, 2*nth
        do in = 1, n
          do it = 1, nth
            gridvals(it,in,ip) = gridvals(it,in,ip) + expmul(ip)%re * sumLege(it,in,im)%re - expmul(ip)%im * sumLege(it,in,im)%im
          end do
        end do
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Cleaning after the computation.                                                    *!!
    !!**************************************************************************************!!
    deallocate( sumLege, p0j, pmj, pmj1, pmj2, costheta, sintheta, expmul, spectramj )
    
  end procedure harmsy_sub
  
end submodule harmsy1