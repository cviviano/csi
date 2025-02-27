function csi_image_percent_stretch, crism_image, percent=percent

  subimage=crism_image(where(crism_image ne 65535.))

  if keyword_set(percent) then begin
    
    max_val=median(subimage)+long(percent)*stdev(subimage)
    min_val=median(subimage)-long(percent)*stdev(subimage)
    
  endif else begin ;default stretch
    
    max_val=max(subimage)-(0.02*(max(subimage)-min(subimage)))
    min_val=min(subimage)+(0.02*(max(subimage)-min(subimage)))
    
  endelse
    
    btsimage=bytscl(crism_image, min_val, max_val)
    
    return, btsimage
end