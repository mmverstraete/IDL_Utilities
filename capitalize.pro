FUNCTION capitalize, arg_str, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns a copy of the input (scalar or array)
   ;  positional parameter with the first character in upper case. The
   ;  input argument itself is unmodified.
   ;
   ;  ALGORITHM: This function ensures that the first character of the
   ;  input (scalar or array) positional parameter arg_str is upper case.
   ;  If this argument is a string array, each element will be
   ;  capitalized, and if the argument is a null string or if the first
   ;  character cannot be capitalized, it is returned unmodified.
   ;
   ;  SYNTAX:
   ;  rc = capitalize(arg_str, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg_str {STRING} [I]: The (scalar or array) string that needs to
   ;      be capitalized.
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
   ;      returns a copy of the input (scalar or array) argument arg_str
   ;      with the first character capitalized, and the output keyword
   ;      parameter excpt_cond is set to a null string, if the optional
   ;      input keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a null STRING, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter arg_str is not of type STRING.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function only modifies the case of the first
   ;      character of a copy of the input (scalar or array) argument; the
   ;      rest of the argument is copied verbatim. Hence, if multiple
   ;      words need to be capitalized in a single string, the function
   ;      needs to be called separately for each word.
   ;
   ;  *   NOTE 2: If the optional keyword parameter DEBUG is set, the
   ;      function will generate an error message if the input argument
   ;      arg_str is not of type STRING. However, if that option is not
   ;      set, the function will return the string representation of the
   ;      numeric input: see the last example below.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> arg_str = 'south africa'
   ;      IDL> res = capitalize(arg_str, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'res = ', res, ' and excpt_cond = >' + excpt_cond + '<'
   ;      res = South africa and excpt_cond = ><
   ;      IDL> PRINT, 'arg_str = ', arg_str
   ;      arg_str = south africa
   ;
   ;      IDL> arg_str = ['united states', 'san francisco']
   ;      IDL> res = capitalize(arg_str)
   ;      IDL> PRINT, 'res = >' + res + '<'
   ;      res = >United states< res = >San francisco<
   ;
   ;      IDL> arg_str = 456
   ;      IDL> res = capitalize(arg_str)
   ;      IDL> PRINT, 'res = >' + res + '<'
   ;      res = >     456<
   ;      IDL> rc = type_of(res, type_code, type_name)
   ;      IDL> PRINT, type_code, '   ', type_name
   ;                 7   STRING
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
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
   ;  Initialize the default return code and the exception condition message:
   return_code = ''
   IF KEYWORD_SET(debug) THEN BEGIN
      debug = 1
   ENDIF ELSE BEGIN
      debug = 0
   ENDELSE
   excpt_cond = ''

   IF (debug) THEN BEGIN

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
   ENDIF

   ;  Capitalize the argument:
   IF (is_array(arg_str)) THEN BEGIN
      res = STRARR(N_ELEMENTS(arg_str))
      FOR i = 0, N_ELEMENTS(arg_str) - 1 DO BEGIN
         res[i] = STRUPCASE(STRMID(arg_str[i], 0, 1)) + STRMID(arg_str[i], 1)
      ENDFOR
   ENDIF ELSE BEGIN
      res = STRUPCASE(STRMID(arg_str, 0, 1)) + STRMID(arg_str, 1)
   ENDELSE

   RETURN, res

END
