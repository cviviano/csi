function csi_image_get_ancillary, image_fname_struct
  
  image_ancillary_struct={crism_mode:'', spectral_sampling:'', crism_fname_abbrev:'', crism_class_type:'', crism_file_path:'', $
    crism_counter:'', crism_activity:'', crism_sensor:'', crism_file_type:'', crism_filename:'', crism_version:''}

  if (image_fname_struct.file_type eq 0) or (image_fname_struct.file_type eq 3) then begin; S
    image_info_struct=mro_crism_parse_filename(image_fname_struct.fname_imageS)
    
  endif

  if (image_fname_struct.file_type eq 1) or (image_fname_struct.file_type eq 3) then begin; L
    image_info_struct=mro_crism_parse_filename(image_fname_struct.fname_imageL)
  endif

  if image_fname_struct.file_type eq 2 then begin ; J
    image_info_struct=mro_crism_parse_filename(image_fname_struct.fname_imageJ)
  endif
  
  image_ancillary_struct.crism_mode=csi_crism_mode_sampling(image_info_struct.class_type, /mode)
  image_ancillary_struct.spectral_sampling=csi_crism_mode_sampling(image_info_struct.class_type, /sampling)
  image_ancillary_struct.crism_fname_abbrev=image_info_struct.class_type+image_info_struct.obs_ID+' '
  image_ancillary_struct.crism_class_type=strmid(image_ancillary_struct.crism_fname_abbrev,0,3)
  image_ancillary_struct.crism_file_path=image_info_struct.file_path
  image_ancillary_struct.crism_counter=image_info_struct.counter
  image_ancillary_struct.crism_activity=image_info_struct.activity
  image_ancillary_struct.crism_sensor=image_info_struct.sensor
  image_ancillary_struct.crism_file_type=image_info_struct.file_type
  image_ancillary_struct.crism_filename=image_info_struct.file_name
  image_ancillary_struct.crism_version=image_info_struct.version

;  image_ancillary_struct.class_type=image_info_struct.class_type
;  image_ancillary_struct.obs_id=image_info_struct.obs_id
;  image_ancillary_struct.counter=image_info_struct.counter
;  image_ancillary_struct.activity=image_info_struct.activity
;  image_ancillary_struct.sensor=image_info_struct.sensor
;  image_ancillary_struct.file_type=image_info_struct.file_type
;  image_ancillary_struct.version=image_info_struct.version

  undefine, image_info_struct

  return, image_ancillary_struct

end