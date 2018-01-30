FUNCTION get_dirs_sizes, dir_patt, n_dirs, dirs_names, dirs_sizes, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function searches for directory names matching the
   ;  pattern dir_patt, and, if any are found, reports their sizes on
   ;  disk.
   ;
   ;  ALGORITHM: This function checks the validity of the input arguments
   ;  and spawns a Bash shell script using the Linux command du to report
   ;  on the size of directories matching dir_patt.
   ;
   ;  SYNTAX: rc = get_dirs_sizes(dir_patt, dirs_names, dirs_sizes, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   dir_patt {STRING} [I]: A pattern of directory names.
   ;
   ;  *   dirs_names {STRING array} [O]: A string array containing the
   ;      names of the matching directories.
   ;
   ;  *   dirs_sizes {STRING array} [O]: A string array containing the
   ;      sizes of the matching directories.
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
   ;      returns 0, and the output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG was
   ;      set and if the optional output keyword parameter EXCPT_COND was
   ;      provided in the call. The output arguments dirs_names and
   ;      dirs_sizes contain the desired information.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter dir_patt is not of type STRING.
   ;
   ;  *   Error 120: Positional parameter dir_patt cannot be a null
   ;      STRING.
   ;
   ;  *   Error 300: No directories matching the positional parameter
   ;      dir_patt have been found.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_string.pro
   ;
   ;  *   set_white.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function may not work in a MS Windows environment,
   ;      which lacks the du command.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = get_dirs_sizes('/Volumes/MISR-HR/P16*', $
   ;         dirs_names, dirs_sizes, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, dirs_names
   ;      /Volumes/MISR-HR/P167/ /Volumes/MISR-HR/P168/
   ;      /Volumes/MISR-HR/P169/
   ;      IDL> PRINT, dirs_sizes
   ;      81G 553G 337G
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–06: Version 0.9 — Initial release.
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
   return_code = 0
   IF KEYWORD_SET(debug) THEN BEGIN
      debug = 1
   ENDIF ELSE BEGIN
      debug = 0
   ENDELSE
   excpt_cond = ''

   ;  Initialize the output positional parameters to invalid values:
   dirs_names = []
   dirs_sizes = []

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): dir_patt, n_dirs, dirs_names, dirs_sizes.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'dir_patt' is not of type STRING:
      IF (is_string(dir_patt) NE 1) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument dir_patt is not of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the argument
   ;  'dir_patt' is a null STRING:
      IF (dir_patt EQ '') THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Argument dir_patt cannot be a null STRING.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Locate the directories matching the given pattern:
   dirs_names = FILE_SEARCH(dir_patt, COUNT = n_dirs, /TEST_DIRECTORY, $
      /MARK_DIRECTORY)

   IF ((debug) AND (n_dirs EQ 0)) THEN BEGIN
      info = SCOPE_TRACEBACK(/STRUCTURE)
      rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
      error_code = 300
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': No directories match ' + dir_patt + '.'
      RETURN, error_code
   ENDIF

   dirs_sizes = STRARR(n_dirs)
   FOR i = 0, n_dirs - 1 DO BEGIN
      bash_cmd_1 = 'du -c -d 0 -h ' + dirs_names[i]
      SPAWN, bash_cmd_1, sd, /STDERR
      white = set_white()
      parts = STRSPLIT(sd[N_ELEMENTS(sd) - 1], white, $
         COUNT = n_parts, /EXTRACT)
      dirs_sizes[i] = parts[0]
   ENDFOR

   RETURN, return_code

END
