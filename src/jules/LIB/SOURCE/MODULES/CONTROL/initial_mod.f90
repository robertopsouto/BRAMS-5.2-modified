! Contains variables and procedures related to setting the initial state, and the
! reading and writing of dumps.
!
! It would be clearer to separate the dump i/o code into another file, but the
! easiest way to do that would currently result in circular dependencies, so
! left for now!
!
!###############################################################################

  MODULE initial_mod

  IMPLICIT NONE

!-------------------------------------------------------------------------------
! Scalar parameters.
!-------------------------------------------------------------------------------
  INTEGER, PARAMETER :: nvarMax = 36   !  the number of all possible variables
!                      that can be used to
!                      define the initial state.
!                      This may be (it is!) larger than the number needed for
!                      any particular configuration.
!                      Each variable must have an iposXX variable declared below.

  INTEGER, PARAMETER :: ndimMax = 4  !  max possible number of dimensions in a
!                               variable. These are x,z,psuedo,t.
!                 This section of code only ever deals with a single time level,
!                 but include a t dim for consistency with diagnostic output.

!-------------------------------------------------------------------------------
! Scalar variables.
!-------------------------------------------------------------------------------
  INTEGER ::  &
!   Every possible variable (nvarMax) must have an "iposX" variables declared here
    iposCanht      &!  position of canht_ft in list of all possible variables
   ,iposCanopy     &!  position of canopy in list of all possible variables
   ,iposCs         &!  position of cs in list of all possible variables
   ,iposFrac       &!  position of frac in list of all possible variables
   ,iposGLeafAcc   &!  position of g_leaf_acc
   ,iposGLeafPhenAcc &!  position of g_leaf_phen_acc
   ,iposGs         &!  position of gs in list of all possible variables
   ,iposLAI        &!  position of LAI in list of all possible variables
   ,iposNppFtAcc   &!  position of npp_ft_acc
   ,iposNsnow      &!  position of nSnow
   ,iposRespSAcc   &!  position of resp_s_acc
   ,iposRespWFtAcc &!  position of resp_w_ft_acc
   ,iposRgrain     &!  position of rgrain in list of all possible variables
   ,iposRgrainL    &!  position of rgrainL in list of all possible variables
   ,iposRhoSnow    &!  position of rho_snow_grnd in list of all possible variables
   ,iposRouteStore &!  position of routeStore in list of all possible variables
   ,iposSnowDepth  &!  position of snowDepth in list of all possible variables
   ,iposSnowDs     &!  position of ds in list of all possible variables
   ,iposSnowGrnd   &!  position of snow_grnd in list of all possible variables
   ,iposSnowIce    &!  position of sice in list of all possible variables
   ,iposSnowLiq    &!  position of sliq in list of all possible variables
   ,iposSnowTile   &!  position of snow_tile in list of all possible variables
   ,iposSthf       &!  position of sthf in list of all possible variables
   ,iposSthu       &!  position of sthu in list of all possible variables
   ,iposSthuf      &!  position of sthuf (sthuf=sthu+sthf) in list of all
!                      possible variables
   ,iposSthzw      &!  position of sthzw in list of all possible variables
   ,iposTsnow      &!  position of tsnow in list of all possible variables
   ,iposTsoil      &!  position of t_soil in list of all possible variables
   ,iposTstarT     &!  position of tstar_tile in list of all possible variables
   ,iposZw         &!  position of zw in list of all possible variables
   ,iposCo2        &!  position of IMOGEN Atmospheric CO2 concentration in
!                   !  list of all possible variables
   ,iposCo2Change  &!  position of change in IMOGEN Atmospheric CO2 concentration
!                   !  (i.e. gradient) in list of all possible variables
   ,iposDTempO     &!  postion of IMOGEN variable dtemp_o in list of all possible variables
   ,iposFaOcean    &!  position of IMOGEN variable fa_ocean in list of all possible variables
   ,iposSeedRain   &!  position of IMOGEN variable seed_rain in list of all
!                   !  possible variables
   ,iposCv          !  position of cv in list of all possible variables
   

   LOGICAL ::  zrevSnow  !    Flag to reverse the order of the snow layers in
!                    the input data.
!                    Model snow levels start from that at the top of the
!                    snowpack and increase with depth (top to bottom of snowpack).
!                    F means the input snow data are arranged top to bottom
!                    T means the input snow data are arranged bottom to top.

   LOGICAL ::  zrevSoil  !    Flag to reverse the order of the soil layers in
!                             the input data. Model soil levels start from that
!                             at the ground surface and increase with
!                             depth (top to bottom).
!                             F means the input soil data are arranged top to
!                             bottom
!                             T means the input soil data are arranged bottom
!                             to top.
!-------------------------------------------------------------------------------
! Array variables.
!-------------------------------------------------------------------------------
  INTEGER ::    &
    varNdim(nvarMax)          &!  number of dimensions for a variable
   ,varSize(nvarMax,ndimMax)  &!  size of each variable (only used for ASCII)
!                           2nd dimension: 1= "spatial extent" (e.g. land_pts)
!                                          2:= number of levels
!                           If a variable does not have layers dimension X, set
!                           varSize(i,X)=1.
   ,varNzRead(nvarMax)  &!  number of levels to be read in for each variable
!                           (i.e. not necessarily the number of levels in a
!                           variable - we could read one and copy to all layers)
!                           At present varNzRead is redundant and equals the
!                           product of varSize(ivar,2:).
!                           This is only used for ASCII and binary input (not netCDF).
   ,varFlag(nvarMax)    &!  flag indicating how a variable is to be initialised
!                     0  field is not required
!                    >0  field number in an unformatted file
!                        This is the 'level' number of the first level in this
!                        field.
!                    -1  spatially constant using a single value read in
!                    -2  field will be calculated from others (in this case,
!                        this field will not be input) This might mean that a field
!                        is derived from other variables.
!                   <-2  special options for particular variables
   ,varStash(nvarMax)  &!  STASH code for each variable
   ,varUse(nvarMax)     !  flag indicating if and how a variable is used
!                             0 = not needed (so not input)
!                             1 = needed (but can be set indirectly, in which
!                                 case it is not input)
!                             2 = needed indirectly only (to set another variable,
!                                 e.g. sthu may be used to calculate sthuf)

  REAL :: varConst(nvarMax)  !  work: value of each variable used if a spatially
!                               constant condition is requested

  REAL, ALLOCATABLE :: workSpace(:,:)  !  work space

  LOGICAL :: icVarSet(nvarMax)   !  flag indicating if a variable has been
!                                   initialised. Used to detect errors (probably
!                                   in the code!).
  LOGICAL :: varDump(nvarMax)    !  flag indicating that a variable is to be
!                           written to dump.
!                           This is equivalent to indicating that this is a state
!                           variable that must be initialised (somehow).

! Note that we have both varUse and varDump to cope with circumstances where
! a variable is to be included in dumps but is not to be initialised. At
! present this rather unusual set of circumstances cannot occur! - but at one
! time it was allowed for equilibrium-mode runs of ECOSSE, which didn't need
! soil C and N stores to be initialised, but which did need to write the
! final calculated states to dumps.
! So the code has been left for now -  it means there is a variable (varDump)
! whose sole purpose is to indicate "put into dump".

  CHARACTER(len=2) :: varType(nvarMax)   !  indicates type of variable

  CHARACTER(len=50) :: varName(nvarMax)  !  names of variables as read from run
!                control file - only used to identify variables in this routine

  CHARACTER(len=100) :: varNcAtt(nvarMax,4)  ! netCDF attributes of variables
!                     1=axes, 2=units, 3=name, 4=description

  CHARACTER(len=150) :: varDesc(nvarMax)     !  description of each possible
!                                               variable, excluding units
  CHARACTER(len=150) :: varDescFull(nvarMax) !  description of each possible
!                                               variable, including units
  CHARACTER(len=20) :: varUnits(nvarMax) !  units of each variable
!-------------------------------------------------------------------------------
!--- DSM{
  REAL :: lon,lat,cs_aux
  INTEGER :: sai
!---DSM }

  CONTAINS

!###############################################################################
!###############################################################################

! subroutine init_ic
! Internal procedure in module initial_mod.
! Sets the initial condition (initial state).
!
! Note that different approaches have been used for the selection of variables
! in different initialisation routines - could do with being rationalised!
!
! This subroutine has evolved as the model has developed, and some of the
! structures might well be thoroughly "sub-optimal" now. Feel free to rewrite!
! Generally I have tried to retain flexibility for offline applications so
! that they can be initialised in different ways (i.e. don't always need to
! input all prognostics directly, but can derive values) - which has resulted
! in some relatively complicated code. And no doubt some loopholes.
!
! Also - the approach taken here has, in the main, been to try to proceed
! with whatever variables have been made available, subject to the indicated
! options, rather than to stop whenever any possible inconsistency has been
! found. This relates to variables that can be set in more than one way.
! Some examples:
! 1) Say we find an ECOSSE variable is listed (OK, not in this particular
!    version!!), despite ECOSSE being off.
! We could treat this as an error and stop, but this is annoying if we just want
! to quickly switch the model off to test something - it means the list of
! input variables must be rewritten for every run. So we raise a warning and
! proceed, ignoring the ECOSSE variables.
! 2) Say we try to read a non-prognostic variable from a dump file (where it
! will never appear). We could stop before we even attempt this, or we can wait
! unti the variable cannot be found in the dump. The latter is easier as it
! doesn't require new code and would also work (without new code) for variables
! that are prognostic in some configurations and can be used but not prognostically
! in others (none at present!).
! However...in some cases I have opted to stop to highlight to the user that
! there is some inconsistency, particularly between different sections of the code
! e.g. canopy properties cannot be initialised here if they are not prognostic.

  SUBROUTINE init_ic(nia,nja,npatch,nzg,nstyp,patch_area,veg_fracarea,leaf_class,stom_resist &
                     ,soil_water,soil_text,slmsts,veg_lai,temp2,soil_energy &
                     ,veg_ht,slcpd,nvtyp_teb,MYNUM,hfilout,hfilin,runtype)

!DSM {
!! Variaveis provenientes do BRAMS, todas com: intent(in) 
!  USE leaf_coms, ONLY : &
!     veg_ht,  slcpd        
!DSM }

  USE ancil_info, ONLY :  &
!  imported scalars with intent(in)
     dim_cs1,land_pts,nsmax,ntiles,sm_levels,soil_pts,row_length,land_index  &
!  imported scalars with intent(out)
    ,lice_pts  &
!  imported arrays with intent(inout)
    ,frac,soil_index  &
!  imported arrays with intent(out)
    ,lice_index,tile_index,tile_pts

  USE c_densty, ONLY :  &
!  imported scalar parameters
     rho_water

  USE file_utils, ONLY:  &
!  imported procedures
     closeFile,fileUnit,findTag,openFile  &
!  imported arrays with intent(inout)
    ,irecPrev

  USE grid_utils, ONLY :  &
!  imported procedures
     getXYPos

  USE inout, ONLY :   &
!  imported scalar parameters
     formatAsc,formatBin,formatLen,formatNc,formatPP,jinUnit,tagAscBin,tagNc   &
!  imported scalars with intent(in)
    ,echo,nxIn,nyIn,readFracIC  &
!  imported arrays with intent(in)
    ,mapInLand,outDir,runID

  USE jules_netcdf, ONLY :  &
!  imported scalars with intent(in)
     ncType

  USE misc_utils, ONLY :   &
!  imported procedures
     checkVarPos,checkVars,read_list,repeatVal,varInfo,varList

  USE nstypes, ONLY :  &
!  imported scalars with intent(in)
     ice,npft,ntype,urban,urban_canyon,urban_roof

  USE p_s_parms, ONLY :   &
!  imported arrays with intent(in)
     b,sathh,smvcst  &
!  imported arrays with intent(out)
    ,sthf,sthu   !   under some circumstances, sthu initially holds sthuf

  USE prognostics, ONLY :  &
!  imported arrays with intent(out)
     smcl,t_soil

  USE readWrite_mod, ONLY :  &
!  imported procedures
     readVar2d,readvar3dComp

  USE route_mod, ONLY :  &
!  imported scalar parameters
     routeTypeTRIP  &
!  imported scalars with intent(in)
    ,npRoute,nxInRoute,nyInRoute,nxRoute,nyRoute   &
!  imported arrays with intent(in)
    ,mapInRoute,routeIndex

  USE seed, ONLY :  &
!  imported scalars with intent(in)
     frac_min

  USE soil_param, ONLY :  &
!  imported arrays with intent(in)
     dzsoil

  USE switches, ONLY :  &
!  imported scalars with intent(in)
     can_model,l_phenol,l_spec_albedo,l_top,l_triffid, &
     l_veg_compete,route,routeOnly,l_imogen

  USE switches_urban, ONLY :  &
!  imported scalars with intent(in)
     l_urban2t

  USE urban_param, ONLY : &
!  imported arrays with intent(in)
     wrr
     
  USE imogen_constants, ONLY : n_olevs,nfarray

  USE time_loc, ONLY :  latitude,longitude  !DSM

!-------------------------------------------------------------------------------
  IMPLICIT NONE

!-------------------------------------------------------------------------------
! Local scalar parameters.
!-------------------------------------------------------------------------------
  LOGICAL, PARAMETER :: byteSwap = .FALSE.   !  FALSE means that byte order of
!                    data in a binary file are not reversed after reading
  LOGICAL, PARAMETER :: fullDump = .FALSE.   !  FALSE means that TRIFFID and
!                    phenology accumulated fluxes are not written to dumps.
!                    This is acceptable while the relevant counters (e.g.
!                    steps_since_triffid) are assumed to be zero at the start
!                    of each run.
!                    TRUE means these fluxes are included in dumps.

!-------------------------------------------------------------------------------
! Local scalar variables.
!-------------------------------------------------------------------------------
  INTEGER ::  &
    i            &!  loop counter
   ,ipos         &!  work
   ,ierr         &!  error flag
   ,ierrSum      &!  error flag
   ,inUnit       &!  unit used to connect to input file
   ,iorder       &!  work
   ,ivar         &!  loop counter
   ,ix           &!  work
   ,iy           &!  work
   ,j            &!  work
   ,jvar         &!  loop counter
   ,l            &!  work
   ,nfieldFile   &!  number of fields per time in a file
   ,nheaderField &!  number of headers records at start of each field in file
   ,nheaderFile  &!  number of headers records at start of a file
   ,nheaderT     &!  number of headers at start of each time
   ,nlineField   &!  work
   ,nvarIn       &!  the number of variables that are read in (not including
!                      spatially constant)
   ,readT        &!  time level to be read from file
   ,readZ        &!  vertical level to be read from file
   ,useIndex      !  index in irecPrev

  REAL ::        &
    urban_fraction    ! Work

  LOGICAL ::  &
    checkName &!  work
   ,checkPos  &!  work
   ,errFound  &!  flag indicating an error
   ,found     &!  work
   ,readDump  &!  flag indicating if a model dump is to be read
   ,readFile  &!  flag indicating if an external file is to be read
   ,sdfFile   &!  TRUE if dealing with an SDF (self-describing file)
   ,zrevFlag   !  work: indicates if levels of a variable are to be reversed

  LOGICAL :: allDump  !  Switch indicating that all variables are to be read from
!                          a dump. If TRUE, all variables will be set directly
!                          from dump, with no possibility for over-riding.
!                          It allows the run control file to be simpler in that
!                          case the user doesn't have to work out what variables
!                          are required.
  LOGICAL :: dumpFile ! T means file to be read is a JULES dump
                      ! F means file is not a JULES dump
  LOGICAL :: totalSnow    ! Switch indicating how the snow model is initialised.
!               T means only snow_tile is needed (along with other "standard,
!                 non-snow" variables such as t_soil)
!                 If nsmax>0, the layer values are determined by the model.
!               F means all snow variables are supplied directly (what these
!                 are depends on nsmax).

  LOGICAL :: totalWetness ! Switch indicating how soil wetness (sthuf) is
!                          iniitalised.
!                          T means (the total) sthuf is specified.
!                          F means the frozen and unfrosen fractions (sthf and
!                            sthu) are supplied separately
!                          This option introduced to allow a run to be started
!                          directly from diagnostic output from another run,
!                          where that output contains sthu and sthf, but not
!                          sthuf. Arguably would be
!                          easier to simplify and insist on sthuf (o yes).

  CHARACTER(len=formatLen) :: fileFormat   !  format of file

  CHARACTER(len=formatLen) :: dumpInFormat  !  format of any input dump file

  CHARACTER(len=150) ::        &
     fileName                  & !  The name of a file
    ,ftxt                        !  Format for writing text

!-------------------------------------------------------------------------------
! Local array variables.
!-------------------------------------------------------------------------------
  INTEGER ::  &
    nzCheck(nvarMax)        &!  work: number of levels for variable
   ,varFlagTmp(nvarMax)     &!  work: values as read from run control file
   ,varInSort(nvarMax)      &!  a list of which variables in master list are to
!                                 be read in, sorted into ascending order of
!                                 location in file. Values 1:varIn give a list
!                                 of variables that are to be read from file
!                                 (in terms of location in master list of all possible
!                                 variables), sorted into ascending order of location
!                                 of data in file.
   ,ival(nvarMax)            !  work

  REAL ::  &
    sthuf(land_pts,sm_levels)      &!  total soil wetness (frozen+unfrozen)
   ,varConstTmp(nvarMax)            !  work

  LOGICAL ::  &
    done(nvarMax)        &!  work
   ,varSnowTot(nvarMax)  &!  flag indicating whether a variable is affected by
!                              totalSnow (qv). i.e. if totalSnow=T, this variable
!                              will be set from others, otherwise is input
!                              directly. This is becoming bit of a faff...but
!                              I'll carry on for now.
   ,foundVar(nvarMax)     !  flag indicating if a variable is listed in run
!                            control file

  CHARACTER(len=LEN(varName)) ::  &!  local ARRAYS
    varNameTmp(nvarMax)        !  work: values as read from run control file

  CHARACTER(len=50) ::  &!  local arrays
    varExtra(nvarMax)          &!  "extra" diagnostic information for each variable
   ,varNameSDF(nvarMax)        &!  names of variables in input file
!                                  (SDF=self-describing file)
   ,varNameSDFTmp(nvarMax)      !  work: values as read from run control file

!------------------------------------------------------------------------------

!-------------------------------------------------------------------------------
   INTEGER, INTENT(IN)  :: nia,nja,npatch,nzg,nstyp
   REAL,    INTENT(IN)  :: patch_area(nia,nja,npatch), veg_fracarea(nia,nja,npatch)    &
                           ,leaf_class(nia,nja,npatch),stom_resist(nia,nja,npatch)      &
                           ,soil_water(nzg,nia,nja) &
                           ,soil_text(nzg,nia,nja), slmsts(nstyp)               &
                           ,veg_lai(nia,nja,npatch)              &
                           ,temp2(nia,nja),soil_energy(nzg,nia,nja)
 
   INTEGER              :: nsoil,ipat,k,tB(ntype),qual_ip(ntype),ip

   CHARACTER (LEN=80)   :: veg(ntype)
   CHARACTER (LEN=2)    :: tB_str    
   REAL                 :: tempk,fracliq 
   
   INTEGER                             :: nvtyp_teb
   REAL, DIMENSION (nstyp+nvtyp_teb)   :: veg_ht 
   REAL, DIMENSION (nstyp)             :: slcpd
!-------------------------------------------------------------------------------
  INTEGER :: MYNUM,tam
  CHARACTER(len=256) ::  hfilout,hfilin
  CHARACTER(len=16)  :: runtype


  if (echo) WRITE(*,"(50('-'),/,a)") 'init_ic'

! Locate the start of this section in input file.
  CALL findTag( jinUnit,'init_ic','>INIT_IC' )

!-------------------------------------------------------------------------------
! Set up the master list of all possible variables. There are nvarMax of these.
! These are essentially parameters, but the list is easier to maintain if set up
! in executable statements here.
! There are other possibilities for STASH code for some variables -
!   e.g. canopy water content could apparently come from STASH HYDROLOGY section
!        (209) or PROGNOSTICS section (22).
! For ASCII dumps, a 3-D snow layer variable A(land_pts,ntiles,nsmax) is
! treated as a 2-D variable in which the latter 2 dimensions are combined:
! A(land_pts,ntiles*nsmax).
! Indicate this via varSize(:,2) = product( varSize(:,2:) ).
!-------------------------------------------------------------------------------

! Initialise.
  varNdim(:) = 0         !  no dimensions
  varSize(:,:) = 1       !  a single layer
  varSnowTot(:) = .FALSE.!  not affected by totalSnow
  varExtra(:) = ''       !  empty
  varType(:) = ''        !  empty
! Note that it is critical that the counter "i" runs 1,2,3,.. as this fact is used
! later in the code.
  i = 0

  i=i+1; iposCanht=i; varName(i)='canht'
  varStash(i) = 218
  varDesc(i) = 'Vegetation (canopy) height'
  varUnits(i) = 'm'
  varType(i) = 'PF'

  i=i+1; iposCanopy=i; varName(i)='canopy'
  varStash(i) = 229
  varDesc(i) = 'Canopy water storage'
  varUnits(i) = 'kg m-2'
  varType(i) = 'TI'

  i=i+1; iposCs=i; varName(i)='cs'
  varStash(i) = 223
  varDesc(i) = 'Soil carbon in each pool'
  varUnits(i) = 'kg m-2'
  varType(i) = 'SC'

  i=i+1; iposFrac=i; varName(i)='frac'
  varStash(i) = 216
  varDesc(i) = 'Fractional cover of surface type'
  varUnits(i) = '-'
  varType(i) = 'TY'

  i=i+1; iposGs=i; varName(i)='gs'
  varStash(i) = 213
  varDesc(i) = '"Stomatal" conductance to evaporation'
  varUnits(i) = 'm s-1'
  varType(i) = 'LA'

  i=i+1; iposGLeafAcc=i; varName(i)='g_leaf_acc'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Accumulated leaf turnover rate'
  varUnits(i) = '-'
  varType(i) = 'PF'

  i=i+1; iposGLeafPhenAcc=i; varName(i)='g_leaf_phen_acc'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Accumulated leaf turnover rate including phenology'
  varUnits(i) = '-'
  varType(i) = 'PF'

  i=i+1; iposLAI=i; varName(i)='lai'
  varStash(i) = 217
  varDesc(i) = 'Leaf Area Index'
  varUnits(i) = '-'
  varType(i) = 'PF'

  i=i+1; iposNppFtAcc=i; varName(i)='npp_ft_acc'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Accumulated net primary productivity'
  varUnits(i) = '-'
  varType(i) = 'PF'

  i=i+1; iposNsnow=i; varName(i)='nsnow'
  varStash(i) = 0   !  not known
  varDesc(i) = 'Number of snow layers'
  varUnits(i) = '-'
  varType(i) = 'TI'
  varSnowTot(i) = .TRUE.

  i=i+1; iposRespSAcc=i; varName(i)='resp_s_acc'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Accumulated soil respiration'
  varUnits(i) = '-'
  varType(i) = 'SC'

  i=i+1; iposRespWFtAcc=i; varName(i)='resp_w_ft_acc'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Accumulated wood maintenance respiration'
  varUnits(i) = '-'
  varType(i) = 'PF'

  i=i+1; iposRgrain=i; varName(i)='rgrain'
  varStash(i) = 0   !  not known
  varDesc(i) = 'Snow surface grain size'
  varUnits(i) = 'microns'
  varType(i) = 'TI'

  i=i+1; iposRgrainL=i; varName(i)='rgrainL'
  varStash(i) = 0   !  not known
  varDesc(i) = 'Snow grain size in snow layers'
  varUnits(i) = 'microns'
  varType(i) = 'SN'
  varSnowTot(i) = .TRUE.

  i=i+1; iposRhoSnow=i; varName(i)='rho_snow'
  varStash(i) = 0   !  not known
  varDesc(i) = 'Snow bulk density'
  varUnits(i) = 'kg m-3'
  varType(i) = 'TI'
  varSnowTot(i) = .TRUE.

  i=i+1; iposRouteStore=i; varName(i)='routeStore'
  varStash(i) = 0   !  not known
  varDesc(i) = 'Routing channel storage'
  varUnits(i) = 'kg'
  varType(i) = 'RG'

  i=i+1; iposSnowTile=i; varName(i)='snow_tile'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Snow on tile'
  varUnits(i) = 'kg m-2'
  varType(i) = 'TI'
! NB leave varSnowTot=F, meaning this var is input even if totalSnow=T.

  i=i+1; iposSnowDepth=i; varName(i)='snowDepth'
  varStash(i) = 0   !  not known
  varDesc(i) = 'Snow depth (m)'
  varUnits(i) = 'm'
  varType(i) = 'TI'
  varSnowTot(i) = .TRUE.

  i=i+1; iposSnowDs=i; varName(i)='snowDs'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Snow layer thicknesses'
  varUnits(i) = 'm'
  varType(i) = 'SN'
  varSnowTot(i) = .TRUE.

  i=i+1; iposSnowGrnd=i; varName(i)='snow_grnd'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Snow on ground'
  varUnits(i) = 'kg m-2'
  varType(i) = 'TI'
  varSnowTot(i) = .TRUE.

  i=i+1; iposSnowIce=i; varName(i)='snowIce'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Snow layer ice mass'
  varUnits(i) = 'kg m-2'
  varType(i) = 'SN'
  varSnowTot(i) = .TRUE.

  i=i+1; iposSnowLiq=i; varName(i)='snowLiq'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Snow layer liquid mass'
  varUnits(i) = 'kg m-2'
  varType(i) = 'SN'
  varSnowTot(i) = .TRUE.

  i=i+1; iposSthf=i; varName(i)='sthf'
  varStash(i) = 215
  varDesc(i) = 'Frozen soil wetness'
  varUnits(i) = '-'
  varType(i) = 'SO'

  i=i+1; iposSthu=i; varName(i)='sthu'
  varStash(i) = 214
  varDesc(i) = 'Unfrozen soil wetness'
  varUnits(i) = '-'
  varType(i) = 'SO'

  i=i+1; iposSthuf=i; varName(i)='sthuf'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Soil wetness'
  varUnits(i) = '-'
  varType(i) = 'SO'

  i=i+1; iposSthZw=i; varName(i)='sthzw'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Soil wetness in deep (TOPMODEL) layer'
  varUnits(i) = '-'
  varType(i) = 'LA'

  i=i+1; iposTsnow=i; varName(i)='tsnow'
  varStash(i) = 20
  varDesc(i) = 'Snow layer temperature (K)'
  varUnits(i) = 'K'
  varType(i) = 'SN'
  varSnowTot(i) = .TRUE.

  i=i+1; iposTsoil=i; varName(i)='t_soil'
  varStash(i) = 20
  varDesc(i) = 'Subsurface temperature (K)'
  varUnits(i) = 'K'
  varType(i) = 'SO'

  i=i+1; iposTstarT=i; varName(i)='tstar_tile'
  varStash(i) = 233
  varDesc(i) = 'Surface temperature of tile (K)'
  varUnits(i) = 'K'
  varType(i) = 'TI'

  i=i+1; iposZw=i; varName(i)='zw'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Depth to water table (m)'
  varUnits(i) = 'm'
  varType(i) = 'LA'
  
  i=i+1; iposCo2=i; varName(i)='co2_ppmv'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Atmospheric CO2 concentration'
  varUnits(i) = 'ppmv'
  varType(i) = 'SL'
  
  i=i+1; iposCo2Change=i; varName(i)='co2_change_ppmv'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Gradient of atmospheric CO2 concentration'
  varUnits(i) = 'ppmv/yr'
  varType(i) = 'SL'
  
  i=i+1; iposDTempO=i; varName(i)='dtemp_o'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Ocean temperature anomalies'
  varUnits(i) = 'K'
  varType(i) = 'OC'
  
  i=i+1; iposFaOcean=i; varName(i)='fa_ocean'
  varStash(i) = 0  !  not known
  varDesc(i) = 'CO2 fluxes from atmosphere to ocean'
  varUnits(i) = 'ppm/m2/yr'
  varType(i) = 'FA'
  
  i=i+1; iposSeedRain=i; varName(i)='seed_rain'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Seeding number for subdaily rainfall'
  varUnits(i) = '-'
  varType(i) = 'SD'
  
  i=i+1; iposCv=i; varName(i)='cv'
  varStash(i) = 0  !  not known
  varDesc(i) = 'Total vegetation carbon'
  varUnits(i) = '-'
  varType(i) = 'LA'
  

!-------------------------------------------------------------------------------
! Set sizes of variables and get "full" descriptions.
!-------------------------------------------------------------------------------
  DO ivar=1,nvarMax
    varDescFull(ivar) = TRIM( varDesc(ivar) ) // ' ('   &
            // TRIM( varUnits(ivar) ) // ')'
    SELECT CASE ( varType(ivar) )
      CASE ( 'LA' )
        varNdim(ivar) = 1
        varSize(ivar,1:varNdim(ivar)) = land_pts
      CASE ( 'PF' )
        varNdim(ivar) = 2
        varSize(ivar,1:varNdim(ivar)) = (/ land_pts, npft /)
      CASE ( 'RG' )
        varNdim(ivar) = 1
        varSize(ivar,1:varNdim(ivar)) = nxRoute*nyRoute
      CASE ( 'SC' )
        varNdim(ivar) = 2
        varSize(ivar,1:varNdim(ivar)) = (/ land_pts, dim_cs1 /)
      CASE ( 'SO' )
        varNdim(ivar) = 2
        varSize(ivar,1:varNdim(ivar)) = (/ land_pts, sm_levels /)
      CASE ( 'SN' )
        varNdim(ivar) = 3
        varSize(ivar,1:varNdim(ivar)) = (/ land_pts, nsmax, ntiles /)
      CASE ( 'TI' )
        varNdim(ivar) = 2
        varSize(ivar,1:varNdim(ivar)) = (/ land_pts, ntiles /)
      CASE ( 'TY' )
        varNdim(ivar) = 2
        varSize(ivar,1:varNdim(ivar)) = (/ land_pts, ntype /)
!-------------------------------------------------------------------------------
! Cases for IMOGEN variables
!-------------------------------------------------------------------------------
      CASE ( 'SL' )
! SL indicates a scalar - represented by an array of dimension 1
        varNdim(ivar) = 1
        varSize(ivar,1:varNdim(ivar)) = 1
      CASE ( 'OC' )
        varNdim(ivar) = 1
        varSize(ivar,1:varNdim(ivar)) = n_olevs
      CASE ( 'FA' )
        varNdim(ivar) = 1
        varSize(ivar,1:varNdim(ivar)) = nfarray
      CASE ( 'SD' )
        varNdim(ivar) = 1
        varSize(ivar,1:varNdim(ivar)) = 4
      CASE default
        WRITE(*,*)'init_ic: do not recognise varType=',TRIM(varType(ivar))
        STOP
    END SELECT
  ENDDO
!-------------------------------------------------------------------------------
! Start to read from the run control file.
!-------------------------------------------------------------------------------

! Establish where data are to be read from and other format details.
  READ(jinUnit,*) readFile

!DSM{  --- Definindo TRUE se RUNTYPE=´HISTORY' ---
  IF (runtype == 'HISTORY') readFile=.TRUE.
!DSM}



  READ(jinUnit,*) fileFormat
  READ(jinUnit,*) dumpFile,allDump
  READ(jinUnit,*) fileName
  
!DSM{ ----- Utilizando a configurcao HISTORY do RAMSIN
  IF (len(trim(hfilout(index(hfilout,'/',BACK=.TRUE.)+1:100))) > 9) THEN
     PRINT*, '********'
     PRINT*, 'ERRO... O nome do arquivo history (em HFILOUT) deve ter no maximo 5 caracteres'
     PRINT*, '********'
     STOP
  ENDIF
  !{--- Configurando o nome do history (dump) do JULES ---
  !outDir=trim(hfilout(1:index(hfilout,'/',BACK=.TRUE.)-1))
  !write(runID,'(a,i4.4)') trim(hfilout(index(hfilout,'/',BACK=.TRUE.)+1:100))//'-',MYNUM
  write(outDir,'(a,i4.4)') trim(hfilout(1:index(hfilout,'/',BACK=.TRUE.)-1))//'/p',MYNUM
  runID=trim(hfilout(index(hfilout,'/',BACK=.TRUE.)+1:100))

  tam=len_trim(hfilout)
  fileName=trim(outDir)//'/'//trim(runID)//'_'//hfilin(tam+4:tam+7)// &
        hfilin(tam+9:tam+10)//hfilin(tam+12:tam+13)//'_'//hfilin(tam+15:tam+20)//'_dump.nc'
  !}
!DSM}
  
  
  READ(jinUnit,*) zrevSoil,zrevSnow

! Read flags indicating how certain variables are to be set.
  READ(jinUnit,*) totalWetness
  READ(jinUnit,*) totalSnow

!-------------------------------------------------------------------------------
! If reading from run control file, set file format, otherwise check format.
! This can be irrelevant if no variables are actually read from file.
!-------------------------------------------------------------------------------
  IF ( .NOT. readFile ) THEN
    fileFormat = formatAsc
  ELSE
    IF ( dumpFile ) THEN
      SELECT CASE ( fileFormat )
        CASE ( formatAsc,formatNc )
          dumpInFormat = fileFormat
        CASE default
          WRITE(*,*)'ERROR: init_ic: dump format cannot be ',TRIM(fileFormat)
          STOP
      END SELECT
    ELSE
      SELECT CASE ( fileFormat )
        CASE ( formatAsc,formatBin,formatNc )
!         OK
        CASE default
          WRITE(*,*)'ERROR: init_ic: unrecognised file format: ',TRIM(fileFormat)
          STOP
      END SELECT
    ENDIF
  ENDIF  !  readFile

!-------------------------------------------------------------------------------
! Set flag if a dump file is to be read.
!-------------------------------------------------------------------------------
  readDump = .FALSE.
  IF ( readFile .AND. dumpFile ) THEN
    readDump = .TRUE.
!   In this version, don't allow netCDF dumps if routing is selected.
!   I'm in a hurry and this simplifies grid information.
    IF ( fileFormat==formatNc .AND. route ) THEN
      WRITE(*,*)'ERROR: init_ic: netCDF dumps not allowed with routing.'
      WRITE(*,*)'Sorry - more code is required.'
      STOP
    ENDIF
    
!   In this version, don't allow netCDF dumps if IMOGEN is selected.
    IF ( fileFormat==formatNc .AND. l_imogen ) THEN
      WRITE(*,*)'ERROR: init_ic: netCDF dumps not allowed with IMOGEN at present.'
      STOP
    ENDIF
  ENDIF
  IF ( .NOT. readDump ) allDump = .FALSE.
  IF ( allDump ) THEN
    totalWetness = .TRUE.
    totalSnow = .FALSE.
  ENDIF

! Reset totalSnow if only doing routing.
  IF ( routeOnly ) totalSnow = .FALSE.

!-------------------------------------------------------------------------------
! Set flags indicating if a variable is needed for the selected model
! configuration, and if it must be read in or can be derived from other variables.
!
! We differentiate between:
! a) the model configuration: i.e. what "physics" or "processes" are active.
!      This determines what variables require to be initialised (ultimately -
!      they may be derived).
! b) the input/output (i/o) configuration: i.e. what variables are input.
!
! Note that variables that are not needed for the model configuration can still be
! input if they provide data for variables that are required (e.g. sthu on its own
! is never needed, but it can be input and used to calculate sthuf).
! varFlag is not set here, even for variables that will be derived ("special
! cases") so that we retain any value that is read from the run control file.
!-------------------------------------------------------------------------------

! Initialise.
  varUse(:) = 0           !  variable not needed
  varDump(:) = .FALSE.    !  don't include in dumps

!-------------------------------------------------------------------------------
  IF ( .NOT. routeOnly ) THEN

!-------------------------------------------------------------------------------
!   1. "General" variables.
!-------------------------------------------------------------------------------
!   Variables that are always needed.
!   These are canopy, cs, gs, rho_snow_grnd, snow_tile, snowDepth, sthuf,
!   t_soil, tstar_tile.
!-------------------------------------------------------------------------------

    ipos = iposCanopy
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

    ipos = iposCs
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

    ipos = iposGs
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

    ipos = iposRhoSnow
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

    ipos = iposSnowDepth
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

    ipos = iposSnowTile
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

    ipos = iposSthuf
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

    ipos = iposTsoil
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

    ipos = iposTstarT
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

!-------------------------------------------------------------------------------
!   Variables that are always needed, but that may be set elsewhere:
!-------------------------------------------------------------------------------
    ipos = iposFrac
    IF ( readFracIC ) varUse(ipos) = 1
    varDump(ipos) = .TRUE.

!-------------------------------------------------------------------------------
!   Variables that are needed only if certain options set.
!-------------------------------------------------------------------------------

!-------------------------------------------------------------------------------
!   TRIFFID or phenology variables.
!-------------------------------------------------------------------------------
!   Canopy height.
    IF ( l_triffid ) THEN
      ipos = iposCanht
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
    ENDIF

!   LAI.
    IF ( l_phenol ) THEN
      ipos = iposLAI
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
    ENDIF

!-------------------------------------------------------------------------------
!   Accumulations for TRIFFID and phenology.
!   In fact these are redundant in dumps at present, as elsewhere it is assumed
!   that the TRIFFID and phenology counters can be reset to zero at the start of
!   a JULES run. Rather than remove this code, which might be useful in future,
!   I have deactivated it by adding the parameter fullDump, set to FALSE. To use
!   this code, set to TRUE.
!-------------------------------------------------------------------------------
    IF ( fullDump .AND. ( l_triffid .OR. l_phenol ) ) THEN
      ipos = iposGLeafAcc
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
    ENDIF

    IF ( fullDump .AND. l_triffid ) THEN

      ipos = iposGLeafPhenAcc
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.

      ipos = iposNppFtAcc
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.

      ipos = iposRespSAcc
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.

      ipos = iposRespWFtAcc
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.

    ENDIF

!-------------------------------------------------------------------------------
!  Some snow variables (not specifically for the multi-layer model).
!-------------------------------------------------------------------------------
!   rgrain
    IF ( l_spec_albedo ) THEN
      ipos = iposRgrain
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
    ENDIF

!   snow under canopy
    IF ( can_model == 4 ) THEN
      ipos = iposSnowGrnd
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
    ENDIF

!-------------------------------------------------------------------------------
!   Variables for the multi-layer snow model.
!-------------------------------------------------------------------------------
    IF ( nsmax > 0 ) THEN
      DO ivar=1,nvarMax
        IF ( varType(ivar)=='SN' .OR. ivar==iposNsnow ) THEN
          varUse(ivar) = 1
          varDump(ivar) = .TRUE.
        ENDIF
      ENDDO
!     Deselect rgrainL if spectral model not used.
      IF ( .NOT. l_spec_albedo ) THEN
        varUse(iposRgrainL) = 0
        varDump(iposRgrainL) = .FALSE.
      ENDIF
    ENDIF  !  nsmax

!-------------------------------------------------------------------------------
!   TOPMODEL variables.
!-------------------------------------------------------------------------------
    IF ( l_top ) THEN

!     Wetness in deep layer.
      ipos = iposSthZw
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
!     Depth to water table.
      ipos = iposZw
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
    ENDIF

!-------------------------------------------------------------------------------
!   Channel routing variables.
!-------------------------------------------------------------------------------
!   Channel routing store.
    IF ( route ) THEN
      ipos = iposRouteStore
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
    ENDIF

!------------------------------------------------------------------------------
!   Variables that can only be required indirectly (to derive others).
!   Separate flags indicate whether these are required for the current run.
!   If required, set varUse=2 (else leave varUse=0).
!-------------------------------------------------------------------------------
!   Soil wetness can be specified via two fractions.
    IF ( .NOT. totalWetness ) THEN
      varUse(iposSthf) = 2
      varUse(iposSthu) = 2
    ENDIF

!-------------------------------------------------------------------------------
! IMOGEN variables
!-------------------------------------------------------------------------------
    IF ( l_imogen ) THEN
      ipos = iposCo2
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
      
      ipos = iposCo2Change
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
      
      ipos = iposDTempO
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
      
      ipos = iposFaOcean
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
      
      ipos = iposSeedRain
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
      
! This should possibly be under an l_triffid switch, but is here for now
! so as not to change behaviour for non-TRIFFID runs
      ipos = iposCv
      varUse(ipos) = 1
      varDump(ipos) = .TRUE.
    ENDIF

  ELSE

!   routeOnly
!   Only need channel storage, which must be prescribed directly.
    ipos = iposRouteStore
    varUse(ipos) = 1
    varDump(ipos) = .TRUE.

  ENDIF  !  routeOnly

!-------------------------------------------------------------------------------
! Set up work space.
!-------------------------------------------------------------------------------
  i = MAX( land_pts,nxRoute,nfarray,n_olevs )
  j = MAX( ntiles,ntype,sm_levels,nyRoute,ntiles*nsmax )
  ALLOCATE( workSpace(i,j), stat=ierr )
  IF ( ierr /= 0 ) THEN
    WRITE(*,*)'ERROR: init_ic: error allocating workSpace ',i,j
    STOP
  ENDIF

!-------------------------------------------------------------------------------
! Resume reading from the run control file.
!
! Only read parameters for the file format indicated.
! For a dump file, we still read the ASCII section, to determine if any dump
! values are to be overridden (unless allDump=TRUE).

! If the data will be read from run control file, we don't assume an order in
!  which the variables will be presented (unlike in other sections of
! initialisation code). This may seem to make life harder
! for the user (effectively there's no "standard" setup, and the user always has
! to work out what variables are required) but the alternative (hardwire order)
! could lead to mistakes - e.g. if data for an unrequired variable is present,
! code would mistakenly use it for another variable. This would be unavoidable,
! unless we included a "marker" or tag giving the name of the variable alongside
! the data - but there's no code for that yet. As it is, as long as the user
! gives the correct "field numbers" for each variable (i.e. tmpFlag matches
! what data are given), the code will flag unwanted variables and correctly
! skip them.
! NB The above only applies to reading from the run control file (jinUnit)!
!-------------------------------------------------------------------------------

  IF ( .NOT. allDump ) THEN

    SELECT CASE ( fileFormat )

      CASE ( formatAsc,formatBin,formatPP )
        sdfFile = .FALSE.
!       Locate the information in run control file.
        CALL findTag( jinUnit,'init_ic',tagAscBin )
        READ(jinUnit,*) nheaderFile,nheaderField

!       Read variable names, flags and constVals.
        CALL read_list( jinUnit,3,nvarMax,'>VARS','>ENDVARS',' ','init_ic'  &
                       ,nvarIn,cvar1=varNameTmp,cvar1Pos=1,ivar=varFlagTmp,ivarPos=2  &
                       ,rvar=varConstTmp,rvarPos=3 )

      CASE ( formatNc )
        sdfFile= .TRUE.
!       Locate the information in run control file.
        CALL findTag( jinUnit,'init_ic',tagNc,preInit=.TRUE. )

!       Read variable names, flags, constVals and names in file.
        CALL read_list( jinUnit,4,nvarMax,'>VARS','>ENDVARS',' ','init_ic'  &
                       ,nvarIn,cvar1=varNameTmp,cvar1Pos=1,ivar=varFlagTmp,ivarPos=2  &
                       ,rvar=varConstTmp,rvarPos=3,cvar2=varNameSDFtmp,cvar2Pos=4 )

      CASE default
        WRITE(*,*)'ERROR: init_ic: no code for fileFormat=',TRIM(fileFormat)
        STOP

    END SELECT

!-------------------------------------------------------------------------------
!   Check that there are no repeated names (the names that act as IDs in the run
!   control file).
!-------------------------------------------------------------------------------
    IF ( repeatVal( varNameTmp(1:nvarIn) ) ) THEN
      WRITE(*,*)'ERROR: init_ic: repeated name: ',TRIM(varNameTmp(ivar))
      STOP
    ENDIF

!-------------------------------------------------------------------------------
!   If reading from a dump, set field number (varFlag) to 1 unless special
!   case is indicated.
!-------------------------------------------------------------------------------
    DO ivar=1,nvarIn
      IF ( readDump .AND. varFlagTmp(ivar)>=0 ) varFlagTmp(ivar)=1
    ENDDO

  ELSE

!-------------------------------------------------------------------------------
!   allDump = TRUE
!   All variables to be read from dump. Count variables, set up names etc.
!-------------------------------------------------------------------------------
    nvarIn = 0
!   Loop over all possible variables, identifying all those that are indicated
!   as to be included in dumps.
    DO ivar=1,nvarMax
      IF ( varDump(ivar) ) THEN
        nvarIn = nvarIn + 1
        varNameTmp(nvarIn) = varName(ivar)
        varFlagTmp(nvarIn) = 1
      ENDIF
    ENDDO
    sdfFile = .FALSE.

  ENDIF  !  allDump

!-------------------------------------------------------------------------------
! Establish what variables have been indicated.
!-------------------------------------------------------------------------------
  CALL varList( nvarIn,sdfFile,varNameTmp,varName  &
               ,errFound,foundVar  &
               ,varFlagIn=varFlagTmp,varNameSDFin=varNameSDFtmp  &
               ,varConstIn=varConstTmp  &
               ,varFlag=varFlag,varNameSDF=varNameSDF  &
               ,varConst=varConst )

  IF ( errFound ) THEN
    WRITE(*,*)'ERROR: init_ic: error returned by varList'
    STOP
  ENDIF

!-------------------------------------------------------------------------------
! Set number of levels of data to be read (varNzRead).
! Note that this is in theory a property of the input setup (and the variable),
! i.e we could fill a multi-level variable by repeating a single level of data,
! but at present this flexibility is not fully coded and all required levels must
! be input separately.
! Number of levels to read is found as product of sizes 2 upwards.
!-------------------------------------------------------------------------------
  DO ivar=1,nvarMax
    IF ( varUse(ivar) > 0 ) varNzRead(ivar) = PRODUCT( varSize(ivar,2:) )  !  cxyz CHECK! is varNzRead in master order?
  ENDDO

!-------------------------------------------------------------------------------
! Where a variable is required, but may be calculated from others, ensure that
! the available data are consistent with the option indicated. If optional but
! unnecessary fields are supplied, report this.

! A major deficiency with the approach taken below is that varUse is set to 0
! to cause an "optional" variable to be ignored - which fails miserably if this
! optional variable is actually required elsewhere (e.g. to initialise a 3rd variable).
! At present the code is OK, because there are no possible conflicts...but it's
! not at all future proof!
!-------------------------------------------------------------------------------

!-------------------------------------------------------------------------------
! Soil wetness.
!-------------------------------------------------------------------------------
  IF ( varUse(iposSthuf) == 1 ) THEN
!   sthuf (soil wetness) is needed.

    IF ( .NOT. totalWetness ) THEN
!     Option flag indicates that the frozen and unfrozen fractions are to be used.
!     Set flag for sthuf to -2 : a "special" case, meaning it will be set as sum.
      varFlag(iposSthuf) = -2
      varExtra(iposSthuf) = 'as sum of sthf and sthu'
      IF ( foundVar(iposSthuf) ) THEN
        WRITE(*,*)'WARNING: totalWetness=FALSE. Soil wetness will be initialised'
        WRITE(*,*)'using the sum of sthf+sthu (frozen+unfrozen fractions),'
        WRITE(*,*)'with the fractions supplied separately.'
        WRITE(*,*)'*** The total sthuf WILL be IGNORED. ***'
      ENDIF
    ELSE
!     Option flag indicates that wetness should be set from a single variable,
!     not as the sum of frozen and unfrozen fractions.
      IF ( foundVar(iposSthf) .OR. foundVar(iposSthu) ) THEN
        WRITE(*,*)'WARNING: totalWet=TRUE. Soil wetness will be initialised'
        WRITE(*,*)'using sthuf.'
        WRITE(*,*)'*** The fractions sthu and sthf WILL be IGNORED. ***'
!       Set varFlag and varUse to zero, but leave foundVar so we can say if it
!       was found.
!       With varUse=0, sthu and sthf will not be used any further.
!        varFlag(iposSthf) = 0
!        varUse(iposSthf) = 0
!        varFlag(iposSthu) = 0
!        varUse(iposSthu) = 0
      ENDIF
    ENDIF  !  totalWetness
  ENDIF   !  varUse(iposSthuf)

!-------------------------------------------------------------------------------
! Snow variables.
!-------------------------------------------------------------------------------
  IF ( totalSnow ) THEN
!-------------------------------------------------------------------------------
!   snow_tile is input. All other snow variables are ignored.
!   Set varFlag for all others to -2 to indicate a "special case" - in this
!   case, initialised from other variables
!   Loop over a list that identifies snow variables affected by totalSnow.
!-------------------------------------------------------------------------------
    found = .FALSE.
    DO ivar=1,nvarMax
      IF ( varSnowTot(ivar) ) THEN
        varFlag(ivar) = -2
        varExtra(ivar) = 'from other variables'
        IF ( foundVar(ivar) ) THEN
          found = .TRUE.
          WRITE(*,*)'WARNING: ignoring ',TRIM(varName(ivar))
        ENDIF
      ENDIF
    ENDDO
    IF ( found ) THEN
      WRITE(*,*)'WARNING: totalSnow=TRUE. The only snow-specific variables'
      WRITE(*,*)'that are required are snow_tile (and rgrain if l_spec_aledbo=T).'
    ENDIF
  ENDIF  !  totalSnow

!-------------------------------------------------------------------------------
! Check that the variables are specified correctly.
!-------------------------------------------------------------------------------
  CALL checkVars( nvarMax,.TRUE.,.TRUE.,varUse,foundVar,varDesc,varName  &
                 ,nvarIn,varFlag,errFound )
! Stop if an error was detected.
  IF ( errFound ) THEN
    WRITE(*,*)'ERROR: init_ic: an error was found by checkVars.'
    STOP
  ENDIF

!-------------------------------------------------------------------------------
! Calculate number of variables to be read in (not including spatially constant).
!-------------------------------------------------------------------------------
  nvarIn = COUNT( varFlag(:) > 0 )

!-------------------------------------------------------------------------------
! Stop if there are inconsistencies - safer than simply resetting, as user may
! then not know what source of data is.
!-------------------------------------------------------------------------------

! Check if frac is indicated as being part of intial state, but was read earlier.
  IF ( .NOT.readFracIC .AND. foundVar(iposFrac) ) THEN
    errFound = .TRUE.
    WRITE(*,*)'ERROR: init_ic: frac was read in init_frac.'
    WRITE(*,*)'This field must not then be read in init_ic.'
    WRITE(*,*)'If desired, frac CAN be read here - see documentation.'
    WRITE(*,*)'Stopping, so you know what data are being used!'
  ENDIF

! When phenology is not on, LAI is not prognostic and should be read elsewhere
  IF ( .NOT.l_phenol .AND. foundVar(iposLAI) ) THEN
    errFound = .TRUE.
    WRITE(*,*)'ERROR: init_ic: lai is set in init_veg for runs without phenology'
    WRITE(*,*)'It should then not be read in init_ic.'
    WRITE(*,*)'Stopping, so you know what data are being used!'
  ENDIF
  
! When phenology is on, LAI is prognostic and should be read here
  IF ( l_phenol .AND. .NOT.foundVar(iposLAI) ) THEN
    errFound = .TRUE.
    WRITE(*,*)'ERROR: init_ic: lai is prognostic for runs with phenology'
    WRITE(*,*)'It should be read in init_ic.'
    WRITE(*,*)'Stopping, so you know what data are being used!'
  ENDIF
  
! When TRIFFID is not on, canopy height is not prognostic and should be read elsewhere
  IF ( .NOT.l_triffid .AND. foundVar(iposCanht) ) THEN
    errFound = .TRUE.
    WRITE(*,*)'ERROR: init_ic: canopy height is set in init_veg for runs without TRIFFID'
    WRITE(*,*)'It should then not be read in init_ic.'
    WRITE(*,*)'Stopping, so you know what data are being used!'
  ENDIF
  
! When TRIFFID is on, canopy height is prognostic and should be read here
  IF ( l_triffid .AND. .NOT.foundVar(iposCanht) ) THEN
    errFound = .TRUE.
    WRITE(*,*)'ERROR: init_ic: canopy height is prognostic for runs with TRIFFID'
    WRITE(*,*)'It should be read in init_ic.'
    WRITE(*,*)'Stopping, so you know what data are being used!'
  ENDIF

! Stop if an error was detected.
  IF ( errFound ) STOP

! Don't allow certain options.
! Don't allow canht_ft or lai to be specified as constant - that would be constant over all PFTs.
  IF ( varFlag(iposCanht)==-1  .OR. varFlag(iposLAI)==-1 )   THEN
    WRITE(*,*)'ERROR: init_ic: canht_ft and LAI cannot be specified via flag=-1.'
    WRITE(*,*)'That would imply constant values over all PFTs.'
    STOP
  ENDIF

!-------------------------------------------------------------------------------
! If no fields are to be read from external file, reset any flags.
!-------------------------------------------------------------------------------

  IF ( nvarIn==0 .AND. ( readDump .OR. readFile ) ) THEN
    readDump = .FALSE.
    readFile = .FALSE.
    fileFormat = formatAsc
    WRITE(*,*)'WARNING: init_ic: No fields to be read from external file, but readFile or readDump=TRUE.'
    WRITE(*,*)'All values will be set via flag<0 (e.g. spatially constant).'
    WRITE(*,*)'Setting readDump and readFile to F.'
  ENDIF

!-------------------------------------------------------------------------------
! Get a sorted list, giving input variables according to position in input file(s).
! This is needed for reading from run control file, but is always done.
!-------------------------------------------------------------------------------
  done(:) = .TRUE.
  varInSort(:) = 0
! Only consider variables that are to be read in (flag>0).
  WHERE ( varFlag(:) > 0 ) done(:)=.FALSE.
  DO ivar=1,nvarIn
    ival(1:1) = MINLOC( varFlag(:), .NOT.done(:) )
    i = ival(1)
    done(i) = .TRUE.
    varInSort(ivar) = i
  ENDDO

!-------------------------------------------------------------------------------
! Set flag showing what variables will be set as part of this initialisation.
! Other required variables need to be set later.
! If this code/number of options becomes more complicated, it might be better to
! only set icVarSet once value is actually set, rather than using varFlag (which
! might become more complicated) as currently done. YES - use should be revised!
! i.e. This only deals with varFlag>=-2, so obviously doesn't detect -3, -4
!-------------------------------------------------------------------------------
  icVarSet(:) = .FALSE.
  WHERE ( varUse(:)==1 .AND. varFlag(:)>=-2 ) icVarSet(:)=.TRUE.

!-------------------------------------------------------------------------------
! Further checks.
!-------------------------------------------------------------------------------

!-------------------------------------------------------------------------------
! Check we have an acceptable file format, and set flags indicating what other
! variables to check.
!-------------------------------------------------------------------------------
  checkName = .FALSE.
  checkPos = .FALSE.
  SELECT CASE ( fileFormat )
    CASE ( formatAsc )
!     ASCII. Need positions of variables.
      checkPos = .TRUE.
    CASE ( formatBin )
!     GrADS. For now, need positions of variables.
      checkPos = .TRUE.
    CASE ( formatNc )
!     netCDF. Need names of variables.
      checkName = .TRUE.
    CASE ( formatPP )
!     PP format. For now, need positions of variables.
      checkPos = .TRUE.
    CASE default
      WRITE(*,*)'ERROR: init_ic: no code for fileFormat=',TRIM(fileFormat)
      STOP
  END SELECT

! No need to check dump.
  IF ( readDump ) THEN
    checkName = .FALSE.
    checkPos = .FALSE.
  ENDIF

  IF ( checkName ) THEN
!-------------------------------------------------------------------------------
!   Check that there are no repeated names (names used in self-describing files).
!-------------------------------------------------------------------------------
    DO ivar=1,nvarMax
      DO jvar=ivar+1,nvarMax
!       If a variable is to be read from file, varFlag will be >0.
        IF ( (varFlag(ivar)>0 .AND. varFlag(jvar)>0) .AND.  &
             ( varNameSDF(ivar) == varNameSDF(jvar) ) ) THEN
          WRITE(*,*)'ERROR: init_ic: repeated name (varNameSDF): ',TRIM(varNameSDF(ivar))
          STOP
        ENDIF
      ENDDO
    ENDDO
  ENDIF

!-------------------------------------------------------------------------------
! Check that there are no repeated "positions" (only >0 are significant).
!-------------------------------------------------------------------------------
  IF ( checkPos ) THEN

!   First argument to checkVarPos indicates how important the order of the
!   variables is.  0 means order is not important. If reading from run control
!   file, insist that variables are 1,2,3,.... - indicated by iorder=2. In all
!    cases, values <1 are ignored.
    iorder = 0
    IF ( .NOT. readFile ) iorder = 2

!   We need to load file locations in sorted order, and set number of levels
!   to be checked - if reading from run control file, all
!cxyz here   - what??
    ival(:) = 0
    nzCheck(:) = 0
    DO ivar=1,nvarIn
      ival(ivar) = varFlag( varInSort(ivar) )
      IF ( readFile ) THEN
        nzCheck(ivar) = varNzRead( varInSort(ivar) )  !  cxyz check this
      ELSE
        nzCheck(ivar) = 1  !  cxyz why?
      ENDIF
    ENDDO

    ierr = checkVarPos( iorder,ival(:),' init_ic: ival',varNzIn=nzCheck(:) )
    IF ( ierr < 0 ) THEN
      WRITE(*,*)'ERROR: init_ic: error from checkvarPos.'
      WRITE(*,*)'If error was repeated use of same varPos, but you do in fact want to reuse the'
      WRITE(*,*)'same data for more than one variable, comment out this stop!'
      IF ( .NOT. readFile ) THEN
        WRITE(*,"(/,a)") 'When reading the initial state from the run control'
        WRITE(*,*)'file, the required fields must be grouped together, with no'
        WRITE(*,*)'unrequired fields in the group.'
        WRITE(*,*)'This means that if you change the model configuration (say by'
        WRITE(*,*)'switching off a process, so that a particular variable is no'
        WRITE(*,*)'longer required), you may have to edit the run control file'
        WRITE(*,*)'to change the order of variables.'
        WRITE(*,*)'Look above for warnings that a variable "is provided but is not needed"'
      ENDIF
      STOP
    ENDIF
  ENDIF

!-------------------------------------------------------------------------------
! Summarise sources of data, for the benefit of the user!
!-------------------------------------------------------------------------------
  IF ( allDump ) WRITE(*,*)'allDump=T: All values will be set from the dump file.'
  IF ( echo ) THEN
    DO ivar=1,nvarMax
      IF ( varUse(ivar) /= 0 ) CALL varInfo( varName(ivar),varFlag(ivar)  &
                     ,varStash(ivar),varNameSDF(ivar),fileFormat  &
                     ,constVal=varConst(ivar),readDump=readDump  &
                     ,varDesc=varDescFull(ivar)  &
                     ,extraDesc=varExtra(ivar) )
    ENDDO  !  ivar
  ENDIF  !  echo

  IF ( readDump .AND. ( l_triffid .OR. l_phenol ) ) THEN
    WRITE(*,"(/,50('#'))")
    WRITE(*,*)'WARNING: runs with TRIFFID and/or phenology that start from a'
    WRITE(*,*)'restart (dump) file might not be correct.'
    WRITE(*,*)'In particular the counters for TRIF and phenol are set to zero'
    WRITE(*,*)'at the start of each run, rather than carried through the restart'
    WRITE(*,*)'file. The accumulated fluxes are also set to zero at the start'
    WRITE(*,*)'of each run (code exists to add to dump, but there''s no point'
    WRITE(*,*)'in activating it until counters are also there!).'
    WRITE(*,*)'So...I think there should be no problem if the earlier run'
    WRITE(*,*)'created the dump on a TRIF timestep, so that the accumulated'
    WRITE(*,*)'fluxes in this following run should indeed be initialised as'
    WRITE(*,*)'zero. Otherwise there will be some error in the accum fluxes.'
    WRITE(*,"(50('#'),/)")
  ENDIF

!-------------------------------------------------------------------------------
! Read data.
!-------------------------------------------------------------------------------

! If a model dump is to be read, call dump i/o routine.
! Values can be overwritten with constants later.
  IF ( readDump ) THEN

    WRITE(*,'(2a)')'Reading dump: ',trim(fileName)
    CALL dump_io( .FALSE.,dumpInFormat=dumpInFormat,dumpName=fileName )

  ELSE  !  NOT readDump

!-------------------------------------------------------------------------------
!   Read values from a file (not dump file).
!   Note that support for netCDF files is currently very limited here (what do
!   you mean "it's very limited everywhere"?!). See comments below.
!-------------------------------------------------------------------------------

!   Open file.
    IF ( readFile ) THEN
      inUnit = fileUnit( fileFormat )   !  get unit
      !DSM CALL openFile( 1,.FALSE.,inUnit,'READ',fileFormat,fileName,'old'  &
      !DSM              ,'init_ic',ncType )
      IF ( zrevSnow ) WRITE(*,*)'zrevSnow=T: snow var order is bottom to top'
      IF ( zrevSoil ) WRITE(*,*)'zrevSoil=T: soil var order is bottom to top'
    ELSE
      if (echo) WRITE(*,*)'Reading initial condition from the run control file.'
      IF ( zrevSoil .OR. zrevSnow ) THEN
        WRITE(*,*)'ERROR: init_ic: zrevSnow and zrevSoil must be FALSE IF reading from run control file.'
        WRITE(*,*)'i.e. data must be presented in correct order.'
        STOP
      ENDIF
      inUnit = jinUnit
!     Locate the start of the data in the run control file.
      CALL findTag( inUnit,'init_ic','>DATA',preInit=.TRUE. )
    ENDIF

!-------------------------------------------------------------------------------
!   All levels of a variable are read into temporary space, then loaded into
!   final variables. For non-SDF files, variables are read in the order in which
!   they appear in file - this is done so that values can be read from the run
!   control file (which is possibly open on stdIn and therefore can't be backspaced).
!-------------------------------------------------------------------------------
    DO jvar=1,nvarIn

!     Get location in master list of next variable to be read.
      ivar = varInSort(jvar)

!     Stop if trying to read a netCDF format that is not yet coded!
      IF ( fileFormat == formatNc .AND.  &
           ( varType(ivar)=='SN' .OR.  &
            ( varType(ivar)=='SC' .AND. dim_cs1/=1) ) ) THEN
        WRITE(*,*)'ERROR: init_ic: can''t read a netCDF file containing snow'
        WRITE(*,*)'layer variables or more than one soil carbon pool!'
        WRITE(*,*)'Needs more code! Sorry.'
        STOP
      ENDIF

!     Read from file.
      IF ( inUnit==jinUnit .AND. nxIn*nyIn==1 ) THEN

!-------------------------------------------------------------------------------
!       If only need to read one space point from run control file, expect no new
!       line between fields/levels of this variable(i.e. all on one line).
!       Calling readVar means we could cope with headers in the run control file.
!       But there's no need since annotation is already simple in this case.

!       NB This should really read varSize(ivar,1) points, and testing on
!       nxIn*nyIn is irrelevant if this var is on the routing grid. But for now
!       I'm assuming that nxIn*nyIn=1 will not be used with routing. I know
!       that's sloppy, but life's too short.
!-------------------------------------------------------------------------------
        READ(jinUnit,*) workSpace(1,1:varNzRead(ivar))

      ELSE

!-------------------------------------------------------------------------------
!       Note that snow layer variables do not use zrevSnow here (since this does
!       not result in the correct order of levels, and further work would still
!       be required) - that is dealt with later.
!-------------------------------------------------------------------------------
        zrevFlag = .FALSE.
        IF ( zrevSoil .AND. varType(ivar)=='SO' ) zrevFlag=.TRUE.
        readT = 1         !  time level to read from file
        nfieldFile = varFlag(ivar)+varNzRead(ivar)-1    !  # of fields in file.
!                               Set to end of required field - OK while readT=1
        nheaderT = 0      !  no headers at top of each time
        nlineField = 0    !  will not attempt to read ASCII line-by-line
!       Set index to use for irecPrev with netCDF files - this irecPrev isn't
!       changed, but need to keep index within bounds.
        useIndex = inUnit
        IF ( fileFormat == formatNc ) useIndex = 1
        SELECT CASE ( varType(ivar) )
          CASE ( 'RG' )
!-------------------------------------------------------------------------------
!           Read a variable onto routing grid.
!-------------------------------------------------------------------------------
            CALL readVar2d( readT,readZ,varFlag(ivar),varStash(ivar)  &
                               ,irecPrev(useIndex),nfieldFile  &
                               ,nheaderFile,nheaderT,nheaderField,nlineField  &
                               ,nxInRoute,nyInRoute  &
                               ,inUnit,varNameSDF(ivar)  &
                               ,mapInRoute(:),(/(i,i=1,varSize(ivar,1))/) &
                               ,fileFormat  &
                               ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar))  &
                               ,byteSwap,'init_ic','init_ic',ncType )
!-------------------------------------------------------------------------------
! Cases for IMOGEN variables - these are also not on the normal JULES grid
!-------------------------------------------------------------------------------
          CASE ( 'SL' )
            CALL readVar2d( readT,readZ,varFlag(ivar),varStash(ivar)  &
                               ,irecPrev(useIndex),nfieldFile  &
                               ,nheaderFile,nheaderT,nheaderField,nlineField  &
! SL indicates a scalar - i.e. nxIn = nyIn = 1
                               ,1,1  &
                               ,inUnit,varNameSDF(ivar)  &
                               ,(/(i,i=1,varSize(ivar,1))/),(/(i,i=1,varSize(ivar,1))/) &
                               ,fileFormat  &
                               ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar))  &
                               ,byteSwap,'init_ic','init_ic',ncType )
          CASE ( 'OC' )
            CALL readVar2d( readT,readZ,varFlag(ivar),varStash(ivar)  &
                               ,irecPrev(useIndex),nfieldFile  &
                               ,nheaderFile,nheaderT,nheaderField,nlineField  &
                               ,n_olevs,1  &
                               ,inUnit,varNameSDF(ivar)  &
                               ,(/(i,i=1,varSize(ivar,1))/),(/(i,i=1,varSize(ivar,1))/) &
                               ,fileFormat  &
                               ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar))  &
                               ,byteSwap,'init_ic','init_ic',ncType )
          CASE ( 'FA' )
            CALL readVar2d( readT,readZ,varFlag(ivar),varStash(ivar)  &
                               ,irecPrev(useIndex),nfieldFile  &
                               ,nheaderFile,nheaderT,nheaderField,nlineField  &
                               ,nfarray,1  &
                               ,inUnit,varNameSDF(ivar)  &
                               ,(/(i,i=1,varSize(ivar,1))/),(/(i,i=1,varSize(ivar,1))/) &
                               ,fileFormat  &
                               ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar))  &
                               ,byteSwap,'init_ic','init_ic',ncType )
          CASE ( 'SD' )
            CALL readVar2d( readT,readZ,varFlag(ivar),varStash(ivar)  &
                               ,irecPrev(useIndex),nfieldFile  &
                               ,nheaderFile,nheaderT,nheaderField,nlineField  &
                               ,4,1  &
                               ,inUnit,varNameSDF(ivar)  &
                               ,(/(i,i=1,varSize(ivar,1))/),(/(i,i=1,varSize(ivar,1))/) &
                               ,fileFormat  &
                               ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar))  &
                               ,byteSwap,'init_ic','init_ic',ncType )
          CASE default
!-------------------------------------------------------------------------------
!           Read a variable into land points.
!-------------------------------------------------------------------------------
            !DSM CALL readVar3dComp( readT,varFlag(ivar),varStash(ivar),.FALSE.  &
            !DSM                    ,irecPrev(useIndex),nfieldFile  &
            !DSM                    ,nheaderFile,nheaderT,nheaderField,nlineField  &
            !DSM                    ,nxIn,nyIn,varNzRead(ivar),zrevFlag  &
            !DSM                    ,inUnit,varNameSDF(ivar)  &
            !DSM                   ,mapInLand(:),(/(i,i=1,varSize(ivar,1))/) &
            !DSM                   ,fileFormat  &
            !DSM                   ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar))  &
            !DSM                   ,'init_ic','init_ic',ncType )
       !{DSM
 
         !print*,ivar, varSize(ivar,1),varNzRead(ivar)
         
      
         !IF (varNzRead(ivar)>nzg) THEN
         !   PRINT*, 'ERRO!!!... varNz(ivar)>nzg: '
         !   STOP
         !ENDIF !varNzRead(ivar)>nzg
         
         !--- Convertendo o tipo de vegetacao do BRAMS para o JULES ---
         CALL brams2jules(veg,ntype)
         CALL frac_from_leaf( frac  &
                  ,land_pts,ntype,land_index,nia,nja,npatch,patch_area,veg_fracarea    &
                  ,leaf_class )
  
         ipat=2  !considerando apenas o patch 2, observei que a varicao em relacao aos patch eh pequena
         DO k=1,varNzRead(ivar)
            DO l=1,land_pts
               j = ( land_index(l)-1 ) / row_length + 1
               i = land_index(l) - ( j-1 ) * row_length
               

               !--- Encontrando o tipo de vegetacao correspondente ao JULES ---
               !IF (TRIM(varName(ivar)) == 'lai' .or. TRIM(varName(ivar)) == 'gs') THEN
                  READ(veg(k)(1:2),*) tB(k)  !caso este ponto (i,j) nao possua nenhum representante para este tile (k) serah utilizado o primeiro tipo definido em brams2jules

                  qual_ip(k)=-999

                  DO ip=1,npatch
                     WRITE(tB_str,'(i2.2)') nint(leaf_class(i,j,ip))  ! Jogando o tipo do BRAMS em tB_str
                     IF (index(veg(k),tB_str)/=0) THEN
                        READ(tB_str,*) tB(k)
                        qual_ip(k)=ip   
                        exit  ! jah encontrou para o menor patch (mais representativo)
                     ENDIF
                  ENDDO
               !ENDIF

               IF (TRIM(varName(ivar)) == 'sthuf') THEN
                  nsoil = nint(soil_text(varNzRead(ivar)-k+1,i,j))  
                  workSpace(l,k)=soil_water(varNzRead(ivar)-k+1,i,j)/smvcst(l,k)  !OK
                  
                  !--Imprimindo para utilizar no off-line---
                  !write(42,*) 'sthuf',k,l,longitude(i,j),latitude(i,j),workSpace(l,k)
                  
               ELSEIF (TRIM(varName(ivar)) == 'tstar_tile') THEN
                  workSpace(l,k)=temp2(i,j)  !OK
                  !print*,workSpace(l,k)
                  !workSpace(l,k) = 272.0
                  !print*,workSpace(l,k)

                  !--Imprimindo para utilizar no off-line---
                  !write(42,*) 'tstar_tile',k,l,longitude(i,j),latitude(i,j),workSpace(l,k)
                  
               ELSEIF (TRIM(varName(ivar)) == 't_soil') THEN
                  nsoil = nint(soil_text(varNzRead(ivar)-k+1,i,j))  
                  CALL qwtk_from_BRMS(soil_energy(varNzRead(ivar)-k+1,i,j),soil_water(varNzRead(ivar)-k+1,i,j)*1.e3  &
                            ,slcpd(nsoil),tempk,fracliq)
               
                  workSpace(l,k) = tempk  !OK
                  !print*,'t_soil===>',l,k,workSpace(l,k),soil_energy(varNzRead(ivar)-k+1,i,j)
                  
                  !workSpace(l,k) = 278.0

                  !--Imprimindo para utilizar no off-line---
                  !write(42,*) 't_soil',k,l,longitude(i,j),latitude(i,j),workSpace(l,k),soil_energy(varNzRead(ivar)-k+1,i,j),soil_water(varNzRead(ivar)-k+1,i,j)*1.e3
                  
                  
               ELSEIF (TRIM(varName(ivar)) == 'frac') THEN
                  workSpace(l,k)=frac(l,k)    !OK
                  !workSpace(l,k) = 0.

                  !--Imprimindo para utilizar no off-line---
                  !write(42,*) 'frac',k,l,longitude(i,j),latitude(i,j),workSpace(l,k)

               ELSEIF (TRIM(varName(ivar)) == 'lai') THEN
                  
                  IF (qual_ip(k) /= -999 ) THEN               
                     workSpace(l,k) = veg_lai(i,j,qual_ip(k))  !OK
                  ELSE
                     workSpace(l,k) = 1.5  !OK
                  ENDIF
                  !print*,l,k,qual_ip(k),workSpace(l,k)
                  !workSpace(l,k) = 2.0


                  !--Imprimindo para utilizar no off-line---
                  !write(42,*) 'lai',k,l,longitude(i,j),latitude(i,j),workSpace(l,k)
                  
               ELSEIF (TRIM(varName(ivar)) == 'canht') THEN  !!!veg_height
                  
                  workSpace(l,k)=veg_ht(tB(k)) !OK 
                  !workSpace(l,k) = 1.0

                  !--Imprimindo para utilizar no off-line---
                  !write(42,*) 'canht',k,l,longitude(i,j),latitude(i,j),workSpace(l,k)
                  
                  
               ELSEIF (TRIM(varName(ivar)) == 'gs') THEN  !!!veg_height
                  
                  IF (qual_ip(k)==1) THEN
                     PRINT*, "ERRO... qual_ip nao pode ser 1, pois neste caso (agua) stom_resist=0"
                     STOP
                  ENDIF
                  IF (qual_ip(k) /= -999 ) THEN               
                     workSpace(l,k)=1/stom_resist(i,j,qual_ip(k)) !OK 
                  ELSE
                     workSpace(l,k)=0. !OK
                  ENDIF

                  !workSpace(l,k) = 0.

                  !--Imprimindo para utilizar no off-line---
                  !write(42,*) 'gs',k,l,longitude(i,j),latitude(i,j),workSpace(l,k)
                  
                  
                  
               ELSEIF (TRIM(varName(ivar)) == 'cs') THEN  !!!soil_carbon
                  
                  OPEN(51,FILE='soil_carbon.txt', STATUS='OLD')
                  sai=0
                  DO WHILE (sai==0)
                     READ(51,*,err=202,iostat=sai) lon,lat,cs_aux
                     202 continue
                     IF (sai/=0) then
                        workSpace(l,k)=10.0
                     ELSE
                        !print*,"i,lon,longitude(i,j)",i,lon,longitude(i,j)
                        !print*,"j,lat,latitude(i,j)",j,lat,latitude(i,j)
                        IF (lon>longitude(i,j) .and. lat>latitude(i,j)) THEN
                           workSpace(l,k)=cs_aux
                           sai=1
                        ENDIF
                     ENDIF
                  ENDDO
                  CLOSE(51)

                  !write(59,*) l,k,workSpace(l,k)
                  !call flush(59)
                  !workSpace(l,k) = 0.
                  !      workSpace(l,k)=12.5

                  !--Imprimindo para utilizar no off-line---
                  !write(42,*) 'gs',k,l,longitude(i,j),latitude(i,j),workSpace(l,k)
                  
               ELSE
                  WRITE(*,*) 'Favor definir no codigo (initial_mod2brams.f90) o valor da variavel: '//TRIM(varName(ivar))
                  STOP
               ENDIF
               
            ENDDO !DO l=1,land_pts
         ENDDO  !k=1,varNzRead(ivar)

! print*,"ssssdfggjj222------->","|"//TRIM(varName(ivar))//"|",ivar,nzg,varNzRead(ivar)
!pause        
        !DSM}

          END SELECT  !  var Type
      ENDIF  !  inUnit etc

!     Load data into correct location.
      CALL fill_ic_var( ivar,zrevSnow  &
                       ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar)) )

    ENDDO  !  jvar

!-------------------------------------------------------------------------------
!   Close file if it is not the run control file
!-------------------------------------------------------------------------------
    IF ( inUnit /= jinUnit ) CALL closeFile( inUnit,fileFormat )

  ENDIF  !  readDump

!-------------------------------------------------------------------------------
! Now deal with variables that are to be set as spatially constant.
!-------------------------------------------------------------------------------
  DO ivar=1,nvarMax
    IF ( varFlag(ivar) == -1 ) CALL fill_ic_var( ivar,zrevSnow )
  ENDDO

!-------------------------------------------------------------------------------
! Deal with any special flags.
! Snow variables that are affected by totalSnow  are dealt with separately.
! Extra care/code will be required if the processing of one variable depends
! upon the value of another variable, i.e. if the order of the variables matters.
!-------------------------------------------------------------------------------

  DO ivar=1,nvarMax

    IF ( varUse(ivar)>0 .AND. varFlag(ivar)<-1 .AND. .NOT.varSnowTot(ivar) ) THEN

      found = .FALSE.

!-------------------------------------------------------------------------------
!     Set sthuf from sthu+sthf (but result is still held in sthu for now).
!-------------------------------------------------------------------------------
      IF ( ivar== iposSthuf .AND. varFlag(ivar)==-2 ) THEN
        found = .TRUE.
        sthu(:,:) = sthu(:,:) + sthf(:,:)
      ENDIF

      IF ( .NOT. found ) THEN
        WRITE(*,*)'ERROR: init_ic: no code to load ivar=',ivar,' '  &
               ,TRIM(varName(ivar)),' with varFlag=',varFlag(ivar)
        STOP
      ELSE
!       Indicate that this variable has been set.
        icVarSet(ivar) = .TRUE.
      ENDIF

    ENDIF  !  varFlag

  ENDDO  !  ivar

!-------------------------------------------------------------------------------
  IF ( .NOT. routeOnly ) THEN

!-------------------------------------------------------------------------------
!   Further processing of soil moisture.
!-------------------------------------------------------------------------------
    IF ( varUse(iposSthuf) == 1 ) THEN

!     Copy total soil wetness from sthu to sthuf.
      sthuf(:,:) = sthu(:,:)

!     Calculate soil moisture content from wetness.
      DO i=1,sm_levels
        smcl(:,i) = rho_water * dzsoil(i) * sthuf(:,i) * smvcst(:,i)
      ENDDO

    ENDIF

!------------------------------------------------------------------------------
!   If using two-tile urban schemes then split urban fraction here between
!   the canyon and roof. This has to be done instead of in init_urban to be
!   consistent with triffid
!------------------------------------------------------------------------------

! The ice tile is no longer hijacked for standalone JULES, like it is currently
! in the UM, so the check for the presence of ice does not need to be done
! here. However, it has been left it in to be consistent.
    IF ( l_urban2t ) THEN
      PRINT '(/,a)', 'Either URBAN-2T or MORUSES is in use:'
      PRINT *, 'Splitting urban tile to canyon/ roof'
      WRITE(ftxt,'(a10,i2,a10)') '(1x,a7,i9,',ntype,'(2x,f5.3))'
      DO l = 1, land_pts
        IF (frac(l,urban) > 0.0 .AND. frac(l,ice) == 0.0 ) THEN
          IF ( echo ) PRINT ftxt, 'BEFORE:', l,frac(l,:)
          urban_fraction  = frac(l,urban)
          frac(l,urban_canyon)   = urban_fraction * wrr(l)
          frac(l,urban_roof)     = urban_fraction - frac(l,urban_canyon)
          IF ( echo ) PRINT ftxt, 'AFTER :', l,frac(l,:)
        ELSE IF ( frac(l,urban) > 0.0 .AND. frac(l,ice) > 0.0 ) THEN
          PRINT *, "WARNING: ice and urban co-exist for land point", l
        END IF
      END DO
      PRINT *
    END IF

!-------------------------------------------------------------------------------
!   If using TRIFFID (with or without competing veg), ensure that fractions of
!   PFTs are not below minimum.
!   Only do this over soil points - land ice points should have zero fractions.
!-------------------------------------------------------------------------------
    IF ( l_triffid ) THEN
      DO j=1,soil_pts
        i = soil_index(j)
        IF ( ANY( frac(i,:)<frac_min ) ) THEN
          !DSM WRITE(*,"(10('*'),a,i6,a,10('*'))")' WARNING: point #',i,' frac<frac_min '
          !DSM WRITE(*,*)'Resetting to frac_min=',frac_min
!             Reset all small values. Renormalisation is done later,
!             but will fail if frac_min is sufficiently large.
!             Only resetting PFTs, not the others.
          WHERE ( frac(i,1:npft)<frac_min ) frac(i,1:npft)=frac_min
        ENDIF
      ENDDO  !    soil points
    ENDIF  !  l_triffid

!-------------------------------------------------------------------------------
!   Check that frac sums to 1.0 (with a bit of leeway).
!-------------------------------------------------------------------------------
    DO i=1,land_pts

      IF ( ABS( SUM(frac(i,:))-1.0 ) > 1.0e-4 ) THEN
        WRITE(*,*)'WARNING: point #',i,' Sum of frac=',SUM(frac(i,:))
        WRITE(*,*)'frac(i,1:ntype)=',frac(i,1:ntype)
        IF ( ABS( SUM(frac(i,:))-1.0 ) >= 1.0e-2 ) THEN
          WRITE(*,*)'ERROR: init_ic: frac does not sum to 1'
          IF ( l_urban2t ) THEN
            WRITE(*,*) 'URBAN-2T / MORUSES: The total urban fraction', &
               ' should be given in init_frac.'
            WRITE(*,*) '  The urban fraction is split, between urban_canyon', &
               ' & urban_roof, in'
            WRITE(*,*) '  init_urban using wrr (or the canyon fraction).', &
               ' This may be the cause'
            WRITE(*,*) '  of the error.'
          END IF
          STOP
        ELSE
!         Ignore small discrepancies and (re)normalise.
          WRITE(*,*)'Removing small discrepancy....'
          frac(i,:) = frac(i,:) / SUM(frac(i,:))
          WRITE(*,*)'new frac(i,1:ntype)=',frac(i,1:ntype)
        ENDIF
      ENDIF

    ENDDO

!-------------------------------------------------------------------------------
!   Process the ice fraction field.
!   Identify land ice points, only if the ice surface type is specified.
!-------------------------------------------------------------------------------
    lice_pts = 0
    lice_index(:) = 0
    IF ( ice > 0 ) THEN
      DO l=1,land_pts
        IF ( frac(l,ice) > 0.0 ) THEN
!         This is a land ice point.
          LICE_PTS = LICE_PTS + 1
          LICE_INDEX(LICE_PTS) = L
!         At present, land ice and soil points are mutually exclusive.
!         Check this is not a soil point.
          DO j=1,soil_pts
            IF ( l == soil_index(j) ) THEN
              WRITE(*,*)'ERROR: init_ic: a land ice point cannot also be a soil point.'
              WRITE(*,*)'Soil point #',j,' which is land point #',l,' has'
              WRITE(*,*)'ice fraction=',frac(l,ice)
              STOP
            ENDIF
          ENDDO   !  soil points
!         Check that ice fraction is one (cannot have partial ice coverage).
          IF ( ABS(frac(l,ice)-1.0) > EPSILON(frac(l,ice)) ) THEN
            WRITE(*,*)'ERROR: init_ic: ice fraction must be 1 at an ice point.'
            WRITE(*,*)'Point #,',l,' ice fraction=',frac(l,ice)
          ENDIF
        ENDIF
      ENDDO  !  l  (land points)
      IF ( echo ) WRITE(*,*)'Number of land ice points=',lice_pts
    ENDIF    !  ice

!-------------------------------------------------------------------------------
!   Check that all land points have been identified as either soil or ice.
!-------------------------------------------------------------------------------
    IF ( soil_pts+lice_pts /= land_pts ) THEN
      WRITE(*,*)'ERROR: init_ic: land point sum incorrect.'
      WRITE(*,*)'All land points should be either soil or land ice points.'
      WRITE(*,*)'We have land_pts=',land_pts,' soil_pts+lice_pts=',soil_pts+lice_pts
      WRITE(*,*)'soil_pts=',soil_pts,' lice_pts=',lice_pts
      WRITE(*,*)'Check that soil properties are correctly set at soil points,'
      WRITE(*,*)'and that fractional coverage of ice=1 at all other (non-soil) land points.'
      STOP
    ENDIF

!-------------------------------------------------------------------------------
!   Set up tile index.
!-------------------------------------------------------------------------------
    CALL TILEPTS( LAND_PTS,FRAC,TILE_PTS,TILE_INDEX )

! For URBAN-2T or MORUSES: Check that urban canyons also have roofs
    IF ( l_urban2t ) THEN
      IF ( tile_pts(urban_canyon) /= tile_pts(urban_roof) ) THEN
        WRITE(*,*) 'ERROR: init_ic: URBAN-2T or MORUSES: # canyons /= # roofs'
        STOP
      END IF
    END IF

!-------------------------------------------------------------------------------
!   Deal with "simple" initialisation of snow variables.
!-------------------------------------------------------------------------------
    IF ( totalSnow ) CALL totalSnowInit

  ENDIF  !  routeOnly

!-------------------------------------------------------------------------------
! The routing store has been set at all locations on the routing grid, but
! many of these may be "inactive" points, e.g. sea.
! To distinguish these from active points in any output, set value to <0 at
! inactive points. Only do this if value was set to a constant.
!-------------------------------------------------------------------------------

  IF ( route .AND. varFlag(iposRouteStore)==-1 ) THEN
!   Create a -1/1 mask for the inactive/active points.
    workSpace(:,:) = -1
    DO i=1,npRoute
!     Get location on routing grid.
      CALL getXYPos( routeIndex(i),nxRoute,nyRoute,ix,iy )
      workSpace(ix,iy) = 1.0
    ENDDO
!cxyz    WHERE ( workSpace(1:nxRoute,1:nyRoute) < 0.0 ) routeStore(:,:) = -1.0e6
  ENDIF

!------------------------------------------------------------------------------
! Optional write of fields to screen.
!------------------------------------------------------------------------------

  IF ( echo ) THEN
!   Print full fields, level by level.
    CALL init_ic_diag( .TRUE.,.FALSE.,sthuf )
!   Print summary of full field.
    CALL init_ic_diag( .FALSE.,.TRUE.,sthuf )
!    IF ( nx*ny > 1 ) CALL init_ic_diag( .FALSE.,.TRUE.,sthuf )
  ENDIF  !  echo

  IF ( .NOT. routeOnly ) THEN
!-------------------------------------------------------------------------------
!   Calculate frozen and unfrozen fractions of soil moisture.
!------------------------------------------------------------------------------
    CALL FREEZE_SOIL (LAND_PTS,SM_LEVELS  &
                               ,B,DZSOIL,SATHH,SMCL,T_SOIL,SMVCST,STHU,STHF)

!------------------------------------------------------------------------------
!   Finish initialising TOPMODEL.
!------------------------------------------------------------------------------
    IF ( l_top ) CALL topmod_init()

  ENDIF  !  routeOnly

!------------------------------------------------------------------------------
! Deallocate memory.
!------------------------------------------------------------------------------
  ierrSum = 0
  DEALLOCATE( workSpace,stat=ierr )
  ierrSum = ierrSum + ierr
  IF ( ierrSum/=0 ) WRITE(*,*)'WARNING: init_ic: error on deallocate. ierrSum=',ierrSum

  END SUBROUTINE init_ic

!###############################################################################
!###############################################################################

! subroutine init_ic_diag
! Module procedure in module initial_mod.
! Writes diagnostics of initial state.

  SUBROUTINE init_ic_diag( levels,summary,sthuf )

!-------------------------------------------------------------------------------
  USE ancil_info, ONLY :  &
!  imported scalars with intent(in)
     land_pts,ntiles,sm_levels  &
!  imported arrays with intent(in)
    ,frac

  USE misc_utils, ONLY :  &
!  imported procedures
     varValue

  USE nstypes, ONLY :  &
!  imported scalars with intent(in)
     npft,ntype

  USE pftparm, ONLY :  &
!  imported arrays with intent(in)
     pftName

  USE nvegparm, ONLY :  &
!  imported arrays with intent(in)
     nvgName

  USE prognostics, ONLY :  &
!  imported arrays with intent(in)
     canht_ft,canopy,cs,gs,lai,nsnow,rgrain,rgrainL,rho_snow_grnd  &
    ,routeStore,sice,sliq,smcl,snow_grnd,snow_tile,snowDepth,t_soil  &
    ,tsnow,tstar_tile

  USE snow_param, ONLY :  &
!  imported arrays with intent(in)
     ds

  USE switches, ONLY :  &
!  imported scalars with intent(in)
     l_aggregate,routeOnly

  USE top_pdm, ONLY :  &
!  imported arrays with intent(in)
     sthzw,zw

  USE trifctl, ONLY :   &
!  imported arrays with intent(in)
     g_leaf_acc,g_leaf_phen_acc,npp_ft_acc,resp_s_acc,resp_w_ft_acc,cv
     
  USE imogen_progs, ONLY :  &
     co2_ppmv,co2_change_ppmv,dtemp_o,fa_ocean,seed_rain

  IMPLICIT NONE

!-------------------------------------------------------------------------------
! Scalar arguments with intent(in):
!-------------------------------------------------------------------------------

  LOGICAL, INTENT(in) ::  levels   !   flag indicating how to deal with levels
!             TRUE means process each level separately
!             FALSE means process entire field as one
  LOGICAL, INTENT(in) ::  summary  !   flag indicating what type of information to produce
!                  TRUE means output summary statistics
!                  FALSE means output entire fields
! Note that at time of writing, two types of call were expected:
! 1) summary=T,levels=F to summarise field. For some fields the whole field is
!    treated as one, for others the field is processed level by level (e.g. canht)
! 2) summary=F,levels=T to print field level by level
!

!-------------------------------------------------------------------------------
! Array arguments with intent(in)
!-------------------------------------------------------------------------------
  REAL, INTENT(in) :: sthuf(land_pts,sm_levels)   !  soil wetness

!-------------------------------------------------------------------------------
! Local scalar parameters
!-------------------------------------------------------------------------------
  REAL, PARAMETER :: fracMin = 0.0001   !  minimum value of fraction for which
!                                          a type is considered

!-------------------------------------------------------------------------------
! Local scalars variables
!-------------------------------------------------------------------------------
  INTEGER :: ivar          !  loop counter

  LOGICAL :: tileFracMask  !  switch indicating if summary statistics of tile
!                             variables are only to consider points with frac>0.

!-------------------------------------------------------------------------------
! Local array variables.
!-------------------------------------------------------------------------------

  REAL ::  &
   tileFrac(land_pts,ntiles)      !  work: used when calculating statistics

  CHARACTER(len=20) :: tileName(ntiles)   !  name of each surface tile
  CHARACTER(len=20) :: typeName(ntype)    !  name of each surface type

!-------------------------------------------------------------------------------

! Set values of switch.
  tileFracMask = .TRUE.
  IF ( l_aggregate ) tileFracMask = .FALSE.
  IF ( routeOnly ) tileFracMask = .FALSE.

  IF ( .NOT. routeOnly ) THEN

!   Get names of surface types and tiles.
    typeName(1:npft) = pftName(:)
    typeName(npft+1:ntype) = nvgName(:)
    IF ( l_aggregate ) THEN
      tileName(1) = 'aggregate'
    ELSE
       tileName(:) = typeName(:)
    ENDIF

    IF ( summary ) THEN

!     Set value of mask field.
      IF ( tileFracMask ) THEN
!       Assuming ntiles=ntype.
        tileFrac(:,:) = frac(:,:)
      ELSE
!       Set a value > fracMin, so all points are included.
        tileFrac(:,:) = 1.0 + fracMin
      ENDIF

    ENDIF  !  summary

  ENDIF  !  routeOnly
!-------------------------------------------------------------------------------

  IF ( summary ) THEN
    WRITE(*,"(50('#'),/,a)")'Approx statistics of the initial state.'
    IF ( tileFracMask ) THEN
      WRITE(*,"(a,es7.1,a,/)")'Only locations with frac>',fracMin,' are considered.'
    ELSE
      WRITE(*,"(a,/)")'Locations with frac=0 are included in statistics.'
    ENDIF
  ELSE
    WRITE(*,"(50('#'),/,a,/)")'The initial state is:'
  ENDIF

! A possible extension would be to create a mask for soil points, so that e.g.
! soil moisture would not be summarised at ice points.

!-------------------------------------------------------------------------------
! The following is inside a loop so that if new variables are added, but the
! user forgets to include them here, a warning is raised. Just so nothing is
! left out!
!-------------------------------------------------------------------------------

  DO ivar=1,nvarMax

    IF ( varUse(ivar) == 1 ) THEN

      IF ( icVarSet(ivar) ) THEN

!-------------------------------------------------------------------------------
        IF ( ivar == iposCanht ) THEN
!         Only summarise where tile_frac>min. This is a var on PFTs.
          CALL varValue( levels,summary,canht_ft,varFormat='f9.2'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar)  &
                        ,levName=tileName(1:npft)  &
                        ,maskVar=tileFrac(:,1:npft),maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCanopy ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,canopy,varFormat='f9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCs ) THEN
          CALL varValue( levels,summary,cs(:,:),varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposFrac ) THEN

          IF ( summary ) WRITE(*,"(a)") '# All values of frac are included here.'
          CALL varValue( levels,summary,frac,varFormat='f7.3'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=typeName )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposGLeafAcc ) THEN
!         Only summarise where frac>min. This is a var on PFTs.
          CALL varValue( levels,summary,g_leaf_acc,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=typeName(1:npft)  &
                        ,maskVar=frac(:,1:npft),maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposGLeafPhenAcc ) THEN
!         Only summarise where frac>min. This is a var on PFTs.
          CALL varValue( levels,summary,g_leaf_phen_acc,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=typeName(1:npft)  &
                        ,maskVar=frac(:,1:npft),maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposGs ) THEN
          CALL varValue( summary,gs,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposLAI ) THEN
!         Only summarise where frac>min. This is a var on PFTs.
          CALL varValue( levels,summary,lai,varFormat='f9.2'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=typeName(1:npft)  &
                        ,maskVar=frac(:,1:npft),maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposNppFtAcc ) THEN
!         Only summarise where frac>min. This is a var on PFTs.
          CALL varValue( levels,summary,npp_ft_acc,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=typeName(1:npft)  &
                        ,maskVar=frac(:,1:npft),maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposNsnow ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,REAL(nsnow),varFormat='f5.0'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRespSAcc ) THEN
          CALL varValue( summary,resp_s_acc(:,1),varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRespWFtAcc ) THEN
!         Only summarise where frac>min. This is a var on PFTs.
          CALL varValue( levels,summary,resp_w_ft_acc,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=typeName(1:npft)  &
                        ,maskVar=frac(:,1:npft),maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRgrain ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,rgrain,varFormat='f6.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRgrainL ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,rgrainL,varFormat='f6.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRhoSnow ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,rho_snow_grnd,varFormat='f6.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRouteStore ) THEN
          IF ( summary ) WRITE(*,*)'NB Range includes "inactive"/sea points.'
          CALL varValue( summary,PACK( routeStore,.TRUE.)  &
                        ,varFormat='es9.2'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowTile ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,snow_tile,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowDepth ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,snowDepth,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowDs ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,ds,varFormat='f7.3'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowIce ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,sice,varFormat='f6.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowLiq ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,sliq,varFormat='f6.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowGrnd ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,snow_grnd,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSthuf ) THEN
          CALL varValue( levels,summary,sthuf,varFormat='f6.3'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )

!         Also write smcl values here.
          WRITE(*,"(a)") '# Soil moisture (kg m-2) - this includes any ice points'
          CALL varValue( levels,summary,smcl,varFormat='f7.1'  &
                        ,varDesc='Soil moisture (kg m-2)',varName='smcl' )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSthZw ) THEN
          CALL varValue( summary,sthzw,varFormat='f6.3'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposTsnow ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,tsnow,varFormat='f7.2'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposTsoil ) THEN
          CALL varValue( levels,summary,t_soil,varFormat='f7.2'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposTstarT ) THEN
!         Only summarise where tile_frac>min.
          CALL varValue( levels,summary,tstar_tile,varFormat='f9.2'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar),levName=tileName  &
                        ,maskVar=tileFrac,maskMin=fracMin )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposZw ) THEN
          CALL varValue( summary,zw,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCo2 ) THEN
! Since this is a scalar value, we need to copy its value into an
! array of size one for the varValue code to work
          CALL varValue( summary,(/ co2_ppmv /),varFormat='f7.2'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCo2Change ) THEN
! Since this is a scalar value, we need to copy its value into an
! array of size one for the varValue code to work
          CALL varValue( summary,(/ co2_change_ppmv /),varFormat='f7.2'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposDTempO ) THEN
          CALL varValue( summary,dtemp_o,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposFaOcean ) THEN
          CALL varValue( summary,fa_ocean,varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSeedRain ) THEN
          CALL varValue( summary,REAL(seed_rain),varFormat='f5.0'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCv ) THEN
          CALL varValue( summary,cv(:),varFormat='es9.1'  &
                        ,varDesc=varDescFull(ivar),varName=varName(ivar) )
!-------------------------------------------------------------------------------
        ELSE
          WRITE(*,*)'WARNING: init_ic: no output code for varName=',TRIM(varName(ivar))
          WRITE(*,*)'This is not too serious - just means diagnostic information will not be provided!'
        ENDIF   !  ivar

      ELSE

!       NOT icVarSet
        WRITE(*,"(2a)") '# ',TRIM(varDesc(ivar))
        WRITE(*,*)'This variable has not yet been set. Waiting for further information.'
        WRITE(*,*)'There is no code to do this yet!'
        WRITE(*,*)'ERROR. Stopping in SUBROUTINE init_ic_diag'
        STOP

      ENDIF  !  icVarSet
    ENDIF   !  varUse
  ENDDO  !  ivar

  END SUBROUTINE init_ic_diag
!###############################################################################
!###############################################################################

! subroutine fill_ic_var
! Internal procedure in module initial_mod.
! Load values for the initial state that have been read from file into the
! correct variable.
! This code is in a subroutine as it is used in more than one location.

  SUBROUTINE fill_ic_var( ivar,zrev,tmpval )

  USE ancil_info, ONLY :  &
!  imported arrays with intent(inout)
     frac

  USE p_s_parms, ONLY :   &
!  imported arrays with intent(inout)
     sthf,sthu   !   sthu may be used for sthuf

  USE prognostics, ONLY :  &
!  imported arrays with intent(inout)
     canht_ft,canopy,cs,gs,lai,nsnow  &
    ,rgrain,rgrainL,rho_snow_grnd,routeStore,sice,sliq,snow_grnd,snow_tile  &
    ,snowDepth,t_soil,tsnow,tstar_tile

  USE route_mod, ONLY :  &
!  imported scalaras with intent(in)
     nxRoute,nyRoute

  USE snow_param, ONLY :  &
!  imported arrays with intent(out)
     ds

  USE top_pdm, ONLY :  &
!  imported scalars with intent(out)
     zw,sthzw

  USE trifctl, ONLY :   &
!  imported arrays with intent(inout)
     g_leaf_acc,g_leaf_phen_acc,npp_ft_acc,resp_s_acc,resp_w_ft_acc,cv

  USE imogen_progs, ONLY :  &
     co2_ppmv,co2_change_ppmv,dtemp_o,fa_ocean,seed_rain

  IMPLICIT NONE

!-------------------------------------------------------------------------------
! Scalar arguments with intent(in)
!-------------------------------------------------------------------------------
  INTEGER, INTENT(in) :: ivar     !  variable number (loop counter)
  LOGICAL, INTENT(in) :: zrev     !  flag indicating if order of levels is to be reversed
!                                      Only used for snow layer variables. All
!                                      others are reversed when read.

!-------------------------------------------------------------------------------
! Optional array arguments with intent(in)
!-------------------------------------------------------------------------------
  REAL, INTENT(in), OPTIONAL :: tmpval(:,:)   !  input data (not constant)

!-------------------------------------------------------------------------------
! For each variable, decide whether to use spatial field or a constant value.
! Other possibilties are dealt with elsewhere.
!-------------------------------------------------------------------------------

! Check that optional argument is present, if required.
  IF ( varFlag(ivar)>0 .AND. .NOT.PRESENT(tmpVal) ) THEN
    WRITE(*,*)'ERROR: fill_ic_var: tmpval not provided, but varFlag>0.'
    WRITE(*,*)'ivar=',ivar,' varName=',TRIM(varName(ivar))
    STOP
  ENDIF

  IF ( ivar == iposCanHt ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      canht_ft(:,:) = tmpval(:,:)
    ELSEIF ( varFlag(ivar) == -1 ) THEN
      canht_ft(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposCanopy ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      canopy(:,:) = tmpval(:,:)
    ELSE
      canopy(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposCs ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      cs(:,:) = tmpval(:,:)
    ELSE
      cs(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposFrac ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      frac(:,:) = tmpval(:,:)
    ELSE
      frac(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposGleafAcc ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      g_leaf_acc(:,:) = tmpval(:,:)
    ELSE
      g_leaf_acc(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposGleafPhenAcc ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      g_leaf_phen_acc(:,:) = tmpval(:,:)
    ELSE
      g_leaf_phen_acc(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposGs ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      gs(:) = tmpval(:,1)
    ELSE
      gs(:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposLAI ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      lai(:,:) = tmpval(:,:)
    ELSE
      lai(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposNppFtAcc ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      npp_ft_acc(:,:) = tmpval(:,:)
    ELSE
      npp_ft_acc(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposNsnow ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      nsnow(:,:) = NINT( tmpval(:,:) )
    ELSE
      nsnow(:,:) = NINT( varConst(ivar) )
    ENDIF

  ELSEIF ( ivar == iposRespSAcc ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      resp_s_acc(:,1) = tmpval(:,1)
    ELSE
      resp_s_acc(:,1) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposRespWFtAcc ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      resp_w_ft_acc(:,:) = tmpval(:,:)
    ELSE
      resp_w_ft_acc(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposRgrain ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      rgrain(:,:) = tmpval(:,:)
    ELSE
      rgrain(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposRgrainL ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      rgrainL(:,:,:) = snowLayerVar( zrev,tmpval(:,:) )
    ELSE
      rgrainL(:,:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposRhoSnow ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      rho_snow_grnd(:,:) = tmpval(:,:)
    ELSE
      rho_snow_grnd(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposRouteStore ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
!     Reshape from a vector to routing grid.
      routeStore(:,:) = RESHAPE( tmpval(:,1), (/nxRoute,nyRoute/) )
    ELSE
      routeStore(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSnowtile ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      snow_tile(:,:) = tmpval(:,:)
    ELSE
      snow_tile(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSnowDepth ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      snowDepth(:,:) = tmpval(:,:)
    ELSE
      snowDepth(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSnowGrnd ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      snow_grnd(:,:) = tmpval(:,:)
    ELSE
      snow_grnd(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSnowDs ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      ds(:,:,:) = snowLayerVar( zrev,tmpval(:,:) )
    ELSE
      ds(:,:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSnowIce ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      sice(:,:,:) = snowLayerVar( zrev,tmpval(:,:) )
    ELSE
      sice(:,:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSnowLiq ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      sliq(:,:,:) = snowLayerVar( zrev,tmpval(:,:) )
    ELSE
      sliq(:,:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSthf ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      sthf(:,:) = tmpval(:,:)
    ELSE
      sthf(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSthu ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      sthu(:,:) = tmpval(:,:)
    ELSE
      sthu(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSthuf ) THEN
!   sthuf is held in sthu.
    IF ( varFlag(ivar) > 0 ) THEN
      sthu(:,:) = tmpval(:,:)
    ELSE
      sthu(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposSthzw ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      sthzw(:) = tmpval(:,1)
    ELSE
      sthzw(:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposTsnow ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      tsnow(:,:,:) = snowLayerVar( zrev,tmpval(:,:) )
    ELSE
      tsnow(:,:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposTsoil ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      t_soil(:,:) = tmpval(:,:)
    ELSE
      t_soil(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposTstarT ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      tstar_tile(:,:) = tmpval(:,:)
    ELSE
      tstar_tile(:,:) = varConst(ivar)
    ENDIF

  ELSEIF ( ivar == iposZw ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      zw(:) = tmpval(:,1)
    ELSE
      zw(:) = varConst(ivar)
    ENDIF
    
  ELSEIF ( ivar == iposCo2 ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      co2_ppmv = tmpval(1,1)
    ELSE
      co2_ppmv = varConst(ivar)
    ENDIF
    
  ELSEIF ( ivar == iposCo2Change ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      co2_change_ppmv = tmpval(1,1)
    ELSE
      co2_change_ppmv = varConst(ivar)
    ENDIF
    
  ELSEIF ( ivar == iposDTempO ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      dtemp_o(:) = tmpval(:,1)
    ELSE
      dtemp_o(:) = varConst(ivar)
    ENDIF
    
  ELSEIF ( ivar == iposFaOcean ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      fa_ocean(:) = tmpval(:,1)
    ELSE
      fa_ocean(:) = varConst(ivar)
    ENDIF
    
  ELSEIF ( ivar == iposSeedRain ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      seed_rain(:) = NINT(tmpval(:,1))
    ELSE
      seed_rain(:) = NINT(varConst(ivar))
    ENDIF

  ELSEIF ( ivar == iposCv ) THEN
    IF ( varFlag(ivar) > 0 ) THEN
      cv(:) = tmpval(:,1)
    ELSE
      cv(:) = varConst(ivar)
    ENDIF

!-------------------------------------------------------------------------------
  ELSE
     WRITE(*,*)'ERROR: fill_ic_var: no code to load ivar=',ivar
     WRITE(*,*) TRIM(varName(ivar))
     STOP

  ENDIF

  END SUBROUTINE fill_ic_var

!###############################################################################
!###############################################################################
!###############################################################################
!###############################################################################

! function snowLayerVar
! Load values into a 3-D snow layer variable, given 2-D input.

  FUNCTION snowLayerVar( zrev,inval )  &
                           RESULT( outval )

  USE ancil_info, ONLY :  &
!  imported scalars with intent(in)
     land_pts,nsmax,ntiles

  IMPLICIT NONE

! Function result.
  REAL :: outval(land_pts,ntiles,nsmax) !  a snow layer variable

! Scalar arguments with intent(in)
  LOGICAL, INTENT(in) :: zrev       !  flag indicating if order of levels is to be reversed

! Array arguments with intent(in)
  REAL, INTENT(in) :: inval(land_pts,ntiles*nsmax) ! input data

! Local scalars.
  INTEGER :: i,iz,t   !  loop counters

!-------------------------------------------------------------------------------

! The input data have point varying fastest, then layer, then tile.

  IF ( .NOT. zrev ) THEN

    outval(:,:,:) = RESHAPE( inval(:,:), (/ land_pts,ntiles,nsmax /)  &
                                       , order=(/ 1,3,2 /) )
  ELSE

!   Note that these data did not have order of levels altered when read from file.
    DO t=1,ntiles
      DO iz=1,nsmax
        i = t*nsmax - iz + 1
        outval(:,t,iz) = inval(:,i)
      ENDDO
    ENDDO

  ENDIF

  END FUNCTION snowLayerVar

!###############################################################################
!###############################################################################
!###############################################################################
! subroutine totalSnowInit
! Initialise snow variables if "simple initialisation" flag is set.

  SUBROUTINE totalSnowInit

  USE ancil_info, ONLY :  &
!  imported scalars with intent(in)
     land_pts,nsmax,ntiles  &
!  imported arrays with intent(in)
    ,tile_index,tile_pts

  USE prognostics, ONLY :  &
!  imported arrays with intent(in)
     nsnow,rgrain,snow_tile,t_soil  &
!  imported arrays with intent(out)
    ,rgrainL,rho_snow_grnd,sice,sliq,snow_grnd,snowDepth,tsnow

  USE snow_param, ONLY :  &
!  imported scalars with intent(in)
     rho_snow_const  &
!  imported arrays with intent(in)
    ,canSnowTile  &
!  imported arrays with intent(out)
    ,ds

  USE switches, ONLY :  &
!  imported scalars with intent(in)
     l_spec_albedo

  IMPLICIT NONE

! Local scalar variables.
  INTEGER :: i,j,k,n         !  work/loop counters

! Local array variables.
  REAL :: snow_on_ground(land_pts,ntiles)  !  snow considered to be on the
!        ground (not in canopy) (kg m-2). This is all the snow.

!-------------------------------------------------------------------------------
! Put all snow onto the ground and zero canopy snow.
! Currently all snow is held in snow_tile.
! For can_model=4 tiles, put snow into snow_grnd and zero snow_tile.
!-------------------------------------------------------------------------------

! Save input value.
  snow_on_ground(:,:) = snow_tile(:,:)

! Initialise stores to zero.
  snow_grnd(:,:) = 0.0
  snow_tile(:,:) = 0.0

! Initialise other variables with values that will be retained where there is
! no tile - using "sensible" values for when these are printed.
  snowDepth(:,:) = 0.0
  rho_snow_grnd(:,:) = rho_snow_const
  IF ( nsmax > 0 ) THEN
    tsnow(:,:,:) = 273.15
    ds(:,:,:) = 0.0
    IF ( l_spec_albedo ) rgrainL(:,:,:) = 0.0
  ENDIF

  DO n=1,ntiles
    IF ( canSnowTile(n) ) THEN
      DO j=1,tile_pts(n)
        i = tile_index(j,n)
        snow_grnd(i,n) = snow_on_ground(i,n)
      ENDDO
    ELSE
      DO j=1,tile_pts(n)
        i = tile_index(j,n)
        snow_tile(i,n) = snow_on_ground(i,n)
      ENDDO
    ENDIF
  ENDDO

!-------------------------------------------------------------------------------
! Calculate snow depth and set temperature of snow to equal that of soil.
!-------------------------------------------------------------------------------
  DO n=1,ntiles
    DO j=1,tile_pts(n)
      i = tile_index(j,n)
      rho_snow_grnd(i,n) = rho_snow_const
      snowDepth(i,n) = snow_on_ground(i,n) / rho_snow_grnd(i,n)
      IF ( nsmax > 0 ) THEN
        tsnow(i,n,:) = t_soil(i,1)
        IF ( l_spec_albedo ) rgrainl(i,n,:) = rgrain(i,n)
      ENDIF
    ENDDO
  ENDDO

!-------------------------------------------------------------------------------
! Calculate snow layer thicknesses.
!-------------------------------------------------------------------------------
  DO N=1,NTILES
    CALL layersnow( land_pts,tile_pts(n),tile_index(:,n),snowdepth(:,n)  &
                   ,nsnow(:,n),ds(:,n,:) )
  ENDDO

!-------------------------------------------------------------------------------
! Set layer frozen and liquid contents.
!-------------------------------------------------------------------------------
  IF ( nsmax > 0 ) THEN
    sice(:,:,:) = 0.0
    sliq(:,:,:) = 0.0
    DO n=1,ntiles
      DO j=1,tile_pts(n)
        i = tile_index(j,n)
        DO k=1,nsnow(i,n)
          sice(i,n,k) =  snow_on_ground(i,n) * ds(i,n,k) / snowdepth(i,n)
        ENDDO
      ENDDO
    ENDDO
  ENDIF

  END SUBROUTINE totalSnowInit

!###############################################################################
!###############################################################################
!###############################################################################

  SUBROUTINE topmod_init

!-------------------------------------------------------------------------------
! Finish initialising TOPMODEL by calculating surface saturated fraction.
!-------------------------------------------------------------------------------

  USE ancil_info, ONLY :  &
!  imported scalars with intent(in)
     land_pts,sm_levels,soil_pts  &
!  imported arrays with intent(in)
    ,soil_index

  USE p_s_parms, ONLY :   &
!  imported arrays with intent(in)
     b,satcon,sthf,sthu

  USE soil_param, ONLY :  &
!  imported arrays with intent(in)
     dzsoil

  USE top_pdm, ONLY :  &
!    imported arrays with intent(in)
       fexp,gamtot,ti_mean,ti_sig,zw  &
!    imported arrays with intent(out)
      ,fsat,fwetl,qbase

  IMPLICIT NONE

!-------------------------------------------------------------------------------
! Local scalar parameters.
  LOGICAL, PARAMETER :: l_gamtot = .TRUE.  !  switch for calculation of gamtot

! Local scalar variables.
  INTEGER :: i,j,n     !  work/loop counters

! Local array variables.
  REAL :: qbase_l(land_pts,sm_levels+1) !  Base flow from each layer (kg/m2/s).
  REAL :: top_crit(land_pts)            !  Critical topographic index required
!                                       !    to calculate the surface saturation
!                                            fraction.
  REAL :: zdepth(0:sm_levels)           !  Lower soil layer boundary depth (m).
  REAL :: wutot(land_pts)               !  UNFROZEN to TOTAL fraction at ZW.
  REAL :: ksz(land_pts,0:sm_levels)     !  Saturated hydraulic conductivity for
!                                            each layer (kg/m2/s).

!-------------------------------------------------------------------------------
  zdepth(0) = 0.0
  DO n=1,sm_levels
    zdepth(n) = zdepth(n-1) + dzsoil(n)
  ENDDO

! Set value that is retained at non-soil points.
  fsat(:) = 0.0
  fwetl(:) = 0.0

  IF ( soil_pts /= 0 ) THEN

    DO j=1,soil_pts
      i = soil_index(J)
      DO n=0,sm_levels
        ksz(i,n) = satcon(i,n)
      ENDDO
    ENDDO

!   We need top_crit to calculate fsat - get this from calc_baseflow.
    CALL calc_baseflow_jules( soil_pts,soil_index,land_pts,sm_levels  &
                             ,zdepth,ksz,b,fexp,ti_mean,zw,sthf,sthu  &
                             ,wutot,top_crit,qbase,qbase_l )

!   Call calc_fsat with 1st argument (l_gamtot)=.FALSE. so as get fsat.
    CALL calc_fsat( l_gamtot,soil_pts,soil_index,land_pts  &
                   ,ti_mean,ti_sig,wutot,top_crit,gamtot,fsat,fwetl)

  ENDIF  !  soil_pts

  END SUBROUTINE topmod_init

!###############################################################################
!###############################################################################
!###############################################################################
! subroutine dump_io
! Module procedure in module dump_mod.
! Read or write a model dump.
! Both bits of code are kept here in the hope that if you change one, you'll
! remember also to change the other!

!-------------------------------------------------------------------------------
  SUBROUTINE dump_io( doWrite,dumpInFormat,dumpTypeArg,dumpName )

  USE ancil_info, ONLY :  &
!  imported scalars with intent(in)
     dim_cs1,land_pts,nsmax,ntiles,sm_levels  &
!  imported arrays with intent(in)
    ,frac,land_index

  USE file_utils, ONLY :  &
!  imported procedures
     closeFile,fileUnit,openFile  &
!  imported arrays with intent(inout)
    ,irecPrev

  USE inout, ONLY :  &
!  imported scalar parameters
     formatAsc,formatLen,formatNc  &
!  imported scalars with intent(in)
    ,dumpFormat,dumpStatus,echo,outDir,runID &
!  imported scalars with intent(inout)
    ,dumpWarn, jinUnit  !DSM incluido o jinUnit

  USE jules_netcdf, ONLY :  &
!  imported scalars with intent(in)
     ncTypeJules  &
!  imported procedures
    ,createNcFile,readVarNcDump

  USE nstypes, ONLY :  &
!  imported scalars with intent(in)
     npft,ntype

  USE nvegparm, ONLY :   &
!  imported arrays with intent(in)
     nvgName

  USE pftparm, ONLY :   &
!  imported arrays with intent(in)
     pftName

  USE p_s_parms, ONLY :   &
!  imported arrays with intent(inout)
     sthf,sthu

  USE prognostics, ONLY :   &
!  imported arrays with intent(inout)
     canht_ft,canopy,cs,gs,lai,nsnow,rgrain,rgrainL,rho_snow_grnd  &
    ,routeStore,snow_grnd  &
    ,snow_tile,snowDepth,sice,sliq,t_soil,tsnow,tstar_tile

  USE readWrite_mod, ONLY :  &
!  imported procedures
     readvar3dComp,writeVar

  USE route_mod, ONLY :  &
!  imported scalar parameters
     routeTypeTRIP  &
!  imported scalars with intent(in)
    ,nxRoute,nyRoute,routeType

  USE snow_param, ONLY :  &
!  imported arrays with intent(inout)
     ds

  USE spin_Mod, ONLY :   &
!  imported scalars with intent(in)
    ispin,spinUp

  USE switches, ONLY :  &
!  imported scalars with intent(in)
     l_360,l_aggregate,route,l_imogen

  USE time_loc, ONLY :   &
!  imported scalars with intent(in)
     date,nxGrid,nyGrid,regDlat,regDlon,regLat1,regLon1,time

  USE time_mod, ONLY :   &
!  imported procedures
     dateToBits,monthName3,s_to_chhmmss,secToSMH

  USE top_pdm, ONLY :  &
!  imported scalars with intent(inout)
     zw,sthzw

  USE trifctl, ONLY :   &
!  imported arrays with intent(inout)
     g_leaf_acc,g_leaf_phen_acc,npp_ft_acc,resp_s_acc,resp_w_ft_acc,cv

  USE imogen_progs, ONLY :  &
     co2_ppmv,co2_change_ppmv,dtemp_o,fa_ocean,seed_rain
     
  USE imogen_constants, ONLY : n_olevs,nfarray

!-------------------------------------------------------------------------------
  IMPLICIT NONE

!-------------------------------------------------------------------------------
! Scalar arguments with intent(in)
!-------------------------------------------------------------------------------
  LOGICAL, INTENT(in) :: doWrite   !  T means write a dump, F means read a dump

!-------------------------------------------------------------------------------
! Optional scalar arguments with intent(in)
!-------------------------------------------------------------------------------
  CHARACTER(len=*), INTENT(in), OPTIONAL ::  &
    dumpInFormat  &!  format of any input dump
   ,dumpName      &!  name of a dump file that is to be read
   ,dumpTypeArg    !  type of dump that is to be written (e.g. final dump,
                   !  initial dump)

!-------------------------------------------------------------------------------
! Local scalar parameters.
!-------------------------------------------------------------------------------
  INTEGER, PARAMETER ::  &
!    The header parameters below must reflect the number of header lines that are
!    written by the code further below.
    nheaderFileOut = 12   &!  number of header lines at start of an ASCII dump file
   ,nheaderFieldOut = 1    !  number of header lines at start of every field in
!                             an ASCII dump file

  LOGICAL, PARAMETER :: dumpCompress = .TRUE. !  Dumps are essentially always
!    "compressed" in that they only include model points.

  LOGICAL, PARAMETER :: zrev = .FALSE.  !  argument to fill_ic_var, FALSE to
!    indicate that snow layer variables need not have order of layers reversed

!-------------------------------------------------------------------------------
! Local scalar variables.
!-------------------------------------------------------------------------------
  INTEGER ::  &
    day,hh,mm,month,ss,year  &!  work
   ,i            &!  loop counter
   ,irecOut      &!  output record number
   ,ivar         &!  loop counter
   ,j            &!  loop counter
   ,jvar         &!  work
   ,field        &!  work: starting field in file for a variable
   ,nfieldFile   &!  number of fields per time in a file
   ,nheaderFile     &!
   ,nheaderT     &!  number of headers at start of each time
   ,nlineField   &!  work
   ,nvar         &!  number of variables to be written to dump
   ,readNyIn     &!  work
   ,readT        &!  time level to be read from file
   ,unit          !  unit used to connect to file

  LOGICAL :: errFlag    !  T means an error was raised while looking for
!                          a variable in the dump
  LOGICAL :: fileExist  !  T means the dump file already exists
  LOGICAL :: haveSCpool,haveLand,havePFT,haveRoute,haveSnow  &
              ,haveSoil,haveTile,haveType,haveScalar,haveNOlevs  &
              ,haveNfarray,haveSeed
!              Flags indicating what "types" of variables are to be output.
!              Note that haveLand=T if there is any variable on land points
!              (not just a 'LA' variable).

  CHARACTER(len=formatLen) :: fileFormat   !  format of file
  CHARACTER(len=3) :: cmonth3  !  3 character month name
  CHARACTER(len=5) :: cnum   !  work
  CHARACTER(len=6) :: hhmmss    !  time of day
  CHARACTER(len=7) :: spinNum   !  work: spin up cycle, e.g. spin001
  CHARACTER(len=15) :: cdateTime       !  date and time as character (dddddd_hhmmss)
  CHARACTER(len=20) :: dateTimeString  !  date and time as yyyy-mm-dd hh:mm:ss
  CHARACTER(len=200) :: compressGridFile  !  file containing mapping data
  CHARACTER(len=200) :: headerDesc  !  work: description of dump type
  CHARACTER(len=200) :: header  !  work: a header line written to a dump
  CHARACTER(len=LEN(dumpStatus)) :: fileStatus    !  work: status of file
  CHARACTER(len=10) :: dumpType  !  local version of dumpTypeArg
  CHARACTER(len=MAX(150,LEN(outDir)+1+LEN(runID)+40)) :: fileName
               !  the name of a file
               !  length is longer than largest expected and is sufficient for
               !  a dump file called
               !  outDir/runID_yyyymmdd_hhmmss_dumpType_dump.asc.FAIL,
               !  The number comes allows for yyyymmdd(8),hhmmss(6)
               !  ,dumptype(8 for spinFail),_dump.asc.FAIL(14), plus 4*"_".
  CHARACTER(len=LEN(fileName)) :: tmpName   !  the name of a file

!-------------------------------------------------------------------------------
! Local array variables.
!-------------------------------------------------------------------------------
  INTEGER :: ncMap(ndimMax)    !  map argument for netCDF
  INTEGER :: ncStart(ndimMax)  !  start argument for netCDF
  INTEGER :: varID(nvarMax)    !  netCDF ID for each variable

  CHARACTER(len=LEN(pftName)) :: tileName(ntiles)   !  name of surface tile
  CHARACTER(len=LEN(pftName)) :: typeName(ntype)    !  name of surface type
  CHARACTER(len=LEN(varName)) :: varNameList(nvarMax)  !  names of required variables
  CHARACTER(len=LEN(varNcAtt)) :: varNcAttList(nvarMax,4)!  names of required variables
  CHARACTER(len=LEN(varType)) :: varTypeList(nvarMax)  !  types of required variables

!-----------------------------------------------------------------------------------
! Check that the required optional arguments are provided, but just ignore any
! unnecessary optional argument.
!-----------------------------------------------------------------------------------
! doWrite=FALSE must be accompanied by the optional file format and name.
  IF ( .NOT.doWrite .AND.  &
      ( .NOT.PRESENT(dumpInFormat) .OR. .NOT.PRESENT(dumpName) ) ) THEN
    WRITE(*,*)'ERROR: dump_io: doWrite=FALSE must be accompanied by the optional'
    WRITE(*,*)'arguments dumpInFormat and dumpName.'
    STOP
  ENDIF

!-----------------------------------------------------------------------------------
! Set default netCDF values.
! These are also passed as unused arguments for ASCII files.
!-----------------------------------------------------------------------------------
  varID(:) = 1
  ncStart(:) = 1

!-------------------------------------------------------------------------------
! Establish what kind of variables will be in dump - mainly for purposes of
! sorting out layers. Also set up netCDF attributes for output.
!-------------------------------------------------------------------------------
  haveLand = .FALSE.
  havePFT = .FALSE.
  haveRoute = .FALSE.
  haveSCpool = .FALSE.
  haveSnow = .FALSE.
  haveSoil = .FALSE.
  haveTile = .FALSE.
  haveType = .FALSE.
  haveScalar = .FALSE.
  haveNOlevs = .FALSE.
  haveNfarray = .FALSE.
  haveSeed = .FALSE.
  DO ivar=1,nvarMax
    IF ( varDump(ivar) ) THEN
      SELECT CASE ( varType(ivar) )

!cxyz Note that att could come from create_annotation, if that was called.

        CASE ( 'LA' )
          haveLand = .TRUE.
          varNcAtt(ivar,1) = 'TYX'
        CASE ( 'PF' )
          havePFT = .TRUE.
          haveLand = .TRUE.
          varNcAtt(ivar,1) = 'TZYX'
        CASE ( 'RG' )
          haveRoute = .TRUE.
          varNcAtt(ivar,1) = 'TYX'
        CASE ( 'SC' )
          haveSCpool = .TRUE.
          haveLand = .TRUE.
          varNcAtt(ivar,1) = 'TZYX'
        CASE ( 'SN' )
          haveSnow = .TRUE.
          haveLand = .TRUE.
          varNcAtt(ivar,1) = 'TPZYX'
!-------------------------------------------------------------------------------
!         Create a map between netCDF and FORTRAN dimensions.
!         This is needed because the FORTRAN variable is A(x,tile,z) but the
!         netCDF variable is B(x,z,tile,t). It's a long story how we got into
!         this corner, but it relates to bolting netCDF i/o onto GrADS-based code!
!-------------------------------------------------------------------------------
          ncMap(1) = 1
          ncMap(2) = varSize(ivar,3) * varSize(ivar,1)  !  ntiles * nx
          ncMap(3) = varSize(ivar,1)  !  nx
          ncMap(4) = PRODUCT( varSize(ivar,1:3) )  !  nx*nsmax*ntiles
        CASE ( 'SO' )
          haveSoil = .TRUE.
          haveLand = .TRUE.
          varNcAtt(ivar,1) = 'TZYX'
        CASE ( 'TI' )
          haveTile = .TRUE.
          haveLand = .TRUE.
          varNcAtt(ivar,1) = 'TZYX'
        CASE ( 'TY' )
          haveType = .TRUE.
          haveLand = .TRUE.
          varNcAtt(ivar,1) = 'TZYX'
!-------------------------------------------------------------------------------
! Cases for IMOGEN variables
!-------------------------------------------------------------------------------
        CASE ( 'SL' )
! SL indicates a scalar - represented by an array of dimension 1
          haveScalar = .TRUE.
        CASE ( 'OC' )
          haveNOlevs = .TRUE.
        CASE ( 'FA' )
          haveNfarray = .TRUE.
        CASE ( 'SD' )
          haveSeed = .TRUE.
        CASE default
          WRITE(*,*)'ERROR: dump_io: no code for varType=',TRIM(varType(ivar))
          STOP
      END SELECT
      varNcAtt(ivar,2) = varUnits(ivar)
      varNcAtt(ivar,3) = varName(ivar)
      varNcAtt(ivar,4) = varDesc(ivar)
    ENDIF
  ENDDO

!-------------------------------------------------------------------------------
! List the variables that are to be in dump.
! cxyz if reading, might not all need to be read from dump
!-------------------------------------------------------------------------------
  varNameList(:) = ''
  varTypeList(:) = ''
  varNcAttList(:,:) = ''
  nvar = 0
  DO ivar=1,nvarMax
    IF ( varDump(ivar) ) THEN
      nvar = nvar + 1
      varNameList(nvar) = varName(ivar)
      varTypeList(nvar) = varType(ivar)
      varNcAttList(nvar,:) = varNcAtt(ivar,:)
    ENDIF
  ENDDO

!###############################################################################
!###############################################################################

  IF ( doWrite ) THEN

!-------------------------------------------------------------------------------
!   Write a dump file.
!   Write all prognostic variables. Also write frac, if it's used by
!   the current model, even if it's not prognostic.
!-------------------------------------------------------------------------------

    fileFormat = dumpFormat

!-------------------------------------------------------------------------------
!   Get a value for the dump type.
!-------------------------------------------------------------------------------
    dumpType = '-'
    IF ( PRESENT( dumpTypeArg ) ) dumpType = dumpTypeArg
!   Flag dumps during spin up.
    IF ( dumpType=='-' .AND. spinUp ) dumpType='spin'

!-------------------------------------------------------------------------------
!   Check we recognise the dump type.
!-------------------------------------------------------------------------------
    SELECT CASE ( dumpType )
      CASE ( 'init','final','spin','spinFail','spunup','-' )
!       Valid dump types
      CASE default
        WRITE(*,*)'ERROR: dump_io: do not recognise dumpType=',TRIM(dumpType)
        STOP
    END SELECT

!-------------------------------------------------------------------------------
!   Get name of dump file.
!-------------------------------------------------------------------------------
    hhmmss = s_to_chhmmss( time,.TRUE. )
    WRITE(cdateTime,"(i8.8,a1,a6)") date,'_',hhmmss
    fileName = TRIM(outDir) // '/' // TRIM(runID) // '_' // cdateTime
!   Include the type of certain "special" dumps in the file name.
    SELECT CASE ( dumpType )
      CASE ( 'spinFail','spunup' )
        fileName = TRIM(fileName) // '_' // TRIM(dumpType)
      CASE ( 'spin' )
!       Include number of spin up cycle. This call is at the start of a
!        calendar year. If this is at the end of a cycle of spinup (and the
!       start of another cycle), the date will be that for start of spin up,
!       and  spinNum will be for the next cycle.
!       e.g. spin up over 1Jan2000 to 31Jan2000, after 1 cycle the dump will
!       be called/annotated with 1Jan2000, spinNum=2. This is probably best,
!       if slightly confusing.
        WRITE(spinNum,"(a4,i3.3)") 'spin',ispin
        fileName = TRIM(fileName) // '_' // TRIM(spinNum)
    END SELECT

!   Add extension.
    fileName = TRIM(fileName) // '_dump.' // TRIM(dumpFormat)

!   If the status of the dump is 'replace', we use the current name (regardless
!   of whether or not this already exists).
!   If the status of the dump is 'new' but a file with this name already exists,
!   we first try to get some alternative names, but we may eventually fail.

    fileExist = .FALSE.
    fileStatus = dumpStatus
    IF ( dumpStatus == 'new' ) INQUIRE( file=fileName, exist=fileExist )

!   If dump already exists, create a new file name. In particular, we'd really
!   like to write a final dump rather than end the run with no record of the
!   final state!
    IF ( fileExist ) THEN
      dumpWarn = .TRUE.
      WRITE(*,"(50('#'),/,a)")'WARNING: dump_io: Dump file already exists.'
      WRITE(*,*)'file: ',TRIM(fileName)
!     Have 10 attempts to generate a new name. If several runs are made,
!     each generating a new file in this way, eventually we will be unable
!     to produce a unique name since the "random" number harvest will repeat.
      DO i=1,10
        CALL RANDOM_NUMBER( workSpace(1,1) )
        WRITE(cnum,"(a1,i4.4)") '.',INT( workSpace(1,1) * 1000 )
        tmpName = TRIM(fileName) // cnum
!       Test if this file already exists.
        INQUIRE( file=tmpName, exist=fileExist )
        IF ( .NOT. fileExist ) THEN
          fileName = tmpName
          EXIT
        ENDIF
      ENDDO
    ENDIF

!   Note that fileExist=TRUE only if dumpStatus='new' (will be FALSE is
!   dumpStatus='replace').
    IF ( fileExist ) THEN
      WRITE(*,"(70('#'),/,a)")'WARNING: dump_io: failed to generate a&
                             & unique name for dump file.'
!     If we haven't found a unique name, stop. However, if this is the end
!     of the run (or a section of the run), go for a hardwired option and
!     don't stop here.
      SELECT CASE ( dumpType )
        CASE ( 'final', 'spinFail' )
          WRITE(*,*)'But continuing since this is the end of the run....'
          fileName = TRIM(fileName) // '.FAIL'
          fileStatus = 'replace'
          INQUIRE( file=fileName, exist=fileExist )
          IF ( fileExist ) WRITE(*,*)  &
                'The existing dump with this name will be replaced.'
        CASE default
          WRITE(*,*)'ERROR: dump_io: Could not generate a unique name for &
                   &dump. Terminating run.'
          STOP
      END SELECT
      if (echo) WRITE(*,"(70('#'))")
    ENDIF

!-------------------------------------------------------------------------------
!   Check we have a setup we can deal with.
!-------------------------------------------------------------------------------
    IF ( .NOT.l_aggregate .AND. ntiles/=ntype ) THEN
      WRITE(*,*)'ERROR: dump_io: No code for this configuration.'
      WRITE(*,*)'Stopping in subroutine dump_io'
      STOP
    ENDIF

!-------------------------------------------------------------------------------
!   Get names for types, tiles etc.
!-------------------------------------------------------------------------------
    DO i=1,ntype
      IF ( i <= npft ) THEN
        typeName(i) = pftName(i)
      ELSE
        typeName(i) = nvgName(i-npft)
      ENDIF
    ENDDO

    IF ( .NOT. l_aggregate ) THEN
      tileName(:) = typeName(:)
    ELSE
      tileName(1) = 'aggregate'
    ENDIF

!-------------------------------------------------------------------------------
    IF ( echo ) WRITE(*,"(/,2a)")'Writing dump file: ',TRIM(fileName)

!-------------------------------------------------------------------------------
!   Get timestamp.
!-------------------------------------------------------------------------------
    CALL DateToBits( date,day,month,year,l_360,'newOutFileName' )
    CALL secToSMH ( time,ss,mm,hh,'newOutFileName' )
    cmonth3 = monthName3( month )  !  get character month name
    WRITE(dateTimeString,"(i4.4,a1,a3,a1,i2.2,tr1,i2.2,a1,i2.2,a1,i2.2)")  &
       year,'-',cmonth3,'-',day,hh,':',mm,':',ss

!-------------------------------------------------------------------------------
!   Get a description of dump type.
!-------------------------------------------------------------------------------
    SELECT CASE ( dumpType )
      CASE ( 'final' )
       headerDesc = 'Final dump'
      CASE  ( 'init' )
       headerDesc = 'Initial dump'
      CASE  ( 'spin' )
        WRITE(spinNum,"(i3.3)") ispin
       headerDesc = 'Dump during spin up cycle #' // spinNum
      CASE  ( 'spinFail' )
       headerDesc = 'Dump after failure to spin up'
      CASE  ( 'spunup' )
       headerDesc = 'Dump after spin up'
      CASE default
       headerDesc = 'Intermediate dump'
    END SELECT

!-------------------------------------------------------------------------------
!   Get a unit for file and then open.
!-------------------------------------------------------------------------------
    unit = fileUnit( dumpFormat )
    CALL openFile( 1,.FALSE.,unit,'write',dumpFormat,fileName,fileStatus )

    IF ( dumpFormat == formatNc ) THEN

      compressGridFile = 'noFile'  !  cxyz for now

!-------------------------------------------------------------------------------
!     Create dimensions etc for a netCDF file.
!-------------------------------------------------------------------------------
      CALL createNcFile( 0,unit,nxGrid,nyGrid,land_pts,nvar  &
                        ,regDLon,regDlat,regLon1,regLat1,.FALSE.  &
                        ,haveSCpool,havePFT,haveSnow  &
                        ,haveSoil,haveTile,haveType,haveScalar,haveNOlevs  &
                        ,haveNfarray,haveSeed   &
                        ,dumpCompress,'dump',compressGridFile  &
                        ,dateTimeString,fileName,headerDesc,land_index  &
                        ,varNameList,varNcAttList,varTypeList,varID )

    ELSEIF ( dumpFormat == formatAsc ) THEN

!     Specifying a format means we will likely drop a few significant figures....
!     but the output will be consistently
!     formatted across processors (i.e. no/less dependence on choice of computer).
!     Given that format is specified, we could write number of lines per field
!     as a header, but we won't bother.
!     All header lines should be just that - a single line each, although that is
!     not guaranteed with current formats.

!-------------------------------------------------------------------------------
!     Write some headers.
!     NB Make sure nheaderFileOut headers are written.
!-------------------------------------------------------------------------------
      WRITE(unit,"(i8,a20)") nheaderFileOut,' nheaderFile'
      WRITE(header,"(i8,i6,tr1,a,tr8,a,tr2,a)") date,time,TRIM(runID)  &
                                         ,'date, time, runID',TRIM(headerDesc)
      WRITE(unit,"(a)") TRIM(header)
      WRITE(unit,"(i8,a20)") land_pts,' land_pts'
      WRITE(unit,"(i8,a20)") ntype,' ntype'
      WRITE(unit,"(i8,a20)") npft,' npft'
      WRITE(unit,"(i8,a20)") ntiles,' ntiles'
      WRITE(unit,"(i8,a20)") sm_levels,' sm_levels'
      WRITE(unit,"(i8,a20)") dim_cs1,' dim_cs1'
      WRITE(unit,"(i8,a20)") nsmax,' nsmax'
      IF ( l_imogen ) THEN
        WRITE(unit,"(3(i8),a20)") n_olevs,nfarray,4,' n_olevs,nfarray,seed'
      ELSE
        WRITE(unit,"(a)") '0 0 0  n_olevs,nfarray,seed - no IMOGEN'
      ENDIF
      IF ( route ) THEN
        WRITE(unit,"(2(i8),a20)") nxRoute,nyRoute,' nxRoute,nyRoute'
      ELSE
        WRITE(unit,"(a)") '0 0  nxRoute,nyRoute - no routing'
      ENDIF
      WRITE(unit,"(i8,a20)") nheaderFieldOut,' nheaderField'

    ELSE

      WRITE(*,*)'ERROR: dump_io: no code to write dumpFormat=',dumpFormat

    ENDIF  !  dumpFormat

!-------------------------------------------------------------------------------
!   Write data.
!-------------------------------------------------------------------------------

!   NB For ASCII output, make sure each field is preceeded by nheaderFieldOut
!   header lines. Should really ensure that format is long enough for
!   len(varname)...
!   The header line is: name size level [optional_label]

!   Set record number. This is a required argument, although not used.
    irecOut = 1

    jvar = 0
    DO ivar=1,nvarMax

!-------------------------------------------------------------------------------
!     Write a variable if it is used by model.
!-------------------------------------------------------------------------------
      IF ( varDump(ivar) ) THEN

!       Get index
        jvar = jvar + 1

!-------------------------------------------------------------------------------
        IF ( ivar == iposCanht ) THEN

          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,npft
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                          ,"'",varSize(ivar,1),i,TRIM(typeName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,canht_ft(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(canht_ft,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCanopy ) THEN

          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                           ,"'",varSize(ivar,1),i,TRIM(tileName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,canopy(:,i),dumpFormat,'called from dump_io' )

            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(canopy,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCs ) THEN

          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,dim_cs1
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                          ,"'",varSize(ivar,1),i
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,cs(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(cs,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposFrac ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntype
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                           ,"'",varSize(ivar,1),i,TRIM(typeName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,frac(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(frac,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposGLeafAcc ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,npft
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                          ,"'",varSize(ivar,1),i,TRIM(typeName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,g_leaf_acc(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(g_leaf_acc,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposGLeafPhenAcc ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,npft
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                          ,"'",varSize(ivar,1),i,TRIM(typeName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,g_leaf_phen_acc(:,i)  &
                            ,dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(g_leaf_phen_acc,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposGs ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                               ,varSize(ivar,1),i
          ENDIF
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,gs(:),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposLAI ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,npft
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                          ,"'",varSize(ivar,1),i,TRIM(typeName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,lai(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(lai,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposNppFtAcc ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,npft
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                          ,"'",varSize(ivar,1),i,TRIM(typeName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                             ,npp_ft_acc(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(npp_ft_acc,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposNsnow ) THEN
!         This is treated as a REAL var so existing code can be used.
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                             ,"'",varSize(ivar,1),i,TRIM(tileName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,REAL(nsnow(:,i)),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(REAL(nsnow),.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRespSAcc ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                                 ,varSize(ivar,1),i
          ENDIF
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,resp_s_acc(:,1),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRespWFtAcc ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,npft
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                          ,"'",varSize(ivar,1),i,TRIM(typeName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,resp_w_ft_acc(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(resp_w_ft_acc,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRgrain ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                          ,"'",varSize(ivar,1),i,TRIM(tileName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,rgrain(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(rgrain,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRgrainL ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              DO j=1,nsmax
                WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a,tr1,i3)") "'"  &
                       ,TRIM(varName(ivar)),"'"  &
                       ,varSize(ivar,1),i,TRIM(tileName(i)),j
                CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                              ,rgrainL(:,i,j),dumpFormat,'called from dump_io' )
              ENDDO
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(rgrainL,.TRUE.)  &
                          ,dumpFormat,'called from dump_io',mapArg=ncMap )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRhoSnow ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                        ,"'",varSize(ivar,1),i,TRIM(tileName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,rho_snow_grnd(:,i)  &
                            ,dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(rho_snow_grnd,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposRouteStore ) THEN
          SELECT CASE ( routeType )
            CASE ( routeTypeTRIP )
              IF ( dumpFormat == formatAsc ) THEN
                i = 1
                WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                         ,varSize(ivar,1),i
              ENDIF
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,PACK(routeStore,.TRUE.)  &
                            ,dumpFormat,'called from dump_io' )
            CASE default
              WRITE(*,*)'ERROR: dump_io: no code for routeType=',routeType
              STOP
          END SELECT

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowtile ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                        ,"'",varSize(ivar,1),i,TRIM(tileName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,snow_tile(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(snow_tile,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowDepth ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                           ,"'",varSize(ivar,1),i,TRIM(tileName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,snowDepth(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(snowDepth,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowGrnd ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                ,"'",varSize(ivar,1),i,TRIM(tileName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,snow_grnd(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(snow_grnd,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowDs ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              DO j=1,nsmax
                WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a,tr1,i3)") "'"  &
                       ,TRIM(varName(ivar)),"'"  &
                       ,varSize(ivar,1),i,TRIM(tileName(i)),j
                CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                              ,ds(:,i,j),dumpFormat,'called from dump_io' )
              ENDDO
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(ds,.TRUE.)  &
                          ,dumpFormat,'called from dump_io',mapArg=ncMap )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowIce ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              DO j=1,nsmax
                WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a,tr1,i3)") "'"  &
                       ,TRIM(varName(ivar)),"'"  &
                       ,varSize(ivar,1),i,TRIM(tileName(i)),j
                CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                              ,sice(:,i,j),dumpFormat,'called from dump_io' )
              ENDDO
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(sice,.TRUE.)  &
                          ,dumpFormat,'called from dump_io',mapArg=ncMap )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSnowLiq ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              DO j=1,nsmax
                WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a,tr1,i3)") "'"  &
                       ,TRIM(varName(ivar)),"'"  &
                       ,varSize(ivar,1),i,TRIM(tileName(i)),j
                CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                              ,sliq(:,i,j),dumpFormat,'called from dump_io' )
              ENDDO
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(sliq,.TRUE.)  &
                          ,dumpFormat,'called from dump_io',mapArg=ncMap )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSthuf ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,sm_levels
              WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                          ,varSize(ivar,1),i
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,sthu(:,i)+sthf(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(sthu+sthf,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSthzw ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                        ,varSize(ivar,1),i
          ENDIF
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,sthzw(:),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposTsnow ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              DO j=1,nsmax
                WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a,tr1,i3)") "'"  &
                       ,TRIM(varName(ivar)),"'"  &
                       ,varSize(ivar,1),i,TRIM(tileName(i)),j
                CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                              ,tsnow(:,i,j),dumpFormat,'called from dump_io' )
              ENDDO
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(tsnow,.TRUE.)  &
                          ,dumpFormat,'called from dump_io',mapArg=ncMap )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposTsoil ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,sm_levels
              WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                              ,varSize(ivar,1),i
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,t_soil(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(t_soil,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposTstarT ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            DO i=1,ntiles
              WRITE(unit,"(a1,a,a1,2(tr1,i6),tr1,a)") "'",TRIM(varName(ivar))  &
                             ,"'",varSize(ivar,1),i,TRIM(tileName(i))
              CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                            ,tstar_tile(:,i),dumpFormat,'called from dump_io' )
            ENDDO
          ELSE
            CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                          ,PACK(tstar_tile,.TRUE.)  &
                          ,dumpFormat,'called from dump_io' )
          ENDIF

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposZw ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                          ,varSize(ivar,1),i
          ENDIF
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,zw(:),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCo2 ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                          ,varSize(ivar,1),i
          ENDIF
! Since this variable is a scalar, we must create a 'fake' array for the
! interface of writeVar to be satisfied
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,(/ co2_ppmv /),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCo2Change ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                          ,varSize(ivar,1),i
          ENDIF
! Since this variable is a scalar, we must create a 'fake' array for the
! interface of writeVar to be satisfied
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,(/ co2_change_ppmv /),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposDTempO ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                          ,varSize(ivar,1),i
          ENDIF
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,dtemp_o(:),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposFaOcean ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                          ,varSize(ivar,1),i
          ENDIF
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,fa_ocean(:),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposSeedRain ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                          ,varSize(ivar,1),i
          ENDIF
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,REAL(seed_rain(:)),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSEIF ( ivar == iposCv ) THEN
          IF ( dumpFormat == formatAsc ) THEN
            i = 1
            WRITE(unit,"(a1,a,a1,2(tr1,i6))") "'",TRIM(varName(ivar)),"'"  &
                               ,varSize(ivar,1),i
          ENDIF
          CALL writeVar( irecOut,varID(jvar),unit,varSize(ivar,:),ncStart  &
                        ,cv(:),dumpFormat,'called from dump_io' )

!-------------------------------------------------------------------------------
        ELSE
          WRITE(*,*)'ERROR: dump_io: no code for varName=',TRIM(varName(ivar))
          WRITE(*,*) TRIM(varDesc(ivar))
          STOP

       ENDIF   !  ivar
     ENDIF  !  varDump
   ENDDO  !  ivar

!###############################################################################
!###############################################################################
  ELSE

!-------------------------------------------------------------------------------
!   NOT doWrite
!   Read a dump file. Read all variables required by configuration of current run.
!-------------------------------------------------------------------------------
    fileFormat = dumpInFormat
    unit = fileUnit( fileFormat )  !  get unit
    CALL openFile( 1,.FALSE.,unit,'read',fileFormat,dumpName,'old','dump_io'  &
                  ,ncTypeJules )

!-------------------------------------------------------------------------------
!   Read headers and/or dimension information, and check they're reasonable.
!-------------------------------------------------------------------------------
    CALL check_dump_dims( unit,nheaderFieldOut,nheaderFileOut  &
            ,haveSCpool,haveLand,havePFT  &
            ,haveSnow,haveRoute,haveSoil  &
            ,haveTile,haveType,haveScalar,haveNOlevs  &
              ,haveNfarray,haveSeed,dumpName,fileFormat )

!-------------------------------------------------------------------------------
!   Read all required variables.

!   For ASCII dumps:
!     We could read all variables that are needed by the model and that are
!     found in dump, even if some of these are really to be given other values
!     (e.g. a constant). However, as coded below, we only read those for which
!     the dump value is to be used (varFlag>0).
!-------------------------------------------------------------------------------
    DO ivar=1,nvarMax

      IF ( varDump(ivar) .AND. varFlag(ivar)>0 ) THEN


        IF ( fileFormat == formatAsc ) THEN
!-------------------------------------------------------------------------------
!         Locate this variable in dump by looking for a field header that starts
!         with its name.
!-------------------------------------------------------------------------------

          CALL headerSearch( nheaderFieldOut,nheaderFileOut,unit,varName(ivar)  &
                            ,irecPrev(unit),errFlag )
          IF ( errFlag ) THEN
            WRITE(*,*)'ERROR: dump_io: error while searching dump for '  &
                      ,TRIM(varName(ivar))
            WRITE(*,*)'file: ',TRIM(dumpName)
            STOP
          ENDIF

!-------------------------------------------------------------------------------
!         Read data.
!         For ASCII, the file is currently positioned at start of required field
!         (before field headers), so we can read the field by demanding that the
!         next field is read  - this also avoids needing to know how many lines
!         per field and fields per "time".
!-------------------------------------------------------------------------------

          field = irecPrev(unit) + 1
          readT = 1             !  time level to read from file
          nfieldFile = field + varNzRead(ivar) - 1   !  number of fields in file.
!                    Setting to last level of required field is OK while readT=1.
          nheaderFile = 0       !  number of headers in file (zero, otherwise if
!                                  reading first record in file, will attempt to
!                                  read file headers.)
          nheaderT = 0          !  number of  headers at top of each time
          nlineField = 0        !  0 means will not attempt to read ASCII
!                                  line-by-line
          readNyIn = 1          !  1=read input as if it has ny=1

!         We're calling the "comp" version of readVar, but it's irrelevant here
!         as we're reading from a grid onto the same grid.
!         This also means that all variables (on any grid) can be read by the
!         same subroutine.

          CALL readVar3dComp( readT,field,varStash(ivar),.FALSE.,irecPrev(unit)  &
                             ,nfieldFile  &
                             ,nheaderFile,nheaderT,nheaderFieldOut,nlineField  &
                             ,varSize(ivar,1),readNyIn,varNzRead(ivar),.FALSE.  &
                             ,unit,varName(ivar)  &
                             ,(/(i,i=1,varSize(ivar,1))/)  &
                             ,(/(i,i=1,varSize(ivar,1))/) &
                             ,fileFormat  &
                             ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar))  &
                             ,'dump_io','dump_io',ncTypeJules )

        ELSE

!-------------------------------------------------------------------------------
!         fileFormat=formatNc
!
!-------------------------------------------------------------------------------
          CALL readVarNcDump ( unit,varName(ivar),varSize(ivar,1:varNdim(ivar))  &
                              ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar)) )

        ENDIF

!-------------------------------------------------------------------------------
!       Copy data into final variables. Set to a constant value, if required.
!-------------------------------------------------------------------------------
        CALL fill_ic_var( ivar,zrev  &
                          ,workSpace(1:varSize(ivar,1),1:varNzRead(ivar)) )

      ENDIF  !  varFlag

    ENDDO  !  ivar

!-------------------------------------------------------------------------------
  ENDIF  !  doWrite

! Close file.
  !DSM   CALL closeFile( unit,fileFormat )
  if (unit/=jinUnit) CALL closeFile( unit,fileFormat )      !DSM

  END SUBROUTINE dump_io
!###############################################################################
!###############################################################################
!###############################################################################
! subroutine headerSearch
! Module procedure in module dump_mod.
! Read an ASCII file, with known numbers of headers, looking for a particular field.
! The field is indicated by the first part of the first field header.
! Sounds grand and generic, but is rather limited.

! The present approach is to search file for a particular field which, if reading
! lots of fields from a large file (currently ASCII), can be rather slow, with
! lots of redundant i/o. Would be better if this routine was structured to take
! a list of all fields that are to be found, then move through file, reading
! field headers and returning any field (with data) that is required.

  SUBROUTINE headerSearch( nheaderField,nheaderFile,unit,varName,irecPrev,errFlag )


  IMPLICIT NONE

!-------------------------------------------------------------------------------
! Scalar arguments with intent(in)

  INTEGER, INTENT(in) ::  &
    nheaderField  &!  number of header lines before every field
   ,nheaderFile   &!  number of header lines at start of file
   ,unit           !  unit that file is open on

  CHARACTER(len=*), INTENT(in) ::  &
    varName   !  name of variable to be located
!-------------------------------------------------------------------------------
! Scalar arguments with intent(out)

  INTEGER, INTENT(out) ::  &
    irecPrev  !  counter of last field read (excl headers)

  LOGICAL, INTENT(out) ::  &
    errFlag   !  T means an error was raised in this subroutine
!-------------------------------------------------------------------------------
! Local scalar variables.

  INTEGER ::  &
    i        &!  work: loop counter
   ,ierr     &!  work: error value
   ,headerNp  !  work: size of grid as read from header

  LOGICAL :: &
    found     !  T means the required field has been found

  CHARACTER(len=LEN(varName)) ::  &
    headerName    !  the name of a variable, as read from a header
!-------------------------------------------------------------------------------

! Initialise.
  errFlag = .FALSE.
  found = .FALSE.

! Reposition file at start.
  REWIND unit
  irecPrev = 0

! Skip file headers.
  DO i=1,nheaderFile
    READ(unit,*,iostat=ierr)  !  skip a line
    IF ( ierr /= 0 ) THEN
      errFlag = .TRUE.
      RETURN
    ENDIF
  ENDDO

! Loop over fields.
! Note that errFlag is not set to TRUE when iostat/=0 - this will be
! caught/reported as "variable not found in file".

  floop: DO

!          Read first two fields from first field header (name and size).
           READ(unit,*,iostat=ierr) headerName,headerNp
           IF ( ierr /= 0 ) EXIT fLoop

           IF ( headerName == varName ) THEN
!            This is the required field.
             found = .TRUE.
             EXIT fLoop
           ENDIF

!          Skip later field headers.
           DO i=2,nheaderField
             READ (unit,*,iostat=ierr)
             IF ( ierr /= 0 ) EXIT fLoop
           ENDDO

!          Read data values for this field - just want to get past them!
           ierr = headerSearchData( headerNp,unit )
           IF ( ierr /= 0 ) EXIT fLoop

           irecPrev = irecPrev + 1

         ENDDO floop

! If have found the required field, reposition the file before all field headers.
! In fact this now just means move back by one field header line.
  IF ( found .AND. .NOT.errFlag ) BACKSPACE(unit)

  IF ( .NOT.found .OR. errFlag ) THEN
    WRITE(*,*)'ERROR: headerSearch: error while searching dump for ',TRIM(varName)
    IF ( .NOT. found ) WRITE(*,*)'Field not found in dump.'
  ENDIF

  IF ( .NOT. found ) errFlag = .TRUE.

  END SUBROUTINE headerSearch
!###############################################################################
!###############################################################################

! function headerSearchData
! Internal procedure in module dump_mod.
! Simply reads a field from a dump file for the purposes of skipping over it.
! Done in a procedure to simplify sizing.

  FUNCTION headerSearchData( np,unit ) RESULT( ierr )

  IMPLICIT NONE

! Function result.
  INTEGER :: ierr  ! Error code from read.

! Scalar arguments with intent(in).
  INTEGER, INTENT(in) :: np   !  size of data to be read
  INTEGER, INTENT(in) :: unit !  unit to read from

! Local array variables.
  REAL :: tmpval(np)  !  data read

!-------------------------------------------------------------------------------

! Read data.

  READ (unit,*,iostat=ierr) tmpval(:)

  END FUNCTION headerSearchData

!###############################################################################
!###############################################################################

  SUBROUTINE check_dump_dims( unit,nheaderFieldOut,nheaderFileOut  &
            ,haveSCpool,haveLand,havePFT  &
            ,haveSnow,haveRoute,haveSoil  &
            ,haveTile,haveType,haveScalar,haveNOlevs  &
            ,haveNfarray,haveSeed,dumpName,fileFormat )

! Read the dimensions in an existing dump (restart) file and check that they
! match those required for the current run.

  USE ancil_info, ONLY :  &
!  imported scalars with intent(in)
     dim_cs1,land_pts,nsmax,sm_levels,ntiles

  USE inout, ONLY :   &
!  imported scalar parameters
     formatAsc,formatNc

  USE netcdf, ONLY :  &
!  imported scalar parameters
     nf90_noErr  &
!  imported procedures
    ,nf90_inq_dimid,nf90_inquire_dimension

  USE nstypes, ONLY :  &
!  imported scalars with intent(in)
     npft,ntype

  USE route_mod, ONLY :  &
!  imported scalars with intent(in)
     nxRoute,nyRoute

  USE rwErr_mod, ONLY :  &
!  imported procedures
     rwErr

  USE switches, ONLY :  &
!  imported scalars with intent(in)
     route,routeOnly,l_imogen
     
  USE imogen_constants, ONLY : n_olevs,nfarray

  IMPLICIT NONE

!-------------------------------------------------------------------------------
! Scalar arguments with intent(in)
!-------------------------------------------------------------------------------
  INTEGER, INTENT(in) :: unit   !  unit (or netCDF ID) used for dump file
  INTEGER, INTENT(in) :: nheaderFieldOut   !  expected number of header lines
!                                               at top of each field
  INTEGER, INTENT(in) :: nheaderFileOut    !  expected number of header lines
!                                               at top of file
  LOGICAL, INTENT(in) :: haveSCpool,haveLand,havePFT  &
            ,haveSnow,haveRoute,haveSoil  &
            ,haveTile,haveType,haveScalar,haveNOlevs  &
            ,haveNfarray,haveSeed   !   Flags indicating what "types" of
!                                    variables are to be found in dump
  CHARACTER(len=*), INTENT(in) :: dumpName   !  name of existing dump file
  CHARACTER(len=*), INTENT(in) :: fileFormat !  format of existing dump file

!-------------------------------------------------------------------------------
! Local scalar variables.
!------------------------------------------------------------------------------
  INTEGER, PARAMETER :: ndimMax = 13  !  number of possible dimensions

!-------------------------------------------------------------------------------
! Local scalar variables.
!-------------------------------------------------------------------------------
  INTEGER :: dimID      !  netCDF ID of a dimension
  INTEGER :: dimVal     !  size of a dimension
  INTEGER :: idim       !  loop counter/work
  INTEGER :: idimSCpool !  index for soil carbon pool dimension
  INTEGER :: idimLand   !  index for (land points) index dimension
  INTEGER :: idimPft    !  index for PFT dimension
  INTEGER :: idimRoute  !  index for route (routing grid) dimension
  INTEGER :: idimSnow   !  index for snow dimension
  INTEGER :: idimSoil   !  index for soil dimension
  INTEGER :: idimTile   !  index for tile dimension
  INTEGER :: idimTime   !  index for time dimension
  INTEGER :: idimType   !  index for type dimension
  INTEGER :: idimScalar !  index for 'scalar' dimension
  INTEGER :: idimNOlevs !  index for n_olevs (see IMOGEN) dimension
  INTEGER :: idimNfarray  ! index for nfarray (see IMOGEN) dimension
  INTEGER :: idimSeed   ! index for seed dimension (see IMOGEN)
  INTEGER :: ierr       !  error code

  INTEGER :: dim_cs1In,land_ptsIn,npftIn,nsmaxIn,ntilesIn  &
         ,ntypeIn,nxRouteIn,nyRouteIn,sm_levelsIn          &
         ,n_olevsIn,nfarrayIn,seedIn  ! dimension sizes as
!                                               read from existing dump file
  INTEGER :: nheaderFieldIn  ! number of headers before each field in input dump
  INTEGER :: nheaderFileIn   !  number of headers at start of input dump

!-------------------------------------------------------------------------------
! Local array variables.
!-------------------------------------------------------------------------------
  INTEGER :: dimSize(ndimMax)           !  required size for each dimension
  LOGICAL :: useDim(ndimMax)            !  T if a dimension is required
  CHARACTER(len=6) :: dimName(ndimMax)  !  name of each dimension

!-------------------------------------------------------------------------------
! Set up lists of all possible dimensions.
! Currently only used for netCDF.
!-------------------------------------------------------------------------------
  idim = 0

  idim=idim+1; idimLand=idim; dimName(idim)='index'
  dimSize(idim) = land_pts

  idim=idim+1; idimTime=idim; dimName(idim)='tstep'
  dimSize(idim) = 1

  idim=idim+1; idimSCpool=idim; dimName(idim)='SCpool'
  dimSize(idim) = dim_cs1

  idim=idim+1; idimPFT=idim; dimName(idim)='pft'
  dimSize(idim) = npft

  idim=idim+1; idimRoute=idim; dimName(idim)='route'
  dimSize(idim) = nxRoute * nyRoute

  idim=idim+1; idimSnow=idim; dimName(idim)='snow'
  dimSize(idim) = nsmax

  idim=idim+1; idimSoil=idim; dimName(idim)='soil'
  dimSize(idim) = sm_levels

  idim=idim+1; idimTile=idim; dimName(idim)='tile'
  dimSize(idim) = ntiles

  idim=idim+1; idimType=idim; dimName(idim)='type'
  dimSize(idim) = ntype
  
  idim=idim+1; idimScalar=idim; dimName(idim)='scalar'
  dimSize(idim) = 1
  
  idim=idim+1; idimNOlevs=idim; dimName(idim)='n_olevs'
  dimSize(idim) = n_olevs
  
  idim=idim+1; idimNfarray=idim; dimName(idim)='nfarray'
  dimSize(idim) = nfarray
  
  idim=idim+1; idimSeed=idim; dimName(idim)='seed'
  dimSize(idim) = 4

! Loop over all possible dimensions to establish which are required.
  useDim(:) = .FALSE.
  DO idim=1,ndimMax
    IF ( idim==idimSCpool .AND. haveSCpool ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimLand .AND. haveLand ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimPFT .AND. havePFT ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimRoute .AND. haveRoute ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimSnow .AND. haveSnow ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimSoil .AND. haveSoil ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimTime ) THEN
!     All variables have time dimension.
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimTile .AND. haveTile ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimType .AND. haveType ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimScalar .AND. haveScalar ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimNOlevs .AND. haveNOlevs ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimNfarray .AND. haveNfarray ) THEN
      useDim(idim) = .TRUE.
    ELSEIF ( idim==idimSeed .AND. haveSeed ) THEN
      useDim(idim) = .TRUE.
    ENDIF
  ENDDO

!-------------------------------------------------------------------------------
  IF ( fileFormat == formatAsc ) THEN

    READ(unit,*) nheaderFileIn

    IF ( nheaderFileIn < 1 ) THEN
      WRITE(*,*)'ERROR: check_dump_dims: error reading dump file.'
      WRITE(*,*)'nheaderFileIn<1 - impossible!'
      WRITE(*,*)'file: ',TRIM(dumpName)
      STOP
    ENDIF

    IF ( nheaderFileIn /= nheaderFileOut ) THEN
      WRITE(*,*)'ERROR: check_dump_dims: error reading dump file.'
      WRITE(*,*)'nheaderFileIn /= nheaderFileOut'
      WRITE(*,*)'nheaderFileIn=',nheaderFileIn
      WRITE(*,*)'nheaderFileOut=',nheaderFileOut
      WRITE(*,*)'Code only exists to read a dump that is consistent with current'
      WRITE(*,*)'format of dump.'
      WRITE(*,*)'file: ',TRIM(dumpName)
      STOP
    ENDIF

!-------------------------------------------------------------------------------
!   Expect next headers to be general, land_pts, ntype, npft, ntiles and
!   nheaderField respectively.
!-------------------------------------------------------------------------------
    READ(unit,*)  !  skip a line containing time information
    READ(unit,*) land_ptsIn
    READ(unit,*) ntypeIn
    READ(unit,*) npftIn
    READ(unit,*) ntilesIn
    READ(unit,*) sm_levelsIn
    READ(unit,*) dim_cs1In
    READ(unit,*) nsmaxIn
    READ(unit,*) n_olevsIn,nfarrayIn,seedIn
    READ(unit,*) nxRouteIn,nyRouteIn
    READ(unit,*) nheaderFieldIn

!-------------------------------------------------------------------------------
!   Check that the headers indicate that dump is from a run that is "consistent"
!   with current run. This is a necessary but not sufficient condition - a basic
!   check for gross differences.
!-------------------------------------------------------------------------------
!   This test for ASCII dumps is less subtle than the netCDF test below!
    IF ( ( .NOT.routeOnly .AND. &
         ( land_ptsIn/=land_pts .OR. ntypeIn/=ntype .OR. npftIn/=npft .OR. &
           nsmaxIn/=nsmax .OR. ntilesIn/=ntiles .OR. sm_levelsIn/=sm_levels  &
          .OR. dim_cs1In/=dim_cs1 )  &
       ) .OR.  &
       ( l_imogen .AND. (n_olevsIn/=n_olevs .OR. nfarrayIn/=nfarray .OR. &
                         seedIn/=4 ) ) .OR.  &
       ( route .AND. (nxRouteIn/=nxRoute .OR. nyRouteIn/=nyRoute) ) ) THEN
      WRITE(*,*)'ERROR: check_dump_dims: error reading dump file.'
      WRITE(*,*)'file: ',TRIM(dumpName)
      WRITE(*,*)'ERROR: dump is not consistent with current run.'
      WRITE(*,*)'Values from dump and current run are:'
      IF ( .NOT. routeOnly ) THEN
        WRITE(*,*)'land_pts=',land_ptsIn,land_pts
        WRITE(*,*)'ntype=',ntypeIn,ntype
        WRITE(*,*)'npft=',npftIn,npft
        WRITE(*,*)'ntiles=',ntilesIn,ntiles
        WRITE(*,*)'sm_levels=',sm_levelsIn,sm_levels
        WRITE(*,*)'nsmax=',nsmaxIn,nsmax
      ENDIF
      IF ( l_imogen ) THEN
        WRITE(*,*)'n_olevs=',n_olevsIn,n_olevs
        WRITE(*,*)'nfarray=',nfarrayIn,nfarray
        WRITE(*,*)'seed=',seedIn,4
      ENDIF
      IF ( route ) THEN
        WRITE(*,*)'nxRoute=',nxRouteIn,nxRoute
        WRITE(*,*)'nyRoute=',nyRouteIn,nyRoute
      ENDIF
      WRITE(*,*)'In fact this is only an error if you are attempting to read'
      WRITE(*,*)'a field that has different dimensions - e.g. the fact that'
      WRITE(*,*)'the number of soil layers differs between the dump and the'
      WRITE(*,*)'current run is irrelevant if you have not requested a soil'
      WRITE(*,*)'variable from the dump - but this is not tested!'
      WRITE(*,*)'In that case, remove this STOP!'
      WRITE(*,*)'Even better, develop the code further.'
      WRITE(*,*)'Stopping in subroutine check_dump_dims'
      STOP
    ENDIF

    IF ( nheaderFieldIn /= nheaderFieldOut ) THEN
      WRITE(*,*)'ERROR: check_dump_dims: error reading dump file.'
      WRITE(*,*)'file: ',TRIM(dumpName)
      WRITE(*,*)'ERROR: nheaderFieldIn /= nheaderFieldOut'
      WRITE(*,*)'Code only exists to read a dump that is conistent with current&
               & format of dump.'
      STOP
    ENDIF

!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------
  ELSEIF ( fileFormat == formatNc ) THEN
!-------------------------------------------------------------------------------
!-------------------------------------------------------------------------------

!   There's a lot of repetition across JULES of similar code for
!   dealing with dimensions, which might well be rationalised.
!   But not right now.

    DO idim=1,ndimMax
      IF ( useDim(idim) ) THEN
!       Check this dimension exists.
        ierr = nf90_inq_dimid( unit,dimName(idim),dimID )
        IF ( ierr /= nf90_noErr )  &
          CALL rwErr( formatNc,.TRUE.,ierr=ierr,ncID=unit  &
                 ,dimName=dimName(idim)  &
                 ,errMess1='error from nf90_inq_dimid'  &
                 ,errMess2='call from check_dump_dims' )
!       Check dimension has expected size.
        ierr = nf90_inquire_dimension( unit,dimID,len=dimVal )
        IF ( ierr /= nf90_noErr )  &
          CALL rwErr( formatNc,.TRUE.,ierr=ierr,ncID=unit  &
                 ,dimName=dimName(idim)  &
                 ,errMess1='error from nf90_inquire_dimension'  &
                 ,errMess2='call from check_dump_dims' )
        IF ( dimVal /= dimSize(idim) ) THEN
          WRITE(*,*)'ERROR: check_dump_dims: dimension not expected size.'
          WRITE(*,*)'name=',TRIM(dimName(idim)),' size=',dimVal
          WRITE(*,*)'Expected size=',dimSize(idim)
          WRITE(*,*)'In fact this is only an error if you are attempting to read'
          WRITE(*,*)'a field that has different dimensions - e.g. the fact that'
          WRITE(*,*)'the number of soil layers differs between the dump and the'
          WRITE(*,*)'current run is irrelevant if you have not requested a soil'
          WRITE(*,*)'variable from the dump - but this is not tested!'
          WRITE(*,*)'In that case, remove this STOP!'
          WRITE(*,*)'Even better, develop the code further.'
          WRITE(*,*)'Stopping in subroutine check_dump_dims'
          STOP
        ENDIF

      ENDIF  !  useDim
    ENDDO  !  idim

  ELSE  !  fileFormat

    WRITE(*,*)'ERROR: check_nc_dims: no code for fileFormat=',TRIM(fileFormat)
    STOP

  ENDIF  !  fileFormat

  END SUBROUTINE check_dump_dims

!###############################################################################
!###############################################################################
!     ******************************************************************

SUBROUTINE qwtk_from_BRMS(qw,w,dryhcap,tempk,fracliq)
  IMPLICIT NONE
  REAL :: qw,w,dryhcap,tempk,fracliq
  REAL, PARAMETER :: r4186=1./4186.,r2093=1./2093.,r334000=1./334000.
  REAL :: qwliq0
  !     Inputs:
  !        qw       internal energy [J/m^2] or [J/m^3]
  !        w        mass [kg/m^2] or [kg/m^3]
  !        dryhcap  heat capacity of nonwater part [J/(m^2 K)] or [J/(m^3 K)]
  !     Outputs:
  !        tempk    temperature [K]
  !        fracliq  liquid fraction [dimensionless]
  !     Local Constants:
  !        4186     specific heat of liquid [J/(kg K)]
  !        2093     specific heat of ice [J/(kg K)]
  !        334000   latent heat of fusion [J/kg]
  !        273.15   conversion from temp [C] to temp [K]

  qwliq0 = w * 334000.
  IF (qw .LE. 0.) THEN
     fracliq = 0.
     tempk = qw / (2093. * w + dryhcap) + 273.15
  ELSEIF (qw .GE. qwliq0) THEN
     fracliq = 1.
     tempk = (qw - qwliq0) / (4186. * w + dryhcap) + 273.15
  ELSE
     fracliq = qw / qwliq0
     tempk = 273.15
  ENDIF
  RETURN
END SUBROUTINE qwtk_from_BRMS

  END MODULE initial_mod

!###############################################################################
!###############################################################################
