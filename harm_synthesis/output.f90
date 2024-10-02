program output
  use ocean
  use ice
  use tgt_cylinder
  implicit none
  
  !call print_tgtcylinder_3d_sub()
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90/mod34/velc-averaged.spec', &
  !                             nd         = 85,                          &
  !                             jmax       = 237,                         &
  !                             fac        = 3.0d-4 / 10 * 0.08 / 0.06,   &
  !                             identifier = '90-mode1'              )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90/mod36/velc-averaged.spec', &
  !                             nd         = 97,                          &
  !                             jmax       = 285,                         &
  !                             fac        = 3.0d-4 / 10 * 0.08 / 0.14,   &
  !                             identifier = '90-mode2a'             )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90/mod37/velc-averaged.spec', &
  !                             nd         = 97,                          &
  !                             jmax       = 321,                         &
  !                             fac        = 3.0d-4 / 10 * 0.08 / 0.16,   &
  !                             identifier = '90-mode2b'             )
  !
  !call print_tgtcylinder_2d_sub()
  
  call harm_synthesis_flux_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90/mod34/flux-averaged.spec', &
                               jmax       = 237,        &
                               identifier = '90-mode1' )
  
  !call harm_synthesis_flux_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90/mod36/flux-averaged.spec', &
  !                             jmax       = 285,         &
  !                             identifier = '90-mode2a' )                             
  !
  !call harm_synthesis_flux_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90/mod37/flux-averaged.spec', &
  !                             jmax       = 321,         &
  !                             identifier = '90-mode2b' )

end program output