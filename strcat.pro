FUNCTION strcat, str_array, SEP_CHAR = sep_char, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function takes the STRING array argument str_array as
   ;  input and returns the STRING scalar obtained by concatenating all
   ;  array elements in their original order, using the optional sep_char
   ;  character as separator between successive elements.
   ;
   ;  ALGORITHM: This function concatenates all elements of str_array,
   ;  separated by the optional character sep_char or a single blank
   ;  space, into a single STRING which is returned to the calling
   ;  routine.
   ;
   ;  SYNTAX: res = strcat(str_array, SEP_CHAR = sep_char, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   str_array {STRING} [I]: A string array.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   SEP_CHAR = sep_char {STRING} [I] (Default value: ’ ’): Character
   ;      string used to separate the array elements in the output string.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
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
   ;      excpt_cond is set to a null string, if the optional input
   ;      keyword parameter DEBUG is set and if the optional output
   ;      keyword parameter EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a null string and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter str_array is not of type STRING.
   ;
   ;  *   Error 120: Positional parameter str_array is not an array.
   ;
   ;  *   Error 130: Keyword parameter sep_char is not of type STRING.
   ;
   ;  *   Error 140: Keyword parameter sep_char is not a scalar.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_array.pro
   ;
   ;  *   is_scalar.pro
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
   ;      IDL> res = strcat(str_array, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;      This is a 2D string array
   ;
   ;      IDL> str_array = ['P168', 'O068050', 'B110']
   ;      IDL> sep_char = '_'
   ;      IDL> res = strcat(str_array, SEP_CHAR = sep_char, $
   ;         DEBUG = 1, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'res = >' + res + '<'
   ;      res = >P168_O068050_B110<
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–18: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
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
   return_string = ''
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
            ' positional parameter(s): str_array.'
         RETURN, return_string
      ENDIF

   ;  Return to the calling routine with an error message if argument
   ;  'str_array' is not of type STRING:
      IF (is_string(str_array) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument str_array is not of type STRING.'
         RETURN, return_string
      ENDIF

   ;  Return to the calling routine with an error message if argument
   ;  'str_array' is not an array:
      IF (is_array(str_array) NE 1) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Argument str_array is not an array.'
         RETURN, return_string
      ENDIF
   ENDIF

   IF KEYWORD_SET(sep_char) THEN BEGIN

      IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if the optional
   ;  keyword argument 'sep_char' is not of type STRING:
         IF (is_string(sep_char) NE 1) THEN BEGIN
            error_code = 130
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Keyword parameter sep_char is not of type STRING.'
            RETURN, return_string
         ENDIF

   ;  Return to the calling routine with an error message if the optional
   ;  keyword argument 'sep_char' is not a scalar:
         IF (is_scalar(sep_char) NE 1) THEN BEGIN
            error_code = 140
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Keyword parameter sep_char is not a scalar.'
            RETURN, return_string
         ENDIF
      ENDIF
   ENDIF ELSE BEGIN

   ;  Set the default value of sep_char:
      sep_char = ' '
   ENDELSE

   ;  Compute the number of elements in 'str_array':
   n_str = N_ELEMENTS(str_array)

   ; If the array contains 0 or 1 element, return that element unchanged:
   IF (n_str LT 2) THEN BEGIN
      return_string = str_array
   ENDIF ELSE BEGIN

   ;  Otherwise, assemble the result by concatenating all elements of
   ;  'str_array', separated by the specified or default separation character:
      return_string = ''
      FOR i = 0, n_str - 2 DO BEGIN
         return_string = return_string + str_array[i] + sep_char
      ENDFOR
      return_string = return_string + str_array[n_str - 1]
   ENDELSE

  RETURN, return_string

END
