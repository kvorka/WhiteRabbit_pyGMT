program output
  use ocean
  use ice
  use tgt_cylinder
  implicit none
  
  !call print_tgtcylinder_3d_sub()
  
  
  call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90-fluxCond/mod4_8/velc-averaged.spec', &
                                nd         = 105,                         &
                                jmax       = 321,                        &
                                fac        = 1.0d0,                      &
                                identifier = 'modXX'                     )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90-flux/mod1_13/velc-averaged.spec', &
  !                              nd         = 91,                         &
  !                              jmax       = 247,                        &
  !                              fac        = 1.08d0 / 1883.65d0,         &
  !                              identifier = 'modeIIa'                   )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90-flux/mod1_15/velc-averaged.spec', &
  !                              nd         = 97,                         &
  !                              jmax       = 285,                        &
  !                              fac        = 1.08d0 / 2627.19d0,         &
  !                              identifier = 'modeIIb'                   )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90/mod40/velc-averaged.spec', &
  !                              nd         = 97,                         &
  !                              jmax       = 285,                        &
  !                              fac        = 1.40d0 / 5446.08,              &
  !                              identifier = 'model40'               )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90-flux/mod1_13/velc-resid1.spec', &
  !                              nd         = 91,                         &
  !                              jmax       = 247,                        &
  !                              fac        = 0.08d0 / 2037.48d0,         &
  !                              identifier = 'modeIIar'                  )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.90-flux/mod1_15/velc-resid1.spec', &
  !                              nd         = 97,                         &
  !                              jmax       = 285,                        &
  !                              fac        = 0.08d0 / 3170.66d0,         &
  !                              identifier = 'modeIIbr'                  )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.95/modeInew2/Velc-405.dat', &
  !                              nd         = 73,                         &
  !                              jmax       = 213,                        &
  !                              fac        = 1.0d-4 / 10 * 0.11 / 0.02,  &
  !                              identifier = '95-mode1'                  )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/mod11/Velc-1700.dat', &
  !                              nd         = 89,                          &
  !                              jmax       = 237,                         &
  !                              fac        = 3.0d-4 / 10 * 0.30 / 0.12,   &
  !                              identifier = '85-mode2a-snpsht'           )
  !
  !call harm_synthesis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.95/mod3/velc-averaged.spec', &
  !                              nd         = 107,                          &
  !                              jmax       = 429,                          &
  !                              fac        = 3.0d-4 / 10 * 0.11 / 0.26,    &
  !                              identifier = '95-mode2b'                   )
  
end program output
