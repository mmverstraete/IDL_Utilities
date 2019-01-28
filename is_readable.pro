FUNCTION is_readable, $
   file_spec, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;input positional parameter
   ;
   ;  PURPOSE: This function reports whether the input positional
   ;  parameter file_spec exists or not, and if it exists, whether it
   ;  points to a directory or file that is readable or not.
   ;
   ;  ALGORITHM: This function relies on IDL internal functions to
   ;  determine the status of the directory or file provided as input
   ;  positional parameter file_spec.
   ;
   ;  SYNTAX: rc = is_readable(file_spec, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   file_spec {STRING} [I]: The file specification (path and/or file
   ;      name) to be checked for reading.
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
   ;  OUTCOME: This function returns
   ;
   ;  *   1 if the file or directory provided as the input positional
   ;      parameter file_spec exists and is readable; the output keyword
   ;      parameter excpt_cond is set to a null string.
   ;
   ;  *   0 if this file or directory exists but is unreadable; the output
   ;      keyword parameter excpt_cond contains a message to this effect.
   ;
   ;  *   -1 if an exception condition has been detected; the output
   ;      keyword parameter excpt_cond contains a message about the
   ;      exception condition encountered.
   ;
   ;  *   -2 if this file or directory does not exist; the output keyword
   ;      parameter excpt_cond contains a message to this effect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter file_spec is not of type STRING.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Since the purpose of this function is to check the
   ;      existence and readability of the input positional parameter
   ;      file_spec, all tests are performed irrespective of the setting
   ;      of the input keyword parameter DEBUG. The keywords DEBUG and
   ;      EXCPT_COND are included for consistency, and to allow reporting
   ;      of the exception condition if one is encountered.
   ;
   ;  *   NOTE 2: If the input positional parameter file_spec does not
   ;      contain a path component (absolute or relative), the file is
   ;      assumed to be located in the current working directory.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = is_readable('~/Desktop', $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      1,   ><
   ;
   ;      IDL> rc = is_readable('~/Codes/Test_dir/unreadable.txt', $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      0,   >The file ~/Codes/Test_dir/unreadable.txt exists
   ;         but is unreadable.<
   ;
   ;      IDL> rc = is_readable(234, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      -1,   >Error 110 in IS_READABLE: Input positional
   ;         parameter file_spec is not of type string.<
   ;
   ;      IDL> rc = is_readable('~/Desktop/missing_file.txt', $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      -2,   ><
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
   ;  *   2018–04–24: Version 1.2 — Update the function to return 0 but no
   ;      exception condition if the input positional parameter exists but
   ;      is unreadable.
   ;
   ;  *   2018–05–14: Version 1.3 — Add return code to indicate the input
   ;      positional parameter does not exist, and update the
   ;      documentation.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–06–22: Version 1.6 — Improve diagnostic messages.
   ;
   ;  *   2018–08–15: Version 1.7 — Return non-empty excpt_cond values
   ;      only when errors are encountered (i.e., only when rc = -1, and
   ;      not as warning or information messages).
   ;
   ;  *   2018–08–28: Version 1.8 — Return empty excpt_cond value only
   ;      when file_spec exists and is readable.
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

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
   n_reqs = 1
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): file_spec.'
      RETURN, -1
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'file_spec' is not of type string:
   IF (is_string(file_spec) NE 1) THEN BEGIN
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter file_spec is not of type STRING.'
      RETURN, -1
   ENDIF

   ;  Remove any spurious white space at the front or back of the input
   ;  positional parameter 'file_spec':
   file_spec = strstr(file_spec)

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'file_spec' is not accessible for reading:
   res = FILE_INFO(file_spec)
   IF (res.EXISTS EQ 1) THEN BEGIN
      IF (res.READ EQ 1) THEN BEGIN
         RETURN, 1
      ENDIF ELSE BEGIN
         excpt_cond = 'The file ' + file_spec + ' exists but is unreadable.'
         RETURN, 0
      ENDELSE
   ENDIF ELSE BEGIN
      excpt_cond = 'The file ' + file_spec + ' does not exist.'
      RETURN, -2
   ENDELSE

END
