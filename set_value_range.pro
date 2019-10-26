FUNCTION set_value_range, $
   min_val, $
   max_val, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns an ‘optimal’ value range to be used
   ;  in plotting routines, based on the actual minimum and maximum values
   ;  of the variable to be displayed. It can substitute the default range
   ;  used by IDL in the PLOT function, if the latter is not satisfactory.
   ;
   ;  ALGORITHM: This function selects the minimum and maximum values of a
   ;  range that contains the values provided as input, decreased and
   ;  increased by about 1/10th of the range between those values, and
   ;  appropriately rounded.
   ;
   ;  SYNTAX: res = set_value_range(min_val, max_val, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   min_val {FLOAT} [I]: The actual minimum valid value in a
   ;      dataset, i.e., not considering special codes for missing values.
   ;
   ;  *   max_val {FLOAT} [I]: The actual maximum valid value in a
   ;      dataset, i.e., not considering special codes for missing values.
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
   ;  RETURNED VALUE TYPE: FLOAT array.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns the optimal range to plot values within
   ;      [min_val, max_val], and the output keyword parameter excpt_cond
   ;      is set to a null string, if the optional input keyword parameter
   ;      DEBUG is set and if the optional output keyword parameter
   ;      EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns the dummy range res = [-99.9, -99.9], and the output
   ;      keyword parameter excpt_cond contains a message about the
   ;      exception condition encountered, if the optional input keyword
   ;      parameter DEBUG is set and if the optional output keyword
   ;      parameter EXCPT_COND is provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter min_val or max_val is not of
   ;      numeric type.
   ;
   ;  *   Error 120: The actual range max_val - min_val is null.
   ;
   ;  *   Error 130: An exception condition occurred in routine oom.pro.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   oom.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS: None.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = set_value_range(0.12, 0.62, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;            0.00000     0.700000
   ;      IDL> PRINT, 'excpt_cond = >' + excpt_cond + '<'
   ;      excpt_cond = ><
   ;
   ;      IDL> res = set_value_range(-2.5, 12.7)
   ;      IDL> PRINT, res
   ;           -10.0000      20.0000
   ;
   ;      IDL> res = set_value_range(15.0, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;           -99.9000     -99.9000
   ;      IDL> PRINT, 'excpt_cond = ' + excpt_cond
   ;      excpt_cond = Error 100 in set_value_range: Routine must be
   ;         called with 2 positional parameters: min_val, max_val.
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
   return_code = [-99.9, -99.9]

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
            ' positional parameter(s): min_val, max_val.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if either of the
   ;  input positional parameters min_val or max_val is not numeric:
      IF ((is_numeric(min_val) NE 1) OR (is_numeric(max_val) NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Either min_val or max_val is not of numeric type.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the actual range
   ;  max_val - min_val is nul:
      IF (max_val - min_val EQ 0.0) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The actual range max_val - min_val is nul.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Set the logarithm base to use:
   base = 10.0

   ;  Set the increment to expand the new range by 1/10 of the actual range
   ;  on either side of the actual range:
   actual_range = max_val - min_val
   oom_act_rng = oom(actual_range, DEBUG = debug, EXCPT_COND = excpt_cond)
   IF (debug AND (excpt_cond NE '')) THEN BEGIN
      error_code = 130
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         excpt_cond
      RETURN, return_code
   ENDIF
   delta = actual_range / 10.0

   ;  Set the new minimum:
   new_min_val = min_val - delta

   ;  Round-off the new range minimum:
   IF ((min_val * new_min_val) LT 0.0) THEN BEGIN
      min_range = 0.0
   ENDIF ELSE BEGIN
      min_range = (FLOOR(new_min_val / (base^oom_act_rng))) * $
         (base^oom_act_rng)
   ENDELSE

   ;  Set the new maximum:
   new_max_val = max_val + delta

   ;  Round-off the new range maximum:
   IF ((max_val * new_max_val) LT 0.0) THEN BEGIN
      max_range = 0.0
   ENDIF ELSE BEGIN
      max_range = (CEIL(new_max_val / (base^oom_act_rng))) * $
         (base^oom_act_rng)
   ENDELSE

   RETURN, [min_range, max_range]

END
