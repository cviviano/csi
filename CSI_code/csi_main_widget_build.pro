;------------------------------------------------------------------------
;Christina Viviano (3/2023)
;
;This is the CSI main widget display.  This code builds the base for the 
;interface that will be populated by selected images.
;
;------------------------------------------------------------------------;
;
;
;
;*************************************************
;MAIN DISPLAY WIDGET 

PRO csi_main_widget_build, image_ancillary_struct=image_ancillary_struct, csi_table_struct=csi_table_struct, multsz=multsz, infoholder=infoholder, $;, img_str=img_str
  image_struct=image_struct,param_struct=param_struct,browse_struct=browse_struct, ddr_struct=ddr_struct, LAB_data=LAB_data, MICA_data=MICA_data, wvt_subset=wvt_subset
  COMMON CSIcommon, csi_image, csi_param, csi_browse, csi_ddr; param_struct, browse_struct, ddr_struct, image_struct
;*************************************************
;SET SOME COLORS

      device, decomposed=0
      loadct, 37, /silent
;*************************************************  
;image_struct=*img_str
;image_struct=*image_struct

titlebase='CRISM Spectral Interrogator (CSI) -- Current Image: '+strupcase(image_struct.crism_fname_abbrev)+'_'+image_ancillary_struct.crism_counter       
  if image_struct.file_type eq 3 then titlebase='CRISM Spectral Interrogator (CSI) -- Current Image: '+strupcase(image_struct.crism_fname_abbrev)+'_'+ $
    image_ancillary_struct.crism_counter+' Force Joined'

OuterBase=widget_base(frame=5, column=1, title=titlebase, xoffset=0, yoffset=70, TLB_FRAME_ATTR=1, /base_align_center, MBAR=bar)
InnerBase=widget_base(OuterBase, col=1)
 tabbase=widget_tab(InnerBase)
  ;*****************************First the MAIN tab:*******************************************************
    superbase=widget_base(tabbase, col=2, title='CSI: Control Center', frame=1)
    subbase=widget_base(superbase, column=1, /align_center)
    
    baseROI=widget_base(subbase, col=1, /align_center); ROI SECTION
      RGBlabel=widget_label(baseROI, value=' ')
      RGBlabel=widget_label(baseROI, value=' ')
      ROIlabel=widget_label(baseROI, value='*** REGION OF INTEREST SETTINGS ***', /align_center)
    
    tab1=widget_tab(baseROI) ; SET THE ROI DIMENSIONS, AVERAGING, AND ALIGNMENT****************************
            oddonly=string(round((2*findgen(25)+1)))
      tabROIsize=widget_base(tab1, row=2, frame=1, title='Size')
           ROIr=widget_droplist(tabROIsize, title='Set ROI # of rows:   ', value=oddonly)
          ; ROIr=widget_slider(tabROIsize, title='Set ROI # of rows:   ', value=5, minimum=1, maximum=101, scroll=2)
         ;  ROIr=widget_text(tabROIsize, value='5', uvalue='roi_r_size', xsize=5, /editable)
         ;  ROIr=cw_field(tabROIsize, title='Set ROI # of rows:   ', value=5, uvalue='roi_r_size', xsize=5, /integer, /return_events)
           ROIc=widget_droplist(tabROIsize, title='Set ROI # of columns:', value=oddonly)
         ;  ROIc=cw_field(tabROIsize, title='Set ROI # of columns:', value=5, uvalue='roi_c_size', xsize=5, /integer, /return_events)

      tabROIavg=widget_base(tab1, row=1, frame=1, title='Averaging')
           avgbutton=widget_base(tabROIavg, row=2, /align_center)
           blnkbase=widget_base(avgbutton)
           blnklabel=widget_label(blnkbase, value=' ')
           buttonbase2=widget_base(avgbutton, /exclusive, row=1)
           avgtypmean= widget_button(buttonbase2, value='Mean')
           avgtypmed= widget_button(buttonbase2, value='Median')
      tabROIalign=widget_base(tab1, row=3, frame=1, title='Alignment')    
           lbl=widget_label(tabROIalign, value='Force denominator ROI to align')
           lbl=widget_label(tabROIalign, value='(column) with numerator?:')
            alignbutton=widget_base(tabROIalign, row=1, /exclusive, /align_center)  
                colseton = widget_button(alignbutton, uvalue='alignon', value='On')
                colsetoff = widget_button(alignbutton, uvalue='alignoff', value='Off')      
              
    ROIloc=widget_base(baseROI, row=4, frame=1,  space=-2, units=0) ; SET THE ROI ROW AND COLUMN***********
          tabROIloc2=widget_base(ROIloc, row=4, space=-2, units=0, /align_right)
            subwidbase1=widget_base(tabROIloc2, row=1, space=-2, units=0)
              textlb=widget_label(subwidbase1, value='                 row   column', /align_right, ysize=9)
            subwidbase2=widget_base(tabROIloc2, row=1, space=-2, units=0)
              subtxt=widget_base(subwidbase2, row=1, space=-2, units=0)
              text_nrowwid=widget_label(subtxt, value='Numerator:    ', /align_right)
              roi_nrowwid=widget_text(subtxt, uvalue='nrowwid', xsize=5, /editable)
              roi_ncolwid=widget_text(subtxt, uvalue='ncolwid', xsize=5, /editable)
            subwidbase3=widget_base(tabROIloc2, row=1, space=-2, units=0)
              subtxt=widget_base(subwidbase3, row=1, space=-2, units=0)
              text_drowwid=widget_label(subtxt, value='Denominator:  ', /align_right)
              roi_drowwid=widget_text(subtxt, uvalue='drowwid', xsize=5, /editable)
              roi_dcolwid=widget_text(subtxt, uvalue='dcolwid', xsize=5, /editable)  
            subwidbase4=widget_base(tabROIloc2, row=1, space=0, units=0, /align_right)                 
              applyrowcol_button=widget_button(subwidbase4, value=' Apply ', uvalue='setrowcol', frame=1, /align_right)  
            
    ROIdisp=widget_base(baseROI, row=2, frame=1) ; DISPLAY ROI ON IMAGES************************************
           text_disp=widget_label(ROIdisp, value='Display saved ROIs?:    ', /align_right)
           dispbutton=widget_base(ROIdisp, row=1, /exclusive, /align_center)
           dispseton = widget_button(dispbutton, uvalue='disproion', value='On')
           dispsetoff = widget_button(dispbutton, uvalue='disproioff', value='Off')       
              
    baseRGB=widget_base(subbase, col=1, /align_center) ; IMAGE RGB SECTION**********************************
          RGBlabel=widget_label(baseRGB, value=' ', /align_center)
          RGBlabel=widget_label(baseRGB, value=' ', /align_center)
          RGBlabel=widget_label(baseRGB, value='**** IMAGE COMPOSITE SETTINGS ****', /align_center)
      
          tabimgs=widget_tab(baseRGB)
                tabRGBbase=widget_base(tabimgs, row=7, frame=1, title='Browse')
                tabRGBbaselabel=widget_label(tabRGBbase, value='BROWSE RGB:                      ', /align_center) 
                      blnklabel=widget_label(tabRGBbase, value=' ')
                      brws = widget_droplist(tabRGBbase, uvalue='brwz', title='Browse Product:    ', value=browse_struct.browse_names) 
                      blnklabel=widget_label(tabRGBbase, value=' ')
                      blnklabel=widget_label(tabRGBbase, value=' ')
                      blnklabel=widget_label(tabRGBbase, value=' ')  
                      brws_info=widget_button(tabRGBbase, value=' Browse Info ', uvalue='infobut', frame=1, /align_right)   
                tabRGBbase2=widget_base(tabimgs, row=6, frame=1, title='Custom')
                tabRGBbaselabel=widget_label(tabRGBbase2, value='PARAMETER RGB:', /align_center) 
                      rpar = widget_droplist(tabRGBbase2, uvalue='param', title='   R:', value=param_struct.band_names )
                      gpar = widget_droplist(tabRGBbase2, uvalue='param', title='   G:', value=param_struct.band_names )
                      bpar = widget_droplist(tabRGBbase2, uvalue='param', title='   B:', value=param_struct.band_names )              
                      baser2=widget_base(tabRGBbase2, col=2)
                      param_info=widget_button(baser2, value=' Parameter Info ', uvalue='infoparam', frame=1)
                      baser1=widget_base(baser2, col=1, /nonexclusive) 
                      rbox=widget_button(baser1, value='Refined')
                pctsz=['1','2','3','4','5','6','7','8','9','10']      
                tabRGBbase4=widget_base(tabimgs, row=4, frame=1, title='Stretch')
                tabRGBbaselabel=widget_label(tabRGBbase4, value='CUSTOM n-SIGMA STRETCH:', /align_center) 
                      rpct = widget_droplist(tabRGBbase4, uvalue='rstretch', title='   R:', value=pctsz)
                      gpct = widget_droplist(tabRGBbase4, uvalue='rstretch', title='   G:', value=pctsz)
                      bpct = widget_droplist(tabRGBbase4, uvalue='rstretch', title='   B:', value=pctsz)
     
      baseplotset=widget_base(subbase, col=1, /align_center) ; PLOT SETTING SECTION****************************
            blklabel=widget_label(baseplotset, value=' ', /align_center)
            blklabel=widget_label(baseplotset, value=' ', /align_center)
            ROIlabel=widget_label(baseplotset, value='********** PLOT SETTINGS **********', /align_center)
            plotbaseopt=widget_base(baseplotset, row=2)
            if (image_struct.file_type eq 2) or (image_struct.file_type eq 3) then begin
              sensitiveS=1
              sensitiveL=1
              sensitiveJ=1
            endif
            if (image_struct.file_type eq 0) then begin
              sensitiveS=1
              sensitiveL=0
              sensitiveJ=0
            endif
            if (image_struct.file_type eq 1) then begin
              sensitiveS=0
              sensitiveL=1
              sensitiveJ=0
            endif
            offsetc1=widget_base(plotbaseopt, row=2, frame=1, sensitive=sensitiveJ)
            lbl=widget_label(offsetc1, value='1-MICRON OFFSET CORRECTION?:     ', /align_left)
            buttons=widget_base(offsetc1, row=1, /exclusive, /align_center)
            offsetcorron = widget_button(buttons, value='Yes')
            offsetcorroff = widget_button(buttons, value='No')
            offsetc3=widget_base(plotbaseopt, row=2, frame=1)
            lbl=widget_label(offsetc3, value='PLOT RANGE:                      ', /align_left)
            rangebutton=widget_base(offsetc3, col=1, /exclusive, /align_center)
            joined= widget_button(rangebutton, value='All wavelengths')
            visswir=widget_button(rangebutton, value='VIS+SWIR', sensitive=sensitiveJ)
            vis= widget_button(rangebutton, value='VIS', sensitive=sensitiveS)
            ir= widget_button(rangebutton, value='SWIR', sensitive=sensitiveL)
            irzoom= widget_button(rangebutton, value='1.8-2.6 microns', sensitive=(sensitiveL or sensitiveJ))
     
      extractbase=widget_base(subbase, col=1, /align_center) ; BUTTON TO EXTRACT SPECTRA*************************
      extractbutton=widget_button(extractbase, value=' Data Extraction ', uvalue='extract', frame=5)  
     
   ;  device, get_screen_size=screen_size
     screensize=get_screen_size()
     
     if strupcase(strmid(image_struct.crism_class_type, 1, 1)) eq 'S' then begin ;mapping data (MSP/HSP)
       xsizez=multsz*image_struct.arraysize[2]
       zmultsz=((screensize[1])/2.)/(image_struct.arraysize[3]+1000)
       xsizestrip=zmultsz*image_struct.arraysize[2]
       ysizez=zmultsz*image_struct.arraysize[3]
         colmult=4
     endif else begin
       xsizez=multsz*image_struct.arraysize[2]
       ysizez=multsz*image_struct.arraysize[3]
         colmult=2 
     endelse

  superbase2=widget_base(superbase, column=1);frame=5,
  imgbase=widget_base(superbase2, column=colmult);frame=5,
        if strupcase(strmid(image_struct.crism_class_type, 1, 1)) eq 'S' then begin  
        imgscro=widget_draw(imgbase, frame=1, YSIZE=ysizez, XSIZE=xsizestrip, retain=2)
        endif
    disimg2=widget_base(imgbase, row=2, frame=1)
       lbl=widget_label(disimg2, value=strupcase(image_struct.crism_fname_abbrev)+'_'+strtrim(image_ancillary_struct.crism_counter,1)+': I/F (R:'+strtrim(string(image_struct.default_bands[0]),1)+ $
         ', G:'+strtrim(string(image_struct.default_bands[1]),1)+', B:'+strtrim(string(image_struct.default_bands[2]),1)+')', /align_center)
      imgimg=widget_draw(disimg2, frame=1, XSIZE=multsz*image_struct.arraysize[2], YSIZE=multsz*image_struct.arraysize[3], /button_events, /scroll, x_scroll_size=xsizez, y_scroll_size=ysizez, retain=2, $
         uvalue='imgimgu', /viewport_events)
      if strupcase(strmid(image_struct.crism_class_type, 1, 1)) eq 'S' then begin ;MSP/HSP
        parscro=widget_draw(imgbase, frame=1, YSIZE=ysizez, XSIZE=xsizestrip, retain=2)
      endif
    disparam2=widget_base(imgbase, row=2, frame=1)
       lbl=widget_label(disparam2, value=strupcase(image_struct.crism_fname_abbrev)+'_'+strtrim(image_ancillary_struct.crism_counter,1)+': Parameter RGB composite', /align_center)
      imgpar=widget_draw(disparam2, frame=1, XSIZE=multsz*image_struct.arraysize[2], YSIZE=multsz*image_struct.arraysize[3], /button_events, /scroll, x_scroll_size=xsizez, y_scroll_size=ysizez, retain=2, $
        uvalue='imgparu', /viewport_events)
   
     filler=intarr(n_elements(image_struct.wvs))
     specton=filler
     spectoff=filler
     
    if screensize[1] lt 1400 then begin
    plotsize=300.     
    endif else begin
    plotsize=500.
    endelse

  plotbaseBIG=widget_base(superbase2,col=2, /align_center, /base_align_bottom);frame=5, 
    plotbase=widget_base(plotbaseBIG, row=2)  
      plotbaseopt=widget_base(plotbase, row=1)
                    
      plotbaseplt=widget_base(plotbase, col=1, /align_center)
      plotbase1=widget_base(plotbaseplt, col=2, /align_bottom)
      tab=widget_tab(plotbase1)

        pbase1=widget_base(tab, title=' Extracted Spectra ', col=1, frame=1)
          lbl=widget_label(pbase1, value='Extracted Spectra ("on" and "off")', /align_center)
          plotimg1=widget_draw(pbase1, frame=1, XSIZE=plotsize*1.2, ysize=plotsize, retain=2);, /button_events)
          plotout=widget_button(pbase1, value='Plot CRISM Spectra in ENVI Plot Window', uvalue='plot', frame=2, /align_center)
        pbase2=widget_base(tab, title=' Ratioed Spectra ', col=1, frame=1)
          lbl=widget_label(pbase2, value='Ratioed Spectra (= on / off)', /align_center)
          plotimg2=widget_draw(pbase2, frame=1, XSIZE=plotsize*1.2, ysize=plotsize, retain=2);, /button_events)
          plotout=widget_button(pbase2, value='Plot CRISM Spectra in ENVI Plot Window', uvalue='plot', frame=2, /align_center)            
          
      tab2=widget_tab(plotbase1)
        pbase3=widget_base(tab2, title=' Compare: CRISM MICA Spectra ', col=1, frame=1)   
          lbl=widget_label(pbase3, value='CRISM MICA Type Spectra & Ratioed CRISM Spectra')
          plotimg3=widget_draw(pbase3, frame=1, XSIZE=plotsize*1.2, ysize=plotsize, retain=2);, /button_events)
          plotoutlib=widget_button(pbase3, value='Plot Lab and MICA Spectra in ENVI Plot Window', uvalue='libplot', frame=2, /align_center)
        pbase4=widget_base(tab2, title=' Compare: Lab Spectra ', col=1, frame=1)  
          lbl=widget_label(pbase4, value='Lab MICA Spectra and Ratioed CRISM Spectra')
          plotimg4=widget_draw(pbase4, frame=1, XSIZE=plotsize*1.2, ysize=plotsize, retain=2);, /button_events)
          plotoutlib=widget_button(pbase4, value='Plot Lab and MICA Spectra in ENVI Plot Window', uvalue='libplot', frame=2, /align_center)       
      
       MainMMbase=widget_base(plotbaseBIG, col=1, /align_center)
       MMtab=widget_tab(MainMMbase)
       MMbase=widget_base(MMtab, Title='Spectral Analysis', /col, /align_center)
       label=widget_label(MMbase, value='*Resampled Lab spectra and MICA type spectra*')
       mbase=widget_base(MMbase, col=4, frame=1);,  /nonexclusive) 

   
     
;;;;;All of the buttons for the Lab & Mica type spectra
bb=26 ; color box size

loadct, 41, ncolors=n_elements(MICA_data.names), rgb_table=colorindex
mica_color_table = BYTARR(16, 16, 3, n_elements(MICA_data.names))
;colorindex=bytarr(n_elements(MICA_spectra_names),3)
;loadct, 37, /silent
for i=0, n_elements(MICA_data.names)-1 do begin
  mica_color_table[*,*,0,i]=(colorindex[i,*])[0]
  mica_color_table[*,*,1,i]=(colorindex[i,*])[1]
  mica_color_table[*,*,2,i]=(colorindex[i,*])[2]
endfor 

      col1=widget_base(mbase,/col, frame=0)
           
        label=widget_label(col1, value='Fe-oxides & Primary')
        label=widget_label(col1, value='Silicates')
        obase=widget_base(col1, frame=1, col=2)
        base1=widget_base(obase, col=1, /nonexclusive)     
        base2=widget_base(obase, row=6, /align_center)     
            hematite=widget_button(base1, value=mica_color_table[*,*,*,0])
            label=widget_label(base2, value=MICA_data.names[0], ysize=bb)
            mg_olivine=widget_button(base1, value=mica_color_table[*,*,*,1])
            label=widget_label(base2, value=MICA_data.names[1], ysize=bb)
            fe_olivine=widget_button(base1, value=mica_color_table[*,*,*,2])
            label=widget_label(base2, value=MICA_data.names[2], ysize=bb)
            plagioclase=widget_button(base1, value=mica_color_table[*,*,*,3]) 
            label=widget_label(base2, value=MICA_data.names[3], ysize=bb)         
            lcp=widget_button(base1, value=mica_color_table[*,*,*,4])
            label=widget_label(base2, value=MICA_data.names[4], ysize=bb)         
            hcp=widget_button(base1, value=mica_color_table[*,*,*,5])   
            label=widget_label(base2, value=MICA_data.names[5], ysize=bb)
        
        col2=widget_base(mbase,/col, frame=0)  
        label=widget_label(col2, value='Sulfates')
        obase=widget_base(col2, frame=1, col=2)
        base1=widget_base(obase, col=1, /nonexclusive)     
        base2=widget_base(obase, row=7, /align_center)                   
            mono_hyd_sulf=widget_button(base1, value=mica_color_table[*,*,*,8]) 
            label=widget_label(base2, value=MICA_data.names[8], ysize=bb)         
            alunite=widget_button(base1, value=mica_color_table[*,*,*,9])
            label=widget_label(base2, value=MICA_data.names[9], ysize=bb) 
            hydrox_fe_sulf=widget_button(base1, value=mica_color_table[*,*,*,10]) 
            label=widget_label(base2, value=MICA_data.names[10], ysize=bb)          
            jarosite=widget_button(base1, value=mica_color_table[*,*,*,11])  
            label=widget_label(base2, value=MICA_data.names[11], ysize=bb) 
            poly_hyd_sulf=widget_button(base1, value=mica_color_table[*,*,*,12])  
            label=widget_label(base2, value=MICA_data.names[12], ysize=bb)                 
            gypsum=widget_button(base1, value=mica_color_table[*,*,*,13])       
            label=widget_label(base2, value=MICA_data.names[13], ysize=bb)  
            bassanite=widget_button(base1, value=mica_color_table[*,*,*,14])
            label=widget_label(base2, value=MICA_data.names[14], ysize=bb)
            
        col3=widget_base(mbase,/col, frame=0)  
        label=widget_label(col3, value='Phyllosilicates')
        obase=widget_base(col3, frame=1, col=2)
        base1=widget_base(obase, col=1, /nonexclusive) 
        base2=widget_base(obase, row=10, /align_center)  
            kaolinite=widget_button(base1, value=mica_color_table[*,*,*,15])  
            label=widget_label(base2, value=MICA_data.names[15], ysize=bb)  
            al_smectite=widget_button(base1, value=mica_color_table[*,*,*,16]) 
            label=widget_label(base2, value=MICA_data.names[16], ysize=bb)  
            margarite=widget_button(base1, value=mica_color_table[*,*,*,17])   
            label=widget_label(base2, value=MICA_data.names[17], ysize=bb)  
            illite_muscovite=widget_button(base1, value=mica_color_table[*,*,*,18])  
            label=widget_label(base2, value=MICA_data.names[18], ysize=bb)             
            fe_smectite=widget_button(base1, value=mica_color_table[*,*,*,19])   
            label=widget_label(base2, value=MICA_data.names[19], ysize=bb)             
            mg_smectite=widget_button(base1, value=mica_color_table[*,*,*,20])   
            label=widget_label(base2, value=MICA_data.names[20], ysize=bb)             
            talc=widget_button(base1, value=mica_color_table[*,*,*,21])   
            label=widget_label(base2, value=MICA_data.names[21], ysize=bb)                                      
            serpentine=widget_button(base1, value=mica_color_table[*,*,*,22])  
            label=widget_label(base2, value=MICA_data.names[22], ysize=bb)             
            chlorite=widget_button(base1, value=mica_color_table[*,*,*,23])  
            label=widget_label(base2, value=MICA_data.names[23], ysize=bb)                      
            prehnite=widget_button(base1, value=mica_color_table[*,*,*,24])  
            label=widget_label(base2, value=MICA_data.names[24], ysize=bb)  
            
        col4=widget_base(mbase,/col, frame=0)   
        label=widget_label(col4, value='Carbonates')
        obase=widget_base(col4, frame=1, col=2)
        base1=widget_base(obase, col=1, /nonexclusive)     
        base2=widget_base(obase, row=2, /align_center)  
            mg_carbonate=widget_button(base1, value=mica_color_table[*,*,*,25])
            label=widget_label(base2, value=MICA_data.names[25], ysize=bb) 
            fe_ca_carbonate=widget_button(base1, value=mica_color_table[*,*,*,26])
            label=widget_label(base2, value=MICA_data.names[26], ysize=bb) 
          
        label=widget_label(col4, value='Other')
        obase=widget_base(col4, frame=1, col=2)
        base1=widget_base(obase, col=1, /nonexclusive)     
        base2=widget_base(obase, row=4, /align_center)          
            hydrated_silica=widget_button(base1, value=mica_color_table[*,*,*,27])
            label=widget_label(base2, value=MICA_data.names[27], ysize=bb) 
            epidote=widget_button(base1, value=mica_color_table[*,*,*,28])
            label=widget_label(base2, value=MICA_data.names[28], ysize=bb) 
            analcime=widget_button(base1, value=mica_color_table[*,*,*,29])
            label=widget_label(base2, value=MICA_data.names[29], ysize=bb) 
            chloride=widget_button(base1, value=mica_color_table[*,*,*,30])
            label=widget_label(base2, value=MICA_data.names[30], ysize=bb)    
            
         label=widget_label(col4, value='Ices')
         obase=widget_base(col4, frame=1, col=2)
         base1=widget_base(obase, col=1, /nonexclusive)
         base2=widget_base(obase, row=2, /align_center)
            h2o_ice=widget_button(base1, value=mica_color_table[*,*,*,6])
            label=widget_label(base2, value=MICA_data.names[6], ysize=bb)
            co2_ice=widget_button(base1, value=mica_color_table[*,*,*,7])
            label=widget_label(base2, value=MICA_data.names[7], ysize=bb)    
                               
       clear=widget_button(mmbase, value='Deselect All', uvalue='clear', xsize=5, frame=2)    

      cc=105
      morphnames=[ 'bright', 'intermed', 'dark', $ ;Albedo
                  'massive', 'layered', 'unconsolidated', $; Exposure
                  'rim', 'floor', 'central_peak', 'ring', 'wall', 'ejecta', 'pedestal', $; Crater
                  'wrinkle_ridge', 'scarp', 'fractured', 'dike', $; Structural
                  'channel', 'gully', 'fan_delta', 'landslide', 'talus', 'spur', 'debris_apron', 'dune', $; Erosion & Deposition
                  'caldera', 'cone', 'flow', 'ridge']; Volcanic
       
      MMmorph=widget_base(MMtab, Title='Morphology', /col) 
      label=widget_label(MMmorph, value='*Morphologic characteristics of location*')
       morphbase=widget_base(MMmorph, col=4, frame=1)
       
    col1=widget_base(morphbase,/col, frame=0)
       
          label=widget_label(col1, value='ALBEDO')                      
       albedo=widget_base(col1, row=3, /nonexclusive, frame=1, xsize=cc)
          bright=widget_button(albedo, value=morphnames[0]) 
          intermed=widget_button(albedo, value=morphnames[1])               
          dark=widget_button(albedo, value=morphnames[2]) 
          
          label=widget_label(col1, value='EXPOSURE')            
         exposure=widget_base(col1, row=3, /nonexclusive, frame=1, xsize=cc)                           
          massive=widget_button(exposure, value=morphnames[3])
          layered=widget_button(exposure, value=morphnames[4])
          unconsolidated=widget_button(exposure, value=morphnames[5])
          
    col2=widget_base(morphbase,/col, frame=0)
          label=widget_label(col2, value='CRATER')
          crater=widget_base(col2, row=7, /nonexclusive, frame=1, xsize=cc)
          rim=widget_button(crater, value=morphnames[6])
          floor=widget_button(crater, value=morphnames[7])
          central_peak=widget_button(crater, value=morphnames[8])
          ring=widget_button(crater, value=morphnames[9])
          wall=widget_button(crater, value=morphnames[10])
          ejecta=widget_button(crater, value=morphnames[11])
          pedestal=widget_button(crater, value=morphnames[12])
                   
    col3=widget_base(morphbase,/col, frame=0)

          label=widget_label(col3, value='EROSION &')
          label=widget_label(col3, value='DEPOSITION')
         eroanddep=widget_base(col3, row=8, /nonexclusive, frame=1, xsize=cc) 
          channel=widget_button(eroanddep, value=morphnames[17])
          gully=widget_button(eroanddep, value=morphnames[18])
          fan_delta=widget_button(eroanddep, value=morphnames[19])
          landslide=widget_button(eroanddep, value=morphnames[20])
          talus=widget_button(eroanddep, value=morphnames[21])
          spur=widget_button(eroanddep, value=morphnames[22])
          debris_apron=widget_button(eroanddep, value=morphnames[23])
          dune=widget_button(eroanddep, value=morphnames[24])

    col4=widget_base(morphbase,/col, frame=0)
    
          label=widget_label(col4, value='VOLCANIC')
         volcanic=widget_base(col4, row=4, /nonexclusive, frame=1, xsize=cc) 
          caldera=widget_button(volcanic, value=morphnames[25])
          cone=widget_button(volcanic, value=morphnames[26])
          flow=widget_button(volcanic, value=morphnames[27])
          ridge=widget_button(volcanic, value=morphnames[28])
          
          label=widget_label(col4, value='STRUCTURAL')
          structural=widget_base(col4, row=4, /nonexclusive, frame=1, xsize=cc)
          wrinkle_ridge=widget_button(structural, value=morphnames[13])
          scarp=widget_button(structural, value=morphnames[14])
          fractured=widget_button(structural, value=morphnames[15])
          dike=widget_button(structural, value=morphnames[16])
       
       clear=widget_button(MMmorph, value='Deselect All', uvalue='mclear', xsize=5, frame=2)    
       
       commentlabel=widget_label(MMmorph, value='Additional comments:')
       commentbox=widget_text(MMmorph, uvalue='comment', frame=1, ysize=5, /editable)


 ;*****************now for the TABLE tab:*******************************************************
              
      
          d0=csi_table_struct
          z=30
           colwid=[z, 3*z, 5*z, 5*z, 3*z, 2*z, 2*z, 2*z, z, z, 2*z, 2*z] 
       collabels=tag_names(d0)
      stop          
  superbase2=widget_base(tabbase, title='CSI: Data Extraction and Storage', frame=1, /column, XSIZE=((screensize[0])/1.2)+400)    
  
    table1 = widget_table(superbase2, VALUE=d0, /ROW_MAJOR, ROW_LABELS='', COLUMN_LABELS=collabels, /RESIZEABLE_COLUMNS, COLUMN_WIDTHS=colwid, $
                            YSIZE=150, SCR_YSIZE=(screensize[1])/1.2, /scroll, /NO_ROW_HEADERS, uvalue=tablewid, /sensitive,/ALL_EVENTS, $
                            background_color=[193,205,193],foreground_color=[0,0,0])  ;/no_copy, 
 
        d0.Num=0L   
     buttonbase=widget_base(superbase2, row=1, frame=1, /align_center)   
          gotobutton=widget_button(buttonbase, value='Reset Control Center to Selected Row', uvalue='goto', /align_center, frame=5)
          delbutton=widget_button(buttonbase, value='Delete Selected Row', uvalue='delete', /align_center, frame=5)
        
;*****************************Menu options:*******************************************************
          menu1 = widget_button(bar, VALUE=' File ', /MENU)
            menuopen = widget_button(menu1, VALUE='Open new file (lose unsaved table data)...', event_pro='widget_reset_event')
            menusave = widget_button(menu1, VALUE='Save table ', event_pro='csi_save_event')
            menusaveas = widget_button(menu1, VALUE='Save table as... ', event_pro='csi_saveas_event') 
            menurestore = widget_button(menu1, VALUE='Restore table... ', event_pro='csi_restore_event')
            menuquit = widget_button(menu1, VALUE='Quit ', event_pro='widget_quit_event')           
       
          menu2 = widget_button(bar, VALUE=' Help ', /MENU)
            menuhelp=widget_button(menu2, value='CSI Help ', uvalue='help')
       
          
   ;set default parameter RGB droplist selections
   if image_struct.file_type ne 0 then begin  ; L, J, or S+L
   Rpardef=where(param_struct.band_names eq 'OLINDEX3')
      if (Rpardef eq -1) then Rpardef=0
   Gpardef=where(param_struct.band_names eq 'LCPINDEX2')
      if (Gpardef eq -1) then Gpardef=1
   Bpardet=where(param_struct.band_names eq 'HCPINDEX2')
      if (Bpardet eq -1) then Bpardet=2
   endif else begin ; S data only
     Rpardef=where(param_struct.band_names eq 'BD530_2')
     if (Rpardef eq -1) then Rpardef=9
     Gpardef=where(param_struct.band_names eq 'BD920_2')
     if (Gpardef eq -1) then Gpardef=7
     Bpardet=where(param_struct.band_names eq 'BDI1000VIS')
     if (Bpardet eq -1) then Bpardet=6    
   endelse
      
   ;set default browse droplist selections
    if image_struct.file_type eq 0 then begin ; S-only
      default_brws=where(browse_struct.browse_names eq 'FM2')
    endif else begin
      default_brws=where(browse_struct.browse_names eq 'MAF')
    endelse

         
    widget_control, rpar, set_droplist_select=Rpardef
    widget_control, gpar, set_droplist_select=Gpardef
    widget_control, bpar, set_droplist_select=Bpardet
    
    widget_control, brws, set_droplist_select=default_brws
    
   ;set default ROI size droplist selections
   widget_control, ROIr, set_droplist_select=2
   widget_control, ROIc, set_droplist_select=2  
   
   widget_control, dispsetoff, /set_button
   
   ;set default sigma size droplist selections
   widget_control, rpct, set_droplist_select=2
   widget_control, gpct, set_droplist_select=2
   widget_control, bpct, set_droplist_select=2   
   
   ;set default column alignment
   widget_control, colseton, /set_button
   ;set default offset correct
  ; widget_control, offsetcorron, /set_button   
  widget_control, offsetcorroff, /set_button  
   ;set default averaging
   widget_control, avgtypmean, /set_button
   ;set default plot range
   if image_struct.file_type eq 0 then begin 
    widget_control, vis, /set_button
   endif   
   if image_struct.file_type eq 1 then begin
     widget_control, ir, /set_button
   endif
   if (image_struct.file_type eq 2) or (image_struct.file_type eq 3) then begin
    widget_control, visswir, /set_button
   endif
   
   widget_control, extractbutton, get_uvalue=extractset
       
 WIDGET_CONTROL, superbase, /REALIZE    
 ; Retrieve the window ID from the draw widget. 

 WIDGET_CONTROL, imgpar, GET_VALUE=drawID  
  WIDGET_CONTROL, imgimg, GET_VALUE=drawID2
  if strupcase(strmid(image_struct.crism_class_type, 1, 1)) eq 'S' then begin ;mapping mode
  WIDGET_CONTROL, imgscro, GET_VALUE=drawID3
  WIDGET_CONTROL, parscro, GET_VALUE=drawID4
  endif else begin
  drawID3=0
  drawID4=0
  endelse
  WIDGET_CONTROL, plotimg1, GET_VALUE=drawIDonandoff
  WIDGET_CONTROL, plotimg2, GET_VALUE=drawIDratio
  WIDGET_CONTROL, plotimg3, GET_VALUE=drawIDMICA
  WIDGET_CONTROL, plotimg4, GET_VALUE=drawIDLAB
 WSET, drawID
 
 ;set default
 rpara=param_struct.band_names[0]
 gpara=param_struct.band_names[1]
 bpara=param_struct.band_names[2] 


  csi_display_parameter, drawID, default_brws, default_brws, default_brws, csi_browse=csi_browse, browse_struct=browse_struct, plotroi={x:0}, multsz=multsz

if image_struct.file_type eq 0 then begin ; S-only  
  csi_display_parameter, drawID2, 'R600', 'R530', 'R440', csi_param=csi_param, param_struct=param_struct, plotroi={x:0},pctr=5,pctg=5,pctb=5, $
  multsz=multsz
endif else begin
  csi_display_parameter, drawID2, 'R2529', 'R1506', 'R1080', csi_param=csi_param, param_struct=param_struct, plotroi={x:0},pctr=5,pctg=5,pctb=5, $
    multsz=multsz
endelse

;add zoom out image for MSP type:   ;REWRITE THIS TO ACCESS ANCILLARY INFO
if strupcase(strmid(image_struct.crism_class_type, 1, 1)) eq 'S' then begin
  ysizez=zmultsz*(size(*image_struct.image))[2] 
  resizescro=(((size(*image_struct.image))[2])/(ysizez))  
  csi_display_parameter, drawID3, 'R2529', 'R1506', 'R1080', csi_param=csi_param, param_struct=param_struct, plotroi={x:0}, pctr=5,pctg=5,pctb=5, $
    multsz=1./resizescro, /interp
endif

  wvs=n_elements(image_struct.wvs)
  filler=intarr(wvs)
  
 ;create structure to pass vars...insanely big...and a common variable...nice going
 ; info = {image_struct:image_struct, param_struct:param_struct, browse_struct:browse_struct,$
  info = { image_ancillary_struct:image_ancillary_struct, infoholder:infoholder, csi_table_struct:csi_table_struct, multsz:multsz, $ 
        ;  cdet:cdet, cspsamp:cspsamp, clength:clength, cmicron:cmicron, cESC:cESC, cfile_type:cfile_type, $
        ;img_str:img_str, $
          image_struct:image_struct, param_struct:param_struct, browse_struct:browse_struct, ddr_struct:ddr_struct, $
          R_par:rpar, G_par:gpar, B_par:bpar, BRZ_par:brws, $
          redp:'', greenp:'', bluep:'', brzp:'', $
          drawID:drawID, drawID2:drawID2, drawID4:drawID4, $
          Img_par:imgpar, Img_img:imgimg, $
          rbox:rbox, $
          Rpercent:rpct, Gpercent:gpct, Bpercent:bpct, $
          pctr:'', pctg:'', pctb:'', $
          roi_nrowwid:roi_nrowwid, roi_ncolwid:roi_ncolwid, $
          roi_drowwid:roi_drowwid, roi_dcolwid:roi_dcolwid, $
          ROI_r:ROIr, ROI_c:ROIc, $
          roi_row:'', roi_col:'', $
          colON:'', colOFF:'', rowON:'', rowOFF:'', $
          joined:joined, visswir:visswir, vis:vis, ir:ir, irzoom:irzoom, $
          range:'joined', $
          colseton:colseton, dispseton:dispseton, $
          offsetcorron:offsetcorron, $
          avgtypmean:avgtypmean, typeavg:'', $
          offset:'', $
          alignset:'', $
          disproiset:'',$
          specton:filler, spectoff:filler, $
          plotout:plotout, $
          table1:table1,$
          extractset:'',$
          num:0L,$
          d0:ptr_new(d0), $
          ddrlat:'', ddrlon:'', ddrelev:'',$
          drawIDonandoff:drawIDonandoff, drawIDratio:drawIDratio, drawIDMICA:drawIDMICA, drawIDLAB:drawIDLAB, $
          wvt_subset:wvt_subset,$
          last:'brwz',$
          commentbox:commentbox,$
          colorindex:colorindex, $
          MICA_data:MICA_data, LAB_data:LAB_data, $
          libindex:intarr(n_elements(MICA_data.names)), $
          morphnames:morphnames, $
          morphindex:intarr(n_elements(morphnames)), $
          ;wlliblab:wlliblab, wllibmica:wllibmica, $
          ;LAB_library_resampled:LAB_library_resampled, MICA_library_resampled:MICA_library_resampled, $
                   
     ;morphology     
          bright:bright, intermed:intermed, dark:dark, massive:massive, layered:layered, unconsolidated:unconsolidated, $
          rim:rim, floor:floor, central_peak:central_peak, ring:ring, wall:wall, ejecta:ejecta, pedestal:pedestal, $
          wrinkle_ridge:wrinkle_ridge, scarp:scarp, fractured:fractured, dike:dike, channel:channel, gully:gully, $
          fan_delta:fan_delta, landslide:landslide, talus:talus, spur:spur, debris_apron:debris_apron, dune:dune, $
          caldera:caldera, cone:cone, flow:flow, ridge:ridge, $
          
     ;spectra     
          h2o_ice:h2o_ice, co2_ice:co2_ice, $
          hematite:hematite, mg_olivine:mg_olivine, fe_olivine:fe_olivine, plagioclase:plagioclase, lcp:lcp, hcp:hcp, $             
          mono_hyd_sulf:mono_hyd_sulf, alunite:alunite, hydrox_fe_sulf:hydrox_fe_sulf, jarosite:jarosite, $
          poly_hyd_sulf:poly_hyd_sulf, gypsum:gypsum, bassanite:bassanite, $
          kaolinite:kaolinite, al_smectite:al_smectite, margarite:margarite, illite_muscovite:illite_muscovite, $
          fe_smectite:fe_smectite, mg_smectite:mg_smectite, talc:talc, serpentine:serpentine, chlorite:chlorite, prehnite:prehnite, $
          mg_carbonate:mg_carbonate, fe_ca_carbonate:fe_ca_carbonate, $
          hydrated_silica:hydrated_silica, epidote:epidote, analcime:analcime, chloride:chloride, $
          
      ;saving and restoring table
          oddonly:oddonly, $
          selected:[0L,0L,0L,0L], $
          savename:''}
          
          infoptr=ptr_new(info)
       
          ;------------------------------------------see if open was selected to save prev. table data------------
          ;if infoholder eq '/project/crism/users/viviace1/tmp.csv' then begin  
          if infoholder ne '0' then begin  
            
          d1=csi_table_struct
          
          restorename=infoholder
          tnames = tag_names(d1)

        openr, lun, restorename, /get_lun
        temparray=''
        templine=''
        while not eof(lun) do begin & $
          readf, lun, templine & $
          temparray=[temparray,templine]&$
        endwhile
      free_lun, lun    
        
      temparray=temparray[2:*] ;no header info      
      for i=0, ((size(temparray))[1])-1 do begin 
      subtemp=(strsplit(temparray[i], '","', /extract))  ; separate commas
      if i eq 0 then begin                                        ;build structure
        concat=ptr_new(d1)
      endif else begin
        concat=ptr_new([*concat,d1])
      endelse
      endfor
      
      newstruct=*concat
      ptr_free, concat
      for i=0, ((size(temparray))[1])-1 do begin  ; fill structure
        for j=0, (n_elements(subtemp)-1) do begin
        newstruct[i].(j)=subtemp(j)
        endfor
      endfor        
          
          for i=0, ((size(newstruct))[1]-1) do begin  ;re-number table
            newstruct[i].num=strtrim(string(i+1),1)
          endfor        
          info.num=n_elements(newstruct.(0))
          info.d0=ptr_new(newstruct)
          infoptr=ptr_new(info)
          
          WIDGET_CONTROL, info.table1, SET_VALUE=*info.d0
          infoholder='0' ; reset keyword
          endif          
          
          ;------------------------------------------------------------------------------------------------------------
          
  widget_control, OuterBase, set_uvalue=infoptr
  widget_control, OuterBase, show=1
    XMANAGER, 'csi_main_widget_build', OuterBase;, cleanup='selectband_cleanup'
    
     
END
