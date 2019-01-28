FUNCTION chk_ymddate, $
   date, $
   year, $
   month, $
   day, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function analyzes the STRING input positional
   ;  parameter date, formatted as YYYY-MM-DD, and provides the year,
   ;  month and day values as numeric output positional parameters.
   ;
   ;  ALGORITHM: This function splits the input positional parameter date
   ;  on character - and sets the output positional parameters year, month
   ;  and day to their numerical values. If the input keyword parameter
   ;  DEBUG is set, this function also checks the validity of date and of
   ;  its 3 components: the year number YYYY must be larger than 1582 and
   ;  smaller than 2100, the month number MM must be larger than 0 and
   ;  smaller than 13, while the day number DD must be larger than 0 and
   ;  smaller than the number of days in that month, accounting for the
   ;  possibility of a leap year.
   ;
   ;  SYNTAX: rc = chk_ymddate(date, year, month, day, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   date {STRING} [I]: A string indicating a date.
   ;
   ;  *   year {INT} [O]: The numeric year of date date.
   ;
   ;  *   month {INT} [O]: The numeric month of date date.
   ;
   ;  *   day {INT} [O]: The numeric day of date date.
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
   ;  RETURNED VALUE TYPE: INT.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output positional parameters year,
   ;      month and day provide the desired numeric information.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters corresponding to
   ;      invalid values are set to 0.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter date is not of type STRING.
   ;
   ;  *   Error 120: Positional parameter date is not of length 10.
   ;
   ;  *   Error 130: Positional parameter date does not contain a dash
   ;      character.
   ;
   ;  *   Error 140: Positional parameter date does not contain 2 dash
   ;      characters.
   ;
   ;  *   Error 150: Positional parameter date does not contain 3 elements
   ;      separated by 2 dashes.
   ;
   ;  *   Error 160: Positional parameter date specifies an invalid year.
   ;
   ;  *   Error 170: Positional parameter date specifies an invalid month.
   ;
   ;  *   Error 180: Positional parameter date specifies an invalid day.
   ;
   ;  *   Error 200: An exception condition occurred in
   ;      days_per_month.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   days_per_month.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Since the purpose of this function is to check the
   ;      validity of the input positional parameter date, all tests are
   ;      performed irrespective of the setting of the input keyword
   ;      parameter DEBUG. The keywords DEBUG and EXCPT_COND are included
   ;      for consistency, and to allow reporting of the exception
   ;      condition if one is encountered.
   ;
   ;  *   NOTE 2: The month and day elements of the input positional
   ;      parameter date must be 0-filled to make up a 10-character long
   ;      string; hence a date like 5 Feb 2011 must be provided as
   ;      2011-02-05.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = chk_ymddate('2010-01-01', year, month, day, $
   ;         DEBUG = 1, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, '   >' + excpt_cond + '<'
   ;             0   ><
   ;      IDL> PRINT, year, month, day
   ;          2010       1       1
   ;
   ;      IDL> rc = chk_ymddate('2200-01-01', year, month, day, $
   ;         DEBUG = 1, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, '   >' + excpt_cond + '<'
   ;           160   >Error 160 in CHK_DATE_YMD: Year 2200 is invalid
   ;            (must be 4 digits long and lie within [1582, 2100]).<
   ;
   ;      IDL> rc = chk_ymddate('1999-02-29', year, month, day, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, '   >' + excpt_cond + '<'
   ;           180   >Error 180 in CHK_DATE_YMD: Day 29 is invalid
   ;           (must be 2 digits long and lie within
   ;           [1, #days in the month]).<
   ;      IDL> PRINT, year, month, day
   ;          1999       2       0
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–09–07: Version 0.9 — Initial release under the name
   ;      chk_date_ymd.pro.
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–03–28: Version 1.2 — Update the code to use the new
   ;      function
   ;      days_per_month.pro.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–12–13: Version 1.6 — Rename this function to
   ;      chk_ymddate.pro.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
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
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Initialize the output positional parameter(s):
   year = 0
   month = 0
   day = 0

   ;  Implement all tests: See Note 1 above.

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
   n_reqs = 4
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): date, year, month, day.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'date' is not of type STRING:
   IF (is_string(date) NE 1) THEN BEGIN
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date is not of type STRING.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'date' is not of length 10:
   IF (STRLEN(date) NE 10) THEN BEGIN
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date does not contain 10 characters.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'date' does not contain 2 dashes:
   pos1 = STRPOS(date, '-')
   IF (pos1 LE 0) THEN BEGIN
      error_code = 130
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date does not contain a dash ' + $
         'character.'
      RETURN, error_code
   ENDIF ELSE BEGIN
      pos2 = STRPOS(date, '-', pos1 + 1)
      IF (pos2 LE 0) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter date does not contain 2 dash ' + $
            'characters.'
         RETURN, error_code
      ENDIF
   ENDELSE

   ;  Isolate the nominal year, month and day of the date:
   parts = STRSPLIT(date, '-', COUNT = nparts, /EXTRACT)
   year = FIX(parts[0])
   month = FIX(parts[1])
   day = FIX(parts[2])

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'date' is not formatted as a sequence of 3 elements
   ;  separated by 2 dashes (e.g., contains more than 2 dashes):
   IF (nparts NE 3) THEN BEGIN
      error_code = 150
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date does not contain 3 elements ' + $
         'separated by 2 dashes.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the year is
   ;  invalid (year must be within the range [1582, 2100]):
   IF (((STRLEN(parts[0]) NE 4)) OR $
      (year LT 1582) OR $
      (year GT 2100)) THEN BEGIN
      error_code = 160
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Year ' + strstr(year) + ' is invalid (must be 4 digits long ' + $
         'and lie within [1582, 2100]).'
      year = 0
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the month is
   ;  invalid:
   IF (((STRLEN(parts[1]) NE 2)) OR $
      (month LT 1) OR $
      (month GT 12)) THEN BEGIN
      error_code = 170
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Month ' + strstr(month) + $
         ' is invalid (must be 2 digits long and lie within [1, 12]).'
      month = 0
      RETURN, error_code
   ENDIF

   ;  Set the number of days per months in that year:
   rc = days_per_month(num_days, YEAR = year, $
      DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (rc NE 0) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the day is
   ;  invalid:
   IF ((STRLEN(parts[2]) NE 2) OR $
      (day LT 1) OR $
      (day GT num_days[month])) THEN BEGIN
      error_code = 180
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Day ' + strstr(day) + ' is invalid (must be 2 digits long ' + $
         'and lie within [1, #days in the month]).'
      day = 0
      RETURN, error_code
   ENDIF

  RETURN, return_code

END
