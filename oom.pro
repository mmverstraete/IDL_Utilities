FUNCTION oom, $
   arg, $
   BASE = base, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This routine returns an integer value representing the
   ;  order of magnitude of the absolute value of the input positional
   ;  parameter arg in the optional logarithmic base base (10 by default).
   ;
   ;  ALGORITHM: If the input positional parameter arg is not null and if
   ;  the optional keyword parameter base is strictly positive, the
   ;  function returns FLOOR(alogb(ABS(arg), base)). In all other cases,
   ;  the function returns NaN and raises an exception condition.
   ;
   ;  SYNTAX: res = oom(arg, BASE = base, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg is an arbitrary but non-null numeric expression.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   BASE = base {Numeric} [I] (Default value: 10.0): An arbitrary
   ;      but strictly positive numeric expression.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: INT.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns the order of magnitude of the absolute value of the
   ;      input positional parameter arg, and the output keyword parameter
   ;      excpt_cond is set to a null string, if the optional input
   ;      keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided.
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
   ;  *   Error 110: Positional parameter arg is not of type numeric.
   ;
   ;  *   Error 120: Input keyword parameter base is specified but not
   ;      numeric.
   ;
   ;  *   Error 130: Input keyword parameter base is not strictly
   ;      positive.
   ;
   ;  *   Error 200: Scalar input keyword parameter arg is
   ;      indistinguishable from 0.0.
   ;
   ;  *   Error 210: An exception condition occurred in function
   ;      alogb.pro.
   ;
   ;  *   Error 220: At least one of the elements of the array input
   ;      positional parameter arg is indistinguishable from 0.0.
   ;
   ;  *   Error 230: An exception condition occurred in function
   ;      alogb.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   alogb.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The input positional parameter arg can be a scalar or an
   ;      array.
   ;
   ;  *   NOTE 2: If the input positional parameter arg is of type
   ;      COMPLEX, the function returns the order of magnitude of the
   ;      modulus of the complex number, which can be larger than either
   ;      of the components of that number: See the examples below.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> a = 99.9
   ;      IDL> PRINT, oom(a)
   ;                 1
   ;
   ;      IDL> b = 100.0
   ;      IDL> PRINT, oom(b)
   ;                 2
   ;
   ;      IDL> c = -1234.56
   ;      IDL> PRINT, oom(c)
   ;                 3
   ;
   ;      IDL> d = 1.0E-50
   ;      IDL> PRINT, oom(d)
   ;        2147483647
   ;      % Program caused arithmetic error: Floating divide by 0
   ;      % Program caused arithmetic error: Floating illegal operand
   ;      IDL> PRINT, oom(d, /DEBUG, EXCPT_COND = excpt_cond)
   ;                NaN
   ;      IDL> PRINT, 'excpt_cond = ' + excpt_cond
   ;      excpt_cond = Error 200 in OOM: Scalar input positional parameter arg is indistinguishable from 0.0.
   ;
   ;      IDL> e = [234.0, -32.1]
   ;      IDL> PRINT, oom(e)
   ;             2       1
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–05: Version 0.8 — Initial release.
   ;
   ;  *   2017–07–11: Version 0.9 — Moved former input positional
   ;      parameter base into an optional keyword parameter.
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
   ;  *   2019–08–20: Version 2.1.0 — Update the function to handle
   ;      negative input positional parameters arg, update the
   ;      documentation, adopt revised coding and documentation standards
   ;      (in particular regarding the assignment of numeric return
   ;      codes), and switch to 3-parts version identifiers.
   ;
   ;  *   2019–10–05: Version 2.1.1 — Simplify and update the code to
   ;      handle array arguments, update the documentation.
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
   return_code = !VALUES.F_NAN

   ;  Set the default values of flags and essential keyword parameters:
   IF (~KEYWORD_SET(base)) THEN base = 10.0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   res_mac = MACHAR()
   smallest = res_mac.XMIN

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): arg.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'arg' is not of a numeric type:
      IF (is_numeric(arg) EQ 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter arg is not numeric.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the keyword
   ;  parameter 'base' is defined and not of a numeric type:
      IF (KEYWORD_SET(base) AND (is_numeric(base) EQ 0)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input keyword parameter base is specified but not numeric.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the keyword
   ;  parameter 'base' is defined and not strictly positive:
      IF (KEYWORD_SET(base) AND (base LT smallest)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input keyword parameter base is not strictly positive.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Ensure that the evaluation is performed on positive input positional
   ;  parameter(s) arg:
   absarg = ABS(arg)

   ;  Return to the calling routine with an error message if the scalar input
   ;  positional parameter 'arg' is indistinguishable from 0.0; otherwise
   ;  compute the order of magnitude of the input argument:
   IF (is_scalar(absarg) EQ 1) THEN BEGIN
      IF (debug AND (absarg LT smallest)) THEN BEGIN
         error_code = 200
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Scalar input positional parameter arg is indistinguishable ' + $
            'from 0.0.'
         RETURN, return_code
      ENDIF
      res_oom = FLOOR(alogb(absarg, base, $
         DEBUG = debug, EXCPT_COND = excpt_cond))
      IF (debug AND (excpt_cond NE '')) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, return_code
      ENDIF
   ENDIF ELSE BEGIN

   ;  Return to the calling routine with an error message if one of the
   ;  elements of the array input positional parameter 'arg' is
   ;  indistinguishable from 0.0; otherwise compute the order of magnitude
   ;  of each element of the input argument:
      n_elem = N_ELEMENTS(absarg)
      res_oom = INTARR(n_elem)
      FOR i = 0, N_ELEMENTS(absarg) - 1 DO BEGIN
         IF (debug AND (absarg[i] LT smallest)) THEN BEGIN
            error_code = 220
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': At least one of the elements of the array input ' + $
               'positional parameter arg is indistinguishable from 0.0.'
            RETURN, return_code
         ENDIF
         res_oom[i] = FLOOR(alogb(absarg[i], base, $
            DEBUG = debug, EXCPT_COND = excpt_cond))
         IF (debug AND (excpt_cond NE '')) THEN BEGIN
            error_code = 230
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': ' + excpt_cond
            RETURN, return_code
         ENDIF
      ENDFOR
   ENDELSE

   RETURN, res_oom

END
