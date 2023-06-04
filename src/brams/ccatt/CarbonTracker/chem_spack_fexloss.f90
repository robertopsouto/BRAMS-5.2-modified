                                                                                
 MODULE mod_chem_spack_fexloss                                                  
                                                                                
   IMPLICIT NONE                                                                
   PRIVATE                                                                      
   PUBLIC :: fexloss ! subroutine                                               
 CONTAINS                                                                       
                                                                                
   SUBROUTINE fexloss(dw,loss,ngas,ijkbegin,ijkend,maxblock_size,nr)            
                                                                                
!------------------------------------------------------------------------       
!                                                                               
!     -- DESCRIPTION                                                            
!                                                                               
!     This routine computes the chemical loss  term L in a P-Lc formulation.    
!     This routine is automatically generated by SPACK.                         
!     Mechanism: ../Mechanism/CB07                                              
!     Species: ../Mechanism/ciCB07                                              
!                                                                               
!------------------------------------------------------------------------       
!                                                                               
!     -- INPUT VARIABLES                                                        
!                                                                               
!     DW: derivative of reaction rates wrt Y.                                   
!                                                                               
!     -- INPUT/OUTPUT VARIABLES                                                 
!                                                                               
!     -- OUTPUT VARIABLES                                                       
!                                                                               
!     LOSS: array of chemical loss terms.                                       
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
                                                                                
     INTEGER	       , INTENT(IN)  :: NGAS	                                      
     INTEGER	       , INTENT(IN)  :: ijkbegin		                                 
     INTEGER	       , INTENT(IN)  :: ijkend			                                  
     INTEGER	       , INTENT(IN)  :: maxblock_size		                            
     INTEGER	       , INTENT(IN)  :: nr		 	                                     
     DOUBLE PRECISION , INTENT(IN)  :: dw(maxblock_size,nr,NGAS)                
     DOUBLE PRECISION , INTENT(OUT) :: loss(maxblock_size,NGAS)                 
     INTEGER :: ijk						                                                       
                                                                                
                                                                                
!     Chemical loss terms.                                                      
print*,"assaassd",maxblock_size,NGAS,nr,ijkbegin,ijkend                                                                                           
      DO ijk=ijkbegin,ijkend                                                    
      loss(ijk,  1) = + dw(ijk,  1,  1) &
          + dw(ijk, 28,  1) &
          + dw(ijk, 29,  1) &
          + dw(ijk, 31,  1) &
          + dw(ijk, 34,  1) &
          + dw(ijk, 41,  1) &
          + dw(ijk, 43,  1) &
          + dw(ijk, 47,  1) &
          + dw(ijk, 61,  1) &
          + dw(ijk, 68,  1) &
          + dw(ijk, 80,  1) &
          + dw(ijk, 89,  1)
      loss(ijk,  2) = + dw(ijk, 27,  2) &
          + dw(ijk, 30,  2) &
          + dw(ijk, 33,  2) &
          + dw(ijk, 40,  2) &
          +  0.2000000000000000D+01 * dw(ijk, 42,  2) &
          + dw(ijk, 43,  2) &
          + dw(ijk, 45,  2) &
          + dw(ijk, 60,  2) &
          + dw(ijk, 85,  2) &
          + dw(ijk, 94,  2) &
          + dw(ijk, 95,  2)
      loss(ijk,  3) = + dw(ijk, 16,  3) &
          + dw(ijk, 17,  3) &
          + dw(ijk, 27,  3) &
          + dw(ijk, 28,  3) &
          + dw(ijk, 29,  3) &
          + dw(ijk, 54,  3) &
          + dw(ijk, 57,  3) &
          + dw(ijk, 69,  3) &
          + dw(ijk, 72,  3) &
          + dw(ijk, 76,  3)
      loss(ijk,  4) = + dw(ijk,  2,  4) &
          + dw(ijk,  3,  4) &
          + dw(ijk, 17,  4) &
          + dw(ijk, 21,  4) &
          + dw(ijk, 22,  4) &
          + dw(ijk, 40,  4) &
          + dw(ijk, 41,  4) &
          + dw(ijk, 71,  4) &
          + dw(ijk, 74,  4) &
          + dw(ijk, 78,  4) &
          + dw(ijk, 82,  4) &
          + dw(ijk, 91,  4)
      loss(ijk,  5) = + dw(ijk,  7,  5) &
          + dw(ijk,  8,  5) &
          + dw(ijk, 32,  5) &
          + dw(ijk, 36,  5) &
          + dw(ijk, 45,  5) &
          + dw(ijk, 46,  5) &
          + dw(ijk, 47,  5) &
          +  0.2000000000000000D+01 * dw(ijk, 51,  5) &
          + dw(ijk, 56,  5) &
          + dw(ijk, 59,  5) &
          + dw(ijk, 75,  5) &
          + dw(ijk, 79,  5) &
          + dw(ijk, 83,  5) &
          + dw(ijk, 88,  5)
      loss(ijk,  6) = + dw(ijk, 18,  6) &
          + dw(ijk, 19,  6) &
          + dw(ijk, 20,  6)
      loss(ijk,  7) = + dw(ijk, 21,  7) &
          + dw(ijk, 23,  7) &
          + dw(ijk, 24,  7) &
          + dw(ijk, 30,  7) &
          + dw(ijk, 31,  7) &
          + dw(ijk, 32,  7) &
          + dw(ijk, 37,  7) &
          + dw(ijk, 38,  7) &
          + dw(ijk, 39,  7) &
          + dw(ijk, 52,  7) &
          + dw(ijk, 53,  7) &
          + dw(ijk, 55,  7) &
          + dw(ijk, 58,  7) &
          + dw(ijk, 65,  7) &
          + dw(ijk, 70,  7) &
          + dw(ijk, 73,  7) &
          + dw(ijk, 77,  7) &
          + dw(ijk, 81,  7) &
          + dw(ijk, 84,  7) &
          + dw(ijk, 87,  7) &
          + dw(ijk, 90,  7) &
          + dw(ijk, 92,  7) &
          + dw(ijk, 93,  7) &
          + dw(ijk,101,  7) &
          + dw(ijk,102,  7) &
          + dw(ijk,103,  7)
      loss(ijk,  8) = + dw(ijk, 22,  8) &
          + dw(ijk, 23,  8) &
          +  0.2000000000000000D+01 * dw(ijk, 25,  8) &
          +  0.2000000000000000D+01 * dw(ijk, 26,  8) &
          + dw(ijk, 33,  8) &
          + dw(ijk, 34,  8) &
          + dw(ijk, 36,  8) &
          + dw(ijk, 63,  8) &
          + dw(ijk, 97,  8) &
          + dw(ijk, 98,  8)
      loss(ijk,  9) = + dw(ijk, 48,  9) &
          + dw(ijk, 49,  9) &
          + dw(ijk, 50,  9)
      loss(ijk, 10) = + dw(ijk,  5, 10) &
          + dw(ijk, 38, 10)
      loss(ijk, 11) = + dw(ijk,  4, 11) &
          + dw(ijk, 37, 11) &
          +  0.2000000000000000D+01 * dw(ijk, 44, 11)
      loss(ijk, 12) = + dw(ijk,  6, 12) &
          + dw(ijk, 35, 12) &
          + dw(ijk, 39, 12)
      loss(ijk, 13) = + dw(ijk,  9, 13) &
          + dw(ijk, 24, 13)
      loss(ijk, 14) = + dw(ijk, 52, 14) &
          + dw(ijk, 53, 14)
      loss(ijk, 15) = + dw(ijk, 10, 15) &
          + dw(ijk, 11, 15) &
          + dw(ijk, 54, 15) &
          + dw(ijk, 55, 15) &
          + dw(ijk, 56, 15)
      loss(ijk, 16) = + dw(ijk, 12, 16) &
          + dw(ijk, 57, 16) &
          + dw(ijk, 58, 16) &
          + dw(ijk, 59, 16)
      loss(ijk, 17) = + dw(ijk, 60, 17) &
          + dw(ijk, 61, 17) &
          + dw(ijk, 63, 17) &
          +  0.2000000000000000D+01 * dw(ijk, 64, 17)
      loss(ijk, 18) = + dw(ijk, 94, 18) &
          +  0.2000000000000000D+01 * dw(ijk, 96, 18) &
          + dw(ijk, 97, 18) &
          + dw(ijk,100, 18)
      loss(ijk, 19) = + dw(ijk, 62, 19)
      loss(ijk, 20) = +  0.1110000000000000D+01 * dw(ijk, 65, 20) &
          +  0.2100000000000000D+01 * dw(ijk, 66, 20) &
          + dw(ijk, 73, 20) &
          + dw(ijk, 75, 20)
      loss(ijk, 21) = + dw(ijk, 95, 21) &
          + dw(ijk, 98, 21) &
          +  0.2000000000000000D+01 * dw(ijk, 99, 21) &
          + dw(ijk,100, 21)
      loss(ijk, 22) = +  0.9800000000000000D+00 * dw(ijk, 66, 22) &
          + dw(ijk, 67, 22) &
          + dw(ijk, 68, 22)
      loss(ijk, 23) = + dw(ijk, 72, 23) &
          + dw(ijk, 73, 23) &
          + dw(ijk, 74, 23) &
          + dw(ijk, 75, 23)
      loss(ijk, 24) = + dw(ijk, 69, 24) &
          + dw(ijk, 70, 24) &
          + dw(ijk, 71, 24)
      loss(ijk, 25) = + dw(ijk, 84, 25)
      loss(ijk, 26) = + dw(ijk, 87, 26) &
          + dw(ijk, 88, 26)
      loss(ijk, 27) = + dw(ijk, 85, 27) &
          + dw(ijk, 86, 27)
      loss(ijk, 28) = + dw(ijk, 14, 28) &
          + dw(ijk, 90, 28) &
          + dw(ijk, 91, 28)
      loss(ijk, 29) = + dw(ijk, 89, 29)
      loss(ijk, 30) = + dw(ijk, 15, 30) &
          + dw(ijk, 93, 30)
      loss(ijk, 31) = + dw(ijk, 92, 31)
      loss(ijk, 32) = + dw(ijk, 76, 32) &
          + dw(ijk, 77, 32) &
          + dw(ijk, 78, 32) &
          + dw(ijk, 79, 32) &
          + dw(ijk, 80, 32)
      loss(ijk, 33) = + dw(ijk, 13, 33) &
          + dw(ijk, 81, 33) &
          + dw(ijk, 82, 33) &
          + dw(ijk, 83, 33)
      loss(ijk, 34) = + dw(ijk,101, 34)
      loss(ijk, 35) = + dw(ijk,102, 35)
      loss(ijk, 36) = + dw(ijk,103, 36)
      END DO   
                                                                                
   END SUBROUTINE fexloss                                                       
                                                                                
  END MODULE mod_chem_spack_fexloss                                             
                                                                                
