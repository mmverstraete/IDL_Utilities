FUNCTION round_dec, arg, n_dec, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function rounds the argument arg to a new
   ;  representation with only n_dec significant decimals.
   ;
   ;  ALGORITHM: This function implements the following rules:
   ;
   ;  *   If arg is of type BYTE (code 1), INT (code 2), LONG (code 3),
   ;      UINT (code 12), ULONG (code 13), LONG64 (code 14), or ULONG64
   ;      (code 15), the function returns the argument arg unmodified.
   ;
   ;  *   If arg is of type FLOAT (code 4), the function returns the
   ;      desired output provided the total number of significant digits
   ;      of the input argument does not exceed 6. The accuracy of the
   ;      result for longer input arguments cannot be guaranteed.
   ;
   ;  *   If arg is of type DOUBLE (code 5), the function returns the
   ;      desired output provided the total number of significant digits
   ;      of the input argument does not exceed 15. The accuracy of the
   ;      result for longer input arguments cannot be guaranteed.
   ;
   ;  *   If arg is of a numeric type different than those mentioned
   ;      above, the function returns NaN.
   ;
   ;  *   If n_dec is not of one of the numeric types, the function
   ;      returns the value NaN; if n_dec is a non-integer numeric
   ;      expression, its INT value, as returned by the FIX built-in
   ;      function is used.
   ;
   ;  SYNTAX:
   ;  res = round_dec(arg, n_dec, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg {Number} [I]: An arbitrary expression of type FLOAT or
   ;      DOUBLE. Integer values are tolerated (the function returns the
   ;      input unmodified). If arg is an array, each of its elements will
   ;      be treated in the same way.
   ;
   ;  *   n_dec {INTEGER} [I]: The desired number of decimal digits in the
   ;      result.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: Number or NaN.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected and the input
   ;      argument arg is of one of the INTEGER types, this function
   ;      return the value arg itself and the output keyword parameter
   ;      excpt_cond is set to a null string, if the optional input
   ;      keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided.
   ;
   ;  *   If no exception condition has been detected and the input
   ;      argument arg is either of type FLOAT or DOUBLE, this function
   ;      returns a numeric approximation of the input argument arg,
   ;      rounded to n_dec significant decimals, and the output keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG is set and if the optional output
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
   ;  *   Error 110: Input positional parameter n_dec must be numeric.
   ;
   ;  *   Error 120: Input positional parameter arg cannot be rounded
   ;      because it is not numeric or COMPLEX.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   type_of.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Floating point numbers often cannot be represented
   ;      internally with an exact number of decimals, hence, after
   ;      rounding off, the returned number is the closest to the desired
   ;      number but may still contain arbitrary digits in less
   ;      significant places.
   ;
   ;  *   NOTE 2: If the number of required decimals exceeds the inherent
   ;      precision of the input number, this function returns a result
   ;      equal to the input arg. See the examples below.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> arg = 12.345678
   ;      IDL> n_dec = 2
   ;      IDL> res = round_dec(arg, n_dec, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'arg = ', arg, 'n_dec = ', n_dec, 'res = ', res, $
   ;      > FORMAT = '(A6, 3X, F18.7, 3X, A8, I3, 3X, A6, F18.7)'
   ;      arg = 12.3456783   n_dec = 2   res = 12.3500004
   ;
   ;      IDL> arg = 12.987654
   ;      IDL> n_dec = 1
   ;      IDL> res = round_dec(arg, n_dec, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'arg = ', arg, 'n_dec = ', n_dec, 'res = ', res, $
   ;      > FORMAT = '(A6, 3X, F18.7, 3X, A8, I3, 3X, A6, F18.7)'
   ;      arg = 12.9876537   n_dec = 1   res = 13.0000000
   ;
   ;      IDL> arg = [1.23456, 2.34567]
   ;      IDL> n_dec = 1
   ;      IDL> res = round_dec(arg, n_dec, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, arg
   ;            1.23456      2.34567
   ;      IDL> PRINT, res
   ;            1.20000      2.30000
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
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

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): arg, n_dec.'
         RETURN, !VALUES.F_NAN
      ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  n_dec is not of a numeric type:
      IF (is_numeric(n_dec) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter n_dec must be numeric.'
         RETURN, !VALUES.F_NAN
      ENDIF
   ENDIF

   ;  Ensure that the argument n_dec is of type INT:
   n_dec = FIX(n_dec)

   ;  If the input argument is of type INTEGER, return it unmodified:
   res = type_of(arg, type_code, type_name)
   IF ((type_code EQ 1) OR (type_code EQ 2) OR (type_code EQ 3) OR $
      (type_code EQ 12) OR (type_code EQ 13) OR (type_code EQ 14) OR $
      (type_code EQ 15)) THEN BEGIN
      RETURN, arg
   ENDIF

   ;  If the input argument is of type FLOAT, compute the new value of
   ;  the decimal part and add it to the integer part:
   IF (type_code EQ 4) THEN BEGIN
      ori_dec = arg - FIX(arg)
      factor = 10.0^n_dec
      trn_dec = ROUND(ori_dec * factor) / factor
      val = FIX(arg) + trn_dec
      RETURN, val
   ENDIF

   ;  If the input argument is of type DOUBLE, compute the new value of
   ;  the decimal part and add it to the integer part:
   IF (type_code EQ 5) THEN BEGIN
      ori_dec = arg - LONG(arg)
      factor = 10.0D^n_dec
      trn_dec = ROUND(ori_dec * factor) / factor
      val = LONG(arg) + trn_dec
      RETURN, val
   ENDIF

   ;  In all other cases (e.g., COMPLEX, STRUCT, etc.), the input argument
   ;  arg is not numeric or cannot be simply rounded to a set number of
   ;  decimals:
   IF (debug) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input argument arg must be either FLOAT or DOUBLE.'
   ENDIF
   RETURN, !VALUES.F_NAN

END
