pro csi_pick_phase_priority, names, dominant, secondary, accepted=accepted, group_leader=group_leader
  compile_opt idl2

  accepted = 0
  dominant = ''
  secondary = ''

  if n_elements(names) lt 2 then return

  base = widget_base(/column, /modal, title='Set Color Priority', group_leader=group_leader)

  dom_id = widget_droplist(base, title='Spectrally-dominant phase:', value=names, uvalue=domu)
  sec_id = widget_droplist(base, title='Secondary phase:', value=names, uvalue=secu)

  btnbase = widget_base(base, /row, /align_center)
  ok_id = widget_button(btnbase, value='OK', uvalue='ok')
  cancel_id = widget_button(btnbase, value='Cancel', uvalue='cancel')

  widget_control, dom_id, set_droplist_select=0
 ; widget_control, sec_id, set_droplist_select=(n_elements(names) gt 1 ? 1 : 0)
  widget_control, sec_id, set_droplist_select=1
  
  widget_control, base, /realize

  done = 0
  while done eq 0 do begin
    ev = widget_event(base)

    widget_control, ev.id, get_uvalue=uval

    if size(uval, /type) ne 7 then continue

    case strlowcase(uval) of

      'ok': begin
     ;   widget_control, dom_id, get_value=domval
     ;   widget_control, sec_id, get_value=secval

        dominant = strtrim(names[widget_info(dom_id, /DropList_Select)], 2)
        secondary = strtrim(names[widget_info(sec_id, /DropList_Select)], 2)

        if dominant eq secondary then begin
          junk=dialog_message('Please choose two different phases.', /error, title='Phase Priority')
        endif else begin
          accepted = 1
          done = 1
        endelse
      end

      'cancel': begin
        done = 1
      end

    endcase
  endwhile

  widget_control, base, /destroy
end