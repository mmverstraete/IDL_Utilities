FUNCTION date_of_year, $
   day_of_year, $
   month, $
   day, $
   YEAR = year, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function reports the date corresponding to the rank
   ;  number day_of_year provided as input.
   ;
   ;  ALGORITHM: This function computes the date (month and day)
   ;  corresponding to the rank (day number within a civil year) provided
   ;  as input, either for a common year (if the keyword parameter YEAR is
   ;  not specified), or for that particular year if it is.
   ;
   ;  SYNTAX: rc = date_of_year(day_of_year, month, day, $
   ;  YEAR = year, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   day_of_year {INT} [I]: The rank (day number) of a day in a year,
   ;      a value expected to be in the range [1, 365] for a common year,
   ;      or [1, 366] for a leap year.
   ;
   ;  *   month {INT} [O]: The month in which this day falls.
   ;
   ;  *   day {INT} [O]: The day within that month.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   YEAR = year {INT} [I] (Default: None): The optional year number.
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
   ;      provided in the call. The output positional parameters month and
   ;      day provide the month and day numbers corresponding to the input
   ;      positional parameter day_of_year, for a non-leap year if the
   ;      optional input keyword parameter is either absent or points to a
   ;      non-leap year. If this optional input keyword parameter is
   ;      present in the call and points to a leap year, the output
   ;      positional parameters are specific for that year.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters month and day are set
   ;      to -1.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter day_of_year is not of
   ;      numeric type.
   ;
   ;  *   Error 120: An exception condition occurred in
   ;      days_per_month.pro.
   ;
   ;  *   Error 130: Input positional parameter day_of_year is invalid.
   ;
   ;  *   Error 200: Exception condition encountered in CASE statement:
   ;      the value of the input positional parameter day_of_year is
   ;      invalid. Set the optional keyword parameter DEBUG to get a more
   ;      specific diagnostic.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   days_per_month.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function cannot test and adjust for leap year if
   ;      the year is not specified, so in the absence of the input
   ;      keyword parameter YEAR = year, or if the specified year is not a
   ;      leap year, the value day_of_year = 366 is considered in error.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = date_of_year(60, month, day, $
   ;         DEBUG = 1, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'month = ', month, ' and day = ', day
   ;      month =        3 and day =        1
   ;
   ;      IDL> res = date_of_year(60, month, day, YEAR = 2004, $
   ;         DEBUG = 1, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'month = ', month, ' and day = ', day
   ;      month =        2 and day =       29
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–11–10: Version 0.9 — Initial release.
   ;
   ;  *   2017–-11–-20: Version 1.0 —– Initial public release.
   ;
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–04–03: Version 1.2 — Update the code to use the new
   ;      function
   ;      days_per_month.pro.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the assignment
   ;      of numeric return codes), and switch to 3-parts version
   ;      identifiers.
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

   ;  Set the default values of flags and essential keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Initialize the output positional parameter(s):
   month = -1
   day = -1

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 3
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): day_of_year, month, day.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'day_of_year' is not of numeric type:
      IF (is_numeric(day_of_year) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter day_of_year must be of numeric type.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the number of days per months in a common year, or in the particular
   ;  year if it has been specified (num_days[0] holds the total number of days
   ;  in the year):
   rc = days_per_month(num_days, YEAR = year, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (rc NE 0) THEN BEGIN
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with an invalid input positional parameter 'day_of_year':
      IF ((day_of_year LT 1) OR (day_of_year GT num_days[0])) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter day_of_year must be within ' + $
            'the range [1, ' + strstr(num_days[0]) + '].'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the cumulative number of days from the start of the year until the
   ;  end of each month in a common year:
   cum_num_days = INTARR(13)
   cum_num_days[0] = 0
   cum_num_days[1] = 31
   cum_num_days[2] = TOTAL(num_days[1:2])
   cum_num_days[3] = TOTAL(num_days[1:3])
   cum_num_days[4] = TOTAL(num_days[1:4])
   cum_num_days[5] = TOTAL(num_days[1:5])
   cum_num_days[6] = TOTAL(num_days[1:6])
   cum_num_days[7] = TOTAL(num_days[1:7])
   cum_num_days[8] = TOTAL(num_days[1:8])
   cum_num_days[9] = TOTAL(num_days[1:9])
   cum_num_days[10] = TOTAL(num_days[1:10])
   cum_num_days[11] = TOTAL(num_days[1:11])
   cum_num_days[12] = TOTAL(num_days[1:12])

   ;  Determine the date corresponding to the input positional parameter
   ;  'day_of_year' by identifying the month in which it falls and subtracting
   ;  the number of days in all previous completed months:
   CASE 1 OF
      (day_of_year GT cum_num_days[0]) AND $
      (day_of_year LE cum_num_days[1]): BEGIN
         month = 1
         day = day_of_year
      END
      (day_of_year GT cum_num_days[1]) AND $
      (day_of_year LE cum_num_days[2]): BEGIN
         month = 2
         day = day_of_year - cum_num_days[1]
      END
      (day_of_year GT cum_num_days[2]) AND $
      (day_of_year LE cum_num_days[3]): BEGIN
         month = 3
         day = day_of_year - cum_num_days[2]
      END
      (day_of_year GT cum_num_days[3]) AND $
      (day_of_year LE cum_num_days[4]): BEGIN
         month = 4
         day = day_of_year - cum_num_days[3]
      END
      (day_of_year GT cum_num_days[4]) AND $
      (day_of_year LE cum_num_days[5]): BEGIN
         month = 5
         day = day_of_year - cum_num_days[4]
      END
      (day_of_year GT cum_num_days[5]) AND $
      (day_of_year LE cum_num_days[6]): BEGIN
         month = 6
         day = day_of_year - cum_num_days[5]
      END
      (day_of_year GT cum_num_days[6]) AND $
      (day_of_year LE cum_num_days[7]): BEGIN
         month = 7
         day = day_of_year - cum_num_days[6]
      END
      (day_of_year GT cum_num_days[7]) AND $
      (day_of_year LE cum_num_days[8]): BEGIN
         month = 8
         day = day_of_year - cum_num_days[7]
      END
      (day_of_year GT cum_num_days[8]) AND $
      (day_of_year LE cum_num_days[9]): BEGIN
         month = 9
         day = day_of_year - cum_num_days[8]
      END
      (day_of_year GT cum_num_days[9]) AND $
      (day_of_year LE cum_num_days[10]): BEGIN
         month = 10
         day = day_of_year - cum_num_days[9]
      END
      (day_of_year GT cum_num_days[10]) AND $
      (day_of_year LE cum_num_days[11]): BEGIN
         month = 11
         day = day_of_year - cum_num_days[10]
      END
      (day_of_year GT cum_num_days[11]) AND $
      (day_of_year LE cum_num_days[12]): BEGIN
         month = 12
         day = day_of_year - cum_num_days[11]
      END
      ELSE: BEGIN
         error_code = 200
         excpt_cond = 'Unrecognized day_of_year.'
         RETURN, error_code
      END
   ENDCASE

   RETURN, return_code

END
