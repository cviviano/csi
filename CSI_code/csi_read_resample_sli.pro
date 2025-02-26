function csi_read_resample_sli, spectral_sampling, units, sli_file

data=csi_read_envi_image(sli_file, header=library_hdr)
spectra_names=strtrim(*(library_hdr.spectra_names), 1)

case spectral_sampling of
  0: begin ; multispectral (MSP)
    wvt_subset=csi_determine_wavetable('MSP')
  end
  1: begin ; hyperspectral (FRT,HRL)
    wvt_subset=csi_determine_wavetable('FRT')
  end
  2: begin ; 'hyperspectral' (HSP sampling)
    wvt_subset=csi_determine_wavetable('HSP')
  end
endcase

library_resampled=csi_resample_spectra(*(library_hdr.wavelength), data, wvt_subset)

wl=wvt_subset

; Conform library spectra to units in image (assumes nm or microns)
if strupcase(units) eq 'NANOMETERS' then begin 
 if strupcase(library_hdr.wavelength_units) ne 'NANOMETERS' then begin ; convert to nm
  wl=wvt_subset*1000.
  wl[where(wvt_subset eq 65535.)]=65535.
 endif
endif else begin
 if strupcase(library_hdr.wavelength_units) eq 'NANOMETERS' then begin ; convert to micron
   wl=wvt_subset/1000.
   wl[where(wvt_subset eq 65535.)]=65535.
 endif
endelse

return, {spectra: data, wvt:wl, names: spectra_names}

end