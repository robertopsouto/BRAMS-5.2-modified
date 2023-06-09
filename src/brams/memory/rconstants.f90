!############################# Change Log ##################################
! 5.0.0
!
!###########################################################################
!  Copyright (C)  1990, 1995, 1999, 2000, 2003 - All Rights Reserved
!  Regional Atmospheric Modeling System - RAMS
!###########################################################################


Module rconstants

!---------------------------------------------------------------------------
real, parameter ::                    &
        rgas     = 287.               &
    ,   cp       = 1004.              &
    ,   cv       = 717.               &
    ,   rm       = 461.               &
    ,   p00      = 1.e5               &
    ,   t00      = 273.16             &
    ,   g        = 9.80               &
    ,   pi180    = 3.1415927 / 180.   &
    ,   pi4      = 3.1415927 * 4.     &
    ,   spcon    = 111120.            &
    ,   erad     = 6367000.           &
    ,   vonk     = 0.40               &
    ,   tkmin    = 5.e-4              &
    ,   alvl     = 2.50e6             &
    ,   alvi     = 2.834e6            &
    ,   alli     = 0.334e6            &
    ,   alvl2    = 6.25e12            &
    ,   alvi2    = 8.032e12           &
    ,   solar    = 1.3533e3           &
    ,   stefan   = 5.6696e-8          &
    ,   cww      = 4218.              &
    ,   c0       = 752.55 * 4.18684e4 &
    ,   viscos   = .15e-4             &
    ,   rowt     = 1.e3               &
    ,   dlat     = 111120.            &
    ,   omega    = 7.292e-5           &
    ,   rocp     = rgas / cp          &
    ,   p00i     = 1. / p00           &
    ,   cpor     = cp / rgas          &
    ,   rocv     = rgas / cv          &
    ,   cpi      = 1. / cp            &
    ,   cpi4     = 4. * cpi           &
    ,   cp253i   = cpi / 253.         & 
    ,   allii    = 1. / alli          &
    ,   aklv     = alvl / cp          &
    ,   akiv     = alvi / cp          &
    ,   gama     = cp / cv            &
    ,   gg       = .5 * g             &
    ,   ep       = rgas / rm          & 
    ,   p00k     = 26.870941          &  !  = p00 ** rocp  
    ,   p00ki    = 1. / p00k
!---------------------------------------------------------------------------
!--(DMK-CCATT-INI)--------------------------------------------------------------	   
   real, parameter :: grav      = 9.80665     ! Gravity acceleration            [     m/s]
   real, parameter :: onethird  = 1./3.             ! 1/3                       [      ---]
  
   !---------------------------------------------------------------------------------------!
   ! Lower bounds for turbulence-related variables                                         !
   !---------------------------------------------------------------------------------------!
   !real, parameter :: tkmin       = 5.e-4 ! Minimum TKE                         [     J/kg]
   real, parameter :: sigwmin     = 1.e-4 ! Minimum sigma-w                     [      m/s]
   real, parameter :: abslmomin   = 1.e-4 ! Minimum abs value of Obukhov length [        m]
   real, parameter :: ltscalemax  = 1.e5  ! Maximum Lagrangian timescale        [        s]
   real, parameter :: abswltlmin  = 1.e-4 ! Minimum abs value of Theta*         [    K m/s]
   real, parameter :: lturbmin    = 1.e-3 ! Minimum abs value of turb. lenght   [        m]
!--(DMK-CCATT-FIM)--------------------------------------------------------------	   

end Module
