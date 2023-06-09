#Makefile objects_model.mk

# Define main source.

MAIN = $(MODEL)/rammain.f90
MAINOBJ = rammain.o


# Define objects.

OBJ_MODEL = \
	mem_stilt.o \
	node_mod.o    \
	ModVarfFile.o \
	ModBuffering.o \
	ModMessageData.o \
	ModMessagePassing.o \
	ModMessageSet.o \
	ModGridDims.o \
	ModGrid.o \
	ModGridTree.o \
	ModNeighbourNodes.o \
	ModFieldSectionList.o \
	ModDomainDecomp.o \
	ModDateUtils.o \
	ReadBcst.o \
	mpi_io_engine-5d.o \
	hdf5_parallel_engine.o \
	Phys_const.o \
	alloc.o   \
	an_header.o \
	aobj.o \
	asgen.o \
	asti.o \
	asti2.o \
	astp.o \
	avarf.o \
	ccatt_start.o \
	machine_arq.o \
	teb_spm_start.o \
	mem_grid_dim_defs.o \
	cond_read.o \
	cond_update.o \
	conv_coms.o \
	coriolis.o \
	cu_read.o \
	cup_dn.o \
	cup_env.o \
	cup_env_catt.o \
	cup_grell_catt_deep.o \
	cup_grell_catt_shallow.o \
	cup_output_vars.o \
	cup_up.o \
	diffsclr.o \
	diffuse.o \
	file_inv.o \
	first_rams.o \
	geodat.o \
	grid_dims.o \
	grid_struct.o \
	inithis.o  \
	io_params.o \
	isan_coms.o \
	isan_io.o \
	ke_coms.o \
	landuse_input.o \
	leaf3.o \
	leaf3_hyd.o \
	leaf3_init.o \
	leaf_coms.o \
	leaf3_teb.o \
	mem_aerad.o \
	mem_all.o \
	mem_basic.o \
	carma_driver.o \
	mem_carma.o \
	mem_cuparm.o \
	mem_cutrans.o \
	mem_globaer.o \
	mem_globrad.o \
	mem_grell.o \
	mem_grell_param2.o \
	mem_grid.o \
	mem_leaf.o \
	mem_micro.o \
	mem_mksfc.o \
	mem_nestb.o \
	mem_oda.o \
	mem_opt_scratch.o \
	mem_precision.o \
	mem_radiate.o \
	mem_scalar.o \
	mem_scratch.o \
	mem_scratch1_brams.o \
	mem_scratch1_grell.o \
	mem_scratch2_grell.o \
	mem_scratch2_grell_sh.o \
	mem_scratch3_grell.o \
	mem_scratch3_grell_sh.o \
	mem_shcu.o \
	mem_tconv.o \
	mem_tend.o \
	mem_turb.o \
	mem_turb_scalar.o \
	mem_varinit.o \
	mem_micro_optij.o \
	mic_coll.o \
	mic_driv.o \
	mic_driv_new.o \
	mic_gamma.o \
	mic_init.o \
	mic_misc.o \
	mic_nuc.o \
	mic_tabs.o \
	mic_vap.o \
	micphys.o \
	mksfc_driver.o \
	mksfc_ndvi.o \
	mksfc_sfc.o \
	mksfc_sst.o \
	mksfc_top.o \
	ModTimeStamp.o \
	modsched.o \
	local_proc.o \
	mpass_dtl.o \
	mpass_feed.o \
	mpass_full.o      \
	mpass_nest.o \
	ndvi_read.o \
	nest_drivers.o \
	nest_feed.o \
	nest_filldens.o \
	nest_geosst.o \
	nest_intrp.o \
	nud_analysis.o \
	nud_read.o \
	nud_update.o \
	obs_input.o \
	oda_krig.o \
	oda_nudge.o \
	oda_proc_obs.o \
	oda_read.o \
	oda_sta_count.o \
	oda_sta_input.o \
	opspec.o \
	domain_decomp.o \
	para_init.o \
	Phys_const.o \
	raco.o \
	raco_adap.o \
	rad_carma.o \
	rad_driv.o \
	rtm_driver.o \
	radvc.o \
	radvc_rk.o \
	radvc_adap.o \
	radvc_mnt.o \
	mod_GhostBlock.o \
	mod_GhostBlockPartition.o \
	mod_advect_kit.o \
	radvc_new.o \
	rams_grid.o \
	gridset.o \
	adap_init.o \
	ModOneProc.o \
	rams_mem_alloc.o   \
	rams_read_header.o \
	ranlavg.o \
	rbnd.o \
	rbnd_adap.o \
	rcio.o \
	rconstants.o \
	rconv.o \
	rconv_grell_catt.o \
	chem_conv_transp.o \
	ModNamelistFile.o  \
	ModParallelEnvironment.o  \
	read_ralph.o \
	recycle.o  \
	ref_sounding.o \
	refstate.o \
	rgrad.o \
	rhhi.o  \
	rinit.o  \
	rio.o \
	rnest_par.o \
	rnode.o \
	rshcupar.o \
	rthrm.o \
	rtimh.o \
	rtimh_rk.o \
	rtimh_abm.o \
	rtimi.o \
	ruser.o \
	shcu_vars_const.o \
	memSoilMoisture.o \
	soilMoisture.o \
	sst_read.o \
	turb_diff.o \
	turb_diff_adap.o \
	turb_k.o \
	turb_k_adap.o \
	turb_ke.o \
	upcase.o \
	urban_canopy.o \
	v_interps.o \
	extra.o \
	aer1_list.o \
	mem_aer1.o \
	chem1_list.o \
	chem1aq_list.o \
	mem_chem1aq.o \
	mem_chem1.o \
	mem_chemic.o \
	mem_plume_chem1.o \
	mem_volc_chem1.o \
	chem_sources.o \
	chem_plumerise_scalar.o \
	ChemSourcesDriver.o \
	chem_dry_dep.o \
	ChemDryDepDriver.o \
	mem_tuv.o \
	tuvParameter.o \
	ModTuv2.7.o \
	ModTuvDriver2.7.o \
	var_tables.o \
	varf_update.o \
	vtab_fill.o \
	mksfc_fuso.o \
	mem_teb.o \
	mem_teb_common.o \
	mem_teb_vars_const.o \
	mem_gaspart.o \
	mem_emiss.o \
	urban.o \
	gaspart.o \
	ozone.o \
	mod_ozone.o \
	chem_isan_coms.o \
	chem_aobj.o \
	chem_asgen.o \
	chem_asti2.o \
	chem_asti.o \
	chem_astp.o \
	chem_avarf.o \
	chem_file_inv.o \
	chem_first_rams.o \
	chem_isan_io.o \
	chem_refstate.o \
	chem_v_interps.o \
	carma_fastjx.o \
	chem_fastjx57.o \
	chem_fastjx_data.o \
	chem_fastjx_driv.o \
	chem_spack_utils.o \
	mem_spack.o \
	chem_uv_att.o\
	chem_spack_solve_sparse.o \
	chem_spack_lu.o \
	chem_spack_jacdchemdc.o \
	chem_spack_dratedc.o \
	chem_spack_kinetic.o \
	chem_spack_fexprod.o \
	chem_spack_fexloss.o \
	chem_spack_rates.o \
	chem_spack_fexchem.o \
	chem_spack_ros.o \
	chem_spack_ros_dyndt.o \
	chem_spack_rodas3_dyndt.o\
	chem_spack_qssa.o \
	chem_trans_gasaq.o \
	chem_trans_liq.o \
	chem_orage.o \
	chemistry.o \
	ModPostProcess.o \
	ModPostOneField.o \
	ModPostOneFieldUtils.o \
	ModPostUtils.o \
	ModPostGrid.o \
	ModBramsGrid.o \
	ModOutputUtils.o \
	kbcon_ecmwf.o \
	module_cu_g3.o \
	module_cu_gf.o \
	module_cu_gf_v5.1.o \
	module_cu_gd_fim.o \
	cup_grell3.o \
	rexev.o \
	rstilt.o \
	turb_constants.o \
	tkenn.o \
	digitalFilter.o \
	GridMod.o \
	MapMod.o \
	ProcessorMod.o \
	BoundaryMod.o \
	errorMod.o \
	advSendMod.o \
	InitAdvect.o \
	seasalt.o  \
	meteogram.o \
	meteogramType.o \
	mcica_random_numbers.o \
	mcica_subcol_gen_sw.o \
	parkind.o \
	parrrsw.o \
	rrsw_aer.o \
	rrsw_cld.o \
	rrsw_con.o \
	rrsw_kg16.o \
	rrsw_kg17.o \
	rrsw_kg18.o \
	rrsw_kg19.o \
	rrsw_kg20.o \
	rrsw_kg21.o \
	rrsw_kg22.o \
	rrsw_kg23.o \
	rrsw_kg24.o \
	rrsw_kg25.o \
	rrsw_kg26.o \
	rrsw_kg27.o \
	rrsw_kg28.o \
	rrsw_kg29.o \
	rrsw_ref.o \
	rrsw_tbl.o \
	rrsw_vsn.o \
	rrsw_wvn.o \
	rrtmg_sw_cldprmc.o \
	rrtmg_sw_cldprop.o \
	rrtmg_sw_init.o \
	rrtmg_sw_k_g.o \
	rrtmg_sw_rad.o \
	rrtmg_sw_reftra.o \
	rrtmg_sw_setcoef.o \
	rrtmg_sw_spcvmc.o \
	rrtmg_sw_spcvrt.o \
	rrtmg_sw_taumol.o \
	rrtmg_sw_vrtqdr.o \
	mcica_subcol_gen_lw.o \
	parrrtm.o \
	rrlw_cld.o \
	rrlw_con.o \
	rrlw_kg01.o \
	rrlw_kg02.o \
	rrlw_kg03.o \
	rrlw_kg04.o \
	rrlw_kg05.o \
	rrlw_kg06.o \
	rrlw_kg07.o \
	rrlw_kg08.o \
	rrlw_kg09.o \
	rrlw_kg10.o \
	rrlw_kg11.o \
	rrlw_kg12.o \
	rrlw_kg13.o \
	rrlw_kg14.o \
	rrlw_kg15.o \
	rrlw_kg16.o \
	rrlw_ncpar.o \
	rrlw_ref.o \
	rrlw_tbl.o \
	rrlw_vsn.o \
	rrlw_wvn.o \
	rrtmg_lw_cldprmc.o \
	rrtmg_lw_cldprop.o \
	rrtmg_lw_init.o \
	rrtmg_lw_k_g.o \
	rrtmg_lw_rad.o \
	rrtmg_lw_rtrn.o \
	rrtmg_lw_rtrnmc.o \
	rrtmg_lw_rtrnmr.o \
	rrtmg_lw_setcoef.o \
	rrtmg_lw_taumol.o \
	mem_rrtm.o \
	isrpia.o \
	quad.o \
	actv.o \
	coag.o \
	depv.o \
	diam.o \
	dicrete.o \
	init.o \
	solut.o \
	issoropia.o \
	isofwd.o \
	isorev.o \
	matrix.o \
	npf.o \
	quad.o \
	setup.o \
	subs.o \
	thermo_isorr.o \
	isrpia.o \
	MatrixDriver.o \
	ModParticle.o \
	memMatrix.o\
	module_rams_microphysics_2M.o\
	mic_thompson_driver.o\
	module_mp_thompson.o\
	module_mp_radar.o

	JULES_OBJ_SFCLYR = sfclyr_jules.o 
	JULES_OBJ_MEM    = mem_jules.o
	JULES_OBJ_FLX   = fluxes.o
ifeq ($(ENABLEJULES),false)
	JULES_OBJ_SFCLYR =  
	JULES_OBJ_MEM    = 
	JULES_OBJ_FLX   = 
endif

MOD_MODEL = \
	advectdata.mod \
	advect_kit.mod \
	advmessagemod.mod \
	aer1_list.mod \
	aerosol_component_pcf.mod \
	aerosol_parametrization_pcf.mod \
	angular_integration_pcf.mod \
	boundarymod.mod \
	carma_fastjx.mod \
	ccatt_start.mod \
	chem1aq_list.mod \
	chem1_list.mod \
	chemdrydepdriver.mod \
	chem_isan_coms.mod \
	chemsourcesdriver.mod \
	chem_sources.mod \
	cloud_component_pcf.mod \
	cloud_parametrization_pcf.mod \
	cloud_region_pcf.mod \
	cloud_representation_pcf.mod \
	cloud_scheme_pcf.mod \
	cloud_type_pcf.mod \
	continuum_pcf.mod \
	conv_coms.mod \
	cuparm_grell3.mod \
	cup_output_vars.mod \
	def_spectrum.mod \
	def_ss_prop.mod \
	def_std_io_icf.mod \
	def_um_nml.mod \
	diff_elsasser_ccf.mod \
	diff_keqv_ucf.mod \
	digitalfilter.mod \
	dimensions_field_ucf.mod \
	dimensions_fixed_pcf.mod \
	dimensions_spec_ucf.mod \
	domain_decomp.mod \
	dtset.mod \
	errormod.mod \
	error_pcf.mod \
	esrad.mod \
	extras.mod \
	fastjx57.mod \
	fastjx.mod \
	gas_list_pcf.mod \
	gas_overlap_pcf.mod \
	gaussian_weight_pcf.mod \
	grid_dims.mod \
	gridmod.mod \
	grid_struct.mod \
	hdf5_parallel_engine.mod \
	ice_cloud_parametrization_pcf.mod \
	io_params.mod \
	isan_coms.mod \
	jx_data.mod \
	kbcon_ecmwf.mod \
	ke_coms.mod \
	k_scale_pcf.mod \
	leaf_coms.mod \
	lu.mod \
	machine_arq.mod \
	mapmod.mod \
	math_cnst_ccf.mod \
	mem_aer1.mod \
	mem_aerad.mod \
	mem_all.mod \
	mem_basic.mod \
	mem_carma.mod \
	mem_chem1aq.mod \
	mem_chem1.mod \
	mem_chemic.mod \
	mem_cuparm.mod \
	mem_cutrans.mod \
	mem_emiss.mod \
	mem_gaspart.mod \
	mem_globaer.mod \
	mem_globrad.mod \
	mem_grell.mod \
	mem_grell_param.mod \
	mem_grid_dim_defs.mod \
	mem_grid.mod \
	mem_leaf.mod \
	mem_micro.mod \
	mem_micro_opt.mod \
	mem_mksfc.mod \
	mem_nestb.mod \
	mem_oda.mod \
	mem_opt.mod \
	mem_plume_chem1.mod \
	mem_precision.mod \
	mem_radiate.mod \
	mem_scalar.mod \
	mem_scratch1_grell.mod \
	mem_scratch1.mod \
	mem_scratch2_grell.mod \
	mem_scratch2_grell_sh.mod \
	mem_scratch3_grell.mod \
	mem_scratch3_grell_sh.mod \
	mem_scratch.mod \
	mem_shcu.mod \
	memsoilmoisture.mod \
	mem_spack.mod \
	mem_stilt.mod \
	mem_tconv.mod \
	mem_teb_common.mod \
	mem_teb.mod \
	mem_tend.mod \
	mem_turb.mod \
	mem_turb_scalar.mod \
	mem_tuv.mod \
	mem_varinit.mod \
	mem_volc_chem1.mod \
	meteogram.mod \
	meteogramtype.mod \
	micphys.mod \
	modacoust_adap.mod \
	modacoust.mod \
	modbramsgrid.mod \
	modbuffering.mod \
	mod_chem_orage.mod \
	mod_chem_plumerise_scalar.mod \
	mod_chem_spack_dratedc.mod \
	mod_chem_spack_fexchem.mod \
	mod_chem_spack_fexloss.mod \
	mod_chem_spack_fexprod.mod \
	mod_chem_spack_jacdchemdc.mod \
	mod_chem_spack_kinetic.mod \
	mod_chem_spack_qssa.mod \
	mod_chem_spack_rates.mod \
	mod_chem_spack_rodas3_dyndt.mod \
	mod_chem_spack_ros_dyndt.mod \
	mod_chem_spack_ros.mod \
	mod_chem_trans_gasaq.mod \
	mod_chem_trans_liq.mod \
	moddomaindecomp.mod \
	modfieldsectionlist.mod \
	mod_ghostblock.mod \
	mod_ghostblockpartition.mod \
	modgriddims.mod \
	modgrid.mod \
	modgridtree.mod \
	modmessagedata.mod \
	modmessagepassing.mod \
	modmessageset.mod \
	modnamelistfile.mod \
	modneighbournodes.mod \
	modoneproc.mod \
	modoutpututils.mod \
	modparallelenvironment.mod \
	modpostgrid.mod \
	modpostonefield.mod \
	modpostonefieldutils.mod \
	modpostprocess.mod \
	modpostutils.mod \
	modtimestamp.mod \
	modtimestep.mod \
	modtuvdriver.mod \
	modtuv.mod \
	module_chemistry_driver.mod \
	module_cu_g3.mod \
	module_cu_gd_fim.mod \
	module_cu_gf.mod \
	module_cu_gf_v5.1.mod \
	module_dry_dep.mod \
	modvarffile.mod \
	monotonic_adv.mod \
	mpi_io_engine.mod \
	node_mod.mod \
	obs_input.mod \
	ozone_const.mod \
	phase_pcf.mod \
	phys_const.mod \
	physical_constants_0_ccf.mod \
	physical_constants_1_ccf.mod \
	processormod.mod \
	rad_carma.mod \
	radiation.mod \
        rtm_driver.mod \
	rconstants.mod \
	readbcst.mod \
	realtype_rd.mod \
	ref_sounding.mod \
	rrad3.mod \
	scale_fnc_pcf.mod \
	scatter_method_pcf.mod \
	seasalt.mod \
	shcu_vars_const.mod \
	soilmoisture.mod \
	solver_pcf.mod \
	solve_sparse.mod \
	source_coeff_pointer_pcf.mod \
	spack_utils.mod \
	spectral_region_pcf.mod \
	sph_algorithm_pcf.mod \
	sph_mode_pcf.mod \
	sph_qr_iter_acf.mod \
	sph_truncation_pcf.mod \
	surface_spec_pcf.mod \
	teb_spm_start.mod \
	teb_vars_const.mod \
	turb_constants.mod \
	tuvparameter.mod \
	two_stream_scheme_pcf.mod \
	ukmoadapt.mod \
	uv_atten.mod \
	var_tables.mod \
	mem_jules.mod \
	parkind.mod \
	mem_rrtm.mod \
	mersennetwister.mod \
	mcica_random_numbers.mod \
	parrrsw.mod \
	rrsw_con.mod \
	rrsw_vsn.mod \
	rrsw_wvn.mod \
	mcica_subcol_gen_sw.mod \
	rrsw_aer.mod \
	rrsw_cld.mod \
	rrtmg_sw_cldprmc.mod \
	rrsw_ref.mod \
	rrtmg_sw_setcoef.mod \
	rrsw_tbl.mod \
	rrtmg_sw_reftra.mod \
	rrsw_kg16.mod \
	rrsw_kg17.mod \
	rrsw_kg18.mod \
	rrsw_kg19.mod \
	rrsw_kg20.mod \
	rrsw_kg21.mod \
	rrsw_kg22.mod \
	rrsw_kg23.mod \
	rrsw_kg24.mod \
	rrsw_kg25.mod \
	rrsw_kg26.mod \
	rrsw_kg27.mod \
	rrsw_kg28.mod \
	rrsw_kg29.mod \
	rrtmg_sw_taumol.mod \
	rrtmg_sw_vrtqdr.mod \
	rrtmg_sw_spcvmc.mod \
	rrtmg_sw_rad.mod \
	parrrtm.mod \
	rrlw_con.mod \
	rrlw_vsn.mod \
	rrlw_wvn.mod \
	mcica_subcol_gen_lw.mod \
	rrlw_cld.mod \
	rrtmg_lw_cldprmc.mod \
	rrlw_tbl.mod \
	rrtmg_lw_rtrnmc.mod \
	rrlw_ref.mod \
	rrtmg_lw_setcoef.mod \
	rrlw_kg01.mod \
	rrlw_kg02.mod \
	rrlw_kg03.mod \
	rrlw_kg04.mod \
	rrlw_kg05.mod \
	rrlw_kg06.mod \
	rrlw_kg07.mod \
	rrlw_kg08.mod \
	rrlw_kg09.mod \
	rrlw_kg10.mod \
	rrlw_kg11.mod \
	rrlw_kg12.mod \
	rrlw_kg13.mod \
	rrlw_kg14.mod \
	rrlw_kg15.mod \
	rrlw_kg16.mod \
	rrlw_ncpar.mod \
	rrtmg_sw_cldprop.mod \
	rrtmg_lw_cldprop.mod \
	rrtmg_sw_init.mod \
	rrtmg_lw_init.mod \
	rrtmg_sw_spcvrt.mod \
	rrtmg_lw_rtrn.mod \
	rrtmg_lw_rtrnmr.mod \
	rrtmg_lw_taumol.mod \
	rrtmg_lw_rad.mod   \
	rams_microphysics_2M.mod \
	carma_driver.mod
