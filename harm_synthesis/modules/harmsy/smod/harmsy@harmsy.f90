submodule (harmsy) harmsy
  implicit none; contains
  
  module pure subroutine harmsy_sub(jmax, n, spectra, gridvals)
    integer,           intent(in)  :: jmax, n
    complex(kind=dbl), intent(in)  :: spectra(n,*)
    real(kind=dbl),    intent(out) :: gridvals(n,2*nth,0:nth)
    integer                        :: it, ip, ij, im, in, ijm, imj
    real(kind=dbl),    allocatable :: p0j(:), pmj(:), pmj1(:), pmj2(:), costheta(:), sintheta(:)
    complex(kind=dbl), allocatable :: sumLege1(:), sumLege2(:), sumL1(:), sumL2(:), facexp(:), spectramj(:,:)
    
    !!**************************************************************************************!!
    !!* Prepare output array.                                                              *!!
    !!**************************************************************************************!!
    do concurrent ( it = 0:nth, ip = 1:2*nth, in = 1:n )
      gridvals(in,ip,it) = zero
    end do
    
    !!**************************************************************************************!!
    !!* Allocatation of temporal arrays, step is set to 4, everything is reused for lower  *!!
    !!* stepping and a  case of equator (a little unoptimized).                            *!!
    !!**************************************************************************************!!
    allocate( sumLege1(4*n*(jmax+1)), sumL1(4*n), &
            & sumLege2(4*n*(jmax+1)), sumL2(4*n), &
            & p0j(4), pmj(4), pmj1(4), pmj2(4),   &
            & costheta(4), sintheta(4),           &
            & facexp(2*nth),                      &
            & spectramj(n,jmax*(jmax+1)/2+jmax+1) )
    
    do im = 0, jmax
      do ij = im, jmax
        ijm = ij*(ij+1)/2+im+1
        imj = im*(jmax+1)-im*(im+1)/2+ij+1
        
        do concurrent ( in = 1:n )
          spectramj(in,imj) = spectra(in,ijm)
        end do
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Main cycle over latitudes. As nth=180, 360, ..., vectorization is handled by com-  *!!
    !!* puting many latitudes at once. Equator is handled separately.                      *!!
    !!**************************************************************************************!!
    do it = 0, ( (nth/2) / 4 ) * 4 - 1, 4
      call pmj4_set0_sub( it, costheta(1), sintheta(1) )
      
      do im = 0, jmax
        do concurrent ( in = 1:4*n)
          sumL1(in) = czero
          sumL2(in) = czero
        end do
        
        imj = im*(jmax+1)-im*(im+1)/2+im+1
          call pmj4_set_sub( im, sintheta(1), p0j(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj4_sum_sub( n, pmj, sumL1(1), spectramj(1,imj))
        
        do ij = 1, (jmax-im)/2
          imj = imj + 2
          
          call pmj4_recursion_sub( imj-1, costheta(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj4_sum_sub( n, pmj, sumL2(1), spectramj(1,imj-1))
          
          call pmj4_recursion_sub( imj, costheta(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj4_sum_sub( n, pmj, sumL1(1), spectramj(1,imj))
        end do
        
        if ( mod(jmax-im,2) /= 0 ) then
          call pmj4_recursion_sub( imj+1, costheta(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj4_sum_sub( n, pmj, sumL2(1), spectramj(1,imj+1))
        end if
        
        call pmj4_transpose_sub( n, sumL1(1), sumL2(1), sumLege1(1+4*n*im), sumLege2(1+4*n*im) )
      end do
      
      im = 0
        facexp = cone / 2
        call fourtrans4_sum_sub( n, facexp(1), sumLege1(1), gridvals(1,1,it),      &
                               &               sumLege2(1), gridvals(1,1,nth-it-3) )
      
      im = 1
        facexp = expphi
        call fourtrans4_sum_sub( n, facexp(1), sumLege1(1+4*n), gridvals(1,1,it),      &
                               &               sumLege2(1+4*n), gridvals(1,1,nth-it-3) )
        
      do im = 2, jmax
        facexp = facexp * expphi
        call fourtrans4_sum_sub( n, facexp(1), sumLege1(1+4*n*im), gridvals(1,1,it),      &
                               &               sumLege2(1+4*n*im), gridvals(1,1,nth-it-3) )
      end do
    end do
    
    do it = ( (nth/2) / 4 ) * 4, nth/2 - 1, 2
      call pmj2_set0_sub( it, costheta(1), sintheta(1) )
      
      do im = 0, jmax
        do concurrent ( in = 1:2*n)
          sumL1(in) = czero
          sumL2(in) = czero
        end do
        
        imj = im*(jmax+1)-im*(im+1)/2+im+1
          call pmj2_set_sub( im, sintheta(1), p0j(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj2_sum_sub( n, pmj, sumL1(1), spectramj(1,imj))
          
          do ij = 1, (jmax-im)/2
            imj = imj + 2
            
            call pmj2_recursion_sub( imj-1, costheta(1), pmj(1), pmj1(1), pmj2(1) )
            call pmj2_sum_sub( n, pmj, sumL2(1), spectramj(1,imj-1))
            
            call pmj2_recursion_sub( imj, costheta(1), pmj(1), pmj1(1), pmj2(1) )
            call pmj2_sum_sub( n, pmj, sumL1(1), spectramj(1,imj))
          end do
          
          if ( mod(jmax-im,2) /= 0 ) then
            call pmj2_recursion_sub( imj+1, costheta(1), pmj(1), pmj1(1), pmj2(1) )
            call pmj2_sum_sub( n, pmj, sumL2(1), spectramj(1,imj+1))
          end if
        
        call pmj2_transpose_sub( n, sumL1(1), sumL2(1), sumLege1(1+2*n*im), sumLege2(1+2*n*im) )
      end do
      
      im = 0
        facexp = cone / 2
        call fourtrans2_sum_sub( n, facexp(1), sumLege1(1), gridvals(1,1,it),      &
                               &               sumLege2(1), gridvals(1,1,nth-it-1) )
      
      im = 1
        facexp = expphi
        call fourtrans2_sum_sub( n, facexp(1), sumLege1(1+2*n), gridvals(1,1,it),      &
                               &               sumLege2(1+2*n), gridvals(1,1,nth-it-1) )
        
      do im = 2, jmax
        facexp = facexp * expphi
        call fourtrans2_sum_sub( n, facexp(1), sumLege1(1+2*n*im), gridvals(1,1,it),      &
                               &               sumLege2(1+2*n*im), gridvals(1,1,nth-it-1) )
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Equator                                                                            *!!
    !!**************************************************************************************!!
    it = nth/2
      call pmj_set0_sub( it, costheta(1), sintheta(1) )
      
      do im = 0, jmax
        do concurrent ( in = 1:n)
          sumLege1(in+n*im) = czero
        end do
        
        imj = im*(jmax+1)-im*(im+1)/2+im+1
          call pmj_set_sub( im, sintheta(1), p0j(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj_sum_sub( n, pmj(1), sumLege1(1+n*im), spectramj(1,imj))
        
        do ij = im+1, jmax
          imj = imj + 1
          
          call pmj_recursion_sub( imj, costheta(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj_sum_sub( n, pmj(1), sumLege1(1+n*im), spectramj(1,imj))
        end do
      end do
      
      im = 0
        facexp = cone / 2
        call fourtrans_sum_sub( n, facexp(1), sumLege1(1), gridvals(1,1,it) )
      
      im = 1
        facexp = expphi
        call fourtrans_sum_sub( n, facexp(1), sumLege1(1+n), gridvals(1,1,it) )
        
      do im = 2, jmax
        facexp = facexp * expphi
        call fourtrans_sum_sub( n, facexp(1), sumLege1(1+n*im), gridvals(1,1,it) )
      end do
    
    !!**************************************************************************************!!
    !!* Cleaning after the computation.                                                    *!!
    !!**************************************************************************************!!
    deallocate( sumLege1, sumLege2, sumL1, sumL2, p0j, pmj, pmj1, pmj2, costheta, sintheta, &
              & facexp, spectramj )
    
  end subroutine harmsy_sub
  
end submodule harmsy