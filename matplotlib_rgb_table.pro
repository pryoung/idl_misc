
FUNCTION matplotlib_rgb_table, index, viridis=viridis, help=help, plasma=plasma, $
                              inferno=inferno, magma=magma, cividis=cividis

;+
; NAME:
;     MATPLOTLIB_RGB_TABLE
;
; PURPOSE:
;     Return an IDL RGB table that corresponds to one of the five Matplotlib
;     colormaps (viridis, plasma, inferno, magma, cividis).
;
; CATEGORY:
;     Plot; color table.
;
; CALLING SEQUENCE:
;     Result = MATPLOTLIB_RGB_TABLE( )
;
; INPUTS:
;     Index:  An integer from 0 to 4 that specfies which color table to use.
;             Use the /help keyword to see what the options are.
;
; KEYWORD PARAMETERS:
;     VIRIDIS:  Select the viridis colormap (default).
;     PLASMA:   Select the plasma colormap.
;     INFERNO:  Select the inferno colormap.
;     MAGMA:    Select the magma colormap.
;     CIVIDIS:   Select the cividis colormap.
;     HELP:     Lists the available options.
;
; OUTPUTS:
;     Returns a byte array of size (256,3) that contains the RGB color table.
;     This can be input to the IDL plot functions with the rgb_table= input.
;
; EXAMPLE:
;     IDL> rgb_table=matplotlib_rgb_table(/viridis)
;     IDL> p=image(image,rgb_table=rgb_table)
;
; MODIFICATION HISTORY:
;     Ver.1, 20-Dec-2024, Peter Young
;     Ver.2, 21-Jul-2025, Peter Young
;       Changed name to matplotlib_rgb_table, and the colormap files are now
;       located in the same directory as the routine.
;-


IF keyword_set(help) THEN BEGIN
  print,'An RGB table can be selected with:'
  print,'  rgb_table=matplotlib_rgb_table(index)'
  print,'where'
  print,'  0 - viridis (default)'
  print,'  1 - plasma'
  print,'  2 - inferno'
  print,'  3 - magma'
  print,'  4 - cividis'
  print,'The colormaps can be also be selected with a keyword, e.g., /plasma.'
  return,-1
ENDIF

ct_dir=file_dirname(file_which('matplotlib_rgb_table.pro'))

names=['viridis','plasma','inferno','magma','cividis']

IF n_elements(index) NE 0 THEN BEGIN
  name=names[index]
ENDIF ELSE BEGIN
  CASE 1 OF
    keyword_set(plasma): name='plasma'
    keyword_set(inferno): name='inferno'
    keyword_set(magma): name='magma'
    keyword_set(cividis): name='cividis'
    ELSE: name='viridis'
  ENDCASE
ENDELSE 
  


cmap_file=name+'_colormap.txt'
cmap_file=concat_dir(ct_dir,cmap_file)

chck=file_info(cmap_file)
IF chck.exists EQ 0 THEN BEGIN
  message,/info,/cont,'The colormap file was not found. Returning...'
  return,-1
ENDIF 

rgb_table=bytarr(3,256)

str1=''
openr,lin,cmap_file,/get_lun
readf,lin,str1
readf,lin,rgb_table
free_lun,lin

return,rearrange(rgb_table,[2,1])

END
