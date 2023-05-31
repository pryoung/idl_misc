
FUNCTION thermal_width, lambda, n, temp, velocity=velocity, quiet=quiet

;+
; NAME:
;     THERMAL_WIDTH()
;
; PURPOSE:
;     Computes the thermal width of an emission line given the wavelength, 
;     atomic mass number of the element and the temperature. The expression
;     used is
;
;      width^2 = 4 ln(2) (lambda/c)^2 2kT /M
;
;     If /velocity is set, then the velocity width is calculated. This
;     is given by:
;
;     vwidth = sqrt( 2kT/M )
;
;     Note that the velocity width is *not* the FWHM converted to
;     velocity units.
;
; CATEGORY:
;     Emission lines; width.
;
; CALLING SEQUENCE:
;     Result = THERMAL_WIDTH( Lambda, N, Temp )
;
; INPUTS:
;     Lambda:  Wavelength of emission line (angstroms).
;     N:       Atomic mass number of element.
;     Temp:    Temperature. If the input value is less than 10, then
;              the log of the temperature is assumed to have been input.
;
; KEYWORD PARAMETERS:
;     VELOCITY: If set, then the velocity width is returned.
;     QUIET:    If set, then information messages are not printed to the IDL
;              window.
;
; OUTPUTS:
;     The thermal FWHM of the emission line in angstroms. If /velocity
;     is set, then the value returned is *not* the FWHM converted into
;     velocity units, but the mean velocity of the ions (see
;     explanation above).
;
; EXAMPLE:
;     IDL> w=thermal_width(192.0,56,2e7)
;     IDL> w=thermal_width(1393.7,14,8e4,/vel)
;
; MODIFICATION HISTORY:
;     Ver.1, 20-Jan-03, Peter Young
;     Ver.2, 2-Aug-06, Peter Young
;       now returns velocity width if /velocity set.
;     Ver.3, 6-Sep-2012, Peter Young
;       routine is now a function; added /quiet keyword; the velocity
;       width is now correctly calculated.
;     Ver.4, 7-Oct-2022, Peter Young
;       I updated the constant 5.130d-13 as previously I was using the
;       proton mass instead of the atomic mass unit.
;     Ver.5, 31-May-2023, Peter Young
;       Updated header; tidied up text output.
;-


IF n_params() LT 3 THEN BEGIN
  print,'Use:  IDL> th_width = thermal_width ( lambda, n, temp [, /velocity] )'
  return,-1
ENDIF


IF temp LT 10. THEN ltemp=temp ELSE ltemp=alog10(temp)

IF NOT keyword_set(quiet) THEN BEGIN 
  print,format='("Wavelength [Ang]: ",f12.3)',lambda
  print,format='("Atomic weight: ",i3)',n
  print,format='("Log10 Temperature [K]: ",f9.2)',ltemp
ENDIF 

lambda=float(lambda)
n=float(n)

;
; I have a document on Overleaf that explains where the value 5.130d-13
; comes from.
;
width=5.130d-13*(10.^ltemp)*lambda^2/n
width=sqrt(width)

IF keyword_set(velocity) THEN BEGIN
  dlambda=width/sqrt(4.*alog(2))
  vwidth=lamb2v(dlambda,lambda)
  IF NOT keyword_set(quiet) THEN BEGIN 
    print,''
    print,format='("Velocity width / km/s: ",f10.1)',vwidth
    print,''
    print,'  (Note that the velocity width is not the FWHM.)'
  ENDIF 
  return,vwidth
ENDIF ELSE BEGIN
  IF NOT keyword_set(quiet) THEN BEGIN 
    print,''
    print,format='("Width / Ang: ",f10.4)',width
  ENDIF 
  return,width
ENDELSE


END
