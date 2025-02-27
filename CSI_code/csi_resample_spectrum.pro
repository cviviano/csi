; Resample a spectrum to a new set of wavelengths

; in_wvs: 1D array of input wavelengths
; in_spectra: 1D array of input flux values
; out_wvs: 1D array of output wavelengths
; out_spectra: Output array to store the resampled flux values

function csi_resample_spectra, in_wvs, in_spectra, out_wvs

  n_input = n_elements(in_wvs)
  n_output = n_elements(out_wvs)
  out_spectra=fltarr(n_elements(out_wvs))
  
  ; Linear interpolation for each output wavelength
  for i = 0, n_output - 1 do begin
    if out_wvs[i] lt in_wvs[0] then begin
      out_spectra[i] = in_spectra[0]
    endif else if out_wvs[i] gt in_wvs[n_input - 1] then begin
      out_spectra[i] = in_spectra[n_input - 1]
    endif else begin
      ; Find the indices of the two input wavelengths closest to the output wavelength
      index1 = max(where(out_wvs[i] ge in_wvs))
      index2 = index1 + 1

      ; Calculate the weightings for linear interpolation
      weight2 = (out_wvs[i] - in_wvs[index1]) / (in_wvs[index2] - in_wvs[index1])
      weight1 = 1.0 - weight2

      ; Perform linear interpolation
      out_spectra[i] = weight1 * in_spectra[index1] + weight2 * in_spectra[index2]
    endelse
  endfor

return, out_spectra

end