! *****************************COPYRIGHT*******************************
! (C) Crown copyright Met Office. All rights reserved.
! For further details please refer to the file COPYRIGHT.txt
! which you should have received as part of this distribution.
! *****************************COPYRIGHT*******************************
!
! Module with UM setting of 
! CHARNOCK, a constant in the Charnock formula for sea-surface

! Code Description:
!   Language: FORTRAN 90
!   This code is written to UMDP3 v8.2 programming standards.

MODULE c_charnk

  IMPLICIT NONE

! CHARNOCK is a constant in the Charnock formula for sea-surface
!          roughness length for momentum (Z0MSEA).
  REAL,PARAMETER:: charnock = 0.011

END MODULE c_charnk
