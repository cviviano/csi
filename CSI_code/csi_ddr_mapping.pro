
  ;02/26/2011 (fps)
  ;   Initial development - mro_crism_ddr_mapping
  ;   Typical CRISM VNIR/IR pair application for correlative processing: VNIR = base_ddr, IR = warp_ddr, /simultaneous
  ;   Typical CRISM VNIR/IR pair application for MTRDR processing: IR = base_ddr, VNIR = warp_ddr, /simultaneous
  ;09/06/2012 (fps)
  ;   Added support for base_mask keyword and mask handling
  ;     Only base_mask pixels are populated in outptut stacks
  ;   Added keyword /geo_ddr - input ddr info is GEO file - set appropriate offsets
  ;2017(?) (cev) 
  ;   Don't use struct in for loop
  ;01/30/2023 (cev)
  ;   Cleaned up for CSI
  
function csi_ddr_mapping, base_ddr, warp_ddr, neighbors = neighbors, simultaneous = simultaneous, $
  base_mask = base_mask, geo_ddr = geo_ddr
  
  if (not(keyword_set(neighbors))) then begin
    neighbors = 9
  endif
  
  base_ddr_size = size(base_ddr, /struct)
  warp_ddr_size = size(warp_ddr, /struct)
  
  if (not(keyword_set(base_mask))) then begin
    base_mask = make_array(base_ddr_size.dimensions[0], base_ddr_size.dimensions[1], value = 1b)
  endif
  
  if (keyword_set(geo_ddr)) then begin
    lat_indx_offset = 2
    lon_indx_offset = 4
  endif
  
  base_coord_struct = mro_crism_ddr_coord_convert(base_ddr, /return_struct, lat_indx_offset = lat_indx_offset, lon_indx_offset = lon_indx_offset)
  warp_coord_struct = mro_crism_ddr_coord_convert(warp_ddr, ref_coords = base_coord_struct.ref_coords, /return_struct, lat_indx_offset = lat_indx_offset, lon_indx_offset = lon_indx_offset)
  base_coord=base_coord_struct.coords
  warp_coord=warp_coord_struct.coords
  basedim=base_ddr_size.dimensions
  
  indx_stack = make_array(basedim[0], basedim[1], neighbors, value = -1, /long)
  dist_stack = make_array(basedim[0], basedim[1], neighbors, value = -1.0, /float)
  
  for i = 0, basedim[0] -1 do begin
    print, systime(0) + ': ' + strtrim(string(i+1),2) + '/' + strtrim(string(basedim[0]),2)
    for j = 0, basedim[1] -1 do begin
      if (base_mask[i,j] EQ 1) then begin
        target_coords = base_coord[i,j,*]
        if (keyword_set(simultaneous)) then begin
          line_indx = lindgen(neighbors/2 + 1) - neighbors/4 + j
          if (min(line_indx) LT 0) then begin
            line_indx = line_indx - min(line_indx)
          endif
          if (max(line_indx) GT (basedim[1] -1)) then begin
            line_indx = line_indx - (max(line_indx) - (basedim[1] -1))
          endif
        endif else begin
          line_indx = lindgen(basedim[1])
        endelse
        dist_map = sqrt((warp_coord[*,line_indx,0] - target_coords[0])^2.0 + (warp_coord[*,line_indx,1] - target_coords[1])^2.0)
        select_indx = (sort(dist_map))[0:neighbors-1]
        dist_stack[i,j,*] = dist_map[select_indx]
        if (keyword_set(simultaneous)) then begin          
          array_select_indx = array_indices(dist_map, select_indx)
          array_select_indx[1,*] = array_select_indx[1,*] + min(line_indx)
          select_indx = indices_array(array_select_indx, [basedim[0], basedim[1]])
        endif
        indx_stack[i,j,*] = select_indx
      endif
    endfor  
  endfor
  
  return, {indx_stack:indx_stack, dist_stack:dist_stack}
  
  
END