FUNCTION chk_isodate, $
   isodate, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function checks the validity of the scalar input
   ;  positional parameter isodate.
   ;
   ;  ALGORITHM: This function verifies that the input positional
   ;  parameter isodate is a scalar STRING formatted as
   ;  yyyy-mm-ddThh:nn:ssZ where
   ;
   ;  *   yyyy is a valid 4-digit year number,
   ;
   ;  *   mm is a valid 2-digit month number,
   ;
   ;  *   dd is a valid 2-digit day number,
   ;
   ;  *   hh is a valid 2-digit hour number,
   ;
   ;  *   nn is a valid 2-digit minute number, and
   ;
   ;  *   ss is a valid 2-digit second number.
   ;
   ;  SYNTAX: rc = chk_isodate(isodate, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   isodate {STRING} [I]: A string containing a date and time
   ;      specification formatted as yyyy-mm-ddThh:nn:ssZ.
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
   ;      provided in the call. The input positional parameter isodate is
   ;      valid.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The input positional parameter isodate may be invalid.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter isodate is not of type
   ;      STRING.
   ;
   ;  *   Error 120: Input positional parameter isodate cannot be an
   ;      array.
   ;
   ;  *   Error 200: The input positional parameter isodate is incorrectly
   ;      formatted: it must contain 2 strings separated by T.
   ;
   ;  *   Error 210: The input positional parameter isodate is incorrectly
   ;      formatted: the date must contain 3 strings separated by -.
   ;
   ;  *   Error 220: The input positional parameter isodate is incorrectly
   ;      formatted: the time must contain 3 strings separated by :.
   ;
   ;  *   Error 230: The input positional parameter isodate is invalid:
   ;      the year must be within the range [1582, 2100].
   ;
   ;  *   Error 240: The input positional parameter isodate is invalid:
   ;      the month must be within the range [1, 12].
   ;
   ;  *   Error 250: An exception condition occurred in
   ;      days_per_month.pro.
   ;
   ;  *   Error 260: The input positional parameter isodate is invalid:
   ;      the day must be within the range [1, number of days in the
   ;      month].
   ;
   ;  *   Error 270: The input positional parameter isodate is invalid:
   ;      the hour must be within the range [0, 23].
   ;
   ;  *   Error 280: The input positional parameter isodate is invalid:
   ;      the minute must be within the range [0, 59].
   ;
   ;  *   Error 290: The input positional parameter isodate is invalid:
   ;      the second must be within the range [0, 59].
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   days_per_month.pro
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   last_char.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Since the purpose of this function is to check the
   ;      validity of the input positional parameter isodate, all tests
   ;      are performed irrespective of the setting of the input keyword
   ;      parameter DEBUG. The optional input keyword DEBUG is included
   ;      for consistency but its value on input is ignored, while the
   ;      optional output keyword parameter EXCPT_COND allows reporting of
   ;      the exception condition if one is encountered.
   ;
   ;  *   NOTE 2: The input positional parameter isodate cannot be an
   ;      array.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> isodate = '2018-06-13T12:00:00Z'
   ;      IDL> rc = chk_isodate(isodate, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + $
   ;         excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;
   ;      IDL> isodate = '2018-06-13T32:00:00Z'
   ;      IDL> rc = chk_isodate(isodate, DEBUG = 0, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + $
   ;         excpt_cond + '<'
   ;      rc = 270, excpt_cond = >Error 270 in CHK_ISODATE: Input positional
   ;         parameter isodate is invalid: the hour must be within the range
   ;         [0, 23].<
   ;
   ;      IDL> isodate = '2018-06-13T32:00:00Z'
   ;      IDL> rc = chk_isodate(isodate)
   ;      IDL> PRINT, 'rc = ' + strstr(rc)
   ;      rc = 270
   ;
   ;  REFERENCES:
   ;
   ;  *   https://www.w3.org/TR/NOTE-datetime, accessed on 21
   ;      November 2018.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–03–25: Version 0.9 — Initial release under the name
   ;      chk_date_iso.pro.
   ;
   ;  *   2018–03–28: Version 1.0 — Initial public release.
   ;
   ;  *   2018–04–03: Version 1.1 — Updated error diagnostics.
   ;
   ;  *   2018–04–23: Version 1.2 — Bug fix (missing parenthesis on line
   ;      287).
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–11–23: Version 1.6 — Change the name of the routine from
   ;      chk_date_iso.pro to chk_isodate.pro, remove the output
   ;      positional parameter julian_iso and the code to compute its
   ;      value, as this functionality is now available with function
   ;      iso2jul.pro, perform all diagnostic tests irrespective of the
   ;      value of the optional input keyword parameter DEBUG, and update
   ;      the documentation.
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
   return_code = 0

   ;  Set the default values of flags and essential keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Implement all tests on the input positional parameter: See Note 1 above.

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
   n_reqs = 1
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): isodate.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter isodate is not of type STRING:
   IF (is_string(isodate) NE 1) THEN BEGIN
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate must be of type STRING.'
      RETURN, error_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter isodate is an array:
   IF (is_array(isodate) EQ 1) THEN BEGIN
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate cannot be an array.'
      RETURN, error_code
   ENDIF

   ;  Split the input positional parameter into its 2 main components (date
   ;  and time):
   parts1 = STRSPLIT(isodate, 'T', COUNT = nparts1, /EXTRACT)
   IF (nparts1 NE 2) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is incorrectly formatted: ' + $
         'it must contain 2 strings separated by the character T.'
      RETURN, error_code
   ENDIF

   ;  Check that the date component contains 3 parts:
   parts2 = STRSPLIT(parts1[0], '-', COUNT = nparts2, /EXTRACT)
   IF (nparts2 NE 3) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is incorrectly formatted: ' + $
         'the date must contain 3 strings separated by dashes.'
      RETURN, error_code
   ENDIF

   ;  Remove the character 'Z' at the end of the time specification, if present:
   lstchr = last_char(parts1[1])
   IF ((lstchr EQ 'Z') OR (lstchr EQ 'z')) THEN $
      parts1[1] = STRMID(parts1[1], 0, STRLEN(parts1[1]) - 1)

   ;  Check that the time component contains 3 parts:
   parts3 = STRSPLIT(parts1[1], ':', COUNT = nparts3, /EXTRACT)
   IF (nparts3 NE 3) THEN BEGIN
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is incorrectly formatted: ' + $
         'the time must contain 3 strings separated by colons.'
      RETURN, error_code
   ENDIF

   ;  Extract the date and time components:
   yy = FIX(parts2[0])
   mm = FIX(parts2[1])
   dd = FIX(parts2[2])
   hh = FIX(parts3[0])
   nn = FIX(parts3[1])
   ss = FIX(parts3[2])

   ;  Check that the year is within the allowed range:
   IF ((yy LT 1582) OR (yy GT 2100)) THEN BEGIN
      error_code = 230
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is invalid: ' + $
         'the year must be within the range [1582, 2100].'
      RETURN, error_code
   ENDIF

   ;  Check that the month is within the allowed range:
   IF ((mm LT 1) OR (mm GT 12)) THEN BEGIN
      error_code = 240
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is invalid: ' + $
         'the month must be within the range [1, 12].'
      RETURN, error_code
   ENDIF

   ;  Check that the day is within the allowed range:
   rc = days_per_month(num_days, YEAR = yy, DEBUG = debug, $
      EXCPT_COND = excpt_cond)
   IF (rc NE 0) THEN BEGIN
      error_code = 250
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + excpt_cond
      RETURN, error_code
   ENDIF
   IF ((dd LT 1) OR (dd GT num_days[mm])) THEN BEGIN
      error_code = 260
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is invalid: ' + $
         'the day must be within the range [1, ' + strstr(num_days[mm]) + '].'
      RETURN, error_code
   ENDIF

   ;  Check that the hour is within the allowed range:
   IF ((hh LT 0) OR (hh GT 23)) THEN BEGIN
      error_code = 270
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is invalid: ' + $
         'the hour must be within the range [0, 23].'
      RETURN, error_code
   ENDIF

   ;  Check that the minute is within the allowed range:
   IF ((nn LT 0) OR (nn GT 59)) THEN BEGIN
      error_code = 280
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is invalid: ' + $
         'the minute must be within the range [0, 59].'
      RETURN, error_code
   ENDIF

   ;  Check that the second is within the allowed range:
   IF ((ss LT 0) OR (ss GT 59)) THEN BEGIN
      error_code = 290
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is invalid: ' + $
         'the second must be within the range [0, 59].'
      RETURN, error_code
   ENDIF

   RETURN, return_code

END
