program output
  use ocean
  use ice
  use tgt_cylinder
  implicit none
  
  call print_tgtcylinder_3d_sub()
  
  call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/mod9/velc-averaged.spec', &
                               nd         = 73,                          &
                               jmax       = 177,                         &
                               fac        = 3.0d-4 / 10 * 0.21 / 0.08,   &
                               identifier = '85-mode1'                   )
  
  call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/modnew/velc-averaged.spec', &
                               nd         = 89,                          &
                               jmax       = 237,                         &
                               fac        = 3.0d-4 / 10 * 0.21 / 0.12,   &
                               identifier = '85-mode2a'                  )
  
  call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/mod11/velc-averaged.spec', &
                               nd         = 89,                          &
                               jmax       = 237,                         &
                               fac        = 3.0d-4 / 10 * 0.21 / 0.14,   &
                               identifier = '85-mode2b'                  )
  
  call print_tgtcylinder_2d_sub()
  
  call harm_synthesis_flux_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/mod9/flux-averaged.spec', &
                               jmax       = 177,        &
                               identifier = '85-mode1' )
  
  call harm_synthesis_flux_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/modnew/flux-averaged.spec', &
                               jmax       = 237,         &
                               identifier = '85-mode2a' )                             
  
  call harm_synthesis_flux_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/mod11/flux-averaged.spec', &
                               jmax       = 237,         &
                               identifier = '85-mode2b' )

end program output