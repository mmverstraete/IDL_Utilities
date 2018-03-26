FUNCTION oom, arg, BASE = base, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This routine returns an integer value representing the
   ;  order of magnitude of the argument arg in the optional logarithmic
   ;  base base (10 by default).
   ;
   ;  ALGORITHM: The input positional parameters arg and the input keyword
   ;  parameter base (if provided) must both be strictly positive numbers,
   ;  in which case this function returns FLOOR(alogb(arg, base)). If
   ;  either is not strictly positive, the function returns NaN as well as
   ;  an exception condition.
   ;
   ;  SYNTAX: res = oom(arg, BASE = base, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg is an arbitrary but strictly positive numeric expression.
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
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns the order of magnitude of argument arg, and the output
   ;      keyword parameter excpt_cond is set to a null string, if the
   ;      optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
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
   ;  *   Error 120: Positional parameter arg is not strictly positive.
   ;
   ;  *   Error 130: Keyword parameter base is not of type numeric.
   ;
   ;  *   Error 140: Keyword parameter base is not strictly positive.
   ;
   ;  *   Error 200: An exception condition occurred in alogb.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Positional parameter arg and keyword parameter base must
   ;      both be strictly positive numbers. If the order of magnitude of
   ;      a negative number is required, provide the absolute value of
   ;      that number as the argument to oom.
   ;
   ;  *   NOTE 2: Arguments arg and base can be of any numeric type,
   ;      including COMPLEX or DOUBLE; the result will be of the same type
   ;      as arg.
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
   ;      IDL> c = 123
   ;      IDL> PRINT, oom(c, BASE = 5)
   ;                 2
   ;
   ;      IDL> e = 123.45
   ;      IDL> PRINT, oom(e, BASE = 2.8)
   ;                 4
   ;
   ;      IDL> f = -12
   ;      IDL> PRINT, oom(f, /DEBUG, EXCPT_COND = excpt_cond)
   ;                NaN
   ;      IDL> PRINT, excpt_cond
   ;      Error 110 in routine OOM: Argument arg is not
   ;      strictly positive.
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
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2018 Michel M. Verstraete.
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
   ;Sec-Cod
   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   IF KEYWORD_SET(debug) THEN BEGIN
      debug = 1
   ENDIF ELSE BEGIN
      debug = 0
   ENDELSE
   excpt_cond = ''

   res = MACHAR()
   smallest = res.XMIN
   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): arg.'
         RETURN, !VALUES.F_NAN
      ENDIF

   ;  Return to the calling routine with an error message if the argument 'arg'
   ;  is not of a numeric type:
      IF (is_numeric(arg) EQ 0) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         excpt_cond = 'Error 110 in routine ' + rout_name + $
            ': Argument arg is not numeric.'
         RETURN, !VALUES.F_NAN
      ENDIF

   ;  Return to the calling routine with an error message if the argument 'arg'
   ;  is not strictly positive:
      IF (arg LT smallest) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         excpt_cond = 'Error 120 in routine ' + rout_name + $
            ': Argument arg is not strictly positive.'
         RETURN, !VALUES.F_NAN
      ENDIF
   ENDIF

      IF (KEYWORD_SET(base)) THEN BEGIN

         IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if the keyword
   ;  parameter 'base' is of a numeric type:
            IF (is_numeric(base) EQ 0) THEN BEGIN
               info = SCOPE_TRACEBACK(/STRUCTURE)
               rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
               excpt_cond = 'Error 130 in routine ' + rout_name + $
                  ': Argument base is not numeric.'
               RETURN, !VALUES.F_NAN
            ENDIF

   ;  Return to the calling routine with an error message if the keyword
   ;  parameter 'base' is not strictly positive:
            IF (base LT smallest) THEN BEGIN
               info = SCOPE_TRACEBACK(/STRUCTURE)
               rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
               excpt_cond = 'Error 140 in routine ' + rout_name + $
                  ': Argument base is not strictly positive.'
               RETURN, !VALUES.F_NAN
            ENDIF
         ENDIF
      ENDIF ELSE BEGIN
         base = 10.0
      ENDELSE

   ;  Compute the order of magnitude of 'arg':
   res = FLOOR(alogb(arg, base, DEBUG = debug, EXCPT_COND = excpt_cond))

   IF ((debug) AND (excpt_cond NE '')) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      excpt_cond = 'Error 200 in routine ' + rout_name + $
         ': ' + excpt_cond
      RETURN, !VALUES.F_NAN
   ENDIF

   RETURN, res

END
