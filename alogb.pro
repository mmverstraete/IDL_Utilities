FUNCTION alogb, $
   arg, $
   base, $
   DOUBLE = double, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns the logarithm of the input positional
   ;  parameter arg to an arbitrary base.
   ;
   ;  ALGORITHM: This function computes the logarithm of a strictly
   ;  positive numeric (but not complex) scalar or array arg to an
   ;  arbitrary but strictly positive numeric (but not complex and
   ;  different from 1.0) scalar or array base as
   ;  log (arg, base) = log (arg, 10)/log (base, 10),
   ;  where both arg and base.
   ;
   ;  SYNTAX: res = alogb(arg, base, DOUBLE = double, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg {Number} [I]: An arbitrary but strictly positive numeric
   ;      (not complex) scalar or array.
   ;
   ;  *   base {Number} [I]: An arbitrary but strictly positive numeric
   ;      (not complex) scalar or array, different from 1.0.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   DOUBLE = double {INT} [I] (Default value: 0): Flag to request
   ;      computation in DOUBLE (1) or single (0) precision.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: FLOAT scalar or array, DOUBLE scalar or array,
   ;  or NaN.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns the following result, and the output keyword parameter
   ;      excpt_cond is set to a null string, if the optional input
   ;      keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided:
   ;
   ;      -   If arg is an array and base is a scalar, then the logarithm
   ;          of each element of arg is computed in base base.
   ;
   ;      -   If arg is a scalar and base is an array, then the logarithm
   ;          of arg is computed in each element of base base.
   ;
   ;      -   If arg and base are both arrays, the logarithm of each
   ;          element i of arg is computed in the corresponding element i
   ;          of base. And in that case, if these arrays are of different
   ;          sizes, the computation stops as soon as all elements of the
   ;          shorter array have been processed.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns NaN, and the output keyword parameter excpt_cond
   ;      contains a message about the exception condition encountered, if
   ;      the optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter arg is not of numeric type.
   ;
   ;  *   Error 120: Positional parameter base is not of numeric type.
   ;
   ;  *   Error 130: Positional parameters arg and/or base cannot be of
   ;      type COMPLEX or DCOMPLEX.
   ;
   ;  *   Error 140: Positional parameter arg is a scalar not strictly
   ;      positive.
   ;
   ;  *   Error 150: Positional parameter arg is an array with at least
   ;      one element not strictly positive.
   ;
   ;  *   Error 160: Positional parameter base is a scalar not strictly
   ;      positive.
   ;
   ;  *   Error 170: Positional parameter base is an array with at least
   ;      one element not strictly positive.
   ;
   ;  *   Error 180: Positional parameter base must be different from 1.0.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_complex.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Input positional parameters arg and base can be provided
   ;      in any positive numeric type, but the returned result will
   ;      always be of type FLOAT or DOUBLE.
   ;
   ;  *   NOTE 2: The function returns NaN if either input positional
   ;      parameter is not a strictly positive number.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> a = 100.0
   ;      IDL> res = alogb(a, 10)
   ;      IDL> PRINT, res
   ;            2.00000
   ;
   ;      IDL> res = alogb(a, 5, DOUBLE = 1, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;             2.8613531
   ;      IDL> PRINT, 5^res
   ;             100.00000
   ;
   ;      IDL> res = alogb(a, EXP(1.0), DOUBLE = 0)
   ;      IDL> PRINT, res
   ;             4.6051704
   ;      IDL> PRINT, EXP(4.60517)
   ;            100.000
   ;
   ;      IDL> res = alogb(-1.0, 10, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;                NaN
   ;      IDL> PRINT, excpt_cond
   ;      Error 140 in ALOGB: Input positional parameter arg
   ;         is a scalar not strictly positive.
   ;
   ;      IDL> res = alogb([10.0, 100.0, 1000.0], 10, DOUBLE = 0)
   ;      IDL> PRINT, 'res = ', res
   ;      res =       1.00000      2.00000      3.00000
   ;
   ;  REFERENCES:
   ;
   ;  *   https://en.wikipedia.org/wiki/Logarithm, accessed 3 Jan 2018.
   ;
   ;  *   https://en.wikipedia.org/wiki/Complex_logarithm, accessed 3
   ;      Jan 2018.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–05: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–02–24: Version 2.01 — Documentation update.
   ;
   ;Input positional parameter
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2019 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following three
   ;      conditions:
   ;
   ;      1. The above copyright notice and this permission notice shall
   ;      be included in its entirety in all copies or substantial
   ;      portions of the Software.
   ;
   ;      2. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
   ;      KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
   ;      WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE
   ;      AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;      3. The current version of this Software is freely available from
   ;
   ;      https://github.com/mmverstraete.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com
   ;Sec-Cod

   COMPILE_OPT idl2, HIDDEN

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code:
   return_code = 0

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(double)) THEN double = 1 ELSE double = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Define the smallest floating point number larger than 0:
      res = MACHAR()
      smallest = res.XMIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): arg, base.'
         RETURN, !VALUES.F_NAN
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'arg' is not of a numeric type:
      IF (is_numeric(arg) EQ 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter arg is not numeric.'
         RETURN, !VALUES.F_NAN
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'base' is not of a numeric type:
      IF (is_numeric(base) EQ 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter base is not numeric.'
         RETURN, !VALUES.F_NAN
      ENDIF

   ;  Return to the calling routine with an error message if either the input
   ;  positional parameter 'arg' or the input positional parameter 'base' is
   ;  of type COMPLEX:
      IF ((is_complex(arg)) OR (is_complex(base)) OR $
         (is_dcomplex(arg)) OR (is_dcomplex(base))) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameters arg and base cannot be ' + $
            'of type COMPLEX.'
         RETURN, !VALUES.F_NAN
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'arg' is not strictly positive:
      IF (is_array(arg) EQ 0) THEN BEGIN
         IF (arg LT smallest) THEN BEGIN
            error_code = 140
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Input positional parameter arg is a scalar not ' + $
               'strictly positive.'
            RETURN, !VALUES.F_NAN
         ENDIF
      ENDIF ELSE BEGIN
         FOR i = 0, N_ELEMENTS(arg) - 1 DO BEGIN
            IF (arg[i] LT smallest) THEN BEGIN
               error_code = 150
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Input positional parameter arg is an ' + $
                  'array with at least one element that is not ' + $
                  'strictly positive.'
               RETURN, !VALUES.F_NAN
            ENDIF
         ENDFOR
      ENDELSE

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'base' is not strictly positive:
      IF (is_array(base) EQ 0) THEN BEGIN
         IF (base LT smallest) THEN BEGIN
            error_code = 160
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Input positional parameter base is a scalar not ' + $
               'strictly positive.'
            RETURN, !VALUES.F_NAN
         ENDIF
      ENDIF ELSE BEGIN
         FOR i = 0, N_ELEMENTS(base) - 1 DO BEGIN
            IF (base[i] LT smallest) THEN BEGIN
               error_code = 170
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Input positional parameter base is an ' + $
                  'array with at least one element that is not strictly ' + $
                  'positive.'
               RETURN, !VALUES.F_NAN
            ENDIF
         ENDFOR
      ENDELSE

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'base' is equal to 1.0:
      IF (is_array(base) EQ 0) THEN BEGIN
         IF (base EQ 1.0) THEN BEGIN
            error_code = 180
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Input positional parameter base is a scalar equal to 1.0.'
            RETURN, !VALUES.F_NAN
         ENDIF
      ENDIF ELSE BEGIN
         FOR i = 0, N_ELEMENTS(base) - 1 DO BEGIN
            IF (base[i] EQ 1.0) THEN BEGIN
               error_code = 190
               excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
                  rout_name + ': Input positional parameter base is an ' + $
                  'array with at least one element that is equal to 1.0.'
               RETURN, !VALUES.F_NAN
            ENDIF
         ENDFOR
      ENDELSE
   ENDIF

   ;  Check whether computations need to be executed in double precision:
   IF (KEYWORD_SET(double)) THEN BEGIN
      arg = DOUBLE(arg)
      base = DOUBLE(base)
   ENDIF

   res = ALOG10(arg) / ALOG10(base)

   RETURN, res

END
