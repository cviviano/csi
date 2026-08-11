  ; ------------------------------------------------------------
  ; WELCOME TO THE CSI - CRISM SPECTRAL INTERROGATOR
  ; ------------------------------------------------------------
;+
; NAME:
;   CSI
;
; PURPOSE:
;   Launch the CRISM Spectral Investigation (CSI) software.
;
;   CSI is an IDL-based graphical interface for visualization and
;   analysis of Compact Reconnaissance Imaging Spectrometer for Mars
;   (CRISM) data. The software provides tools for defining regions of
;   interest, extracting and ratioing spectra, comparing CRISM spectra
;   with reference spectral libraries, and recording compositional and
;   morphologic observations.
;
;   This routine serves as the primary entry point for CSI. It establishes
;   the location of the CSI installation and associated ancillary resources,
;   adds the required CSI source directories to the IDL search path as
;   necessary, and launches CSI_DRIVER.
;
; CATEGORY:
;   Planetary remote sensing
;   Imaging spectroscopy
;   CRISM data analysis
;
; CALLING SEQUENCE:
;
;   CSI
;
;   or:
;
;   CSI, DIRECTORY=directory
;
; INPUTS:
;   None.
;
; KEYWORD PARAMETERS:
;
;   DIRECTORY:
;       Optional directory containing CRISM data products. If supplied,
;       this directory is used as the initial location when selecting
;       input CRISM products.
;
;   INFOHOLDERSET:
;       Optional CSI internal keyword used when restoring or transferring
;       an existing CSI analysis session/table. Normally this keyword does
;       not need to be specified by the user.
;
;   SKIP:
;       Optional CSI internal keyword used to modify the normal startup
;       sequence. Normally this keyword does not need to be specified by
;       the user.

pro csi, directory=directory, infoholderset=infoholderset, skip=skip

  compile_opt idl2

  ; ------------------------------------------------------------
  ; Determine the CSI installation directory
  ; ------------------------------------------------------------
  source_info = routine_info('csi', /source)
  csi_root = file_dirname(source_info.path)

  csi_code = file_dirname(source_info.path) + path_sep() + 'CSI_code'
  csi_ancillary = file_dirname(source_info.path) + path_sep() + 'CSI_ancillary'

  ; ------------------------------------------------------------
  ; Check that the repository looks complete
  ; ------------------------------------------------------------
  if ~file_test(csi_code, /directory) then begin
    message, 'CSI_code directory not found: ' + csi_code
  endif

  if ~file_test(csi_ancillary, /directory) then begin
    message, 'CSI_ancillary directory not found: ' + csi_ancillary
  endif

  ; ------------------------------------------------------------
  ; Add CSI_code to the IDL search path
  ; ------------------------------------------------------------
  if ~strpos(!path, csi_code) ge 0 then begin
    !path = csi_code + path_sep(/search_path) + !path
  endif

  ; ------------------------------------------------------------
  ; Launch CSI
  ; ------------------------------------------------------------
  csi_driver, directory=directory, $
              infoholderset=infoholderset, $
              skip=skip

end