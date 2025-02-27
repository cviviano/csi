PRO csi_saveas_event, ev
  widget_control, ev.top, get_uvalue=infoptr
  info=*infoptr
  
  ;Pick the filename
  ofilename=info.image_ancillary_struct.crism_file_path+info.image_ancillary_struct.crism_fname_abbrev +'_' + $
    info.image_ancillary_struct.crism_counter+'_'+ info.image_ancillary_struct.crism_activity+info.image_ancillary_struct.crism_sensor+ $
    '_'+info.image_ancillary_struct.crism_file_type+info.image_ancillary_struct.crism_version+'_CSItable'+'.csv'

  if string(info.infoholder) ne '0' then begin  ;check for defined file name
    savename=info.infoholder
  endif else begin
    savename= DIALOG_PICKFILE(path=info.image_ancillary_struct.crism_file_path, title="Save Table As...", /write, file=ofilename)
  endelse

  ;Write the CSI table
  csi_formatted_table=csi_format_table(info.d0)
  csi_write_table, csi_formatted_table, savename

  info.savename=savename
  *infoptr=info
END