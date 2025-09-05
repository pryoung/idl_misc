

FUNCTION color_tol, colname, bright=bright, vibrant=vibrant, example=example, $
                    high_contrast=high_contrast, muted=muted, $
                    medium_contrast=medium_contrast, color_list=color_list

;+
; NAME:
;     COLOR_TOL
;
; PURPOSE:
;     Returns RGB values for colors recommended on Paul Tol's website
;     (https://sronpersonalpages.nl/~pault/). Five color schemes are
;     implemented: vibrant (default), bright, high contrast, medium
;     contrast and muted.
;
; CATEGORY:
;     Plotting; colors.
;
; CALLING SEQUENCE:
;     Result = COLOR_TOL( Colname )
;
; INPUTS:
;     Colname: The name of a color. For example, 'blue', 'red'. Does not
;              accept vectors.
;
; KEYWORD PARAMETERS:
;     VIBRANT:  Use the "vibrant" color scheme (this is the default).
;     BRIGHT:  Use the "bright" color scheme.
;     HIGH_CONTRAST:  Use the "high contrast" color scheme.
;     MEDIUM_CONTRAST:  Use the "medium contrast" color scheme.
;     MUTED:   Use the "muted" color scheme.
;     EXAMPLE: If set, then the routine returns an IDL plot object showing
;              the color options for the color scheme.
;
; OUTPUTS:
;     If the requested color name (COLNAME) matches one of the options for
;     the color scheme, then a three element byte array is returned giving
;     the RGB values for the color. This array can then be used as an input
;     for any IDL object graphic routine that allows a color to be input
;     (see example below).
;
;     If there is not a match for COLNAME, then the routine prints a list
;     of the colors available for the color scheme.
;
;     If /example was set, then the output will be an IDL plot object that
;     shows the color options.
;
;     If a problem is found, or there is no color match, then -1 is returned.
;
; OPTIONAL OUTPUTS:
;     Color_List:  A string array giving the list of colors for the scheme.
;
; EXAMPLES:
;     Plot a blue line using the vibrant color scheme:
;
;     IDL> p=plot(findgen(5),th=3,color=color_tol('blue'))
;
;     Plot a dark yellow line using the medium contrast color scheme:
;
;     IDL> p=plot(findgen(5),th=3,color=color_tol('dark yellow',/medium_contrast))
;
;     Plot showing the options from the bright color scheme:
;
;     IDL> p=color_tol(/example,/bright)
;
;     Get the list of options for the high contrast color scheme:
;
;     IDL> rgb=color_tol(/high_contrast)
;
; MODIFICATION HISTORY:
;     Ver.1, 05-Sep-2025, Peter Young
;-


IF n_params() LT 1 THEN colname='no_name'

str={name: '', rgb: bytarr(3)}

CASE 1 OF 
  ;
  ; The /BRIGHT COLOR SCHEME
  ;
  keyword_set(bright): BEGIN
    ctname='bright'
    col=replicate(str,7)
    col.name=['blue','cyan','green','yellow','red','purple','grey']
    col[0].rgb=[68,119,170]
    col[1].rgb=[102,204,238]
    col[2].rgb=[34,136,51]
    col[3].rgb=[204,187,68]
    col[4].rgb=[238,102,119]
    col[5].rgb=[170,51,119]
    col[6].rgb=[187,187,187]
  END 
  ;
  ; The /HIGH_CONTRAST COLOR SCHEME
  ;
  keyword_set(high_contrast): BEGIN
    ctname='high_contrast'
    col=replicate(str,5)
    col.name=['white','yellow','red','blue','black']
    col[0].rgb=[255,255,255]
    col[1].rgb=[221,170,51]
    col[2].rgb=[187,85,102]
    col[3].rgb=[0,68,136]
    col[4].rgb=[0,0,0]
  END 
  ;
  ; The /MEDIUM_CONTRAST COLOR SCHEME
  ;
  keyword_set(medium_contrast): BEGIN
    ctname='medium_contrast'
    col=replicate(str,8)
    col.name=['white','light yellow','light red','light blue','dark yellow', $
              'dark red','dark blue','black']
    col[0].rgb=[255,255,255]
    col[1].rgb=[238,204,102]
    col[2].rgb=[238,153,170]
    col[3].rgb=[102,153,204]
    col[4].rgb=[153,119,0]
    col[5].rgb=[153,68,85]
    col[6].rgb=[0,68,136]
    col[7].rgb=[0,0,0]
  END 
  ;
  ; The /MUTED COLOR SCHEME
  ;
  keyword_set(muted): BEGIN
    ctname='muted'
    col=replicate(str,10)
    col.name=['indigo','cyan','teal','green','olive','sand','rose','wine', $
              'purple','pale gray']
    col[0].rgb=[51,34,136]
    col[1].rgb=[136,204,238]
    col[2].rgb=[68,170,153]
    col[3].rgb=[17,119,51]
    col[4].rgb=[153,153,51]
    col[5].rgb=[221,204,119]
    col[6].rgb=[204,102,119]
    col[7].rgb=[136,34,85]
    col[8].rgb=[170,68,153]
    col[9].rgb=[221,221,221]
  END 
  ;
  ; The /VIBRANT COLOR SCHEME (** this is the default **)
  ;
  ELSE: BEGIN
    ctname='vibrant'
    col=replicate(str,7)
    col.name=['blue','cyan','teal','orange','red','magenta','grey']
    col[0].rgb=[0,119,187]
    col[1].rgb=[51,187,238]
    col[2].rgb=[0,153,136]
    col[3].rgb=[238,119,51]
    col[4].rgb=[204,51,17]
    col[5].rgb=[238,51,119]
    col[6].rgb=[187,187,187]
  END 
ENDCASE

;
; This is an optional output, giving the list of colors for the scheme.
;
color_list=col.name

;
; If /example was set, then make a plot showing the color options.
; The plot object is returned to the user.
;
IF keyword_set(example) THEN BEGIN
  p=plot(/nodata,[0,1],[0,1],dim=[500,500],xthick=2,ythick=2, $
        xticklen=0.015,yticklen=0.015,font_size=14)
  nc=n_elements(col)
  dy=1/float(nc+1)
  FOR i=0,nc-1 DO BEGIN
    q=plot(/overplot,[0,1],(i+1)*dy*[1,1],color=col[i].rgb,thick=3)
    t=text(/data,0.05,(i+1)*dy,col[i].name,color=col[i].rgb,font_size=14)
  ENDFOR
  return,p
ENDIF 

;
; If colname was not specified, or it does not match one of the
; options, then print out the list of options.
;
chck=col.name.matches(strlowcase(colname))
IF total(chck) EQ 0 THEN BEGIN
  nc=n_elements(col)
  print,'The color options for /'+ctname+' are:'
  FOR i=0,nc-1 DO BEGIN
    print,format='(i7,".",2x,a14)',i+1,strpad(col[i].name,14,fill=' ',/after)
  ENDFOR
  return,-1
ENDIF ELSE BEGIN
  k=where(chck EQ 1)
  return,col[k[0]].rgb
ENDELSE 

END
