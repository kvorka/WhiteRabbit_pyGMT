submodule (ocean) velc
  implicit none; contains
  
  module procedure harm_synthesis_velc_sub
    integer                        :: ir, ijml, jmv, jms1
    real(kind=dbl),    allocatable :: r(:), grdxyz(:,:,:), grdptr(:,:,:)
    complex(kind=dbl), allocatable :: spcxyz(:,:), velc(:,:)
    
    jms1 =     ( (jmax+1)*(jmax+2)/2+(jmax+1) ) + 1
    jmv  = 3 * ( (jmax  )*(jmax+1)/2+(jmax  ) ) + 1
    
    allocate( r(n_out), velc(jmv,n_out), grdptr(3,0:nth,n_out) )
      
      call load_spectra_3d_sub(filein, jmv, nd, r, velc)
      call init_harmsy_sub(jmax+1,nth)

      !$omp parallel private (ijml,spcxyz,grdxyz)
      allocate( spcxyz(3,jms1), grdxyz(3,2*nth,0:nth) )
        
        !$omp do
        do ir = 1, n_out
          velc(1,ir) = czero
          do ijml = 2, jmv
            velc(ijml,ir) = fac * velc(ijml,ir)
          end do
          
          call vec2scals_sub(jmax, velc(:,ir), spcxyz)
          call harmsy_sub(jmax+1, 3, spcxyz, grdxyz)
          call vecxyz2zonvecrtp_sub(grdxyz, grdptr(:,:,ir))
        end do
        
      deallocate(spcxyz, grdxyz)
      !$omp end parallel
      
      call deallocate_harmsy_sub()
      
      call save_data_3d_sub( identifier//'-radvelc.range', identifier//'-vrad.dat', r, grdptr(1,:,:), 'n' )
      call save_data_3d_sub( identifier//'-thtvelc.range', identifier//'-vtht.dat', r, grdptr(2,:,:), 'n' )
      call save_data_3d_sub( identifier//'-phivelc.range', identifier//'-vphi.dat', r, grdptr(3,:,:), 'n' )
      
    deallocate( r, velc, grdptr )
    
  end procedure harm_synthesis_velc_sub
  
  module procedure harm_synthesis_surfvelc_sub
    integer                        :: ir, ijml, jmv, jms1
    real(kind=dbl),    allocatable :: r(:), grdxyz(:,:,:), grdptr(:,:,:)
    complex(kind=dbl), allocatable :: spcxyz(:,:), velc(:,:)
    
    jms1 =     ( (jmax+1)*(jmax+2)/2+(jmax+1) ) + 1
    jmv  = 3 * ( (jmax  )*(jmax+1)/2+(jmax  ) ) + 1
    
    allocate( r(n_out), velc(jmv,n_out), grdptr(3,2*nth,0:nth) )
      
      call load_spectra_3d_sub(filein, jmv, nd, r, velc)
      call init_harmsy_sub(jmax+1,nth)
      
      allocate( spcxyz(3,jms1), grdxyz(3,2*nth,0:nth) )
        
        ir = n_out
          velc(1,ir) = czero
          do ijml = 2, jmv
            velc(ijml,ir) = fac * velc(ijml,ir)
          end do
          
          call vec2scals_sub(jmax, velc(:,ir), spcxyz)
          call harmsy_sub(30, 3, spcxyz, grdxyz)
          call vecxyz2vecrtp_sub(grdxyz, grdptr)
        
      deallocate(spcxyz, grdxyz)
      
      call deallocate_harmsy_sub()
      
      call save_data_2d_sub( identifier//'-surf_radvelc.range', identifier//'-surf_vrad.dat', grdptr(1,:,:), 't' )
      call save_data_2d_sub( identifier//'-surf_thtvelc.range', identifier//'-surf_vtht.dat', grdptr(2,:,:), 't' )
      call save_data_2d_sub( identifier//'-surf_phivelc.range', identifier//'-surf_vphi.dat', grdptr(3,:,:), 't' )
      
    deallocate( r, velc, grdptr )
    
  end procedure harm_synthesis_surfvelc_sub
  
end submodule velc