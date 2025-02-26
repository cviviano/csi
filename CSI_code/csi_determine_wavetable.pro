;Viviano 4/2022
;Returns appropriate wavetable for class type (e.g., MSP, HSP, FRT/HRL/FRS/HRS) and whether it is S, L, or J data.
;This is the SUBSET wavetable, using the downselect eventually chosen for the MTRDRs.

function csi_determine_wavetable, class_type ;, sensor
wvt_modes_S_file='/project/crism/users/viviace1/crismidl/CSI_program/CRISM_S_wavetable.txt'
wvt_modes_L_file='/project/crism/users/viviace1/crismidl/CSI_program/CRISM_L_wavetable.txt'
wvt_mtrdr_file='/project/crism/users/viviace1/crismidl/CSI_program/CRISM_J_wavetable.txt'

wvt_modes_S=read_ascii(wvt_modes_S_file, data_start=1)
wvt_modes_L=read_ascii(wvt_modes_L_file, data_start=1)
wvt_Jsub=read_ascii(wvt_mtrdr_file)
wvt_Jsub=wvt_Jsub.Field1

;Read in these clunky files:
;remove all NAN rows
detector_row_S=(wvt_modes_S.FIELD1[0,*])[where([wvt_modes_S.FIELD1[5,*]] ne 65535.)]
targeted_S=(wvt_modes_S.FIELD1[1,*])[where([wvt_modes_S.FIELD1[5,*]] ne 65535.)]
msp_S=(wvt_modes_S.FIELD1[2,*])[where([wvt_modes_S.FIELD1[5,*]] ne 65535.)]
hsp_S=(wvt_modes_S.FIELD1[3,*])[where([wvt_modes_S.FIELD1[5,*]] ne 65535.)]
wavelength_S=(wvt_modes_S.FIELD1[5,*])[where([wvt_modes_S.FIELD1[5,*]] ne 65535.)]

;reverse L data
detector_row_L0=reverse(transpose(wvt_modes_L.FIELD1[0,*]))
targeted_L0=reverse(transpose(wvt_modes_L.FIELD1[1,*]))
msp_L0=reverse(transpose(wvt_modes_L.FIELD1[2,*]))
hsp_L0=reverse(transpose(wvt_modes_L.FIELD1[3,*]))
wavelength_L0=reverse(transpose(wvt_modes_L.FIELD1[5,*]))

;remove L data NANs
detector_row_L=detector_row_L0[where(wavelength_L0 ne 65535.)]
targeted_L=targeted_L0[where(wavelength_L0 ne 65535.)]
msp_L=msp_L0[where(wavelength_L0 ne 65535.)]
hsp_L=hsp_L0[where(wavelength_L0 ne 65535.)]
wavelength_L=wavelength_L0[where(wavelength_L0 ne 65535.)]


if class_type eq 'MSP' then begin
  wvt_MSP_S=wavelength_S[where(msp_S eq 1)]
  wvt_MSP_L=wavelength_L[where(msp_L eq 1)]
  wv_MSP=[wvt_MSP_S,wvt_MSP_L]
  match, wv_MSP, wvt_Jsub, subwvt_MSP, subwvt_Jsub
  wvt = float(wv_MSP[subwvt_MSP])
endif

if class_type eq 'HSP' then begin
  wvt_HSP_S=wavelength_S[where(hsp_S eq 1)]
  wvt_HSP_L=wavelength_L[where(hsp_L eq 1)]
  wv_HSP=[wvt_HSP_S,wvt_HSP_L]
  match, wv_HSP, wvt_Jsub, subwvt_HSP, subwvt_Jsub
  wvt = float(wv_HSP[subwvt_HSP])
endif

if class_type eq 'FRT' then begin
  wvt = float(wvt_Jsub)
endif

if n_elements(wvt) le 1 then begin
  print, 'ERROR -- problems determining wavetable for scene, or non-standard CRISM class type'
  stop
endif

return, wvt
end