FUNCTION get_disks_sizes, disks_sizes, DIR = dir, PRINTIT = printit, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function retrieves the name, total capacity, used
   ;  space and available space of each of the disks mounted on the
   ;  current computer and matching the optional pattern DIR, and passes
   ;  that information to the calling routine through the output
   ;  positional parameter disks_sizes. If the optional keyword parameter
   ;  PRINTIT is set, this information is also printed on the console.
   ;
   ;  ALGORITHM: This function spawns a Linux df command to the operating
   ;  system, extracts the desired information from the outcome, and uses
   ;  it to populate the 2-dimensional output array disks_sizes.
   ;
   ;  SYNTAX:
   ;  res = get_disks_sizes(disks_sizes, DIR = dir, PRINTIT = printit, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   disks_sizes {STRING array} [O]: A 2-dimensional array containing
   ;      size information for each disk mounted on the current computer.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   DIR = dir {STRING} [I] (Default: ”): The name pattern of the
   ;      disk(s) to be documented.
   ;
   ;  *   PRINTIT = printit {INT} [I] (Default: 0): Flag to activate (1)
   ;      or skip (0) the printing of the outcome on the console.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: STRING array.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function sets
   ;      the 2-dimensional STRING array disks_sizes[n_disks, n_items] as
   ;      follows:
   ;
   ;      -   N_ELEMENTS(disks_sizes[*, 0]) is the number of currently
   ;          mounted disks meeting the optional selection criterion dir,
   ;
   ;      -   disks_sizes[i, 0] contains the name of the mount point for
   ;          disk i,
   ;
   ;      -   disks_sizes[i, 1] contains the total capacity of the disk i,
   ;
   ;      -   disks_sizes[i, 2] contains the space already used on disk i,
   ;          and
   ;
   ;      -   disks_sizes[i, 3] contains the space remaining available on
   ;          disk i.
   ;
   ;      The output keyword parameter excpt_cond is set to a null string,
   ;      if the optional input keyword parameter DEBUG was set and if the
   ;      optional output keyword parameter EXCPT_COND was provided in the
   ;      call.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a null STRING array, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The optional keyword parameter dir must be of type
   ;      STRING.
   ;
   ;  *   Error 120: An exception condition occurred in the spawning of
   ;      the df command.
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
   ;  *   NOTE 1: This function relies on Linux’s df command, so it will
   ;      only work within the macOS or Linux environments.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> dir = 'MISR*'
   ;      IDL> rc = get_disks_sizes(disks_sizes, DIR = dir, $
   ;         /PRINT, /DEBUG, EXCPT_COND = excpt_cond)
   ;      There are 2 disks mounted on MicMac2:
   ;              /Volumes/MISR-HR       1.8Ti       1.8Ti       3.6Gi
   ;           /Volumes/MISR_Data3       3.6Ti       3.3Ti       379Gi
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–03–29: Version 0.9 — Initial release.
   ;
   ;  *   2017–04–02: Version 1.0 — Initial public release.
   ;
   ;  *   2017–04–04: Version 1.1 — Update the code and documentation to
   ;      provide the desired information through a positional parameter
   ;      rather than the return value (now used for error reporting).
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
   return_code = 0
   excpt_cond = ''

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

   ;  Initialize the output positional parameters to invalid values:
   par_1 = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 1
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): disks_sizes.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the optional
   ;  keyword parameter DIR is not of STRING type:
      IF (KEYWORD_SET(dir) AND (is_string(dir) NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Optional keyword parameter dir must be of type STRING.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Identify the current computer:
   SPAWN, 'hostname -s', computer
   computer = computer[0]

   ;  Set the Linux command line:
   IF (KEYWORD_SET(dir)) THEN BEGIN
      command = 'df -h /Volumes/' + dir
   ENDIF ELSE BEGIN
      command = 'df -h /Volumes/*'
   ENDELSE

   ;  Spawn the Linux command and retrieve the disk information:
   ;  Note 1: The variable 'disk_space' returned by this spawned command is a
   ;  1-dimensional STRING array containing a header line and 1 additional
   ;  line per mounted disk.
   ;  Note 2: In the absence of the optional keyword parameter 'dir', this
   ;  command will always return at least the characteristics of the primary
   ;  disk ('/') of the current computer.
   ;  Note 3: If the optional keyword parameter 'dir' is set but no physical
   ;  disk meeting that name specification is mounted, the spawned 'df' command
   ;  returns an error message in the variable 'err_result'.
   SPAWN, command, disk_space, err_result

   ;  Return to the calling routine if no mount point meets the search
   ;  criterion of the spawned 'df' command, or if another error occurred:
   disks_sizes = ['', '']
   IF (err_result NE '') THEN BEGIN
      IF (STRPOS(err_result, 'No such file or directory') GE 0) THEN BEGIN
         IF (KEYWORD_SET(printit)) THEN BEGIN
            IF (KEYWORD_SET(dir)) THEN BEGIN
               PRINT, 'There are no disks matching the pattern ' + $
                  dir + ' mounted on ' + computer + '.'
            ENDIF ELSE BEGIN
               PRINT, 'There are no disks matching the pattern ' + $
                  '/Volumes/ mounted on ' + computer + '.'
            ENDELSE
         ENDIF
         RETURN, return_code
      ENDIF ELSE BEGIN
         IF (KEYWORD_SET(printit)) THEN PRINT, $
            'The spawned df command returned the error message: ' + $
               err_result
         IF (debug) THEN BEGIN
            error_code = 120
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': The spawned df command returned the error message: ' + $
                  err_result
            RETURN, error_code
         ENDIF
         RETURN, return_code
      ENDELSE
   ENDIF

   ;  Set the character string to split the Linux command output to white
   ;  space (blank and tab):
   white = set_white()

   ;  Extract the desired information from the STRING array 'disk_space' and
   ;  store it in the 2-dimensional STRING array 'disks_sizes'.
   ;  Note 1: The array element 'disk_space[0]' contains a header line, which
   ;  is currently ignored.
   ;  Note 2: The number of extracted items is currently hardwired to 4, to
   ;  include the name of the mount point, the disk capacity, the space used,
   ;  and the space remaining available. Additional information is available
   ;  from the OS, such as the device name: if that information should be
   ;  retrieved too, modify the variable 'n_items' accordingly and copy the
   ;  relevant information from 'disk_space[i]' to 'disks_sizes[i - 1, n]':
   n_items = 4
   n_lines = N_ELEMENTS(disk_space)
   n_disks = n_lines - 1
   disks_sizes = STRARR(n_disks, n_items)
   FOR i = 1, n_disks DO BEGIN
      parts = STRSPLIT(disk_space[i], white, COUNT = n_parts, /EXTRACT)
      disks_sizes[i - 1, 0] = parts[n_parts - 1]
      disks_sizes[i - 1, 1] = parts[1]
      disks_sizes[i - 1, 2] = parts[2]
      disks_sizes[i - 1, 3] = parts[3]
   ENDFOR

   ;  If the optional keyword parameter 'PRINTIT' is set, output the
   ;  required information on the console:
   IF (KEYWORD_SET(printit)) THEN BEGIN
      CASE n_disks OF
         0: PRINT, 'There are no disks mounted on ' + computer + '.'
         1: PRINT, 'There is 1 disk mounted on ' + computer + ':'
         ELSE: PRINT, 'There are ' + strstr(n_disks) + $
            ' disks mounted on ' + computer + ':'
      ENDCASE
      FOR j = 0, n_disks  - 1 DO BEGIN
         PRINT, disks_sizes[j, *], FORMAT = '(A24, 3A12)'
      ENDFOR
      PRINT
   ENDIF

   RETURN, return_code

END
