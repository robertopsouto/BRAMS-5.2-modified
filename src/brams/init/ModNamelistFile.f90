!############################# Change Log ##################################
! 5.0.0
!
!###########################################################################
!  Copyright (C)  1990, 1995, 1999, 2000, 2003 - All Rights Reserved
!  Regional Atmospheric Modeling System - RAMS
!###########################################################################

module ModNamelistFile

  use grid_dims

  private
  public :: namelistFile
  public :: CreateNamelistFile
  public :: DestroyNamelistFile
  public :: GetNamelistFileName
  public :: ReadNamelistFile
  public :: BroadcastNamelistFile
  public :: DumpNamelistFile
  public :: TimeUnitsToSeconds


  include "files.h"
  integer, parameter :: maxodagrids=10
  integer, parameter :: maxcugrids=10
  integer, parameter :: ncat_dummy=8 ! for micro_2m
  integer, parameter :: maxsndg=200
  integer, parameter :: maxisn=100
  integer, parameter :: maxagrds=10

!--(DMK-CCATT-INI)-----------------------------------------------------------
  integer, parameter :: nsrc=4   !  number_sources
!--(DMK-CCATT-FIM)-----------------------------------------------------------

  type namelistFile
     character(len=f_name_length) :: fileName 

     ! namelist /MODEL_GRID/

     character(len=64) :: expnme            
     character(len=16) :: runtype 
     character(len=1)  :: timeunit 
     real    :: timmax 
     integer :: load_bal           
     integer :: imonth1 
     integer :: idate1 
     integer :: iyear1 
     integer :: itime1 
     integer :: ngrids                      
     integer :: nnxp(maxgrds)       
     integer :: nnyp(maxgrds)       
     integer :: nnzp(maxgrds)       
     integer :: nzg                         
     integer :: nzs                         
     integer :: nxtnest(maxgrds)            
     character(len=f_name_length) :: domain_fname 
     integer :: if_adap 
     integer :: ihtran 
     real :: deltax 
     real :: deltay 
     real :: deltaz 
     real :: dzrat 
     real :: dzmax 
     real :: zz(nzpmax) 
     real :: dtlong 
     integer :: nacoust 
     integer :: ideltat 
     integer :: nstratx(maxgrds)            
     integer :: nstraty(maxgrds)            
     integer :: nndtrat(maxgrds)            
     integer :: nestz1 
     integer :: nstratz1(nzpmax) 
     integer :: nestz2 
     integer :: nstratz2(nzpmax) 
     real :: polelat 
     real :: polelon 
     real :: centlat(maxgrds)               
     real :: centlon(maxgrds)               
     integer :: ninest(maxgrds)             
     integer :: njnest(maxgrds)             
     integer :: nknest(maxgrds)             
     integer :: nnsttop(maxgrds) 
     integer :: nnstbot(maxgrds) 
     real :: gridu(maxgrds) 
     real :: gridv(maxgrds) 

     ! namelist /CCATT_INFO/

     integer :: ccatt
     integer :: chemistry
     character(len=20) :: split_method
     real    :: chem_timestep
     integer :: chemistry_aq
     !integer :: aerosol
     integer :: chem_assim
     character(len=256) :: srcmapfn
     integer :: recycle_tracers 
     character(len=32) :: def_proc_src
     integer :: diur_cycle(nsrc)            
     integer :: na_extra2d
     integer :: na_extra3d
     integer :: plumerise 
     real :: prfrq             
     integer :: volcanoes
     !Matrix
     REAL :: aer_timestep
     INTEGER :: aerosol
     integer :: aer_assim
     integer :: mech
     
!--(DMK-CCATT-OLD)-----------------------------------------------------------
!     ! namelist /CATT_INFO/
!
     integer :: catt
     character(len=256) :: firemapfn 
!    integer :: recycle_tracers 
!    integer :: plumerise 
     integer :: define_proc 
!    real :: prfrq             
!--(DMK-CCATT-FIM)-----------------------------------------------------------

     ! namelist /TEB_SPM_INFO/                                              &

     integer :: teb_spm 
     character(len=f_name_length) :: fusfiles 
     integer :: ifusflg(maxgrds) 
     character(len=f_name_length) :: ifusfn(maxgrds) 
     integer             :: ichemi    
     integer             :: ichemi_in   
     character (len=f_name_length) :: chemdata_in 
     integer             :: isource     
     character(len=3)    :: weekdayin   
     real            :: rushh1    
     real            :: rushh2    
     real            :: daylight  
     real            :: efsat 
     real            :: efsun 
     real            :: eindno  
     real            :: eindno2 
     real            :: eindpm 
     real            :: eindco 
     real            :: eindso2 
     real            :: eindvoc 
     real            :: eveino  
     real            :: eveino2 
     real            :: eveipm  
     real            :: eveico  
     real            :: eveiso2 
     real            :: eveivoc 
     integer         :: iteb 
     real            :: tminbld   
     integer         :: nteb 
     real            :: hc_roof(maxsteb) 
     real            :: tc_roof(maxsteb) 
     real            :: d_roof(maxsteb) 
     real            :: hc_road(maxsteb) 
     real            :: tc_road(maxsteb) 
     real            :: d_road(maxsteb) 
     real            :: hc_wall(maxsteb) 
     real            :: tc_wall(maxsteb) 
     real            :: d_wall(maxsteb) 
     integer         :: nurbtype    
     integer         :: ileafcod(maxubtp)   
     real            :: z0_town(maxubtp) 
     real            :: bld(maxubtp) 
     real            :: bld_height(maxubtp) 
     real            :: bld_hl_ratio(maxubtp) 
     real            :: aroof(maxubtp) 
     real            :: eroof(maxubtp) 
     real            :: aroad(maxubtp) 
     real            :: eroad(maxubtp) 
     real            :: awall(maxubtp) 
     real            :: ewall(maxubtp) 
     real            :: htraf(maxubtp) 
     real            :: hindu(maxubtp) 
     real            :: pletraf(maxubtp) 
     real            :: pleindu(maxubtp) 


     !namelist /MODEL_FILE_INFO/                                           &

     integer :: initial 
     integer :: nud_type 
     character(len=f_name_length)       :: varfpfx 
     real :: vwait1 
     real :: vwaittot 
     character(len=f_name_length) :: nud_hfile 
     integer :: nudlat 
     real :: tnudlat 
     real :: tnudcent 
     real :: tnudtop 
     real :: znudtop 
     real :: wt_nudge_grid(maxgrds) 
     real :: wt_nudge_uv 
     real :: wt_nudge_th 
     real :: wt_nudge_pi 
     real :: wt_nudge_rt 
     integer :: nud_cond 
     character(len=f_name_length) :: cond_hfile 
     real :: tcond_beg  
     real :: tcond_end  
     real :: t_nudge_rc  
     real :: wt_nudgec_grid(maxgrds) 
     integer            :: if_oda 
     character(len=128) :: oda_upaprefix 
     character(len=128) :: oda_sfcprefix 
     real               :: frqoda 
     real               :: todabeg 
     real               :: todaend 
     real               :: tnudoda 
     real               :: wt_oda_grid(maxodagrids) 
     real               :: wt_oda_uv 
     real               :: wt_oda_th 
     real               :: wt_oda_pi 
     real               :: wt_oda_rt 
     real               :: roda_sfce(maxodagrids) 
     real               :: roda_sfc0(maxodagrids) 
     real               :: roda_upae(maxodagrids) 
     real               :: roda_upa0(maxodagrids) 
     real               :: roda_hgt(maxodagrids) 
     real               :: roda_zfact(maxodagrids) 
     real               :: oda_sfc_til 
     real               :: oda_sfc_tel 
     real               :: oda_upa_til 
     real               :: oda_upa_tel 
     integer :: if_cuinv             
     character(len=128) :: cu_prefix 
     real :: tnudcu                  
     real :: wt_cu_grid(maxcugrids)  
     real :: tcu_beg                 
     real :: tcu_end                 
     real :: cu_tel                  
     real :: cu_til                  
     real :: timstr 
     character(len=f_name_length) :: hfilin 
     integer :: ipastin 
     character(len=f_name_length) :: pastfn 
     integer :: ioutput 
     character(len=f_name_length) :: hfilout 
     character(len=f_name_length) :: afilout 
     integer :: iclobber 
     integer :: ihistdel 
     real :: frqhis 
     real :: frqanl 
     real :: frqlite 
     integer :: ipos
     character(len=20)  :: xlite 
     character(len=20)  :: ylite 
     character(len=20)  :: zlite 
     integer :: nlite_vars 
     character(len=32)  :: lite_vars(maxlite) 
     real :: avgtim 
     real :: frqmean 
     real :: frqboth 
     integer :: kwrite 
     real             :: frqprt 
     integer            :: initfld 
     integer                :: prtcputime 
     character(len=f_name_length) :: topfiles 
     character(len=f_name_length) :: sfcfiles 
     character(len=f_name_length) :: sstfpfx 
     character(len=f_name_length) :: ndvifpfx 
     integer :: itoptflg(maxgrds) 
     integer :: isstflg(maxgrds) 
     integer :: ivegtflg(maxgrds) 
     integer :: isoilflg(maxgrds) 
     integer :: ndviflg(maxgrds) 
     integer :: nofilflg(maxgrds) 
     integer            :: iupdndvi 
     integer            :: iupdsst 
     character(len=f_name_length) :: itoptfn(maxgrds) 
     character(len=f_name_length) :: isstfn(maxgrds) 
     character(len=f_name_length) :: ivegtfn(maxgrds) 
     character(len=f_name_length) :: isoilfn(maxgrds) 
     character(len=f_name_length) :: ndvifn(maxgrds) 
     integer :: itopsflg(maxgrds) 
     real  :: toptenh(maxgrds) 
     real  :: toptwvl(maxgrds) 
     integer :: iz0flg(maxgrds) 
     real  :: z0max(maxgrds) 
     real  :: z0fact 
     integer            :: mkcoltab 
     character(len=f_name_length) :: coltabfn 
     character(len=f_name_length) :: mapaotfile

     ! namelist /MODEL_OPTIONS/ &
     integer :: advmnt
     integer :: ghostzonelength
     integer :: naddsc 
     integer :: icorflg
     integer :: dyncore_flag
!--(DMK-CCATT-INI)-----------------------------------------------------------
     integer :: iexev
     integer :: imassflx
     integer :: vveldamp
!--(DMK-CCATT-FIM)-----------------------------------------------------------
     integer :: ibnd 
     integer :: jbnd 
     real :: cphas 
     integer :: lsflg 
     integer :: nfpt 
     real :: distim  
     integer :: iswrtyp 
     integer :: ilwrtyp 
     character(LEN=f_name_length) :: raddatfn 
     real    :: radfrq 
     integer :: lonrad 
     integer :: nnqparm(maxgrds) 
     character(len=2) :: closure_type  
     integer :: nnshcu(maxgrds) 
     real :: confrq              
     real    :: shcufrq 
     real :: wcldbs 
     
     integer :: g3d_spread
     integer :: g3d_smoothh
     integer :: g3d_smoothv
                  
     integer :: npatch                      
     integer :: nvegpat 
     integer :: isfcl 

     integer :: nvgcon 
     real    :: pctlcon 
     integer :: nslcon 
     real    :: drtcon 
     real    :: zrough 
     real    :: albedo 
     real    :: seatmp 
     real    :: dthcon 
     character(len=1)   :: soil_moist       
     character(len=1)   :: soil_moist_fail  
     character(len=f_name_length) :: usdata_in        
     character(len=f_name_length) :: usmodel_in       
     real    :: slz(nzgmax) 
     real    :: slmstr(nzgmax) 
     real    :: stgoff(nzgmax) 
     integer :: if_urban_canopy 
     integer :: idiffk(maxgrds) 
     integer :: ihorgrad        
     real    :: csx(maxgrds)    
     real    :: csz(maxgrds)    
     real    :: xkhkm(maxgrds)  
     real    :: zkhkm(maxgrds)  
     real    :: akmin(maxgrds)  
     integer            :: mcphys_type 
     integer            :: idriz 
     integer            :: iccnlev
     integer            :: irime
     integer            :: iplaws
      
     integer            :: level 
     integer            :: icloud 
     integer            :: irain 
     integer            :: ipris 
     integer            :: isnow 
     integer            :: iaggr 
     integer            :: igraup 
     integer            :: ihail 
     real               :: cparm 
     real               :: rparm 
     real               :: pparm 
     real               :: sparm 
     real               :: aparm 
     real               :: gparm 
     real               :: hparm 
     real               :: dparm 
     real               :: cnparm
     real               :: gnparm
     real               :: epsil
      
     real               :: gnu(ncat_dummy) 

     !namelist /MODEL_SOUND/ &

     integer             :: ipsflg 
     integer             :: itsflg 
     integer             :: irtsflg 
     integer             :: iusflg 
     real                :: hs(maxsndg) 
     real                :: ps(maxsndg) 
     real                :: ts(maxsndg) 
     real                :: rts(maxsndg) 
     real                :: us(maxsndg) 
     real                :: vs(maxsndg) 

     !namelist /MODEL_PRINT/ &

     integer            :: nplt 
     character(len=16)  :: iplfld(50) 
     integer            :: ixsctn(50) 
     integer            :: isbval(50) 

     !namelist /ISAN_CONTROL/ &

     integer :: iszstage
     integer :: ivrstage
     integer :: isan_inc
     character(len=8)   :: guess1st
     integer :: i1st_flg
     integer :: iupa_flg
     integer :: isfc_flg
     character(len=256) :: iapr
     character(len=256) :: iarawi
     character(len=256) :: iasrfce
     character(len=256) :: varpfx
     integer :: ioflgisz
     integer :: ioflgvar

     !namelist /ISAN_ISENTROPIC/ &

     integer                    :: nisn
     integer                    :: levth(maxisn)
     integer                    :: nigrids
     real                       :: topsigz
     real                       :: hybbot
     real                       :: hybtop
     real                       :: sfcinf
     real                       :: sigzwt
     integer                    :: nfeedvar
     integer                    :: maxsta
     integer                    :: maxsfc
     integer                    :: notsta
     character(len=8)           :: notid(50)
     integer                    :: iobswin
     real                       :: stasep
     integer                    :: igridfl
     real                       :: gridwt(maxagrds)
     real                       :: gobsep
     real                       :: gobrad
     real                       :: wvlnth(maxagrds)
     real                       :: respon(maxagrds)
     real                       :: swvlnth(maxagrds)

     !namelist POST

     integer                       :: nvp
     character(len=f_name_length)  :: vp(200)
     character(len=f_name_length)  :: gprefix
     character(len=10)             :: anl2gra
     character(len=10)             :: proj
     character(len=3)              :: mean_type
     real                          :: lati(maxgrds)
     real                          :: loni(maxgrds)
     real                          :: latf(maxgrds)
     real                          :: lonf(maxgrds)
     integer                       :: zlevmax(maxgrds)
     integer                       :: ipresslev
     integer                       :: inplevs
     integer                       :: iplevs(nzpmax)
     character(len=10)             :: mechanism
     character(len=20)             :: ascii_data
     real                          :: site_lat
     real                          :: site_lon
	
     !namelist digital filter
     logical :: applyDigitalFilter
     real    :: digitalFilterTimeWindow
	
     !namelist meteogram
     logical                      :: applyMeteogram
     real                         :: meteogramFreq
     character(len=f_name_length) :: meteogramMap
     character(len=f_name_length) :: meteogramDir

  end type namelistFile
  
contains





  subroutine CreateNamelistFile(oneNamelistFile)
    implicit none
    type(namelistFile), pointer :: oneNamelistFile
    if (associated(oneNamelistFile)) then
       deallocate(oneNamelistFile)
    end if
    allocate(oneNamelistFile)
  end subroutine CreateNamelistFile




  subroutine DestroyNamelistFile(oneNamelistFile)
    implicit none
    type(namelistFile), pointer :: oneNamelistFile
    if (associated(oneNamelistFile)) then
       deallocate(oneNamelistFile)
    end if
    nullify(oneNamelistFile)
  end subroutine DestroyNamelistFile



  subroutine GetNamelistFileName(oneNamelistFile)
    implicit none
    type(namelistFile), pointer :: oneNamelistFile

    integer :: nargs
    integer :: iarg
    integer :: lenArg
    integer :: status
    logical :: flagName ! true iff arg="-f"; next arg is file name
    character(len=f_name_length) :: arg

    oneNamelistFile%fileName="RAMSIN" ! default namelist

    ! search command line for "-f " <namelist file name> 
    ! return default if not found

    nargs = command_argument_count()
    if (nargs >= 0) then
       flagName = .false.
       do iarg = 0, nargs
          call get_command_argument(iarg, arg, lenArg, status)
          if (status == 0) then
             if (flagName) then
                oneNamelistFile%fileName = arg(1:lenArg)
                exit
             else
                flagName = arg(1:lenArg) == "-f"
             end if
          end if
       end do
    end if
  end subroutine GetNamelistFileName


  ! ReadNamelistFile:
  !    open, reads and close namelist file
  !    implements defaults for namelist variables
  !    check input options consistency


  subroutine ReadNamelistFile(oneNamelistFile)

    implicit none
    type(namelistFile), pointer :: oneNamelistFile

    include "files.h"



    integer :: i                        ! loop count
    integer :: iunit                    ! io unit number
    integer, parameter :: firstUnit=20  ! lowest io unit number available
    integer, parameter :: lastUnit=99   ! highest io unit number available
    logical :: op                       ! io unit number opened or not
    logical :: ex                       ! namelist file exists?
    integer :: err                      ! return code on iostat
    character(len=10) :: c0             ! scratch
    character(len=*), parameter :: h="**(ReadNamelistFile)**"  ! program unit name

    ! namelist /MODEL_GRID/

    character(len=64) :: expnme            
    character(len=16) :: runtype 
    character(len=1)  :: timeunit 
    real    :: timmax 
    integer :: load_bal           
    integer :: imonth1 
    integer :: idate1 
    integer :: iyear1 
    integer :: itime1 
    integer :: ngrids                      
    integer :: nnxp(maxgrds)       
    integer :: nnyp(maxgrds)       
    integer :: nnzp(maxgrds)       
    integer :: nzg                         
    integer :: nzs                         
    integer :: nxtnest(maxgrds)            
    character(len=f_name_length) :: domain_fname 
    integer :: if_adap 
    integer :: ihtran 
    real :: deltax 
    real :: deltay 
    real :: deltaz 
    real :: dzrat 
    real :: dzmax 
    real :: zz(nzpmax) 
    real :: dtlong 
    integer :: nacoust 
    integer :: ideltat 
    integer :: nstratx(maxgrds)            
    integer :: nstraty(maxgrds)            
    integer :: nndtrat(maxgrds)            
    integer :: nestz1 
    integer :: nstratz1(nzpmax) 
    integer :: nestz2 
    integer :: nstratz2(nzpmax) 
    real :: polelat 
    real :: polelon 
    real :: centlat(maxgrds)               
    real :: centlon(maxgrds)               
    integer :: ninest(maxgrds)             
    integer :: njnest(maxgrds)             
    integer :: nknest(maxgrds)             
    integer :: nnsttop(maxgrds) 
    integer :: nnstbot(maxgrds) 
    real :: gridu(maxgrds) 
    real :: gridv(maxgrds) 

    namelist /MODEL_GRIDS/                                               &
         expnme, runtype, timeunit, timmax, load_bal, imonth1, idate1,   &
         iyear1, itime1, ngrids, nnxp, nnyp, nnzp, nzg, nzs, nxtnest,    &
         domain_fname,                                                   &
         if_adap, ihtran, deltax, deltay, deltaz, dzrat, dzmax, zz,      &
         dtlong, nacoust, ideltat, nstratx, nstraty, nndtrat, nestz1,    &
         nstratz1, nestz2, nstratz2, polelat, polelon, centlat, centlon, &
         ninest, njnest, nknest, nnsttop, nnstbot, gridu, gridv
!--(DMK-CCATT-FIM)-----------------------------------------------------------


!    ! namelist /CATT_INFO/
!
!    integer :: catt
!    character(len=256) :: firemapfn 
!    integer :: recycle_tracers 
!    integer :: plumerise 
!    integer :: define_proc 
!    real :: prfrq             

!--(DMK-CCATT-INI)-----------------------------------------------------------
    ! namelist /CCATT_INFO/

    integer :: ccatt
    integer :: chemistry
    character(len=20) :: split_method
    real    :: chem_timestep
    integer :: chemistry_aq
    !integer :: aerosol
    integer :: chem_assim
    character(len=256) :: srcmapfn
    integer :: recycle_tracers 
    character(len=32) :: def_proc_src
    integer :: diur_cycle(nsrc)            
    integer :: na_extra2d
    integer :: na_extra3d
    integer :: plumerise 
    real :: prfrq             
    integer :: volcanoes
    !Matrix
    INTEGER :: aerosol
    REAL :: aer_timestep
    integer :: aer_assim
    integer :: mech

!--(DMK-CCATT-FIM)-----------------------------------------------------------

!--(DMK-CCATT-INI)-----------------------------------------------------------
    namelist /CCATT_INFO/                                                &
         ccatt,                                                          &                             
         chemistry, split_method, chem_timestep, chemistry_aq,  &
         chem_assim, srcmapfn, recycle_tracers, def_proc_src, diur_cycle,&
         na_extra2d, na_extra3d, plumerise, prfrq, volcanoes, aerosol, &
	 aer_timestep, aer_assim, mech
!--(DMK-CCATT-OLD)-----------------------------------------------------------
!    namelist /CATT_INFO/                                                 &
!         catt,                                                           &
!         firemapfn, recycle_tracers,                                     &
!         plumerise, define_proc, prfrq
!--(DMK-CCATT-FIM)-----------------------------------------------------------

    ! namelist /TEB_SPM_INFO/

    integer :: teb_spm 
    character(len=f_name_length) :: fusfiles 
    integer :: ifusflg(maxgrds) 
    character(len=f_name_length) :: ifusfn(maxgrds) 
    integer             :: ichemi    
    integer             :: ichemi_in   
    character (len=f_name_length) :: chemdata_in 
    integer             :: isource     
    character(len=3)    :: weekdayin   
    real            :: rushh1    
    real            :: rushh2    
    real            :: daylight  
    real                :: efsat 
    real                :: efsun 
    real                :: eindno  
    real                :: eindno2 
    real                :: eindpm 
    real                :: eindco 
    real                :: eindso2 
    real                :: eindvoc 
    real                :: eveino  
    real                :: eveino2 
    real                :: eveipm  
    real                :: eveico  
    real                :: eveiso2 
    real                :: eveivoc 
    integer         :: iteb 
    real            :: tminbld   
    integer         :: nteb 
    real            :: hc_roof(maxsteb) 
    real            :: tc_roof(maxsteb) 
    real            :: d_roof(maxsteb) 
    real            :: hc_road(maxsteb) 
    real            :: tc_road(maxsteb) 
    real            :: d_road(maxsteb) 
    real            :: hc_wall(maxsteb) 
    real            :: tc_wall(maxsteb) 
    real            :: d_wall(maxsteb) 
    integer         :: nurbtype    
    integer         :: ileafcod(maxubtp)   
    real            :: z0_town(maxubtp) 
    real            :: bld(maxubtp) 
    real            :: bld_height(maxubtp) 
    real            :: bld_hl_ratio(maxubtp) 
    real            :: aroof(maxubtp) 
    real            :: eroof(maxubtp) 
    real            :: aroad(maxubtp) 
    real            :: eroad(maxubtp) 
    real            :: awall(maxubtp) 
    real            :: ewall(maxubtp) 
    real            :: htraf(maxubtp) 
    real            :: hindu(maxubtp) 
    real            :: pletraf(maxubtp) 
    real            :: pleindu(maxubtp) 

    namelist /TEB_SPM_INFO/                                              &
         teb_spm,                                                        &
         fusfiles, ifusflg, ifusfn,                                      &
         ichemi, ichemi_in, chemdata_in, isource, weekdayin, rushh1,     &
         rushh2, daylight, efsat, efsun, eindno, eindno2, eindpm,        &
         eindco, eindso2, eindvoc, eveino, eveino2, eveipm, eveico,      &
         eveiso2, eveivoc, iteb, tminbld, nteb, hc_roof, tc_roof,        &
         d_roof, hc_road, tc_road, d_road, hc_wall, tc_wall, d_wall,     &
         nurbtype, ileafcod, z0_town, bld, bld_height, bld_hl_ratio,     &
         aroof, eroof, aroad, eroad, awall, ewall, htraf, hindu,         &
         pletraf, pleindu


    !namelist /MODEL_FILE_INFO/

    integer :: initial 
    integer :: nud_type 
    character(len=f_name_length)       :: varfpfx 
    real :: vwait1 
    real :: vwaittot 
    character(len=f_name_length) :: nud_hfile 
    integer :: nudlat 
    real :: tnudlat 
    real :: tnudcent 
    real :: tnudtop 
    real :: znudtop 
    real :: wt_nudge_grid(maxgrds) 
    real :: wt_nudge_uv 
    real :: wt_nudge_th 
    real :: wt_nudge_pi 
    real :: wt_nudge_rt 
    integer :: nud_cond 
    character(len=f_name_length) :: cond_hfile 
    real :: tcond_beg  
    real :: tcond_end  
    real :: t_nudge_rc  
    real :: wt_nudgec_grid(maxgrds) 
    integer            :: if_oda 
    character(len=128) :: oda_upaprefix 
    character(len=128) :: oda_sfcprefix 
    real               :: frqoda 
    real               :: todabeg 
    real               :: todaend 
    real               :: tnudoda 
    real               :: wt_oda_grid(maxodagrids) 
    real               :: wt_oda_uv 
    real               :: wt_oda_th 
    real               :: wt_oda_pi 
    real               :: wt_oda_rt 
    real               :: roda_sfce(maxodagrids) 
    real               :: roda_sfc0(maxodagrids) 
    real               :: roda_upae(maxodagrids) 
    real               :: roda_upa0(maxodagrids) 
    real               :: roda_hgt(maxodagrids) 
    real               :: roda_zfact(maxodagrids) 
    real               :: oda_sfc_til 
    real               :: oda_sfc_tel 
    real               :: oda_upa_til 
    real               :: oda_upa_tel 
    integer :: if_cuinv             
    character(len=128) :: cu_prefix 
    real :: tnudcu                  
    real :: wt_cu_grid(maxcugrids)  
    real :: tcu_beg                 
    real :: tcu_end                 
    real :: cu_tel                  
    real :: cu_til                  
    real :: timstr 
    character(len=f_name_length) :: hfilin 
    integer :: ipastin 
    character(len=f_name_length) :: pastfn 
    integer :: ioutput 
    character(len=f_name_length) :: hfilout 
    character(len=f_name_length) :: afilout 
    integer :: iclobber 
    integer :: ihistdel 
    real :: frqhis 
    real :: frqanl 
    real :: frqlite
    integer :: ipos
    character(len=20)  :: xlite 
    character(len=20)  :: ylite 
    character(len=20)  :: zlite 
    integer :: nlite_vars 
    character(len=32)  :: lite_vars(maxlite) 
    real :: avgtim 
    real :: frqmean 
    real :: frqboth 
    integer :: kwrite 
    real             :: frqprt 
    integer            :: initfld 
    integer                :: prtcputime 
    character(len=f_name_length) :: topfiles 
    character(len=f_name_length) :: sfcfiles 
    character(len=f_name_length) :: sstfpfx 
    character(len=f_name_length) :: ndvifpfx 
    integer :: itoptflg(maxgrds) 
    integer :: isstflg(maxgrds) 
    integer :: ivegtflg(maxgrds) 
    integer :: isoilflg(maxgrds) 
    integer :: ndviflg(maxgrds) 
    integer :: nofilflg(maxgrds) 
    integer            :: iupdndvi 
    integer            :: iupdsst 
    character(len=f_name_length) :: itoptfn(maxgrds) 
    character(len=f_name_length) :: isstfn(maxgrds) 
    character(len=f_name_length) :: ivegtfn(maxgrds) 
    character(len=f_name_length) :: isoilfn(maxgrds) 
    character(len=f_name_length) :: ndvifn(maxgrds) 
    integer :: itopsflg(maxgrds) 
    real  :: toptenh(maxgrds) 
    real  :: toptwvl(maxgrds) 
    integer :: iz0flg(maxgrds) 
    real  :: z0max(maxgrds) 
    real  :: z0fact 
    integer            :: mkcoltab 
    character(len=f_name_length) :: coltabfn 
    character(len=f_name_length) :: mapaotfile

    namelist /MODEL_FILE_INFO/                                           &
         initial, nud_type, varfpfx, vwait1, vwaittot, nud_hfile, nudlat,&
         tnudlat, tnudcent, tnudtop, znudtop, wt_nudge_grid, wt_nudge_uv,&
         wt_nudge_th, wt_nudge_pi, wt_nudge_rt, nud_cond, cond_hfile,    &
         tcond_beg, tcond_end, t_nudge_rc, wt_nudgec_grid, if_oda,       &
         oda_upaprefix,oda_sfcprefix, frqoda, todabeg, todaend, tnudoda, &
         wt_oda_grid, wt_oda_uv, wt_oda_th, wt_oda_pi, wt_oda_rt,        &
         roda_sfce, roda_sfc0, roda_upae,roda_upa0, roda_hgt,            &
         roda_zfact, oda_sfc_til, oda_sfc_tel, oda_upa_til, oda_upa_tel, &
         if_cuinv, cu_prefix, tnudcu, wt_cu_grid, tcu_beg, tcu_end,      &
         cu_tel, cu_til, timstr, hfilin, ipastin, pastfn, ioutput,       &
         hfilout, afilout, iclobber, ihistdel, frqhis, frqanl, frqlite,  &
         xlite, ylite, zlite, nlite_vars, lite_vars,                     &
         ipos,                                                           &
         avgtim, frqmean,                                                &
         frqboth, kwrite, frqprt, initfld, prtcputime, topfiles,         &
         sfcfiles, sstfpfx, ndvifpfx, itoptflg, isstflg, ivegtflg,       &
         isoilflg, ndviflg, nofilflg, iupdndvi, iupdsst, itoptfn, isstfn,&
         ivegtfn, isoilfn, ndvifn, itopsflg, toptenh, toptwvl, iz0flg,   &
         z0max, z0fact, mkcoltab, coltabfn, mapaotfile

    ! namelist /MODEL_OPTIONS/

    integer :: naddsc 
    integer :: icorflg
    integer :: dyncore_flag
!--(DMK-CCATT-INI)-----------------------------------------------------------
    integer :: iexev
    integer :: imassflx
    integer :: vveldamp
!--(DMK-CCATT-FIM)-----------------------------------------------------------
    integer :: ibnd 
    integer :: jbnd 
    real :: cphas 
    integer :: lsflg 
    integer :: nfpt 
    real :: distim  
    integer :: iswrtyp 
    integer :: ilwrtyp 
    character(LEN=f_name_length) :: raddatfn 
    real    :: radfrq 
    integer :: lonrad 
    integer :: nnqparm(maxgrds) 
    character (len=2) :: closure_type  
    integer :: nnshcu(maxgrds) 
    real :: confrq              
    real    :: shcufrq 
    real :: wcldbs    
    integer :: g3d_spread
    integer :: g3d_smoothh
    integer :: g3d_smoothv          
    integer :: npatch                      
    integer :: nvegpat 
    integer :: isfcl 
    integer :: nvgcon 
    real    :: pctlcon 
    integer :: nslcon 
    real    :: drtcon 
    real    :: zrough 
    real    :: albedo 
    real    :: seatmp 
    real    :: dthcon 
    character(len=1)   :: soil_moist       
    character(len=1)   :: soil_moist_fail  
    character(len=f_name_length) :: usdata_in        
    character(len=f_name_length) :: usmodel_in       
    real    :: slz(nzgmax) 
    real    :: slmstr(nzgmax) 
    real    :: stgoff(nzgmax) 
    integer :: if_urban_canopy 
    integer :: idiffk(maxgrds) 
    integer :: ihorgrad        
    real    :: csx(maxgrds)    
    real    :: csz(maxgrds)    
    real    :: xkhkm(maxgrds)  
    real    :: zkhkm(maxgrds)  
    real    :: akmin(maxgrds)  
    integer            :: mcphys_type 
    integer            :: idriz 
    integer	       :: iccnlev
    integer	       :: irime
    integer	       :: iplaws
    integer            :: level 
    integer            :: icloud 
    integer            :: irain 
    integer            :: ipris 
    integer            :: isnow 
    integer            :: iaggr 
    integer            :: igraup 
    integer            :: ihail 
    real               :: cparm 
    real               :: rparm 
    real               :: pparm 
    real               :: sparm 
    real               :: aparm 
    real               :: gparm 
    real               :: hparm 
    real               :: dparm 
    real	       :: cnparm
    real	       :: gnparm
    real	       :: epsil
    real               :: gnu(ncat_dummy) 
    INTEGER            :: advmnt
    INTEGER            :: GhostZoneLength   

    namelist /MODEL_OPTIONS/ &
!--(DMK-CCATT-INI)-----------------------------------------------------------
         dyncore_flag,advmnt, GhostZoneLength,                                         &
         naddsc, icorflg,                                                 &
!--(DMK-CCATT-INI)-----------------------------------------------------------
         iexev, imassflx, vveldamp,                                        &
!--(DMK-CCATT-FIM)-----------------------------------------------------------
         ibnd, jbnd, cphas, lsflg, nfpt, distim,          &
         iswrtyp, ilwrtyp,                                                 &
         raddatfn,                                                         &
         radfrq, lonrad, nnqparm, closure_type, nnshcu, confrq,            &
         shcufrq, wcldbs, g3d_spread, g3d_smoothh, g3d_smoothv, npatch,    &
	 nvegpat, isfcl, nvgcon,                          &
         pctlcon, nslcon, drtcon, zrough, albedo, seatmp, dthcon,          &
         soil_moist, soil_moist_fail, usdata_in, usmodel_in, slz, slmstr,  &
         stgoff, if_urban_canopy, idiffk, ihorgrad, csx, csz, xkhkm, zkhkm,&
         akmin, mcphys_type, level, idriz, icloud, irain, ipris, isnow, iaggr,&
	 igraup, ihail,irime, iplaws,iccnlev, &
         cparm, rparm, pparm, sparm, aparm, gparm, hparm,  dparm,cnparm,&
	 epsil,gnparm,gnu

    !namelist /MODEL_SOUND/

    integer             :: ipsflg 
    integer             :: itsflg 
    integer             :: irtsflg 
    integer             :: iusflg 
    real                :: hs(maxsndg) 
    real                :: ps(maxsndg) 
    real                :: ts(maxsndg) 
    real                :: rts(maxsndg) 
    real                :: us(maxsndg) 
    real                :: vs(maxsndg) 

    namelist /MODEL_SOUND/ &
         ipsflg, itsflg, irtsflg, iusflg, hs, ps, ts, rts, us, vs

    !namelist /MODEL_PRINT/

    integer            :: nplt 
    character(len=16)  :: iplfld(50) 
    integer            :: ixsctn(50) 
    integer            :: isbval(50) 

    namelist /MODEL_PRINT/ &
         nplt, iplfld, ixsctn, isbval

    !namelist /ISAN_CONTROL/

    integer :: iszstage
    integer :: ivrstage
    integer :: isan_inc
    character(len=8)   :: guess1st
    integer :: i1st_flg
    integer :: iupa_flg
    integer :: isfc_flg
    character(len=256) :: iapr
    character(len=256) :: iarawi
    character(len=256) :: iasrfce
    character(len=256) :: varpfx
    integer :: ioflgisz
    integer :: ioflgvar

    namelist /ISAN_CONTROL/ &
         iszstage, ivrstage, isan_inc, guess1st, i1st_flg, iupa_flg,       &
         isfc_flg, iapr, iarawi, iasrfce, varpfx, ioflgisz, ioflgvar

    !namelist /ISAN_ISENTROPIC/

    integer                    :: nisn
    integer                    :: levth(maxisn)
    integer                    :: nigrids
    real                       :: topsigz
    real                       :: hybbot
    real                       :: hybtop
    real                       :: sfcinf
    real                       :: sigzwt
    integer                    :: nfeedvar
    integer                    :: maxsta
    integer                    :: maxsfc
    integer                    :: notsta
    character(len=8)           :: notid(50)
    integer                    :: iobswin
    real                       :: stasep
    integer                    :: igridfl
    real                       :: gridwt(maxagrds)
    real                       :: gobsep
    real                       :: gobrad
    real                       :: wvlnth(maxagrds)
    real                       :: respon(maxagrds)
    real                       :: swvlnth(maxagrds)

    namelist /ISAN_ISENTROPIC/ &
         nisn, levth, nigrids, topsigz, hybbot, hybtop, sfcinf, sigzwt,    &
         nfeedvar, maxsta, maxsfc, notsta, notid, iobswin, stasep, igridfl,&
         gridwt, gobsep, gobrad, wvlnth, swvlnth, respon

    !namelist POST

    integer                       :: nvp
    character(len=f_name_length)  :: vp(200)
    character(len=f_name_length)  :: gprefix
    character(len=10)             :: anl2gra
    character(len=10)             :: proj
    character(len=3)              :: mean_type
    real                          :: lati(maxgrds)
    real                          :: loni(maxgrds)
    real                          :: latf(maxgrds)
    real                          :: lonf(maxgrds)
    integer                       :: zlevmax(maxgrds)
    integer                       :: ipresslev
    integer                       :: inplevs
    integer                       :: iplevs(nzpmax)
    character(len=10)             :: mechanism
    character(len=20)             :: ascii_data
    real                          :: site_lat
    real                          :: site_lon
    namelist /POST/ &
         nvp, vp, gprefix, anl2gra, proj, mean_type, lati, loni, &
         latf, lonf, zlevmax, ipresslev, inplevs, iplevs, &
         mechanism, ascii_data, site_lat, site_lon
    
	!namelist digital filter
	logical :: applyDigitalFilter
	real	:: digitalFilterTimeWindow
     namelist /DIGITALFILTER/ &
	       applyDigitalFilter, digitalFilterTimeWindow


     logical                      :: applyMeteogram
     real                         :: meteogramFreq
     character(len=f_name_length) :: meteogramMap
     character(len=f_name_length) :: meteogramDir
	       
     namelist /METEOGRAM/ &
     applyMeteogram,      &
     meteogramFreq,       &
     meteogramMap,        &
     meteogramDir

!--(DMK-CCATT-INI)-----------------------------------------------------------
    ! CCATT_INFO
    ccatt               = 0
    chemistry           = 0
    split_method        = ''
    chem_timestep       = 0.
    chemistry_aq        = 0
!    aerosol             = 0
    chem_assim          = 0
    srcmapfn            = ''
    recycle_tracers     = 0
    def_proc_src        = 'STOP'
    diur_cycle(1:nsrc)  = 1
    na_extra2d          = 0
    na_extra3d          = 0
    plumerise           = 0
    prfrq               = 3600. ! Initial Value for PlumeRise Frequency - CCATT
    volcanoes           = 0
!Matrix
    aerosol             = 0
    aer_timestep        = 0.
    aer_assim           = 0
    mech                = 8
!--(DMK-CCATT-OLD)-----------------------------------------------------------
!    ! CATT_INFO
!    catt                = 0
!    firemapfn           = ''
!    recycle_tracers     = 0
!    plumerise           = 0
!    define_proc         = 0
!    prfrq               = 3600. ! Initial Value for PlumeRise Frequency - CATT
!--(DMK-CCATT-FIM)-----------------------------------------------------------

    ! ISAN_CONTROL
    iszstage            = 1
    ivrstage            = 1
    isan_inc            = 0600
    guess1st	      = 'PRESS'
    i1st_flg	      = 1
    iupa_flg	      = 3
    isfc_flg	      = 3
    iapr		      = './dprep/dp' ! 2
    iarawi	      = ''
    iasrfce	      = ''
    varpfx	      = './ivar/iv-brams4' ! 2
    ioflgisz 	      = 0
    ioflgvar 	      = 1

    ! ISAN_ISENTROPIC
    nisn                = 43
    levth               = 800
    levth(1:nisn)       = (/280,282,284,286,288,290,292,294,296,298,300,303,306,309,&
         312,315,318,321,324,327,330,335,340,345,350,355,360,380,400,420,440, &
         460,480,500,520,540,570,600,630,670,700,750,800/)
    nigrids             = 1
    topsigz	      = 20000.
    hybbot	      = 4000.
    hybtop	      = 6000.
    sfcinf	      = 1000.
    sigzwt	      = 1.
    nfeedvar            = 1.
    maxsta 	      = 150
    maxsfc 	      = 1000
    notsta 	      = 0
    notid               = ''
    iobswin	      = 1800
    stasep	      = .1
    igridfl	      = 3
    gridwt	      = .01
    gobsep	      = 5.
    gobrad	      = 5.
    wvlnth	      = 1000
    swvlnth	      = 500.
    respon	      = .90

    ! MODEL_FILE_INFO
    initial	      = 2 ! 2
    nud_type	      = 2 ! 2
    varfpfx	      = varpfx ! will be rewrited on the namelist read, and after too
    vwait1	      = 0.
    vwaittot	      = 0.
    nud_hfile	      = '' ! 2
    nudlat	      = 5 ! 2
    tnudlat	      = 1800. ! 2
    tnudcent	      = 0. ! 2
    tnudtop	      = 10800. ! 2
    znudtop	      = 16000. ! 2
    wt_nudge_grid       = 1. ! 2
    wt_nudge_grid(1:4)  = (/1.,0.8,0.7,0.5/) ! 2
    wt_nudge_uv	      = 1.
    wt_nudge_th	      = 1.
    wt_nudge_pi	      = 1.
    wt_nudge_rt	      = 1.
    nud_cond	      = 0
    cond_hfile	      = ''
    tcond_beg	      = 0.
    tcond_end	      = 21600.
    t_nudge_rc	      = 3600.
    wt_nudgec_grid      = 0.5
    wt_nudgec_grid(1:4) = (/1.,0.8,0.7,0.5/)
    if_oda	      = 0
    oda_upaprefix       = ''
    oda_sfcprefix       = ''
    frqoda 	      = 300.
    todabeg	      = 0.
    todaend	      = 9999999.
    tnudoda	      = 900.
    wt_oda_grid         = 1.
    wt_oda_grid(1:4)    = (/1.,0.8,0.7,0.5/)
    wt_oda_uv	      = 1.
    wt_oda_th	      = 1.
    wt_oda_pi	      = 1.
    wt_oda_rt	      = 1.
    roda_sfce	      = 0.
    roda_sfce(1:4)      = (/50000.,100.,100.,100./)
    roda_sfc0           = 0.
    roda_sfc0(1:4)      = (/100000.,100000.,100000.,100000./)
    roda_upae           = 0.
    roda_upae(1:4)      = (/100000.,200.,200.,200./)
    roda_upa0           = 0.
    roda_upa0(1:4)      = (/200000.,2000.,2000.,2000./)
    roda_hgt            = 0.
    roda_hgt(1:4)       = (/3000.,3000.,3000.,3000./)
    roda_zfact          = 0.
    roda_zfact(1:4)     = (/100.,100.,100.,100./)
    oda_sfc_til 	      = 21600.
    oda_sfc_tel 	      = 900.
    oda_upa_til 	      = 43200.
    oda_upa_tel 	      = 21600.
    oda_upa_tel 	      = 21600.
    if_cuinv            = 0
    cu_prefix           = ''
    tnudcu              = 900.
    wt_cu_grid          = 1.
    wt_cu_grid(1:4)     = (/1.,1.,0.5,0.5/)
    tcu_beg	      = 0.
    tcu_end	      = 7200.
    cu_tel 	      = 3600.
    cu_til 	      = 21600.
    timstr 	      = 0
    hfilin 	      = ''
    ipastin	      = 0 ! 2
    pastfn 	      = '' ! 2
    ioutput	      = 2 ! 2
    hfilout	      = './H/H-brams4' ! 2
    afilout	      = './A/A-brams4' ! 2
    iclobber 	      = 0 ! 2
    ihistdel 	      = 0 ! 2
    ipos              = 0
    frqhis	      = 21600. ! 2
    frqanl	      = 10800. ! 2
    frqlite             = 0.
    xlite 	      = '/0:0/'
    ylite 	      = '/0:0/'
    zlite 	      = '/0:0/'
    nlite_vars	      = 4
    lite_vars 	      = ''
    lite_vars(1)        = 'UP'
    lite_vars(2)        = 'VP'
    lite_vars(3)        = 'WP'
    lite_vars(4)        = 'THETA'
    avgtim 	      = 0.
    frqmean	      = 0.
    frqboth	      = 0.
    kwrite 	      = 0
    frqprt 	      = 21600.
    initfld	      = 1
    topfiles	      = './data/toph-'
    sfcfiles	      = './data/sfc-'
    sstfpfx 	      = './data/sst-'
    ndvifpfx	      = './data/ndvi-'
    itoptflg	      = 2 ! 2
    itoptflg(1:4)       = (/2,2,2,2/) ! 2
    isstflg             = 2 ! 2
    isstflg(1:4)        = (/2,2,2,2/) ! 2
    ivegtflg            = 2 ! 2
    ivegtflg(1:4)       = (/2,2,2,2/) ! 2
    isoilflg            = 2 ! 2
    isoilflg(1:4)       = (/2,2,2,2/) ! 2
    ndviflg             = 2 ! 2
    ndviflg(1:4)        = (/2,2,2,2/) ! 2
    nofilflg            = 2
    nofilflg(1:4)       = (/2,2,2,2/)
    iupdndvi            = 1
    iupdsst	      = 1
    itoptfn	      = ''
    itoptfn(1)          = './topo10km/H'
    itoptfn(2:4)        = (/'./topo/EL','./topo/EL','./topo/EL'/)
    isstfn              = ''
    isstfn(1:4)         = (/'./sst/S','./sst/S','./sst/S','./sst/S'/)
    ivegtfn             = ''
    ivegtfn(1:4)        = (/'./soil-fao/FAO','./soil-fao/FAO','./soil-fao/FAO','./soil-fao/FAO'/)
    isoilfn             = ''
    isoilfn(1:4)        = (/'./oge_brams4/OGE','./oge_brams4/OGE','./oge_brams4/OGE','./oge_brams4/OGE'/)
    ndvifn              = ''
    ndvifn(1:4)         = (/'./ndvi-modis/N','./ndvi-modis/N','./ndvi-modis/N','./ndvi-modis/N'/)
    itopsflg            = 0
    itopsflg(1:4)       = (/0,0,0,0/)
    toptenh             = 1
    toptenh(1:4)        = (/1,1,1,1/)
    toptwvl             = 1
    toptwvl(1:4)        = (/1,1,1,1/)
    iz0flg              = 0
    iz0flg(1:4)         = (/0,0,0,0/)
    z0max               = 5.
    z0max(1:4)          = (/5.,5.,5.,5./)
    z0fact              = 0.005
    mkcoltab            = 0 ! duvida!
    coltabfn            = './micro/ct2.0' ! duvida!
    mapaotfile          = './tables2/rad_carma/infMapAOT.vfm'
    prtcputime          = 0

    ! MODEL_GRIDS
    expnme              = 'BRAMS 41' ! 2
    timeunit 	      = 'h' ! 2
    load_bal 	      = 0
    ngrids 	      = 1 ! 2
    nzg    	      = 9 ! 2
    nzs    	      = 32
    nxtnest	      = 1 ! 2
    nxtnest(1:4)        = (/0,1,2,3/) ! 2
    if_adap	      = 0 ! 2
    ihtran 	      = 1
    deltaz 	      = 250 ! 2
    dzrat  	      = 1.2 ! 2
    dzmax  	      = 1000.
    zz     	      = 19700.
    zz(1:41)            = (/0.0,20.0,46.0,80.0,120.0,165.0,220.0,290.0,380.0,480.0,590.0, &
         720.0,870.0,1030.0,1200.0,1380.0,1595.0,1850.0,2120.0,2410.0,2715.0,  &
         3030.0,3400.0,3840.0,4380.0,5020.0,5800.0,6730.0,7700.0,8700.0,9700.0,&
         10700.,11700.,12700.,13700.,14700.,15700.,16700.,17700.,18700.,19700./)
    dtlong  	      = 30. ! 2
    nacoust 	      = 3
    ideltat 	      = 1 ! 2
    nstratx 	      = 3
    nstratx(1:4)        = (/1,3,3,3/)
    nstraty             = 3
    nstraty(1:4)        = (/1,3,3,3/)
    nndtrat             = 3
    nndtrat(1:4)        = (/1,3,3,3/)
    nestz1              = 0
    nstratz1            = 1
    nstratz1(1:4)       = (/2,2,2,1/)
    nestz2              = 0
    nstratz2            = 1
    nstratz2(1:4)       = (/3,3,2,1/)
    ninest              = 3 ! 2
    ninest(1:4)         = (/1,1,2,3/) ! 2
    njnest              = 3 ! 2
    njnest(1:4)         = (/1,1,2,3/) ! 2
    nknest              = 1
    nknest(1:4)         = (/1,1,1,1/)
    nnsttop             = 1
    nnsttop(1:4)        = (/1,1,1,1/)
    nnstbot             = 1
    nnstbot(1:4)        = (/1,1,1,1/)
    gridu               = 0.
    gridu(1:4)          = (/0.,0.,0.,0./)
    gridv               = 0.
    gridv(1:4)          = (/0.,0.,0.,0./)

!--(DMK-CCATT-INI)-----------------------------------------------------------
    dyncore_flag        = 0 !default value  
    advmnt              = 0
    ghostzonelength     = 1
!--(DMK-CCATT-FIM)-----------------------------------------------------------

    domain_fname        = ''

    ! MODEL_OPTIONS
    naddsc  	      = 0
    icorflg 	      = 1
!--(DMK-CCATT-INI)-----------------------------------------------------------
    iexev             = 1
    imassflx          = 0
    vveldamp          = 0
!--(DMK-CCATT-FIM)-----------------------------------------------------------
    ibnd    	      = 1
    jbnd    	      = 1
    cphas   	      = 20.
    lsflg   	      = 0
    nfpt    	      = 0
    distim  	      = 400.
    iswrtyp 	      = 1
    ilwrtyp 	      = 1
    raddatfn	      = "./carma/rad_param.data" ! 2
    radfrq  	      = 900. !2
    lonrad  	      = 1
    nnqparm 	      = 2
    closure_type      = "EN" ! 2
    nnshcu            = 1 ! 2
    nnshcu(1:4)       = (/1,1,1,1/) !2
    confrq            = 600. ! 2
    shcufrq           = 600. ! 2
    wcldbs            = .0005
    g3d_spread	      = 0
    g3d_smoothh	      = 0
    g3d_smoothv	      = 0
    npatch            = 2 ! 2
    nvegpat           = 1
    isfcl             = 1 ! 2
    nvgcon            = 6 ! 2
    pctlcon           = 1.
    nslcon 	      = 6 ! 2
    zrough 	      = .05
    albedo 	      = .2
    seatmp 	      = 298. ! 2
    dthcon 	      = 0.
    drtcon 	      = 0.
    soil_moist          = "i" ! 2
    soil_moist_fail     = "l" ! 2
    usdata_in  	      = "./soil-moisture/GL_SM.GMNR." ! 2
    usmodel_in 	      = "./data/SM-" ! 2
    slz        	      = -0.1 ! 2
    slz(1:9)   	      = (/-2.0,-1.75,-1.50,-1.25,-1.00,-0.75,-0.50,-0.25,-0.1/)
    slmstr     	      = 0.28 ! 2
    slmstr(1:9)	      = (/0.40,0.37,0.35,0.33,0.32,0.31,0.30,0.29,0.28/) ! 2
    stgoff     	      = 0.0
    stgoff(1:9)	      = (/0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0/)
    if_urban_canopy     = 0
    idiffk              = 1 ! 2
    idiffk(1:4)         = (/1,1,1,1/) ! 2
    ihorgrad            = 2
    csx                 = .2
    csx(1:4) 	      = (/.2,.2,.2,.2/)
    csz      	      = .2
    csz(1:4) 	      = (/.35,.35,.35,.35/)
    xkhkm    	      = 3.
    xkhkm(1:4) 	      = (/3.,3.,3.,3./)
    zkhkm      	      = 3.
    zkhkm(1:4) 	      = (/3.,3.,3.,3./)
    akmin      	      = 1.
    akmin(1:4) 	      = (/1.,1.,1.,1./)
    mcphys_type       = 0
    level  	      = 3 ! 2
    icloud 	      = 4 ! 2
    idriz 	      = 1 ! 2
    irime             = 0
    iplaws            = 0
    iccnlev           = 0
    irain  	      = 2 ! 2
    ipris  	      = 5
    isnow  	      = 2 ! 2
    iaggr  	      = 2 ! 2
    igraup 	      = 2 ! 2
    ihail  	      = 2 ! 2
    cparm  	      = .1e9
    rparm  	      = 1e-3
    pparm  	      = 0.
    sparm  	      = 1e-3
    aparm  	      = 1e-3
    gparm  	      = 1e-3
    hparm  	      = 3e-3
    dparm             = 1.e-5 
    cnparm            = 0.04e-4
    gnparm            = 3.00e-4
    epsil             = 0.1
    gnu    	      = 2.
    gnu(1:8)	      = (/2.,2.,2.,2.,2.,2.,2.,2./)

    ! MODEL_PRINT
    nplt   	      = 0
    iplfld 	      = ""
    ixsctn 	      = 3
    ixsctn(1:4)         = (/3,3,3,3/)
    isbval              = 2
    isbval(1:4)         = (/2,2,2,2/)

    ! MODEL_SOUND
    ipsflg  	      = 1 ! 2
    itsflg  	      = 0 ! 2
    irtsflg 	      = 3 ! 2
    iusflg  	      = 0 ! 2
    hs      	      = 0. ! 2
    ps(1:11)	      = (/1010.,1000.,2000.,3000.,4000.,6000.,8000.,11000.,15000.,20000.,25000./) ! 2
    ts(1:11)	      = (/25.,18.5,12.,4.5,-11.,-24.,-37.,-56.5,-56.5,-56.5,-56.5/) ! 2
    rts(1:11) 	      = (/70.,70.,70.,70.,20.,20.,20.,20.,10.,10.,10./) ! 2
    us(1:11)  	      = (/10.,10.,10.,10.,10.,10.,10.,10.,10.,10.,10./) ! 2
    vs(1:11)  	      = (/0.,0.,0.,0.,0.,0.,0.,0.,0.,0.,0./) ! 2

    ! TEB
    teb_spm  	      = 0
    fusfiles 	      = ''
    ifusflg  	      = 0
    ifusflg(1:4)        = (/1,1,1,1/)
    ifusfn 	      = ''
    ifusfn(1:4)	      = (/'./fusos/fuso','./fusos/fuso','./fusos/fuso','./fusos/fuso'/) ! 2
    ichemi     	      = 0    !Photochemical module activation - 1=on, 0=off
    ichemi_in  	      = 1    !Use initial values from previous run (1=yes,0=no) ! 2
    chemdata_in	      = ''
    isource    	      = 1    !Emission module activation - 1=on, 0=off ! 2
    weekdayin  	      = 'SUN'  !Initial weeakday of the simulation
    rushh1     	      = 7.81  !Morning Rush Hour (Local Time in Hours)
    rushh2     	      = 16.0  !Afternoon/Evening Rush Hour (Local Time)
    daylight   	      = 0.    !Daylight saving time (horario de verao)
    ! Emission factor (fraction of weekdays) for Saturdays and Sundays
    ! They are used in the emission module and TEB. - EDF
    efsat     	      = 0.8
    efsun     	      = 0.5
    ! Input GMT difference time variable (To define local time)
    !Industrial emissions (kg/s/m2)
    eindno     	      = 2.6636227e-10
    eindno2    	      = 2.9595805e-11
    eindpm     	      = 4.3421278e-10
    eindco     	      = 8.1599860e-10
    eindso2    	      = 3.6149164e-10
    eindvoc    	      = 2.5367833e-10 
    !Veicular emissions (kg/day/m2)
    eveino     	      = 4.3196708e-04
    eveino2    	      = 6.8566209e-05
    eveipm     	      = 6.2648396e-06
    eveico     	      = 7.5433785e-03
    eveiso2    	      = 4.0730592e-05
    eveivoc    	      = 1.1892237e-03
    !----- Urban canopy parameterization using TEB (Masson, 2000)-------------
    iteb      	      = 0     !1=on, 0=off
    tminbld   	      = 12.   !Minimum internal building temperature (degrees Celsius)
    nteb      	      = 3     !Number of roof,road and wall layers used in TEB, Max.3
    ! ROOF layers properties
    ! heat capacity
    hc_roof             = 0.
    hc_roof(1:3)        = (/2110000.,280000.,290000./)
    ! thermal conductivity
    tc_roof             = 0.
    tc_roof(1:3)        = (/0.41,0.05,0.03/)
    ! depth
    d_roof              = 0.
    d_roof(1:3)         = (/0.05,0.4,0.05/)
    ! ROAD layers properties
    ! heat capacity
    hc_road             = 0.
    hc_road(1:3)        = (/1240000.,1280000.,1280000./)
    ! thermal conductivity 1.01
    tc_road             = 1.0103
    ! depth
    d_road              = 0.
    d_road(1:3)         = (/0.05,0.1,1.0/)
    ! WALL layers properties
    ! heat capacity J/m3/K 10e6
    hc_wall             = 1000000.
    ! thermal conductivity 0.81 W/m/K
    tc_wall             = 0.81
    ! depth
    d_wall              = 0.
    d_wall(1:3)         = (/0.02,0.125,0.02/)
    nurbtype            = 2	  !Number of urban types (maximum of 3)

    !Leaf class code to identify each urban type
    ileafcod            = 19
    ileafcod(1:2)       = (21,19)
    !Urban type properties
    !Urban type roughness length 5 e 1
    z0_town             = 0.0
    z0_town(1:2)        = (/3.0,0.5/)
    !Fraction occupied by buildings in the grid cell
    bld      	      = 0.0
    bld(1:2) 	      = (/0.5,0.7/)
    !Building Height
    bld_height          = 0
    bld_height(1:2)     = (/50.,5.0/)
    !Vertical/Horizontal rate 3 e 0.5
    bld_hl_ratio        = 2.4
    bld_hl_ratio(1:2)   = (/4.4,2.4/)
    !Roof albedo
    aroof               = 0.15
    !Roof emissivitiy
    eroof               = 0.9
    !Road albedo
    aroad               = 0.1
    !Road emissivity 90% masson
    eroad               = 0.9
    !Wall albedo
    awall               = 0.25
    !Wall emissivity
    ewall               = 0.85
    !Maximum value of sensible heat
    htraf      	      = 0.
    htraf(1:2) 	      = (/90.0,60.0/)
    !Maximum value of sensible heat
    hindu      	      = 14.
    hindu(1:2) 	      = (/10.0,14.0/)
    !released by Industry (W/m2)
    !Maximum value of latent heat
    pletraf             = 5.
    pletraf(1:2)        = (/10.0,5.0/)
    !released by Traffic (W/m2)
    !Maximum value of latent heat
    pleindu             = 50.
    pleindu(1:2)        = (/30.0,50.0/)

    !PPL defaults for necessary variables
    ! (values from the first-time users)
    ! ATENTION: those variables below should be declared on the simplest RAMSIN
    runtype 	      = "initial"
    timmax  	      = 24
    imonth1 	      = 01
    idate1  	      = 25
    iyear1  	      = 2005
    itime1  	      = 0000
    nnxp    	      = 35
    nnyp    	      = 34
    nnzp    	      = 32
    deltax  	      = 112000.
    deltay  	      = 112000.
    polelat 	      = -23.
    polelon 	      = -52.5
    centlat 	      = -22.
    centlon             = -56.

    !namelist POST
    mechanism = " "
    proj="YES"
    anl2gra="ONE"
    mean_type="VMP"
    lati(:)=-90
    latf(:)=+90
    loni(:)=-180
    lonf(:)=+180
    ascii_data="NO"

    ! PPL end defaults

    ! select unused i/o unit

    do iunit = firstUnit, lastUnit
       inquire(iunit,opened=op)
       if (.not. op) exit
    end do

    if (iunit > lastUnit) then
       call fatal_error(h//" all i/o units in use")
    end if

    ! if namelist file exists, open, read each section and close

    inquire(file=trim(oneNamelistFile%fileName), exist=ex)
    if (.not. ex) then
       call fatal_error(h//" namelist file "//trim(oneNamelistFile%fileName)//&
            " does not exist")
    end if

    open(iunit, file=trim(oneNamelistFile%fileName), status="old", action="read",&
         iostat=err)
    if (err /= 0) then
       write(c0,"(i10)") err
       call fatal_error(h//" open namelist file "//trim(oneNamelistFile%fileName)//&
            " returned iostat="//trim(adjustl(c0)))
    end if

    read (iunit, iostat=err, NML=MODEL_GRIDS)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section MODEL_GRIDS "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)
       write(*,"(a)") h//" compare values read with file contents:"
       write(*,*) "expnme=",trim(expnme)
       write(*,*) "runtype=",trim(runtype)
       write(*,*) "timeunit=",trim(timeunit)
       write(*,*) "timmax=",timmax
       write(*,*) "load_bal=",load_bal
       write(*,*) "imonth1=",imonth1
       write(*,*) "idate1=",idate1
       write(*,*) "iyear1=",iyear1
       write(*,*) "itime1=",itime1
       write(*,*) "ngrids=",ngrids
       write(*,*) "nnxp=",nnxp
       write(*,*) "nnyp=",nnyp
       write(*,*) "nnzp=",nnzp
       write(*,*) "nzg=",nzg
       write(*,*) "nzs=",nzs
       write(*,*) "nxtnest=",nxtnest
       write(*,*) "DOMAIN_FNAME=", DOMAIN_FNAME
       write(*,*) "if_adap=",if_adap
       write(*,*) "ihtran=",ihtran
       write(*,*) "deltax=",deltax
       write(*,*) "deltay=",deltay
       write(*,*) "deltaz=",deltaz
       write(*,*) "dzrat=",dzrat
       write(*,*) "dzmax=",dzmax
       write(*,*) "zz=",zz
       write(*,*) "dtlong=",dtlong
       write(*,*) "nacoust=",nacoust
       write(*,*) "ideltat=",ideltat
       write(*,*) "nstratx=",nstratx
       write(*,*) "nstraty=",nstraty
       write(*,*) "nndtrat=",nndtrat
       write(*,*) "nestz1=",nestz1
       write(*,*) "nstratz1=",nstratz1
       write(*,*) "nestz2=",nestz2
       write(*,*) "nstratz2=",nstratz2
       write(*,*) "polelat=",polelat
       write(*,*) "polelon=",polelon
       write(*,*) "centlat=",centlat
       write(*,*) "centlon=",centlon
       write(*,*) "ninest=",ninest
       write(*,*) "njnest=",njnest
       write(*,*) "nknest=",nknest
       write(*,*) "nnsttop=",nnsttop
       write(*,*) "nnstbot=",nnstbot
       write(*,*) "gridu=",gridu
       write(*,*) "gridv=",gridv
       
       call fatal_error(h//" reading namelist")
    else
       ! namelist /MODEL_GRID/
       oneNamelistFile%expnme=expnme
       oneNamelistFile%runtype=runtype
       oneNamelistFile%timeunit=timeunit
       oneNamelistFile%timmax=timmax
       oneNamelistFile%load_bal=load_bal
       oneNamelistFile%imonth1=imonth1
       oneNamelistFile%idate1=idate1
       oneNamelistFile%iyear1=iyear1
       oneNamelistFile%itime1=itime1
       oneNamelistFile%ngrids=ngrids
       oneNamelistFile%nnxp=nnxp
       oneNamelistFile%nnyp=nnyp
       oneNamelistFile%nnzp=nnzp
       oneNamelistFile%nzg=nzg
       oneNamelistFile%nzs=nzs
       oneNamelistFile%nxtnest=nxtnest
       oneNamelistFile%domain_fname=domain_fname
       oneNamelistFile%if_adap=if_adap
       oneNamelistFile%ihtran=ihtran
       oneNamelistFile%deltax=deltax
       oneNamelistFile%deltay=deltay
       oneNamelistFile%deltaz=deltaz
       oneNamelistFile%dzrat=dzrat
       oneNamelistFile%dzmax=dzmax
       oneNamelistFile%zz=zz
       oneNamelistFile%dtlong=dtlong
       oneNamelistFile%nacoust=nacoust
       oneNamelistFile%ideltat=ideltat
       oneNamelistFile%nstratx=nstratx
       oneNamelistFile%nstraty=nstraty
       oneNamelistFile%nndtrat=nndtrat
       oneNamelistFile%nestz1=nestz1
       oneNamelistFile%nstratz1=nstratz1
       oneNamelistFile%nestz2=nestz2
       oneNamelistFile%nstratz2=nstratz2
       oneNamelistFile%polelat=polelat
       oneNamelistFile%polelon=polelon
       oneNamelistFile%centlat=centlat
       oneNamelistFile%centlon=centlon
       oneNamelistFile%ninest=ninest
       oneNamelistFile%njnest=njnest
       oneNamelistFile%nknest=nknest
       oneNamelistFile%nnsttop=nnsttop
       oneNamelistFile%nnstbot=nnstbot
       oneNamelistFile%gridu=gridu
       oneNamelistFile%gridv=gridv
    end if


!--(DMK-CCATT-INI)-----------------------------------------------------------
    read (iunit, iostat=err, NML=CCATT_INFO)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section CCATT_INFO "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)
       write(*,"(a)") h//" compare values read with file contents:"
       print *, "CCATT=", CCATT
       write(*,*) "CHEMISTRY=", chemistry
       write(*,*) "SPLIT_METHOD=", trim(split_method)
       write(*,*) "CHEM_TIMESTEP=", chem_timestep
       write(*,*) "CHEMISTRY_AQ=", chemistry_aq
!       write(*,*) "AEROSOL=", aerosol
       write(*,*) "CHEM_ASSIM=", chem_assim
       write(*,*) "SRCMAPFN=", srcmapfn
       write(*,*) "RECYCLE_TRACERS=", RECYCLE_TRACERS
       write(*,*) "DEF_PROC_SRC=", trim(def_proc_src)
       write(*,*) "DIUR_CYCLE=", diur_cycle
       write(*,*) "NA_EXTRA2D=", na_extra2d
       write(*,*) "NA_EXTRA3D=", na_extra3d
       write(*,*) "PLUMERISE=", PLUMERISE
       write(*,*) "PRFRQ=", PRFRQ
       write(*,*) "VOLCANOES=", volcanoes
       write(*,*) "AEROSOL=", aerosol
       write(*,*) "AER_TIMESTEP=", aer_timestep
       write(*,*) "AER_ASSIM=", aer_assim
       write(*,*) "MECH=", mech
       
       call fatal_error(h//" reading namelist")
    else
       oneNamelistFile%ccatt=ccatt
       oneNamelistFile%chemistry=chemistry
       oneNamelistFile%split_method=split_method
       oneNamelistFile%chem_timestep=chem_timestep
       oneNamelistFile%chemistry_aq=chemistry_aq
!       oneNamelistFile%aerosol=aerosol
       oneNamelistFile%chem_assim=chem_assim
       oneNamelistFile%srcmapfn=srcmapfn
       oneNamelistFile%recycle_tracers=recycle_tracers
       oneNamelistFile%def_proc_src=def_proc_src
       oneNamelistFile%diur_cycle=diur_cycle
       oneNamelistFile%na_extra2d=na_extra2d
       oneNamelistFile%na_extra3d=na_extra3d
       oneNamelistFile%plumerise=plumerise
       oneNamelistFile%prfrq=prfrq
       oneNamelistFile%volcanoes=volcanoes
       oneNamelistFile%aerosol=aerosol
       oneNamelistFile%aer_timestep=aer_timestep
       oneNamelistFile%aer_assim=aer_assim
       oneNamelistFile%mech=mech
       
    end if
!--(DMK-CCATT-OLD)-----------------------------------------------------------
!    read (iunit, iostat=err, NML=CATT_INFO)
!    if (err /= 0) then
!       write(*,"(a)") h//"**(ERROR)** reading section CATT_INFO "//&
!            &"of namelist file "//trim(oneNamelistFile%fileName)
!       write(*,"(a)") h//" compare values read with file contents:"
!       print *, "CATT=", CATT
!       write(*,*) "FIREMAPFN=", FIREMAPFN
!       write(*,*) "RECYCLE_TRACERS=", RECYCLE_TRACERS
!       write(*,*) "PLUMERISE=", PLUMERISE
!       write(*,*) "DEFINE_PROC=", define_proc
!       write(*,*) "PRFRQ=", PRFRQ
!       call fatal_error(h//" reading namelist")
!    else
!       oneNamelistFile%catt=catt
!       oneNamelistFile%firemapfn=firemapfn
!       oneNamelistFile%recycle_tracers=recycle_tracers
!       oneNamelistFile%plumerise=plumerise
!       oneNamelistFile%define_proc=define_proc
!       oneNamelistFile%prfrq=prfrq
!    end if
!--(DMK-CCATT-FIM)-----------------------------------------------------------

    read (iunit, iostat=err, NML=TEB_SPM_INFO)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section TEB_SPM_INFO "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)
       write(*,"(a)") h//" compare values read with file contents:"
       print *, "TEB_SPM=", TEB_SPM
       print *, "ifusflg=", ifusflg
       print *, "ifusfn=", ifusfn
       print *, "fusfiles=", trim(fusfiles)
       print *, "ICHEMI=", ICHEMI
       print *, "ICHEMI_IN=", ICHEMI_IN
       print *, "CHEMDATA_IN=", CHEMDATA_IN
       print *, "ISOURCE=", ISOURCE
       print *, "WEEKDAYIN=", trim(WEEKDAYIN)
       print *, "RUSHH1=", RUSHH1
       print *, "RUSHH2=", RUSHH2
       print *, "DAYLIGHT=", DAYLIGHT
       print *, "EFSAT=", EFSAT
       print *, "EFSUN=", EFSUN
       print *, "EINDNO=", EINDNO
       print *, "EINDNO2=", EINDNO2
       print *, "EINDPM=", EINDPM
       print *, "EINDCO=", EINDCO
       print *, "EINDSO2=", EINDSO2
       print *, "EINDVOC=", EINDVOC
       print *, "EVEINO=", EVEINO
       print *, "EVEINO2=", EVEINO2
       print *, "EVEIPM=", EVEIPM
       print *, "EVEICO=", EVEICO
       print *, "EVEISO2=", EVEISO2
       print *, "EVEIVOC=", EVEIVOC
       print *, "ITEB=", ITEB
       print *, "TMINBLD=", TMINBLD
       print *, "NTEB=", NTEB
       print *, "HC_ROOF=", HC_ROOF
       print *, "TC_ROOF=", TC_ROOF
       print *, "D_ROOF=", D_ROOF
       print *, "HC_ROAD=", HC_ROAD
       print *, "TC_ROAD=", TC_ROAD
       print *, "D_ROAD=", D_ROAD
       print *, "HC_WALL=", HC_WALL
       print *, "TC_WALL=", TC_WALL
       print *, "D_WALL=", D_WALL
       print *, "NURBTYPE=", NURBTYPE
       print *, "ILEAFCOD=", ILEAFCOD
       print *, "Z0_TOWN=", Z0_TOWN
       print *, "BLD=", BLD
       print *, "BLD_HEIGHT=", BLD_HEIGHT
       print *, "BLD_HL_RATIO=", BLD_HL_RATIO
       print *, "AROOF=", AROOF
       print *, "EROOF=", EROOF
       print *, "AROAD=", AROAD
       print *, "EROAD=", EROAD
       print *, "AWALL=", AWALL
       print *, "EWALL=", EWALL
       print *, "HTRAF=", HTRAF
       print *, "HINDU=", HINDU
       print *, "PLETRAF=", PLETRAF
       print *, "PLEINDU=", PLEINDU
       call fatal_error(h//" reading namelist")
    else
       oneNamelistFile%teb_spm=teb_spm
       oneNamelistFile%fusfiles=fusfiles
       oneNamelistFile%ifusflg=ifusflg
       oneNamelistFile%ifusfn=ifusfn
       oneNamelistFile%ichemi=ichemi
       oneNamelistFile%ichemi_in=ichemi_in
       oneNamelistFile%chemdata_in=chemdata_in
       oneNamelistFile%isource=isource
       oneNamelistFile%weekdayin=weekdayin
       oneNamelistFile%rushh1=rushh1
       oneNamelistFile%rushh2=rushh2
       oneNamelistFile%daylight=daylight
       oneNamelistFile%efsat=efsat
       oneNamelistFile%efsun=efsun
       oneNamelistFile%eindno=eindno
       oneNamelistFile%eindno2=eindno2
       oneNamelistFile%eindpm=eindpm
       oneNamelistFile%eindco=eindco
       oneNamelistFile%eindso2=eindso2
       oneNamelistFile%eindvoc=eindvoc
       oneNamelistFile%eveino=eveino
       oneNamelistFile%eveino2=eveino2
       oneNamelistFile%eveipm=eveipm
       oneNamelistFile%eveico=eveico
       oneNamelistFile%eveiso2=eveiso2
       oneNamelistFile%eveivoc=eveivoc
       oneNamelistFile%iteb=iteb
       oneNamelistFile%tminbld=tminbld
       oneNamelistFile%nteb=nteb
       oneNamelistFile%hc_roof=hc_roof
       oneNamelistFile%tc_roof=tc_roof
       oneNamelistFile%d_roof=d_roof
       oneNamelistFile%hc_road=hc_road
       oneNamelistFile%tc_road=tc_road
       oneNamelistFile%d_road=d_road
       oneNamelistFile%hc_wall=hc_wall
       oneNamelistFile%tc_wall=tc_wall
       oneNamelistFile%d_wall=d_wall
       oneNamelistFile%nurbtype=nurbtype
       oneNamelistFile%ileafcod=ileafcod
       oneNamelistFile%z0_town=z0_town
       oneNamelistFile%bld=bld
       oneNamelistFile%bld_height=bld_height
       oneNamelistFile%bld_hl_ratio=bld_hl_ratio
       oneNamelistFile%aroof=aroof
       oneNamelistFile%eroof=eroof
       oneNamelistFile%aroad=aroad
       oneNamelistFile%eroad=eroad
       oneNamelistFile%awall=awall
       oneNamelistFile%ewall=ewall
       oneNamelistFile%htraf=htraf
       oneNamelistFile%hindu=hindu
       oneNamelistFile%pletraf=pletraf
       oneNamelistFile%pleindu=pleindu
    end if

    read (iunit, iostat=err, NML=MODEL_FILE_INFO)

    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section MODEL_FILE_INFO "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)
       write(*,"(a)") h//" compare values read with file contents:"
       write (*, "(a)") " namelist MODEL_FILE_INFO: "
       write (*,*) "initial=", initial
       write (*,*) "nud_type=", nud_type
       write (*,*) "varfpfx=", trim(varfpfx)
       write (*,*) "vwait1=", vwait1
       write (*,*) "vwaittot=", vwaittot
       write (*,*) "nud_hfile=", trim(nud_hfile)
       write (*,*) "nudlat=", nudlat
       write (*,*) "tnudlat=", tnudlat
       write (*,*) "tnudcent=", tnudcent
       write (*,*) "tnudtop=", tnudtop
       write (*,*) "znudtop=", znudtop
       write (*,*) "wt_nudge_grid=", wt_nudge_grid
       write (*,*) "wt_nudge_uv=", wt_nudge_uv
       write (*,*) "wt_nudge_th=", wt_nudge_th
       write (*,*) "wt_nudge_pi=", wt_nudge_pi
       write (*,*) "wt_nudge_rt=", wt_nudge_rt
       write (*,*) "nud_cond=", nud_cond
       write (*,*) "cond_hfile=", trim(cond_hfile)
       write (*,*) "tcond_beg=", tcond_beg
       write (*,*) "tcond_end=", tcond_end
       write (*,*) "t_nudge_rc=", t_nudge_rc
       write (*,*) "wt_nudgec_grid=", wt_nudgec_grid
       write (*,*) "if_oda=", if_oda
       write (*,*) "oda_upaprefix=", trim(oda_upaprefix)
       write (*,*) "oda_sfcprefix=", trim(oda_sfcprefix)
       write (*,*) "frqoda=", frqoda
       write (*,*) "todabeg=", todabeg
       write (*,*) "todaend=", todaend
       write (*,*) "tnudoda=", tnudoda
       write (*,*) "wt_oda_grid=", wt_oda_grid
       write (*,*) "wt_oda_uv=", wt_oda_uv
       write (*,*) "wt_oda_th=", wt_oda_th
       write (*,*) "wt_oda_pi=", wt_oda_pi
       write (*,*) "wt_oda_rt=", wt_oda_rt
       write (*,*) "roda_sfce=", roda_sfce
       write (*,*) "roda_sfc0=", roda_sfc0
       write (*,*) "roda_upae=", roda_upae
       write (*,*) "roda_upa0=", roda_upa0
       write (*,*) "roda_hgt=", roda_hgt
       write (*,*) "roda_zfact=", roda_zfact
       write (*,*) "oda_sfc_til=", oda_sfc_til
       write (*,*) "oda_sfc_tel=", oda_sfc_tel
       write (*,*) "oda_upa_til=", oda_upa_til
       write (*,*) "oda_upa_tel=", oda_upa_tel
       write (*,*) "if_cuinv=", if_cuinv
       write (*,*) "cu_prefix=", trim(cu_prefix)
       write (*,*) "tnudcu=", tnudcu
       write (*,*) "wt_cu_grid=", wt_cu_grid
       write (*,*) "tcu_beg=", tcu_beg
       write (*,*) "tcu_end=", tcu_end
       write (*,*) "cu_tel=", cu_tel
       write (*,*) "cu_til=", cu_til
       write (*,*) "timstr=", timstr
       write (*,*) "hfilin=", trim(hfilin)
       write (*,*) "ipastin=", ipastin
       write (*,*) "pastfn=", trim(pastfn)
       write (*,*) "ioutput=", ioutput
       write (*,*) "hfilout=", trim(hfilout)
       write (*,*) "afilout=", trim(afilout)
       write (*,*) "iclobber=", iclobber
       write (*,*) "ihistdel=", ihistdel
       write (*,*) "frqhis=", frqhis
       write (*,*) "frqanl=", frqanl
       write (*,*) "frqlite=", frqlite
       write (*,*) "ipos=", ipos
       write (*,*) "xlite=", xlite
       write (*,*) "ylite=", ylite
       write (*,*) "zlite=", zlite
       write (*,*) "nlite_vars=", nlite_vars
       write (*,*) "lite_vars=", (trim(lite_vars(i))//";", i=1,size(lite_vars))
       write (*,*) "avgtim=", avgtim
       write (*,*) "frqmean=", frqmean
       write (*,*) "frqboth=", frqboth
       write (*,*) "kwrite=", kwrite
       write (*,*) "frqprt=", frqprt
       write (*,*) "initfld=", initfld
       write (*,*) "prtcputime", prtcputime
       write (*,*) "topfiles=", trim(topfiles)
       write (*,*) "sfcfiles=", trim(sfcfiles)
       write (*,*) "sstfpfx=", trim(sstfpfx)
       write (*,*) "ndvifpfx=", trim(ndvifpfx)
       write (*,*) "itoptflg=", itoptflg
       write (*,*) "isstflg=", isstflg
       write (*,*) "ivegtflg=", ivegtflg
       write (*,*) "isoilflg=", isoilflg
       write (*,*) "ndviflg=", ndviflg
       write (*,*) "nofilflg=", nofilflg
       write (*,*) "iupdndvi=", iupdndvi
       write (*,*) "iupdsst=", iupdsst
       write (*,*) "itoptfn=", (trim(itoptfn(i))//";", i =1,size(itoptfn))
       write (*,*) "isstfn=", (trim(isstfn(i))//";", i=1,size(isstfn))
       write (*,*) "ivegtfn=", (trim(ivegtfn(i))//";", i = 1, size(ivegtfn))
       write (*,*) "isoilfn=", (trim(isoilfn(i))//";", i = 1, size(isoilfn))
       write (*,*) "ndvifn=", (trim(ndvifn(i))//";", i=1,size(ndvifn))
       write (*,*) "itopsflg=", itopsflg
       write (*,*) "toptenh=", toptenh
       write (*,*) "toptwvl=", toptwvl
       write (*,*) "iz0flg=", iz0flg
       write (*,*) "z0max=", z0max
       write (*,*) "z0fact=", z0fact
       write (*,*) "mkcoltab=", mkcoltab
       write (*,*) "coltabfn=", trim(coltabfn)
       write (*,*) "mapaotfile=", trim(mapaotfile)
       call fatal_error(h//" reading namelist")
    else
       oneNamelistFile%initial=initial
       oneNamelistFile%nud_type=nud_type
       oneNamelistFile%varfpfx=varfpfx
       oneNamelistFile%vwait1=vwait1
       oneNamelistFile%vwaittot=vwaittot
       oneNamelistFile%nud_hfile=nud_hfile
       oneNamelistFile%nudlat=nudlat
       oneNamelistFile%tnudlat=tnudlat
       oneNamelistFile%tnudcent=tnudcent
       oneNamelistFile%tnudtop=tnudtop
       oneNamelistFile%znudtop=znudtop
       oneNamelistFile%wt_nudge_grid=wt_nudge_grid
       oneNamelistFile%wt_nudge_uv=wt_nudge_uv
       oneNamelistFile%wt_nudge_th=wt_nudge_th
       oneNamelistFile%wt_nudge_pi=wt_nudge_pi
       oneNamelistFile%wt_nudge_rt=wt_nudge_rt
       oneNamelistFile%nud_cond=nud_cond
       oneNamelistFile%cond_hfile=cond_hfile
       oneNamelistFile%tcond_beg=tcond_beg
       oneNamelistFile%tcond_end=tcond_end
       oneNamelistFile%t_nudge_rc=t_nudge_rc
       oneNamelistFile%wt_nudgec_grid=wt_nudgec_grid
       oneNamelistFile%if_oda=if_oda
       oneNamelistFile%oda_upaprefix=oda_upaprefix
       oneNamelistFile%oda_sfcprefix=oda_sfcprefix
       oneNamelistFile%frqoda=frqoda
       oneNamelistFile%todabeg=todabeg
       oneNamelistFile%todaend=todaend
       oneNamelistFile%tnudoda=tnudoda
       oneNamelistFile%wt_oda_grid=wt_oda_grid
       oneNamelistFile%wt_oda_uv=wt_oda_uv
       oneNamelistFile%wt_oda_th=wt_oda_th
       oneNamelistFile%wt_oda_pi=wt_oda_pi
       oneNamelistFile%wt_oda_rt=wt_oda_rt
       oneNamelistFile%roda_sfce=roda_sfce
       oneNamelistFile%roda_sfc0=roda_sfc0
       oneNamelistFile%roda_upae=roda_upae
       oneNamelistFile%roda_upa0=roda_upa0
       oneNamelistFile%roda_hgt=roda_hgt
       oneNamelistFile%roda_zfact=roda_zfact
       oneNamelistFile%oda_sfc_til=oda_sfc_til
       oneNamelistFile%oda_sfc_tel=oda_sfc_tel
       oneNamelistFile%oda_upa_til=oda_upa_til
       oneNamelistFile%oda_upa_tel=oda_upa_tel
       oneNamelistFile%if_cuinv=if_cuinv
       oneNamelistFile%cu_prefix=cu_prefix
       oneNamelistFile%tnudcu=tnudcu
       oneNamelistFile%wt_cu_grid=wt_cu_grid
       oneNamelistFile%tcu_beg=tcu_beg
       oneNamelistFile%tcu_end=tcu_end
       oneNamelistFile%cu_tel=cu_tel
       oneNamelistFile%cu_til=cu_til
       oneNamelistFile%timstr=timstr
       oneNamelistFile%hfilin=hfilin
       oneNamelistFile%ipastin=ipastin
       oneNamelistFile%pastfn=pastfn
       oneNamelistFile%ioutput=ioutput
       oneNamelistFile%hfilout=hfilout
       oneNamelistFile%afilout=afilout
       oneNamelistFile%iclobber=iclobber
       oneNamelistFile%ihistdel=ihistdel
       oneNamelistFile%frqhis=frqhis
       oneNamelistFile%frqanl=frqanl
       oneNamelistFile%frqlite=frqlite
       oneNamelistFile%ipos=ipos
       oneNamelistFile%xlite=xlite
       oneNamelistFile%ylite=ylite
       oneNamelistFile%zlite=zlite
       oneNamelistFile%nlite_vars=nlite_vars
       oneNamelistFile%lite_vars=lite_vars
       oneNamelistFile%avgtim=avgtim
       oneNamelistFile%frqmean=frqmean
       oneNamelistFile%frqboth=frqboth
       oneNamelistFile%kwrite=kwrite
       oneNamelistFile%frqprt=frqprt
       oneNamelistFile%initfld=initfld
       oneNamelistFile%prtcputime=prtcputime
       oneNamelistFile%topfiles=topfiles
       oneNamelistFile%sfcfiles=sfcfiles
       oneNamelistFile%sstfpfx=sstfpfx
       oneNamelistFile%ndvifpfx=ndvifpfx
       oneNamelistFile%itoptflg=itoptflg
       oneNamelistFile%isstflg=isstflg
       oneNamelistFile%ivegtflg=ivegtflg
       oneNamelistFile%isoilflg=isoilflg
       oneNamelistFile%ndviflg=ndviflg
       oneNamelistFile%nofilflg=nofilflg
       oneNamelistFile%iupdndvi=iupdndvi
       oneNamelistFile%iupdsst=iupdsst
       oneNamelistFile%itoptfn=itoptfn
       oneNamelistFile%isstfn=isstfn
       oneNamelistFile%ivegtfn=ivegtfn
       oneNamelistFile%isoilfn=isoilfn
       oneNamelistFile%ndvifn=ndvifn
       oneNamelistFile%itopsflg=itopsflg
       oneNamelistFile%toptenh=toptenh
       oneNamelistFile%toptwvl=toptwvl
       oneNamelistFile%iz0flg=iz0flg
       oneNamelistFile%z0max=z0max
       oneNamelistFile%z0fact=z0fact
       oneNamelistFile%mkcoltab=mkcoltab
       oneNamelistFile%coltabfn=coltabfn
       oneNamelistFile%mapaotfile=mapaotfile
    end if

    read (iunit, iostat=err, NML=MODEL_OPTIONS)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section MODEL_OPTIONS "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)
       write(*,"(a)") h//" compare values read with file contents:"
       write (*,*) "naddsc=",naddsc
       write (*, *) "icorflg=",icorflg
!--(DMK-CCATT-INI)-----------------------------------------------------------
       write (*, *) "dyncore_flag=",dyncore_flag
       write (*, *) "iexev=",iexev
       write (*, *) "imassflx=",imassflx
       write (*, *) "vveldamp=",vveldamp
!--(DMK-CCATT-FIM)-----------------------------------------------------------
       write (*, *) "ibnd=",ibnd
       write (*, *) "jbnd=",jbnd
       write (*, *) "cphas=",cphas
       write (*, *) "lsflg=",lsflg
       write (*, *) "nfpt=",nfpt
       write (*, *) "distim=",distim
       write (*, *) "iswrtyp=",iswrtyp
       write (*, *) "ilwrtyp=",ilwrtyp
       write (*, *) "raddatfn=", RADDATFN
       write (*, *) "radfrq=",radfrq
       write (*, *) "lonrad=",lonrad
       write (*, *) "nnqparm=",nnqparm
       write (*, *) "closure_type=",closure_type
       write (*, *) "nnshcu=",nnshcu
       write (*, *) "confrq=",confrq
       write (*, *) "shcufrq=",shcufrq
       write (*, *) "wcldbs=",wcldbs
       write (*, *) "g3d_spread=",g3d_spread
       write (*, *) "g3d_smoothh=",g3d_smoothh
       write (*, *) "g3d_smoothv=",g3d_smoothv
       write (*, *) "npatch=",npatch
       write (*, *) "nvegpat=",nvegpat
       write (*, *) "isfcl=",isfcl
       write (*, *) "nvgcon=",nvgcon
       write (*, *) "pctlcon=",pctlcon
       write (*, *) "nslcon=",nslcon
       write (*, *) "drtcon=",drtcon
       write (*, *) "zrough=",zrough
       write (*, *) "albedo=",albedo
       write (*, *) "seatmp=",seatmp
       write (*, *) "dthcon=",dthcon
       write (*, *) "soil_moist=",soil_moist
       write (*, *) "soil_moist_fail=",soil_moist_fail
       write (*, *) "usdata_in=",trim(usdata_in)
       write (*, *) "usmodel_in=",trim(usmodel_in)
       write (*, *) "slz=",slz
       write (*, *) "slmstr=",slmstr
       write (*, *) "stgoff=",stgoff
       write (*, *) "if_urban_canopy=",if_urban_canopy
       write (*, *) "idiffk=",idiffk
       write (*, *) "ihorgrad=",ihorgrad
       write (*, *) "csx=",csx
       write (*, *) "csz=",csz
       write (*, *) "xkhkm=",xkhkm
       write (*, *) "zkhkm=",zkhkm
       write (*, *) "akmin=",akmin
       write (*, *) "mcphys_type=",mcphys_type
       write (*, *) "level=",level
       write (*, *) "icloud=",icloud
       write (*, *) "idriz=",idriz
       write (*, *) "irime=",irime
       write (*, *) "iplaws=",iplaws
       write (*, *) "iccnlev=",iccnlev
       write (*, *) "irain=",irain
       write (*, *) "ipris=",ipris
       write (*, *) "isnow=",isnow
       write (*, *) "iaggr=",iaggr
       write (*, *) "igraup=",igraup
       write (*, *) "ihail=",ihail
       write (*, *) "cparm=",cparm
       write (*, *) "rparm=",rparm
       write (*, *) "pparm=",pparm
       write (*, *) "sparm=",sparm
       write (*, *) "aparm=",aparm
       write (*, *) "gparm=",gparm
       write (*, *) "hparm=",hparm
       write (*, *) "dparm=",dparm
       write (*, *) "cnparm=",cnparm
       write (*, *) "gnparm=",gnparm
       write (*, *) "epsil=",epsil
       write (*, *) "gnu=",gnu
       write (*,*)  "advmnt=", advmnt
       write (*,*)  "GhostZoneLength", GhostZoneLength
       call fatal_error(h//" reading namelist")
    else
 !--(DMK-CCATT-INI)-----------------------------------------------------------
       oneNamelistFile%dyncore_flag=dyncore_flag
       oneNamelistFile%advmnt=advmnt
       oneNamelistFile%GhostZoneLength=GhostZoneLength
!--(DMK-CCATT-FIM)-----------------------------------------------------------   
    
       oneNamelistFile%naddsc=naddsc
       oneNamelistFile%icorflg=icorflg
!--(DMK-CCATT-INI)-----------------------------------------------------------
       oneNamelistFile%iexev=iexev
       oneNamelistFile%imassflx=imassflx
       oneNamelistFile%vveldamp=vveldamp
!--(DMK-CCATT-FIM)-----------------------------------------------------------
       oneNamelistFile%ibnd=ibnd
       oneNamelistFile%jbnd=jbnd
       oneNamelistFile%cphas=cphas
       oneNamelistFile%lsflg=lsflg
       oneNamelistFile%nfpt=nfpt
       oneNamelistFile%distim=distim
       oneNamelistFile%iswrtyp=iswrtyp
       oneNamelistFile%ilwrtyp=ilwrtyp
       oneNamelistFile%raddatfn=raddatfn
       oneNamelistFile%radfrq=radfrq
       oneNamelistFile%lonrad=lonrad
       oneNamelistFile%nnqparm=nnqparm
       oneNamelistFile%closure_type=closure_type
       oneNamelistFile%nnshcu=nnshcu
       oneNamelistFile%confrq=confrq
       oneNamelistFile%shcufrq=shcufrq
       oneNamelistFile%wcldbs=wcldbs
       
       oneNamelistFile%g3d_spread=g3d_spread
       oneNamelistFile%g3d_smoothh=g3d_smoothh
       oneNamelistFile%g3d_smoothv=g3d_smoothv
       
       oneNamelistFile%npatch=npatch
       oneNamelistFile%nvegpat=nvegpat
       oneNamelistFile%isfcl=isfcl

       oneNamelistFile%nvgcon=nvgcon
       oneNamelistFile%pctlcon=pctlcon
       oneNamelistFile%nslcon=nslcon
       oneNamelistFile%drtcon=drtcon
       oneNamelistFile%zrough=zrough
       oneNamelistFile%albedo=albedo
       oneNamelistFile%seatmp=seatmp
       oneNamelistFile%dthcon=dthcon
       oneNamelistFile%soil_moist=soil_moist
       oneNamelistFile%soil_moist_fail=soil_moist_fail
       oneNamelistFile%usdata_in=usdata_in
       oneNamelistFile%usmodel_in=usmodel_in
       oneNamelistFile%slz=slz
       oneNamelistFile%slmstr=slmstr
       oneNamelistFile%stgoff=stgoff
       oneNamelistFile%if_urban_canopy=if_urban_canopy
       oneNamelistFile%idiffk=idiffk
       oneNamelistFile%ihorgrad=ihorgrad
       oneNamelistFile%csx=csx
       oneNamelistFile%csz=csz
       oneNamelistFile%xkhkm=xkhkm
       oneNamelistFile%zkhkm=zkhkm
       oneNamelistFile%akmin=akmin
       oneNamelistFile%mcphys_type=mcphys_type
       oneNamelistFile%level=level
       oneNamelistFile%icloud=icloud
       oneNamelistFile%idriz=idriz
       oneNamelistFile%iccnlev=iccnlev
       oneNamelistFile%iplaws=iplaws
       oneNamelistFile%irime=irime
       oneNamelistFile%irain=irain
       oneNamelistFile%ipris=ipris
       oneNamelistFile%isnow=isnow
       oneNamelistFile%iaggr=iaggr
       oneNamelistFile%igraup=igraup
       oneNamelistFile%ihail=ihail
       oneNamelistFile%cparm=cparm
       oneNamelistFile%rparm=rparm
       oneNamelistFile%pparm=pparm
       oneNamelistFile%sparm=sparm
       oneNamelistFile%aparm=aparm
       oneNamelistFile%gparm=gparm
       oneNamelistFile%hparm=hparm
       oneNamelistFile%dparm=dparm
       oneNamelistFile%cnparm=cnparm
       oneNamelistFile%gnparm=gnparm
       oneNamelistFile%epsil=epsil
       oneNamelistFile%gnu=gnu
    end if
    
    read (iunit, iostat=err, NML=MODEL_SOUND)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section MODEL_SOUND "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)
       write(*,"(a)") h//" compare values read with file contents:"
       write (*, *) "ipsflg=",ipsflg
       write (*, *) "itsflg=",itsflg
       write (*, *) "irtsflg=",irtsflg
       write (*, *) "iusflg=",iusflg
       write (*, *) "hs=",hs
       write (*, *) "ps=",ps
       write (*, *) "ts=",ts
       write (*, *) "rts=",rts
       write (*, *) "us=",us
       write (*, *) "vs=",vs
       call fatal_error(h//" reading namelist")
    else
       oneNamelistFile%ipsflg=ipsflg
       oneNamelistFile%itsflg=itsflg
       oneNamelistFile%irtsflg=irtsflg
       oneNamelistFile%iusflg=iusflg
       oneNamelistFile%hs=hs
       oneNamelistFile%ps=ps
       oneNamelistFile%ts=ts
       oneNamelistFile%rts=rts
       oneNamelistFile%us=us
       oneNamelistFile%vs=vs
    end if

    read (iunit, iostat=err, NML=MODEL_PRINT)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section MODEL_PRINT "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)
       write(*,"(a)") h//" compare values read with file contents:"
       write (*, *) "nplt=",nplt
       write (*, *) "iplfld=",(trim(iplfld(i))//";", i=1,size(iplfld))
       write (*, *) "ixsctn=",ixsctn
       write (*, *) "isbval=",isbval
       call fatal_error(h//" reading namelist")
    else
       oneNamelistFile%nplt=nplt
       oneNamelistFile%iplfld=iplfld
       oneNamelistFile%ixsctn=ixsctn
       oneNamelistFile%isbval=isbval
    end if

    read (iunit, iostat=err, NML=ISAN_CONTROL)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section ISAN_CONTROL "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)
       write(*,"(a)") h//" compare values read with file contents:"
       write (*, *) "iszstage=",iszstage
       write (*, *) "ivrstage=",ivrstage
       write (*, *) "isan_inc=",isan_inc
       write (*, *) "guess1st=",guess1st
       write (*, *) "i1st_flg=",i1st_flg
       write (*, *) "iupa_flg=",iupa_flg
       write (*, *) "isfc_flg=",isfc_flg
       write (*, *) "iapr=",trim(iapr)
       write (*, *) "iarawi=",trim(iarawi)
       write (*, *) "iasrfce=",trim(iasrfce)
       write (*, *) "varpfx=",trim(varpfx)
       write (*, *) "ioflgisz=",ioflgisz
       write (*, *) "ioflgvar=",ioflgvar
       call fatal_error(h//" reading namelist")
    else
       oneNamelistFile%iszstage=iszstage
       oneNamelistFile%ivrstage=ivrstage
       oneNamelistFile%isan_inc=isan_inc
       oneNamelistFile%guess1st=guess1st
       oneNamelistFile%i1st_flg=i1st_flg
       oneNamelistFile%iupa_flg=iupa_flg
       oneNamelistFile%isfc_flg=isfc_flg
       oneNamelistFile%iapr=iapr
       oneNamelistFile%iarawi=iarawi
       oneNamelistFile%iasrfce=iasrfce
       oneNamelistFile%varpfx=varpfx
       oneNamelistFile%ioflgisz=ioflgisz
       oneNamelistFile%ioflgvar=ioflgvar
    end if

    read (iunit, iostat=err, NML=ISAN_ISENTROPIC)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section ISAN_ISENTROPIC "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)
       write(*,"(a)") h//" compare values read with file contents:"
       write (*, *) "nisn=",nisn
       write (*, *) "levth=",levth
       write (*, *) "nigrids=",nigrids
       write (*, *) "topsigz=",topsigz
       write (*, *) "hybbot=",hybbot
       write (*, *) "hybtop=",hybtop
       write (*, *) "sfcinf=",sfcinf
       write (*, *) "sigzwt=",sigzwt
       write (*, *) "nfeedvar=",nfeedvar
       write (*, *) "maxsta=",maxsta
       write (*, *) "maxsfc=",maxsfc
       write (*, *) "notsta=",notsta
       write (*, *) "notid=",(trim(notid(i))//";", i=1,size(notid))
       write (*, *) "iobswin=",iobswin
       write (*, *) "stasep=",stasep
       write (*, *) "igridfl=",igridfl
       write (*, *) "gridwt=",gridwt
       write (*, *) "gobsep=",gobsep
       write (*, *) "gobrad=",gobrad
       write (*, *) "wvlnth=",wvlnth
       write (*, *) "swvlnth=",swvlnth
       write (*, *) "respon=",respon
       call fatal_error(h//" reading namelist")
    else
       oneNamelistFile%nisn=nisn
       oneNamelistFile%levth=levth
       oneNamelistFile%nigrids=nigrids
       oneNamelistFile%topsigz=topsigz
       oneNamelistFile%hybbot=hybbot
       oneNamelistFile%hybtop=hybtop
       oneNamelistFile%sfcinf=sfcinf
       oneNamelistFile%sigzwt=sigzwt
       oneNamelistFile%nfeedvar=nfeedvar
       oneNamelistFile%maxsta=maxsta
       oneNamelistFile%maxsfc=maxsfc
       oneNamelistFile%notsta=notsta
       oneNamelistFile%notid=notid
       oneNamelistFile%iobswin=iobswin
       oneNamelistFile%stasep=stasep
       oneNamelistFile%igridfl=igridfl
       oneNamelistFile%gridwt=gridwt
       oneNamelistFile%gobsep=gobsep
       oneNamelistFile%gobrad=gobrad
       oneNamelistFile%wvlnth=wvlnth
       oneNamelistFile%swvlnth=swvlnth
       oneNamelistFile%respon=respon
    end if

    ! namelist POST
    read (iunit, iostat=err, NML=POST)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section POST "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)

    else
       oneNamelistFile%nvp = nvp
       oneNamelistFile%vp=vp
       oneNamelistFile%gprefix=gprefix
       oneNamelistFile%anl2gra=anl2gra
       oneNamelistFile%proj=proj
       oneNamelistFile%mean_type=mean_type
       oneNamelistFile%lati=lati
       oneNamelistFile%loni=loni
       oneNamelistFile%latf=latf
       oneNamelistFile%lonf=lonf
       oneNamelistFile%zlevmax=zlevmax
       oneNamelistFile%ipresslev=ipresslev
       oneNamelistFile%inplevs=inplevs
       oneNamelistFile%iplevs=iplevs
       oneNamelistFile%mechanism=mechanism
       oneNamelistFile%ascii_data=ascii_data
       oneNamelistFile%site_lat=site_lat
       oneNamelistFile%site_lon=site_lon
    end if

    ! namelist DIGITAL FILTER
    read (iunit, iostat=err, NML=DIGITALFILTER)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section DIGITAL FILTER "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)

    else
	oneNamelistFile%applyDigitalFilter = applyDigitalFilter
      	oneNamelistFile%digitalFilterTimeWindow=digitalFilterTimeWindow
    end if
    
       ! namelist METEOGRAM
    read (iunit, iostat=err, NML=METEOGRAM)
    if (err /= 0) then
       write(*,"(a)") h//"**(ERROR)** reading section METEOGRAM "//&
            &"of namelist file "//trim(oneNamelistFile%fileName)

    else
	oneNamelistFile%applyDigitalFilter = applyDigitalFilter
      	oneNamelistFile%digitalFilterTimeWindow=digitalFilterTimeWindow
	
	oneNamelistFile%applyMeteogram = applyMeteogram
     	oneNamelistFile%meteogramFreq  = meteogramFreq
     	oneNamelistFile%meteogramMap   = meteogramMap
     	oneNamelistFile%meteogramDir   = meteogramDir
	
    end if

    close(iunit, iostat=err)
    if (err /= 0) then
       write(c0,"(i10)") err
       call fatal_error(h//" closing file "//&
            trim(oneNamelistFile%fileName)//" returned iostat="//&
            trim(adjustl(c0)))
    end if

  end subroutine ReadNamelistFile







!!$  subroutine StoreNamelistFile(oneNamelistFile)
!!$
!!$    use io_params, only: frqboth, &
!!$         afilout,                 &
!!$         avgtim,                  &
!!$         frqanl,                  &
!!$         frqhis,                  &
!!$         frqlite,                 &
!!$         frqmean,                 &
!!$         frqprt,                  &
!!$         hfilin,                  &
!!$         hfilout,                 &
!!$         iclobber,                &
!!$         ihistdel,                &
!!$         initfld,                 &
!!$         prtcputime,              &
!!$         ioutput,                 &
!!$         ipastin,                 &
!!$         iplfld,                  &
!!$         isbval,                  &
!!$         isoilflg,                &
!!$         isoilfn,                 &
!!$         isstflg,                 &
!!$         isstfn,                  &
!!$         itopsflg,                &
!!$         itoptflg,                &
!!$         itoptfn,                 &
!!$         iupdndvi,                &
!!$         iupdsst,                 &
!!$         ivegtflg,                &
!!$         ivegtfn,                 &
!!$         ixsctn,                  &
!!$         iz0flg,                  &
!!$         kwrite,                  &
!!$         lite_vars,               &
!!$         ndviflg,                 &
!!$         ndvifn,                  &
!!$         ndvifpfx,                &
!!$         nlite_vars,              &
!!$         nofilflg,                &
!!$         nplt,                    &
!!$         pastfn,                  &
!!$         sfcfiles,                &
!!$         sstfpfx,                 &
!!$         timstr,                  &
!!$         topfiles,                &
!!$         toptenh,                 &
!!$         toptwvl,                 &
!!$         xlite,                   &
!!$         ylite,                   &
!!$         z0fact,                  &
!!$         z0max,                   &
!!$         zlite,                   &
!!$                                ! TEB
!!$         ifusflg,                 &
!!$         ifusfn,                  &
!!$         fusfiles
!!$    use isan_coms, only: gobrad, &
!!$         gobsep, &
!!$         gridwt, &
!!$         guess1st, &
!!$         hybbot, &
!!$         hybtop, &
!!$         i1st_flg, &
!!$         iapr, &
!!$         iarawi, &
!!$         iasrfce, &
!!$         igridfl, &
!!$         iobswin, &
!!$         ioflgisz, &
!!$         ioflgvar, &
!!$         isan_inc, &
!!$         isfc_flg, &
!!$         iszstage, &
!!$         iupa_flg, &
!!$         ivrstage, &
!!$         levth, &
!!$         maxsfc, &
!!$         maxsta, &
!!$         nfeedvar, &
!!$         nigrids, &
!!$         nisn, &
!!$         notid, &
!!$         notsta, &
!!$         respon, &
!!$         sfcinf, &
!!$         sigzwt, &
!!$         stasep, &
!!$         swvlnth, &
!!$         topsigz, &
!!$         varpfx, &
!!$         wvlnth
!!$    use mem_cuparm, only: confrq, &
!!$         cu_prefix, &
!!$         cu_tel, &
!!$         cu_til, &
!!$         if_cuinv, &
!!$         nnqparm, &
!!$         tcu_beg, &
!!$         tcu_end, &
!!$         tnudcu, &
!!$         wcldbs, &
!!$         wt_cu_grid
!!$    use mem_globrad, only: raddatfn 
!!$    use mem_grell_param, only: closure_type
!!$    use mem_grid, only: centlat, &
!!$         centlon, &
!!$         cphas, &
!!$         deltax, &
!!$         deltay, &
!!$         deltaz, &
!!$         distim, &
!!$         dtlong, &
!!$         dzmax, &
!!$         dzrat, &
!!$         expnme, &
!!$         gridu, &
!!$         gridv, &
!!$         ibnd, &
!!$         icorflg, &
!!$         idate1, &
!!$         ideltat, &
!!$         if_adap, &
!!$         ihtran, &
!!$         imonth1, &
!!$         initial, &
!!$         itime1, &
!!$         iyear1, &
!!$         jbnd, &
!!$         lsflg, &
!!$         nacoust, &
!!$         naddsc, &
!!$         nestz1, &
!!$         nestz2, &
!!$         nfpt, &
!!$         ngrids, &
!!$         ninest, &
!!$         njnest, &
!!$         nknest, &
!!$         nndtrat, &
!!$         nnstbot, &
!!$         nnsttop, &
!!$         nnxp, &
!!$         nnyp, &
!!$         nnzp, &
!!$         npatch, &
!!$         nstratx, &
!!$         nstraty, &
!!$         nstratz1, &
!!$         nstratz2, &
!!$         nxtnest, &
!!$         nzg, &
!!$         nzs, &
!!$         polelat, &
!!$         polelon, &
!!$         runtype, &
!!$         timeunit, &
!!$         timmax, &
!!$         zz
!!$    use mem_leaf, only: albedo, &
!!$         drtcon, &
!!$         dthcon, &
!!$         isfcl, &
!!$         nslcon, &
!!$         nvegpat, &
!!$         nvgcon, &
!!$         pctlcon, &
!!$         seatmp, &
!!$         slmstr, &
!!$         slz, &
!!$         stgoff, &
!!$         zrough
!!$    use mem_oda, only: frqoda, &
!!$         if_oda, &
!!$         oda_sfc_tel, &
!!$         oda_sfc_til, &
!!$         oda_sfcprefix, &
!!$         oda_upa_tel, &
!!$         oda_upa_til, &
!!$         oda_upaprefix, &
!!$         roda_hgt, &
!!$         roda_sfc0, &
!!$         roda_sfce, &
!!$         roda_upa0, &
!!$         roda_upae, &
!!$         roda_zfact, &
!!$         tnudoda, &
!!$         todabeg, &
!!$         todaend, &
!!$         wt_oda_grid, &
!!$         wt_oda_pi, &
!!$         wt_oda_rt, &
!!$         wt_oda_th, &
!!$         wt_oda_uv
!!$    use mem_radiate, only: ilwrtyp, &
!!$         iswrtyp, &
!!$         lonrad, &
!!$         radfrq
!!$    use soilMoisture, only: soil_moist, &
!!$         soil_moist_fail, &
!!$         usdata_in, &
!!$         usmodel_in
!!$    use mem_turb, only: akmin, &
!!$         csx, &
!!$         csz, &
!!$         idiffk, &
!!$         if_urban_canopy, &
!!$         ihorgrad, &
!!$         xkhkm, &
!!$         zkhkm
!!$    use mem_varinit, only: cond_hfile, &
!!$         nud_cond, &
!!$         nud_hfile, &
!!$         nud_type, &
!!$         nudlat, &
!!$         t_nudge_rc, &
!!$         tcond_beg, &
!!$         tcond_end, &
!!$         tnudcent, &
!!$         tnudlat, &
!!$         tnudtop, &
!!$         varfpfx, &
!!$         vwait1, &
!!$         vwaittot, &
!!$         wt_nudge_grid, &
!!$         wt_nudge_pi, &
!!$         wt_nudge_rt, &
!!$         wt_nudge_th, &
!!$         wt_nudge_uv, &
!!$         wt_nudgec_grid, &
!!$         znudtop
!!$    use micphys, only: &
!!$         aparm, &
!!$         coltabfn, &
!!$         cparm, &
!!$         gnu, &
!!$         gparm, &
!!$         hparm, &
!!$         iaggr, &
!!$         icloud, &
!!$         igraup, &
!!$         ihail, &
!!$         ipris, &
!!$         irain, &
!!$         isnow, &
!!$         level, &
!!$         mkcoltab, &
!!$         pparm, &
!!$         rparm, &
!!$         sparm
!!$    use node_mod, only: &
!!$         load_bal
!!$    use ref_sounding, only: &
!!$         hs, &
!!$         ipsflg, &
!!$         irtsflg, &
!!$         itsflg, &
!!$         iusflg, &
!!$         ps, &
!!$         rts, &
!!$         ts, &
!!$         us, &
!!$         vs
!!$    use shcu_vars_const, only: &
!!$         nnshcu, &
!!$         shcufrq
!!$    use sib_vars, only: &
!!$         co2_init, &
!!$         n_co2
!!$
!!$    use catt_start, only: &
!!$         CATT
!!$
!!$    use emission_source_map, only: &
!!$         firemapfn, &
!!$         plumerise,                           &
!!$         define_proc
!!$
!!$    use plume_utils, only: &
!!$         prfrq
!!$
!!$    use mem_scalar, only: &
!!$         recycle_tracers
!!$
!!$    use teb_spm_start, only: &
!!$         teb_spm
!!$
!!$    use mem_emiss, only : &
!!$         ichemi,          &
!!$         ichemi_in,       &
!!$         chemdata_in,     &
!!$         isource,         &
!!$         weekdayin,       &
!!$         efsat,           &
!!$         efsun,           &
!!$         eindno,          &
!!$         eindno2,         &
!!$         eindpm,          &
!!$         eindco,          &
!!$         eindso2,         &
!!$         eindvoc,         &
!!$         eveino,          &
!!$         eveino2,         &
!!$         eveipm,          &
!!$         eveico,          &
!!$         eveiso2,         &
!!$         eveivoc
!!$
!!$    use teb_vars_const, only : &
!!$         rushh1,               &
!!$         rushh2,               &
!!$         daylight,             &
!!$         iteb,                 &
!!$         tminbld,              &
!!$         nteb,                 &
!!$         hc_roof,              &
!!$         tc_roof,              &
!!$         d_roof,               &
!!$         hc_road,              &
!!$         d_road,               &
!!$         tc_road,              &
!!$         d_wall,               &
!!$         tc_wall,              &
!!$         hc_wall,              &
!!$         nurbtype,             &
!!$         ileafcod,             &
!!$         z0_town,              &
!!$         bld,                  &
!!$         bld_height,           &
!!$         bld_hl_ratio,         &
!!$         aroof,                &
!!$         eroof,                &
!!$         aroad,                &
!!$         eroad,                &
!!$         awall,                &
!!$         ewall,                &
!!$         htraf,                &
!!$         hindu,                &
!!$         pletraf,              &
!!$         pleindu
!!$
!!$    ! Explicit domain decomposition
!!$    use domain_decomp, only: &
!!$         domain_fname
!!$
!!$    implicit none
!!$    type(namelistFile), pointer :: oneNamelistFile
!!$
!!$
!!$
!!$    frqboth = oneNamelistFile%frqboth
!!$    afilout = oneNamelistFile%afilout
!!$    avgtim = oneNamelistFile%avgtim
!!$    frqanl = oneNamelistFile%frqanl
!!$    frqhis = oneNamelistFile%frqhis
!!$    frqlite = oneNamelistFile%frqlite
!!$    frqmean = oneNamelistFile%frqmean
!!$    frqprt = oneNamelistFile%frqprt
!!$    hfilin = oneNamelistFile%hfilin
!!$    hfilout = oneNamelistFile%hfilout
!!$    iclobber = oneNamelistFile%iclobber
!!$    ihistdel = oneNamelistFile%ihistdel
!!$    initfld = oneNamelistFile%initfld
!!$    prtcputime = oneNamelistFile%prtcputime
!!$    ioutput = oneNamelistFile%ioutput
!!$    ipastin = oneNamelistFile%ipastin
!!$    iplfld = oneNamelistFile%iplfld
!!$    isbval = oneNamelistFile%isbval
!!$    isoilflg = oneNamelistFile%isoilflg
!!$    isoilfn = oneNamelistFile%isoilfn
!!$    isstflg = oneNamelistFile%isstflg
!!$    isstfn = oneNamelistFile%isstfn
!!$    itopsflg = oneNamelistFile%itopsflg
!!$    itoptflg = oneNamelistFile%itoptflg
!!$    itoptfn = oneNamelistFile%itoptfn
!!$    iupdndvi = oneNamelistFile%iupdndvi
!!$    iupdsst = oneNamelistFile%iupdsst
!!$    ivegtflg = oneNamelistFile%ivegtflg
!!$    ivegtfn = oneNamelistFile%ivegtfn
!!$    ixsctn = oneNamelistFile%ixsctn
!!$    iz0flg = oneNamelistFile%iz0flg
!!$    kwrite = oneNamelistFile%kwrite
!!$    lite_vars = oneNamelistFile%lite_vars
!!$    ndviflg = oneNamelistFile%ndviflg
!!$    ndvifn = oneNamelistFile%ndvifn
!!$    ndvifpfx = oneNamelistFile%ndvifpfx
!!$    nlite_vars = oneNamelistFile%nlite_vars
!!$    nofilflg = oneNamelistFile%nofilflg
!!$    nplt = oneNamelistFile%nplt
!!$    pastfn = oneNamelistFile%pastfn
!!$    sfcfiles = oneNamelistFile%sfcfiles
!!$    sstfpfx = oneNamelistFile%sstfpfx
!!$    timstr = oneNamelistFile%timstr
!!$    topfiles = oneNamelistFile%topfiles
!!$    toptenh = oneNamelistFile%toptenh
!!$    toptwvl = oneNamelistFile%toptwvl
!!$    xlite = oneNamelistFile%xlite
!!$    ylite = oneNamelistFile%ylite
!!$    z0fact = oneNamelistFile%z0fact
!!$    z0max = oneNamelistFile%z0max
!!$    zlite = oneNamelistFile%zlite
!!$    ifusflg = oneNamelistFile%ifusflg
!!$    ifusfn = oneNamelistFile%ifusfn
!!$    fusfiles = oneNamelistFile%fusfiles
!!$    gobrad = oneNamelistFile%gobrad
!!$    gobsep = oneNamelistFile%gobsep
!!$    gridwt = oneNamelistFile%gridwt
!!$    guess1st = oneNamelistFile%guess1st
!!$    hybbot = oneNamelistFile%hybbot
!!$    hybtop = oneNamelistFile%hybtop
!!$    i1st_flg = oneNamelistFile%i1st_flg
!!$    iapr = oneNamelistFile%iapr
!!$    iarawi = oneNamelistFile%iarawi
!!$    iasrfce = oneNamelistFile%iasrfce
!!$    igridfl = oneNamelistFile%igridfl
!!$    iobswin = oneNamelistFile%iobswin
!!$    ioflgisz = oneNamelistFile%ioflgisz
!!$    ioflgvar = oneNamelistFile%ioflgvar
!!$    isan_inc = oneNamelistFile%isan_inc
!!$    isfc_flg = oneNamelistFile%isfc_flg
!!$    iszstage = oneNamelistFile%iszstage
!!$    iupa_flg = oneNamelistFile%iupa_flg
!!$    ivrstage = oneNamelistFile%ivrstage
!!$    levth = oneNamelistFile%levth
!!$    maxsfc = oneNamelistFile%maxsfc
!!$    maxsta = oneNamelistFile%maxsta
!!$    nfeedvar = oneNamelistFile%nfeedvar
!!$    nigrids = oneNamelistFile%nigrids
!!$    nisn = oneNamelistFile%nisn
!!$    notid = oneNamelistFile%notid
!!$    notsta = oneNamelistFile%notsta
!!$    respon = oneNamelistFile%respon
!!$    sfcinf = oneNamelistFile%sfcinf
!!$    sigzwt = oneNamelistFile%sigzwt
!!$    stasep = oneNamelistFile%stasep
!!$    swvlnth = oneNamelistFile%swvlnth
!!$    topsigz = oneNamelistFile%topsigz
!!$    varpfx = oneNamelistFile%varpfx
!!$    wvlnth = oneNamelistFile%wvlnth
!!$    confrq = oneNamelistFile%confrq
!!$    cu_prefix = oneNamelistFile%cu_prefix
!!$    cu_tel = oneNamelistFile%cu_tel
!!$    cu_til = oneNamelistFile%cu_til
!!$    if_cuinv = oneNamelistFile%if_cuinv
!!$    nnqparm = oneNamelistFile%nnqparm
!!$    tcu_beg = oneNamelistFile%tcu_beg
!!$    tcu_end = oneNamelistFile%tcu_end
!!$    tnudcu = oneNamelistFile%tnudcu
!!$    wcldbs = oneNamelistFile%wcldbs
!!$    wt_cu_grid = oneNamelistFile%wt_cu_grid
!!$    raddatfn = oneNamelistFile%raddatfn
!!$    closure_type = oneNamelistFile%closure_type
!!$    centlat = oneNamelistFile%centlat
!!$    centlon = oneNamelistFile%centlon
!!$    cphas = oneNamelistFile%cphas
!!$    deltax = oneNamelistFile%deltax
!!$    deltay = oneNamelistFile%deltay
!!$    deltaz = oneNamelistFile%deltaz
!!$    distim = oneNamelistFile%distim
!!$    dtlong = oneNamelistFile%dtlong
!!$    dzmax = oneNamelistFile%dzmax
!!$    dzrat = oneNamelistFile%dzrat
!!$    expnme = oneNamelistFile%expnme
!!$    gridu = oneNamelistFile%gridu
!!$    gridv = oneNamelistFile%gridv
!!$    ibnd = oneNamelistFile%ibnd
!!$    icorflg = oneNamelistFile%icorflg
!!$    idate1 = oneNamelistFile%idate1
!!$    ideltat = oneNamelistFile%ideltat
!!$    if_adap = oneNamelistFile%if_adap
!!$    ihtran = oneNamelistFile%ihtran
!!$    imonth1 = oneNamelistFile%imonth1
!!$    initial = oneNamelistFile%initial
!!$    itime1 = oneNamelistFile%itime1
!!$    iyear1 = oneNamelistFile%iyear1
!!$    jbnd = oneNamelistFile%jbnd
!!$    lsflg = oneNamelistFile%lsflg
!!$    nacoust = oneNamelistFile%nacoust
!!$    naddsc = oneNamelistFile%naddsc
!!$    nestz1 = oneNamelistFile%nestz1
!!$    nestz2 = oneNamelistFile%nestz2
!!$    nfpt = oneNamelistFile%nfpt
!!$    ngrids = oneNamelistFile%ngrids
!!$    ninest = oneNamelistFile%ninest
!!$    njnest = oneNamelistFile%njnest
!!$    nknest = oneNamelistFile%nknest
!!$    nndtrat = oneNamelistFile%nndtrat
!!$    nnstbot = oneNamelistFile%nnstbot
!!$    nnsttop = oneNamelistFile%nnsttop
!!$    nnxp = oneNamelistFile%nnxp
!!$    nnyp = oneNamelistFile%nnyp
!!$    nnzp = oneNamelistFile%nnzp
!!$    npatch = oneNamelistFile%npatch
!!$    nstratx = oneNamelistFile%nstratx
!!$    nstraty = oneNamelistFile%nstraty
!!$    nstratz1 = oneNamelistFile%nstratz1
!!$    nstratz2 = oneNamelistFile%nstratz2
!!$    nxtnest = oneNamelistFile%nxtnest
!!$    nzg = oneNamelistFile%nzg
!!$    nzs = oneNamelistFile%nzs
!!$    polelat = oneNamelistFile%polelat
!!$    polelon = oneNamelistFile%polelon
!!$    runtype = oneNamelistFile%runtype
!!$    timeunit = oneNamelistFile%timeunit
!!$    timmax = oneNamelistFile%timmax
!!$    zz = oneNamelistFile%zz
!!$    albedo = oneNamelistFile%albedo
!!$    drtcon = oneNamelistFile%drtcon
!!$    dthcon = oneNamelistFile%dthcon
!!$    isfcl = oneNamelistFile%isfcl
!!$    nslcon = oneNamelistFile%nslcon
!!$    nvegpat = oneNamelistFile%nvegpat
!!$    nvgcon = oneNamelistFile%nvgcon
!!$    pctlcon = oneNamelistFile%pctlcon
!!$    seatmp = oneNamelistFile%seatmp
!!$    slmstr = oneNamelistFile%slmstr
!!$    slz = oneNamelistFile%slz
!!$    stgoff = oneNamelistFile%stgoff
!!$    zrough = oneNamelistFile%zrough
!!$    frqoda = oneNamelistFile%frqoda
!!$    if_oda = oneNamelistFile%if_oda
!!$    oda_sfc_tel = oneNamelistFile%oda_sfc_tel
!!$    oda_sfc_til = oneNamelistFile%oda_sfc_til
!!$    oda_sfcprefix = oneNamelistFile%oda_sfcprefix
!!$    oda_upa_tel = oneNamelistFile%oda_upa_tel
!!$    oda_upa_til = oneNamelistFile%oda_upa_til
!!$    oda_upaprefix = oneNamelistFile%oda_upaprefix
!!$    roda_hgt = oneNamelistFile%roda_hgt
!!$    roda_sfc0 = oneNamelistFile%roda_sfc0
!!$    roda_sfce = oneNamelistFile%roda_sfce
!!$    roda_upa0 = oneNamelistFile%roda_upa0
!!$    roda_upae = oneNamelistFile%roda_upae
!!$    roda_zfact = oneNamelistFile%roda_zfact
!!$    tnudoda = oneNamelistFile%tnudoda
!!$    todabeg = oneNamelistFile%todabeg
!!$    todaend = oneNamelistFile%todaend
!!$    wt_oda_grid = oneNamelistFile%wt_oda_grid
!!$    wt_oda_pi = oneNamelistFile%wt_oda_pi
!!$    wt_oda_rt = oneNamelistFile%wt_oda_rt
!!$    wt_oda_th = oneNamelistFile%wt_oda_th
!!$    wt_oda_uv = oneNamelistFile%wt_oda_uv
!!$    ilwrtyp = oneNamelistFile%ilwrtyp
!!$    iswrtyp = oneNamelistFile%iswrtyp
!!$    lonrad = oneNamelistFile%lonrad
!!$    radfrq = oneNamelistFile%radfrq
!!$    soil_moist = oneNamelistFile%soil_moist
!!$    soil_moist_fail = oneNamelistFile%soil_moist_fail
!!$    usdata_in = oneNamelistFile%usdata_in
!!$    usmodel_in = oneNamelistFile%usmodel_in
!!$    akmin = oneNamelistFile%akmin
!!$    csx = oneNamelistFile%csx
!!$    csz = oneNamelistFile%csz
!!$    idiffk = oneNamelistFile%idiffk
!!$    if_urban_canopy = oneNamelistFile%if_urban_canopy
!!$    ihorgrad = oneNamelistFile%ihorgrad
!!$    xkhkm = oneNamelistFile%xkhkm
!!$    zkhkm = oneNamelistFile%zkhkm
!!$    cond_hfile = oneNamelistFile%cond_hfile
!!$    nud_cond = oneNamelistFile%nud_cond
!!$    nud_hfile = oneNamelistFile%nud_hfile
!!$    nud_type = oneNamelistFile%nud_type
!!$    nudlat = oneNamelistFile%nudlat
!!$    t_nudge_rc = oneNamelistFile%t_nudge_rc
!!$    tcond_beg = oneNamelistFile%tcond_beg
!!$    tcond_end = oneNamelistFile%tcond_end
!!$    tnudcent = oneNamelistFile%tnudcent
!!$    tnudlat = oneNamelistFile%tnudlat
!!$    tnudtop = oneNamelistFile%tnudtop
!!$    varfpfx = oneNamelistFile%varfpfx
!!$    vwait1 = oneNamelistFile%vwait1
!!$    vwaittot = oneNamelistFile%vwaittot
!!$    wt_nudge_grid = oneNamelistFile%wt_nudge_grid
!!$    wt_nudge_pi = oneNamelistFile%wt_nudge_pi
!!$    wt_nudge_rt = oneNamelistFile%wt_nudge_rt
!!$    wt_nudge_th = oneNamelistFile%wt_nudge_th
!!$    wt_nudge_uv = oneNamelistFile%wt_nudge_uv
!!$    wt_nudgec_grid = oneNamelistFile%wt_nudgec_grid
!!$    znudtop = oneNamelistFile%znudtop
!!$    aparm = oneNamelistFile%aparm
!!$    coltabfn = oneNamelistFile%coltabfn
!!$    cparm = oneNamelistFile%cparm
!!$    gnu = oneNamelistFile%gnu
!!$    gparm = oneNamelistFile%gparm
!!$    hparm = oneNamelistFile%hparm
!!$    iaggr = oneNamelistFile%iaggr
!!$    icloud = oneNamelistFile%icloud
!!$    igraup = oneNamelistFile%igraup
!!$    ihail = oneNamelistFile%ihail
!!$    ipris = oneNamelistFile%ipris
!!$    irain = oneNamelistFile%irain
!!$    isnow = oneNamelistFile%isnow
!!$    level = oneNamelistFile%level
!!$    mkcoltab = oneNamelistFile%mkcoltab
!!$    pparm = oneNamelistFile%pparm
!!$    rparm = oneNamelistFile%rparm
!!$    sparm = oneNamelistFile%sparm
!!$    load_bal = oneNamelistFile%load_bal
!!$    hs = oneNamelistFile%hs
!!$    ipsflg = oneNamelistFile%ipsflg
!!$    irtsflg = oneNamelistFile%irtsflg
!!$    itsflg = oneNamelistFile%itsflg
!!$    iusflg = oneNamelistFile%iusflg
!!$    ps = oneNamelistFile%ps
!!$    rts = oneNamelistFile%rts
!!$    ts = oneNamelistFile%ts
!!$    us = oneNamelistFile%us
!!$    vs = oneNamelistFile%vs
!!$    nnshcu = oneNamelistFile%nnshcu
!!$    shcufrq = oneNamelistFile%shcufrq
!!$    co2_init = oneNamelistFile%co2_init
!!$    n_co2 = oneNamelistFile%n_co2
!!$    catt = oneNamelistFile%catt
!!$    firemapfn = oneNamelistFile%firemapfn
!!$    plumerise = oneNamelistFile%plumerise
!!$    define_proc = oneNamelistFile%define_proc
!!$    prfrq = oneNamelistFile%prfrq
!!$    recycle_tracers = oneNamelistFile%recycle_tracers
!!$    teb_spm = oneNamelistFile%teb_spm
!!$    ichemi = oneNamelistFile%ichemi
!!$    ichemi_in = oneNamelistFile%ichemi_in
!!$    chemdata_in = oneNamelistFile%chemdata_in
!!$    isource = oneNamelistFile%isource
!!$    weekdayin = oneNamelistFile%weekdayin
!!$    efsat = oneNamelistFile%efsat
!!$    efsun = oneNamelistFile%efsun
!!$    eindno = oneNamelistFile%eindno
!!$    eindno2 = oneNamelistFile%eindno2
!!$    eindpm = oneNamelistFile%eindpm
!!$    eindco = oneNamelistFile%eindco
!!$    eindso2 = oneNamelistFile%eindso2
!!$    eindvoc = oneNamelistFile%eindvoc
!!$    eveino = oneNamelistFile%eveino
!!$    eveino2 = oneNamelistFile%eveino2
!!$    eveipm = oneNamelistFile%eveipm
!!$    eveico = oneNamelistFile%eveico
!!$    eveiso2 = oneNamelistFile%eveiso2
!!$    eveivoc = oneNamelistFile%eveivoc
!!$    rushh1 = oneNamelistFile%rushh1
!!$    rushh2 = oneNamelistFile%rushh2
!!$    daylight = oneNamelistFile%daylight
!!$    iteb = oneNamelistFile%iteb
!!$    tminbld = oneNamelistFile%tminbld
!!$    nteb = oneNamelistFile%nteb
!!$    hc_roof = oneNamelistFile%hc_roof
!!$    tc_roof = oneNamelistFile%tc_roof
!!$    d_roof = oneNamelistFile%d_roof
!!$    hc_road = oneNamelistFile%hc_road
!!$    d_road = oneNamelistFile%d_road
!!$    tc_road = oneNamelistFile%tc_road
!!$    d_wall = oneNamelistFile%d_wall
!!$    tc_wall = oneNamelistFile%tc_wall
!!$    hc_wall = oneNamelistFile%hc_wall
!!$    nurbtype = oneNamelistFile%nurbtype
!!$    ileafcod = oneNamelistFile%ileafcod
!!$    z0_town = oneNamelistFile%z0_town
!!$    bld = oneNamelistFile%bld
!!$    bld_height = oneNamelistFile%bld_height
!!$    bld_hl_ratio = oneNamelistFile%bld_hl_ratio
!!$    aroof = oneNamelistFile%aroof
!!$    eroof = oneNamelistFile%eroof
!!$    aroad = oneNamelistFile%aroad
!!$    eroad = oneNamelistFile%eroad
!!$    awall = oneNamelistFile%awall
!!$    ewall = oneNamelistFile%ewall
!!$    htraf = oneNamelistFile%htraf
!!$    hindu = oneNamelistFile%hindu
!!$    pletraf = oneNamelistFile%pletraf
!!$    pleindu = oneNamelistFile%pleindu
!!$    domain_fname = oneNamelistFile%domain_fname
!!$  end subroutine StoreNamelistFile


  !**********************************************************************





  subroutine BroadcastNamelistFile(oneNamelistFile, oneParallelEnvironment)
    use ParLib, only: parf_bcast
    use ModParallelEnvironment, only: parallelEnvironment
    implicit none
    type(namelistFile), pointer :: oneNamelistFile
    type(parallelEnvironment), pointer :: oneParallelEnvironment

    include "i8.h"

    ! MODEL_GRIDS
    call parf_bcast(oneNamelistFile%expnme,&
         int(len(oneNamelistFile%expnme),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%runtype,&
         int(len(oneNamelistFile%runtype),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%timeunit,&
         int(len(oneNamelistFile%timeunit),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%timmax,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%load_bal,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%imonth1,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%idate1,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iyear1,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%itime1,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ngrids,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nnxp,&
         int(size(oneNamelistFile%nnxp,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nnyp,&
         int(size(oneNamelistFile%nnyp,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nnzp,&
         int(size(oneNamelistFile%nnzp,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nzg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nzs,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nxtnest,&
         int(size(oneNamelistFile%nxtnest,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%domain_fname,&
         int(len(oneNamelistFile%domain_fname),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%if_adap,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ihtran,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%deltax,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%deltay,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%deltaz,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%dzrat,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%dzmax,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%zz,&
         int(size(oneNamelistFile%zz,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%dtlong,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nacoust,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ideltat,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nstratx,&
         int(size(oneNamelistFile%nstratx,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nstraty,&
         int(size(oneNamelistFile%nstraty,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nndtrat,&
         int(size(oneNamelistFile%nndtrat,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nestz1,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nstratz1,&
         int(size(oneNamelistFile%nstratz1,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nestz2,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nstratz2,&
         int(size(oneNamelistFile%nstratz2,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%polelat,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%polelon,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%centlat,&
         int(size(oneNamelistFile%centlat,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%centlon,&
         int(size(oneNamelistFile%centlat,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ninest,&
         int(size(oneNamelistFile%ninest,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%njnest,&
         int(size(oneNamelistFile%njnest,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nknest,&
         int(size(oneNamelistFile%nknest,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nnsttop,&
         int(size(oneNamelistFile%nnsttop,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nnstbot,&
         int(size(oneNamelistFile%nnstbot,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%gridu,&
         int(size(oneNamelistFile%gridu,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%gridv,&
         int(size(oneNamelistFile%gridv,1),i8),&
         oneParallelEnvironment%master_num)

    ! CCATT_INFO
    call parf_bcast(oneNamelistFile%ccatt,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%chemistry,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%split_method,&
         int(len(oneNamelistFile%split_method),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%chem_timestep,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%chemistry_aq,&
         oneParallelEnvironment%master_num)
!    call parf_bcast(oneNamelistFile%aerosol,&
!         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%chem_assim,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%srcmapfn,&
         int(len(oneNamelistFile%srcmapfn),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%recycle_tracers,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%def_proc_src,&
         int(len(oneNamelistFile%def_proc_src),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%diur_cycle,&
         int(size(oneNamelistFile%diur_cycle,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%na_extra2d,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%na_extra3d,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%plumerise,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%prfrq,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%volcanoes,&
         oneParallelEnvironment%master_num)
!Matrix
    call parf_bcast(oneNamelistFile%aerosol,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%aer_timestep,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%aer_assim,&
         oneParallelEnvironment%master_num)	 
	 
    call parf_bcast(oneNamelistFile%mech,&
         oneParallelEnvironment%master_num)
!--(DMK-CCATT-OLD)-----------------------------------------------------------
!    ! CATT_INFO
!    call parf_bcast(oneNamelistFile%catt,&
!         oneParallelEnvironment%master_num)
!    call parf_bcast(oneNamelistFile%firemapfn,&
!         int(len(oneNamelistFile%firemapfn),i8),&
!         oneParallelEnvironment%master_num)
!    call parf_bcast(oneNamelistFile%recycle_tracers,&
!         oneParallelEnvironment%master_num)
!    call parf_bcast(oneNamelistFile%plumerise,&
!         oneParallelEnvironment%master_num)
!    call parf_bcast(oneNamelistFile%define_proc,&
!         oneParallelEnvironment%master_num)
!    call parf_bcast(oneNamelistFile%prfrq,&
!         oneParallelEnvironment%master_num)
!--(DMK-CCATT-FIM)-----------------------------------------------------------
    ! TEB_SPM_INFO
    call parf_bcast(oneNamelistFile%teb_spm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%fusfiles,&
         int(len(oneNamelistFile%fusfiles),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ifusflg,&
         int(size(oneNamelistFile%ifusflg,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%IFUSFN,&
         int(len(oneNamelistFile%IFUSFN(1)),i8), &
         int(size(oneNamelistFile%IFUSFN,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ichemi,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ichemi_in,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%chemdata_in,&
         int(len(oneNamelistFile%chemdata_in),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isource,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%weekdayin,&
         int(len(oneNamelistFile%weekdayin),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%rushh1,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%rushh2,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%daylight,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%efsat,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%efsun,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eindno,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eindno2,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eindpm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eindco,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eindso2,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eindvoc,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eveino,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eveino2,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eveipm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eveico,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eveiso2,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eveivoc,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iteb,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tminbld,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nteb,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hc_roof,&
         int(size(oneNamelistFile%hc_roof,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tc_roof,&
         int(size(oneNamelistFile%tc_roof,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%d_roof,&
         int(size(oneNamelistFile%d_roof,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hc_road,&
         int(size(oneNamelistFile%hc_road,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tc_road,&
         int(size(oneNamelistFile%tc_road,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%d_road,&
         int(size(oneNamelistFile%d_road,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hc_wall,&
         int(size(oneNamelistFile%hc_wall,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tc_wall,&
         int(size(oneNamelistFile%tc_wall,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%d_wall,&
         int(size(oneNamelistFile%d_wall,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nurbtype,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ileafcod,&
         int(size(oneNamelistFile%ileafcod,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%z0_town,&
         int(size(oneNamelistFile%z0_town,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%bld,&
         int(size(oneNamelistFile%bld,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%bld_height,&
         int(size(oneNamelistFile%bld_height,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%bld_hl_ratio,&
         int(size(oneNamelistFile%bld_hl_ratio,1),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%aroof,&
         int(size(oneNamelistFile%aroof,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eroof,&
         int(size(oneNamelistFile%eroof,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%aroad,&
         int(size(oneNamelistFile%aroad,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%eroad,&
         int(size(oneNamelistFile%eroad,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%awall,&
         int(size(oneNamelistFile%awall,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ewall,&
         int(size(oneNamelistFile%ewall,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%htraf,&
         int(size(oneNamelistFile%htraf,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hindu,&
         int(size(oneNamelistFile%hindu,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%pletraf,&
         int(size(oneNamelistFile%pletraf,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%pleindu,&
         int(size(oneNamelistFile%pleindu,1),i8),&
         oneParallelEnvironment%master_num)
    ! MODEL_FILE_INFO
    call parf_bcast(oneNamelistFile%initial,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nud_type,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%varfpfx,&
         int(len(oneNamelistFile%varfpfx),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%vwait1,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%vwaittot,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nud_hfile,&
         int(len(oneNamelistFile%nud_hfile),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nudlat,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tnudlat,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tnudcent,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tnudtop,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%znudtop,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_nudge_grid,&
         int(size(oneNamelistFile%wt_nudge_grid,1),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_nudge_uv,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_nudge_th,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_nudge_pi,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_nudge_rt,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nud_cond,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%cond_hfile,&
         int(len(oneNamelistFile%cond_hfile),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tcond_beg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tcond_end,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%t_nudge_rc,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_nudgec_grid,&
         int(size(oneNamelistFile%wt_nudgec_grid,1),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%if_oda,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%oda_upaprefix,&
         int(len(oneNamelistFile%oda_upaprefix),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%oda_sfcprefix,&
         int(len(oneNamelistFile%oda_sfcprefix),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%frqoda,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%todabeg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%todaend,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tnudoda,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_oda_grid,&
         int(size(oneNamelistFile%wt_oda_grid,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_oda_uv,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_oda_th,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_oda_pi,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_oda_rt,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%roda_sfce,&
         int(size(oneNamelistFile%roda_sfce,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%roda_sfc0,&
         int(size(oneNamelistFile%roda_sfc0,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%roda_upae,&
         int(size(oneNamelistFile%roda_upae,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%roda_upa0,&
         int(size(oneNamelistFile%roda_upa0,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%roda_hgt,&
         int(size(oneNamelistFile%roda_hgt,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%roda_zfact,&
         int(size(oneNamelistFile%roda_zfact,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%oda_sfc_til,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%oda_sfc_tel,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%oda_upa_til,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%oda_upa_tel,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%if_cuinv,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%cu_prefix,&
         int(len(oneNamelistFile%cu_prefix),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tnudcu,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wt_cu_grid,&
         int(size(oneNamelistFile%wt_cu_grid,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tcu_beg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%tcu_end,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%cu_tel,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%cu_til,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%timstr,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hfilin,&
         int(len(oneNamelistFile%hfilin),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ipastin,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%pastfn,&
         int(len(oneNamelistFile%pastfn),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ioutput,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hfilout,&
         int(len(oneNamelistFile%hfilout),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%afilout,&
         int(len(oneNamelistFile%afilout),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iclobber,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ihistdel,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%frqhis,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%frqanl,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%frqlite,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ipos,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%xlite,&
         int(len(oneNamelistFile%xlite),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ylite,&
         int(len(oneNamelistFile%ylite),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%zlite,&
         int(len(oneNamelistFile%zlite),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nlite_vars,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%lite_vars,&
         int(len(oneNamelistFile%lite_vars(1)),i8), &
         int(size(oneNamelistFile%lite_vars,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%avgtim,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%frqmean,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%frqboth,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%kwrite,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%frqprt,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%initfld,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%prtcputime,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%topfiles,&
         int(len(oneNamelistFile%topfiles),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%sfcfiles,&
         int(len(oneNamelistFile%sfcfiles),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%sstfpfx,&
         int(len(oneNamelistFile%sstfpfx),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ndvifpfx,&
         int(len(oneNamelistFile%ndvifpfx),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%itoptflg,&
         int(size(oneNamelistFile%itoptflg,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isstflg,&
         int(size(oneNamelistFile%isstflg,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ivegtflg,&
         int(size(oneNamelistFile%ivegtflg,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isoilflg,&
         int(size(oneNamelistFile%isoilflg,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ndviflg,&
         int(size(oneNamelistFile%ndviflg,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nofilflg,&
         int(size(oneNamelistFile%nofilflg,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iupdndvi,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iupdsst,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%itoptfn,&
         int(len(oneNamelistFile%itoptfn(1)),i8), &
         int(size(oneNamelistFile%itoptfn,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isstfn,&
         int(len(oneNamelistFile%isstfn(1)),i8), &
         int(size(oneNamelistFile%isstfn,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ivegtfn,&
         int(len(oneNamelistFile%ivegtfn(1)),i8), &
         int(size(oneNamelistFile%ivegtfn,1),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isoilfn,&
         int(len(oneNamelistFile%isoilfn(1)),i8), &
         int(size(oneNamelistFile%isoilfn,1),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ndvifn,&
         int(len(oneNamelistFile%ndvifn(1)),i8), &
         int(size(oneNamelistFile%ndvifn,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%itopsflg,&
         int(size(oneNamelistFile%itopsflg,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%toptenh,&
         int(size(oneNamelistFile%toptenh,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%toptwvl,&
         int(size(oneNamelistFile%toptwvl,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iz0flg,&
         int(size(oneNamelistFile%iz0flg,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%z0max,&
         int(size(oneNamelistFile%z0max,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%z0fact,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%mkcoltab,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%coltabfn,&
         int(len(oneNamelistFile%coltabfn),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%mapaotfile,&
         int(len(oneNamelistFile%mapaotfile),i8),&
         oneParallelEnvironment%master_num)         
    ! MODEL_OPTIONS
!--(DMK-CCATT-INI)-----------------------------------------------------------
    call parf_bcast(oneNamelistFile%dyncore_flag,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%advmnt,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ghostzonelength,&
         oneParallelEnvironment%master_num)    
    
    call parf_bcast(oneNamelistFile%naddsc,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%icorflg,&
         oneParallelEnvironment%master_num)

!--(DMK-CCATT-INI)-----------------------------------------------------------
    call parf_bcast(oneNamelistFile%iexev,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%imassflx,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%vveldamp,&
         oneParallelEnvironment%master_num)
!--(DMK-CCATT-FIM)-----------------------------------------------------------
    call parf_bcast(oneNamelistFile%ibnd,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%jbnd,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%cphas,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%lsflg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nfpt,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%distim,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iswrtyp,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ilwrtyp,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%raddatfn,&
         int(len(oneNamelistFile%raddatfn),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%radfrq,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%lonrad,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nnqparm,&
         int(size(oneNamelistFile%nnqparm,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%closure_type,&
         int(len(oneNamelistFile%closure_type),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nnshcu,&
         int(size(oneNamelistFile%nnshcu,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%confrq,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%shcufrq,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wcldbs,&
         oneParallelEnvironment%master_num)

     call parf_bcast(oneNamelistFile%g3d_spread,&
         oneParallelEnvironment%master_num)
     call parf_bcast(oneNamelistFile%g3d_smoothh,&
         oneParallelEnvironment%master_num)
     call parf_bcast(oneNamelistFile%g3d_smoothv,&
         oneParallelEnvironment%master_num)	 
	 
    call parf_bcast(oneNamelistFile%npatch,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nvegpat,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isfcl,&
         oneParallelEnvironment%master_num)

    call parf_bcast(oneNamelistFile%nvgcon,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%pctlcon,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nslcon,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%drtcon,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%zrough,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%albedo,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%seatmp,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%dthcon,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%soil_moist,&
         int(len(oneNamelistFile%soil_moist),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%soil_moist_fail,&
         int(len(oneNamelistFile%soil_moist_fail),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%usdata_in,&
         int(len(oneNamelistFile%usdata_in),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%usmodel_in,&
         int(len(oneNamelistFile%usmodel_in),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%slz,&
         int(size(oneNamelistFile%slz,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%slmstr,&
         int(size(oneNamelistFile%slmstr,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%stgoff,&
         int(size(oneNamelistFile%stgoff,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%if_urban_canopy,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%idiffk,&
         int(size(oneNamelistFile%idiffk,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ihorgrad,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%csx,&
         int(size(oneNamelistFile%csx,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%csz,&
         int(size(oneNamelistFile%csz,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%xkhkm,&
         int(size(oneNamelistFile%xkhkm,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%zkhkm,&
         int(size(oneNamelistFile%zkhkm,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%akmin,&
         int(size(oneNamelistFile%akmin,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%mcphys_type,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%level,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%icloud,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%idriz,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%irime,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iplaws,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iccnlev,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%irain,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ipris,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isnow,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iaggr,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%igraup,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ihail,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%cparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%rparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%pparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%sparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%aparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%gparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%dparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%cnparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%gnparm,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%epsil,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%gnu,&
         int(size(oneNamelistFile%gnu,1),i8),&
         oneParallelEnvironment%master_num)
    ! MODEL_SOUND
    call parf_bcast(oneNamelistFile%ipsflg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%itsflg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%irtsflg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iusflg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hs,&
         int(size(oneNamelistFile%hs,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ps,&
         int(size(oneNamelistFile%hs,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ts,&
         int(size(oneNamelistFile%ts,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%rts,&
         int(size(oneNamelistFile%rts,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%us,&
         int(size(oneNamelistFile%us,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%vs,&
         int(size(oneNamelistFile%vs,1),i8),&
         oneParallelEnvironment%master_num)
    ! MODEL_PRINT
    call parf_bcast(oneNamelistFile%nplt,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iplfld,&
         int(len(oneNamelistFile%iplfld(1)),i8), &
         int(size(oneNamelistFile%iplfld,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ixsctn,&
         int(size(oneNamelistFile%ixsctn,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isbval,&
         int(size(oneNamelistFile%isbval,1),i8),&
         oneParallelEnvironment%master_num)
    ! ISAN_CONTROL
    call parf_bcast(oneNamelistFile%iszstage,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ivrstage,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isan_inc,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%guess1st,&
         int(len(oneNamelistFile%guess1st),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%i1st_flg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iupa_flg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%isfc_flg,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iapr,&
         int(len(oneNamelistFile%iapr),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iarawi,&
         int(len(oneNamelistFile%iarawi),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iasrfce,&
         int(len(oneNamelistFile%iasrfce),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%varpfx,&
         int(len(oneNamelistFile%varpfx),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ioflgisz,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ioflgvar,&
         oneParallelEnvironment%master_num)
    ! ISAN_ISENTROPIC
    call parf_bcast(oneNamelistFile%nisn,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%levth,&
         int(size(oneNamelistFile%levth,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nigrids,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%topsigz,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hybbot,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%hybtop,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%sfcinf,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%sigzwt,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%nfeedvar,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%maxsta,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%maxsfc,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%notsta,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%notid,&
         int(len(oneNamelistFile%notid(1)),i8), &
         int(size(oneNamelistFile%notid,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iobswin,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%stasep,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%igridfl,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%gridwt,&
         int(size(oneNamelistFile%gridwt,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%gobsep,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%gobrad,&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%wvlnth,&
         int(size(oneNamelistFile%wvlnth,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%swvlnth,&
         int(size(oneNamelistFile%swvlnth,1),i8),&
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%respon,&
         int(size(oneNamelistFile%respon,1),i8),&
         oneParallelEnvironment%master_num)
    ! POST
    call parf_bcast(oneNamelistFile%nvp, &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%vp, &
         int(len(oneNamelistFile%vp(1)),i8), &
         int(size(oneNamelistFile%vp,1),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%gprefix, &
         int(len(oneNamelistFile%gprefix),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%anl2gra, &
         int(len(oneNamelistFile%anl2gra),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%proj, &
         int(len(oneNamelistFile%proj),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%mean_type, &
         int(len(oneNamelistFile%mean_type),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%lati, &
         int(maxgrds,i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%loni, &
         int(maxgrds,i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%latf, &
         int(maxgrds,i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%lonf, &
         int(maxgrds,i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%zlevmax, &
         int(maxgrds,i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ipresslev, &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%inplevs, &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%iplevs, &
         int(nzpmax,i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%mechanism, &
         int(len(oneNamelistFile%mechanism),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%ascii_data, &
         int(len(oneNamelistFile%ascii_data),i8), &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%site_lat, &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%site_lon, &
         oneParallelEnvironment%master_num)
 
 !digital filter

    call parf_bcast(oneNamelistFile%applyDigitalFilter, &
         oneParallelEnvironment%master_num)
    call parf_bcast(oneNamelistFile%digitalFilterTimeWindow, &
         oneParallelEnvironment%master_num)

 !meteogram
	 
   call parf_bcast(oneNamelistFile%applyMeteogram, &
                   oneParallelEnvironment%master_num)
	 
 call parf_bcast(oneNamelistFile%meteogramFreq, &
         oneParallelEnvironment%master_num)
 
  call parf_bcast(oneNamelistFile%meteogramMap, &
         int(len(oneNamelistFile%meteogramMap),i8), &
         oneParallelEnvironment%master_num)
	 
  call parf_bcast(oneNamelistFile%meteogramDir, &
         int(len(oneNamelistFile%meteogramDir),i8), &
         oneParallelEnvironment%master_num)

  end subroutine BroadcastNamelistFile



  subroutine TimeUnitsToSeconds(oneNamelistFile)
    type(namelistFile), pointer :: oneNamelistFile

    real :: tfact
    character(len=*), parameter :: h="**(TimeUnitsToSeconds)**"

    select case (oneNamelistFile%timeunit) 
    case ("d","D")
       tfact = 86400.
    case ("h","H")
       tfact =  3600.
    case ("m","M")
       tfact =    60.
    case ("s","S")
       tfact =     1.
    case default
       call fatal_error(h//" Namelist timeunit ="//&
            &trim(oneNamelistFile%timeunit)//" has to be d, h, m or s")
    end select

    oneNamelistFile%timmax=oneNamelistFile%timmax*tfact
    oneNamelistFile%timstr=oneNamelistFile%timstr*tfact
  end subroutine TimeUnitsToSeconds




  subroutine DumpNamelistFile(oneNamelistFile)
    implicit none
    type(namelistFile), pointer :: oneNamelistFile


    integer :: ng,np,k,m
    integer :: lenLine, lenThis

    ! This routine prints out a listing of the values of all variables
    ! in the NAMELISTS


    write(6,100)
100 format(/,'----------------------------NAMELIST VARIABLES-------',  &
         '------------------------',/)

    do ng = 1, oneNamelistFile%ngrids
       write(*,"(1(a,i4))") &
            ' CONFIGURATION FOR GRID:',ng
       write(*,"(5(a,i4))") &
            '       NNXP=',oneNamelistFile%nnxp(ng),	&
            '       NNYP=',oneNamelistFile%nnyp(ng),	&
            '       NNZP=',oneNamelistFile%nnzp(ng),	&
            '    NXTNEST=',oneNamelistFile%nxtnest(ng), &
            '    NSTRATX=',oneNamelistFile%nstratx(ng)
       write(*,"(a,5(a,i4))") &
            '            	',			 &
            '    NSTRATY=', oneNamelistFile%nstraty(ng), &
            '     IDIFFK=', oneNamelistFile%idiffk(ng), &
            '    NNDTRAT=', oneNamelistFile%nndtrat(ng), &
            '    NNQPARM=', oneNamelistFile%nnqparm(ng), &
            '     NINEST=', oneNamelistFile%ninest(ng)
    end do

    if (len_trim(oneNamelistFile%domain_fname) > 0) then
       write(*, '("Domain File Name =",A80)') oneNamelistFile%domain_fname
    else
       write(*, '("Using default domain decomposition")')
    endif


    write(*,"(a)") " Closure type for Grell Parametrization is: "//oneNamelistFile%closure_type

    write(*,999) (' ', oneNamelistFile%nnshcu(ng), ng=1, oneNamelistFile%ngrids)  ! For Shallow Cumulus Param.

    write(*,103)(' ',oneNamelistFile%njnest(ng),oneNamelistFile%nknest(ng),oneNamelistFile%nnsttop(ng)  &
         ,oneNamelistFile%nnstbot(ng),oneNamelistFile%itoptflg(ng),ng=1,oneNamelistFile%ngrids)
    write(*,104)(' ',oneNamelistFile%isstflg(ng),oneNamelistFile%ivegtflg(ng),oneNamelistFile%isoilflg(ng)  &
         ,oneNamelistFile%nofilflg(ng),oneNamelistFile%ndviflg(ng),ng=1,oneNamelistFile%ngrids)

999 format(A1,' NNSHCU=',I4,999(A1,/,I13))  ! For Shallow Cumulus Param.

103 format(A1,' NJNEST=',I4,'     NKNEST=',I4,'    NNSTTOP=',I4  &
         ,'    NNSTBOT=',I4,'   ITOPTFLG=',I4,999(A1,/,I13,4I16))
104 format(A1,'ISSTFLG=',I4,'   IVEGTFLG=',I4,'   ISOILFLG=',I4  &
         ,'   NOFILFLG=',I4,'    NDVIFLG=',I4,999(A1,/,I13,4I16))

    write(*, "(' ')")
    write(*,201)oneNamelistFile%ngrids,oneNamelistFile%nestz1,oneNamelistFile%nestz2,&
         oneNamelistFile%initial,oneNamelistFile%ioutput,oneNamelistFile%nudlat,&
         oneNamelistFile%if_adap
201 format('  NGRIDS=',I4,'     NESTZ1=',I4,'     NESTZ2=',I4  &
         ,'    INITIAL=',I4,'    IOUTPUT=',I4,'     NUDLAT=',I4,'     IF_ADAP=',I4)
    write(*,FMT="('IPOS=',I4)") oneNamelistFile%ipos
    write(*,202)oneNamelistFile%initfld,oneNamelistFile%ihtran,oneNamelistFile%nacoust,&
         oneNamelistFile%kwrite
202 format(' INITFLD=',I4,'     IHTRAN=',I4  &
         ,'    NACOUST=',I4,'     KWRITE=',I4)
    write(*,203)oneNamelistFile%iupdsst,&
         oneNamelistFile%icorflg,&
!--(DMK-CCATT-INI)-----------------------------------------------------
         oneNamelistFile%iexev,oneNamelistFile%imassflx,oneNamelistFile%vveldamp, &
!--(DMK-CCATT-FIM)-----------------------------------------------------        
	 oneNamelistFile%nslcon,oneNamelistFile%ibnd
203 format(' IUPDSST=',I4  &
         ,'    ICORFLG=',I4&
!--(DMK-CCATT-INI)-----------------------------------------------------
         ,'      IEXEV=',I4,'   IMASSFLX=',I4, '   VVELDAMP=',I4&
!--(DMK-CCATT-FIM)-----------------------------------------------------
         ,'     NSLCON=',I4,'       IBND=',I4)
    write(*,204)oneNamelistFile%jbnd,oneNamelistFile%lsflg,oneNamelistFile%nfpt,&
         oneNamelistFile%ideltat,oneNamelistFile%iswrtyp,oneNamelistFile%ilwrtyp
204 format('    JBND=',I4,'      LSFLG=',I4,'       NFPT=',I4  &
         ,'    IDELTAT=',I4,'    ISWRTYP=',I4,'    ILWRTYP=',I4)
    write(*,205)oneNamelistFile%lonrad,oneNamelistFile%imonth1,oneNamelistFile%idate1,&
         oneNamelistFile%iyear1,oneNamelistFile%itime1,oneNamelistFile%isfcl
205 format('  LONRAD=',I4,'    IMONTH1=',I4,'     IDATE1=',I4  &
         ,'     IYEAR1=',I4,'     ITIME1=',I4,'      ISFCL=',I4)
    write(*,206)oneNamelistFile%nvgcon,oneNamelistFile%nplt,oneNamelistFile%ipsflg,&
         oneNamelistFile%itsflg,oneNamelistFile%irtsflg
206 format('  NVGCON=',I4,'       NPLT=',I4,'     IPSFLG=',I4  &
         ,'     ITSFLG=',I4,'    IRTSFLG=',I4)
    write(*,207)oneNamelistFile%iusflg,oneNamelistFile%mkcoltab,oneNamelistFile%nzg,&
         oneNamelistFile%nzs,oneNamelistFile%iupdndvi
207 format('  IUSFLG=',I4,'   MKCOLTAB=',I4,'        NZG=',I4  &
         ,'        NZS=',I4,'   IUPDNDVI=',I4)
    write(*,208)oneNamelistFile%npatch,oneNamelistFile%nvegpat
208 format('  NPATCH=',I4,'    NVEGPAT=',I4)

    write(*,211)oneNamelistFile%mcphys_type,oneNamelistFile%level,&
         oneNamelistFile%icloud,oneNamelistFile%idriz
211 format('  MCPHYS_TYPE=',I4,'      LEVEL=',I4, '     ICLOUD=',I4 &
         ,'     IDRIZ=',I4)
    write(*,212)oneNamelistFile%iccnlev,oneNamelistFile%irime,&
         oneNamelistFile%iplaws
212 format('  ICCNLEV=',I4,'     IRIME=',I4 &
         ,'     IPLAWS=',I4)

    write(*,209)oneNamelistFile%irain,oneNamelistFile%ipris,oneNamelistFile%isnow,&
         oneNamelistFile%iaggr,oneNamelistFile%igraup
209 format('   IRAIN=',I4,'      IPRIS=',I4,'      ISNOW=',I4  &
         ,'      IAGGR=',I4,'     IGRAUP=',I4)

    write(*,210)oneNamelistFile%ihail,oneNamelistFile%naddsc
210 format('   IHAIL=',I4,'     NADDSC=',I4 )

    write(*, "(' ')")
    write(*,301)(' ',oneNamelistFile%toptenh(ng),oneNamelistFile%toptwvl(ng),&
         oneNamelistFile%centlat(ng),ng=1,oneNamelistFile%ngrids)
301 format(A1,'TOPTENH=',E12.5,'        TOPTWVL=',E12.5  &
         ,'        CENTLAT=',E12.5,999(A1,/,E21.5,2E28.5))
    write(*,302)(' ',oneNamelistFile%centlon(ng),oneNamelistFile%csx(ng),&
         oneNamelistFile%csz(ng),ng=1,oneNamelistFile%ngrids)
302 format(A1,'CENTLON=',E12.5,'            CSX=',E12.5  &
         ,'            CSZ=',E12.5,999(A1,/,E21.5,2E28.5))
    write(*,303)(' ',oneNamelistFile%xkhkm(ng),oneNamelistFile%zkhkm(ng),&
         oneNamelistFile%akmin(ng),ng=1,oneNamelistFile%ngrids)
303 format(A1,'  XKHKM=',E12.5,'          ZKHKM=',E12.5  &
         ,'          AKMIN=',E12.5,999(A1,/,E21.5,2E28.5))
    write(*,304)(' ',oneNamelistFile%gridu(ng),oneNamelistFile%gridv(ng),&
         ng=1,oneNamelistFile%ngrids)
304 format(A1,'  GRIDU=',E12.5,'          GRIDV=',E12.5  &
         ,999(A1,/,E21.5,E28.5))
	 
!--(DMK-CCATT-INI)-----------------------------------------------------
    write(*,305) oneNamelistFile%dyncore_flag, oneNamelistFile%advmnt,&
     oneNamelistFile%GhostZoneLength
305 format( "dyncore_flag=",I4,'  ADVMNT=',I4,'        GHOSTZONELENGTH=',I4)
!--(DMK-CCATT-FIM)-----------------------------------------------------

    write(*, "(' ')")
    write(*,401)oneNamelistFile%timmax,oneNamelistFile%timstr,oneNamelistFile%frqhis
401 format('   TIMMAX=',E12.5,'         TIMSTR=',E12.5  &
         ,'         FRQHIS=',E12.5)
    write(*,402)oneNamelistFile%frqanl,oneNamelistFile%frqprt,oneNamelistFile%tnudlat
402 format('   FRQANL=',E12.5,'         FRQPRT=',E12.5  &
         ,'        TNUDLAT=',E12.5)
    write(*,403)oneNamelistFile%tnudtop,oneNamelistFile%tnudcent,oneNamelistFile%znudtop
403 format('  TNUDTOP=',E12.5,'       TNUDCENT=',E12.5  &
         ,'        ZNUDTOP=',E12.5)
    write(*,404)oneNamelistFile%dtlong,oneNamelistFile%deltax,oneNamelistFile%deltay
404 format('   DTLONG=',E12.5,'         DELTAX=',E12.5  &
         ,'         DELTAY=',E12.5)
    write(*,405)oneNamelistFile%polelat,oneNamelistFile%polelon,oneNamelistFile%deltaz
405 format('  POLELAT=',E12.5,'        POLELON=',E12.5  &
         ,'         DELTAZ=',E12.5)
    write(*,406)oneNamelistFile%dzrat,oneNamelistFile%dzmax
406 format('    DZRAT=',E12.5,'          DZMAX=',E12.5)
    write(*,407)oneNamelistFile%cphas,oneNamelistFile%distim,oneNamelistFile%radfrq
407 format('    CPHAS=',E12.5,'         DISTIM=',E12.5  &
         ,'         RADFRQ=',E12.5)
    write(*,408)oneNamelistFile%confrq,oneNamelistFile%wcldbs
408 format('   CONFRQ=',E12.5,'         WCLDBS=',E12.5)

    write(*,409)oneNamelistFile%shcufrq 
409 format('   SHCUFRQ=',E12.5)  ! For Shallow Cumulus

    write(*,410)oneNamelistFile%pctlcon,oneNamelistFile%zrough,oneNamelistFile%albedo
410 format('  PCTLCON=',E12.5,'         ZROUGH=',E12.5  &
         ,'         ALBEDO=',E12.5)
    write(*,411)oneNamelistFile%seatmp,oneNamelistFile%dthcon,oneNamelistFile%drtcon
411 format('   SEATMP=',E12.5,'         DTHCON=',E12.5  &
         ,'         DRTCON=',E12.5)
    write(*,412)oneNamelistFile%cparm,oneNamelistFile%rparm,oneNamelistFile%pparm
412 format('    CPARM=',E12.5,'          RPARM=',E12.5  &
         ,'          PPARM=',E12.5)
    write(*,413)oneNamelistFile%sparm,oneNamelistFile%aparm,oneNamelistFile%gparm
413 format('    SPARM=',E12.5,'          APARM=',E12.5  &
         ,'          GPARM=',E12.5)
    write(*,414)oneNamelistFile%hparm,oneNamelistFile%dparm
414 format('    HPARM=',E12.5, '    DPARM=',E12.5)
    write(*,416)oneNamelistFile%cnparm,oneNamelistFile%gnparm,oneNamelistFile%epsil
416 format('    CNPARM=',E12.5, '    GNPARM=',E12.5, '    EPSIL=',E12.5)

    write(*,415)oneNamelistFile%g3d_spread
415 format('    G3D_SPREAD=',I4)

!srf    write(*,416)oneNamelistFile%g3d_smoothh
!srf 416 format('    g3d_smoothh=',I4)

!srf    write(*,417)oneNamelistFile%g3d_smoothv
!srf 417 format('    g3d_smoothv=',I4)
!
!    write(*, "(' ')")
    write(*,601)(' ',oneNamelistFile%itoptfn(m),m=1,oneNamelistFile%ngrids)
601 format(A1,'  ITOPTFN=',A40,999(A1,/,11X,A40))
    write(*,602)(' ',oneNamelistFile%isstfn(m),m=1,oneNamelistFile%ngrids)
602 format(A1,'   ISSTFN=',A40,999(A1,/,11X,A40))
    write(*,603)(' ',oneNamelistFile%ivegtfn(m),m=1,oneNamelistFile%ngrids)
603 format(A1,'  IVEGTFN=',A40,999(A1,/,11X,A40))
    write(*,604)(' ',oneNamelistFile%isoilfn(m),m=1,oneNamelistFile%ngrids)
604 format(A1,'  ISOILFN=',A40,999(A1,/,11X,A40))
    write(*,605)(' ',oneNamelistFile%ndvifn(m),m=1,oneNamelistFile%ngrids)
605 format(A1,'   NDVIFN=',A40,999(A1,/,11X,A40))
    write(*,606) ' ',trim(oneNamelistFile%coltabfn)
606 format(A1,' COLTABFN=',A)
    write(*,610) ' ',trim(oneNamelistFile%MapAOTFile)
610 format(A1,' MAPAOTFILE=',A)
    write(*,607) ' ',trim(oneNamelistFile%varfpfx)
607 format(A1,'  VARFPFX=',A)
    write(*,608) ' ',trim(oneNamelistFile%sstfpfx)
608 format(A1,'  SSTFPFX=',A)
    write(*,609) ' ',trim(oneNamelistFile%ndvifpfx)
609 format(A1,' NDVIFPFX=',A)

    !write(*, "(' ')")
    write(*,701)oneNamelistFile%expnme
701 format('  EXPNME=',A40)
    write(*,705)oneNamelistFile%runtype,oneNamelistFile%timeunit
705 format(' RUNTYPE=',A10,'      TIMEUNIT=',A3)
    !write(*, "(' ')")
    write(*,702)oneNamelistFile%hfilin
702 format('  HFILIN=',A40)
    write(*,703)oneNamelistFile%hfilout
703 format(' HFILOUT=',A40)
    write(*,704)oneNamelistFile%afilout
704 format(' AFILOUT=',A40)
    write(*,*) 'SOIL_MOIST = ', oneNamelistFile%soil_moist
    write(*,*) 'SOIL_MOIST_FAIL = ', oneNamelistFile%soil_moist_fail
    write(*,711) oneNamelistFile%usdata_in
711 format(' USDATA_IN =',A40)
    write(*,712) oneNamelistFile%usmodel_in
712 format(' USMODEL_IN=',A40)
    write(*,901)(' ',oneNamelistFile%slmstr(k),oneNamelistFile%slz(k),&
         oneNamelistFile%stgoff(k),k=1,oneNamelistFile%nzg)
901 format(A1,' SLMSTR=',F6.2,'      SLZ=',F7.3,'      STGOFF=',F8.2  &
         ,999(A1,/,F15.2,F17.3,F21.2))
    write(*,1001)(oneNamelistFile%zz(k),k=1,oneNamelistFile%nnzp(1))
1001 format('ZZ=',8F9.1,/,(F12.1,7F9.1))

    write(*,1101)(oneNamelistFile%nstratz1(k),k=1,oneNamelistFile%nnzp(1))
1101 format(/,'NSTRATZ1=',(t9,23i3) )

    write(*,1201)(oneNamelistFile%nstratz2(k),k=1,oneNamelistFile%nnzp(1))
1201 format(/,'NSTRATZ2=',(t9,23i3) )

    write(*,1301)(oneNamelistFile%gnu(k),k=1,7)
1301 format(/,'GNU=',(t9,7f5.2))

    !New rad carma
    if (oneNamelistFile%iswrtyp==4 .or. oneNamelistFile%ilwrtyp==4) then
       write(*,FMT='("RADDATFN = ",A80)')  trim(oneNamelistFile%raddatfn)
    endif

    !write(*, "('==============================================================')")
    if (oneNamelistFile%teb_spm/=1) then
       write(*,FMT='(A,I2)') 'TEB_SPM module not activated: TEB_SPM=', oneNamelistFile%teb_spm
    else
       write(*,FMT='(A,I2)') 'TEB_SPM module activated: TEB_SPM=', oneNamelistFile%teb_spm
    endif
    !write(*, "('==============================================================')")

!--(DMK-CCATT-INI)-----------------------------------------------------------
    if (oneNamelistFile%ccatt == 1) then
       write(*,FMT='(A,I2)') 'CCATT module activated:'
       write(*,FMT='(3x,A,I2)') 'CHEMISTRY= ', oneNamelistFile%chemistry
       write(*,"(3x,a)") "SPLIT_METHOD= "//trim(oneNamelistFile%split_method)
       write(*,FMT='(3x,A,F8.2)') 'CHEM_TIMESTEP= ', oneNamelistFile%chem_timestep
       write(*,FMT='(3x,A,I2)') 'CHEMISTRY_AQ= ', oneNamelistFile%chemistry_aq
       write(*,FMT='(3x,A,I2)') 'CHEM_ASSIM= ', oneNamelistFile%chem_assim
       write(*,"(3x,a)") "SRCMAPFN= "//trim(oneNamelistFile%srcmapfn)
       write(*,FMT='(3x,A,I2)') 'RECYCLE_TRACERS= ', oneNamelistFile%recycle_tracers
       write(*,"(3x,a)") "DEF_PROC_SRC ="//trim(oneNamelistFile%def_proc_src)
       write(*,FMT="(3x,A,4i3)")'DIUR_CYCLE=',(oneNamelistFile%diur_cycle(k),k=1,nsrc)
!   format((t12,23i3) )
       write(*,FMT='(3x,A,I2)') 'NA_EXTRA2D= ', oneNamelistFile%na_extra2d
       write(*,FMT='(3x,A,I2)') 'NA_EXTRA3D= ', oneNamelistFile%na_extra3d
       write(*,FMT='(3x,A,I2)') 'PLUMERISE= ', oneNamelistFile%plumerise
       write(*,FMT='(3x,A,F8.2)') 'PRFRQ= ', oneNamelistFile%prfrq
       write(*,FMT='(3x,A,I2)') 'VOLCANOES= ', oneNamelistFile%volcanoes
       write(*,FMT='(3x,A,I2)') 'AEROSOL= ', oneNamelistFile%aerosol
       !if(oneNamelistFile%aerosol == 2) then
         write(*,FMT='(3x,A,F8.2)') 'AER_TIMESTEP= ', oneNamelistFile%aer_timestep
         !write(*,FMT='(3x,A,I2)')'AER_ASSIM=', oneNamelistFile%aer_assim
         !write(*,FMT='(3x,A,I2)') 'MECH= ', oneNamelistFile%mech 
       !endif
       !write(*, "(' ')")
    else
       write(*,FMT='(A,I2)') 'CCATT module NOT activated - CCATT=',oneNamelistFile%ccatt
    endif
    ! dump POST
    IF(oneNamelistFile%ipos > 0 ) then
     write(*,"(a)") "POST file prefix is "//trim(oneNamelistFile%gprefix)
     write(*,"(3x,a,i3,a)") "POST will write ", oneNamelistFile%nvp, " fields: "

     lenLine=0
     do k = 1, oneNamelistFile%nvp
       lenThis = len_trim(oneNamelistFile%vp(k))
       if (lenLine+lenThis > 80) then
          write(*, "(' ')")
          write(*,"(3x,a)", advance="no") trim(oneNamelistFile%vp(k))
          lenLine = lenThis + 1
       else if (lenLine == 0) then
          lenLine = lenLine + lenThis + 1
          write(*,"(3x,a)", advance="no") trim(oneNamelistFile%vp(k))
       else
          lenLine = lenLine + lenThis + 1
          write(*,"(3x,a)", advance="no") ", "//trim(oneNamelistFile%vp(k))
       end if
     end do
    ELSE
     write(*,"(a,I2)") "POST processing is turned off: IPOS=",oneNamelistFile%ipos
    ENDIF

    write(*,"(/,'----------------------------NAMELIST VARIABLES ENDS--',&
         &'------------------------',/)")
  end subroutine DumpNamelistFile
end module ModNamelistFile
