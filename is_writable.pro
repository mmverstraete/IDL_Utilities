FUNCTION is_writable, file_spec, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function indicates whether the input positional
   ;  parameter file_spec exists or not, and if it exists, whether it
   ;  points to a directory or file that is writable or not.
   ;
   ;  ALGORITHM: This function relies on IDL internal functions to
   ;  determine the status of the directory or file provided as input
   ;  argument file_spec, and returns the following codes:
   ;
   ;  *   1: The directory or file exists and is writable.
   ;
   ;  *   0: The directory or file exists and is not writable.
   ;
   ;  *   -1: An exception condition occurred during execution of this
   ;      function.
   ;
   ;  *   -2: The directory or file does not exist.
   ;
   ;  SYNTAX: rc = is_writeable(file_spec, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   file_spec {STRING} [I]: The file specification (path and/or file
   ;      name) to be checked for writing.
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
   ;      returns 1 if the file or directory provided as the input
   ;      positional parameter file_spec exists and is writable, 0 if it
   ;      exists but is not writable, and -2 if the argument does not
   ;      exist. The output keyword parameter excpt_cond is set to a null
   ;      string, if the optional input keyword parameter DEBUG is set and
   ;      if the optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns -1 and the output keyword parameter excpt_cond contains
   ;      a message about the exception condition encountered, if the
   ;      optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
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
   ;  *   NOTE 1: If the argument file_spec does not contain a path
   ;      component (absolute or relative), the file is assumed to be
   ;      located in the current working directory.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = is_writable('~/Desktop', /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      1,   ><
   ;
   ;      IDL> rc = is_writable('~/Codes/Test_dir/unwritable.txt',
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      0,   ><
   ;
   ;      IDL> rc = is_writable(3, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      -1,   >Error 110 in IS_WRITABLE: Argument file_spec is
   ;         not of type string.<
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
   ;      exception condition if the argument exists but is unwritable.
   ;
   ;  *   2018–05–13: Version 1.3 — Add return code to indicate the input
   ;      argument does not exist, and update the documentation.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
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

   ;  Get the name of this routine:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE

   ;  Initialize the default return code and the exception condition message:
   return_code = 0
   excpt_cond = ''

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

   IF (debug) THEN BEGIN

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

   ;  Return to the calling routine with an error message if argument
   ;  'file_spec' is not of type string:
      IF (is_string(file_spec) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument file_spec is not of type STRING.'
         RETURN, -1
      ENDIF
   ENDIF

   ;  Remove any spurious white space at the front or back of argument
   ;  'file_spec':
   file_spec = strstr(file_spec)

   ;  Return to the calling routine with a return code indicating whether
   ;  the input argument exists and is writable or not, or does not exist:
   res = FILE_INFO(file_spec)
   IF (res.EXISTS EQ 1) THEN BEGIN
      IF (res.WRITE EQ 1) THEN BEGIN
         RETURN, 1
      ENDIF ELSE BEGIN
         RETURN, 0
      ENDELSE
   ENDIF ELSE BEGIN
      RETURN, -2
   ENDELSE

END
