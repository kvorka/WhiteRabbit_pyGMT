module Harmsy
  use Math
  implicit none; public; contains
  
  pure subroutine harmsy_sub(jmax, nscals, spectra, gridvals)
    integer,            intent(in)  :: jmax, nscals
    complex(kind=dbl),  intent(in)  :: spectra(nscals,*)
    real(kind=dbl),     intent(out) :: gridvals(nscals,2*nth,0:nth)
    integer                         :: it, ip, ij, im, ijm, imj, iv
    real(kind=dbl)                  :: costheta, sintheta, p0j, pmj, pmj1, pmj2
    real(kind=dbl),    allocatable  :: amj(:), bmj(:), cmm(:)
    complex(kind=dbl)               :: expmul
    complex(kind=dbl), allocatable  :: sumLege(:,:), expphi(:)
    
    allocate( sumLege(nscals,0:jmax),   & 
            & expphi(2*nth),            &
            & cmm(jmax),                &
            & amj((jmax+1)*(jmax+2)/2), &
            & bmj((jmax+1)*(jmax+2)/2)  )
    
    do im = 0, jmax
      if ( im > 0 ) then
        cmm(im) = -sqrt( (2*im+one) / (2*im) )
      end if
      
      do ij = im+1, jmax
        imj = im*(jmax+1)-im*(im+1)/2+ij+1
        
        amj(imj) = sqrt( (2*ij-1) * (2*ij+one)                         / (            (ij-im) * (ij+im) ) )
        bmj(imj) = sqrt(            (2*ij+one) * (ij-im-1) * (ij+im-1) / ( (2*ij-3) * (ij-im) * (ij+im) ) )
      end do
    end do
    
    do ip = 1, 2*nth
      expphi(ip) = exp( cunit * (ip-1) * pi / nth )
    end do
    
    do it = 0, nth
      sumLege  = czero
      costheta = cos(it*pi/nth)
      sintheta = sin(it*pi/nth)
      
      do im = 0, jmax
        if ( im == 0 ) then
          p0j = 1 / sqrt(4*pi)
        else
          p0j = p0j * cmm(im) * sintheta
        end if
        
        pmj2 = zero
        pmj1 = zero
        pmj  = p0j
        
        ij = im
          do iv = 1, nscals
            sumLege(iv,im) = sumLege(iv,im) + spectra(iv,ij*(ij+1)/2+im+1) * pmj
          end do
        
        do ij = im+1, jmax
          imj = im*(jmax+1)-im*(im+1)/2+ij+1
          ijm = ij*(ij+1)/2+im+1
          
          pmj2 = pmj1
          pmj1 = pmj
          pmj  = amj(imj) * costheta * pmj1 - bmj(imj) * pmj2
          
          do iv = 1, nscals
            sumLege(iv,im) = sumLege(iv,im) + spectra(iv,ijm) * pmj
          end do
        end do
      end do
      
      do ip = 1, 2*nth
        im = 0
          expmul = cone
          
          do iv = 1, nscals
            gridvals(iv,ip,it) = real( sumLege(iv,0) , kind=dbl )
          end do
        
        do im = 1, jmax
          expmul = expmul * expphi(ip)
          
          do iv = 1, nscals
            gridvals(iv,ip,it) = gridvals(iv,ip,it) + 2 * real( expmul * sumLege(iv,im) , kind=dbl )
          end do
        end do
      end do
    end do
    
    deallocate( sumLege, expphi, cmm, amj, bmj )
    
  end subroutine harmsy_sub
  
end module Harmsy