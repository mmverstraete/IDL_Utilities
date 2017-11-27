FUNCTION is_dir, dir_spec, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns 1 if argument dir_spec is a
   ;  directory, and 0 otherwise.
   ;
   ;  ALGORITHM: This function relies on the IDL built-in function
   ;  FILEINFO().
   ;
   ;  SYNTAX: res = is_dir(dir_spec, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   dir_spec {STRING} [I]: An arbitrary file specification.
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
   ;      returns 1 if the argument dir_spec is a directory, or 0 if it is
   ;      not, and the output keyword parameter excpt_cond is set to a
   ;      null string.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns -1, and the output keyword parameter excpt_cond contains
   ;      a message about the exception condition encountered.
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
   ;  *   NOTE 1: The argument dir_spec can include wild characters
   ;      (IDL-allowed regular expressions); see the third example below.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> dir_spec = '/Users/mmverstraete/Desktop'
   ;      IDL> PRINT, is_dir(dir_spec)
   ;             1
   ;
   ;      IDL> dir_spec = '/Users/mmverstraete/Pictures/Scan_1.jpeg'
   ;      IDL> PRINT, is_dir(dir_spec)
   ;             0
   ;
   ;      IDL> dir_spec = '/Volumes/MISR_Data*/P*/'
   ;      IDL> PRINT, is_dir(dir_spec)
   ;             1
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
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
   ;  Initialize the default return code and error message of the function:
   ret_code = -1
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
         ' positional parameter(s): dir_spec.'
      RETURN, ret_code
   ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'dir_spec' is not of type STRING:
   IF (is_string(dir_spec) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + 'Argument must be of type STRING.'
      RETURN, ret_code
   ENDIF

   ;  Assess whether the argument 'dir_spec' is a directory or not:
   res = FILE_INFO(dir_spec)
   IF (res.DIRECTORY EQ 1) THEN RETURN, 1 ELSE RETURN, 0

END
