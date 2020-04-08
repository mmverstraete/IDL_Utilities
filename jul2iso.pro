FUNCTION jul2iso, $
   juldate, $
   isodate, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function converts a Julian date, specified as a
   ;  floating point number in DOUBLE precision, into an ISO 8601/W3C
   ;  date, specified as a STRING.
   ;
   ;  ALGORITHM: This function relies on the IDL program CALDAT to extract
   ;  the date elements from the input Julian date, and reformats those
   ;  into the ISO 8601/W3C date specification (yyyy-mm-ddThh:mm:ssZ).
   ;
   ;  SYNTAX: rc = jul2iso(juldate, isodate, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   juldate {DOUBLE} [I]: The input Julian day number.
   ;
   ;  *   isodate {STRING} [O]: The output date, formatted as per the ISO
   ;      8601/W3C specifications.
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
   ;      provided in the call. The output positional parameter isodate
   ;      contains the date corresponding to the input Julian day number.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameter isodate may be
   ;      undefined, inexistent, incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter juldate is not of type
   ;      DOUBLE.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_double.pro
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
   ;  EXAMPLES:
   ;
   ;      IDL> juldate = 2458444.0D
   ;      IDL> rc = jul2iso(juldate, isodate, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'isodate = ' + isodate
   ;      isodate = 2018-11-21T12:00:00Z
   ;
   ;      IDL> juldate = 2458443.9D
   ;      IDL> rc = jul2iso(juldate, isodate, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'isodate = ' + isodate
   ;      isodate = 2018-11-21T09:36:00Z
   ;
   ;  REFERENCES:
   ;
   ;  *   https://www.w3.org/TR/NOTE-datetime, accessed on 21
   ;      November 2018.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–11–20: Version 0.9 — Initial release.
   ;
   ;  *   2018–11–30: Version 1.0 — Initial public release.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–02–24: Version 2.01 — Documentation update.
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

   ;  Initialize the output positional parameter(s):
   isodate = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): juldate, isodate.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'juldate' is not a DOUBLE floating point number:
      rc = is_double(juldate)
      IF (rc EQ 0) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter juldate is not a DOUBLE ' + $
            'floating point number.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Get the date information from the input Julian day:
   CALDAT, juldate, month, day, year, hour, minute, second

   ;  Reformat this date according to the ISO 8601/W3C specification
   ;  (yyyy-mm-ddThh:mm:ssZ):
   isodate = strstr(year) + '-' + $
      STRING(month, FORMAT = '(I02)') + '-' + $
      STRING(day, FORMAT = '(I02)')  + 'T' + $
      STRING(hour, FORMAT = '(I02)') + ':' + $
      STRING(minute, FORMAT = '(I02)') + ':' + $
      STRING(second, FORMAT = '(I02)') + 'Z'

   RETURN, return_code

END
