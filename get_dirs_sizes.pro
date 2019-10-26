FUNCTION get_dirs_sizes, $
   dir_patt, $
   n_dirs, $
   dirs_names, $
   dirs_sizes, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function reports the size of folders matching the
   ;  input positional parameter dir_patt, if they exist.
   ;
   ;  ALGORITHM: This function searches for folder names matching the
   ;  pattern dir_patt, and, if any are found, spawns a Bash shell script
   ;  using the Linux command du to report on their sizes.
   ;
   ;  SYNTAX:
   ;  rc = get_dirs_sizes(dir_patt, n_dirs, dirs_names, dirs_sizes, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   dir_patt {STRING} [I]: A pattern of folder names.
   ;
   ;  *   n_dirs {INT} [O]: The number of matching folders.
   ;
   ;  *   dirs_names {STRING array} [O]: The names of the matching
   ;      folders.
   ;
   ;  *   dirs_sizes {STRING array} [O]: A string array containing the
   ;      sizes of the matching folders.
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
   ;      provided in the call. The output positional parameters n_dirs,
   ;      dirs_names and dirs_sizes contain the desired information.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters n_dirs, dirs_names
   ;      and dirs_sizes may be inexistent, incomplete or incorrect.
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
   ;  *   NOTE 2: The output positional parameter dirs_sizes is of type
   ;      STRING despite its name and purpose suggesting a number, because
   ;      it also contains a size unit such as ‘M’ for Megabytes, or ‘G’
   ;      for Gigabytes.
   ;
   ;  *   NOTE 3: If no folders are found, the output positional parameter
   ;      n_dirs is set to 0 while dirs_names and dirs_sizes are both set
   ;      to empty STRING arrays.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> rc = get_dirs_sizes('/Volumes/MISR-HR/P16*', n_dirs, $
   ;         dirs_names, dirs_sizes, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ', excpt_cond = >' + $
   ;         excpt_cond + '<'
   ;      rc = 0, excpt_cond = ><
   ;      IDL> PRINT, 'n_dirs = ' + strstr(n_dirs)
   ;      n_dirs = 3
   ;      IDL> PRINT, dirs_names
   ;      /Volumes/MISR-HR/P167/
   ;      /Volumes/MISR-HR/P168/
   ;      /Volumes/MISR-HR/P169/
   ;      IDL> PRINT, dirs_sizes
   ;      81G 557G 337G
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
   ;  *   2018–06–01: Version 1.5 — Implement new coding standards.
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
   return_code = 0

   ;  Set the default values of flags and essential keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Initialize the output positional parameters:
   n_dirs = 0
   dirs_names = ['']
   dirs_sizes = ['']

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): dir_patt, n_dirs, dirs_names, dirs_sizes.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'dir_patt' is not of type STRING:
      IF (is_string(dir_patt) NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter dir_patt is not of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'dir_patt' is a null STRING:
      IF (dir_patt EQ '') THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter dir_patt cannot be a null STRING.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Locate the directories matching the given pattern:
   dirs_names = FILE_SEARCH(dir_patt, COUNT = n_dirs, /TEST_DIRECTORY, $
      /MARK_DIRECTORY)

   ;  If at least 1 such folder is found, record their sizes:
   IF (n_dirs GT 0) THEN BEGIN
      dirs_sizes = STRARR(n_dirs)
      FOR i = 0, n_dirs - 1 DO BEGIN
         bash_cmd_1 = 'du -c -d 0 -h ' + dirs_names[i]
         SPAWN, bash_cmd_1, sd, /STDERR
         white = set_white()
         parts = STRSPLIT(sd[N_ELEMENTS(sd) - 1], white, $
            COUNT = n_parts, /EXTRACT)
         dirs_sizes[i] = parts[0]
      ENDFOR
   ENDIF

   RETURN, return_code

END
