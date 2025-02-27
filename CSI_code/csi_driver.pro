;------------------------------------------------------------------------
;Christina Viviano (11/2022)
;
;This procedure is the driver for a GUI interface that allows you to
;open a TER3/TRR3 file along side it's browse product image and use both
;to "interrogate" the spectra within the scene in an efficient way.
;L-click to define the numerator, R-click to define the denominator.
;The resultant ratioed I/F is plotted out alongside the CRISM Type
;Spectra for comparison.  User has control over ROI size and whether
;or not to force ROIs to align (same column).  Spectra can be plotted
;with multiple wavelength ranges and exported into an ENVI plot window
;(which will mask the bad bands, unlike the ENVI spectral ratioing tool).
;Lastly, the 1-micron offset correction is optionally applied to spectra.
;
;------------------------------------------------------------------------;
;
;
; pro csi_driver
; 
; FLAGS:
;
; OUTPUT FILE:
;
; USER INPUTS:
; TER3 joined file
; TRR3 CAT corrected files (S and/or L)
; 
; REQUIREMENTS:
; 
; Be sure the following TRDR files are in the same folder:
; IF_TER3.IMG and .HDR
; SR_TER3.IMG and .HDR
; BR_XXX.IMG and .HDR
; 
; Required programs to be compiled:
; selectband.pro
; myquadfunc.pro
; abscenterwv.pro
; correct_offset.pro
; crism_spectral_ratio.pro
; MPFITFUN.pro (and daughter procedures)
; 
; Need above list compiled for widget handling and function fitting.
;
; HISTORY:
; 2014 May 16   C. Viviano: Version 1
; 2022 Dec 20   C. Viviano: Removed file-reading dependencies on ENVI
;               
;               
;               
;crism_file_detector, 0=S, 1=L, 2=J, 3=S+L
;cdet
;spectral_sampling, 0=multispectral, 1=hyperspectral, 2=HSP sampling
;cspsamp
;crism_mode, 1=targeted obs, 0=mapping
;clength
;wv_units, 1=nm, 0=microns
;cmicron
;cESC, 1=ESC type file
;file_type, 'TER' or 'TRR'
;------------------------------------------------------------------------

;csi_driver, directory='/project/crism/users/viviace1/crismidl/CSI_program/CSI_practice_files/'

pro csi_driver, infoholderset=infoholderset, directory=directory, skip=skip
;envi, /restore_base_save_files
;envi_batch_init, /no_status_window 
 COMMON CSIcommon, csi_image, csi_param, csi_browse, csi_ddr ;param_struct, browse_struct, ddr_struct, image_struct
 
 
 if keyword_set(skip) then begin
  goto, JUMP1
 endif
;*************************************************
;reset common variables
cimage=0
paramf=0
rparamf=0
browsef=0
browsen=0
ddr=0
avgtyp=0 
;*************************************************  

if keyword_set(infoholderset) then begin
infoholder=infoholderset
endif else begin
infoholder='0'
endelse


;cdr_root = '/project/crism/users/viviace1/crismidl/CSI_program/CDRs/'  ;maybe don't need?


;1) NAVIGATE/FIND IMAGE, DDR, and PARAMETER FILES:
;*************************************************
  
  approved_csi_file_types=['S only (TRR3, CAT corrected)','L only (TRR3, CAT corrected)','J (TER3)','S and L (TRR3s, CAT corrected)']
  
  file_type_selected=csi_file_type(typelist=approved_csi_file_types)
  if file_type_selected.accept eq 0 then return
  
  crism_file_detector=file_type_selected.options
  image_fname_struct=csi_pick_file(crism_file_detector, directory=directory)   ;image 
  print, 'found image file'
  ddr_fname_struct=csi_find_ddr(image_fname_struct) ;ddr
  print, 'found ddr file'
  param_fname_struct=csi_find_param(image_fname_struct) ;summary parameter
  print, 'found parameter file'

;2) READ IMAGE, DDR, PARAMETER, and BROWSE FILES:
;*************************************************

  image_ancillary_struct=csi_image_get_ancillary(image_fname_struct)
  print, 'ancillary info extracted'
  image_struct=csi_read_crism_file(image_fname_struct, image_ancillary_struct)
  print, 'image file read'
  ddr_struct=csi_read_ddr_file(ddr_fname_struct, image_ancillary_struct)
  print, 'ddr file read'
  param_struct=csi_read_crism_param_file(param_fname_struct, image_ancillary_struct)
  print, 'parameter file read'
  browse_struct=csi_create_crism_browse_file(param_struct, image_ancillary_struct)
  print, 'browse file created'

;3) SET MULTIPLICATION FACTOR FOR IMAGE SIZE BASED ON SCREEN INFORMATION:
;*************************************************  
  
  screensize=get_screen_size()  
  multsz=(((screensize[1])/2.)-150)/(image_struct.arraysize)[2]
  case image_struct.crism_class_type of
    'FRT': multsz=multsz
    'HRL': multsz=multsz
    'HRS': multsz=multsz
    'FRS': multsz=multsz*0.5
    'ATU': multsz=multsz*0.4
    'ATO': multsz=multsz*0.4
    'HSP': multsz=multsz*3.
    'MSP': multsz=multsz*3.
    'MSW': multsz=multsz*3.
    'MSV': multsz=multsz*3.
    'HSV': multsz=multsz*3.
    else: begin
      print, 'CRISM file naming convention is incorrect or file type not valid.  See CSI notes on file naming requirements.'
      return
    end
  endcase


;4) RE-PROJECT S DATA TO L DATA USING DDR -- ACCURATELY 'JOIN' SPECTRA ACROSS THE DETECTOR BOUNDARY -- NECESSARY TO DO B/C OF DIFFERING DETECTOR OPTICS:
;************************************************* 

if image_struct.file_type eq 3 then begin
    SLmapping_fname=image_ancillary_struct.crism_file_path+strtrim(image_ancillary_struct.crism_fname_abbrev,2)+'_SLstructure.sav'
        
    if file_test(SLmapping_fname) eq 1 then begin
      restore, SLmapping_fname
    endif else begin
      SLddr_mapping_struct = csi_ddr_mapping(ddr_struct.ddrL, ddr_struct.ddrS, /simult) 
      save, SLddr_mapping_struct, filename = image_ancillary_struct.crism_file_path+strtrim(image_ancillary_struct.crism_fname_abbrev,2)+'_SLstructure.sav'
    endelse

  mapped_imageS = csi_apply_spatial_transform(SLddr_mapping_struct, image_struct.imageS, n_pxls = 1)
  print, 'spatial transform applied to image'
  mapped_paramS = csi_apply_spatial_transform(SLddr_mapping_struct, param_struct.paramS, n_pxls = 1)
  print, 'spatial transform applied to parameters'
  mapped_rparamS = csi_apply_spatial_transform(SLddr_mapping_struct, param_struct.rparamS, n_pxls = 1)
  print, 'spatial transform applied to refined parameters'
;  mapped_browseS = browse_struct.browseS
;  mapped_rbrowseS = browse_struct.rbrowseS
;  for i=0, (size(browse_struct.browseS))[4]-1 do begin
;    mapped_browseS[*,*,*,i] = csi_apply_spatial_transform(SLddr_mapping_struct, browse_struct.browseS[*,*,*,i], n_pxls = 1)
;    mapped_rbrowseShold[*,*,*,i] = csi_apply_spatial_transform(SLddr_mapping_struct, browse_struct.rbrowseS[*,*,*,i], n_pxls = 1)
;  endfor
  
  ;redo browse product for reprojected S data
  browse_struct=csi_create_crism_browse_file(param_struct, image_ancillary_struct)
  print, 'spatial transform applied to browse products'
  
  ;stack image and parameter S and L data now that transform has been applied
  image_struct.imageSL=[[[mapped_imageS]],[[image_struct.imageL]]]
  param_struct=create_struct(param_struct, 'paramSL', [[[mapped_paramS]],[[param_struct.paramL]]], 'rparamSL', [[[mapped_rparamS]],[[param_struct.rparamL]]])
print, 'spatial join'
endif

    
;5) CONSOLIDATE STRUCTURES FOR EASE OF HANDLING
;*************************************************

if crism_file_detector eq 0 then begin
image_struct_selected=create_struct('file_type', image_struct.file_type,$; 'image',  image_struct.imageS, $
  'wvs', image_struct.wvsS, 'bbl', image_struct.bblS, 'units', image_struct.unitsS, 'crism_mode', image_struct.crism_mode, $
  'spectral_sampling', image_struct.spectral_sampling, 'crism_fname_abbrev', image_struct.crism_fname_abbrev, $
  'crism_class_type', image_struct.crism_class_type, 'arraysize', image_struct.arraysize, $
  'default_bands', image_struct.default_bandsS)
csi_image=image_struct.imageS

param_struct_selected=create_struct('file_type', param_struct.file_type, $; 'param',; param_struct.paramS, 'rparam', param_struct.rparamS$
    'band_names', param_struct.band_namesS, 'crism_mode', param_struct.crism_mode, $
    'spectral_sampling', param_struct.spectral_sampling, 'crism_fname_abbrev', param_struct.crism_fname_abbrev, $
    'crism_class_type', param_struct.crism_class_type, 'fname_param', param_struct.fname_paramS, 'fname_Rparam', param_struct.fname_RparamS, $
    'default_bands', param_struct.default_bandsS)
csi_param=create_struct('param', param_struct.paramS,'rparam', param_struct.rparamS)

browse_struct_selected=create_struct('file_type', browse_struct.file_type, $;'browse', browse_struct.browseS, 'rbrowse', browse_struct.rbrowseS$
    'band_names', browse_struct.band_namesS, 'browse_names', browse_struct.browse_namesS, $
    'crism_mode', image_ancillary_struct.crism_mode, $
    'spectral_sampling', image_ancillary_struct.spectral_sampling, $
    'crism_fname_abbrev', image_ancillary_struct.crism_fname_abbrev, $
    'crism_class_type', image_ancillary_struct.crism_class_type)
csi_browse=create_struct('browse', browse_struct.browseS, 'rbrowse', browse_struct.rbrowseS)

ddr_struct_selected=create_struct('file_type', ddr_struct.file_type, $;'ddr', ddr_struct.ddrS, $
    'ddr_bands', ddr_struct.ddr_bands, 'solar_longitude', ddr_struct.solar_longitude, $
    'crism_mode', ddr_struct.crism_mode, $
    'spectral_sampling', ddr_struct.spectral_sampling, $
    'crism_fname_abbrev', ddr_struct.crism_fname_abbrev, $
    'crism_class_type', ddr_struct.crism_class_type)
csi_ddr=ddr_struct.ddrS

endif

if crism_file_detector eq 1 then begin
  image_struct_selected=create_struct('file_type', image_struct.file_type, $ ;'image', image_struct.imageL, $
    'wvs', image_struct.wvsL, 'bbl', image_struct.bblL, 'units', image_struct.unitsL, 'crism_mode', image_struct.crism_mode, $
    'spectral_sampling', image_struct.spectral_sampling, 'crism_fname_abbrev', image_struct.crism_fname_abbrev, $
    'crism_class_type', image_struct.crism_class_type, 'arraysize', image_struct.arraysize, $
    'default_bands', image_struct.default_bandsL)
csi_image=image_struct.imageL

  param_struct_selected=create_struct('file_type', param_struct.file_type, $;'param', param_struct.paramL, 'rparam', param_struct.rparamL$
    'band_names', param_struct.band_namesL, 'crism_mode', param_struct.crism_mode, $
    'spectral_sampling', param_struct.spectral_sampling, 'crism_fname_abbrev', param_struct.crism_fname_abbrev, $
    'crism_class_type', param_struct.crism_class_type, 'fname_param', param_struct.fname_paramL, 'fname_Rparam', param_struct.fname_RparamL, $
    'default_bands', param_struct.default_bandsL)
csi_param=create_struct('param', param_struct.paramL,'rparam', param_struct.rparamL)

  browse_struct_selected=create_struct('file_type', browse_struct.file_type, $;'browse', browse_struct.browseL, 'rbrowse', browse_struct.rbrowseL$
    'band_names', browse_struct.band_namesL, 'browse_names', browse_struct.browse_namesL, $
    'crism_mode', image_ancillary_struct.crism_mode, $
    'spectral_sampling', image_ancillary_struct.spectral_sampling, $
    'crism_fname_abbrev', image_ancillary_struct.crism_fname_abbrev, $
    'crism_class_type', image_ancillary_struct.crism_class_type)
csi_browse=create_struct('browse', browse_struct.browseL, 'rbrowse', browse_struct.rbrowseL)
    
  ddr_struct_selected=create_struct('file_type', ddr_struct.file_type, $;'ddr', ddr_struct.ddrL, $
    'ddr_bands', ddr_struct.ddr_bands, 'solar_longitude', ddr_struct.solar_longitude, $
    'crism_mode', ddr_struct.crism_mode, $
    'spectral_sampling', ddr_struct.spectral_sampling, $
    'crism_fname_abbrev', ddr_struct.crism_fname_abbrev, $
    'crism_class_type', ddr_struct.crism_class_type)
csi_ddr=ddr_struct.ddrL
endif

if crism_file_detector eq 2 then begin
  image_struct_selected=create_struct('file_type', image_struct.file_type, $;'image', image_struct.imageJ, $
    'wvs', image_struct.wvsJ, 'bbl', image_struct.bblJ, 'units', image_struct.unitsJ, 'crism_mode', image_struct.crism_mode, $
    'spectral_sampling', image_struct.spectral_sampling, 'crism_fname_abbrev', image_struct.crism_fname_abbrev, $
    'crism_class_type', image_struct.crism_class_type, 'arraysize', image_struct.arraysize, $
    'default_bands', image_struct.default_bandsJ)
  csi_image=image_struct.imageJ

  param_struct_selected=create_struct('file_type', param_struct.file_type, $; 'param', param_struct.paramJ, 'rparam', param_struct.rparamJ$
    'band_names', param_struct.band_namesJ, 'crism_mode', param_struct.crism_mode, $
    'spectral_sampling', param_struct.spectral_sampling, 'crism_fname_abbrev', param_struct.crism_fname_abbrev, $
    'crism_class_type', param_struct.crism_class_type, 'fname_param', param_struct.fname_paramJ, 'fname_Rparam', param_struct.fname_RparamJ, $
    'default_bands', param_struct.default_bandsJ)
  csi_param=create_struct('param', param_struct.paramJ,'rparam', param_struct.rparamJ)

  browse_struct_selected=create_struct('file_type', browse_struct.file_type, $;'browse', browse_struct.browseJ, 'rbrowse', browse_struct.rbrowseJ,$
    'band_names', browse_struct.band_namesJ, 'browse_names', browse_struct.browse_namesJ, $
    'crism_mode', image_ancillary_struct.crism_mode, $
    'spectral_sampling', image_ancillary_struct.spectral_sampling, $
    'crism_fname_abbrev', image_ancillary_struct.crism_fname_abbrev, $
    'crism_class_type', image_ancillary_struct.crism_class_type)
  csi_browse=create_struct('browse', browse_struct.browseJ, 'rbrowse', browse_struct.rbrowseJ)
  
  ddr_struct_selected=create_struct('file_type', ddr_struct.file_type, $;'ddr', ddr_struct.ddrJ, $
    'ddr_bands', ddr_struct.ddr_bands, 'solar_longitude', ddr_struct.solar_longitude, $
    'crism_mode', ddr_struct.crism_mode, $
    'spectral_sampling', ddr_struct.spectral_sampling, $
    'crism_fname_abbrev', ddr_struct.crism_fname_abbrev, $
    'crism_class_type', ddr_struct.crism_class_type)
  csi_ddr=ddr_struct.ddrJ  
endif

if crism_file_detector eq 3 then begin
  image_struct_selected=create_struct('file_type', image_struct.file_type, $;'image', image_struct.imageSL, $
    'wvs', image_struct.wvsSL, 'bbl', image_struct.bblSL, 'units', image_struct.unitsS, 'crism_mode', image_struct.crism_mode, $
    'spectral_sampling', image_struct.spectral_sampling, 'crism_fname_abbrev', image_struct.crism_fname_abbrev, $
    'crism_class_type', image_struct.crism_class_type, 'arraysize', image_struct.arraysize, $
    'default_bands', image_struct.default_bandsSL)
csi_image=image_struct.imageSL
  
  param_struct_selected=create_struct('file_type', param_struct.file_type, $;'param', param_struct.paramSL,'rparam', param_struct.rparamSL,  $
    'band_names', param_struct.band_namesSL, 'crism_mode', param_struct.crism_mode, $
    'spectral_sampling', param_struct.spectral_sampling, 'crism_fname_abbrev', param_struct.crism_fname_abbrev, $
    'crism_class_type', param_struct.crism_class_type, 'fname_param', '', 'fname_Rparam', '', $
    'default_bands', param_struct.default_bandsSL)
csi_param=create_struct('param', param_struct.paramSL,'rparam', param_struct.rparamSL)

  browse_struct_selected=create_struct('file_type', browse_struct.file_type, $;'browse', browse_struct.browseSL, 'rbrowse', browse_struct.rbrowseSL, $
    'band_names', browse_struct.band_namesSL, 'browse_names', browse_struct.browse_namesSL, $
    'crism_mode', image_ancillary_struct.crism_mode, $
    'spectral_sampling', image_ancillary_struct.spectral_sampling, $
    'crism_fname_abbrev', image_ancillary_struct.crism_fname_abbrev, $
    'crism_class_type', image_ancillary_struct.crism_class_type)
csi_browse=create_struct('browse', browse_struct.browseSL, 'rbrowse', browse_struct.rbrowseSL)
    
  ddr_struct_selected=create_struct('file_type', ddr_struct.file_type, $;'ddr', ddr_struct.ddrL, $
    'ddr_bands', ddr_struct.ddr_bands, 'solar_longitude', ddr_struct.solar_longitude, $
    'crism_mode', ddr_struct.crism_mode, $
    'spectral_sampling', ddr_struct.spectral_sampling, $
    'crism_fname_abbrev', ddr_struct.crism_fname_abbrev, $
    'crism_class_type', ddr_struct.crism_class_type)
csi_ddr=ddr_struct.ddrL    
endif

print, 'data structures built'
 ; image_struct=ptr_new(image_struct_selected)
 
  image_struct=image_struct_selected
  param_struct=param_struct_selected
  browse_struct=browse_struct_selected
  ddr_struct=ddr_struct_selected
  
  undefine, image_struct_selected, param_struct_selected, browse_struct_selected, ddr_struct_selected
 ; delvar, image_struct_selected, param_struct_selected, browse_struct_selected, ddr_struct_selected


;6) READ IN LIBRARY FILES AND DETERMINE WAVELENGTH TABLES
;*************************************************
;THIS WILL NEED TO BE EDITED BASED ON THE SETUP  -
MICA_library_file='/project/crism/users/viviace1/crismidl/CSI_program/MICA_library_file.sli'
MICA_data=csi_read_resample_sli(image_struct.spectral_sampling, image_struct.units, MICA_library_file)

LAB_library_file='/project/crism/users/viviace1/crismidl/CSI_program/LAB_library_file.sli'
LAB_data=csi_read_resample_sli(image_struct.spectral_sampling, image_struct.units, LAB_library_file)

case image_struct.spectral_sampling of
  0: wvt_file='/project/crism/users/viviace1/TaylorNewRedo3/wvt_subset_newsub_MSPresamp_FORCSI.txt' ; multispectral (MSP)
  1: wvt_file='/project/crism/users/viviace1/TaylorNewRedo3/wvt_subset_newsub.txt' ; hyperspectral (FRT,HRL)
  2: wvt_file='/project/crism/users/viviace1/TaylorNewRedo3/wvt_subset_newsub_HSPresamp_FORCSI.txt' ; 'hyperspectral' (HSP sampling)
  else: print, 'Not a valid spectral sampling type.'
endcase

rows=file_lines(wvt_file)  ; read in bad bands for MICA library
openr, lun, wvt_file, /get_lun
;struct3=fltarr(1)
wvt_subset=replicate(fltarr(1), rows)
readf, lun, wvt_subset, format='(f)'
close, lun
free_lun, lun


;7) CALL WIDGET PROGRAM
;*************************************************
  csi_table_struct={STR, Num:'', ID:'', mineralogy:'', morphology:'', comment:'', lon:'', lat:'', elev:'', ROIon_row:'', ROIon_col:'', $
  ROIoff_row:'', ROIoff_col:'', ROIsz_row:'', ROIsz_col:'', ELEVmin:'', ELEVmax:'', color:'', colorline:''}
  
  
 
 save, /variables, filename = '/project/crism/users/viviace1/crismidl/CSI_program/CSI_practice_files/driver_variables.sav'
 
 JUMP1: restore, '/project/crism/users/viviace1/crismidl/CSI_program/CSI_practice_files/driver_variables.sav'
   
  
  csi_main_widget_build, image_ancillary_struct=image_ancillary_struct, csi_table_struct=csi_table_struct, multsz=multsz, infoholder=infoholder, $
    image_struct=image_struct,param_struct=param_struct,browse_struct=browse_struct, ddr_struct=ddr_struct, LAB_data=LAB_data, MICA_data=MICA_data, wvt_subset=wvt_subset  ;, img_str=image_struct
     
  device, decomposed=1
  
END

  
  
  
  
  
