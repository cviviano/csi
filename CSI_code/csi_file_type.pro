;GUI to navigate to pick CRISM file type for CSI

pro csi_file_type_event, ev
  widget_control, ev.top, get_uvalue=pstate
  widget_control, ev.id, get_uvalue=buttonValues, /no_copy

  case buttonValues of
    'zero' : (*pstate).options=0
    'one': (*pstate).options=1
    'two': (*pstate).options=2
    'three':(*pstate).options=3
    'select': widget_control, ev.top, /destroy
    'cancel': begin
      (*pstate).accept=0
      widget_control, ev.top, /destroy
      end
  endcase
end

function csi_file_type, typelist=typelist
  base=widget_base(title = 'Select CRISM file type(s) to open:', /column )
    basebuttons=widget_base(base, column=1, /exclusive)
    button1=widget_button(basebuttons, value=typelist[0], uvalue='zero')
    button2=widget_button(basebuttons, value=typelist[1], uvalue='one')
    button3=widget_button(basebuttons, value=typelist[2], uvalue='two')
    button4=widget_button(basebuttons, value=typelist[3], uvalue='three')
    button5=widget_button(base, value='Select', uvalue='select')
    button6=widget_button(base, value='Cancel', uvalue='cancel')

    state1={options:0, accept:1}
    pstate=ptr_new(state1, /no_copy)
    widget_control, base, set_uvalue=pstate
    widget_control, base, /realize
  xmanager, 'csi_file_type', base
    state2={options:(*pstate).options, accept:(*pstate).accept}
    return, state2
  ptr_free, pstate
  
end