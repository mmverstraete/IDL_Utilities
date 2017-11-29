FUNCTION last_char, arg_str, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns the last character of the input
   ;  argument arg_str.
   ;
   ;  ALGORITHM: This function relies on IDL built-in string functions to
   ;  extract the desired character.
   ;
   ;  SYNTAX: res = last_char(arg_str)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg_str {STRING} [I]: An arbitrary string expression.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: STRING.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns the desired character, and the output keyword parameter
   ;      excpt_cond is set to a null string.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a null string, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter arg_str is not of type STRING.
   ;
   ;  *   Error 200: Positional parameter arg_str does not contain at
   ;      least one character.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This may be useful, for instance, to check whether a
   ;      directory name is terminated by the proper path segment
   ;      separator character for the current operating system.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> path = '/Volumes/MISR_Data'
   ;      IDL> PRINT, last_char(path)
   ;      a
   ;
   ;      IDL> conc = 'Hello' + ' World'
   ;      IDL> PRINT, last_char(conc)
   ;      d
   ;
   ;      IDL> pi = 3.14
   ;      IDL> res = last_char(pi, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'res = >' + res + '< and excpt_cond = ' + excpt_cond
   ;      res = >< and excpt_cond = Error 110 in LAST_CHAR: Argument must be
   ;      of type STRING.
   ;
   ;      IDL> PRINT, last_char(xyz)
   ;      % STRLEN: Variable is undefined: ARG_STR.
   ;      % Execution halted at: LAST_CHAR...
   ;      %                      $MAIN$
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
   ret_code = ''
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
         ' positional parameter(s): arg_str.'
      RETURN, ret_code
   ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'arg_str' is not of type STRING:
   IF (is_string(arg_str) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + 'Argument must be of type STRING.'
      RETURN, ret_code
   ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'arg_str' does not contain at least 1 character:
   IF (STRLEN(arg_str) EQ 0) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 200
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': ' + 'Argument must contain at least 1 character.'
      RETURN, ret_code
   ENDIF

   ;  Extract the last character of arg_str:
   lc = STRMID(arg_str, STRLEN(arg_str) - 1, 1)

   RETURN, lc

END
