FUNCTION days_per_month, num_days, YEAR = year, DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function sets the number of days per month, for either
   ;  a generic or a particular year (specified through the keyword year),
   ;  in which case it adjusts the number of days in February if that year
   ;  is a leap year.
   ;
   ;  ALGORITHM: This function defines the output positional parameter
   ;  num_days as a 13-element INT array, sets num_days[0] to 365 and
   ;  assigns the default number of days to each month of the year in
   ;  array elements 1 to 12. If the keyword parameter year is provided,
   ;  the function checks whether that year is a leap year and adjusts the
   ;  number of days in February as well as the total number of days in
   ;  the year accordingly.
   ;
   ;  SYNTAX: rc = days_per_month(num_days, YEAR = year, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   num_days {INTEGER} [O]: Array containing the number of days of
   ;      each month, as well as the total number of days in the year.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   YEAR = year {INT} [I] (Default value: None): Optional year
   ;      number in the range [1584, 2100], for the purpose of determining
   ;      if that year is a leap year.
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
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output positional parameter num_days
   ;      contains the results generated by this function.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter num_days may be
   ;      undefined or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input keyword parameter year is invalid: it must be
   ;      within the range [1582, 2100].
   ;
   ;  *   Error 120: An exception condition occurred in is_leap.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_leap.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> year = 2016
   ;      IDL> rc = days_per_month(num_days, YEAR = year, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;      IDL> PRINT, 'num_days = ', num_days, FORMAT = '(A, 13I5)'
   ;      num_days = 366  31  29  31  30  31  30  31  31  30  31  30  31
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–03–24: Version 0.9 — Initial release.
   ;
   ;  *   2018–03–28: Version 1.0 — Initial public release.
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
   IF (KEYWORD_SET(debug)) THEN BEGIN
      debug = 1
   ENDIF ELSE BEGIN
      debug = 0
   ENDELSE
   excpt_cond = ''

   ;  Define the output positional parameter num_days as an integer array and
   ;  initialize its elements to invalid values:
   num_days = INTARR(13)
   num_days[*] = -1

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
            ' positional parameter(s): num_days.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with an invalid keyword parameter year:
      IF (KEYWORD_SET(year)) THEN BEGIN
         IF ((year LT 1582) OR (year GT 2100)) THEN BEGIN
            info = SCOPE_TRACEBACK(/STRUCTURE)
            rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
            error_code = 110
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Keyword parameter year is invalid: must be within [1582, 2100].'
            RETURN, error_code
         ENDIF
      ENDIF

   ENDIF

   ;  Set the number of days per months in a common year in array elements
   ;  num_days[1] to num_days[12], and the total number of days in the year
   ;  in element num_days[0]:
   num_days[0] = 365
   num_days[1] = 31
   num_days[2] = 28
   num_days[3] = 31
   num_days[4] = 30
   num_days[5] = 31
   num_days[6] = 30
   num_days[7] = 31
   num_days[8] = 31
   num_days[9] = 30
   num_days[10] = 31
   num_days[11] = 30
   num_days[12] = 31

   ;  If the keyword parameter 'year' is specified, check whether it is a
   ;  leap year, and if so adjust the number of days in February and the
   ;  total number of days in that year:
   IF (KEYWORD_SET(year)) THEN BEGIN
      rc = is_leap(year, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc EQ 1) THEN BEGIN
         num_days[2] = 29
         num_days[0] = 366
      ENDIF
      IF ((debug) AND (rc EQ -1)) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   RETURN, return_code

END
