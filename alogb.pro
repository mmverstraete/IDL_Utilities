FUNCTION alogb, arg, base, DOUBLE = double, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns the logarithm of a strictly positive
   ;  number arg to an arbitrary but strictly positive base base.
   ;
   ;  ALGORITHM: This function verifies the validity of the input
   ;  arguments arg and base, and computes the logarithm of arg in base
   ;  base, if the operation is allowed, as
   ;  log(arg, base)=log(arg, 10)/log(base, 10).
   ;
   ;  SYNTAX:
   ;  res = alogb(arg, base, DOUBLE = double, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg {Number} [I]: An arbitrary but strictly positive number.
   ;
   ;  *   base {Number} [I]: An arbitrary but strictly positive number
   ;      different from 1.0.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   DOUBLE = double {INTEGER} [I] (Default value: 0): Flag to
   ;      request that computations be conducted in DOUBLE precision (1).
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: FLOAT, DOUBLE or NaN.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns the logarithm of arg in base base, as a single or double
   ;      precision number, depending on the setting of the optional input
   ;      keyword parameter DOUBLE, and the output keyword parameter
   ;      excpt_cond is set to a null string.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns NaN, and the output keyword parameter excpt_cond
   ;      contains a message about the exception condition encountered.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Argument arg is not of numeric type.
   ;
   ;  *   Error 120: Argument arg is not strictly positive.
   ;
   ;  *   Error 130: Argument base is not of numeric type.
   ;
   ;  *   Error 140: Argument base is not strictly positive.
   ;
   ;  *   Error 150: Argument base must be different from 1.0.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_complex.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_single.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Arguments arg and base can be provided in any positive
   ;      numeric type, but the returned result will always be of type
   ;      FLOAT or DOUBLE.
   ;
   ;  *   NOTE 2: The function returns NaN if either input argument is not
   ;      a strictly positive number.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> a = 100.0
   ;      IDL> res = alogb(a, 10)
   ;      IDL> PRINT, res
   ;            2.00000
   ;
   ;      IDL> res = alogb(a, 5)
   ;      IDL> PRINT, res
   ;            2.86135
   ;      IDL> PRINT, 5^res
   ;            100.000
   ;
   ;      IDL> res = alogb(a, EXP(1.0))
   ;      IDL> PRINT, res
   ;            4.60517
   ;      IDL> PRINT, EXP(4.60517)
   ;            100.000
   ;
   ;      IDL> res = alogb(-1.0, 10, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;                NaN
   ;      IDL> PRINT, excpt_cond
   ;      Error 110 in routine ALOGB: Argument arg is not strictly
   ;      positive.
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–05: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
   ;
   ;
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017 Michel M. Verstraete.
   ;
   ;      Permission is hereby granted, free of charge, to any person
   ;      obtaining a copy of this software and associated documentation
   ;      files (the “Software”), to deal in the Software without
   ;      restriction, including without limitation the rights to use,
   ;      copy, modify, merge, publish, distribute, sublicense, and/or
   ;      sell copies of the Software, and to permit persons to whom the
   ;      Software is furnished to do so, subject to the following
   ;      conditions:
   ;
   ;      The above copyright notice and this permission notice shall be
   ;      included in all copies or substantial portions of the Software.
   ;
   ;      THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND,
   ;      EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
   ;      OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
   ;      NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
   ;      HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
   ;      WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
   ;      FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
   ;      OTHER DEALINGS IN THE SOFTWARE.
   ;
   ;      See: https://opensource.org/licenses/MIT.
   ;
   ;  *   Feedback
   ;
   ;      Please send comments and suggestions to the author at
   ;      MMVerstraete@gmail.com.
   ;
   ;
   ;Sec-Cod
   ;  Initialize the default exception condition message:
   excpt_cond = ''

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
   n_reqs = 2
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): arg, base.'
      RETURN, !VALUES.F_NAN
   ENDIF

   ;  Ensure that argument 'arg' is of a numeric type:
   rc = is_numeric(arg)
   IF (rc EQ 0) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument arg is not numeric.'
      RETURN, !VALUES.F_NAN
   ENDIF

   ;  Ensure that argument 'arg' is strictly positive:
   res = MACHAR()
   smallest = res.XMIN
   IF (arg LT smallest) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument arg is not strictly positive.'
      RETURN, !VALUES.F_NAN
   ENDIF

   ;  Ensure that argument 'base' is of a numeric type:
   rc = is_numeric(base)
   IF (rc EQ 0) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 130
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument base is not numeric.'
      RETURN, !VALUES.F_NAN
   ENDIF

   ;  Ensure that argument 'base' is strictly positive:
   res = MACHAR()
   smallest = res.XMIN
   IF (base LT smallest) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 140
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument base is not strictly positive.'
      RETURN, !VALUES.F_NAN
   ENDIF

   ;  Ensure that argument 'base' is different from 1.0::
   IF (base EQ 1.0) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 150
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument base cannot be 1.0.'
      RETURN, !VALUES.F_NAN
   ENDIF

   ;  Check whether computations need to be executed in double precision:
   IF (KEYWORD_SET(double)) THEN BEGIN
      IF (is_single(arg)) THEN BEGIN
         IF (is_complex(arg)) THEN BEGIN
            arg = DCOMPLEX(arg)
         ENDIF ELSE BEGIN
            arg = DOUBLE(arg)
         ENDELSE
      ENDIF
   ENDIF

   res = ALOG10(arg) / ALOG10(base)

   RETURN, res

END
