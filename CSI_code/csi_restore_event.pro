PRO csi_restore_event, ev

  widget_control, ev.top, get_uvalue=infoptr
  info=*infoptr

  d0=*info.d0


  ;if infoholder eq '/project/crism/users/viviace1/tmp.csv' then begin
  infoholder=info.infoholder
  if infoholder ne '0' then begin
    restorename=infoholder
    infoholder=0 ;reset once used
  endif else begin
    restorename= DIALOG_PICKFILE(path=info.image_ancillary_struct.crism_file_path, title="Save Table As...", filter=['*.csv'])
  endelse

  d1=info.d_common

  arrayout=read_csv(restorename, count=nrows, delimiter=',')  ;Read in CSI file: get # of rows

  tnames = tag_names(d1)

  for jj=0, n_elements(arrayout.(0))-1 do begin
    for ii=0, n_elements(tnames)-1 do begin
      d1.(ii)=strtrim(string((arrayout.(ii))[jj]), 2)
    endfor
    if jj eq 0 then begin
      concat=ptr_new(d1)
    endif else begin
      concat=ptr_new([*concat,d1])
    endelse
  endfor
  ;grab last two columns since read_csv doesn't seem to want to read them in current format, which is necessary for JMARS

  openr, lun, restorename, /get_lun
  temparray=''
  templine=''
  while not eof(lun) do begin & $
    readf, lun, templine & $
    temparray=[temparray,templine]&$
  endwhile
free_lun, lun

temparray=temparray[2:*] ;no header info

tempcolumn1=strarr(1,(size(temparray))[1])
tempcolumn2=strarr(1,(size(temparray))[1])
for i=0, ((size(temparray))[1])-1 do begin
  subtemp=(strsplit(temparray[i], '","', /extract))
  tempcolumn1[*,i]=subtemp[n_elements(test)-1]
  tempcolumn2[*,i]=subtemp[n_elements(test)-2]
endfor
d1=*concat

d1.color=transpose(tempcolumn2)
d1.colorline=transpose(tempcolumn1)

if strtrim((d0.(0))[0],2) eq '0' then begin ;empty table
  newstruct=[d1]
endif else begin

  newstruct=([d0,d1])

  for i=0, ((size(newstruct))[1]-1) do begin  ;re-number table
    newstruct[i].num=strtrim(string(i+1),2);1
  endfor
endelse
info.num=n_elements(newstruct.(0))
info.d0=ptr_new(newstruct)

widget_control, info.table1, SET_VALUE=*info.d0
*infoptr=info
END