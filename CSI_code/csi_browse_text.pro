function csi_browse_text, wrap_length, browse_selected=browse_selected, browse_names=browse_names, param_name_rgb=param_name_rgb

  info_textfile=file_dirname(routine_dir())+path_sep()+'CSI_ancillary/Browse_and_SumParam_info.txt'
  info_text = read_string_file(info_textfile)
  
  if keyword_set(browse_selected) then begin
    browse_text=info_text(where(strmatch(info_text, '*Abbreviation = '+browse_names[browse_selected])eq 1)+1:(size(info_text))[1]-1)
    return_browse_text=browse_text[0:(where(strpos(browse_text, ' ') eq -1))[0]]
   
    return_browse_text=csi_wrap_string(return_browse_text, wrap_length)

    return, return_browse_text
  endif
  
  if keyword_set(param_name_rgb) then begin
    
  r_simp=strjoin(strsplit(param_name_rgb[0], '_flat', /extract, /regex, /preserve_null))
  g_simp=strjoin(strsplit(param_name_rgb[1], '_flat', /extract, /regex, /preserve_null))
  b_simp=strjoin(strsplit(param_name_rgb[2], '_flat', /extract, /regex, /preserve_null))
  subparamrtxt=info_text(where(strmatch(info_text, '*'+strtrim(r_simp,1)+'*=*') eq 1):(size(info_text))[1]-1)
  subparamr=subparamrtxt[0:(where(strpos(subparamrtxt, ' ') eq -1))[0]]
  subparamgtxt=info_text(where(strmatch(info_text, '*'+strtrim(g_simp,1)+'*=*') eq 1):(size(info_text))[1]-1)
  subparamg=subparamgtxt[0:(where(strpos(subparamgtxt, ' ') eq -1))[0]]
  subparambtxt=info_text(where(strmatch(info_text, '*'+strtrim(b_simp,1)+'*=*') eq 1):(size(info_text))[1]-1)
  subparamb=subparambtxt[0:(where(strpos(subparambtxt, ' ') eq -1))[0]]
   return, [subparamr,subparamg,subparamb]
  endif
end