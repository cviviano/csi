;CLEAN THIS UP FOR SHARING
;
;~03/01/2011 (fps)
;   Initial development - apply previously calculated sensor space / spatial transform
;03/12/2011 (fps)
;   Fixed weighting calculation error - offset by EPS to avoid NaN problem...
;09/05/2012 (fps)
;   Improved handling of CRISM NAN values interior to data cube when pixel averaging (n_pxls GT 1)
;12/05/2013 (fps)
;   Finally can't take the looped logic anymore... if n_pxls = 1 try for a better life through array indexing...
;   	new keyword /oldnslow reverts to previous approach regardless of n_pxls
;12/11/2020 (fps)
;   output data cube has same type as input
;

function csi_apply_spatial_transform, mapping_struct, in_data, n_pxls = n_pxls, oldnslow = oldnslow

ignore_val = 65535.0

if (~(keyword_set(n_pxls))) then begin
    n_pxls = 4
endif

in_mask = ((median(in_data, dim = 3) EQ 65535) EQ 0) 

in_data_size = size(in_data, /struct)
help, in_data_size, /struct

mapping_struct_size = size(mapping_struct.indx_stack, /struct)
help, mapping_struct_size, /struct


;out_data = make_array(mapping_struct_size.dimensions[0], mapping_struct_size.dimensions[1], $
;    	    	     (1 > in_data_size.dimensions[2]), /float, value = ignore_val)

out_data = make_array(mapping_struct_size.dimensions[0], mapping_struct_size.dimensions[1], $
    	    	     (1 > in_data_size.dimensions[2]), type = in_data_size.type , value = ignore_val)

;stop

eps = (machar()).eps

if (n_elements(in_data) NE (n_elements(out_data))) then begin
    print, 'MRO_CRISM_APPLY_MAPPING: I/O size mismach - old-n-slow processing...'
    oldnslow = 1
endif 

if ((n_pxls EQ 1) AND (~(keyword_set(oldnslow)))) then begin
    
	indx = reform(mapping_struct.indx_stack[*,*,0], /overwrite)
	for k = 0, (in_data_size.dimensions[2] > 1) - 1 do begin
    ;		out_data[*,*,k] = reform(in_data[*,*,k][indx], in_data_size.dimensions[0], in_data_size.dimensions[1], /overwrite)
    		out_data_band_vec = (in_data[*,*,k])[indx]
    		out_data_band = reform(out_data_band_vec, in_data_size.dimensions[0], in_data_size.dimensions[1])
	endfor
    ;indx = reform(mapping_struct.indx_stack[*,*,0], n_elements(mapping_struct.indx_stack[*,*,0]))
    
   ; for k = 0, (1 > in_data_size.dimensions[2]) -1 do begin
    ;	out_data_band_vec = (in_data[*,*,k])[indx]
    ;	out_data_band = reform(out_data_band_vec, in_data_size.dimensions[0], in_data_size.dimensions[1])
;	out_data[*,*,k] = out_data_band
    
   ; endfor

endif else begin

    for i = 0, mapping_struct_size.dimensions[0] -1 do begin
;	print, systime(0) + ': ' + strtrim(string(i+1),2) + '/' + strtrim(string(mapping_struct_size.dimensions[0]),2)

	for j = 0, mapping_struct_size.dimensions[1] -1 do begin


	    array_indx = array_indices(mapping_struct.indx_stack[*,*,0], mapping_struct.indx_stack[i,j,0:(n_pxls-1)])

	    if (n_pxls EQ 1) then begin
		;No inter-pixel processing - no sweat...

		out_data[i,j,*] = in_data[array_indx[0,0], array_indx[1,0],*]
	    endif else begin
		;Weighted average of multiple pixels...

		;stop

    		weighting_vector = 1.0 / (mapping_struct.dist_stack[i,j,0:(n_pxls-1)] + eps) / max(1.0 / (mapping_struct.dist_stack[i,j,0:(n_pxls-1)] + eps))	        
		;weighting_vector = 1.0 / (mapping_struct.dist_stack[i,j,*] + eps) / max(1.0 / (mapping_struct.dist_stack[i,j,*] + eps))
		;weighting_vector = 1.0 / (mapping_struct.dist_stack[545,186,*] + eps) / max(1.0 / (mapping_struct.dist_stack[545,186,*] + eps))
		;print, weighting_vector

		out_pxl_data = replicate(0.0, (1 > in_data_size.dimensions[2]))
		weighting_total = 0.0

    		ignore_check_spec = replicate(0, (1 > in_data_size.dimensions[2]))

    		if (total(in_mask[mapping_struct.indx_stack[i,j,0:(n_pxls-1)]]) EQ n_pxls) then begin

		    for l = 0, n_pxls -1 do begin
			in_pxl_data = in_data[array_indx[0,l], array_indx[1,l],*]
    	    		ignore_check_spec = ignore_check_spec + (in_pxl_data EQ ignore_val)

			out_pxl_data = out_pxl_data + in_pxl_data * weighting_vector[l]
			weighting_total = weighting_total + weighting_vector[l]
		    endfor

		    out_data[i,j,*] = out_pxl_data / weighting_total

    	    	    if (total(ignore_check_spec) GT 0) then begin
			ignore_check_indx = where(ignore_check_spec GT 0)
			out_data[i,j,ignore_check_indx] = ignore_val
		    endif

		endif	
    	    endelse

	endfor
    endfor

endelse
		     
;stop

return, out_data

END
