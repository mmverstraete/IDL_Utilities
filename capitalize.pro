FUNCTION capitalize, arg_str, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns a copy of the input positional
   ;  parameter with the first character in upper case. The input argument
   ;  itself is unmodified.
   ;
   ;  ALGORITHM: This function checks the validity of the input positional
   ;  parameter arg_str and ensures that its first character is upper
   ;  case.
   ;
   ;  SYNTAX: rc = capitalize(arg_str, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg_str {STRING} [I]: The string that needs to be capitalized.
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
   ;      returns a copy of the input argument arg_str with the first
   ;      character capitalized, and the output keyword parameter
   ;      excpt_cond is set to a null string.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a null STRING, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter arg_str is not of type STRING.
   ;
   ;  *   Error 120: Positional parameter arg_str does not contain at
   ;      least 1 character.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function only modifies the case of the first
   ;      character of a copy of the input string; the rest of the string
   ;      is copied verbatim. Hence, if multiple words need to be
   ;      capitalized, the function needs to be called separately for each
   ;      word.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> arg_str = 'south africa'
   ;      IDL> res = capitalize(arg_str, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'res = ', res, ' and excpt_cond = >' + excpt_cond + '<'
   ;      res = South africa and excpt_cond = ><
   ;      IDL> PRINT, 'arg_str = ', arg_str
   ;      arg_str = south africa
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–11–20: Version 1.0 — Initial release.
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
   return_code = ''
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
      RETURN, return_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'arg_str' is not of type STRING:
   IF (is_string(arg_str) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter must be of type STRING.'
      RETURN, return_code
   ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'arg_str' does not contain at least 1 arg_stracter:
   IF (STRLEN(arg_str) LT 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter must contain at least 1 character.'
      RETURN, return_code
   ENDIF

   ;  Split the input argument in two parts: the first character and the
   ;  rest of the string:
   tmp1 = STRMID(arg_str, 0, 1)
   tmp2 = STRMID(arg_str, 1)

   ;  Ensure the first character is upper case and reassemble the original
   ;  string:
   tmp1 = STRUPCASE(tmp1)
   RETURN, tmp1 + tmp2

END
