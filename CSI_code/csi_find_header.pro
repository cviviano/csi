function csi_find_header, fname
  
  fname_base=(strsplit(fname,'.',/extract))[0]
  extensions=['.img.hdr', '.IMG.HDR', '.hdr','.HDR']
  
  for i=0, n_elements(extensions)-1 do begin
    if (file_test(fname_base+extensions[i]) eq 1) then begin
      result=1
      headerFilename=fname_base+extensions[i]
    endif
  endfor
  
  if not(n_elements(result) gt 0) then begin
    headerFilename = DIALOG_PICKFILE( TITLE="Please select ENVI header file", $
      PATH=FILE_DIRNAME( fname ), $
      FILTER=['*.hdr','*.HDR'] )
  endif
 
  return, headerFilename

end