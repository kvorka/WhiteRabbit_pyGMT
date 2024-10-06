submodule (harmsy) harmsy
  implicit none; contains
  
  module pure subroutine harmsy_sub(jmax, n, spectra, gridvals)
    integer,           intent(in)  :: jmax, n
    complex(kind=dbl), intent(in)  :: spectra(n,*)
    real(kind=dbl),    intent(out) :: gridvals(n,2*nth,0:nth)
    integer                        :: it, ip, ij, im, in
    real(kind=dbl),    allocatable :: p0j(:), pmj(:), pmj1(:), pmj2(:), costheta(:), sintheta(:)
    complex(kind=dbl)              :: expmul
    complex(kind=dbl), allocatable :: sumLege(:), sumL1(:)
    
    !!**************************************************************************************!!
    !!* Prepare output array.                                                              *!!
    !!**************************************************************************************!!
    do concurrent ( it = 0:nth, ip = 1:2*nth, in = 1:n )
      gridvals(in,ip,it) = zero
    end do
    
    !!**************************************************************************************!!
    !!* Allocatation of temporal arrays, step is set to 4, everything is reused for spe-   *!!
    !!* cial case of north pole (a little unoptimized case).                               *!!
    !!**************************************************************************************!!
    allocate( sumLege(4*n*(jmax+1)), sumL1(4*n), &
            & p0j(4), pmj(4), pmj1(4), pmj2(4),  &
            & costheta(4), sintheta(4)           )
    
    !!**************************************************************************************!!
    !!* A special case of the north pole: the north and the south pole have sintheta=0 and *!!
    !!* the polynomials are equal to zero exept those with m=0. Only a norht pole is trea- *!!
    !!* ted specially due to the vectorization purposes.                                   *!!
    !!**************************************************************************************!!
    it = 0
      call pmj_set0_sub( it, costheta(1), sintheta(1) )
      
      im = 0
        do concurrent ( in = 1:n )
          sumLege(in) = czero
        end do
        
        ij = im
          call pmj_set_sub( im, sintheta(1), p0j(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj_sum_sub( n, pmj(1), sumLege(1), spectra(1,1) )
        
        do ij = 1, jmax
          call pmj_recursion_sub( ij+1, costheta(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj_sum_sub( n, pmj(1), sumLege(1), spectra(1,ij*(ij+1)/2+1) )
        end do
        
      do concurrent ( ip = 1:2*nth, in = 1:n )
        gridvals(in,ip,it) = sumLege(in)%re
      end do
    
    !!**************************************************************************************!!
    !!* Main cycle over latitudes. As nth=180, 360, ..., vectorization is handled by com-  *!!
    !!* puting four latitudes at once. South pole included, as mod(nth-1,4) /= 0.          *!!
    !!**************************************************************************************!!
    do it = 1, nth, 4
      call pmj4_set0_sub( it, costheta(1), sintheta(1) )
      
      do im = 0, jmax
        do concurrent ( in = 1:4*n)
          sumL1(in) = czero
        end do
        
        ij = im
          call pmj4_set_sub( im, sintheta(1), p0j(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj4_sum_sub( n, pmj, sumL1(1), spectra(1,ij*(ij+1)/2+im+1))
        
        do ij = im+1, jmax
          call pmj4_recursion_sub( im*(jmax+1)-im*(im+1)/2+ij+1, costheta(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj4_sum_sub( n, pmj, sumL1(1), spectra(1,ij*(ij+1)/2+im+1))
        end do
        
        call pmj4_transpose_sub( n, sumL1(1), sumLege(1+4*n*im) )
      end do
      
      do ip = 1, 2*nth
        do im = 0, jmax
          call fourtrans_set_sub( im, ip, expmul )
          call fourtrans4_sum_sub( n, expmul, sumLege(1+4*n*im), gridvals(1,ip,it) )
        end do
      end do
    end do
    
    !!**************************************************************************************!!
    !!* Cleaning after the computation.                                                    *!!
    !!**************************************************************************************!!
    deallocate( sumLege, sumL1, p0j, pmj, pmj1, pmj2, costheta, sintheta )
    
  end subroutine harmsy_sub
  
end submodule harmsy