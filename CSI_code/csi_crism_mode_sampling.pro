function csi_crism_mode_sampling, class_type, mode=mode, sampling=sampling

case 1 of
  strcmp(class_type, 'MSP', /fold_case):begin
    crism_mode=0
    spectral_sampling=0
  end
  strcmp(class_type, 'HSP', /fold_case):begin
    crism_mode=0
    spectral_sampling=2
  end
  total(strcmp(class_type, ['FRT','HRL','HRS', 'FRS', 'ATU', 'ATO'], /fold_case)) eq 1:begin
    crism_mode=1
    spectral_sampling=1
  end
  else: begin
    ;error
    return, -1
  end
endcase

if keyword_set(mode) then begin
  return, crism_mode
endif

if keyword_set(sampling) then begin
  return, spectral_sampling
endif


end