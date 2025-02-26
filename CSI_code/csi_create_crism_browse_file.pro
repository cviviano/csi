function csi_create_crism_browse_file, param_struct, image_ancillary_struct
  
  browseS=''
  browseL=''
  browseJ=''
  browseSL=''
  rbrowseS=''
  rbrowseL=''
  rbrowseJ=''
  rbrowseSL=''
  band_namesS=''
  band_namesL=''
  band_namesJ=''
  band_namesSL=''
  browse_namesS=''
  browse_namesL='' 
  browse_namesJ=''
  browse_namesSL=''
  
  browse_stretch=csi_browse_info(/browse_stretch)
 
  if (param_struct.file_type eq 0) or (param_struct.file_type eq 3) then begin; S
    browse_namesS=csi_browse_info(detector='S', /browse_names)
    band_namesS=csi_browse_info(detector='S', /browse_table)
    browseS=fltarr(3, (size(param_struct.paramS))[1], (size(param_struct.paramS))[2], n_elements(browse_namesS))
    rbrowseS=browseS
    for i=0, n_elements(browse_namesS)-1 do begin
   ;   stop
      browseS[0,*,*,i]=param_struct.paramS[*,*, where(param_struct.band_namesS eq (band_namesS[*,i])[0])]
      browseS[1,*,*,i]=param_struct.paramS[*,*, where(param_struct.band_namesS eq (band_namesS[*,i])[1])]
      browseS[2,*,*,i]=param_struct.paramS[*,*, where(param_struct.band_namesS eq (band_namesS[*,i])[2])]
      if param_struct.fname_rparamS ne '' then begin
        rbrowseS[0,*,*,i]=param_struct.rparamS[*,*, where(param_struct.band_namesS eq (band_namesS[*,i])[0])]
        rbrowseS[1,*,*,i]=param_struct.rparamS[*,*, where(param_struct.band_namesS eq (band_namesS[*,i])[1])]
        rbrowseS[2,*,*,i]=param_struct.rparamS[*,*, where(param_struct.band_namesS eq (band_namesS[*,i])[2])]
      endif
    endfor
  endif
  
  if (param_struct.file_type eq 1) or (param_struct.file_type eq 3) then begin; L
    browse_namesL=csi_browse_info(detector='L', /browse_names)
    band_namesL=csi_browse_info(detector='L', /browse_table)
    browseL=fltarr(3, (size(param_struct.paramL))[1], (size(param_struct.paramL))[2], n_elements(browse_namesL))
    rbrowseL=browseL
    for i=0, n_elements(browse_namesL)-1 do begin
      browseL[0,*,*,i]=param_struct.paramL[*,*, where(param_struct.band_namesL eq (band_namesL[*,i])[0])]
      browseL[1,*,*,i]=param_struct.paramL[*,*, where(param_struct.band_namesL eq (band_namesL[*,i])[1])]
      browseL[2,*,*,i]=param_struct.paramL[*,*, where(param_struct.band_namesL eq (band_namesL[*,i])[2])]
      if param_struct.fname_rparamL ne '' then begin
        rbrowseL[0,*,*,i]=param_struct.rparamL[*,*, where(param_struct.band_namesL eq (band_namesL[*,i])[0])]
        rbrowseL[1,*,*,i]=param_struct.rparamL[*,*, where(param_struct.band_namesL eq (band_namesL[*,i])[1])]
        rbrowseL[2,*,*,i]=param_struct.rparamL[*,*, where(param_struct.band_namesL eq (band_namesL[*,i])[2])]
      endif
    endfor
    if (param_struct.file_type eq 3) then begin
      browseSL=reform([reform(browseS,browseS.length),reform(browseL,browseL.length)],(size(browseS))[1],(size(browseS))[2], $
        (size(browseS))[3], (size(browseS))[4]+(size(browseL))[4])
      rbrowseSL=reform([reform(rbrowseS,rbrowseS.length),reform(rbrowseL,rbrowseL.length)],(size(rbrowseS))[1],(size(rbrowseS))[2], $
        (size(rbrowseS))[3], (size(rbrowseS))[4]+(size(rbrowseL))[4])
      band_namesSL=[[band_namesS],[band_namesL]]
      browse_namesSL=[browse_namesS, browse_namesL]
    endif
  endif

  if (param_struct.file_type eq 2) then begin; J
    browse_namesJ=csi_browse_info(detector='J', /browse_names)
    band_namesJ=csi_browse_info(detector='J', /browse_table)
    browseJ=fltarr(3, (size(param_struct.paramJ))[1], (size(param_struct.paramJ))[2], n_elements(browse_namesJ))
    rbrowseJ=browseJ
    for i=0, n_elements(browse_namesJ)-1 do begin 
      browseJ[0,*,*,i]=param_struct.paramJ[*,*, where(param_struct.band_namesJ eq (band_namesJ[*,i])[0])]
      browseJ[1,*,*,i]=param_struct.paramJ[*,*, where(param_struct.band_namesJ eq (band_namesJ[*,i])[1])]
      browseJ[2,*,*,i]=param_struct.paramJ[*,*, where(param_struct.band_namesJ eq (band_namesJ[*,i])[2])]
      if param_struct.fname_rparamJ ne '' then begin    
        rbrowseJ[0,*,*,i]=param_struct.rparamJ[*,*, where(param_struct.band_namesJ eq (band_namesJ[*,i])[0])]
        rbrowseJ[1,*,*,i]=param_struct.rparamJ[*,*, where(param_struct.band_namesJ eq (band_namesJ[*,i])[1])]
        rbrowseJ[2,*,*,i]=param_struct.rparamJ[*,*, where(param_struct.band_namesJ eq (band_namesJ[*,i])[2])]
      endif
    endfor
  endif
  
  browse_struct=create_struct('file_type', param_struct.file_type, 'browseS', browseS, 'browseL', browseL, 'browseJ', browseJ, 'browseSL', browseSL, $
    'rbrowseS', rbrowseS, 'rbrowseL', rbrowseL, 'rbrowseJ', rbrowseJ,  'rbrowseSL', rbrowseSL, $
    'band_namesS', band_namesS, 'band_namesL', band_namesL, 'band_namesJ', band_namesJ, 'band_namesSL', band_namesSL, $
    'browse_namesS', browse_namesS, 'browse_namesL', browse_namesL, 'browse_namesJ', browse_namesJ, 'browse_namesSL', browse_namesSL, $
    'crism_mode', image_ancillary_struct.crism_mode, $
    'spectral_sampling', image_ancillary_struct.spectral_sampling, $
    'crism_fname_abbrev', image_ancillary_struct.crism_fname_abbrev, $
    'crism_class_type', image_ancillary_struct.crism_class_type)
  
  return, browse_struct
end