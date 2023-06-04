                                                                                
 MODULE mod_chem_spack_fexprod                                                  
                                                                                
   IMPLICIT NONE                                                                
   PRIVATE                                                                      
   PUBLIC :: fexprod ! subroutine                                               
 CONTAINS                                                                       
                                                                                
   SUBROUTINE fexprod(w,prod,ngas,ijkbegin,ijkend,maxblock_size,nr)             
                                                                                
!------------------------------------------------------------------------       
!                                                                               
!     -- DESCRIPTION                                                            
!                                                                               
!     This routine computes the production  term P in a P-Lc formulation.       
!     This routine is automatically generated by SPACK.                         
!     Mechanism: ../Mechanism/RELACS                                            
!     Species: ../Mechanism/ciRLCS                                              
!                                                                               
!------------------------------------------------------------------------       
!                                                                               
!     -- INPUT VARIABLES                                                        
!                                                                               
!     W: reaction rates.                                                        
!                                                                               
!     -- INPUT/OUTPUT VARIABLES                                                 
!                                                                               
!     -- OUTPUT VARIABLES                                                       
!                                                                               
!     PROD: array of chemical production terms.                                 
!                                                                               
!------------------------------------------------------------------------       
!                                                                               
!     -- REMARKS                                                                
!                                                                               
!------------------------------------------------------------------------       
!                                                                               
!     -- MODIFICATIONS                                                          
!                                                                               
!------------------------------------------------------------------------       
!                                                                               
!     -- AUTHOR(S)                                                              
!                                                                               
!     SPACK.                                                                    
!                                                                               
!------------------------------------------------------------------------       
                                                                                
                                                                                
                                                                                
       IMPLICIT NONE                                                            
                                                                                
      INTEGER  	, INTENT(IN)  :: ngas                                           
      INTEGER  	, INTENT(IN)  :: ijkbegin		                                     
      INTEGER  	, INTENT(IN)  :: ijkend 		                                      
      INTEGER  	, INTENT(IN)  :: maxblock_size		                                
      INTEGER  	, INTENT(IN)  :: nr		      	                                    
      DOUBLE PRECISION , INTENT(IN)  :: w(maxblock_size,nr)	                    
      DOUBLE PRECISION , INTENT(OUT) :: prod(maxblock_size,NGAS)                
      INTEGER :: ijk						                                                      
                                                                                
                                                                                
!     Chemical production terms.                                                
                                                                                
      DO ijk=ijkbegin,ijkend                                                    
      prod(ijk,  1) = + w(ijk, 18) &
          +  0.1730700000000000D+00 * w(ijk, 99)
      prod(ijk,  2) = + w(ijk, 27) &
          + w(ijk, 28) &
          +  0.1833000000000000D-01 * w(ijk, 76) &
          +  0.1000000000000000D-02 * w(ijk, 77)
      prod(ijk,  3) = + w(ijk,  1) &
          + w(ijk,  4) &
          + w(ijk,  7) &
          + w(ijk, 30) &
          + w(ijk, 46)
      prod(ijk,  4) = + w(ijk,  5) &
          +  0.6500000000000000D+00 * w(ijk,  6) &
          + w(ijk,  8) &
          + w(ijk, 17) &
          + w(ijk, 29) &
          + w(ijk, 34) &
          + w(ijk, 35) &
          + w(ijk, 37) &
          +  0.7000000000000000D+00 * w(ijk, 38) &
          + w(ijk, 39) &
          + w(ijk, 41) &
          + w(ijk, 42) &
          +  0.2000000000000000D+01 * w(ijk, 44) &
          +  0.2000000000000000D+01 * w(ijk, 45) &
          + w(ijk, 48) &
          +  0.2000000000000000D+01 * w(ijk, 49) &
          + w(ijk, 68) &
          +  0.1053000000000000D+00 * w(ijk, 71) &
          +  0.4000000000000000D+00 * w(ijk, 75) &
          +  0.7000000000000000D+00 * w(ijk, 79) &
          + w(ijk, 86) &
          + w(ijk, 87) &
          +  0.9154099999999999D+00 * w(ijk, 88) &
          + w(ijk, 89) &
          +  0.8470000000000000D+00 * w(ijk, 90) &
          +  0.9511500000000001D+00 * w(ijk, 91) &
          + w(ijk, 92) &
          +  0.1815990000000000D+01 * w(ijk, 93) &
          +  0.3244000000000000D+00 * w(ijk,107) &
          +  0.7500000000000000D+00 * w(ijk,115) &
          + w(ijk,116) &
          + w(ijk,117) &
          + w(ijk,118) &
          + w(ijk,119) &
          + w(ijk,120) &
          + w(ijk,121) &
          +  0.1740720000000000D+01 * w(ijk,122) &
          + w(ijk,127) &
          + w(ijk,128)
      prod(ijk,  5) = +  0.3500000000000000D+00 * w(ijk,  6) &
          + w(ijk, 31) &
          + w(ijk, 40) &
          + w(ijk, 43) &
          + w(ijk, 48) &
          +  0.7189300000000000D+00 * w(ijk, 67)
      prod(ijk,  6) = + w(ijk, 47)
      prod(ijk,  7) = + w(ijk, 32) &
          + w(ijk, 82)
      prod(ijk,  8) = + w(ijk, 33) &
          +  0.3000000000000000D+00 * w(ijk, 38) &
          + w(ijk, 69) &
          + w(ijk, 70) &
          +  0.9156700000000000D+00 * w(ijk, 71) &
          + w(ijk, 72)
      prod(ijk,  9) = + w(ijk, 36)
      prod(ijk, 11) = + w(ijk, 51)
      prod(ijk, 12) = + w(ijk, 10) &
          + w(ijk, 11) &
          + w(ijk, 12) &
          +  0.9192399999999999D+00 * w(ijk, 16) &
          +  0.1000000000000000D-01 * w(ijk, 53) &
          +  0.8780000000000000D-03 * w(ijk, 57) &
          + w(ijk, 61) &
          +  0.1017320000000000D+01 * w(ijk, 64) &
          + w(ijk, 69) &
          +  0.1337230000000000D+01 * w(ijk, 71) &
          +  0.3512000000000000D+00 * w(ijk, 76) &
          +  0.3600000000000000D+00 * w(ijk, 77) &
          +  0.6472800000000000D+00 * w(ijk, 78) &
          +  0.1300000000000000D+00 * w(ijk, 79)
      prod(ijk, 15) = + w(ijk,  2) &
          + w(ijk,  3) &
          + w(ijk,  7)
      prod(ijk, 17) = + w(ijk, 10) &
          +  0.2084200000000000D+00 * w(ijk, 16) &
          +  0.5409000000000000D-01 * w(ijk, 76) &
          +  0.5000000000000000D-01 * w(ijk, 77) &
          +  0.4000000000000000D-01 * w(ijk, 79)
      prod(ijk, 18) = + w(ijk,  1) &
          + w(ijk,  3) &
          + w(ijk,  8) &
          + w(ijk, 20) &
          + w(ijk, 21) &
          +  0.9000000000000000D-01 * w(ijk, 77)
      prod(ijk, 19) = + w(ijk,  2)
      prod(ijk, 20) = + w(ijk,  4) &
          + w(ijk,  5) &
          +  0.3500000000000000D+00 * w(ijk,  6) &
          +  0.2000000000000000D+01 * w(ijk,  9) &
          + w(ijk, 13) &
          + w(ijk, 14) &
          +  0.2000000000000000D+01 * w(ijk, 22) &
          + w(ijk, 24) &
          + w(ijk, 35) &
          +  0.7000000000000000D+00 * w(ijk, 38) &
          +  0.2000000000000000D-01 * w(ijk, 53) &
          +  0.3943500000000000D+00 * w(ijk, 76) &
          +  0.2800000000000000D+00 * w(ijk, 77) &
          +  0.2059500000000000D+00 * w(ijk, 78) &
          +  0.3600000000000000D-01 * w(ijk, 79) &
          + w(ijk, 84)
      prod(ijk, 21) = +  0.6500000000000000D+00 * w(ijk,  6) &
          +  0.2000000000000000D+01 * w(ijk, 11) &
          + w(ijk, 12) &
          + w(ijk, 13) &
          +  0.9620500000000000D+00 * w(ijk, 14) &
          +  0.7583000000000000D+00 * w(ijk, 16) &
          + w(ijk, 17) &
          + w(ijk, 23) &
          + w(ijk, 26) &
          + w(ijk, 34) &
          + w(ijk, 37) &
          + w(ijk, 50) &
          + w(ijk, 51) &
          + w(ijk, 52) &
          +  0.2800000000000000D+00 * w(ijk, 53) &
          +  0.1279300000000000D+00 * w(ijk, 57) &
          +  0.1031800000000000D+00 * w(ijk, 60) &
          + w(ijk, 61) &
          +  0.5120800000000000D+00 * w(ijk, 64) &
          +  0.2915000000000000D-01 * w(ijk, 66) &
          +  0.2810700000000000D+00 * w(ijk, 67) &
          + w(ijk, 69) &
          +  0.6321700000000000D+00 * w(ijk, 71) &
          +  0.2345100000000000D+00 * w(ijk, 76) &
          +  0.3000000000000000D+00 * w(ijk, 77) &
          +  0.2844100000000000D+00 * w(ijk, 78) &
          +  0.8000000000000000D-01 * w(ijk, 79) &
          +  0.2000000000000000D-01 * w(ijk, 83) &
          + w(ijk, 87) &
          +  0.7426500000000000D+00 * w(ijk, 88) &
          + w(ijk, 89) &
          +  0.8470000000000000D+00 * w(ijk, 90) &
          +  0.9511500000000001D+00 * w(ijk, 91) &
          +  0.1233400000000000D+00 * w(ijk, 92) &
          +  0.1840100000000000D+00 * w(ijk, 93) &
          +  0.6600000000000000D+00 * w(ijk,101) &
          +  0.9838300000000000D+00 * w(ijk,102) &
          + w(ijk,103) &
          + w(ijk,104) &
          +  0.1027670000000000D+01 * w(ijk,105) &
          +  0.8299800000000001D+00 * w(ijk,106) &
          +  0.6756000000000000D+00 * w(ijk,107) &
          +  0.4807900000000000D+00 * w(ijk,108) &
          +  0.5007800000000000D+00 * w(ijk,109) &
          +  0.5060000000000000D+00 * w(ijk,110) &
          + w(ijk,111) &
          +  0.7566000000000001D-01 * w(ijk,112) &
          +  0.1759900000000000D+00 * w(ijk,113) &
          + w(ijk,114) &
          +  0.5000000000000000D+00 * w(ijk,115) &
          + w(ijk,116) &
          +  0.8129000000000000D+00 * w(ijk,117) &
          + w(ijk,118) &
          + w(ijk,119) &
          + w(ijk,120) &
          +  0.4915000000000000D-01 * w(ijk,121) &
          +  0.2592800000000000D+00 * w(ijk,122) &
          + w(ijk,124)
      prod(ijk, 22) = +  0.4300000000000000D-01 * w(ijk, 76)
      prod(ijk, 23) = +  0.3196000000000000D-01 * w(ijk, 76)
      prod(ijk, 25) = +  0.9186800000000001D+00 * w(ijk, 53) &
          +  0.3738800000000000D+00 * w(ijk, 77) &
          +  0.3781500000000000D+00 * w(ijk, 90) &
          +  0.4807400000000000D+00 * w(ijk,104) &
          +  0.2446300000000000D+00 * w(ijk,110) &
          +  0.4272900000000000D+00 * w(ijk,119)
      prod(ijk, 27) = +  0.1067000000000000D+00 * w(ijk, 80) &
          +  0.1066980000000000D+01 * w(ijk, 81) &
          + w(ijk, 82) &
          +  0.2000000000000000D-01 * w(ijk, 83) &
          + w(ijk, 84)
      prod(ijk, 28) = + w(ijk, 13) &
          +  0.6517000000000001D-01 * w(ijk, 16) &
          +  0.5000000000000000D-01 * w(ijk, 53) &
          +  0.1400000000000000D-02 * w(ijk, 57) &
          +  0.3500000000000000D+00 * w(ijk, 65) &
          +  0.2915000000000000D-01 * w(ijk, 66) &
          +  0.5783900000000000D+00 * w(ijk, 67) &
          +  0.4000000000000000D+00 * w(ijk, 75) &
          +  0.4829000000000000D+00 * w(ijk, 76) &
          +  0.9000000000000000D+00 * w(ijk, 77) &
          +  0.7000000000000000D+00 * w(ijk, 79) &
          + w(ijk, 87) &
          +  0.3002000000000000D-01 * w(ijk, 88) &
          +  0.1398700000000000D+01 * w(ijk, 89) &
          +  0.6060000000000000D+00 * w(ijk, 90) &
          +  0.5848000000000000D-01 * w(ijk, 92) &
          +  0.2341900000000000D+00 * w(ijk, 93) &
          +  0.1330000000000000D+01 * w(ijk,101) &
          +  0.8055600000000001D+00 * w(ijk,102) &
          +  0.1428940000000000D+01 * w(ijk,103) &
          +  0.1090000000000000D+01 * w(ijk,104) &
          + w(ijk,105) &
          +  0.9572300000000000D+00 * w(ijk,106) &
          +  0.8862500000000000D+00 * w(ijk,107) &
          +  0.7600000000000000D-01 * w(ijk,108) &
          +  0.6819200000000000D+00 * w(ijk,109) &
          +  0.3400000000000000D+00 * w(ijk,110) &
          +  0.3432000000000000D-01 * w(ijk,112) &
          +  0.1341400000000000D+00 * w(ijk,113) &
          +  0.3530000000000000D+00 * w(ijk,115) &
          + w(ijk,116) &
          +  0.3142000000000000D-01 * w(ijk,117) &
          +  0.1409090000000000D+01 * w(ijk,118) &
          +  0.6860000000000001D+00 * w(ijk,119) &
          +  0.3175000000000000D-01 * w(ijk,121) &
          +  0.2074000000000000D+00 * w(ijk,122) &
          + w(ijk,124)
      prod(ijk, 29) = +  0.9620500000000000D+00 * w(ijk, 14) &
          +  0.2000000000000000D+00 * w(ijk, 17) &
          + w(ijk, 54) &
          +  0.8173000000000000D-01 * w(ijk, 57) &
          +  0.6253000000000000D-01 * w(ijk, 64) &
          +  0.7335000000000000D-01 * w(ijk, 66) &
          +  0.5265000000000000D-01 * w(ijk, 71) &
          +  0.5146800000000000D+00 * w(ijk, 76) &
          +  0.1569200000000000D+00 * w(ijk, 78) &
          +  0.3314400000000000D+00 * w(ijk, 88) &
          +  0.4212500000000000D+00 * w(ijk, 89) &
          +  0.7368000000000000D-01 * w(ijk, 92) &
          +  0.1011820000000000D+01 * w(ijk, 93) &
          +  0.5607000000000000D+00 * w(ijk,102) &
          +  0.4641300000000000D+00 * w(ijk,103) &
          +  0.8295000000000000D-01 * w(ijk,106) &
          +  0.4152400000000000D+00 * w(ijk,107) &
          +  0.7146100000000000D+00 * w(ijk,108) &
          +  0.6837400000000000D+00 * w(ijk,109) &
          +  0.6969000000000000D-01 * w(ijk,112) &
          +  0.4212200000000000D+00 * w(ijk,113) &
          +  0.9250000000000000D+00 * w(ijk,115) &
          +  0.3374300000000000D+00 * w(ijk,117) &
          +  0.4303900000000000D+00 * w(ijk,118) &
          +  0.2936000000000000D-01 * w(ijk,121) &
          +  0.9185000000000000D+00 * w(ijk,122)
      prod(ijk, 30) = +  0.8000000000000000D+00 * w(ijk, 17) &
          +  0.3498000000000000D-01 * w(ijk, 57) &
          +  0.8529999999999999D-02 * w(ijk, 64) &
          +  0.3759100000000000D+00 * w(ijk, 66) &
          +  0.6320000000000000D-02 * w(ijk, 71) &
          +  0.7377000000000000D-01 * w(ijk, 76) &
          +  0.5453100000000000D+00 * w(ijk, 88) &
          +  0.5220000000000000D-01 * w(ijk, 89) &
          +  0.3786200000000000D+00 * w(ijk, 93) &
          +  0.9673000000000000D-01 * w(ijk,102) &
          +  0.3814000000000000D-01 * w(ijk,103) &
          +  0.9667000000000001D-01 * w(ijk,107) &
          +  0.1881900000000000D+00 * w(ijk,108) &
          +  0.6579000000000000D-01 * w(ijk,109) &
          +  0.2190000000000000D-01 * w(ijk,112) &
          +  0.1082200000000000D+00 * w(ijk,113) &
          +  0.2170000000000000D+00 * w(ijk,115) &
          +  0.6297800000000000D+00 * w(ijk,117) &
          +  0.2051000000000000D-01 * w(ijk,118) &
          +  0.3474000000000000D+00 * w(ijk,122)
      prod(ijk, 31) = +  0.1325500000000000D+00 * w(ijk, 53) &
          +  0.8350000000000000D-02 * w(ijk, 57) &
          +  0.2186300000000000D+00 * w(ijk, 67) &
          +  0.9174099999999999D+00 * w(ijk, 74) &
          +  0.3975400000000000D+00 * w(ijk, 77) &
          +  0.7583000000000006D-01 * w(ijk, 78) &
          +  0.3407000000000000D-01 * w(ijk, 88) &
          +  0.4546300000000000D+00 * w(ijk, 90) &
          +  0.2069930000000000D+01 * w(ijk, 91) &
          +  0.8670000000000000D-01 * w(ijk, 92) &
          +  0.7976000000000000D-01 * w(ijk,102) &
          +  0.5606400000000000D+00 * w(ijk,104) &
          +  0.1994610000000000D+01 * w(ijk,105) &
          +  0.1538700000000000D+00 * w(ijk,106) &
          +  0.6954000000000000D-01 * w(ijk,108) &
          +  0.7859100000000000D+00 * w(ijk,110) &
          +  0.1994550000000000D+01 * w(ijk,111) &
          +  0.1077700000000000D+00 * w(ijk,112) &
          +  0.3531000000000000D-01 * w(ijk,117) &
          +  0.6116000000000000D+00 * w(ijk,119) &
          +  0.2819040000000000D+01 * w(ijk,120) &
          +  0.3455000000000000D-01 * w(ijk,121)
      prod(ijk, 32) = +  0.6000000000000000D+00 * w(ijk, 75) &
          + w(ijk, 80) &
          +  0.8459000000000000D-01 * w(ijk, 88) &
          +  0.1530000000000000D+00 * w(ijk, 90) &
          +  0.4885000000000000D-01 * w(ijk, 91) &
          +  0.1840100000000000D+00 * w(ijk, 93) &
          + w(ijk,100) &
          +  0.6756000000000000D+00 * w(ijk,107) &
          +  0.6656200000000000D+00 * w(ijk,113) &
          +  0.2000000000000000D+01 * w(ijk,114) &
          +  0.1250000000000000D+01 * w(ijk,115) &
          +  0.2592800000000000D+00 * w(ijk,122)
      prod(ijk, 33) = + w(ijk, 85)
      prod(ijk, 34) = + w(ijk, 94)
      prod(ijk, 35) = +  0.1014900000000000D+00 * w(ijk, 78) &
          +  0.1005240000000000D+01 * w(ijk, 95) &
          +  0.1005240000000000D+01 * w(ijk, 96) &
          +  0.1005240000000000D+01 * w(ijk, 97) &
          +  0.1005240000000000D+01 * w(ijk, 98) &
          +  0.8090400000000000D+00 * w(ijk, 99) &
          +  0.1005240000000000D+01 * w(ijk,123)
      prod(ijk, 36) = +  0.8780000000000000D-02 * w(ijk, 57) &
          +  0.1534300000000000D+00 * w(ijk, 76) &
          +  0.1500000000000000D+00 * w(ijk, 77) &
          +  0.1078800000000000D+00 * w(ijk, 78) &
          +  0.1100000000000000D+00 * w(ijk, 79)
      prod(ijk, 37) = +  0.8143000000000000D-01 * w(ijk, 76) &
          +  0.2059500000000000D+00 * w(ijk, 78) &
          +  0.1730700000000000D+00 * w(ijk, 99) &
          +  0.1368400000000000D+00 * w(ijk,106) &
          +  0.4981000000000000D+00 * w(ijk,108) &
          +  0.4992200000000000D+00 * w(ijk,109) &
          +  0.4940000000000000D+00 * w(ijk,110) &
          +  0.9955000000000000D-01 * w(ijk,112) &
          +  0.4896300000000000D+00 * w(ijk,113)
      prod(ijk, 38) = + w(ijk, 12) &
          +  0.3795000000000000D-01 * w(ijk, 14) &
          + w(ijk, 55) &
          +  0.6500000000000000D+00 * w(ijk, 65) &
          +  0.1396600000000000D+00 * w(ijk, 76) &
          +  0.3000000000000000D-01 * w(ijk, 77) &
          +  0.9016000000000000D-01 * w(ijk, 88) &
          +  0.7813400000000000D+00 * w(ijk, 92) &
          +  0.5148000000000000D+00 * w(ijk,108) &
          +  0.5007800000000000D+00 * w(ijk,109) &
          +  0.5060000000000000D+00 * w(ijk,110) &
          + w(ijk,111) &
          +  0.1667020000000000D+01 * w(ijk,112) &
          +  0.5103700000000000D+00 * w(ijk,113) &
          +  0.9730999999999999D-01 * w(ijk,117) &
          +  0.9191000000000000D+00 * w(ijk,121) &
          + w(ijk,125)
      prod(ijk, 39) = + w(ijk, 15) &
          + w(ijk, 56) &
          +  0.8781099999999999D+00 * w(ijk, 57) &
          +  0.4034100000000000D+00 * w(ijk, 66) &
          + w(ijk, 68) &
          +  0.9815000000000000D-01 * w(ijk, 76)
      prod(ijk, 40) = +  0.1025290000000000D+01 * w(ijk, 58)
      prod(ijk, 41) = + w(ijk, 59)
      prod(ijk, 42) = +  0.2760000000000000D-02 * w(ijk, 60) &
          + w(ijk, 72)
      prod(ijk, 43) = +  0.9396800000000000D+00 * w(ijk, 60)
      prod(ijk, 44) = +  0.9800000000000000D+00 * w(ijk, 83)
      prod(ijk, 45) = + w(ijk, 15) &
          +  0.6962200000000000D+00 * w(ijk, 16) &
          + w(ijk, 62) &
          + w(ijk, 63) &
          +  0.5141900000000000D+00 * w(ijk, 64) &
          +  0.5413000000000000D-01 * w(ijk, 66) &
          + w(ijk, 70) &
          +  0.3888100000000000D+00 * w(ijk, 71) &
          +  0.5705000000000000D-01 * w(ijk, 76) &
          +  0.1700000000000000D+00 * w(ijk, 77) &
          +  0.2746000000000000D+00 * w(ijk, 78) &
          +  0.7000000000000000D+00 * w(ijk, 79) &
          + w(ijk, 86)
      prod(ijk, 46) = +  0.9376800000000000D+00 * w(ijk, 73) &
          + w(ijk, 74)
      prod(ijk, 47) = +  0.1500000000000000D+00 * w(ijk, 53) &
          +  0.1031800000000000D+00 * w(ijk, 60) &
          +  0.1016200000000000D+00 * w(ijk, 64) &
          +  0.9333000000000000D-01 * w(ijk, 66) &
          + w(ijk, 67) &
          +  0.1053000000000000D+00 * w(ijk, 71) &
          + w(ijk, 75) &
          +  0.1300000000000000D+00 * w(ijk, 77) &
          +  0.1300700000000000D+00 * w(ijk, 88) &
          +  0.2563000000000000D-01 * w(ijk, 92) &
          +  0.1337000000000000D+00 * w(ijk,102) &
          +  0.2212000000000000D-01 * w(ijk,106) &
          +  0.1130600000000000D+00 * w(ijk,108) &
          +  0.1593000000000000D-01 * w(ijk,112) &
          +  0.1627100000000000D+00 * w(ijk,117) &
          +  0.1021000000000000D-01 * w(ijk,121)
      END DO   
                                                                                
   END SUBROUTINE fexprod                                                       
                                                                                
  END MODULE mod_chem_spack_fexprod                                             
                                                                                
