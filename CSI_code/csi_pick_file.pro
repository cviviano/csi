
function csi_pick_file, file_type_selected, directory=directory

  image_fname_struct={file_type:file_type_selected, fname_imageS:'', fname_imageL:'', fname_imageJ:''}
  
  if (file_type_selected eq 0) or (file_type_selected eq 3) then begin
    image_fname_struct.fname_imageS=dialog_pickfile(title='Pick IF S data (trr3_CAT_corr.img, _TER3.img)', filter='*if*s_*trr3*corr*.img;*if*s_*trr3*corr*.IMG', path=directory)
  endif
  
  if (file_type_selected eq 1) or (file_type_selected eq 3) then begin
    image_fname_struct.fname_imageL=dialog_pickfile(title='Pick IF L data (trr3_CAT_corr.img, _TER3.img)', filter='*if*l_*trr3*corr*.img;*if*l_*trr3*corr*.IMG', path=directory)
  endif
  
  if (file_type_selected eq 2) then begin
    image_fname_struct.fname_imageJ=dialog_pickfile(title='Pick IF J data (_ter3.img)', filter='*if*ter3*.img;*if*ter3*.IMG', path=directory)
  endif
  
  return, image_fname_struct
  
end