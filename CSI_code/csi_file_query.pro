function csi_file_query, file_type_selected

noname='1'
nosize=[1,1,1]
nobands=1
nocdet=-1

crism_file_info={fname:noname, fnameS:noname, fnameL:noname, fnameJ:noname, $
  sZS:nosize, sZL:nosize, szJ:nosize, $
  def_bandsS:nobands, def_bandsL:nobands, def_bandsJ:nobands, $
  cdet:nocdet}

if (file_type_selected eq 0) or (file_type_selected eq 2) then begin
  ENVI_SELECT, fid=crism_file_info.fidS, dims=dims, title='Pick IF S data (TRR3_corr.img, _TER3.img)', /file_only, /no_spec, /no_dims
  if (crism_file_info.fidS[0] eq -1) then return
  envi_file_query, crism_file_info.fidS, fname=crism_file_info.fnameS, data_ignore_value=data_ignore_value, wavelength_units=cmicron, bbl=bblS, wl=wllibS, ns=nsS, nl=nlS, nb=nbS, DEF_BANDS=crism_file_info.def_bandsS
  fname_deets=mro_crism_parse_filename(crism_file_info.fnameS)
  if fname_deets.sensor ne 'S' then return
  crism_file_info.fname=crism_file_info.fnameS
  crism_file_info.cdet=0
  crism_file_info.szS=[nsS,nlS,nbS]

endif

if (file_type_selected eq 1) or (file_type_selected eq 2) then begin
  ENVI_SELECT, fid=fidL, dims=dims, title='Pick IF L data (TRR3_corr.img, _TER3.img)', /file_only, /no_spec, /no_dims
  if (fidL[0] eq -1) then return
  envi_file_query, fidL, fname=crism_file_info.fnameL, data_ignore_value=data_ignore_value, wavelength_units=cmicron, bbl=bblL, wl=wllibL, ns=nsL, nl=nlL, nb=nbL, DEF_BANDS=crism_file_info.def_bandsL
  fname_deets=mro_crism_parse_filename(crism_file_info.fnameL)
  if fname_deets.sensor ne 'L' then return
  crism_file_info.fname=crism_file_info.fnameL
  if file_type_selected eq 2 then begin
    crism_file_info.cdet=3
    crism_file_info.fname=[crism_file_info.fnameL,crism_file_info.fnameS]
    crism_file_info.szS=[nsS,nlS,nbS]
    crism_file_info.szL=[nsL,nlL,nbL]
  endif else begin
    crism_file_info.cdet=1
    crism_file_info.szL=[nsL,nlL,nbL]
  endelse
endif

if (file_type_selected eq 3) then begin
  ENVI_SELECT, fid=fidJ, dims=dims, title='Pick IF J data (_TER3.img)', /file_only, /no_spec, /no_dims 
  if (fidJ[0] eq -1) then return
  envi_file_query, fidJ, fname=crism_file_info.fnameJ, data_ignore_value=data_ignore_value, wavelength_units=cmicron, bbl=bblJ, wl=wllibJ, ns=nsJ, nl=nlJ, nb=nbJ, DEF_BANDS=crism_file_info.def_bandsJ
  crism_file_info.fname=crism_file_info.fnameJ
  crism_file_info.cdet=2
  crism_file_info.szJ=[nsJ,nlJ,nbJ]
endif

return, crism_file_info