FUNCTION day_of_year, $
   month, $
   day, $
   YEAR = year, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function computes the rank (day number) of a date
   ;  specified by the month and day numbers provided as input positional
   ;  parameters, either for an arbitrary common year, or for the
   ;  particular year specified in the optional keyword parameter year.
   ;
   ;  ALGORITHM: By default, this function accumulates and returns the
   ;  number of days between January 1 and the date specified by the
   ;  positional parameters month and day, for a common (non leap) year.
   ;  If the optional keyword parameter year is set to a particular value,
   ;  this function computes the rank of the specified date taking into
   ;  account the leap status of that year.
   ;
   ;  SYNTAX: res = day_of_year(month, day, YEAR = year, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   month {INT} [I]: The month of the date to characterize, where
   ;      January is 1, February is 2, … and December is 12.
   ;
   ;  *   day {INT} [I]: The day within the month of the date to
   ;      characterize, where the first day of the month is 1 and the last
   ;      day of the month is either 28, 30 or 31, depending on the month.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   YEAR = year {INT} [I]: The specific year for which the
   ;      computation must be carried out.
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
   ;      returns the rank number of the specified day in a common year
   ;      (if the keyword year was not set) or in the specified year (if
   ;      the keyword was set), and the output keyword parameter
   ;      excpt_cond is set to a null string, if the optional input
   ;      keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns -1, and the output keyword parameter excpt_cond contains
   ;      a message about the exception condition encountered, if the
   ;      optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
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
   ;      within [1582, 2100].
   ;
   ;  *   Error 150: Positional parameter day is not a scalar variable of
   ;      type numeric.
   ;
   ;  *   Error 160: Positional parameter day is invalid: Must be
   ;      contained in the interval [1, num_days[month]].
   ;
   ;  *   Error 200: An exception condition occurred in
   ;      days_per_month.pro.
   ;
   ;  *   Error 210: An exception condition occurred in
   ;      days_per_month.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   days_per_month.pro
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
   ;      an error code, provided the optional input keyword parameter
   ;      DEBUG is set.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = day_of_year(3, 25, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;            84
   ;      IDL> PRINT, 'excpt_cond = >' + excpt_cond + '<'
   ;      excpt_cond = ><
   ;
   ;      IDL> res = day_of_year(6, 13, YEAR = 2000, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;           165
   ;      IDL> PRINT, 'excpt_cond = >' + excpt_cond + '<'
   ;      excpt_cond = ><
   ;
   ;      IDL> res = day_of_year(2, 29, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;            -1
   ;      IDL> PRINT, 'excpt_cond = ' + excpt_cond
   ;      excpt_cond = Error 134 in day_of_year: Input positional parameter
   ;         day is invalid: Must be contained in [1, num_days[month]].
   ;
   ;      IDL> res = day_of_year(2, 29, YEAR = 2016, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;            60
   ;      IDL> PRINT, 'excpt_cond = >' + excpt_cond + '<'
   ;      excpt_cond = ><
   ;
   ;      [Note: Without the DEBUG option, the result is incorrect
   ;      (2015 is not a leap year) and the function does not report
   ;      the problem.]
   ;      IDL> res = day_of_year(2, 29, YEAR = 2015, DEBUG = 0, $
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
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
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
   ;  *   Copyright (C) 2017-2020 Michel M. Verstraete.
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
   ;      be included in their entirety in all copies or substantial
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
   return_code = -1

   ;  Set the default values of flags and essential keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): month, day.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if month is not a
   ;  scalar numeric expression:
      IF ((is_numeric(month) NE 1) OR (is_scalar(month) NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter month is not a scalar numeric ' + $
            'expression.'
         RETURN, return_code
      ENDIF
   ENDIF
   month = FIX(month)

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if month is not
   ;  within the allowed range:
      IF ((month LT 1) OR (month GT 12)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in day_of_year: ' + $
            'Input positional parameter month is invalid: Must be ' + $
            'contained in [1, 12].'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  If the year is specified:
   IF (KEYWORD_SET(year)) THEN BEGIN

      IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if year is not a
   ;  scalar numeric expression:
         IF ((is_numeric(year) NE 1) OR (is_scalar(year) NE 1)) THEN BEGIN
            error_code = 130
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Input positional parameter year is not a scalar ' + $
               'numeric expression.'
            RETURN, return_code
         ENDIF
      ENDIF

      year = FIX(year)

   ;  Return to the calling routine with an error message if year is not
   ;  withing the allowed range:
      IF ((year LT 1582) OR (year GT 2100)) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter year must be within [1582, 2100].'
         RETURN, return_code

      ENDIF

   ;  Set the number of days per months in the year:
      rc = days_per_month(num_days, YEAR = year, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 200
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF ELSE BEGIN
      rc = days_per_month(num_days, $
         DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (debug AND (rc NE 0)) THEN BEGIN
         error_code = 210
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF

   ENDELSE

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if day is not a
   ;  defined scalar expression:
      IF ((is_numeric(day) NE 1) OR (is_scalar(day) NE 1)) THEN BEGIN
         error_code = 150
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter day is not a scalar numeric ' + $
            'expression.'
         RETURN, return_code
      ENDIF
   ENDIF

   day = FIX(day)

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if day is not
   ;  within the allowed range:
      IF ((day LT 1) OR (day GT num_days[month])) THEN BEGIN
         error_code = 160
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter day is invalid: Must be ' + $
            'contained in ' + '[1, ' + strstr(num_days[month]) + '].'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Accumulate the number of days until the provided date (inclusive), noting
   ;  that the accumulation is taking place in num_days[0], and that the
   ;  indexing of num_days for actual months is 1-based:
   num_days[0] = 0
   FOR i = 0, month - 1 DO BEGIN
      num_days[0] = num_days[0] + num_days[i]
   ENDFOR
   num_days[0] = num_days[0] + day

   RETURN, num_days[0]

END
