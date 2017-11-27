FUNCTION strcat, str_array, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function takes the STRING array argument str_array as
   ;  input and returns the STRING scalar obtained by concatenating all
   ;  array elements in their original order, with a single blank space
   ;  between successive elements.
   ;
   ;  ALGORITHM: This function concatenates all elements of str_array into
   ;  a single STRING which is returned to the calling routine.
   ;
   ;  SYNTAX: res = strcat(str_array, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   str_array {STRING} [I]: A string array.
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
   ;  *   Error 110: Positional parameter str_array is not of type STRING.
   ;
   ;  *   Error 120: Positional parameter str_array is not an array.
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
   ;  *   NOTE 1: The input argument str_array can be multi-dimensional.
   ;      In the case of a 2D array, the elements are concatenated line by
   ;      line.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> a = ['Hello', 'World']
   ;      IDL> res = strcat(a)
   ;      IDL> PRINT, '>' + res + '<'
   ;      >Hello World<
   ;
   ;      IDL> str_array = [['This', 'is', 'a'], ['2D', 'string', 'array']]
   ;      IDL> res = strcat(str_array, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;      This is a 2D string array
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–18: Version 0.9 — Initial release.
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
   n_reqs = 1
   IF (N_PARAMS() NE n_reqs) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 100
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Routine must be called with ' + strstr(n_reqs) + $
         ' positional parameter(s): str_array.'
      RETURN, return_code
   ENDIF

   ;  Check that the argument 'str_array' is of type STRING:
   IF (is_string(str_array) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 110
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument str_array is not of type STRING.'
      RETURN, return_code
   ENDIF

   ;  Check that the argument 'str_array' is an array:
   IF (is_array(str_array) NE 1) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 120
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument str_array is not an array.'
      RETURN, return_code
   ENDIF

   ;  Compute the number of elements in 'str_array':
   n_str = N_ELEMENTS(str_array)

   ;  Assemble the result by concatenating all elements of 'str_array',
   ;  separated by a blank space:
   FOR i = 0, n_str - 1 DO BEGIN
      return_code = return_code + str_array[i] + ' '
   ENDFOR

  RETURN, return_code

END
