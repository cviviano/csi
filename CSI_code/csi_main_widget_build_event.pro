;******************************************************************
PRO csi_main_widget_build_event, ev
   COMMON CSIcommon, csi_image, csi_param, csi_browse, csi_ddr;, param_struct, browse_struct, ddr_struct, image_struct;, browsef,image_struct

  Widget_Control, ev.id, get_uvalue=uvalueset
    if n_elements(uvalueset) gt 0 then isit=uvalueset
  Widget_Control, ev.top, get_uvalue=infoptr
  
;******************************************************************                     
;1) IMPORT INFO STRUCTURE
info=*infoptr
print, 'event'
          range=info.range
          csi_table_struct=info.csi_table_struct
          ;image_struct=*(info.img_str)
       ;   image_struct=*image_struct
          image_struct=info.image_struct
          browse_struct=info.browse_struct
          param_struct=info.param_struct
          ddr_struct=info.ddr_struct
;2) SET AND GET WIDGET PARAMETERS
      
    ;Get RGB for parameter display
    Widget_Control, info.R_par, Get_Value=droplistValues
    info.redp=droplistValues[Widget_Info(info.R_par, /DropList_Select)]
    Widget_Control, info.G_par, Get_Value=droplistValues
    info.greenp=droplistValues[Widget_Info(info.G_par, /DropList_Select)]
    Widget_Control, info.B_par, Get_Value=droplistValues
    info.bluep=droplistValues[Widget_Info(info.B_par, /DropList_Select)]
    Widget_Control, info.BRZ_par, Get_Value=droplistValues
    info.brzp=droplistValues[Widget_Info(info.BRZ_par, /DropList_Select)]
    
    ;Get percent for stretches
    Widget_Control, info.Rpercent, Get_Value=droplistValues
    info.pctr=droplistValues[Widget_Info(info.Rpercent, /DropList_Select)]
    Widget_Control, info.Gpercent, Get_Value=droplistValues
    info.pctg=droplistValues[Widget_Info(info.Gpercent, /DropList_Select)]
    Widget_Control, info.Bpercent, Get_Value=droplistValues
    info.pctb=droplistValues[Widget_Info(info.Bpercent, /DropList_Select)]  
    
    ;Get ROI column/row sizes
    
    Widget_Control, info.ROI_r, Get_Value=droplistValues
    info.roi_row=droplistValues[Widget_Info(info.ROI_r, /DropList_Select)]

    Widget_Control, info.ROI_c, Get_Value=droplistValues
    info.roi_col=droplistValues[Widget_Info(info.ROI_c, /DropList_Select)]
    
      
          if Widget_Info(info.colseton, /Button_Set) eq 1 then info.alignset='On' else info.alignset='Off'
          if Widget_Info(info.dispseton, /Button_Set) eq 1 then info.disproiset='On' else info.disproiset='Off'
          if Widget_Info(info.offsetcorron, /Button_Set) eq 1 then info.offset='Yes' else info.offset='No'
          if Widget_Info(info.avgtypmean, /Button_Set) eq 1 then begin
              info.typeavg='Mean'
              avgtyp='mean'
            endif else begin
              info.typeavg='Median'
              avgtyp='median'
            endelse
            
          ;wavelength range
          if Widget_Info(info.joined, /Button_Set) eq 1 then info.range='joined'
          if Widget_Info(info.visswir, /Button_Set) eq 1 then info.range='visswir'
          if Widget_Info(info.vis, /Button_Set) eq 1 then info.range='vis'
          if Widget_Info(info.ir, /Button_Set) eq 1 then info.range='ir'
          if Widget_Info(info.irzoom, /Button_Set) eq 1 then info.range='irzoom'

;******************************************************************
;3) SET AND GET WIDGET PARAMETERS IF EVENT OCCURS

    if n_elements(isit) gt 0 then begin
      if isit eq 'brwz' then info.last='brwz'
      if isit eq 'param' then info.last='param'
    ;Get and set scroll for displays to match      
            if isit eq 'imgimgu' then begin
              Widget_Control, info.Img_img, Get_Draw_View=currentview
              Widget_Control, info.Img_par, Set_Draw_View=currentview
            endif
            if isit eq 'imgparu' then begin
              Widget_Control, info.Img_par, Get_Draw_View=currentview
              Widget_Control, info.Img_img, Set_Draw_View=currentview
            endif
;   ;Get ROI size
;      if isit eq 'roi_r_size' then begin
;        Widget_Control, info.ROI_r, Get_Value=rowsize_select
;        if rowsize_select MOD 2 eq 0 then rowsize_select++
;        Widget_Control, info.ROI_r, Set_Value=rowsize_select
;        info.roi_row=rowsize_select
;      endif
;      if isit eq 'roi_c_size' then begin
;        Widget_Control, info.ROI_c, Get_Value=colsize_select
;        if colsize_select MOD 2 eq 0 then colsize_select++
;        Widget_Control, info.ROI_r, Set_Value=colsize_select
;        info.roi_col=colsize_select
;      endif
   ;Get preset row/col defined           
           if isit eq 'setrowcol' then begin
             Widget_Control, info.roi_nrowwid, Get_Value=currentnrowwid
             Widget_Control, info.roi_ncolwid, Get_Value=currentncolwid
             Widget_Control, info.roi_drowwid, Get_Value=currentdrowwid
             Widget_Control, info.roi_dcolwid, Get_Value=currentdcolwid
             info.rowON=currentnrowwid
             info.colON=currentncolwid
             info.rowOFF=currentdrowwid
             info.colOFF=currentdcolwid
           endif  
      ;deselect all mineral buttons if "clear" is clicked                         
      if isit eq 'clear' then begin
        for i=0, n_elements(info.MICA_data.names)-1 do begin
          tagloc=where(tag_names(info) eq STRUPCASE(info.MICA_data.names[i]))
          Widget_Control, info.(tagloc), SET_BUTTON=0
        endfor
        ;deselect all morphology buttons if "clear" is clicked
      endif
      if isit eq 'mclear' then begin
        for i=0, n_elements(info.morphnames)-1 do begin
          tagloc=where(tag_names(info) eq STRUPCASE(info.morphnames[i]))
          Widget_Control, info.(tagloc), SET_BUTTON=0
        endfor
      endif
      
    endif
  
  ;Control clicking events x/y coordinates for ROI
  tn=tag_names(ev)
  matchtag = where(tn eq 'X')
  presstag=where(tn eq 'PRESS')
  
  xsizemult=1./info.multsz
  ysizemult=1./info.multsz
  
;******************************************************************
;4) BUTTON PRESSED

  ;one button pressed
  if (n_elements(matchtag) gt 0) or (info.colON gt 0) then begin
            if (presstag ge 0) or (info.colON gt 0) then begin
              if (presstag ge 0) then begin
                if (ev.press eq 1) then begin
                  colON=xsizemult*(ev.x)
                  rowON=image_struct.arraysize[3]-ysizemult*ev.y
                  info.colON=colON
                  info.rowON=rowON
                  onspot=[colON,rowON]
              endif
            endif else begin
              colON=info.colON
              rowON=info.rowON
              info.colON=colON
              info.rowON=rowON
              onspot=[colON,rowON]
            endelse
          endif
    
          if (presstag ge 0) or (info.colOFF gt 0)then begin
            if (presstag ge 0) then begin
              if (ev.press eq 4) then begin
                colOFF=xsizemult*(ev.x)
                rowOFF=image_struct.arraysize[3]-ysizemult*ev.y
                
                info.colOFF=colOFF
                info.rowOFF=rowOFF
                offspot=[colOFF,rowOFF]
              endif
            endif else begin
              colOFF=info.colOFF
              rowOFF=info.rowOFF
              offspot=[colOFF,rowOFF]
              info.colOFF=colOFF
              info.rowOFF=rowOFF
              offspot=[colOFF,rowOFF]
            endelse
          endif
    
    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    ;once both numerator and denominator are set, begin plotting:
    
    if (info.colON gt 0) and (info.colOFF gt 0) then begin  ;not the best...oh well
    
      ;set x/y locator to current value
      Widget_Control, info.roi_nrowwid, Set_Value=strtrim(string(long(info.rowON)),1)
      Widget_Control, info.roi_ncolwid, Set_Value=strtrim(string(long(info.colON)),1)
      Widget_Control, info.roi_drowwid, Set_Value=strtrim(string(long(info.rowOFF)),1)
      Widget_Control, info.roi_dcolwid, Set_Value=strtrim(string(long(info.colOFF)),1)
      
      ROIrow=long(info.roi_row)
      ROIcol=long(info.roi_col)
      
      ONinfo=[long(info.colON), long(info.rowON)]
      OFFinfo=[long(info.colOFF), long(info.rowOFF)]
      
      if info.alignset eq 'On' then begin
        info.colOFF=info.colON
        OFFinfo=[long(info.colON), long(info.rowOFF)] ; reset alignment of column for extraction
      endif
      
;      extractspectraptr=csi_extract_spectra(ONinfo, OFFinfo, ROIrow, ROIcol, image_struct.wvs, avgtyp, info.img_str); image_struct.image)


      extractspectraptr=csi_extract_spectra(ONinfo, OFFinfo, ROIrow, ROIcol, image_struct.wvs, avgtyp, image_struct, csi_image); image_struct.image)
      extr=*extractspectraptr
      
      info.specton=extr.specton
      specton=extr.specton
      info.spectoff=extr.spectoff
      spectoff=extr.spectoff
     
      if info.offset eq 'Yes' then begin
        color_rgb = transpose([[  0,  0  ,0], $ ;black
          [255,255,255], $ ;white
          [255,  0,  0], $ ;red
          [  0,255,  0], $ ;green
          [  0,  0,255], $ ;blue
          [255,255,  0], $ ;yellow
          [  0,255,255], $ ;cyan
          [255,  0,255], $ ;magenta
          [240,240,240]])  ;really light grey
        color_hex = color_rgb_hex(color_rgb)
        
        correct_spec1=transpose(double(fltarr(n_elements(image_struct.wvs),1)))
        correct_offset, double(image_struct.wvs), double(specton), 1, correct_spec=correct_spec1, color_hex=color_hex;, /loud
        specton=correct_spec1
        correct_spec1=transpose(double(fltarr(n_elements(image_struct.wvs),1)))
        correct_offset, double(image_struct.wvs), double(spectoff), 1, correct_spec=correct_spec1, color_hex=color_hex;, /loud
        spectoff=correct_spec1
        
      endif
      
   ;   xmoreoff=info.image_struct.arraysize[0]+10
   ;   ymoreoff=2*info.image_struct.arraysize[1]+80
      
      ;plot up data in gui
      
      drawIDratio=info.drawIDratio
      WSET, drawIDratio
        spectratio=[specton/spectoff]
        info.specton=specton
        info.spectoff=spectoff

      bblindex=where(image_struct.bbl ne 0)   ;CAN YOU PUT ALL OF THIS IN THE WIDGET BUILD???
      spectratio_sub=spectratio[bblindex]
      wllib_sub=image_struct.wvs[bblindex]
      specton_sub=specton[bblindex]
      spectoff_sub=spectoff[bblindex]
      
      nanindex1=where(specton_sub lt 1.)
      spectratio_sub=spectratio_sub[nanindex1]
      wllib_sub=wllib_sub[nanindex1]
      specton_sub=specton_sub[nanindex1]
      spectoff_sub=spectoff_sub[nanindex1]
      
      nanindex2=where(spectoff_sub lt 1.)
      spectratio_sub=spectratio_sub[nanindex2]
      wllib_sub=wllib_sub[nanindex2]
      specton_sub=specton_sub[nanindex2]
      spectoff_sub=spectoff_sub[nanindex2]
      
   if strupcase(image_struct.units) eq 'NANOMETERS' then begin    
     if range eq 'vis' then xranges=[min(wllib_sub), 1000.]
     if range eq 'ir' then xranges=[1060., 2625.]
     if range eq 'joined' then xranges=[min(wllib_sub),max(wllib_sub)]
     if range eq 'visswir' then xranges=[min(wllib_sub), 2625.]
     if range eq 'irzoom' then xranges=[1850., 2625.]
   endif else begin  ;microns
     if range eq 'vis' then xranges=[min(wllib_sub), 1.]
     if range eq 'ir' then xranges=[1.060, 2.625]
     if range eq 'joined' then xranges=[min(wllib_sub),max(wllib_sub)]
     if range eq 'visswir' then xranges=[min(wllib_sub), 2.625]
     if range eq 'irzoom' then xranges=[1.850, 2.625]
   endelse
   ;  if range eq 'vis' then xranges=[min(info.wvt_subset), 1.]
   ;  if range eq 'ir' then xranges=[1.060, 2.625]
   ;  if range eq 'joined' then xranges=[min(info.wvt_subset),max(info.wvt_subset)]
   ;  if range eq 'visswir' then xranges=[min(info.wvt_subset), 2.625]
   ;  if range eq 'irzoom' then xranges=[1.850, 2.625]
   
    lxranges=xranges

      if n_elements(wllib_sub) le 1 then begin
        wllib_sub=[0,0,0]
        spectratio_sub=[0,0,0]
        specton_sub=[0,0,0]
        spectoff_sub=[0,0,0]
      endif
      device,decomposed=0
      loadct, 39, /silent
      
      ;Plot Ratioed Spectra
      plot, wllib_sub, spectratio_sub, xrange=[xranges[0],xranges[1]], $; yrange=[min(spectratio_sub), max(spectratio_sub)], $
        color=0, background=255, thick=2, xthick=2, ythick=2, line=0, $
        xtitle='wavelength', /normal, charsize=0.8, charthick=1.5, yticklen=0, xmargin=[0.02,0.02], ymargin=[3.5,0.1], $
        /ynozero, xstyle=1, ystyle=1
        
      drawIDonandoff=info.drawIDonandoff
      WSET, drawIDonandoff
      
      ;Plot Extracted On/OFF spectra
      yspecton_sub=specton_sub[value_locate(wllib_sub, xranges[0]):value_locate(wllib_sub, xranges[1])]
      yspectoff_sub=spectoff_sub[value_locate(wllib_sub, xranges[0]):value_locate(wllib_sub, xranges[1])]
      ymin=min([yspecton_sub,yspectoff_sub])
      ymax=max([yspecton_sub,yspectoff_sub])
      
      plot, wllib_sub, specton_sub, xrange=[xranges[0], xranges[1]], yrange=[ymin,ymax],$
        color=0, background=255, xthick=2, ythick=2, line=0, $
        xtitle='wavelength', /normal, charsize=0.8, charthick=1.5, yticklen=0, xmargin=[0.02,0.02], ymargin=[3.5,0.1], $
        /ynozero, xstyle=1, ystyle=1; POS=[0.01, 0.01, 0.99, 0.99]
        
      oplot, wllib_sub, specton_sub, color=254, line=0, thick=2
      oplot, wllib_sub, spectoff_sub, color=150, line=0, thick=2
      
      ;Plot MICA spectra with ratioed spectra
      ; See what mineral buttons are clicked ON
      
      if (info.colON gt 0) and (info.colOFF gt 0) then begin
        libindex=info.libindex
        for i=0, n_elements(info.MICA_data.names)-1 do begin
          tagloc=where(tag_names(info) eq STRUPCASE(info.MICA_data.names[i]))
          if widget_info(info.(tagloc), /button_set) eq 1 then libindex[i]=1
        endfor
        
        ; See what morphology buttons are clicked ON
        morphindex=info.morphindex
        for i=0, n_elements(info.morphnames)-1 do begin
          tagloc=where(tag_names(info) eq STRUPCASE(info.morphnames[i]))
          if widget_info(info.(tagloc), /button_set) eq 1 then morphindex[i]=1
        endfor
        
        ;force range to be between 0 and 1 and rescale both the crism data and lab data
        yspectratio_sub=spectratio_sub[value_locate(wllib_sub, xranges[0]):value_locate(wllib_sub, xranges[1])]

        ymax=max(yspectratio_sub)
        
        holder=yspectratio_sub/ymax
        resizespectratio_sub=spectratio_sub/ymax
        ymin=min(holder)
        
        resizespectratio_sub=1-((1./(1.-ymin))*(1-resizespectratio_sub))
        
        drawIDLAB=info.drawIDLAB
        WSET, drawIDLAB
        
        device,decomposed=0
        plot, wllib_sub, resizespectratio_sub, xrange=[xranges[0],xranges[1]],yrange=[0,1], $
          color=0, background=255, thick=2, xthick=2, ythick=2, line=0, $
          xtitle='wavelength', /normal, charsize=0.8, charthick=1.5, yticklen=0, xmargin=[0.02,0.02], ymargin=[3.5,0.1], $
          /ynozero, xstyle=1, ystyle=1
          
          
        drawIDMICA=info.drawIDMICA
        WSET, drawIDMICA
        
        plot, wllib_sub, resizespectratio_sub, xrange=[xranges[0],xranges[1]],yrange=[0,1], $
          color=0, background=255, thick=2, xthick=2, ythick=2, line=0, $
          xtitle='wavelength', /normal, charsize=0.8, charthick=1.5, yticklen=0, xmargin=[0.02,0.02], ymargin=[3.5,0.1], $
          /ynozero, xstyle=1, ystyle=1
          
        if total(libindex) gt 0 then begin
        
          sublibindex=where(libindex eq 1)
          totplots=n_elements(sublibindex)
          WSET, drawIDLAB
          
          for i=0, totplots-1 do begin
            labratio=info.LAB_data.spectra[*, sublibindex[i]]
            ylabratio=labratio[value_locate(info.Lab_data.wvt, lxranges[0]):value_locate(info.Lab_data.wvt, lxranges[1])]
            ymax=max(ylabratio)
            holder=ylabratio/ymax
            resizelabratio=labratio/ymax
            ymin=min(holder)
            device,decomposed=1
            resizelabratio=1-((1./(1.-ymin))*(1-resizelabratio))
            color_hex = color_rgb_hex(info.colorindex[sublibindex[i],*])
            
            oplot, info.Lab_data.wvt, resizelabratio, color=color_hex, line=0, thick=2
          endfor
          
          WSET, drawIDMICA
          for i=0, totplots-1 do begin
            micaratio_bb=info.MICA_data.spectra[*,sublibindex[i]]
            micaratio_sub=fltarr(n_elements(info.wvt_subset))
            
    ;        if cspsamp eq 0 then wllibmica=round(wllibmica*1000)/1000. 
              for j=0, n_elements(info.wvt_subset)-1 do begin
                indexwvts=where(info.MICA_data.wvt eq info.wvt_subset[j])
                micaratio_sub[j]=micaratio_bb[indexwvts]
              endfor
            nanindex1=where(micaratio_sub lt 5.)
            micaratio_sub=micaratio_sub[nanindex1]
            mica_wvt_subset=info.wvt_subset[nanindex1]
           ; ymicaratio=micaratio_sub[value_locate(info.wvt_subset, xranges[0]):value_locate(info.wvt_subset, xranges[1])]
            ymicaratio=micaratio_sub[value_locate(micaratio_sub, xranges[0]):value_locate(micaratio_sub, xranges[1])]
            ymax=max(ymicaratio)
            
            holder=ymicaratio/ymax
            resizemicaratio=micaratio_sub/ymax
            ymin=min(holder)
            device,decomposed=1
            resizemicaratio=1-((1./(1.-ymin))*(1-resizemicaratio))
            color_hex = color_rgb_hex(info.colorindex[sublibindex[i],*])
            oplot, mica_wvt_subset, resizemicaratio, color=color_hex, line=0, thick=2
          endfor
          
        endif
      endif
    endif
    ;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  endif
  
  ;end of button pressed
;******************************************************************
;5) DRAWING?

  if info.disproiset eq 'On' then begin
    plotroi=*info.d0
  endif else begin
    plotroi={x:0}
  endelse
  
  ; draw ROIs onto images
  *infoptr=info
  drawID=info.drawID
  
  if n_elements(info.last) ge 1 then begin
    if info.last eq 'brwz' then begin
      Rbrws=info.brzp
      Rbrws=where(browse_struct.browse_names eq Rbrws)
    endif else begin
      red=info.redp
      green=info.greenp
      blue=info.bluep
    endelse
  endif
  
  ROIrow=long(info.roi_row)
  ROIcol=long(info.roi_col)
  
  drawID2=info.drawID2
  
  onspot=[info.colON,info.rowON]
  offspot=[info.colOFF,info.rowOFF]
  
  if n_elements(info.last) ge 1 then begin
      if info.last eq 'brwz' then begin
              if n_elements(browse_struct.browse_names) ne 1 then begin      
                
        csi_display_parameter, drawID, Rbrws, Rbrws, Rbrws, csi_browse=csi_browse, browse_struct=browse_struct, onspot=onspot, $
                  offspot=offspot, ROIrow=ROIrow, ROIcol=ROIcol, plotroi=plotroi, multsz=info.multsz
        
              endif
      endif else begin
      
      if widget_info(info.rbox, /button_set) eq 1 then begin; See if 'Refined' parameters are clicked ON
        csi_display_parameter, drawID, red, green, blue, csi_param=csi_param, param_struct=param_struct, onspot=onspot, $
          offspot=offspot, ROIrow=ROIrow, ROIcol=ROIcol, pctr=info.pctr, pctg=info.pctg, pctb=info.pctb, plotroi=plotroi, multsz=info.multsz, /refined
          
      endif else begin; Or if 'Refined' parameters are clicked OFF
        csi_display_parameter, drawID, red, green, blue, csi_param=csi_param, param_struct=param_struct, onspot=onspot, $
          offspot=offspot, ROIrow=ROIrow, ROIcol=ROIcol, pctr=info.pctr, pctg=info.pctg, pctb=info.pctb, plotroi=plotroi, multsz=info.multsz
        
          if strmid(image_struct.crism_class_type, 1, 1) eq 'S' then begin ;mapping mode
            drawID4=info.drawID4
            screensize=get_screen_size()
            zmultsz=((screensize[1])/2.)/(image_struct.arraysize[2]+1000)
            ysizez=zmultsz*image_struct.arraysize[2]
            resizescro=((image_struct.arraysize[2])/(ysizez))
            
         csi_display_parameter, drawID4, red, green, blue, csi_param=csi_param, param_struct=param_struct,  $
              plotroi={x:0}, ROIrow=ROIrow, ROIcol=ROIcol, pctr=info.pctr, pctg=info.pctg, pctb=info.pctb, plotroi=plotroi, multsz=info.multsz, /interp
            
          endif
      endelse
    endelse
  endif
  
  if image_struct.file_type eq 2 then begin ;joined product
    imgTAN=where(browse_struct.browse_names eq 'TAN')
    csi_display_parameter, drawID2, imgTAN, imgTAN, imgTAN, csi_browse=csi_browse, browse_struct=browse_struct, onspot=onspot, $
      offspot=offspot, ROIrow=ROIrow, ROIcol=ROIcol, plotroi=plotroi, multsz=info.multsz
  endif 
  if (image_struct.file_type eq 1) then begin
    csi_display_parameter, drawID, 'R2529', 'R1506', 'R1080', csi_param=csi_param, param_struct=param_struct, pctr=5,pctg=5,pctb=5, onspot=onspot, $
      offspot=offspot, ROIrow=ROIrow, ROIcol=ROIcol, plotroi=plotroi, multsz=info.multsz
  endif
  if image_struct.file_type eq 0 then begin
    csi_display_parameter, drawID, 'R600', 'R530', 'R440', csi_param=csi_param, param_struct=param_struct, pctr=5,pctg=5,pctb=5, onspot=onspot, $
      offspot=offspot, ROIrow=ROIrow, ROIcol=ROIcol, plotroi=plotroi, multsz=info.multsz
  endif
  
  if (n_elements(isit) gt 0) and (info.colON gt 0) and (info.colOFF gt 0) then begin
    if isit eq 'plot' then begin
      device, decomposed=1
      
      nameS1='S1'+':['+strtrim(string(fix(float(info.colON))),2)+','+strtrim(string(fix(float(info.rowON))),2)+']'
      nameS2='S2'+':['+strtrim(string(fix(float(info.colOFF))),2)+','+strtrim(string(fix(float(info.rowOFF))),2)+']'
      nameRatio='S1/S2'+':('+strtrim(info.roi_col,2)+'x'+strtrim(info.roi_row,2)+' ROI)'
      
      envi_plot_data, image_struct.wvs, [[specton],[spectoff],[specton/spectoff]], plot_names=[nameS1,nameS2,nameRatio], bbl=image_struct.bbl, plot_colors=[2, 3, 0], $
        xtitle='wavelength (nm)', ytitle='CRISM I/F', plot_title=info.image_ancillary_struct.crism_fname_abbrev; , base=wwin
    endif
    
    if isit eq 'libplot' then begin
      if n_elements(sublibindex) gt 0 then begin
        device, decomposed=1
        
        nameRatio='S1/S2'+' s1:['+strtrim(info.colON,2)+','+strtrim(info.rowON,2)+']'+',s2:['+strtrim(info.colOFF,2)+ $
          ','+strtrim(info.rowOFF,2)+']'+':('+strtrim(info.roi_col,2)+'x'+strtrim(info.roi_row,2)+' ROI)'
          
        labratio_array=info.LAB_data.spectra[*,sublibindex]
        micaratio_array=info.MICA_data.spectra[*,sublibindex]
        
        nameslab=info.LAB_spectra_names[sublibindex]
        namesmica=info.MICA_data.names[sublibindex]

        bbl_lab=(intarr(n_elements(info.Lab_data.wvt)))+1  ;bad lab band - last band
        bbl_lab[n_elements(info.Lab_data.wvt)-1]=0
        
        envi_plot_data, info.Lab_data.wvt, labratio_array, plot_names=[nameslab], plot_colors=sublibindex+2, $
          xtitle='wavelength (nm)', ytitle='CRISM I/F (MICA) and Laboratory Reflectance', plot_title=info.image_ancillary_struct.crism_fname_abbrev, base=base, bbl=bbl_lab
          
        ;bad MICA bad - indiv.
        for i=0, ((size(micaratio_array, /n_elements))/((size(micaratio_array))[1]))-1 do begin
          bbl_mica=image_struct.bbl
          badval=where(micaratio_array[*,i] gt 100)
          bbl_mica[badval]=0
          wlliblab2=info.Lab_data.wvt
          sp_import, base, wlliblab2, micaratio_array[*,i], name=['MICA_'+namesmica[i]], color=[(sublibindex[i]+2)],bbl=bbl_mica
        endfor
        
      endif
    endif
  endif
  ;...................................................................
  ;Extract out data
  
  if n_elements(isit) gt 0 then begin
    if isit eq 'extract' then begin
      if (info.colON gt 0) and (info.colOFF gt 0) then begin
        avgtyp2='mean'
        
        ;extractddrlat=csi_extract_spectra(ONinfo, OFFinfo, ROIrow, ROIcol, 0, avgtyp2, info.ddr_struct.ddr[3,*,*])
        ;extractddrlon=csi_extract_spectra(ONinfo, OFFinfo, ROIrow, ROIcol, 0, avgtyp, info.ddr_struct.ddr[4,*,*])
        ;extractddrelev=csi_extract_spectra(ONinfo, OFFinfo, ROIrow, ROIcol, 0, avgtyp, info.ddr_struct.ddr[9,*,*], /min, /max)
        
        extractddrlat=csi_extract_spectra(ONinfo, OFFinfo, ROIrow, ROIcol, 0, avgtyp2, csi_ddr[3,*,*])
        extractddrlon=csi_extract_spectra(ONinfo, OFFinfo, ROIrow, ROIcol, 0, avgtyp, csi_ddr[4,*,*])
        extractddrelev=csi_extract_spectra(ONinfo, OFFinfo, ROIrow, ROIcol, 0, avgtyp, csi_ddr[9,*,*], /min, /max)       
         
        ddrlatextractddrlat=*extractddrlat
        ddrlonextractddrlon=*extractddrlon
        ddrelevextractddrelev=*extractddrelev
        
        ddrlat=ddrlatextractddrlat.specton
        ddrlon=ddrlonextractddrlon.specton
        ddrelev=ddrelevextractddrelev.specton
        
        extelevmin=ddrelevextractddrelev.min
        extelevmax=ddrelevextractddrelev.max
        
        if n_elements(sublibindex) gt 0 then begin
          names=info.MICA_data.names[sublibindex]
        endif else begin
          names=''
        endelse
        
        if total(morphindex) gt 0 then submorphindex=where(morphindex eq 1)
        
        if n_elements(submorphindex) gt 0 then begin
          mnames=info.morphnames[submorphindex]
        endif else begin
          mnames=''
        endelse
        
        info.ddrlat=ddrlat
        info.ddrlon=ddrlon
        info.ddrelev=ddrelev
        
        widget_control, info.commentbox, GET_VALUE=commentboxf
        d0=*info.d0
        d1=csi_table_struct
        numset=info.num+1
        info.num=numset
        
        d1.Num=strtrim(numset,2)
        d1.mineralogy=strjoin(names, ' ')
        d1.morphology=strjoin(mnames, ' ')
        d1.comment=commentboxf
        if d1.mineralogy eq '' then d1.mineralogy='nd'
        if d1.morphology eq '' then d1.morphology='nd'
        if d1.comment eq '' then d1.comment='nd'
        
        d1.ID=strtrim((strtrim(info.image_ancillary_struct.crism_filename,2))+'_'+info.image_ancillary_struct.crism_counter,2)
        d1.lon=strtrim(ddrlon,2)
        d1.lat=strtrim(ddrlat,2)
        d1.elev=strtrim(ddrelev,2)
        d1.ROIon_row=strtrim(ONinfo[1],2)
        d1.ROIon_col=strtrim(ONinfo[0],2)
        d1.ROIoff_row=strtrim(OFFinfo[1],2)
        d1.ROIoff_col=strtrim(OFFinfo[0],2)
        d1.ROIsz_row=strtrim(ROIrow,2)
        d1.ROIsz_col=strtrim(ROIcol,2)
        d1.ELEVmin=strtrim(extelevmin,2)
        d1.ELEVmax=strtrim(extelevmax,2)
        
        ;...................................................................
        ;Set the dominant phase color
        if n_elements(sublibindex) gt 1 then begin
  ;        prioritybase=widget_auto_base(title='Set Color Priority')
  ;        priorityset1=widget_pmenu(prioritybase, prompt='Spectrally-dominant phase:   ', list=names, uvalue='prior1', /auto, xsize=400, default=0)
  ;        priorityset2=widget_pmenu(prioritybase, prompt='Secondary phase:   ', list=names, uvalue='prior2', /auto, xsize=400, default=1)
          
          WIDGET_CONTROL, ev.top, map=0
          
          priorresult=auto_wid_mng(prioritybase)
          
          if (priorresult.accept eq 1) then begin
            dominant=names[priorresult.prior1]
            secondary=names[priorresult.prior2]
          endif
          WIDGET_CONTROL, ev.top, map=1
          colindex=where(dominant eq info.MICA_data.names)
          colindex2=where(secondary eq info.MICA_data.names)
          d1.color=' '+strtrim(string(long(info.colorindex[colindex,0])),1)+' '+strtrim(string(long(info.colorindex[colindex,1])),1)+' '+strtrim(string(long(info.colorindex[colindex,2])),1)
          d1.colorline=' '+strtrim(string(long(info.colorindex[colindex2,0])),1)+' '+strtrim(string(long(info.colorindex[colindex2,1])),1)+' '+strtrim(string(long(info.colorindex[colindex2,2])),1)
        endif else begin
          if  n_elements(sublibindex) gt 0 then begin
            d1.color=' '+strtrim(string(long(info.colorindex[sublibindex,0])),1)+' '+strtrim(string(long(info.colorindex[sublibindex,1])),1)+' '+strtrim(string(long(info.colorindex[sublibindex,2])),1)
            d1.colorline=' '+strtrim(string(long(info.colorindex[sublibindex,0])),1)+' '+strtrim(string(long(info.colorindex[sublibindex,1])),1)+' '+strtrim(string(long(info.colorindex[sublibindex,2])),1)
          endif else begin
            d1.color=' 0 0 0'
            d1.colorline=' 0 0 0'
          endelse
        endelse
        
        ;...................................................................
        if (numset-1 eq 0.) then begin  ;check for first time around
          concat=ptr_new(d1)
        endif else begin
          concat=ptr_new([d0,d1])
        endelse
        
        info.d0=concat
        
        widget_control, info.table1, SET_VALUE=*info.d0;, INSERT_ROWS=1
      endif
    endif
  endif
  
  ;--------------------------Delete row/s in table  --------------------------
  selection = WIDGET_INFO(info.table1, /TABLE_SELECT)
  
  if total(selection ne 0) then begin;  hasSelection = 1  ELSE hasSelection = 0
    if total(info.selected) gt 1 then begin
      WIDGET_CONTROL, info.table1, USE_TABLE_SELECT=info.selected, background_color=[193,205,193], foreground_color=[0,0,0]  ;reset color to default
    endif
    WIDGET_CONTROL, info.table1, USE_TABLE_SELECT=[0, selection[1], (n_elements(tag_names(*info.d0))-1), selection[3]], background_color=[72,61,139], foreground_color=[255,240,245]  ; set color to selected
    info.selected=[0, selection[1], (n_elements(tag_names(*info.d0))-1), selection[3]]
  endif
  
  if n_elements(isit) gt 0 then begin
    if isit eq 'delete' then begin
    
      totalrows=(size(*info.d0))[1]
      tmparr=indgen(totalrows)
      index1=where(tmparr lt selection[1])
      index2=where(tmparr gt selection[3])
      index=[index1,index2]
      userows=intersect(tmparr, index)
      
      tmp=*info.d0
      if total(userows) eq 0 then begin
      
        subtmp=ptr_new(csi_table_struct)
      endif else begin
        tmp=tmp[userows]
        for i=0, n_elements(tmp.(0))-1 do begin  ;re-number table
          tmp[i].num=strtrim(string(i+1),2);1
        endfor
        info.num=n_elements(tmp.(0))
        subtmp=ptr_new(tmp)
      endelse
      info.d0=subtmp
      widget_control, info.table1, SET_VALUE=*info.d0
      
    endif
    
    ;-------------------------- GO TO function --------------------------
    if isit eq 'goto' then begin
      d0=*info.d0
      if (strsplit(strtrim(d0[selection[1]].ID,2),'_',/regex, /extract, /preserve_null))[0] eq strtrim(info.image_ancillary_struct.crism_fname_abbrev) then begin
        if float(strtrim(d0[selection[1]].ROIsz_row,2)) gt 0 then begin ; make sure not a blank row
        
          d0=*info.d0
          
          currentIndexROIrow=where(strtrim(d0[selection[1]].ROIsz_row,2) eq info.oddonly)
          currentIndexROIcol=where(strtrim(d0[selection[1]].ROIsz_col,2) eq info.oddonly)
          Widget_Control, info.ROI_r, SET_DROPLIST_SELECT=currentIndexROIrow
          Widget_Control, info.ROI_c, SET_DROPLIST_SELECT=currentIndexROIcol
          info.roi_row=strtrim(d0[selection[1]].ROIsz_row,2)
          info.roi_col=strtrim(d0[selection[1]].ROIsz_col,2)
          info.colON=strtrim(d0[selection[1]].ROIon_col,2)
          info.colOFF=strtrim(d0[selection[1]].ROIoff_col,2)
          info.rowON=strtrim(d0[selection[1]].ROIon_row,2)
          info.rowOFF=strtrim(d0[selection[1]].ROIoff_row,2)
          widget_control, info.commentbox, SET_VALUE=d0[selection[1]].comment
          ;clear settings
          for i=0, n_elements(info.MICA_data.names)-1 do begin
            tagloc=where(tag_names(info) eq strtrim(STRUPCASE(info.MICA_data.names[i]),2))
            Widget_Control, info.(tagloc), SET_BUTTON=0
          endfor
          ; set minerals selected
          for i=0, n_elements(info.MICA_data.names)-1 do begin
            tagloc=where(tag_names(info) eq strtrim(STRUPCASE(info.MICA_data.names[i]),2))
            tag=tag_names(info)
            mins=d0[selection[1]].mineralogy
            minsarr=strtrim(STRSPLIT(mins,' ', /EXTRACT),2);1
            for j=0, n_elements(minsarr)-1 do begin
              if tag(tagloc) eq strtrim(STRUPCASE(minsarr[j]),2) then begin
                Widget_Control, info.(tagloc), SET_BUTTON=1
              endif
            endfor
          endfor
          
          ;clear settings
          for i=0, n_elements(info.morphnames)-1 do begin
            tagloc=where(tag_names(info) eq strtrim(STRUPCASE(info.morphnames[i]),2))
            Widget_Control, info.(tagloc), SET_BUTTON=0
          endfor
          ; set morph
          for i=0, n_elements(info.morphnames)-1 do begin
            tagloc=where(tag_names(info) eq strtrim(STRUPCASE(info.morphnames[i]),2))
            tag=tag_names(info)
            morph=d0[selection[1]].morphology
            morpharr=strtrim(STRSPLIT(morph,' ', /EXTRACT),2);1
            for j=0, n_elements(morpharr)-1 do begin
              if tag(tagloc) eq strtrim(STRUPCASE(morpharr[j]),2) then begin
                Widget_Control, info.(tagloc), SET_BUTTON=1
              endif
            endfor
          endfor
          
        endif
      endif else begin
        WIDGET_CONTROL, info.table1, USE_TABLE_SELECT=info.selected, background_color=[254,0,0], foreground_color=[0,0,0]
        WAIT, 0.2
        WIDGET_CONTROL, info.table1, USE_TABLE_SELECT=info.selected, background_color=[72,61,139], foreground_color=[255,240,245]
        
      endelse
    endif
    
    
    ;-------------------------- Text Info --------------------------
    ;if the help button is pushed
    if isit eq 'help' then begin
      helptext = csi_help_text(100)
      helptext = dialog_message(helptext, /information, title='CSI Help File...', /center)
    endif
    
    ;if the browse info button is pushed
    if isit eq 'infobut' then begin
      Rbrws=info.brzp
      Rbrws=where(browse_struct.browse_names eq Rbrws)
      browse_text = csi_browse_text(100, browse_selected=browse_selected, browse_names=browse_struct.browse_names)
      brztext=dialog_message(browse_text, /information, title=browse_struct.browse_names(Rbrws)+' browse product help info...', /center)
    endif
    
    ;if the param info button is pushed
    if isit eq 'infoparam' then begin
      param_text = csi_browse_text(100, param_name_rgb=[info.redp, info.greenp, info.bluep])
        
    ;    r_simp=strjoin(strsplit(info.redp, '_flat', /extract, /regex, /preserve_null))
    ;    g_simp=strjoin(strsplit(info.greenp, '_flat', /extract, /regex, /preserve_null))
    ;    b_simp=strjoin(strsplit(info.bluep, '_flat', /extract, /regex, /preserve_null))
    ;  subparamrtxt=brsarray(where(strmatch(brsarray, '*'+strtrim(r_simp,1)+'*=*') eq 1):(size(brsarray))[1]-1)
    ;  subparamr=subparamrtxt[0:(where(strpos(subparamrtxt, ' ') eq -1))[0]]
    ;  subparamgtxt=brsarray(where(strmatch(brsarray, '*'+strtrim(g_simp,1)+'*=*') eq 1):(size(brsarray))[1]-1)
    ;  subparamg=subparamgtxt[0:(where(strpos(subparamgtxt, ' ') eq -1))[0]]
    ;  subparambtxt=brsarray(where(strmatch(brsarray, '*'+strtrim(b_simp,1)+'*=*') eq 1):(size(brsarray))[1]-1)
    ;  subparamb=subparambtxt[0:(where(strpos(subparambtxt, ' ') eq -1))[0]]
      
      paramtext=dialog_message(param_text, /information, title=' Summary parameter help info...', /center)
    endif
    
  endif
  
  *infoptr=info
  
END


;*****************************Menu Event Handlers:******************************************

PRO widget_quit_event, ev
  WIDGET_CONTROL, ev.id, get_uvalue=uvalueset
  device, decomposed=1
  widget_control, ev.top, get_uvalue=infoptr

  ptr_free, infoptr
  
  WIDGET_CONTROL, ev.TOP, /DESTROY
END

PRO widget_reset_event, ev
  widget_quit_event, ev
  csi_driver
END

PRO widget_addon_event, ev
  
  widget_control, ev.top, get_uvalue=infoptr
  info=*infoptr
  infoholder='/project/crism/users/viviace1/tmp_'+strtrim(string(long(systime(1))),1)+'.csv'
  timeinfoholder=infoholder
  csi_saveas_event, ev
  widget_quit_event, ev
  csi_driver, infoholderset=timeinfoholder
END

