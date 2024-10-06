submodule (harmsy) harmsy
  implicit none; contains
  
  module pure subroutine harmsy_sub(jmax, n, spectra, gridvals)
    integer,           intent(in)  :: jmax, n
    complex(kind=dbl), intent(in)  :: spectra(n,*)
    real(kind=dbl),    intent(out) :: gridvals(n,2*nth,0:nth)
    integer                        :: it, ip, ij, im, in
    real(kind=dbl),    allocatable :: p0j(:), pmj(:), pmj1(:), pmj2(:), costheta(:), sintheta(:)
    complex(kind=dbl)              :: expmul
    complex(kind=dbl), allocatable :: sumLege1(:), sumLege2(:), sumL1(:), sumL2(:)
    
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
            & costheta(4), sintheta(4)            )
    
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
        
        ij = im
          call pmj4_set_sub( im, sintheta(1), p0j(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj4_sum_sub( n, pmj, sumL1(1), spectra(1,ij*(ij+1)/2+im+1))
        
        do ij = im+1, jmax
          call pmj4_recursion_sub( im*(jmax+1)-im*(im+1)/2+ij+1, costheta(1), pmj(1), pmj1(1), pmj2(1) )
          
          if ( mod(ij+im,2) == 0 ) then
            call pmj4_sum_sub( n, pmj, sumL1(1), spectra(1,ij*(ij+1)/2+im+1))
          else
            call pmj4_sum_sub( n, pmj, sumL2(1), spectra(1,ij*(ij+1)/2+im+1))
          end if
        end do
        
        call pmj4_transpose_sub( n, sumL1(1), sumL2(1), sumLege1(1+4*n*im), sumLege2(1+4*n*im) )
      end do
      
      do ip = 1, 2*nth
        im = 0
          expmul = cone / 2
          call fourtrans4_sum_sub( n, expmul, sumLege1(1), gridvals(1,ip,it),    &
                                 &            sumLege2(1), gridvals(1,ip,nth-it) )
        
        im = 1
          expmul = expphi(ip)
          call fourtrans4_sum_sub( n, expmul, sumLege1(1+4*n), gridvals(1,ip,it),    &
                                 &            sumLege2(1+4*n), gridvals(1,ip,nth-it) )
        do im = 2, jmax
          expmul = expmul * expphi(ip)
          call fourtrans4_sum_sub( n, expmul, sumLege1(1+4*n*im), gridvals(1,ip,it),    &
                                            & sumLege2(1+4*n*im), gridvals(1,ip,nth-it) )
        end do
      end do
    end do
    
    do it = ( (nth/2) / 4 ) * 4, nth/2 - 1, 2
      call pmj2_set0_sub( it, costheta(1), sintheta(1) )
      
      do im = 0, jmax
        do concurrent ( in = 1:2*n)
          sumL1(in) = czero
          sumL2(in) = czero
        end do
        
        ij = im
          call pmj2_set_sub( im, sintheta(1), p0j(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj2_sum_sub( n, pmj, sumL1(1), spectra(1,ij*(ij+1)/2+im+1))
        
        do ij = im+1, jmax
          call pmj2_recursion_sub( im*(jmax+1)-im*(im+1)/2+ij+1, costheta(1), pmj(1), pmj1(1), pmj2(1) )
          
          if ( mod(ij+im,2) == 0 ) then
            call pmj2_sum_sub( n, pmj, sumL1(1), spectra(1,ij*(ij+1)/2+im+1))
          else
            call pmj2_sum_sub( n, pmj, sumL2(1), spectra(1,ij*(ij+1)/2+im+1))
          end if
        end do
        
        call pmj2_transpose_sub( n, sumL1(1), sumL2(1), sumLege1(1+2*n*im), sumLege2(1+2*n*im) )
      end do
      
      do ip = 1, 2*nth
        im = 0
          expmul = cone / 2
          call fourtrans2_sum_sub( n, expmul, sumLege1(1), gridvals(1,ip,it),    &
                                 &            sumLege2(1), gridvals(1,ip,nth-it) )
        
        im = 1
          expmul = expphi(ip)
          call fourtrans2_sum_sub( n, expmul, sumLege1(1+2*n), gridvals(1,ip,it),    &
                                 &            sumLege2(1+2*n), gridvals(1,ip,nth-it) )
        do im = 2, jmax
          expmul = expmul * expphi(ip)
          call fourtrans2_sum_sub( n, expmul, sumLege1(1+2*n*im), gridvals(1,ip,it),    &
                                            & sumLege2(1+2*n*im), gridvals(1,ip,nth-it) )
        end do
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
        
        ij = im
          call pmj_set_sub( im, sintheta(1), p0j(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj_sum_sub( n, pmj(1), sumLege1(1+n*im), spectra(1,ij*(ij+1)/2+im+1))
        
        do ij = im+1, jmax
          call pmj_recursion_sub( im*(jmax+1)-im*(im+1)/2+ij+1, costheta(1), pmj(1), pmj1(1), pmj2(1) )
          call pmj_sum_sub( n, pmj(1), sumLege1(1+n*im), spectra(1,ij*(ij+1)/2+im+1))
        end do
      end do
      
      do ip = 1, 2*nth
        im = 0
          expmul = cone / 2
          call fourtrans_sum_sub( n, expmul, sumLege1(1), gridvals(1,ip,it) )
        
        im = 1
          expmul = expphi(ip)
          call fourtrans_sum_sub( n, expmul, sumLege1(1+n), gridvals(1,ip,it) )
          
        do im = 2, jmax
          expmul = expmul * expphi(ip)
          call fourtrans_sum_sub( n, expmul, sumLege1(1+n*im), gridvals(1,ip,it) )
        end do
      end do
    
    !!**************************************************************************************!!
    !!* Cleaning after the computation.                                                    *!!
    !!**************************************************************************************!!
    deallocate( sumLege1, sumLege2, sumL1, sumL2, p0j, pmj, pmj1, pmj2, costheta, sintheta )
    
  end subroutine harmsy_sub
  
end submodule harmsy