submodule (ocean) velc
  implicit none; contains
  
  module subroutine harm_synthesis_velc_sub(filein, nd, jmax, fac, identifier)
    character(len=*),  intent(in)  :: filein, identifier
    integer,           intent(in)  :: nd, jmax
    real(kind=dbl),    intent(in)  :: fac
    integer                        :: ir, ijml, jmv, jms1
    real(kind=dbl),    allocatable :: r(:), grdxyz(:,:,:), grdptr(:,:,:)
    complex(kind=dbl), allocatable :: spcxyz(:,:), velc(:,:)
    
    jms1 =     ( (jmax+1)*(jmax+2)/2+(jmax+1) ) + 1
    jmv  = 3 * ( (jmax  )*(jmax+1)/2+(jmax  ) ) + 1
    
    allocate( r(n_out), velc(jmv,n_out), grdptr(3,0:nth,n_out) )
      
      call load_spectra_3d_sub(filein, jmv, nd, r, velc)
      
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
      
      call save_data_3d_sub( identifier//'-radvelc.range', identifier//'-vrad.dat', r, grdptr(1,:,:), 'n' )
      call save_data_3d_sub( identifier//'-thtvelc.range', identifier//'-vtht.dat', r, grdptr(2,:,:), 'n' )
      call save_data_3d_sub( identifier//'-phivelc.range', identifier//'-vphi.dat', r, grdptr(3,:,:), 'n' )
      
    deallocate( r, velc, grdptr )
    
  end subroutine harm_synthesis_velc_sub
  
end submodule velc