FUNCTION chk_date_ymd, date, year, month, day, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function takes the STRING argument date, formatted as
   ;  YYYY-MM-DD, and provides the year, month and day values as output
   ;  numeric arguments.
   ;
   ;  ALGORITHM: This function splits the input argument date on character
   ;  * and sets the output arguments year, month and day to their
   ;  numerical values. If the input keyword parameter DEBUG is set, this
   ;  function checks the validity of date and of its 3 components: the
   ;  year number YYYY must be larger than 1582 and smaller than 2050, the
   ;  month number MM must be larger than 0 and smaller than 13, while the
   ;  day number DD must be larger than 0 and smaller than 31.
   ;
   ;  SYNTAX: rc = chk_date_ymd(date, year, month, day, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   date {STRING} [I]: A string indicating a date.
   ;
   ;  *   year {INTEGER} [O]: The numeric year of date date.
   ;
   ;  *   month {INTEGER} [O]: The numeric month of date date.
   ;
   ;  *   day {INTEGER} [O]: The numeric day of date date.
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
   ;  *   If no exception condition has been detected, the desired numeric
   ;      information is provided through the output positional
   ;      parameters, the function returns 0, and the keyword parameter
   ;      excpt_cond is set to a null string, if the optional input
   ;      keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, the values of the
   ;      invalid output positional parameters is set to 0, the function
   ;      returns a non-zero error code, and the keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
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
   ;  *   Error 180: An exception condition occurred in is_leap.pro.
   ;
   ;  *   Error 190: Positional parameter date specifies an invalid day.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_leap.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The month and day elements of the argument date must be
   ;      0-filled to make up a 10-character long string; hence a date
   ;      like 5 Feb 2011 must be provided as 2011-02-05.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = chk_date_ymd('2010-01-01', year, month, day, $
   ;         DEBUG = 1, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, '   >' + excpt_cond + '<'
   ;             0   ><
   ;      IDL> PRINT, year, month, day
   ;          2010       1       1
   ;
   ;      IDL> rc = chk_date_ymd('2100-01-01', year, month, day, $
   ;         DEBUG = 1, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, '   >' + excpt_cond + '<'
   ;           160   >Error 160 in CHK_DATE_YMD: Year 2100 is invalid
   ;           (must be 4 digits long and lie within [1582, 2050]).<
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–09–07: Version 1.0 — Initial release.
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
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
   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   IF KEYWORD_SET(debug) THEN BEGIN
      debug = 1
   ENDIF ELSE BEGIN
      debug = 0
   ENDELSE
   excpt_cond = ''

   ;  Initialize the output positional parameters to invalid values:
   year = 0
   month = 0
   day = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): date, year, month, day.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input argument
   ;  'date' is not of type STRING:
      IF (is_string(date) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument date is not of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input argument
   ;  'date' is not of length 10:
      IF (STRLEN(date) NE 10) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument date does not contain 10 characters.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input argument
   ;  'date' does not contain 2 dashes:
      pos1 = STRPOS(date, '-')
      IF (pos1 LE 0) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument date does not contain a dash character.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         pos2 = STRPOS(date, '-', pos1 + 1)
         IF (pos2 LE 0) THEN BEGIN
            info = SCOPE_TRACEBACK(/STRUCTURE)
            rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
            error_code = 140
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Argument date does not contain 2 dash characters.'
            RETURN, error_code
         ENDIF
      ENDELSE
   ENDIF

   ;  Isolate the nominal year and month of the date:
   parts = STRSPLIT(date, '-', COUNT = nparts, /EXTRACT)
   year = FIX(parts[0])
   month = FIX(parts[1])

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if the input argument
   ;  'date' is not formatted as a sequence of three elements separated by
   ;  dashes:
      IF (nparts NE 3) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument date does not contain 3 elements separated by 2 dashes.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the year is
   ;  invalid (year must be within [1582, 2050]):
      IF (((STRLEN(parts[0]) NE 4)) OR $
         (year LT 1582) OR $
         (year GT 2050)) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 160
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Year ' + strstr(year) + ' is invalid (must be 4 digits long ' + $
            'and lie within [1582, 2050]).'
         year = 0
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the month is
   ;  invalid:
      IF (((STRLEN(parts[1]) NE 2)) OR $
         (month LT 1) OR $
         (month GT 12)) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 170
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Month ' + strstr(month) + $
            ' is invalid (must be 2 digits long and lie within [1, 12]).'
         month = 0
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the number of days per months in a common year; the initial element
   ;  of this array may be used as an accumulator:
   num_days = INTARR(13)
   num_days[0] = 0
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

   ;  Reset the number of days in February if this is a leap year:
   rc = is_leap(year, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (rc EQ 1) THEN num_days[2] = 29
   IF ((debug) AND (rc EQ -1)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 180
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   day = FIX(parts[2])

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if the day is
   ;  invalid:
      IF ((STRLEN(parts[2]) NE 2) OR $
         (day LT 1) OR $
         (day GT num_days[month])) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 180
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Day ' + strstr(day) + ' is invalid (must be 2 digits long ' + $
            'and lie within [1, #days in the month]).'
         day = 0
         RETURN, error_code
      ENDIF
   ENDIF

  RETURN, return_code

END
