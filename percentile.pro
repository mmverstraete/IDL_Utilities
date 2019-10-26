FUNCTION percentile, $
   per, $
   array, $
   amin, $
   amax, $
   thresh, $
   AMISS = amiss, $
   IGNORE_BELOW = ignore_below, $
   IGNORE_ABOVE = ignore_above, $
   COUNT = count, $
   DOUBLE = double, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function estimates the sample value thresh of the
   ;  specified percentile per in the input array and returns some basic
   ;  statistical information on that array, which may contain missing
   ;  values and does not need to be sorted prior to the call.
   ;
   ;  ALGORITHM: This function determines the sample value corresponding
   ;  to the desired percentile per by either selecting a particular item
   ;  of array, if it corresponds exactly, or interpolating between two
   ;  array sample values otherwise. If missing values may be present in
   ;  array (i.e., input keyword parameter AMISS is set), then
   ;
   ;  *   the range of valid values must be specified by setting the input
   ;      keyword parameters ignore_below and ignore_above (missing values
   ;      are deemed to lie outside of that range), and
   ;
   ;  *   the output keyword parameters amin and amax report the minimum
   ;      and maximum valid values within that range, as opposed to within
   ;      the original array.
   ;
   ;  SYNTAX: rc = percentile(per, array, amin, amax, thresh, $
   ;  AMISS = amiss, IGNORE_BELOW = ignore_below, $
   ;  IGNORE_ABOVE = ignore_above, COUNT = count, $
   ;  DOUBLE = double, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   per {FLOAT} [I]: The desired percentile, a decimal number within
   ;      the range [0.0, 1.0].
   ;
   ;  *   array {FLOAT array} [I]: The statistical sample from which the
   ;      percentile needs to be estimated.
   ;
   ;  *   amin {FLOAT} [O]: The minimum value of array. If the optional
   ;      input keyword parameters AMISS is set, this minimum value is for
   ;      the valid values contained within the allowed range
   ;      [ignore_below, ignore_above].
   ;
   ;  *   amax {FLOAT} [O]: The maximum value of array. If the optional
   ;      input keyword parameters AMISS is set, this maximum value is for
   ;      the valid values contained within the allowed range
   ;      [ignore_below, ignore_above].
   ;
   ;  *   thresh {FLOAT} [O]: The threshold value in the given array,
   ;      within the allowed range [ignore_below, ignore_above], if
   ;      specified, such that per percents of the sorted array elements
   ;      are smaller than or equal to thresh.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   AMISS = amiss {INT} [I]: Flag indicating whether the array
   ;      contains (1) or does not contain (0) missing values. If missing
   ;      values are present in array, they are assumed to be strictly
   ;      smaller than ignore_below or strictly larger than ignore_above.
   ;
   ;  *   IGNORE_BELOW = ignore_below {STRING} [I]: Minimum valid value
   ;      within the input positional parameter array: If the AMISS
   ;      keyword has been set, this keyword is mandatory and all array
   ;      values strictly lower than this value are ignored for the
   ;      purpose of computing statistics and thresh.
   ;
   ;  *   IGNORE_ABOVE = ignore_above {STRING} [I]: Maximum valid value
   ;      within the input positional parameter array: If the AMISS
   ;      keyword has been set, this keyword is mandatory and all array
   ;      values strictly higher than this value are ignored for the
   ;      purpose of computing statistics and thresh.
   ;
   ;  *   COUNT = count {LONG} [O]: If the keyword parameter AMISS is not
   ;      set, count is the number of elements of array. If the keyword
   ;      parameter AMISS is set, count reports on the number of
   ;      non-missing elements in array that were considered in the
   ;      estimation of the percentile thresh (i.e., the number of array
   ;      elements within the range [ignore_below, ignore_above].
   ;
   ;  *   DOUBLE = double {INT} [I]: Flag requesting explicitly (1) that
   ;      computations be carried out in double precision or not (0).
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
   ;      provided in the call. The output positional parameters amin,
   ;      amax and thresh provide the minimum and maximum values of the
   ;      input positional parameter array, as well as the desired
   ;      percentile, respectively.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero value, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output positional parameters thresh, amin and amax
   ;      are set to !VALUES.F_INFINITY.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The requested percentile is not a number within the
   ;      range [0.0, 1.0].
   ;
   ;  *   Error 120: Input positional parameter array is not a numeric
   ;      array.
   ;
   ;  *   Error 130: Input keyword parameter AMISS is set while keywords
   ;      IGNORE_BELOW and IGNORE_ABOVE are both null.
   ;
   ;  *   Error 140: Input positional parameter array contains fewer than
   ;      3 valid elements.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The input positional parameter array can be
   ;      multi-dimensional, but the resulting thresh applies to all
   ;      elements of array.
   ;
   ;  *   NOTE 2: If the input keyword parameter AMISS is set, the keyword
   ;      parameters ignore_below and ignore_above are required. At least
   ;      one of them must be set explicitly to a non-zero value,
   ;      otherwise all values are considered missing.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> a = [1, 7, 3, -99, 4, 5, -99, 9, 6, 2, 8]
   ;      IDL> PRINT, N_ELEMENTS(a), MIN(a), MAX(a)
   ;                11     -99       9
   ;      IDL> rc = percentile(0.5, a, amin, amax, thresh, /AMISS, $
   ;         IGNORE_BELOW = '0', IGNORE_ABOVE = '100', COUNT = count, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, rc, '   >' + excpt_cond + '<'
   ;             0   ><
   ;      IDL> PRINT, thresh, count, amin, amax
   ;             5           9       1       9
   ;
   ;  REFERENCES:
   ;
   ;  *   Web page
   ;      http://www.itl.nist.gov/div898/handbook/prc/section2/prc252.htm,
   ;      visited on 30 Oct 2017.
   ;
   ;  VERSIONING:
   ;
   ;  *   2008–01–01: Version 0.5 — Initial release under the name prctl.
   ;
   ;  *   2008–10–14: Version 0.6 — Corrections to the documentation.
   ;
   ;  *   2015–04–05: Version 0.7 — Add reporting the min and max values
   ;      within the allowable range.
   ;
   ;  *   2017–01–05: Version 0.8 — Update in-line documentation and add
   ;      the optional COUNT keyword parameter.
   ;
   ;  *   2017–07–05: Version 0.9 — Changed function name to percentile,
   ;      converted some of the input positional parameters into keyword
   ;      parameters, updated the in-line documentation, implemented the
   ;      keywords ignore_below and ignore_above as strings to avoid the
   ;      incorrect interpretation of a null value.
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
   ;  *   2019–08–20: Version 2.1.0 — Update and simplify the function,
   ;      adopt revised coding and documentation standards (in particular
   ;      regarding the assignment of numeric return codes), and switch to
   ;      3-parts version identifiers.
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
   IF (KEYWORD_SET(amiss)) THEN amiss = 1 ELSE amiss = 0
   IF (KEYWORD_SET(double)) THEN double = 1 ELSE double = 0
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Initialize the output positional parameters to invalid values:
   IF (double) THEN amin = -!VALUES.D_INFINITY $
      ELSE amin = -!VALUES.F_INFINITY
   IF (double) THEN amax = !VALUES.D_INFINITY $
      ELSE amax = !VALUES.F_INFINITY
   thresh = !VALUES.F_INFINITY
   count = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 5
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): per, array, amin, amax, thresh.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with an invalid percentile value:
      IF ((is_numeric(per) NE 1) OR (per LT 0.0) OR (per GT 1.0)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Requested percentile is not a number within [0.0, 1.0].'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with an invalid input array:
      IF ((is_array(array) NE 1) OR (is_numeric(array) NE 1)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter array is not a numeric array.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  If the keyword AMISS has been set, check that the keyword parameters
   ;  'ignore_below' and 'ignore_above' have also been set and that they are
   ;  not simultaneously null:
   IF (amiss) THEN BEGIN
      IF (~KEYWORD_SET(ignore_below)) THEN ignore_below = 0.0
      IF (~KEYWORD_SET(ignore_above)) THEN ignore_above = 0.0
      IF (debug AND (ignore_below EQ 0.0) AND (ignore_above EQ 0.0)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Keyword AMISS is set while keywords IGNORE_BELOW and ' + $
            'IGNORE_ABOVE are both null.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Force the computations to take place in double precision if the keyword
   ;  double has been set:
   IF (double) THEN BEGIN
      per = DOUBLE(per)
      array = DOUBLE(array)
      IF (amiss) THEN BEGIN
         ignore_below = DOUBLE(ignore_below)
         ignore_above = DOUBLE(ignore_above)
      ENDIF
   ENDIF ELSE BEGIN
      IF (amiss) THEN BEGIN
         ignore_below = FLOAT(ignore_below)
         ignore_above = FLOAT(ignore_above)
      ENDIF
   ENDELSE

   ;  If the keyword AMISS has been set, create a new array containing no
   ;  missing values, and compute the number of elements in that new array;
   ;  otherwise count the number of elements in the original array:
   IF (amiss) THEN BEGIN
      inomiss = WHERE((array GE ignore_below) AND (array LE ignore_above), $
         count)
      anomiss = array[inomiss]
   ENDIF ELSE BEGIN
      anomiss = array
      count = N_ELEMENTS(array)
   ENDELSE

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'array' does not contain at least 3 valid elements:
   IF (debug AND (N_ELEMENTS(array) LT 3)) THEN BEGIN
      error_code = 140
      excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
         ': Input positional parameter array contains less than 3 elements.'
      RETURN, error_code
   ENDIF

   ;  Sort the array of valid values:
   sort_idx = SORT(anomiss)
   sanomiss = anomiss[sort_idx]

   ;  Compute the minimum and the maximum valid values of the input positional
   ;  parameter array:
   amin = MIN(sanomiss, MAX = amax)

   ;  Compute the rank of the observation in array corresponding to the
   ;  desired percentile:
   IF (double) THEN BEGIN
      rank = per * DOUBLE(count + 1)
   ENDIF ELSE BEGIN
      rank = per * FLOAT(count + 1)
   ENDELSE

   ;  Check for extreme cases arising with small arrays:
   IF (rank LT 1.0) THEN BEGIN
      thresh = sanomiss[0]
      RETURN, return_code
   ENDIF
   IF (rank GT FLOAT(count)) THEN BEGIN
      thresh = sanomiss[count - 1]
      RETURN, return_code
   ENDIF

   ;  If the rank corresponds to an existing observation, return that
   ;  observation:
   flo = FLOOR(rank)
   IF (rank EQ FLOAT(flo)) THEN BEGIN
      thresh = sanomiss[flo - 1]
      RETURN, return_code
   ENDIF

   ;  In all other cases, assign the percentile as a weighted average of
   ;  the two relevant observations in the sorted array. First identify
   ;  the observations that bracket the desired percentile:
   a1 = sanomiss[flo - 1]
   a2 = sanomiss[flo]

   ;  Compute the interpolated percentile:
   thresh = a1 + (rank - FLOAT(flo)) * (a2 - a1)

   RETURN, return_code

END
