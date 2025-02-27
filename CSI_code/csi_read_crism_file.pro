function csi_read_crism_file, image_fname_struct, image_ancillary_struct

  imageS=''
  imageL=''
  imageJ=''
  imageSL=''
  wvsS=''
  bblS=''
  wvsL=''
  bblL=''
  wvsJ=''
  bblJ=''
  wvsSL=''
  bblSL=''
  unitsS=''
  unitsL=''
  unitsJ=''
  default_bandsS=''
  default_bandsL=''
  default_bandsJ=''
  default_bandsSL=''
  arraysize=''

  if (image_fname_struct.file_type eq 0) or (image_fname_struct.file_type eq 3) then begin; S
    ;imageS=transpose(csi_read_envi_image(image_fname_struct.fname_imageS, header=hdrS), [1,2,0])
    imageS=csi_read_envi_image(image_fname_struct.fname_imageS, header=hdrS)
    wvsS=*(hdrS.wavelength)
    bblS=*(hdrS.bbl)
    default_bandsS=hdrS.default_bands
    if ptr_valid(hdrS.wavelength_units) then unitsS=*(hdrS.wavelength_units) else unitsS=hdrS.wavelength_units
    arraysize=size(imageS)
    undefine, hdrS
    imageS=transpose(imageS, [1,2,0])
  endif

  if (image_fname_struct.file_type eq 1) or (image_fname_struct.file_type eq 3) then begin; L
    ;imageL=transpose(csi_read_envi_image(image_fname_struct.fname_imageL, header=hdrL), [1,2,0])
    imageL=csi_read_envi_image(image_fname_struct.fname_imageL, header=hdrL)
    wvsL=*(hdrL.wavelength)
    bblL=*(hdrL.bbl)
    default_bandsL=hdrL.default_bands
    if ptr_valid(hdrL.wavelength_units) then unitsL=*(hdrL.wavelength_units) else unitsL=hdrL.wavelength_units
    arraysize=size(imageL)
    undefine, hdrL
    imageL=transpose(imageL, [1,2,0])

    if (image_fname_struct.file_type eq 3) then begin
      imageSL=[[[imageS]],[[imageL]]]
      wvsSL=[wvsS,wvsL]
      bblSL=[bblS,bblL]
      default_bandsSL=[default_bandsL]
    endif
    
  endif

  if image_fname_struct.file_type eq 2 then begin ; J 
    hdrJ=csi_find_header(image_fname_struct.fname_imageJ)
    imageJ=csi_read_envi_image(image_fname_struct.fname_imageJ, header=hdrJ)
    wvsJ=*(hdrJ.wavelength)
    bblJ=*(hdrJ.bbl)
    default_bandsJ=hdrJ.default_bands
    if ptr_valid(hdrJ.wavelength_units) then unitsJ=*(hdrJ.wavelength_units) else unitsJ=hdrJ.wavelength_units ;MTRDR unit in PDS header is not a pointer
    arraysize=size(imageJ)
    undefine, hdrJ
  endif

  image_struct=create_struct('file_type', image_fname_struct.file_type, 'imageS', imageS, 'imageL', imageL, 'imageJ', imageJ, 'imageSL', imageSL, $
    'wvsS', wvsS, 'wvsL', wvsL, 'wvsJ', wvsj, 'wvsSL', wvsSL, $
    'bblS', bblS, 'bblL', bblL, 'bblJ', bblJ, 'bblSL', bblSL, $
    'unitsS', unitsS, 'unitsL', unitsL, 'unitsJ', unitsJ, $
    'default_bandsS', default_bandsS, 'default_bandsL', default_bandsL,'default_bandsJ', default_bandsJ, 'default_bandsSL', default_bandsSL, $
    'crism_mode', image_ancillary_struct.crism_mode, $
    'spectral_sampling', image_ancillary_struct.spectral_sampling, $
    'crism_fname_abbrev', image_ancillary_struct.crism_fname_abbrev, $
    'crism_class_type', strupcase(image_ancillary_struct.crism_class_type), $
    'arraysize', arraysize)
    
  return, image_struct

end
