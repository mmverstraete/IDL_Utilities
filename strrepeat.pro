FUNCTION strrepeat, str, n_rep, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns a STRING containing n_rep times the
   ;  input argument str.
   ;
   ;  ALGORITHM: This function generates and returns an output string
   ;  containing n_rep times the input argument str.
   ;
   ;  SYNTAX: res = strrepeat(str, n_rep, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   str {STRING} [I]: A string expression.
   ;
   ;  *   n_rep {INTEGER} [I]: The total number of times the input string
   ;      str needs to be replicated in the output string.
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
   ;      returns a string scalar and the output keyword parameter
   ;      excpt_cond is set to a null string.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a null string and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter str is not of type STRING.
   ;
   ;  *   Error 120: Positional parameter n_rep is not of type INTEGER.
   ;
   ;  *   Error 130: Positional parameter n_rep is less than 1.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_integer.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = strrepeat('--123--', 4, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;      --123----123----123----123--
   ;
   ;      IDL> title = 'This is a title'
   ;      IDL> PRINT, title, STRING(10B), strrepeat('-', STRLEN(title), $
   ;         EXCPT_COND = excpt_cond)
   ;      This is a title
   ;      ---------------
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–08–01: Version 0.9 — Initial release.
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
   return_code = ''
   excpt_cond = ''

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
   n_reqs = 2
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): str, n_rep.'
      RETURN, return_code
   ENDIF

   ;  Check that the argument 'str' is of type STRING:
   IF (is_string(str) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument str is not of type STRING.'
      RETURN, return_code
   ENDIF

   ;  Check that the argument 'n_rep' is of one of the INTEGER types:
   IF (is_integer(n_rep) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument n_rep is not of type INTEGER.'
      RETURN, return_code
   ENDIF

   ;  Check that the argument 'n_rep' is strictly positive:
   IF (n_rep LE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 130
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument n_rep must be larger than 0.'
      RETURN, return_code
   ENDIF

   ;  Generate the output string:
   o_str = ''
   FOR i = 0, n_rep - 1 DO BEGIN
      o_str = o_str + str
   ENDFOR

   RETURN, o_str

END
