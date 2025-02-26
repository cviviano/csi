;Set drop menu for RGB image display
;Color ROI on/off location red and green
;CSI

PRO csi_display_parameter, drawID, red, green, blue, param_struct=param_struct, csi_param=csi_param, browse_struct=browse_struct, csi_browse=csi_browse, $
       where=where, onspot=onspot, offspot=offspot, ROIrow=ROIrow, ROIcol=ROIcol, pctr=pctr, pctg=pctg, pctb=pctb, $
       plotroi=plotroi, multsz=multsz, interp=interp, refined=refined

  WSET, drawID
  
  if n_elements(param_struct) gt 0 then begin
      if keyword_set(refined) then begin
        ;param=param_struct.rparam 
        param=csi_param.rparam 
      endif else begin
        ;param=param_struct.param
        param=csi_param.param
      endelse
  endif
  if n_elements(browse_struct) gt 0 then begin
    if keyword_set(refined) then begin
      browse=csi_browse.rbrowse
    endif else begin
      browse=csi_browse.browse
    endelse
  endif
  
  if keyword_set(where) then begin
    
    imageR=param[*,*,[where(strmatch(param_struct.band_names,red+'*'))]]
    imageG=param[*,*,[where(strmatch(param_struct.band_names,green+'*'))]]
    imageB=param[*,*,[where(strmatch(param_struct.band_names,blue+'*'))]]
    btsimageR=bytscl(imageR, min(imageR), max(imageR(where(imageR ne 65535.))))
    btsimageG=bytscl(imageG, min(imageG), max(imageG(where(imageG ne 65535.))))
    btsimageB=bytscl(imageB, min(imageB), max(imageB(where(imageB ne 65535.))))
    
    
  endif else begin
    if keyword_set(browse_struct) then begin
    
   ;   imageR=reform(browse_struct.browse[0,*,*,red])
   ;   imageG=reform(browse_struct.browse[1,*,*,red])
  ;    imageB=reform(browse_struct.browse[2,*,*,red])
      imageR=reform(browse[0,*,*,red])
      imageG=reform(browse[1,*,*,red])
      imageB=reform(browse[2,*,*,red])
      btsimageR=bytscl(imageR, min(imageR), max(imageR(where(imageR ne 65535.))))
      btsimageG=bytscl(imageG, min(imageG), max(imageG(where(imageG ne 65535.))))
      btsimageB=bytscl(imageB, min(imageB), max(imageB(where(imageB ne 65535.))))
     
      
    endif else begin
      ;default 3-sigma stretch
      if not(keyword_set(pctr)) then begin
        pctr=3
      endif
      if not(keyword_set(pctg)) then begin
        pctg=3
      endif
      if not(keyword_set(pctb)) then begin
        pctb=3
      endif
      imageR=param[*,*,[where(strmatch(param_struct.band_names,red+'*'))]]
      imageG=param[*,*,[where(strmatch(param_struct.band_names,green+'*'))]]
      imageB=param[*,*,[where(strmatch(param_struct.band_names,blue+'*'))]]

      ;apply selected percent stretch
      
      btsimageR=csi_image_percent_stretch(imageR, percent=pctr)
      btsimageG=csi_image_percent_stretch(imageG, percent=pctg)
      btsimageB=csi_image_percent_stretch(imageB, percent=pctb)
       
    endelse
    
  endelse
  
  
  width=(size(btsimageR))[1]
  height=(size(btsimageR))[2]
  
  
  ; Overlay all saved ROIs if set to be displayed

  if n_elements(tag_names(plotroi)) gt 1 then begin
    
    
    for i=0, ((size(plotroi))[1]-1) do begin
      colON=plotroi[i].roion_col
      rowON=plotroi[i].roion_row
      cl=fix((plotroi[i].roisz_col)/2)
      rw=fix((plotroi[i].roisz_row)/2)
      
      b=rowON-rw-1
      c=rowON+rw-1
      d=colON-cl-1
      e=colON+cl-1
      
      btsimageR[d:e,b:c]=long((strsplit(plotroi[i].color, /extract))[0])
      btsimageG[d:e,b:c]=long((strsplit(plotroi[i].color, /extract))[1])
      btsimageB[d:e,b:c]=long((strsplit(plotroi[i].color, /extract))[2])
    endfor
    
  endif
  
  
  ; Overlay ROIs if they have been defined
  if keyword_set(onspot) then begin
    if (onspot[0]) gt 0 then begin
      colON=onspot[0]
      rowON=onspot[1]
      cl=fix(ROIcol/2)
      rw=fix(ROIrow/2)
      
      b=rowON-rw-1
      c=rowON+rw-1
      d=colON-cl-1
      e=colON+cl-1
      
      if (b lt 0) or (c ge height) or (d lt 0) or (e ge width) then begin ; catch for clicking outside box
        btsimageR=btsimageR
        btsimageG=btsimageG
        btsimageB=btsimageB
      endif else begin
        btsimageR[d:e,b:c]=254
        btsimageG[d:e,b:c]=0
        btsimageB[d:e,b:c]=0
      endelse
      
    endif
  endif
  
  if keyword_set(offspot) then begin
    if (offspot[0]) gt 0 then begin
      colOFF=offspot[0]
      rowOFF=offspot[1]
      cl=fix(ROIcol/2)
      rw=fix(ROIrow/2)
      
      f=rowOFF-rw-1
      g=rowOFF+rw-1
      h=colOFF-cl-1
      hh=colOFF+cl-1
      if (f lt 0) or (g ge height) or (h lt 0) or (hh ge width) then begin ; catch for clicking outside box
        btsimageR=btsimageR
        btsimageG=btsimageG
        btsimageB=btsimageB
      endif else begin
        btsimageR[h:hh,f:g]=0
        btsimageG[h:hh,f:g]=254
        btsimageB[h:hh,f:g]=0
      endelse
      
    endif
  endif
  
  ;device, get_screen_size=screen_size
      xsizeimg=multsz*(size(btsimageR))[1]
      ysizeimg=multsz*(size(btsimageR))[2]
      
      
  if keyword_set(interp) then begin
    btsimageR2=congrid(btsimageR, xsizeimg, ysizeimg, /interp)
    btsimageG2=congrid(btsimageG, xsizeimg, ysizeimg, /interp)
    btsimageB2=congrid(btsimageB, xsizeimg, ysizeimg, /interp)
  endif else begin
    btsimageR2=congrid(btsimageR, xsizeimg, ysizeimg)
    btsimageG2=congrid(btsimageG, xsizeimg, ysizeimg)
    btsimageB2=congrid(btsimageB, xsizeimg, ysizeimg)    
  endelse
  ;EXPAND, btsimageR, xsizeimg, ysizeimg, btsimageR2
  ;EXPAND, btsimageG, xsizeimg, ysizeimg, btsimageG2
  ;EXPAND, btsimageB, xsizeimg, ysizeimg, btsimageB2
  
  btimage=[[[btsimageR2]],[[btsimageG2]],[[btsimageB2]]]
  
  tvscl, btimage, /order, true=3
  
END