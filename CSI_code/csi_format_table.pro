function csi_format_table, d0

  d0=*d0
  table_tags=tag_names(d0)

  length=n_elements(d0.(0))
  comma=","

  csi_table=strarr(n_elements(table_tags), length)

  for i=0, n_elements(table_tags)-1 do begin

    if i gt n_elements(table_tags)-3 then begin
      scolumn=string(d0.(i))
      scolumnrev=strmid(transpose([scolumn]),0,max(strlen(scolumn)))
      csi_table[i, *]=scolumnrev
    endif else begin
      scolumn=strtrim(string(d0.(i)), 2)
      scolumnrev=strmid(transpose([strtrim(scolumn, 2)]),0,max(strlen(scolumn)))
      csi_table[i, *]=scolumnrev
    endelse
  endfor

  dzname=table_tags
  dzname[n_elements(table_tags)-2]='Fill Color:color'
  dzname[n_elements(table_tags)-1]='Line Color:color'
  csi_table=[[dzname],[csi_table]]
  
return, csi_table
end