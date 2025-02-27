function csi_find_param, image_fname_struct

;update to calculate parameters for TRR files on the fly

;add catch if file isn't found to select directly

  param_fname_struct={file_type:image_fname_struct.file_type, fname_paramS:'', fname_paramL:'', fname_paramJ:'', $
    fname_RparamS:'', fname_RparamL:'', fname_RparamJ:''}

  if (image_fname_struct.file_type eq 0) or (image_fname_struct.file_type eq 3) then begin; S
    param_fname_struct.fname_paramS=file_search(file_dirname(image_fname_struct.fname_imageS),'*s*_2014params.img')
    param_fname_struct.fname_RparamS=file_search(file_dirname(image_fname_struct.fname_imageS),'*s*_2014params_flat.img')
  endif

  if (image_fname_struct.file_type eq 1) or (image_fname_struct.file_type eq 3) then begin; L
    param_fname_struct.fname_paramL=file_search(file_dirname(image_fname_struct.fname_imageL),'*l*_2014params.img')
    param_fname_struct.fname_RparamL=file_search(file_dirname(image_fname_struct.fname_imageL),'*l*_2014params_flat.img')
  endif

  if image_fname_struct.file_type eq 2 then begin ; J
    param_fname_struct.fname_paramJ=file_search(file_dirname(image_fname_struct.fname_imageJ),'*su*ter3.img')
    param_fname_struct.fname_RparamJ=file_search(file_dirname(image_fname_struct.fname_imageJ),'*sr*ter3.img')
  endif

  return, param_fname_struct

end