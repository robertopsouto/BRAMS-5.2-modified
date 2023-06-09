      SUBROUTINE DO_AREAVER( GAPS_LAMBDA_SRCE,GAPS_PHI_SRCE,LROW_SRCE    &
     &,INVERT_SRCE,DATA_SRCE,GAPS_LAMBDA_TARG,GAPS_PHI_TARG,COUNT_TARG   &
     &,BASE_TARG,LROW_TARG,WANT,MASK_TARG,INDEX_SRCE,WEIGHT,ADJUST       &
     &,DATA_TARG,ADJUST_TARG,ICODE,CMESSAGE )   
                         
!     Subroutine DO_AREAVER ------------------------------------------- 
!                                                                       
!   Purpose:                                                            
!                                                                       
!     Perform area-averaging to transform data from the source grid to  
!     the target grid, or adjust the values on the source grid to have  
!     the area-averages supplied on the target grid. The latter mode    
!     is intended for adjusting values obtained by interpolating from   
!     "target" to "source" in order to conserve the area-averages.      
!     This mode should be used ONLY if each source box belongs in       
!     exactly one target box. ADJUST=0 selects normal area-averaging,   
!     ADJUST=1 selects adjustment by addition (use this mode for fields 
!     which may have either sign), ADJUST=2 selects adjustment by       
!     multiplication (for fields which are positive-definite or         
!     negative-definite).                                               
!                                                                       
!     For two-way conservative coupling, ADJUST=3 makes an adjustment   
!     field for fields which may have either sign, ADJUST=4 makes an    
!     adjustment field for fields which are positive-definite or        
!     negative-definite, ADJUST=5 performs conservative adjustment      
!     by addition (use this mode for fields which may have either sign) 
!     and ADJUST=6 selects conservative adjustment by multiplication    
!     (for fields which are positive-definite or negative-definite).    
!                                                                       
!     The shape of the source and target grids are specified by their   
!     dimensions GAPS_aa_bb, which give the number of gaps in the       
!     aa=LAMBDA,PHI coordinate in the bb=SRCE,TARG grid. (The product   
!     of GAPS_LAMBDA_bb and GAPS_PHI_bb is the number of boxes in the   
!     bb grid.)                                                         
!                                                                       
!     The input and output data are supplied as 2D arrays DATA_SRCE and 
!     DATA_TARG, whose first dimensions should also be supplied. Speci- 
!     fying these sizes separately from the actual dimensions of the    
!     grids allows for columns and rows in the arrays to be ignored.    
!     A target land/sea mask should be supplied in MASK_TARG, with the  
!     value indicating wanted points specified in WANT. Points which    
!     are unwanted or which lie outside the source grid are not altered 
!     in DATA_TARG. DATA_SRCE can optionally be supplied with its rows  
!     in reverse order (i.e. with the first row corresponding to        
!     minimum LAMBDA).                                                  
!                                                                       
!     The arrays COUNT_TARG, BASE_TARG, INDEX_SRCE and WEIGHT should be 
!     supplied as returned by PRE_AREAVER q.v.                          
!                                                                       
!     Programming Standard, paper 4 version 4 (14.12.90)                
!                                                                       
!    Model            Modification history from model version 5.2:      
!   Version  date                                                       
!    5.3  07.11.01  Extended for use with 2-way conservative coupling   
!                   scheme by introducing new output argument           
!                   ADJUST_TARG and 4 new operation selectors.          
!    5.5  11.04.03  Corrected bug in calculation of adjustment field    
!                   for case = 3.                                       
!  5.5  28.02.03  Add defined A20_1A (river routing). C. Bunton         
!  6.0  12.09.03  Change DEF from A20 to A26. D. Robinson               
!                                                                       
!   Logical components covered :                                        
!                                                                       
!   Project task :                                                      
!                                                                       
!   External documentation: Unified Model documentation paper No:       
!                           Version:                                    
!                                                                       
      IMPLICIT NONE                                                     

      INTEGER ::  &                                                          
       GAPS_LAMBDA_SRCE       &!IN number lambda gaps in source grid    
      ,GAPS_PHI_SRCE          &!IN number phi gaps in source grid       
      ,LROW_SRCE              &!IN first dimension of source arrays     
      ,GAPS_LAMBDA_TARG       &!IN number lambda gaps in target grid    
      ,GAPS_PHI_TARG          &!IN number phi gaps in target grid       
      ,LROW_TARG              &!IN first dimension of target arrays     
      ,COUNT_TARG(GAPS_LAMBDA_TARG,GAPS_PHI_TARG)      &
!                              !IN no. of source boxes in target box    
      ,BASE_TARG(GAPS_LAMBDA_TARG,GAPS_PHI_TARG)       &                 
!                              !IN first index in list for target box   
      ,INDEX_SRCE(*)          &!IN list of source box indices           
      ,ADJUST                 &!IN selects normal or adjust mode        
      ,ICODE                   !OUT return code                         

      LOGICAL ::  &
       INVERT_SRCE            &!IN DATA_SRCE rows in reverse order      
      ,WANT                   &!IN indicator of wanted points in mask   
      ,MASK_TARG(LROW_TARG,*)  !IN land/sea mask for target grid        

!     NB alternative intents below apply for normal/adjust mode         
      REAL ::  &
       DATA_SRCE(LROW_SRCE,*) &!IN/INOUT data on source grid            
      ,WEIGHT(*)              &!IN list of weights for source boxes     
      ,DATA_TARG(LROW_TARG,*) &!INOUT/IN data on target grid            
      ,ADJUST_TARG(LROW_TARG,*) !OUT factors by which DATA_SRCE        
                                !must be adjusted to give DATA_TARG    

      CHARACTER ::  &                                                         
       CMESSAGE*(*)            !OUT error message                       

      INTEGER ::  &
       IP                     &! pointer into lists                     
      ,I                      &! loop index                             
      ,IX1(GAPS_LAMBDA_SRCE*GAPS_PHI_SRCE)  &
!                              ! working SRCE LAMBDA indices            
      ,IY1(GAPS_LAMBDA_SRCE*GAPS_PHI_SRCE)  &                            
!                              ! working SRCE PHI indices               
      ,IX2,IY2                 ! working TARG LAMBDA/PHI indices        

      REAL ::  &
       TEMP_TARG              &! workspace for area-average             
      ,DELTA                  &! additive adjustment                    
      ,RATIO                   ! multiplicative adjustment              

!-------------------------------------------------------------------------------
                                                                       
!     Loop over all target boxes and calculate values as required.      
!                                                                       
!     The weights and source box indices are recorded in continuous     
!     lists. COUNT_TARG indicates how many consecutive entries in these 
!     lists apply to each target box.                                   
!                                                                       
      DO IY2=1,GAPS_PHI_TARG                                            
        DO IX2=1,GAPS_LAMBDA_TARG                                       
          IF (MASK_TARG(IX2,IY2).EQV.WANT) THEN                         
            IF (COUNT_TARG(IX2,IY2).NE.0) THEN                          
              TEMP_TARG=0.                                              
              DO I=1,COUNT_TARG(IX2,IY2)                                
                IP=BASE_TARG(IX2,IY2)+I                                 
                IX1(I)=MOD(INDEX_SRCE(IP)-1,GAPS_LAMBDA_SRCE)+1         
                IY1(I)=(INDEX_SRCE(IP)-1)/GAPS_LAMBDA_SRCE+1            
                IF (INVERT_SRCE) IY1(I)=GAPS_PHI_SRCE-IY1(I)+1          
                TEMP_TARG=TEMP_TARG+WEIGHT(IP)*DATA_SRCE(IX1(I),IY1(I)) 
              ENDDO                                                     
            ELSE                                                        
              IF(ADJUST.EQ.5)THEN                                       
                TEMP_TARG=0.0                                           
              ELSEIF(ADJUST.EQ.6)THEN                                   
                TEMP_TARG=1.0                                           
              ELSE                                                      
                TEMP_TARG=DATA_TARG(IX2,IY2)                            
              ENDIF                                                     
            ENDIF                                                       
            IF (ADJUST.EQ.0) THEN                                       
              DATA_TARG(IX2,IY2)=TEMP_TARG                              
            ELSEIF (ADJUST.EQ.1) THEN                                   
              DELTA=DATA_TARG(IX2,IY2)-TEMP_TARG                        
              DO I=1,COUNT_TARG(IX2,IY2)                                
                DATA_SRCE(IX1(I),IY1(I))=DATA_SRCE(IX1(I),IY1(I))+DELTA 
              ENDDO                                                     
            ELSEIF (ADJUST.EQ.2.AND.TEMP_TARG.NE.0.) THEN               
              RATIO=DATA_TARG(IX2,IY2)/TEMP_TARG                        
              DO I=1,COUNT_TARG(IX2,IY2)                                
                DATA_SRCE(IX1(I),IY1(I))=DATA_SRCE(IX1(I),IY1(I))*RATIO 
              ENDDO                                                     
            ELSEIF (ADJUST.EQ.3) THEN                                   
              ADJUST_TARG(IX2,IY2)=TEMP_TARG-DATA_TARG(IX2,IY2)         
            ELSEIF (ADJUST.EQ.4) THEN                                   
              IF (TEMP_TARG.EQ.0) THEN                                  
                ADJUST_TARG(IX2,IY2)=1.0                                
              ELSE                                                      
                ADJUST_TARG(IX2,IY2)=DATA_TARG(IX2,IY2)/TEMP_TARG       
              ENDIF                                                     
            ELSEIF (ADJUST.EQ.5) THEN                                   
              DATA_TARG(IX2,IY2)=DATA_TARG(IX2,IY2)+TEMP_TARG           
            ELSEIF (ADJUST.EQ.6) THEN                                   
              DATA_TARG(IX2,IY2)=DATA_TARG(IX2,IY2)*TEMP_TARG           
            ENDIF                                                       
          ENDIF                                                         
        ENDDO                                                           
      ENDDO                                                             
                                                                       
      ICODE=0                                                           
      CMESSAGE=' '                                                      
      RETURN                                                            

      END SUBROUTINE do_areaver
