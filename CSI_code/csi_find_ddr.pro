function csi_find_ddr, image_fname_struct

  ddr_fname_struct={file_type:image_fname_struct.file_type, fname_ddrS:'', fname_ddrL:'', fname_ddrJ:''}

  if (image_fname_struct.file_type eq 0) or (image_fname_struct.file_type eq 3) then begin; S 
    ddr_fname_struct.fname_ddrS=file_search(file_dirname(image_fname_struct.fname_imageS),'../ddr/*s_ddr1.img')
  endif
  
  if (image_fname_struct.file_type eq 1) or (image_fname_struct.file_type eq 3) then begin; L 
    ddr_fname_struct.fname_ddrL=file_search(file_dirname(image_fname_struct.fname_imageL),'../ddr/*l_ddr1.img')
  endif
  
  if image_fname_struct.file_type eq 2 then begin ; J 
    ddr_fname_struct.fname_ddrJ=file_search(file_dirname(image_fname_struct.fname_imageJ),'../ddr/*l_ddr1.img')
  endif

  return, ddr_fname_struct

end