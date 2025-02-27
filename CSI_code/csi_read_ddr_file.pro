function csi_read_ddr_file, ddr_fname_struct, image_ancillary_struct

  ddrS=''
  ddrL=''
  ddrJ=''

  if (ddr_fname_struct.file_type eq 0) or (ddr_fname_struct.file_type eq 3) then begin; S
    ddrS=mro_crism_quick_read(ddr_fname_struct.fname_ddrS, /image_flag, /silent)
    ddrlabel=mro_crism_quick_read(ddr_fname_struct.fname_ddrS, /label_struct_flag, /silent)
    ddrS=transpose(ddrS, [2,0,1])
    
  endif
  
  if (ddr_fname_struct.file_type eq 1) or (ddr_fname_struct.file_type eq 3) then begin; L   
    ddrL=mro_crism_quick_read(ddr_fname_struct.fname_ddrL, /image_flag, /silent)
    ddrlabel=mro_crism_quick_read(ddr_fname_struct.fname_ddrL, /label_struct_flag, /silent)
    ddrL=transpose(ddrL, [2,0,1])
  endif
  
  if ddr_fname_struct.file_type eq 2 then begin ; J (L data ddr, since S projected to L in J products)
    ddrJ=mro_crism_quick_read(ddr_fname_struct.fname_ddrJ, /image_flag, /silent)
    ddrlabel=mro_crism_quick_read(ddr_fname_struct.fname_ddrJ, /label_struct_flag, /silent)
  ;  ddrfile=ddrfileread.image
  ;  ddr=fltarr((size(ddrfile))[1], (size(ddrfile))[2], 3)
  ;  ddr[*,*,0]=ddrfile[*,*,3] ;Latitude, areocentric, deg N
  ;  ddr[*,*,1]=ddrfile[*,*,4] ;Longitude, areocentric, deg E
  ;  ddr[*,*,2]=ddrfile[*,*,9] ;Elevation, meters relative to MOLA 
    ddrJ=transpose(ddrJ, [2,0,1])
  
  endif

  ddr_struct=create_struct('file_type', ddr_fname_struct.file_type, 'ddrS', ddrS, 'ddrL', ddrL, 'ddrJ', ddrJ, $
    'ddr_bands', ddrlabel.band_name, 'solar_longitude', ddrlabel.solar_longitude, $
    'crism_mode', image_ancillary_struct.crism_mode, $
    'spectral_sampling', image_ancillary_struct.spectral_sampling, $
    'crism_fname_abbrev', image_ancillary_struct.crism_fname_abbrev, $
    'crism_class_type', image_ancillary_struct.crism_class_type)
  
  undefine, ddr_fname_struct
  undefine, ddrS
  undefine, ddrL
  undefine, ddrJ
  return, ddr_struct
  
end