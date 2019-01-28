FUNCTION is_dir, $
   dir_spec, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function reports whether the input positional
   ;  parameter dir_spec is a directory or not.
   ;
   ;  ALGORITHM: This function relies on the IDL built-in function
   ;  FILEINFO().
   ;
   ;  SYNTAX: res = is_dir(dir_spec, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   dir_spec {STRING} [I]: An arbitrary directory specification.
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
   ;      returns 1 if the input positional parameter dir_spec is a
   ;      directory, and 0 otherwise, and the output keyword parameter
   ;      excpt_cond is set to a null string, if the optional input
   ;      keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided in the call.
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
   ;  *   Error 110: Positional parameter dir_spec is not of type STRING.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The input positional parameter dir_spec can include wild
   ;      characters (IDL-allowed regular expressions): see the third
   ;      example below, but it cannot be an explicit array of
   ;      directories.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> dir_spec = '~/Desktop'
   ;      IDL> PRINT, is_dir(dir_spec)
   ;             1
   ;
   ;      IDL> dir_spec = '~/Documents/MySoftware/Test_dir/Test_file.txt'
   ;      IDL> PRINT, is_dir(dir_spec, /DEBUG, EXCPT_COND = excpt_cond)
   ;             0
   ;
   ;      IDL> dir_spec = '/Volumes/MISR_Data*/P*/'
   ;      IDL> PRINT, is_dir(dir_spec, DEBUG = 1, EXCPT_COND = excpt_cond)
   ;             1
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
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

   ;  Initialize the default return code:
   return_code = -1

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): dir_spec.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'dir_spec' is not of type STRING:
      IF (is_string(dir_spec) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter must be of type STRING.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Assess whether the input positional parameter 'dir_spec' is a
   ; directory or not:
   res = FILE_INFO(dir_spec)
   IF (res.DIRECTORY EQ 1) THEN RETURN, 1 ELSE RETURN, 0

END
