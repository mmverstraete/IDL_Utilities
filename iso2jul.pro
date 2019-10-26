FUNCTION iso2jul, $
   isodate, $
   juldate, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function converts an ISO 8601/W3C date, specified as a
   ;  STRING, into a Julian date provided as a DOUBLE floating point
   ;  number.
   ;
   ;  ALGORITHM: This function extracts the elements of the ISO 8601/W3C
   ;  date specification (yyyy-mm-ddThh:mm:ssZ) and relies on the IDL
   ;  function JULDAY to generate the corresponding Julian day number.
   ;
   ;  SYNTAX: rc = iso2jul(isodate, juldate, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   isodate {STRING} [O]: The input date formatted as
   ;      yyyy-mm-ddThh:mm:ssZ.
   ;
   ;  *   juldate {DOUBLE} [I]: The output Julian day number.
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
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The output positional parameter juldate
   ;      contains the Julian day number corresponding to the input
   ;      positional parameter isodate.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter juldate may be
   ;      undefined, inexistent, incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter isodate is not of type
   ;      STRING.
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
   ;  DEPENDENCIES:
   ;
   ;  *   chk_isodate.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Julian days start at noon local time, so the first 12
   ;      hours of a particular civilian day belong to the second half of
   ;      one Julian day, and the last 12 hours belong to the first half
   ;      of the next Julian day. See the examples below.
   ;
   ;  *   NOTE 2: By default, the IDL function JULDAY returns a LONG
   ;      integer if the date is specified only using the month, day and
   ;      year numbers, and as a DOUBLE floating point if the date
   ;      specification includes the hour, minute or second.
   ;
   ;  *   NOTE 3: By default, IDL prints large DOUBLE floating point
   ;      numbers such as Julian days for contemporary dates with a single
   ;      decimal digit and rounds the actual numbers in the process. As a
   ;      result, the Julian day number may appear to be the same before
   ;      and after noon: to witness the change, use a format statement to
   ;      force the output of at least two or more decimals. See the
   ;      examples below.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> isodate = '1953-06-13T11:00:00Z'
   ;      IDL> rc = iso2jul(isodate, juldate, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'juldate = ', juldate
   ;      juldate =        2434542.0
   ;      IDL> PRINT, 'juldate = ', juldate, FORMAT = '(A, D12.4)'
   ;      juldate = 2434541.9583
   ;
   ;      IDL> isodate = '1953-06-13T13:00:00Z'
   ;      IDL> rc = iso2jul(isodate, juldate, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'juldate = ', juldate
   ;      juldate =        2434542.0
   ;      IDL> PRINT, 'juldate = ', juldate, FORMAT = '(A, D12.4)'
   ;      juldate = 2434542.0417
   ;
   ;  REFERENCES:
   ;
   ;  *   https://www.w3.org/TR/NOTE-datetime, accessed on 21
   ;      November 2018.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–11–22: Version 0.9 — Initial release.
   ;
   ;  *   2018–11–30: Version 1.0 — Initial public release.
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
   juldate = 0.0D

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): isodate, juldate.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'isodate' is invalid:
      rc = chk_isodate(isodate, DEBUG = debug, EXCPT_COND = excpt_cond)
      IF (rc NE 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': ' + excpt_cond
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Split the input positional parameter 'isodate' into its date and time
   ;  components:
   parts1 = STRSPLIT(isodate, 'T', COUNT = nparts1, /EXTRACT)
   IF (debug AND (nparts1 NE 2)) THEN BEGIN
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is incorrectly formatted: ' + $
         'it must contain 2 strings separated by T.'
      RETURN, error_code
   ENDIF

   ;  Split the date component into its main elements:
   parts2 = STRSPLIT(parts1[0], '-', COUNT = nparts2, /EXTRACT)
   IF (debug AND (nparts2 NE 3)) THEN BEGIN
      error_code = 210
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter isodate is incorrectly formatted: ' + $
         'the date must contain 3 strings separated by dashes.'
      RETURN, error_code
   ENDIF

   ;  Split the time component into its main elements:
   parts3 = STRSPLIT(parts1[1], ':', COUNT = nparts3, /EXTRACT)
   IF (debug AND (nparts3 NE 3)) THEN BEGIN
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

   ;  Compute the corresponding Julian day specification:
   juldate = JULDAY(mm, dd, yy, hh, nn, ss)

   RETURN, return_code

END
