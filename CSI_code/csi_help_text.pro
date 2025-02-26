function csi_help_text, wrap_length

help_file='/project/crism/users/viviace1/crismidl/CSI_program/csi_help_text.txt'

help_str=read_string_file(help_file)

help_text=csi_wrap_string(help_str, wrap_length)

return, help_text
end