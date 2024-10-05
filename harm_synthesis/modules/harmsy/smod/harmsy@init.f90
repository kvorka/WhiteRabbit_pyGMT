submodule (harmsy) init
  implicit none; contains
  
  module pure subroutine init_lege_coeffs_sub(jmax, cmm, amj, bmj)
    integer,        intent(in)  :: jmax
    real(kind=dbl), intent(out) :: amj(*), bmj(*), cmm(*)
    integer                     :: im, ij, imj
    
    !im = 0
      do ij = 1, jmax
        amj(ij+1) = sqrt( (2*ij-1) * (2*ij+one)                         / (            (ij-im) * (ij+im) ) )
        bmj(ij+1) = sqrt(            (2*ij+one) * (ij-im-1) * (ij+im-1) / ( (2*ij-3) * (ij-im) * (ij+im) ) )
      end do
    
    do im = 1, jmax
      cmm(im) = -sqrt( (2*im+one) / (2*im) )
      
      do ij = im+1, jmax
        imj = im*(jmax+1)-im*(im+1)/2+ij+1
        
        amj(imj) = sqrt( (2*ij-1) * (2*ij+one)                         / (            (ij-im) * (ij+im) ) )
        bmj(imj) = sqrt(            (2*ij+one) * (ij-im-1) * (ij+im-1) / ( (2*ij-3) * (ij-im) * (ij+im) ) )
      end do
    end do
    
  end subroutine init_lege_coeffs_sub
  
  module pure subroutine init_fft_coeffs_sub(ntheta, expphi)
    integer,           intent(in)  :: ntheta
    complex(kind=dbl), intent(out) :: expphi(*)
    integer                        :: ip
    
    do concurrent ( ip = 1:2*ntheta )
      expphi(ip) = exp( cunit * (ip-1) * pi / ntheta )
    end do
    
  end subroutine init_fft_coeffs_sub
  
end submodule init