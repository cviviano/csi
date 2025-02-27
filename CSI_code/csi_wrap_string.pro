function csi_wrap_string, long_string, wrap_length

  if (!D.NAME eq 'WIN') then newline = string([13B, 10B]) else newline = string(10B)

paragraph_wrapped = ''

for i=0, n_elements(long_string)-1 do begin 
  ; Initialize variables
  wrapped_string = ''
  current_pos = 0
  str_length = strlen(long_string[i])
  final_space = 1
  
  ; Loop through the long string and wrap the text every 100 characters
  while  ~((current_pos lt str_length) xor ~(final_space eq 0)) do begin    
    ; Get the next characters
    this_string = strmid(long_string[i], current_pos, wrap_length)
    final_space=max(strsplit(this_string))
    if strlen(this_string) ge wrap_length then begin
      wrap_line=strmid(long_string[i], current_pos, final_space)
      wrapped_string = wrapped_string + wrap_line + newline
    endif else begin ;last line
      wrap_line=strmid(long_string[i], current_pos, strlen(long_string[i]))
      final_space=0
      wrapped_string = wrapped_string + wrap_line
    endelse    
    current_pos=current_pos+final_space
  endwhile
  paragraph_wrapped = paragraph_wrapped + wrapped_string + newline

endfor  
return, paragraph_wrapped

end