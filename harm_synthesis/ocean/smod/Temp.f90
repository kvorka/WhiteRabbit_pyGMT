submodule(OutputOceanMod) Temp
  implicit none; contains
  
  module subroutine harm_analysis_temp_sub(filein, nd, jmax, identifier)
    character(len=*),  intent(in)  :: filein, identifier
    integer,           intent(in)  :: nd, jmax
    integer                        :: ir, jms
    real(kind=dbl),    allocatable :: r(:), grdt(:,:), grdxyz(:,:)
    complex(kind=dbl), allocatable :: temp(:,:)
    
    jms = jmax*(jmax+1)/2+jmax+1
    
    allocate( r(n_out), temp(jms,n_out), grdt(0:nth,n_out) )
      
      call load_spectra_3d_sub(filein, jms, nd, r, temp)
      
      !$omp parallel private (grdxyz)
      allocate( grdxyz(2*nth,0:nth) )
        
        !$omp do
        do ir = 1, n_out
          !temp(1,ir) = czero
          
          call harmsy_sub(jmax, 1, temp(:,ir), grdxyz)
          grdt(:,ir) = sum( grdxyz, dim=1 ) / (2*nth)
        end do
        
      deallocate( grdxyz )
      !$omp end parallel
      
      call save_data_3d_sub( identifier//'-temp.range', identifier//'-temp.dat', r, grdt, 'n' )
      
    deallocate( r, temp, grdt )
    
  end subroutine harm_analysis_temp_sub
  
end submodule Temp