FUNCTION strcat, $
   str_array, $
   separator, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns a scalar STRING variable that
   ;  combines all elements of the input positional parameter str_array.
   ;
   ;  ALGORITHM: This function concatenates the elements of the input
   ;  positional parameter str_array, in their original order, into a
   ;  single scalar STRING variable, using the input positional parameter
   ;  sep_char character as separator between successive elements.
   ;
   ;  SYNTAX: res = strcat(str_array, separator, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   str_array {STRING} [I]: An arbitrary string array.
   ;
   ;  *   separator {STRING} [I] (Default value: None): Character string
   ;      used to separate the array elements in the output string.
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
   ;  *   Error 110: Input positional parameter str_array is not of type
   ;      STRING.
   ;
   ;  *   Error 120: Input positional parameter sep_char is not of type
   ;      STRING.
   ;
   ;  *   Error 130: Input positional parameter sep_char is not a scalar.
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
   ;  *   NOTE 1: The input positional parameter str_array can be
   ;      multi-dimensional. In the case of a 2D array, the elements are
   ;      concatenated line by line.
   ;
   ;  *   NOTE 2: If the input positional parameter str_array is empty or
   ;      a scalar STRING, this function returns that argument unmodified.
   ;
   ;  *   NOTE 3: The input positional parameter sep_char can be a null
   ;      string or contain multiple characters.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> a = ['multi', 'spectral']
   ;      IDL> res = strcat(a, '')
   ;      IDL> PRINT, '>' + res + '<'
   ;      >multispectral<
   ;
   ;      IDL> str_array = [['This', 'is', 'a'], ['2D', 'string', 'array']]
   ;      IDL> res = strcat(str_array, ' ', /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;      This is a 2D string array
   ;
   ;      IDL> str_array = ['P168', 'O068050', 'B110']
   ;      IDL> separator = '_'
   ;      IDL> res = strcat(str_array, separator, $
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
   ;
   ;  *   2018–12–04: Version 1.6 — Convert the input keyword parameter
   ;      sep_char into the input positional parameter separator to allow
   ;      concatenation with empty separators.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the assignment
   ;      of numeric return codes), and switch to 3-parts version
   ;      identifiers.
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
   return_string = ''

   ;  Set the default values of flags and essential keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): str_array, separator.'
         RETURN, return_string
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'str_array' is not of type STRING:
      IF (is_string(str_array) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter str_array is not of type STRING.'
         RETURN, return_string
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'separator' is not of type STRING:
      IF (is_string(separator) NE 1) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter separator is not of type STRING.'
         RETURN, return_string
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'separator' is not a scalar:
      IF (is_scalar(separator) NE 1) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter separator is not a scalar.'
         RETURN, return_string
      ENDIF
   ENDIF

   ;  Compute the number of elements in 'str_array':
   n_str = N_ELEMENTS(str_array)

   ; If the array contains 0 or 1 element, return that element unchanged:
   IF (n_str LT 2) THEN BEGIN
      return_string = str_array
   ENDIF ELSE BEGIN

   ;  Otherwise, assemble the result by concatenating all elements of
   ;  'str_array', separated by the specified separator string:
      return_string = ''
      FOR i = 0, n_str - 2 DO BEGIN
         return_string = return_string + str_array[i] + separator
      ENDFOR
      return_string = return_string + str_array[n_str - 1]
   ENDELSE

  RETURN, return_string

END
