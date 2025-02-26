function csi_browse_info, detector=detector, browse_names=browse_names, browse_elements=browse_elements, browse_table=browse_table, browse_stretch=browse_stretch

  browse_vector = ['TRU', 'VNA', 'FEM', 'FM2', 'FAL', 'IRA', 'MAF', 'HYD', 'PHY', 'PFM', 'PAL', 'HYS', 'ICE', 'IC2', 'CHL', 'CAR', 'CR2', 'TAN']
  browse_detector = [0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,2]

  summary_table = [['R600', 'R530', 'R440'], $      ;TRU
    ['R770', 'R770', 'R770'], $                     ;VNA
    ['BD530_2', 'SH600_2', 'BDI1000VIS'], $         ;FEM
    ['BD530_2', 'BD920_2', 'BDI1000VIS'], $         ;FM2
    ['R2529', 'R1506', 'R1080'], $                  ;FAL
    ['R1330', 'R1330', 'R1330'], $                  ;IRA
    ['OLINDEX3', 'LCPINDEX2', 'HCPINDEX2'], $       ;MAF
    ['SINDEX2', 'BD2100_2', 'BD1900_2'], $          ;HYD
    ['D2300', 'D2200', 'BD1900R2'], $               ;PHY
    ['BD2355', 'D2300', 'BD2290'], $                ;PFM
    ['BD2210_2', 'BD2190', 'BD2165'], $             ;PAL
    ['MIN2250', 'BD2250', 'BD1900R2'], $            ;HYS
    ['BD1900_2', 'BD1500_2', 'BD1435'], $           ;ICE
    ['R3920', 'BD1500_2', 'BD1435'], $              ;IC2
    ['ISLOPE1', 'BD3000', 'IRR2'], $                ;CHL
    ['D2300', 'BD2500_2', 'BD1900_2'], $            ;CAR
    ['MIN2295_2480', 'MIN2345_2537', 'CINDEX2'], $  ;CR2
    ['R2529', 'R1330', 'R770']]                     ;TAN

    ; In the following hash map, an array of 4 numbers is assigned to each
  ; band. These 4 numbers (in order) are:
  ; (1) lower stretch
  ; (2) is lower stretch a percentile or summary parameter value
  ; (3) upper stretch percentile
  ; (4) upper stretch floor (if NaN, then has no floor)

  browse_stretch = hash( $
    'R770',         [0.1, 1, 99.9, !VALUES.F_NAN], $
    'R530',         [0.1, 1, 99.9, !VALUES.F_NAN], $
    'R440',         [0.1, 1, 99.9, !VALUES.F_NAN], $
    'R600',         [0.1, 1, 99.9, !VALUES.F_NAN], $
    'R1080',        [0.1, 1, 99.9, !VALUES.F_NAN], $
    ;'IRA',          [0.1, 1, 99.9, !VALUES.F_NAN], $
    'R1330',          [0.1, 1, 99.9, !VALUES.F_NAN], $
    'R1506',        [0.1, 1, 99.9, !VALUES.F_NAN], $
    'R2529',        [0.1, 1, 99.9, !VALUES.F_NAN], $
    'R3920',        [0.1, 1, 99.9, !VALUES.F_NAN], $
    'BD530_2',      [0.0, 0, 99.9, 0.28279391], $
    'SH600_2',      [0.1, 1, 99.9, !VALUES.F_NAN], $
    'BD920_2',      [0.0, 0, 99.9, 0.021907786], $
    'BDI1000VIS',   [0.0, 0, 99.9, 0.034919094], $
    ;'OLINDEX3',     [0.0, 0, 99.9, 0.27088563], $
    'OLINDEX3',     [0.0, 0, 99.9, 0.26000000], $
    'LCPINDEX2',    [0.0, 0, 99.9, 0.020295879], $
    'HCPINDEX2',    [0.0, 0, 99.9, 0.02579698], $
    'ISLOPE1',      [0.1, 1, 99.9, !VALUES.F_NAN], $
    'BD1435',       [0.0, 0, 99.9, 0.01557385], $
    'BD1500_2',     [0.0, 0, 99.9, 0.041867047], $
    'BD1900_2',     [0.0, 0, 99.9, 0.047125809], $
    'BD1900R2',     [0.0, 0, 99.9, 0.049939641], $
    'BD2100_2',     [0.0, 0, 99.9, 0.019579961], $
    'BD2165',     [0.0, 0, 99.9, 0.01], $
    'BD2190',     [0.0, 0, 99.9, 0.01], $
    'BD2210_2',     [0.005, 0, 99.9, 0.009435936], $
    ;'D2200',        [0.0, 0, 99.9, 0.012810982], $
    'D2200',        [0.0025, 0, 99.9, 0.020], $
    'BD2250',       [0.0, 0, 99.9, 0.009232168], $
    'MIN2250',      [0.0, 0, 99.9, 0.01], $
    'BD2290',       [0.0, 0, 99.9, 0.01], $
    'D2300',        [0.0, 0, 99.9, 0.03406233], $
    'BD2355',       [0.005, 0, 99.9, 0.013198648], $
    'SINDEX2',      [0.005, 0, 99.9, 0.029477678],  $
    'MIN2295_2480', [0.0, 0, 99.9, 0.000613246], $
    'MIN2345_2537', [0.0, 0, 99.9, 0.006026381], $
    'BD2500_2',     [0.0, 0, 99.9, 0.004054254], $
    'BD3000',       [0.0, 0, 99.9, 0.87386216], $
    'CINDEX2',      [0.0, 0, 99.9, 0.01], $
    'IRR2',         [0.1, 1, 99.9, !VALUES.F_NAN] $
    )

if keyword_set(browse_names) then begin
   if detector eq 'S' then return, browse_vector(where(browse_detector eq 0))
   if detector eq 'L' then return, browse_vector(where(browse_detector eq 1))
   if detector eq 'J' then return, browse_vector
endif 

if keyword_set(browse_table) then begin
  if detector eq 'S' then return, summary_table[*,(where(browse_detector eq 0))]
  if detector eq 'L' then return, summary_table[*,(where(browse_detector eq 1))]
  if detector eq 'J' then return, summary_table
endif

if keyword_set(browse_elements) then begin
  if detector eq 'S' then return, n_elements(where(browse_detector eq 0))
  if detector eq 'L' then return, n_elements(where(browse_detector eq 1))
  if detector eq 'J' then return, n_elements(browse_detector)  
endif

if keyword_set(browse_stretch) then return, browse_stretch

end