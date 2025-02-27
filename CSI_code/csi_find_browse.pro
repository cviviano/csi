function csi_find_browse, image_fname_struct

  ;update to calculate browse for TRR files on the fly

  ;add catch if file isn't found to select directly

  fname_browseS=''
  fname_browseL=''
  fname_browseJ=''
  
  if (image_fname_struct.file_type eq 0) or (image_fname_struct.file_type eq 3) then begin; S
    fname_browseS=''
  endif

  if (image_fname_struct.file_type eq 1) or (image_fname_struct.file_type eq 3) then begin; L
    fname_browseL=''
  endif

  if image_fname_struct.file_type eq 2 then begin ; J
    fname_browseJ=file_search(file_dirname(image_fname_struct.fname_imageJ),'*_br*j_ter3.img')
  endif
  
  browse_fname_struct=create_struct('file_type', image_fname_struct.file_type, 'fname_browseS', fname_browseS, 'fname_browseL', fname_browseL, 'fname_browseJ', fname_browseJ)
  
  return, browse_fname_struct

end