FUNCTION chk_date_iso, date_iso, julian_iso, DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function checks the validity of the argument date_iso
   ;  and computes the Julian day equivalent.
   ;
   ;  ALGORITHM: This function verifies that the argument date_iso is
   ;  formatted as a string like yy-mm-ddThh:nn:ss where
   ;
   ;  *   yy is a 4-digit year number,
   ;
   ;  *   mm is a 2-digit month number,
   ;
   ;  *   dd is a 2-digit day number,
   ;
   ;  *   hh is a 2-digit hour number,
   ;
   ;  *   nn is a 2-digit minute number, and
   ;
   ;  *   ss is a 2-digit second number.
   ;
   ;  If so, it computes the equivalent Julian day specification.
   ;
   ;  SYNTAX: rc = chk_date_iso(date_iso, julian_iso, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   date_iso {STRING} [I]: A string containing a date and time
   ;      specification formatted as yy-mm-ddThh:nn:ss.
   ;
   ;  *   julian_iso {DOUBLE} [O]: The Julian day number corresponding to
   ;      the date_iso.
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
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output positional parameter julian_iso
   ;      contains the Julian day number corresponding to date_iso.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter julian_iso may be
   ;      undefined or invalid.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter date_iso is not of type
   ;      STRING.
   ;
   ;  *   Error 200: The input positional parameter date_iso is
   ;      incorrectly formatted: it must contain 2 strings separated by T.
   ;
   ;  *   Error 210: The input positional parameter date_iso is
   ;      incorrectly formatted: the date must contain 3 strings separated
   ;      by -.
   ;
   ;  *   Error 220: The input positional parameter date_iso is
   ;      incorrectly formatted: the time must contain 3 strings separated
   ;      by :.
   ;
   ;  *   Error 300: The input positional parameter date_iso is invalid:
   ;      the year must be within the range [1582, 2100].
   ;
   ;  *   Error 310: The input positional parameter date_iso is invalid:
   ;      the month must be within the range [1, 12].
   ;
   ;  *   Error 320: An exception condition occurred in
   ;      days_per_month.pro.
   ;
   ;  *   Error 330: The input positional parameter date_iso is invalid:
   ;      the day must be within the range [1, number of days in the
   ;      month].
   ;
   ;  *   Error 340: The input positional parameter date_iso is invalid:
   ;      the hour must be within the range [0, 23].
   ;
   ;  *   Error 350: The input positional parameter date_iso is invalid:
   ;      the minute must be within the range [0, 59].
   ;
   ;  *   Error 360: The input positional parameter date_iso is invalid:
   ;      the second must be within the range [0, 59].
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   days_per_month.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> date_iso = '2018-06-13T12:00:00'
   ;      IDL> rc = chk_date_iso(date_iso, julian_iso, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;      IDL> PRINT, 'julian_iso = ', julian_iso
   ;      julian_iso =        2458283.0
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–03–25: Version 0.9 — Initial release.
   ;
   ;  *   2018–03–28: Version 1.0 — Initial public release.
   ;
   ;  *   2018–04–03: Version 1.1 — Updated error diagnostics.
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
   IF KEYWORD_SET(debug) THEN BEGIN
      debug = 1
   ENDIF ELSE BEGIN
      debug = 0
   ENDELSE
   excpt_cond = ''

   ;  Initialize julian_iso to an invalid value:
   julian_iso = -1.0D

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): date_iso, julian_iso.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter date_iso is not of type STRING:
      IF (is_string(date_iso) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter date_iso must be of type STRING.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Split the input argument into its components:
   parts1 = STRSPLIT(date_iso, 'T', COUNT = nparts1, /EXTRACT)
   IF (debug AND (nparts1 NE 2)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date_iso is incorrectly formatted: ' + $
         'it must contain 2 strings separated by T.'
      RETURN, error_code
   ENDIF

   parts2 = STRSPLIT(parts1[0], '-', COUNT = nparts2, /EXTRACT)
   IF (debug AND (nparts2 NE 3)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date_iso is incorrectly formatted: ' + $
         'the date must contain 3 strings separated by dashes.'
      RETURN, error_code
   ENDIF

   parts3 = STRSPLIT(parts1[1], ':', COUNT = nparts3, /EXTRACT)
   IF (debug AND (nparts3 NE 3)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 220
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date_iso is incorrectly formatted: ' + $
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
   IF (debug AND ((yy LT 1582) OR (yy GT 2100))) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date_iso is invalid: ' + $
         'the year must be within the range [1582, 2100].'
      RETURN, error_code
   ENDIF

   ;  Check that the month is within the allowed range:
   IF (debug AND ((mm LT 1) OR (mm GT 12))) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 310
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date_iso is invalid: ' + $
         'the month must be within the range [1, 12].'
      RETURN, error_code
   ENDIF

   ;  Check that the day is within the allowed range:
   IF (debug) THEN BEGIN
      rc = days_per_month(num_days, YEAR = yy, DEBUG = debug, $
         EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 320
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
      IF ((dd LT 1) OR (dd GT num_days[mm])) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 330
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter date_iso is invalid: ' + $
            'the day must be within the range [1, ' + strstr(num_days[mm] + $
            '].'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Check that the hour is within the allowed range:
   IF (debug AND ((hh LT 0) OR (hh GT 23))) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 340
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date_iso is invalid: ' + $
         'the hour must be within the range [0, 23].'
      RETURN, error_code
   ENDIF

   ;  Check that the minute is within the allowed range:
   IF (debug AND ((nn LT 0) OR (nn GT 59))) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 350
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date_iso is invalid: ' + $
         'the minute must be within the range [0, 59].'
      RETURN, error_code
   ENDIF

   ;  Check that the second is within the allowed range:
   IF (debug AND ((ss LT 0) OR (ss GT 59))) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 360
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter date_iso is invalid: ' + $
         'the second must be within the range [0, 59].'
      RETURN, error_code
   ENDIF

   ;  Compute the corresponding Julian day specification:
   julian_iso = JULDAY(mm, dd, yy, hh, nn, ss)

   RETURN, return_code

END
