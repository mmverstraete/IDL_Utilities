FUNCTION count_code_lines, $
   file_spec, $
   comm_char, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns the approximate number of code lines
   ;  (as a LONG integer) contained in the text file specified by the
   ;  input positional parameter file_spec, i.e., the number of lines that
   ;  are neither blank (empty) nor beginning with a string expression
   ;  contained in comm_char denoting the start of a comment.
   ;
   ;  ALGORITHM: This function inspects each and every line of file_spec
   ;  and counts those that are neither empty nor starting with one of the
   ;  string(s) provided in comm_char. Blank space (space, TAB) at the
   ;  start of the line is ignored for this purpose. The STRING variable
   ;  comm_char can be either a constant or an array, in which case all
   ;  elements of that array are used in succession to check all possible
   ;  options. Each element of comm_char can include multiple characters
   ;  (e.g., to deal with C or PL-1 language conventions such as /*
   ;  comment */).
   ;
   ;  SYNTAX: res = count_code_lines(file_spec, comm_char, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   file_spec {STRING} [I]: The file specification (optional path
   ;      and name) of the text file to inspect.
   ;
   ;  *   comm_char {STRING or STRING array} [I]: One (scalar) or more (if
   ;      array) string expression(s) containing the usual characters to
   ;      indicate comments in computer languages.
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
   ;  RETURNED VALUE TYPE: LONG.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns the approximate number of code lines in file_spec, and
   ;      the output keyword parameter excpt_cond is set to a null string,
   ;      if the optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns -1L, and the output keyword parameter excpt_cond
   ;      contains a message about the exception condition encountered, if
   ;      the optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter file_spec is not of type STRING.
   ;
   ;  *   Error 120: Positional parameter file_spec is not a scalar.
   ;
   ;  *   Error 130: Positional parameter file_spec is not found, not a
   ;      regular file or not readable.
   ;
   ;  *   Error 140: Positional parameter comm_char is not of type STRING.
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
   ;  *   NOTE 1: The IDL built-in command FILE_LINES counts and returns
   ;      the total number of lines in a text file. By contrast, the
   ;      function count_code_lines reports on the number of active or
   ;      effective code lines, i.e., without counting comments and empty
   ;      lines.
   ;
   ;  *   NOTE 2: The STRING variable comm_char can be either a scalar or
   ;      an array, in which case all elements of that array are used in
   ;      succession to check all possible options. Each element of
   ;      comm_char can include multiple characters (e.g., to deal with C
   ;      or PL-1 language conventions such as /* comment */). And if
   ;      comm_char is set to a scalar null string, this function returns
   ;      the total number of lines in the file, as reported by
   ;      FILE_LINES.
   ;
   ;  *   NOTE 3: This routine may not yield the correct number of code
   ;      lines if comments span multiple lines, each terminated by a <CR>
   ;      and/or <LF>, without repeating the commenting character sequence
   ;      on each line. However, a comment written on a single long line,
   ;      which may appear on multiple lines on screen due to soft
   ;      wrapping, would be treated correctly.
   ;
   ;  *   NOTE 4: This function is also usable in other contexts that use
   ;      a character string at the start of a line to indicate comments,
   ;      such as in LaTeX, for instance.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> file_spec = './Codes/IDL/Utilities/is_leap/is_leap.pro'
   ;      IDL> PRINT, FILE_LINES(file_spec)
   ;                         206
   ;      IDL> PRINT, count_code_lines(file_spec, ';', $
   ;         DEBUG = 1, EXCPT_COND = excpt_cond)
   ;                48
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
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–05–17: Version 2.01 — Code simplification (FILE_TEST).
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

   ;  Initialize the default error return code:
   error_return_code = -1L

   ;  Set the default values of flags and essential output keyword parameters:
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
            ' positional parameter(s): file_spec, comm_char.'
         RETURN, error_return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'file_spec' is not of type STRING:
      IF (is_string(file_spec) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter file_spec is not of type STRING.'
         RETURN, error_return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'file_spec' is not a scalar:
      IF (is_scalar(file_spec) NE 1) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter file_spec is not a scalar.'
         RETURN, error_return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'file_spec' is not found or unreadable:
      res = FILE_TEST(file_spec, /WRITE, /REGULAR)
      IF (res EQ 0) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + $
            rout_name + ': The output file ' + file_spec + $
            ' is not found, not a regular file or not readable.'
         RETURN, error_return_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'comm_char' is not of type STRING:
      res = is_string(comm_char)
      IF (res NE 1) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter comm_char is not of type STRING.'
         RETURN, error_return_code
      ENDIF
   ENDIF

   ;  If the input positional parameter comm_char is a scalar empty string,
   ;  return the actual number of lines in the file, as reported by IDL's
   ;  FILE_LINES function.
   ;  WARNING: The following test must be performed as two independent IF
   ;  statements because the second IF would cause an error when comm_char is
   ;  an array.
   IF (is_scalar(comm_char) EQ 1) THEN BEGIN
      IF (comm_char EQ '') THEN  RETURN, FILE_LINES(file_spec)
   ENDIF

   ;  Check whether input positional parameter comm_char is an array, and if
   ;  so assess the number of elements:
   res = is_array(comm_char)
   IF (res EQ 1) THEN BEGIN
      n_comm_char = N_ELEMENTS(comm_char)
   ENDIF ELSE BEGIN
      n_comm_char = 0
   ENDELSE

   ;  Open the file file_spec and read all lines successively:
   OPENR, unit, file_spec, /GET_LUN
   line = ''
   n_lines = 0L
   WHILE ~EOF(unit) DO BEGIN
      READF, unit, line

   ;  Remove any extraneous white space at the start and end of the line:
      line = STRTRIM(line, 2)

   ;  Consider only non-empty lines:
      IF (STRLEN(line) GT 0) THEN BEGIN

   ;  Consider only lines that are not starting as a comment:
   ;  If comm_char is a scalar expression:
         IF (n_comm_char EQ 0) THEN BEGIN
            comm_char_len = STRLEN(comm_char)
            IF (STRMID(line, 0, comm_char_len) NE comm_char) THEN $
               n_lines = n_lines + 1
         ENDIF ELSE BEGIN

   ;  If comm_char is an array of expressions, check all options:
            test = 0
            FOR i = 0, n_comm_char - 1 DO BEGIN
               comm_char_len = STRLEN(comm_char[i])
               IF (STRMID(line, 0, comm_char_len) EQ comm_char[i]) THEN BEGIN
                  test = test + 1
               ENDIF
            ENDFOR
            IF (test EQ 0) THEN n_lines = n_lines + 1
         ENDELSE
      ENDIF
   ENDWHILE

   CLOSE, unit
   FREE_LUN, unit

   RETURN, n_lines

END
