FUNCTION first_char, $
   arg_str, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns the first character of the input
   ;  positional parameter arg_str.
   ;
   ;  ALGORITHM: This function relies on IDL built-in string functions to
   ;  extract the desired character.
   ;
   ;  SYNTAX: res = first_char(arg_str, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg_str {STRING} [I]: An arbitrary string expression.
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
   ;      returns the first character of the input positional parameter,
   ;      and the output keyword parameter excpt_cond is set to a null
   ;      string, if the optional input keyword parameter DEBUG is set and
   ;      if the optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a null string, and the output keyword parameter
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
   ;  *   Error 120: Positional parameter arg_str does not contain at
   ;      least one character.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> PRINT, first_char('Hello World')
   ;      H
   ;
   ;      IDL> PRINT, '>' + first_char(3.14, /DEBUG, $
   ;         EXCPT_COND = excpt_cond) + '<'
   ;      ><
   ;      IDL> PRINT, 'excpt_cond = ' + excpt_cond
   ;      excpt_cond = Error 110 in FIRST_CHAR: Input
   ;         positional parameter must be of type STRING.
   ;
   ;      [In the following example, variable xyz is undefined.]
   ;      IDL> PRINT, '>' + first_char(xyz, /DEBUG, $
   ;         EXCPT_COND = excpt_cond) + '<
   ;      ><
   ;      IDL> PRINT, 'excpt_cond = ' + excpt_cond
   ;      excpt_cond = Error 110 in FIRST_CHAR: Input
   ;         positional parameter must be of type STRING.
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
   ;
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
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

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): arg_str.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'arg_str' is not of type STRING:
      IF (is_string(arg_str) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter must be of type STRING.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'arg_str' does not contain at least 1 character:
      IF (strlen(arg_str) EQ 0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter must contain at least 1 ' + $
            'character.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Extract the first character of arg_str:
   res = STRMID(arg_str, 0, 1)

   RETURN, res

END
