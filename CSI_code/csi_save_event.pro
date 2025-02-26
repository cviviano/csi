PRO csi_save_event, ev
  widget_control, ev.top, get_uvalue=infoptr
  info=*infoptr
  savename=info.savename

  if (strlen(savename) le 0) then begin ;First time saving the file

    ofilename=info.image_ancillary_struct.file_path+info.image_ancillary_struct.crism_fname_abbrev +'_' + $
      info.image_ancillary_struct.crism_counter+'_'+ info.image_ancillary_struct.crism_activity+info.image_ancillary_struct.crism_sensor+ $
      '_'+info.image_ancillary_struct.crism_file_type+info.image_ancillary_struct.crism_version+'_CSItable'+'.csv'

    savename= DIALOG_PICKFILE(path=info.image_ancillary_struct.crism_file_path, title="Save Table As...", /write, file=ofilename)
  endif
  
  ; Write the CSI table

  csi_formatted_table=csi_format_table(info.d0)
  csi_write_table, csi_formatted_table, savename
 ; write_csv, savename, csi_formatted_table
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  info.savename=savename
  *infoptr=info
END