
PRO plot_vel_rgb_table, image, image_scale=image_scale, rgb_table=rgb_table, $
                        missing_value=missing_value, max_value=max_value, $
                        colorbar_rgb_table=colorbar_rgb_table


;+
; NAME:
;      PLOT_VEL_RGB_TABLE
;
; PURPOSE:
;      This routine takes an image which is assumed to be a
;      line-of-sight velocity map, and returns an RGB color table
;      (suitable for use as a rgb_table= input in IDL plot object
;      routines) together with a scaled image array to which the color
;      table applies.
;
; CATEGORY:
;      Image plotting; color tables.
;
; CALLING SEQUENCE:
;	PLOT_VEL_RGB_TABLE, Image
;
; INPUTS:
;      Image:   A 2D image.
;
; OPTIONAL INPUTS:
;      Missing_value:  A value that identifies missing data in the
;                      image array.
;      Max_value:   Sets the velocity range to be plotted, i.e.,
;                   velocities between -max_value and +max_value will
;                   be plotted.
;
; OPTIONAL OUTPUTS:
;      Image_Scale:  A byte-scale version of image created in order to
;                    match the color table stored in RGB_TABLE.
;      Rgb_Table:    A byte array containing the red-blue color table
;                    that will display IMAGE_SCALE correctly. This can
;                    be directly input to the IDL IMAGE plot object
;                    function. 
;      Max_Value:    If not specified as an input, then max_value will
;                    contain the maximum absolute value in the array.
;      Colorbar_Rgb_Table: This is a 2nd color table that is
;                    specifically meant to be used for the IDL
;                    COLORBAR plot object function.
;
; EXAMPLE:
;      plot_vel_rgb_table, image, rgb_table=rgb_table
;
; MODIFICATION HISTORY:
;      Ver.1, 17-Apr-2016, Peter Young
;         This code was originally in plot_map_obj.pro, but
;         it's generally useful so I've extracted it.
;      Ver.2, 7-Sep-2016, Peter Young
;         Expanded header; fixed bug with missing_value; added
;         colorbar_rgb_table optional output.
;-

;
; Flag any missing data (set to black in final image)
;
IF n_elements(missing_value) NE 0 THEN BEGIN 
  i_b=where(image EQ missing_value,n_b)
 ;
  IF n_elements(max_value) EQ 0 THEN BEGIN 
    k=where(image NE missing_value)
    max_value=max(abs(image[k]))
  ENDIF 
ENDIF ELSE BEGIN
  n_b=0
 ;
  IF n_elements(max_value) EQ 0 THEN BEGIN
    max_value=max(abs(image))
  ENDIF 
ENDELSE 


;
; Create color table. Bytes 1:126 will be blue, byte 127 will be white,
; and bytes 128:253 will be red. Byte 0 is reserved for missing data
; and will be black. Bytes 254 and 255 are not used but are colored white.
;
arr=byte(findgen(126)*253/125)
;
r=bytarr(256)
r[0]=0
r[127]=255
r[128:253]=255
r[1:126]=arr
r[254:255]=255
;
g=bytarr(256)
g[0]=0
g[127]=255
g[1:126]=arr
g[128:253]=reverse(arr)
g[254:255]=255
;
b=bytarr(256)
b[0]=0
b[127]=255
b[128:253]=reverse(arr)
b[1:126]=255
b[254:255]=255
;
rgb_table=[[r],[g],[b]]
;
;

;
; Convert input image to a suitable byte array
;
array_byte=bytscl(image,min=-max_value,max=max_value,top=252)
array_byte=array_byte+1b
image_scale=temporary(array_byte)
IF n_b NE 0 THEN image_scale[i_b]=0b


;
; If the color table is going to be used for the COLORBAR plot object,
; then it's necessary to use a slightly different rgb_table that
; doesn't have the special byte values (0, 254 and 255).
;
r=bytarr(256)+255b
g=bytarr(256)
b=bytarr(256)+255b
arr=byte(findgen(128)*255/127)
r[0:127]=arr
b[128:*]=reverse(arr)
g[0:127]=arr
g[128:*]=reverse(arr)

colorbar_rgb_table=[[r],[g],[b]]

END
