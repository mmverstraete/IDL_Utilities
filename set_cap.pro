FUNCTION set_cap, $
   arg, $
   ALLCHARS = allchars, $
   ALLWORDS = allwords, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function capitalizes the first word, and optionally
   ;  each word or all characters, of the input positional parameter arg.
   ;
   ;  ALGORITHM: This function scans the input positional parameter arg to
   ;  identify the first valid letter and capitalizes it. This operation
   ;  can also be optionally performed on each word (continuous sequence
   ;  of letters) or on all characters.
   ;
   ;  SYNTAX: rc = set_cap, arg, $
   ;  ALLCHARS = allchars, ALLWORDS = allwords, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   arg {STRING} [I]: The string that needs to be capitalized.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   ALLCHARS = allchars {INT} [I] (Default value: 0): Flag to
   ;      activate (1) or skip (0) capitalizing all characters of the
   ;      input positional parameter arg.
   ;
   ;  *   ALLWORDS = allwords {INT} [I] (Default value: 0): Flag to
   ;      activate (1) or skip (0) capitalizing all words of the input
   ;      positional parameter arg.
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
   ;      returns a version of the input positional parameter arg,
   ;      capitalized as follows:
   ;
   ;      -   If neither of the optional keyword parameters ALLCHARS and
   ;          ALLWORDS are set (default), the first letter of the first
   ;          word of arg is set in upper case.
   ;
   ;      -   If the optional keyword parameter ALLCHARS is set, all
   ;          letters of arg are set in upper case.
   ;
   ;      -   If the optional keyword parameter ALLWORDS is set, each word
   ;          of arg is set in upper case.
   ;
   ;      -   If both optional keyword parameters ALLCHARS and ALLWORDS
   ;          are set, the former takes precedence and all letters of arg
   ;          are set in upper case.
   ;
   ;      -   The input positional parameter arg is left unmodified.
   ;
   ;      In all of these cases, the output keyword parameter excpt_cond
   ;      is set to a null string, if the optional input keyword parameter
   ;      DEBUG is set and if the optional output keyword parameter
   ;      EXCPT_COND is provided in the call.
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
   ;  *   Error 110: Input positional parameter arg is not of type STRING.
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
   ;  *   NOTE 1: The input positional parameter arg may be a STRING
   ;      array, in which case all elements of that array are processed as
   ;      indicated above.
   ;
   ;  *   NOTE 2: Characters other than letters are ignored and copied
   ;      over verbatim to the returned value.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> PRINT, set_cap('south africa')
   ;      South africa
   ;
   ;      IDL> PRINT, set_cap('hello', /ALLCHARS)
   ;      HELLO
   ;
   ;      IDL> PRINT, set_cap(' 12  hello', /ALLCHARS)
   ;       12  HELLO
   ;
   ;      IDL> PRINT, set_cap(['south africa', 'united states'], /ALLWORDS)
   ;      South Africa United States
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–12–02: Version 0.9 — Initial release.
   ;
   ;  *   2018–12–12: Version 1.0 — Initial public release.
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

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(allchars)) THEN allchars = 1 ELSE allchars = 0
   IF (KEYWORD_SET(allwords)) THEN allwords = 1 ELSE allwords = 0
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
            ' positional parameter(s): arg.'
         RETURN, ''
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'arg' is invalid:
      rc = is_string(arg)
      IF (rc NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter must be of type STRING.'
         RETURN, ''
      ENDIF
   ENDIF

   ;  Set all characters of the input positional parameter 'arg' to upper case
   ;  if required:
   IF (allchars) THEN BEGIN
      arg_out = arg.ToUpper()
      RETURN, arg_out
   ENDIF

   ;  Set the first character of each word of the input positional parameter
   ;  'arg' to upper case if required:
   IF (allwords) THEN BEGIN
      arg_out = arg.CapWords()
      RETURN, arg_out
   ENDIF

   ;  Set the first letter of the first word the input positional parameter
   ;  'arg' to upper case (default outcome):
   IF (is_array(arg)) THEN BEGIN
      arg_out = STRARR(N_ELEMENTS(arg))
      FOR i = 0, N_ELEMENTS(arg) - 1 DO BEGIN
         FOR j = 0, STRLEN(arg[i]) - 1 DO BEGIN
            c = STRMID(arg[i], j, 1)
            IF (is_letter(c)) THEN BEGIN
               arg_out[i] = STRMID(arg[i], 0, j) + $
                  c.ToUpper() + $
                  STRMID(arg[i], j + 1)
               BREAK
            ENDIF
         ENDFOR
      ENDFOR
   ENDIF ELSE BEGIN
      FOR j = 0, STRLEN(arg) - 1 DO BEGIN
         c = STRMID(arg, j, 1)
         IF (is_letter(c)) THEN BEGIN
            arg_out = STRMID(arg, 0, j) + $
               c.ToUpper() + $
               STRMID(arg, j + 1)
            BREAK
         ENDIF
      ENDFOR
   ENDELSE

   RETURN, arg_out

END
