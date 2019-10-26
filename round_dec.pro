FUNCTION round_dec, $
   arg, $
   n_dec, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns a STRING representation of the input
   ;  positional parameter arg, rounded to n_dec decimals.
   ;
   ;  ALGORITHM: If the input positional parameter arg
   ;
   ;  *   is of type FLOAT, DOUBLE, COMPLEX or DCOMPLEX, the function
   ;      returns a STRING representation of arg with the specified number
   ;      of decimal places;
   ;
   ;  *   is of one of the integer types, the function returns arg
   ;      unchanged.
   ;
   ;  *   is not numeric, the function returns NaN.
   ;
   ;  SYNTAX: res = round_dec(arg, n_dec, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg {Number} [I]: An arbitrary numeric expression, typically of
   ;      one of the types FLOAT, DOUBLE, COMPLEX or DCOMPLEX. Integer
   ;      values are tolerated (the function returns the input
   ;      unmodified).
   ;
   ;  *   n_dec {INT} [I]: The desired number of decimal digits in the
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
   ;  RETURNED VALUE TYPE: STRING, or Number or NaN.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected and the type of the
   ;      input positional parameter arg is INTEGER, COMPLEX, or one of
   ;      the compound data types, this function returns the value arg
   ;      itself and the output keyword parameter excpt_cond is set to a
   ;      null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
   ;
   ;  *   If no exception condition has been detected and the input
   ;      positional parameter arg is either of type FLOAT or DOUBLE, this
   ;      function returns a numeric approximation of the input positional
   ;      parameter arg, rounded to n_dec significant decimals, and the
   ;      output keyword parameter excpt_cond is set to a null string, if
   ;      the optional input keyword parameter DEBUG is set and if the
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
   ;  *   Error 110: Input positional parameter arg must be numeric.
   ;
   ;  *   Error 120: Input positional parameter n_dec must be numeric.
   ;
   ;  *   Error 130: Input positional parameter n_dec must be a scalar.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_scalar.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   type_of.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The returned (STRING) value can be converted back to a
   ;      numeric expression using the IDL built-in functions FLOAT and
   ;      DOUBLE, for instance.
   ;
   ;  *   NOTE 2: The input positional parameter arg can be a scalar or an
   ;      array.
   ;
   ;  *   NOTE 3: If the required number of decimals n_dec exceeds the
   ;      number of decimals provided in the input positional parameter
   ;      arg, the result is padded with zeros.
   ;
   ;  *   NOTE 4: If the required number of decimals n_dec exceeds the
   ;      inherent precision of the input number, this function returns a
   ;      result equal to the input arg. See the examples below.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> arg = 12.345678
   ;      IDL> n_dec = 2
   ;      IDL> res = round_dec(arg, n_dec, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'arg = ', arg, 'n_dec = ', n_dec, 'res = ', res, $
   ;         FORMAT = '(A6, 3X, F18.7, 3X, A8, I3, 3X, A6, A)'
   ;      arg =            12.3456783   n_dec =   2   res = 12.35
   ;
   ;      IDL> arg = 12.987654
   ;      IDL> n_dec = 1
   ;      IDL> res = round_dec(arg, n_dec, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'arg = ', arg, 'n_dec = ', n_dec, 'res = ', res, $
   ;         FORMAT = '(A6, 3X, F18.7, 3X, A8, I3, 3X, A6, A)'
   ;      arg =            12.9876537   n_dec =   1   res = 13.0
   ;
   ;      IDL> arg = [1.23456, 2.34567]
   ;      IDL> n_dec = 1
   ;      IDL> res = round_dec(arg, n_dec, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, arg
   ;            1.23456      2.34567
   ;      IDL> PRINT, res
   ;            1.20000      2.30000
   ;
   ;      IDL> arg = [DCOMPLEX(12.345678, -98.432101), $
   ;         DCOMPLEX(-34.567890, 87.543215)]
   ;      IDL> n_dec = 2
   ;      IDL> res = round_dec(arg, n_dec)
   ;      IDL> PRINT, 'res = ' + res
   ;            res = (12.35, -98.43) res = (-34.57, 87.54)
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
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
   ;  *   2019–04–17: Version 2.01 — Update the code to always round the
   ;      decimal part of the input argument to 64-bit integers.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Improve the algorithm to handle
   ;      arrays and COMPLEX arguments, update the documentation, adopt
   ;      revised coding and documentation standards (in particular
   ;      regarding the assignment of numeric return codes), and switch to
   ;      3-parts version identifiers.
   ;
   ;  *   2019–10–05: Version 2.1.1 — Update the code to correctly handle
   ;      a null argument.
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
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   res_mac = MACHAR()
   smallest = res_mac.XMIN

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         excpt_cond = 'Error 100 in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): arg, n_dec.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter arg is not of a numeric type:
      IF (is_numeric(arg) NE 1) THEN BEGIN
         excpt_cond = 'Error 110 in ' + rout_name + $
            ': Input positional parameter arg must be numeric.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter n_dec is not of a numeric type:
      IF (is_numeric(n_dec) NE 1) THEN BEGIN
         excpt_cond = 'Error 120 in ' + rout_name + $
            ': Input positional parameter n_dec must be numeric.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter n_dec is not a scalar:
      IF (is_scalar(n_dec) NE 1) THEN BEGIN
         excpt_cond = 'Error 130 in ' + rout_name + $
            ': Input positional parameter n_dec must be a scalar.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Ensure that the input positional parameter n_dec is of type INT:
   n_dec = FIX(n_dec)

   res = type_of(arg, type_code, type_name)
   IF (is_scalar(arg) EQ 1) THEN BEGIN
      IF (ABS(arg) LT smallest) THEN BEGIN
         val = '0.' + strrepeat('0', n_dec)
         RETURN, val
      ENDIF ELSE BEGIN
         val = ''
         CASE type_code OF
            4: BEGIN
               val = strstr(STRING(arg, $
                  FORMAT = '(F' + strstr(MAX([oom(arg), 0]) + 3 + n_dec) + $
                  '.' + strstr(n_dec) + ')'))
               RETURN, val
            END
            5: BEGIN
               val = strstr(STRING(arg, $
                  FORMAT = '(D' + strstr(MAX([oom(arg), 0]) + 3 + n_dec) + $
                  '.' + strstr(n_dec) + ')'))
               RETURN, val
            END
            6: BEGIN
               val = COMPLEXROUND(arg * 10^n_dec) / 10^n_dec
               rp = strstr(REAL_PART(val))
               dp = STRPOS(rp, '.')
               rp = STRMID(rp, 0, dp + n_dec + 1)
               ip = strstr(IMAGINARY(val))
               dp = STRPOS(ip, '.')
               ip = STRMID(ip, 0, dp + n_dec + 1)
               val = '(' + rp + ', ' + ip + ')'
               RETURN, val
            END
            9: BEGIN
               val = COMPLEXROUND(arg * 10^n_dec) / 10^n_dec
               rp = strstr(REAL_PART(val))
               dp = STRPOS(rp, '.')
               rp = STRMID(rp, 0, dp + n_dec + 1)
               ip = strstr(IMAGINARY(val))
               dp = STRPOS(ip, '.')
               ip = STRMID(ip, 0, dp + n_dec + 1)
               val = '(' + rp + ', ' + ip + ')'
               RETURN, val
            END
            ELSE: RETURN, arg
         ENDCASE
      ENDELSE
   ENDIF ELSE BEGIN
      n_elem = N_ELEMENTS(arg)
      val = STRARR(n_elem)
      FOR i = 0, n_elem - 1 DO BEGIN
         IF (ABS(arg[i]) LT smallest) THEN BEGIN
            val[i] = '0.' + strrepeat('0', n_dec)
         ENDIF ELSE BEGIN
            CASE type_code OF
            4: BEGIN
               val[i] = strstr(STRING(arg[i], $
                  FORMAT = '(F' + strstr(MAX([oom(arg[i]), 0]) + 3 + $
                  n_dec)  + '.' + strstr(n_dec) + ')'))
            END
            5: BEGIN
               val[i] = strstr(STRING(arg[i], $
                  FORMAT = '(D' + strstr(MAX([oom(arg[i]), 0]) + 3 + $
                  n_dec) + '.' + strstr(n_dec) + ')'))
            END
            6: BEGIN
               tmp = COMPLEXROUND(arg[i] * 10^n_dec) / 10^n_dec
               rp = strstr(REAL_PART(tmp))
               dp = STRPOS(rp, '.')
               rp = STRMID(rp, 0, dp + n_dec + 1)
               ip = strstr(IMAGINARY(tmp))
               dp = STRPOS(ip, '.')
               ip = STRMID(ip, 0, dp + n_dec + 1)
               val[i] = '(' + rp + ', ' + ip + ')'
            END
            9: BEGIN
               tmp = COMPLEXROUND(arg[i] * 10^n_dec) / 10^n_dec
               rp = strstr(REAL_PART(tmp))
               dp = STRPOS(rp, '.')
               rp = STRMID(rp, 0, dp + n_dec + 1)
               ip = strstr(IMAGINARY(tmp))
               dp = STRPOS(ip, '.')
               ip = STRMID(ip, 0, dp + n_dec + 1)
               val[i] = '(' + rp + ', ' + ip + ')'
               END
               ELSE: val[i] = arg[i]
            ENDCASE
         ENDELSE
      ENDFOR
      RETURN, val
   ENDELSE

END
