FUNCTION uniq2, $
   in_array_1, $
   in_array_2, $
   out_array_1, $
   out_array_2, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function sorts and sifts two one-dimensional arrays of
   ;  identical type and dimensions, retaining only the couples of unique
   ;  values while maintaining the correspondance between elements of the
   ;  same rank in each input array.
   ;
   ;  ALGORITHM: This function combines the two input positional parameter
   ;  arrays into a single STRING array, sorts and sifts it to eliminate
   ;  duplicates, and then splits it back into arrays of the original type
   ;  but containing only unique pairs of corresponding values.
   ;
   ;  SYNTAX:
   ;  rc = uniq2(in_array_1, in_array_2, out_array_1, out_array_2, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   in_array_1 [I]: An arbitrary array.
   ;
   ;  *   in_array_2 [I]: An arbitrary array of the same type and size as
   ;      in_array_1.
   ;
   ;  *   out_array_1 [O]: An array of the same type and size as
   ;      in_array_1 containing the elements of in_array_1 which are
   ;      uniquely associated with elements of in_array_2.
   ;
   ;  *   out_array_2 [O]: An array of the same type and size as
   ;      in_array_1 containing the elements of in_array_2 which are
   ;      uniquely associated with elements of in_array_1.
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
   ;  RETURNED VALUE TYPE: INT.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The positional parameters out_array_1 and
   ;      out_array_2 contain the unique combinations of values of the
   ;      input positional parameters.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters may be undefined,
   ;      inexistent, incomplete or useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Both input positional parameters in_array_1 and
   ;      in_array_2 must be arrays.
   ;
   ;  *   Error 120: The input positional parameters in_array_1 and
   ;      in_array_2 must be of the same size.
   ;
   ;  *   Error 130: The input positional parameters in_array_1 and
   ;      in_array_2 must be of the same type.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_array.pro
   ;
   ;  *   strstr.pro
   ;
   ;  *   type_of.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The positional parameters in_array_1 and in_array_2 can
   ;      be of any alphanumeric type, but must be defined.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> in_array_1 = [1.1, 1.1, 2.2, 2.2, 3.3, 3.3, $
   ;         4.4, 4.4, 4.4, 2.2, 5.5]
   ;      IDL> in_array_2 = [0.0, 0.0, 1.1, 2.2, 3.3, 3.3, $
   ;         3.3, 4.4, 3.3, 2.2, 6.1]
   ;      IDL> rc = uniq2(in_array_1, in_array_2, out_array_1, out_array_2, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + $
   ;         excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;      IDL> PRINT, out_array_1
   ;      1.10000  2.20000  2.20000  3.30000  4.40000  4.40000  5.50000
   ;      IDL> PRINT, out_array_2
   ;      0.00000  1.10000  2.20000  3.30000  3.30000  4.40000  6.10000
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–04–29: Version 0.9 — Initial release.
   ;
   ;  *   2018–05–14: Version 1.0 — Initial public release.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–02–28: Version 2.01 — Documentation update.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the assignment
   ;      of numeric return codes), and switch to 3-parts version
   ;      identifiers.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2020 Michel M. Verstraete.
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
   ;      be included in their entirety in all copies or substantial
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
   return_code = 0

   ;  Set the default values of flags and essential keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): in_array_1, in_array_2, ' + $
            'out_array_1, out_array_2.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if either (or both)
   ;  input positional parameter(s) are not arrays:
      res_1 = is_array(in_array_1)
      res_2 = is_array(in_array_2)
      IF ((res_1 NE 1) OR (res_2 NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameters in_array_1 and in_array_2 ' + $
            'must both be arrays.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with input positional parameter arrays of different sizes:
      nel_1 = N_ELEMENTS(in_array_1)
      nel_2 = N_ELEMENTS(in_array_2)
      IF (nel_1 NE nel_2) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameters in_array_1 and in_array_2 ' + $
            'must be arrays of the same sizes.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with input positional parameter arrays of different types:
      rc1 = type_of(in_array_1, type_code_1, type_name_1)
      rc2 = type_of(in_array_2, type_code_2, type_name_2)
      IF (type_code_1 NE type_code_2) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameters in_array_1 and in_array_2 ' + $
            'must be arrays of the same types.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Set the item separator:
   sep = '\~*~\'

   ;  Assemble a 1-d string array containing the elements of the two inputs
   ;  input positional parameters, separated by this separator:
   temp_str = strstr(in_array_1[*]) + sep + strstr(in_array_2[*])

   ;  Create a new array containing unique elements:
   temp = temp_str[UNIQ(temp_str, SORT(temp_str))]
   nel_out = N_ELEMENTS(temp)

   ;  Initialize the output positional parameters:
   out_array_1 = MAKE_ARRAY(nel_out, TYPE = type_code_1)
   out_array_2 = MAKE_ARRAY(nel_out, TYPE = type_code_1)

   ;  Split this array of unique values back into 2 arrays of corresponding
   ;  values:
   FOR i = 0, nel_out - 1 DO BEGIN
      parts = STRSPLIT(temp[i], sep, /EXTRACT)
      out_array_1[i] = parts[0]
      out_array_2[i] = parts[1]
   ENDFOR

   RETURN, return_code

END
