submodule (harmsy) harmsy1
  implicit none; contains
  
  module pure subroutine harmsy1_sub(jmax, spectra, gridvals)
    integer,           intent(in)  :: jmax
    complex(kind=dbl), intent(in)  :: spectra(*)
    real(kind=dbl),    intent(out) :: gridvals(2*nth,0:nth)
    integer                        :: it, ip, ij, im, ijm, imj, i1
    real(kind=dbl),    allocatable :: amj(:), bmj(:), cmm(:), &
                                    & p0j(:), pmj(:), pmj1(:), pmj2(:), &
                                    & costheta(:), sintheta(:)
    complex(kind=dbl)              :: expmul
    complex(kind=dbl), allocatable :: sumLege(:,:), expphi(:)
    
    !!**************************************************************************************!!
    !!* Allocation and initialization of arrays needed for transform. Legendre transform  **!!
    !!* is handled by the traditional recursion, while FFT is brutal force computation.   **!!
    !!**************************************************************************************!! 
    allocate( expphi(2*nth),            &
            & cmm(jmax),                &
            & amj((jmax+1)*(jmax+2)/2), &
            & bmj((jmax+1)*(jmax+2)/2)  )
    
    call init_lege_coeffs_sub( jmax, cmm(1), amj(1), bmj(1) )
    call init_fft_coeffs_sub( nth, expphi(1) )
    
    !!**************************************************************************************!!
    !!* Allocatation of temporal arrays, step is set to 4, everything is reused for spe-   *!!
    !!* cial case of north pole (a little unoptimized case).                               *!!
    !!**************************************************************************************!!
    allocate( sumLege(4,0:jmax),                &
            & p0j(4), pmj(4), pmj1(4), pmj2(4), &
            & costheta(4), sintheta(4)          )
    
    !!**************************************************************************************!!
    !!* A special case of the north pole: the north and the south pole have sintheta=0 and *!!
    !!* the polynomials are equal to zero exept those with m=0. Only a norht pole is trea- *!!
    !!* ted specially due to the vectorization purposes.                                   *!!
    !!**************************************************************************************!!
    it = 0
      costheta(1) = one
      
      im = 0
        p0j(1) = 1 / sq4pi
        
        pmj2(1) = zero
        pmj1(1) = zero
        pmj(1)  = p0j(1)
        
        ij = im
          sumLege(1,0) = spectra(1) * pmj(1)
        
        do ij = 1, jmax
          imj = ij+1
          ijm = ij*(ij+1)/2+1
          
          pmj2(1) = pmj1(1)
          pmj1(1) = pmj(1)
          pmj(1)  = amj(imj) * pmj1(1) - bmj(imj) * pmj2(1)
          
          sumLege(1,0) = sumLege(1,0) + spectra(ijm) * pmj(1)
        end do
        
      do ip = 1, 2*nth
        !im = 0
          gridvals(ip,it) = sumLege(1,0)%re
      end do
    
    !!**************************************************************************************!!
    !!* Main cycle over latitudes. As nth=180, 360, ..., vectorization is handled by com-  *!!
    !!* puting four latitudes at once. South pole included, as mod(nth-1,4) /= 0.          *!!
    !!**************************************************************************************!!
    do it = 1, nth, 4
      do concurrent ( i1 = 1:4 )
        costheta(i1) = cos((it+i1-1)*pi/nth)
        sintheta(i1) = sin((it+i1-1)*pi/nth)
      end do
      
      im = 0
        do concurrent ( i1 = 1:4 )
          p0j(i1) = 1 / sq4pi
        end do
        
        do concurrent ( i1 = 1:4 )
          pmj2(i1) = zero
          pmj1(i1) = zero
          pmj(i1)  = p0j(i1)
        end do
        
        ij = im
          do concurrent ( i1 = 1:4 )
            sumLege(i1,0) = spectra(1) * pmj(i1)
          end do
        
        do ij = 1, jmax
          imj = ij+1
          ijm = ij*(ij+1)/2+1
          
          do concurrent ( i1 = 1:4 )
            pmj2(i1) = pmj1(i1)
            pmj1(i1) = pmj(i1)
            pmj(i1)  = amj(imj) * costheta(i1) * pmj1(i1) - bmj(imj) * pmj2(i1)
          end do
          
          do concurrent ( i1 = 1:4 )
            sumLege(i1,0) = sumLege(i1,0) + spectra(ijm) * pmj(i1)
          end do
        end do
      
      do im = 1, jmax
        do concurrent ( i1 = 1:4 )
          p0j(i1) = p0j(i1) * cmm(im) * sintheta(i1)
        end do
        
        do concurrent ( i1 = 1:4 )
          pmj2(i1) = zero
          pmj1(i1) = zero
          pmj(i1)  = p0j(i1)
        end do
        
        ij = im
          ijm = ij*(ij+1)/2+im+1
          
          do concurrent ( i1 = 1:4 )
            sumLege(i1,im) = sumLege(i1,im) + spectra(ijm) * pmj(i1)
          end do
        
        do ij = im+1, jmax
          imj = im*(jmax+1)-im*(im+1)/2+ij+1
          ijm = ij*(ij+1)/2+im+1
          
          do concurrent ( i1 = 1:4 )
            pmj2(i1) = pmj1(i1)
            pmj1(i1) = pmj(i1)
            pmj(i1)  = amj(imj) * costheta(i1) * pmj1(i1) - bmj(imj) * pmj2(i1)
          end do
          
          do concurrent ( i1 = 1:4 )
            sumLege(i1,im) = sumLege(i1,im) + spectra(ijm) * pmj(i1)
          end do
        end do
      end do
      
      do ip = 1, 2*nth
        im = 0
          expmul = cone
          
          do concurrent ( i1=1:4 )
            gridvals(ip,it+i1-1) = sumLege(i1,0)%re
          end do
        
        do im = 1, jmax
          expmul = expmul * expphi(ip)
          
          do concurrent ( i1 = 1:4 )
            gridvals(ip,it+i1-1) = gridvals(ip,it+i1-1) + 2 * real( expmul * sumLege(i1,im) , kind=dbl )
          end do
        end do
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Cleaning after the computation.                                                    *!!
    !!**************************************************************************************!!
    deallocate( sumLege, expphi, cmm, amj, bmj )
    
  end subroutine harmsy1_sub
  
end submodule harmsy1