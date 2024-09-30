program OutputOcean
  use OutputOceanMod
  implicit none
  
  !call print_tgtcylinder_sub(.False.)
  !
  !call harm_analysis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/mod9/velc-averaged.spec', &
  !                             nd         = 73,                          &
  !                             jmax       = 177,                         &
  !                             fac        = 3.0d-4 / 10 * 0.21 / 0.08,   &
  !                             identifier = 'Ek3-085-mode1'              )
  !
  !call harm_analysis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/mod11/velc-averaged.spec', &
  !                             nd         = 89,                          &
  !                             jmax       = 237,                         &
  !                             fac        = 3.0d-4 / 10 * 0.21 / 0.14,   &
  !                             identifier = 'Ek3-085-mode2a'             )
  !
  !call harm_analysis_velc_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/mod12/velc-averaged.spec', &
  !                             nd         = 89,                          &
  !                             jmax       = 297,                         &
  !                             fac        = 3.0d-4 / 10 * 0.21 / 0.17,   &
  !                             identifier = 'Ek3-085-mode2b'             )
  
  call print_tgtcylinder_sub(.True.)
  
  call harm_analysis_flux_sub( filein     = '/home/kvorka/WorkDir/esa_grant/0.85/mod12/flux-averaged.spec', &
                               jmax       = 297,                         &
                               identifier = 'Ek3-085-mode2b'             )

end program OutputOcean
