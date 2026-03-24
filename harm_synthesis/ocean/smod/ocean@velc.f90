submodule (ocean) velc
  implicit none; contains
  
  module procedure harm_synthesis_velc_sub
    integer                              :: ir, ijml, jmv, jms1, ij, im, il
    type(c_ptr)                          :: c_grdxyz
    real(kind=dbl), pointer, contiguous  :: grdxyz(:)
    real(kind=dbl),          allocatable :: r(:), grdptr(:,:,:)
    complex(kind=dbl),       allocatable :: spcxyz(:,:), velc(:,:)
    
    jms1 =     ( (jmax+1)*(jmax+2)/2+(jmax+1) ) + 1
    jmv  = 3 * ( (jmax  )*(jmax+1)/2+(jmax  ) ) + 1
    
    allocate( r(n_out), velc(jmv,n_out), grdptr(nth,3,n_out) )
      
      call load_spectra_3d_sub(filein, jmv, nd, r, velc)
      
      do ir = 1, n_out
        do ij = 0, jmax
          !im = 0
          !  do il = abs(ij-1), ij+1
          !    velc(3*((ij*(ij+1))/2+im)+il-ij,ir) = czero
          !  end do
          
          do im = 1, ij
            do il = abs(ij-1), ij+1
              velc(3*((ij*(ij+1))/2+im)+il-ij,ir) = czero
            end do
          end do
        end do
      end do
      
      call init_harmsy_sub(jmax+1,nth)

      !$omp parallel private (ijml,spcxyz,grdxyz,c_grdxyz)
      allocate( spcxyz(3,jms1) )
      call alloc_aligned_sub( 6*nth**2, c_grdxyz, grdxyz )
        
        !$omp do
        do ir = 1, n_out
          velc(1,ir) = czero
          do ijml = 2, jmv
            velc(ijml,ir) = fac * velc(ijml,ir)
          end do
          
          call vec2scals_sub(jmax, velc(:,ir), spcxyz)
          call harmsy3_sub(jmax+1, spcxyz, grdxyz)
          
          call vecxyz2zonvecrtp_sub(grdxyz, grdptr(:,:,ir))
        end do
        
      deallocate( spcxyz )
      call free(c_grdxyz)
      !$omp end parallel
      
      call deallocate_harmsy_sub()
      
      call save_data_3d_sub( identifier//'-radvelc.range', identifier//'-vrad.dat', r, grdptr(:,1,:), 's' )
      call save_data_3d_sub( identifier//'-thtvelc.range', identifier//'-vtht.dat', r, grdptr(:,2,:), 'n' )
      call save_data_3d_sub( identifier//'-phivelc.range', identifier//'-vphi.dat', r, grdptr(:,3,:), 's' )
      
    deallocate( r, velc, grdptr )
    
  end procedure harm_synthesis_velc_sub
  
end submodule velc