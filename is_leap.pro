FUNCTION is_leap, year, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function reports whether the input positional
   ;  parameter year is a leap year (1) or not (0).
   ;
   ;  ALGORITHM: For dates after 4 October 1582, a year that is exactly
   ;  divisible by four is a leap year, except that years which are
   ;  exactly divisible by 100 are not leap years, while centurial years
   ;  that are exactly divisible by 400 are leap years (See the references
   ;  section below).
   ;
   ;  SYNTAX: res = is_leap(year, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   year {INTEGER} [I]: The year to inspect.
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
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 1 if the input argument year is a leap year or 0 it is
   ;      not a leap year, and the output keyword parameter excpt_cond is
   ;      set to a null string, if the optional input keyword parameter
   ;      DEBUG is set and if the optional output keyword parameter
   ;      EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns -1, and the output keyword parameter excpt_cond contains
   ;      a message about the exception condition encountered, if the
   ;      optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Warning 10: The fractional part of positional parameter year is
   ;      ignored.
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter year is not of type numeric.
   ;
   ;  *   Error 120: Positional parameter year is anterior to 1582.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function is applicable only to dates of the
   ;      Gregorian calendar, i.e., years occurring after 4 October 1582.
   ;
   ;  *   NOTE 2: Fractional years are rounded off (FLOOR) by ignoring the
   ;      decimal part. A warning is issued but processing continues.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = is_leap(2015, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res, '   >' + excpt_cond + '<'
   ;             0   ><
   ;
   ;      IDL> res = is_leap(2016.7, DEBUG = 1, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res, '   >' + excpt_cond + '<'
   ;             1   >Warning 10 in IS_LEAP: Input argument 2016.70
   ;             has been rounded off to 2016. Processing continues.<
   ;
   ;      IDL> res = is_leap(512, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res, '   >' + excpt_cond + '<'
   ;            -1   >Error 120 in IS_LEAP: Input argument 512
   ;            is anterior to 1582.<
   ;
   ;  REFERENCES:
   ;
   ;  *   Web site: https://en.wikipedia.org/wiki/Leap_year, accessed on
   ;      2017-10-30.
   ;
   ;  *   IDL documentation for built-in routine JULDAY.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–05: Version 0.9 — Initial release.
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
   return_code = -1
   IF KEYWORD_SET(debug) THEN BEGIN
      debug = 1
   ENDIF ELSE BEGIN
      debug = 0
   ENDELSE
   excpt_cond = ''

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
            ' positional parameter(s): year.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if year is not a
   ;  numeric expression:
      IF (is_numeric(year) EQ 0) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input argument year is not numeric.'
         RETURN, return_code
      ENDIF
   ENDIF
   year = FLOOR(year)

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if year is prior
   ;  to 1582, because the leap year algorithm is only valid since then:
      IF (year LT 1582) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input argument ' + strstr(year) + $
            ' is anterior to 1582.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Determine whether year is a leap year:
   IF ((year MOD 4) NE 0) THEN BEGIN
      return_code = 0
   ENDIF ELSE BEGIN
      return_code = 1
      IF ((year MOD 100) EQ 0) THEN BEGIN
         return_code = 0
      ENDIF
      IF ((year MOD 400) EQ 0) THEN BEGIN
         return_code = 1
      ENDIF
   ENDELSE

   RETURN, return_code

END
