FUNCTION strrepeat, $
   str, $
   n_rep, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function generates and returns an output string
   ;  containing n_rep times the input positional parameter str.
   ;
   ;  ALGORITHM: This function replicates the input positional parameter
   ;  str n_rep times and returns the result to the calling routine.
   ;
   ;  SYNTAX: res = strrepeat(str, n_rep, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   str {STRING} [I]: A string expression.
   ;
   ;  *   n_rep {INT} [I]: The total number of times the input string str
   ;      needs to be replicated in the output string.
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
   ;      returns a string scalar, and the output keyword parameter
   ;      excpt_cond is set to a null string, if the optional input
   ;      keyword parameter DEBUG was set and if the optional output
   ;      keyword parameter EXCPT_COND was provided in the call.
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
   ;  *   Error 110: Positional parameter str is not of type STRING.
   ;
   ;  *   Error 120: Positional parameter n_rep is not of type INTEGER.
   ;
   ;  *   Error 130: Positional parameter n_rep is negative.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_integer.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: If the input positional parameter n_rep is 0, this
   ;      function returns a null string, irrespective of the content of
   ;      the input positional parameter str.
   ;
   ;  *   NOTE 2: If the input positional parameter n_rep is 1, this
   ;      function returns the value of str.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = strrepeat('--123--', 4, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;      --123----123----123----123--
   ;
   ;      IDL> title = 'This is a title'
   ;      IDL> PRINT, title, STRING(10B), strrepeat('-', STRLEN(title), $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
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
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2018–12–04: Version 1.6 — Update the function documentation.
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
   return_code = ''

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
            ' positional parameter(s): str, n_rep.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'str' is not of type STRING:
      IF (is_string(str) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter str is not of type STRING.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'n_rep' is not of one of the INTEGER types:
      IF (is_integer(n_rep) NE 1) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter n_rep is not of type INTEGER.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'n_rep' is negative:
      IF (n_rep LT 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter n_rep must not be negative.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Generate the output string:
   CASE 1 OF
      (n_rep GT 1): BEGIN
         o_str = ''
         FOR i = 0, n_rep - 1 DO BEGIN
            o_str = o_str + str
         ENDFOR
         RETURN, o_str
      END
      (n_rep EQ 1): BEGIN
         o_str = str
         RETURN, o_str
      END
      (n_rep EQ 0): BEGIN
         o_str = ''
         RETURN, o_str
      END
      ELSE: BEGIN
         o_str = ''
         RETURN, o_str
      END
   ENDCASE

END
