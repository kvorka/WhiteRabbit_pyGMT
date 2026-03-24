submodule (harmsy) harmsy3
  implicit none; contains
  
  module procedure harmsy3_sub
    integer                              :: it, ip, ij, im, ijm, imj
    type(c_ptr)                          :: c_work
    real(kind=dbl), pointer, contiguous  :: work(:), p0j(:), pmj(:), pmj1(:), pmj2(:), sumLege(:,:,:)
    real(kind=dbl),          allocatable :: spectramj(:,:)
    complex(kind=dbl),       allocatable :: expmul(:)
    
    !!**************************************************************************************!!
    !!* Prepare output array.                                                              *!!
    !!**************************************************************************************!!
    do ip = 1, 2*nth
      !$omp simd
      do it = 1, nth
        gridvals(it,1,ip) = zero
        gridvals(it,2,ip) = zero
        gridvals(it,3,ip) = zero
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Prepare reordered input array and space for fft coeffs.                            *!!
    !!**************************************************************************************!!
    allocate( spectramj(6,jmax*(jmax+1)/2+jmax+1), expmul(2*nth) )
    
    do im = 0, jmax
      !$omp simd
      do ij = im, jmax
        ijm = ij*(ij+1)/2+im+1
        imj = im*(jmax+1)-im*(im+1)/2+ij+1
        
        spectramj(1,imj) = spectra(1,ijm)%re
        spectramj(2,imj) = spectra(2,ijm)%re
        spectramj(3,imj) = spectra(3,ijm)%re
        
        spectramj(4,imj) = spectra(1,ijm)%im
        spectramj(5,imj) = spectra(2,ijm)%im
        spectramj(6,imj) = spectra(3,ijm)%im
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Allocatation of temporal arrays for polynomials, partial sums and fft coeffs.      *!!
    !!**************************************************************************************!!
    call alloc_aligned_sub( 6*nth*(jmax+1)+4*nth, c_work, work )
    
    sumLege(1:nth,1:6,0:jmax) => work(                      1 : 6*nth*(jmax+1)       )
    p0j(1:nth)                => work( 6*nth*(jmax+1)+      1 : 6*nth*(jmax+1)  +nth )
    pmj(1:nth)                => work( 6*nth*(jmax+1)+  nth+1 : 6*nth*(jmax+1)+2*nth )
    pmj1(1:nth)               => work( 6*nth*(jmax+1)+2*nth+1 : 6*nth*(jmax+1)+3*nth )
    pmj2(1:nth)               => work( 6*nth*(jmax+1)+3*nth+1 : 6*nth*(jmax+1)+4*nth )
    
    !!**************************************************************************************!!
    !!* Sums of the associated Legendre polynomials. The outer sum is over the harmonic    *!!
    !!* orders, the inner sums over latitutes are vectorized with openmp.                  *!!
    !!**************************************************************************************!!
    do im = 0, jmax
      imj = im*(jmax+1)-im*(im+1)/2+im+1
      
      if ( im > 0 ) then
        !$omp simd aligned (p0j,pmj,pmj1,pmj2,sumLege:alig)
        do it = 1, nth
          p0j(it)  = p0j(it) * cmm(im) * sintheta(it)
          pmj2(it) = zero
          pmj1(it) = zero
          pmj(it) = p0j(it)
        
          sumLege(it,1,im) = spectramj(1,imj) * p0j(it)
          sumLege(it,2,im) = spectramj(2,imj) * p0j(it)
          sumLege(it,3,im) = spectramj(3,imj) * p0j(it)
          sumLege(it,4,im) = spectramj(4,imj) * p0j(it)
          sumLege(it,5,im) = spectramj(5,imj) * p0j(it)
          sumLege(it,6,im) = spectramj(6,imj) * p0j(it)
        end do
      else
        !$omp simd aligned (p0j,pmj,pmj1,pmj2,sumLege:alig)
        do it = 1, nth
          p0j(it)  = 1 / sq4pi
          pmj2(it) = zero
          pmj1(it) = zero
          pmj(it) = p0j(it)
        
          sumLege(it,1,im) = spectramj(1,imj) * p0j(it)
          sumLege(it,2,im) = spectramj(2,imj) * p0j(it)
          sumLege(it,3,im) = spectramj(3,imj) * p0j(it)
          sumLege(it,4,im) = spectramj(4,imj) * p0j(it)
          sumLege(it,5,im) = spectramj(5,imj) * p0j(it)
          sumLege(it,6,im) = spectramj(6,imj) * p0j(it)
        end do
      end if
      
      do ij = 1, jmax-im
        imj = imj + 1
        
        !$omp simd aligned (pmj,pmj1,pmj2,sumLege:alig)
        do it = 1, nth
          pmj2(it) = pmj1(it)
          pmj1(it) = pmj(it)
          pmj(it)  = amj(imj) * costheta(it) * pmj1(it) - bmj(imj) * pmj2(it)
          
          sumLege(it,1,im) = sumLege(it,1,im) + spectramj(1,imj) * pmj(it)
          sumLege(it,2,im) = sumLege(it,2,im) + spectramj(2,imj) * pmj(it)
          sumLege(it,3,im) = sumLege(it,3,im) + spectramj(3,imj) * pmj(it)
          sumLege(it,4,im) = sumLege(it,4,im) + spectramj(4,imj) * pmj(it)
          sumLege(it,5,im) = sumLege(it,5,im) + spectramj(5,imj) * pmj(it)
          sumLege(it,6,im) = sumLege(it,6,im) + spectramj(6,imj) * pmj(it)
        end do
      end do
      
      !$omp simd aligned (sumLege:alig)
      do it = 1, nth
        sumLege(it,1,im) = 2 * sumLege(it,1,im)
        sumLege(it,2,im) = 2 * sumLege(it,2,im)
        sumLege(it,3,im) = 2 * sumLege(it,3,im)
        sumLege(it,4,im) = 2 * sumLege(it,4,im)
        sumLege(it,5,im) = 2 * sumLege(it,5,im)
        sumLege(it,6,im) = 2 * sumLege(it,6,im)
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Brutal force FFT of order zero (only real part).                                   *!!
    !!**************************************************************************************!!
    im = 0
      do ip = 1, 2*nth
        !$omp simd aligned (sumLege:alig)
        do it = 1, nth
          gridvals(it,1,ip) = gridvals(it,1,ip) + sumLege(it,1,im)
          gridvals(it,2,ip) = gridvals(it,2,ip) + sumLege(it,2,im)
          gridvals(it,3,ip) = gridvals(it,3,ip) + sumLege(it,3,im)
        end do
      end do
    
    !!**************************************************************************************!!
    !!* Brutal force FFT of higher orders.                                                 *!!
    !!**************************************************************************************!!
    !$omp simd
    do ip = 1, 2*nth
      expmul(ip) = cone
    end do
    
    do im = 1, jmax
      !$omp simd
      do ip = 1, 2*nth
        expmul(ip) = expmul(ip) * expphi(ip)
      end do
      
      do ip = 1, 2*nth
        !$omp simd aligned (sumLege:alig)
        do it = 1, nth
          gridvals(it,1,ip) = gridvals(it,1,ip) + expmul(ip)%re * sumLege(it,1,im) - expmul(ip)%im * sumLege(it,4,im)
          gridvals(it,2,ip) = gridvals(it,2,ip) + expmul(ip)%re * sumLege(it,2,im) - expmul(ip)%im * sumLege(it,5,im)
          gridvals(it,3,ip) = gridvals(it,3,ip) + expmul(ip)%re * sumLege(it,3,im) - expmul(ip)%im * sumLege(it,6,im)
        end do
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Cleaning after the computation.                                                    *!!
    !!**************************************************************************************!!
    deallocate( expmul, spectramj )
    call free(c_work)
    
  end procedure harmsy3_sub
  
end submodule harmsy3