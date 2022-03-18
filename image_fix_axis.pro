
FUNCTION image_fix_axis, input

;+
; NAME:
;      IMAGE_FIX_AXIS()
;
; PURPOSE:
;      The IDL IMAGE object can take axis prescriptions that are not
;      uniformly spaced, but generally the image quality suffers when
;      this is done. This routine takes axes that are intended for
;      IMAGE and puts them on a uniform spacing. It also performs the
;      half-pixel correction necessary to replicate the behavior of
;      the SSW routine PLOT_IMAGE.
;
; CATEGORY:
;      Image display; axes.
;
; CALLING SEQUENCE:
;      Result = IMAGE_FIX_AXIS( Input )
;
; INPUTS:
;      Input:   A 1D input containing the grid values corresponding to
;               one axis of an iamge.
;
;
; OUTPUTS:
;      Returns an array of same size as INPUT, but on a uniform grid
;      spacing and with the pixel values shifted by half a pixel. If a
;      problem is found, then the value -1 is returned.
;
; EXAMPLE:
;      IDL> x=findgen(20)/5.
;      IDL> xnew=image_fix_axis(x)
;      IDL> print,xnew[0]
;          -0.100000
;
; MODIFICATION HISTORY:
;      Ver.1, 29-Mar-2018, Peter Young
;-

IF n_params() LT 1 THEN BEGIN
  print,'Use:  IDL> output=image_fix_axis(input)'
  return,-1
ENDIF 

n=n_elements(input)

IF n LT 3 THEN BEGIN
  print,'% IMAGE_FIX_AXIS: the input must contain at least 3 elements. Returning...'
  return,-1
ENDIF 

xstart=input[0]
xend=input[n-1]
xdiff=input[1:n-1]-input[0:n-2]
dx1=mean(xdiff)

dx2=(xend-xstart)/float(n-1)

IF abs(dx1-dx2)/dx2 GE 0.1 THEN BEGIN
  print,'% IMAGE_FIX_AXIS: Warning - the input axis shows significant non-uniformities.'
ENDIF 

output=findgen(n)*dx2 + xstart - dx2/2.

return,output

END
