;extract numerator and denominator spectra

FUNCTION csi_extract_spectra, ONinfo, OFFinfo, ROIrow, ROIcol, wllib, avgtyp, image_struct, crism_image, min=min, max=max

colON=ONinfo[0]
rowON=ONinfo[1]
colOFF=OFFinfo[0]
rowOFF=OFFinfo[1]

cl=fix(ROIcol/2)
rw=fix(ROIrow/2)

;width=((*crism_image).arraysize)[2]
;height=((*crism_image).arraysize)[3]
width=(image_struct.arraysize)[2]
height=(image_struct.arraysize)[3]

b=rowON-rw-1
c=rowON+rw-1
d=colON-cl-1
e=colON+cl-1

if (b lt 0) or (c ge height) or (d lt 0) or (e ge width) then begin ; catch for clicking outside box
 ; imagesubon=(((((*crism_image).image)[*,10:15,*])[*,*,10:15])*0.)+1
  imagesubon=((((crism_image)[*,10:15,*])[*,*,10:15])*0.)+1
endif else begin
 ; imagesubon=(((*crism_image).image)[*,d:e,*])[*,*,b:c]
  imagesubon=((crism_image)[*,d:e,*])[*,*,b:c]
endelse
f=rowOFF-rw-1
g=rowOFF+rw-1
h=colOFF-cl-1
hh=colOFF+cl-1

if (f lt 0) or (g ge height) or (h lt 0) or (hh ge width) then begin ; catch for clicking outside box
 ; imagesuboff=(((((*crism_image).image)[*,10:15,*])[*,*,10:15])*0.)+1
  imagesuboff=((((crism_image)[*,10:15,*])[*,*,10:15])*0.)+1
endif else begin
 ; imagesuboff=(((*crism_image).image)[*,h:hh,*])[*,*,f:g]
  imagesuboff=((crism_image)[*,h:hh,*])[*,*,f:g]
endelse
wvs=n_elements(wllib)

specton=fltarr(1,wvs)
spectoff=fltarr(1,wvs)

CASE avgtyp OF
  'mean': BEGIN
    specton = mean(reform(imagesubon, (size(imagesubon))[1], (size(imagesubon))[2]*(size(imagesubon))[3]), dimension=2)
    spectoff = mean(reform(imagesuboff, (size(imagesuboff))[1], (size(imagesuboff))[2]*(size(imagesuboff))[3]), dimension=2)
  END
  'median': BEGIN
    specton = median(reform(imagesubon, (size(imagesubon))[1], (size(imagesubon))[2]*(size(imagesubon))[3]), dimension=2)
    spectoff = median(reform(imagesuboff, (size(imagesuboff))[1], (size(imagesuboff))[2]*(size(imagesuboff))[3]), dimension=2)
  END
  ELSE: MESSAGE, 'Invalid avgtyp. Use "mean" or "median".'
ENDCASE


if keyword_set(min) then emin=min(imagesubon)
if keyword_set(max) then emax=max(imagesubon)

specton=transpose(specton)
spectoff=transpose(spectoff)

extractspectra={specton:specton, spectoff:spectoff}

if keyword_set(min) then extractspectra={specton:specton, spectoff:spectoff, min:emin, max:emax}

extractspectraptr=ptr_new(extractspectra)
return, extractspectraptr
END