function csi_browse_text, wrap_length, browse_selected=browse_selected, browse_names=browse_names, param_name_rgb=param_name_rgb

  browsefile='/disks/dc039/users/viviace1/crismidl_trunk/CSI/info_for_CSI_BrowseandSumParam.txt'
  brsarray = read_string_file(browsefile)
  
  if keyword_set(browse_selected) then begin
    browse_text=brsarray(where(strmatch(brsarray, '*Abbreviation = '+browse_names(browse_selected))eq 1)+1:(size(brsarray))[1]-1)
    return_browse_text=browse_text[0:(where(strpos(browse_text, ' ') eq -1))[0]]
   
    return_browse_text=csi_wrap_string(return_browse_text, wrap_length)

    return, return_browse_text
  endif
  
  if keyword_set(param_name_rgb) then begin
    
  r_simp=strjoin(strsplit(param_name_rgb[0], '_flat', /extract, /regex, /preserve_null))
  g_simp=strjoin(strsplit(param_name_rgb[1], '_flat', /extract, /regex, /preserve_null))
  b_simp=strjoin(strsplit(param_name_rgb[2], '_flat', /extract, /regex, /preserve_null))
  subparamrtxt=brsarray(where(strmatch(brsarray, '*'+strtrim(r_simp,1)+'*=*') eq 1):(size(brsarray))[1]-1)
  subparamr=subparamrtxt[0:(where(strpos(subparamrtxt, ' ') eq -1))[0]]
  subparamgtxt=brsarray(where(strmatch(brsarray, '*'+strtrim(g_simp,1)+'*=*') eq 1):(size(brsarray))[1]-1)
  subparamg=subparamgtxt[0:(where(strpos(subparamgtxt, ' ') eq -1))[0]]
  subparambtxt=brsarray(where(strmatch(brsarray, '*'+strtrim(b_simp,1)+'*=*') eq 1):(size(brsarray))[1]-1)
  subparamb=subparambtxt[0:(where(strpos(subparambtxt, ' ') eq -1))[0]]
   return, [subparamr,subparamg,subparamb]
  endif
end