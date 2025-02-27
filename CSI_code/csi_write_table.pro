pro csi_write_table, csi_formatted_table, savename

  szd0=size(csi_formatted_table, /dimensions)
  lineWidth=1600
  openW, lun, savename, /Get_Lun, Width=lineWidth
  sData=StrTrim(csi_formatted_table,2)
  sData[0:szd0[0]-2,*]=sData[0:szd0[0]-2,*]+","
  printF, lun, sData
  free_lun, lun

end