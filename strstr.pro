FUNCTION strstr, arg, DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function converts the value of the alphanumeric
   ;  positional parameter arg into a string without any white space in
   ;  the front or at the back.
   ;
   ;  ALGORITHM: This routine converts the input positional parameter arg
   ;  to a STRING and strips any white space in the front or back.
   ;
   ;  SYNTAX: res = strstr(arg, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg {alphanumeric} [I]: The alphanumeric input argument.
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
   ;      returns the string representation of argument arg to the calling
   ;      routine, and the keyword parameter excpt_cond is set to a null
   ;      string, if the optional input keyword parameter DEBUG is set and
   ;      if the optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a null string and the keyword parameter excpt_cond
   ;      contains a message about the exception condition encountered, if
   ;      the optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter arg is not of type alphanumeric.
   ;
   ;  *   Error 1000: Unexpected condition, check the type of argument
   ;      arg.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_alphanum.pro
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Argument arg can be an array, in which case each array
   ;      element is converted into a string without any blank space in
   ;      the front or at the back.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> pi = 3.14159
   ;      IDL> PRINT, pi
   ;            3.14159
   ;      IDL> res = strstr(pi)
   ;      IDL> PRINT, res
   ;      3.14159
   ;
   ;      IDL> a = '   Hello   '
   ;      IDL> PRINT, a
   ;         Hello
   ;      IDL> res = strstr(a)
   ;      IDL> PRINT, res
   ;      Hello
   ;
   ;      IDL> a = CREATE_STRUCT('A', 1, 'B', 'xxx')
   ;      IDL> res = strstr(a, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, '>' + res + '<'
   ;      ><
   ;      IDL> PRINT, excpt_cond
   ;      Error 110 in routine STRSTR: Argument arg is not an alphanumeric
   ;      expression.
   ;
   ;      IDL> b = ['   Hello   ', '   World   ']
   ;      IDL> res = strstr(b)
   ;      IDL> PRINT, '>' + res[0] + '<' + ' ' + '>' + res[1] + '<'
   ;      >Hello< >World<
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–05: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
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
         excpt_cond = 'Error 100 in routine ' + rout_name + $
            ': Routine must be called with ' + $
            STRTRIM(STRING(n_reqs), 2) + ' positional parameter(s): arg.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if arg is not an
   ;  alphanumeric expression:
      IF (is_alphanum(arg) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         excpt_cond = 'Error 110 in routine ' + rout_name + $
            ': Argument arg is not an alphanumeric expression.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  If arg is a string, return it without any extraneous white space:
   IF (is_string(arg) EQ 1) THEN RETURN, STRTRIM(arg, 2)

   ;  If arg is of numeric type, return its string representation:
   IF (is_numeric(arg) EQ 1) THEN RETURN, STRTRIM(STRING(arg), 2)

   ;  Otherwise return to the calling routine with an error message:
   info = SCOPE_TRACEBACK(/STRUCTURE)
   rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
   excpt_cond = 'Error 1000 in ' + rout_name + $
      ': Unexpected condition, check the type of argument arg ' + $
      'as function strstr only accepts alphanumeric arguments.'
   RETURN, return_code

END
