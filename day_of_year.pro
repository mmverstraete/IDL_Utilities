FUNCTION day_of_year, month, day, YEAR = year, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function computes the rank (day number) of a date
   ;  specified by the month and day numbers provided as input arguments,
   ;  either for an arbitrary common year, or for the particular year
   ;  specified in the optional keyword parameter year.
   ;
   ;  ALGORITHM: By default, this function accumulates and returns the
   ;  number of days between January 1 and the date specified by the
   ;  positional parameters month and day, for a common (non leap) year.
   ;  If the optional keyword parameter year is set to a particular value,
   ;  this function computes the rank of the specified date taking into
   ;  account the leap status of that year.
   ;
   ;  SYNTAX:
   ;  res = day_of_year(month, day, YEAR = year, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   month {INTEGER} [I]: The month of the date to characterize,
   ;      where January is 1, February is 2, … and December is 12.
   ;
   ;  *   day {INTEGER} [I]: The day within the month of the date to
   ;      characterize, where the first day of the month is 1 and the last
   ;      day of the month is either 28, 30 or 31, depending on the month.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   YEAR = year {INTEGER} [I]: The specific year for which the
   ;      computation must be carried out.
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
   ;      returns the rank number of the specified day in a common year
   ;      (if the keyword year was not set) or in the specified year (if
   ;      the keyword was set), and the output keyword parameter
   ;      excpt_cond is set to a null string.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns -1, and the output keyword parameter excpt_cond contains
   ;      a message about the exception condition encountered.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter month is not a scalar variable
   ;      of type numeric.
   ;
   ;  *   Error 120: Positional parameter month is invalid: Must be
   ;      contained in [1, 12].
   ;
   ;  *   Error 130: Keyword parameter year is not a scalar variable of
   ;      type numeric.
   ;
   ;  *   Error 140: Keyword parameter year is invalid: Must be contained
   ;      within [1582, 10000].
   ;
   ;  *   Error 150: Positional parameter day is not a scalar variable of
   ;      type numeric.
   ;
   ;  *   Error 160: Positional parameter day is invalid: Must be
   ;      contained in [1, num_days[month]].
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_leap.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_scalar.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: By default, this function accumulates and returns the
   ;      number of days between January 1 and the date specified by the
   ;      positional parameters month and day, for a common (non leap)
   ;      year. If the optional keyword parameter year is set to a
   ;      particular value, this routine computes the rank of the
   ;      specified date taking into account the leap status of that year.
   ;
   ;  *   NOTE 2: If day is set to 29 (implying a leap year), the keyword
   ;      parameter year must be provided, otherwise the function returns
   ;      an error code.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = day_of_year(3, 25, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;            84
   ;      IDL> PRINT, 'excpt_cond = >' + excpt_cond + '<'
   ;      excpt_cond = ><
   ;
   ;      IDL> res = day_of_year(6, 13, YEAR = 2000, $
   ;         EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;           165
   ;      IDL> PRINT, 'excpt_cond = >' + excpt_cond + '<'
   ;      excpt_cond = ><
   ;
   ;      IDL> res = day_of_year(2, 29, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;            -1
   ;      IDL> PRINT, 'excpt_cond = ' + excpt_cond
   ;      excpt_cond = Error 134 in day_of_year: Input argument day
   ;         is invalid: Must be contained in [1, num_days[month]].
   ;
   ;      IDL> res = day_of_year(2, 29, YEAR = 2016, $
   ;         EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;            60
   ;      IDL> PRINT, 'excpt_cond = >' + excpt_cond + '<'
   ;      excpt_cond = ><
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
   ;  Initialize the default return code and the default exception condition
   ;  message:
   return_code = -1
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
         ' positional parameter(s): month, day.'
      RETURN, return_code
   ENDIF

   ;  Return to the calling routine with an error message if month is not a
   ;  scalar numeric expression:
   IF ((is_numeric(month) NE 1) OR (is_scalar(month) NE 1)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input argument month is not a scalar numeric expression.'
      RETURN, return_code
   ENDIF
   month = FIX(month)

   ;  Return to the calling routine with an error message if month is not
   ;  within the allowed range:
   IF ((month LT 1) OR (month GT 12)) THEN BEGIN
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in day_of_year: ' + $
         'Input argument month is invalid: Must be contained in [1, 12].'
      RETURN, return_code
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

   ;  Determine whether the optional keyword parameter year has been set and,
   ;  in that case, whether it specifies a leap year:
   IF (KEYWORD_SET(year)) THEN BEGIN

      ;  Return to the calling routine with an error message if year is not a
      ;  scalar numeric expression:
      IF ((is_numeric(year) NE 1) OR (is_scalar(year) NE 1)) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input argument year is not a scalar numeric expression.'
         RETURN, return_code
      ENDIF
      year = FIX(year)

      ;  Return to the calling routine with an error message if year is not
      ;  within the allowed range, restricted by is_leap and a reasonable
      ;  maximum value for year:
      IF ((year LT 1582) OR (year GT 10000)) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Keyword parameter year is invalid: Must be within ' + $
            '[1582, 10000].'
         RETURN, return_code
      ENDIF

      ;  Adjust the number of days for February if necessary:
      IF (is_leap(year)) THEN num_days[2] = 29
   ENDIF

   ;  Return to the calling routine with an error message if day is not a
   ;  defined scalar expression:
   IF ((is_numeric(day) NE 1) OR (is_scalar(day) NE 1)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input argument day is not a scalar numeric expression.'
      RETURN, return_code
   ENDIF
   day = FIX(day)

   ;  Return to the calling routine with an error message if day is not
   ;  within the allowed range:
   IF ((day LT 1) OR (day GT num_days[month])) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 160
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input argument day is invalid: Must be contained in ' + $
         '[1, ' + strstr(num_days[month]) + '].'
      RETURN, return_code
   ENDIF

   ;  Accumulate the number of days until the provided date (inclusive), noting
   ;  that the accumulation is taking place in num_days[0], and that the
   ;  indexing of num_days for actual months is 1-based:
   FOR i = 0, month - 1 DO BEGIN
      num_days[0] = num_days[0] + num_days[i]
   ENDFOR
   num_days[0] = num_days[0] + day

   RETURN, num_days[0]

END
