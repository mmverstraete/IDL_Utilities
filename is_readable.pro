FUNCTION is_readable, file_spec, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns 1 if the argument file_spec points to
   ;  a readable file or directory in the file system, and 0 otherwise.
   ;
   ;  ALGORITHM: This function verifies that the input argument file_spec
   ;  is of type STRING and points to a file or directory that is
   ;  accessible for reading.
   ;
   ;  SYNTAX: rc = is_readable(file_spec, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   file_spec {STRING} [I]: The file specification (path and/or file
   ;      name) to be checked for reading.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
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
   ;      returns 1 if the argument file_spec points to a readable file or
   ;      directory, or 0 if it is not readable, and the output keyword
   ;      parameter excpt_cond is set to a null string.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns -1, and the output keyword parameter excpt_cond contains
   ;      a message about the exception condition encountered.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter file_spec is not of type STRING.
   ;
   ;  *   Error 120: Positional parameter file_spec is not accessible or
   ;      readable.
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
   ;      IDL> rc = is_readable('~/Desktop', EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      1,   ><
   ;
   ;      IDL> rc = is_readable(EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      -1,   >Error 100 in IS_READABLE: Routine must be called
   ;      with 1 positional parameters: filespec.<
   ;
   ;      IDL> rc = is_readable(123, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',   >' + excpt_cond + '<'
   ;      -1,   >Error 110 in IS_READABLE: Argument filespec
   ;      is not of type string.<
   ;
   ;      IDL> rc = is_readable('~/Desktop/junkfile', $
   ;         EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, ',  >' + excpt_cond + '<'
   ;      -1,  >Error 120 in IS_READABLE: Argument filespec is not found.<
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
   return_code = 0
   excpt_cond = ''

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
   n_reqs = 1
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): file_spec.'
      RETURN, -1
   ENDIF

   ;  Return to the calling routine with an error message if argument
   ;  'file_spec' is not of type string:
   IF (is_string(file_spec) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument file_spec is not of type string.'
      RETURN, -1
   ENDIF

   ;  Remove any spurious white space at the front or back of argument
   ;  'file_spec':
   file_spec = strstr(file_spec)

   ;  Return to the calling routine with an error message if argument
   ;  'file_spec' is not accessible for reading:
   res = FILE_INFO(file_spec)
   IF (res.EXISTS EQ 1) THEN BEGIN
      IF (res.READ EQ 1) THEN RETURN, 1 ELSE RETURN, 0
   ENDIF ELSE BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument file_spec is not found.'
      RETURN, -1
   ENDELSE

END
