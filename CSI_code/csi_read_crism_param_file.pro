function csi_read_crism_param_file, param_fname_struct, image_ancillary_struct

  paramS=''
  paramL=''
  paramJ=''
 ; paramSL=''
  rparamS=''
  rparamL=''
  rparamJ=''
  ;rparamSL=''
  band_namesS=''
  band_namesL=''
  band_namesJ=''
  band_namesSL=''
  default_bandsS=''
  default_bandsL=''
  default_bandsJ=''
  default_bandsSL=''
  
  file_type=param_fname_struct.file_type

  if (param_fname_struct.file_type eq 0) or (param_fname_struct.file_type eq 3) then begin; S
    paramS=transpose(csi_read_envi_image(param_fname_struct.fname_paramS, header=hdrS), [1,2,0])
    if param_fname_struct.fname_rparamS ne '' then rparamS=transpose(csi_read_envi_image(param_fname_struct.fname_rparamS), [1,2,0])
    band_namesS=strtrim(*(hdrS.band_names),1)
    default_bandsS=hdrS.default_bands
  endif

  if (param_fname_struct.file_type eq 1) or (param_fname_struct.file_type eq 3) then begin; L
    paramL=transpose(csi_read_envi_image(param_fname_struct.fname_paramL, header=hdrL), [1,2,0])
    if param_fname_struct.fname_rparamL ne '' then rparamL=transpose(csi_read_envi_image(param_fname_struct.fname_rparamL), [1,2,0])
    band_namesL=strtrim(*(hdrL.band_names),1)
    default_bandsL=hdrL.default_bands
    if (param_fname_struct.file_type eq 3) then begin
      band_namesSL=[band_namesS,band_namesL]  
      default_bandsSL=[default_bandsL]
    endif
  endif

  if param_fname_struct.file_type eq 2 then begin ; J 
    hdrJ=csi_find_header(param_fname_struct.fname_paramJ)
    paramJ=transpose(csi_read_envi_image(param_fname_struct.fname_paramJ, header=hdrJ), [1,2,0])
    hdrJR=csi_find_header(param_fname_struct.fname_rparamJ)
    rparamJ=transpose(csi_read_envi_image(param_fname_struct.fname_rparamJ, header=hdrJR), [1,2,0])
    band_namesJ=strtrim(*(hdrJ.band_names),1)
    default_bandsJ=hdrJ.default_bands
  endif

  param_struct=create_struct('file_type', param_fname_struct.file_type, 'paramS', paramS, 'paramL', paramL, 'paramJ', paramJ, $
    'rparamS', rparamS, 'rparamL', rparamL, 'rparamJ', rparamJ, $
    'band_namesS', band_namesS, 'band_namesL', band_namesL, 'band_namesJ', band_namesJ, 'band_namesSL', band_namesSL,$
    'default_bandsS', default_bandsS, 'default_bandsL', default_bandsL, 'default_bandsJ', default_bandsJ, 'default_bandsSL', default_bandsSL,$
    'crism_mode', image_ancillary_struct.crism_mode, $
    'spectral_sampling', image_ancillary_struct.spectral_sampling, $
    'crism_fname_abbrev', image_ancillary_struct.crism_fname_abbrev, $
    'crism_class_type', image_ancillary_struct.crism_class_type, $
    'fname_paramS', param_fname_struct.fname_paramS, 'fname_paramL', param_fname_struct.fname_paramL, 'fname_paramJ', param_fname_struct.fname_paramJ,  $
    'fname_RparamS', param_fname_struct.fname_RparamS, 'fname_RparamL', param_fname_struct.fname_RparamL, 'fname_RparamJ', param_fname_struct.fname_RparamJ)
  
  return, param_struct

end
