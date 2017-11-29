FUNCTION date_of_year, day_of_year, month, day, YEAR = year, $
   EXCPT_COND = excpt_cond

   ;  Purpose:
   ;     This function converts the rank number 'day_of_year' (a value expected
   ;     to be in the range [1, 365] or [1, 366]) into a date, either for a
   ;     common year, or for the particular year specified in the optional
   ;     keyword parameter 'year', which can be a leap year.

   ;  Remark: the function cannot test and adjust for leap year if the year is not
   ;  specified, so in the absence of the keyword year, or if the year is not a
   ;  leap year, the day_of_year 366 is considered in error

   ;Sec-Doc
   ;  PURPOSE: This function computes the date (month and day)
   ;  corresponding to the rank (day number) provided as input.
   ;
   ;  ALGORITHM: This function computes the date (month and day)
   ;  corresponding to the rank (day number) provided as input, either for
   ;  a common year (if the keyword parameter YEAR is not specified), or
   ;  for that particular year if it is.
   ;
   ;  SYNTAX:
   ;  rc = date_of_year(day_of_year, month, day, YEAR = year, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   day_of_year {INT} [I]: The rank (day number) of a day in a year,
   ;      a value expected to be in the range [1, 365] for a common year,
   ;      or [1, 366] for a leap year.
   ;
   ;  *   month {INT} [O]: The month in which this day falls.
   ;
   ;  *   day {INT} [I]: The day within that month.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   YEAR = year {INT} [I] (Default: None): The optional year number.
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
   ;      provides the month and day numbers corresponding to the input
   ;      argument day_of_year to the calling routine through its output
   ;      positional parameters, returns 0 and the output keyword
   ;      parameter excpt_cond is set to a null string.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter day_of_year is not of
   ;      numeric type.
   ;
   ;  *   Error 120: Input positional parameter day_of_year is invalid.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_leap.pro
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
   ;      IDL> res = date_of_year(60, month, day, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'month = ', month, ' and day = ', day
   ;      month =        3 and day =        1
   ;
   ;      IDL> res = date_of_year(60, month, day, YEAR = 2004, EXCPT_COND = excpt_cond)
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
   ;  Initialize the return code and the error message:
   ret_code = 0
   excpt_cond = ''

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
   n_reqs = 3
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): day_of_year, month, day.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  argument 'day_of_year' is not of numeric type:
   n_reqs = 3
   IF (is_numeric(day_of_year) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter day_of_year must be of numeric type.'
      RETURN, error_code
   ENDIF

   ;  Set the number of days per months in a common year; the initial element
   ;  of this array will be used as an accumulator:
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

   ;  Set the maximum number of days in a common year:
   max_day_of_year = 365

   ;  If the keyword parameter 'year' is specified, check whether it is a
   ;  leap year, and if so adjust the number of days in February and the
   ;  maximum number of days in a leap year:
   IF (KEYWORD_SET(year)) THEN BEGIN
      rc = is_leap(year, EXCPT_COND = excpt_cond)
      IF (rc EQ 1) THEN BEGIN
         num_days[2] = 28
         max_day_of_year = 366
      ENDIF
   ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with an invalid input argument 'day_of_year':
   n_reqs = 1
   IF ((day_of_year LT 1) OR (day_of_year GT max_day_of_year)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input argument day_of_year must be within the range [1, ' + $
         strstr(max_day_of_year) + '].'
      RETURN, error_code
   ENDIF

   ;  Set the cumulative number of days from the start of the year until the
   ;  end of each month in a common year:
   cum_num_days = INTARR(13)
   cum_num_days[0] = 0
   cum_num_days[1] = 31
   cum_num_days[2] = TOTAL(num_days[0:2]) + (max_day_of_year EQ 366)
   cum_num_days[3] = TOTAL(num_days[0:3]) + (max_day_of_year EQ 366)
   cum_num_days[4] = TOTAL(num_days[0:4]) + (max_day_of_year EQ 366)
   cum_num_days[5] = TOTAL(num_days[0:5]) + (max_day_of_year EQ 366)
   cum_num_days[6] = TOTAL(num_days[0:6]) + (max_day_of_year EQ 366)
   cum_num_days[7] = TOTAL(num_days[0:7]) + (max_day_of_year EQ 366)
   cum_num_days[8] = TOTAL(num_days[0:8]) + (max_day_of_year EQ 366)
   cum_num_days[9] = TOTAL(num_days[0:9]) + (max_day_of_year EQ 366)
   cum_num_days[10] = TOTAL(num_days[0:10]) + (max_day_of_year EQ 366)
   cum_num_days[11] = TOTAL(num_days[0:11]) + (max_day_of_year EQ 366)
   cum_num_days[12] = TOTAL(num_days[0:12]) + (max_day_of_year EQ 366)

   ;  Determine the date corresponding to the input argument 'day_of_year':
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
   ENDCASE

   RETURN, ret_code

END
