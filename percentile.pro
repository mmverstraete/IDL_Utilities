FUNCTION percentile, $
   per, $
   array, $
   amin, $
   amax, $
   thresh, $
   AMISS = amiss, $
   IGN_BEL_STR = ign_bel_str, $
   IGN_ABO_STR = ign_abo_str, $
   ASORT = asort, $
   COUNT = count, $
   DOUBLE = double, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function estimates the sample value thresh of the
   ;  specified percentile per in the input array and returns some basic
   ;  statistical information on that array, which may contain missing
   ;  values and may but does not need to be sorted in ascending order.
   ;
   ;  ALGORITHM: This function determines the sample value corresponding
   ;  to the desired percentile per by either selecting a particular item
   ;  of array, if it corresponds exactly, or interpolating between two
   ;  array sample values otherwise. If missing values may be present in
   ;  array (i.e., input keyword parameter AMISS is set), the output
   ;  keyword parameters amin and amax report the minimum and maximum
   ;  valid values within the allowed range
   ;  [FLOAT(ign_bel_str), FLOAT(ign_abo_str)]; otherwise amin and amax
   ;  report the minimum and maximum values within the entire array.
   ;
   ;  SYNTAX: res = percentile(per, array, amin, amax, thresh, $
   ;  AMISS = amiss, IGN_BEL_STR = ign_bel_str, $
   ;  IGN_ABO_STR = ign_abo_str, ASORT = asort, $
   ;  COUNT = count, DOUBLE = double, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   per {FLOAT} [I]: The desired percentile, a decimal number
   ;      between 0.0 and 1.0.
   ;
   ;  *   array {FLOAT array} [I]: The statistical sample from which the
   ;      percentile needs to be estimated.
   ;
   ;  *   amin {FLOAT} [O]: The minimum value of array, within the allowed
   ;      range
   ;      [FLOAT(ign_bel_str), FLOAT(ign_abo_str)], if these input
   ;      positional parameters are provided, or within the whole array
   ;      otherwise. DOUBLE precision equivalents are used if required.
   ;
   ;  *   amax {FLOAT} [O]: The maximum value of array, within the allowed
   ;      range
   ;      [FLOAT(ign_bel_str), FLOAT(ign_abo_str)], if these input
   ;      positional parameters are provided, or within the whole array
   ;      otherwise. DOUBLE precision equivalents are used if required.
   ;
   ;  *   thresh {FLOAT} [O]: The threshold value in the given array,
   ;      within the allowed range
   ;      [FLOAT(ign_bel_str),FLOAT(ign_abo_str)], if specified, such that
   ;      per percents of the sorted array are below or equal to thresh.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   AMISS = amiss {INT} [I]: Flag indicating whether the array
   ;      contains (1) or does not contain (0) missing values. If missing
   ;      values are present in array, they are assumed to be strictly
   ;      smaller than the numerical equivalent of ign_bel_str or strictly
   ;      larger than the numerical equivalent of ign_abo_str.
   ;
   ;  *   IGN_BEL_STR = ign_bel_str {STRING} [I]: Threshold value provided
   ;      as a string: If the AMISS keyword has been set, this keyword is
   ;      mandatory and all array values strictly lower than the numerical
   ;      equivalent to that string are ignored for the purpose of
   ;      computing statistics and thresh. If the AMISS keyword has not
   ;      been set, this keyword is ignored. See the notes below for
   ;      additional information.
   ;
   ;  *   IGN_ABO_STR = ign_abo_str {STRING} [I]: Threshold value provided
   ;      as a string: If the AMISS keyword has been set, this keyword is
   ;      mandatory and all array values strictly higher than the
   ;      numerical equivalent to that string are ignored for the purpose
   ;      of computing statistics and thresh. If the AMISS keyword has not
   ;      been set, this keyword is ignored. See the notes below for
   ;      additional information.
   ;
   ;  *   ASORT = asort {INT} [I]: Flag indicating whether array is
   ;      already sorted in ascending order (1) or not (0).
   ;
   ;  *   COUNT = count {LONG} [O]: If the keyword parameter AMISS is not
   ;      set, count is the number of elements of array. If the keyword
   ;      parameter AMISS is set, count reports on the number of
   ;      non-missing elements in array that were considered in the
   ;      estimation of the percentile thresh (i.e., the number of array
   ;      elements within the range
   ;      [FLOAT(ign_bel_str), FLOAT(ign_abo_str)].
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
   ;      input positional parameter array and the desired percentile,
   ;      respectively.
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
   ;  *   Warning 10: Keyword parameter IGN_BEL_STR was provided as
   ;      numerical value and has been converted to a string. Processing
   ;      continues.
   ;
   ;  *   Warning 20: Keyword parameter IGN_ABO_STR was provided as
   ;      numerical value and has been converted to a string. Processing
   ;      continues.
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The requested percentile is not within [0.0, 1.0].
   ;
   ;  *   Error 120: Input positional parameter array is not an array or
   ;      not numeric.
   ;
   ;  *   Error 130: Input positional parameter array contains less than 4
   ;      elements.
   ;
   ;  *   Error 140: Keyword AMISS was set but keyword IGN_BEL_STR was
   ;      not.
   ;
   ;  *   Error 150: Keyword AMISS was set but keyword IGN_ABO_STR was
   ;      not.
   ;
   ;  *   Error 160: Input positional parameter array contains less than 2
   ;      non-missing values.
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
   ;  *   NOTE 2: The keyword parameters ign_bel_str and ign_abo_str must
   ;      be provided as strings because IDL interprets a null value as
   ;      meaning that this keyword is NOT set (rather than being set to a
   ;      null value).
   ;
   ;  *   NOTE 3: If missing values may be present in array (i.e., input
   ;      keyword parameter AMISS is set), the output keyword parameters
   ;      amin and amax report the minimum and maximum valid values within
   ;      the allowed range [FLOAT(ign_bel_str), FLOAT(ign_abo_str)];
   ;      otherwise amin and amax report the minimum and maximum values
   ;      within the entire array.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> a = [1, 7, 3, -99, 4, 5, -99, 9, 6, 2, 8]
   ;      IDL> PRINT, N_ELEMENTS(a), MIN(a), MAX(a)
   ;                11     -99       9
   ;      IDL> res = percentile(0.5, a, amin, amax, thresh, /AMISS, $
   ;         IGN_BEL_STR = '0', IGN_ABO_STR = '100', COUNT = count, $
   ;         /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res, '   >' + excpt_cond + '<'
   ;             0   ><
   ;      IDL> PRINT, thresh, count, amin, amax
   ;             5           9       1       9
   ;
   ;      IDL> res = percentile(0.5, a, amin, amax, thresh, /AMISS, $
   ;      IDL>    IGN_BEL_STR = '0', IGN_ABO_STR = 100, COUNT = count, $
   ;      >    /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, thresh, count, amin, amax
   ;             5           9       1       9
   ;      IDL> PRINT, excpt_cond
   ;      Warning 20 in PERCENTILE: Keyword IGN_ABO_STR, provided as
   ;      numerical value was converted to a STRING. Processing continues.
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
   error_code = 0

   ;  Set the default values of flags and essential output keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0
   excpt_cond = ''

   ;  Initialize the output positional parameters to invalid values:
   amin = -!VALUES.F_INFINITY
   amax = !VALUES.F_INFINITY
   thresh = !VALUES.F_INFINITY

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
      IF ((per LT 0.0) OR (per GT 1.0)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Requested percentile is not within [0.0, 1.0].'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with an invalid input array:
      IF ((is_array(array) NE 1) OR (is_numeric(array) NE 1)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter array is not an array or not numeric.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'array' does not contain at least 3 elements:
      IF (N_ELEMENTS(array) LT 3) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter array contains less than 3 elements.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Manage possible exception conditions linked to keyword parameters.
   ;  If the keyword AMISS has been set, check that the keywords 'ign_bel_str'
   ;  and 'ign_abo_str' have also been set as strings:
   IF (KEYWORD_SET(amiss)) THEN BEGIN
      IF (NOT(KEYWORD_SET(ign_bel_str))) THEN BEGIN
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Keyword AMISS was set but keyword IGN_BEL_STR was not.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         IF (is_numeric(ign_bel_str)) THEN BEGIN
            warning_code = 10
            excpt_cond = 'Warning ' + strstr(warning_code) + ' in ' + $
               rout_name + $
               ': Keyword IGN_BEL_STR, provided as a numerical value ' + $
               'was converted to a STRING. Processing continues.'
            ign_bel_str = strstr(ign_bel_str)
            error_code = 10
         ENDIF
      ENDELSE

      IF (NOT(KEYWORD_SET(ign_abo_str))) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Keyword AMISS was set but keyword IGN_ABO_STR was not.'
         RETURN, error_code
      ENDIF ELSE BEGIN
         IF (is_numeric(ign_abo_str)) THEN BEGIN
            warning_code = 20
            excpt_cond = 'Warning ' + strstr(warning_code) + ' in ' + $
               rout_name + $
               ': Keyword IGN_ABO_STR, provided as numerical value ' + $
               'was converted to a STRING. Processing continues.'
            ign_abo_str = strstr(ign_abo_str)
            error_code = 20
         ENDIF
      ENDELSE
   ENDIF

   ;  Force the computations to take place in double precision if the keyword
   ;  double has been set:
   IF (KEYWORD_SET(double)) THEN BEGIN
      per = DOUBLE(per)
      array = DOUBLE(array)
      IF (KEYWORD_SET(amiss)) THEN BEGIN
         ignore_below = DOUBLE(ign_bel_str)
         ignore_above = DOUBLE(ign_abo_str)
      ENDIF
   ENDIF ELSE BEGIN
      IF (KEYWORD_SET(amiss)) THEN BEGIN
         ignore_below = FLOAT(ign_bel_str)
         ignore_above = FLOAT(ign_abo_str)
      ENDIF
   ENDELSE

   ;  If the keyword AMISS has been set, create a new array containing no
   ;  missing values, and compute the number of elements in that new array;
   ;  otherwise count the number of elements in the original array:
   IF (KEYWORD_SET(amiss)) THEN BEGIN
      inomiss = WHERE((array GE ignore_below) AND (array LE ignore_above))
      anomiss = array[inomiss]
      count = N_ELEMENTS(anomiss)
   ENDIF ELSE BEGIN
      anomiss = array
      count = N_ELEMENTS(array)
   ENDELSE

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this new array
   ;  itself does not contain at least 3 elements:
      IF (count LT 3) THEN BEGIN
         error_code = 160
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Array of non-missing values contains less than 3 elements.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  If the original array is unsorted or if there are missing values,
   ;  sort the new array in ascending order:
   IF ((NOT(KEYWORD_SET(asort))) OR (KEYWORD_SET(amiss))) THEN BEGIN
      sort_idx = SORT(anomiss)
      sanomiss = anomiss[sort_idx]
   ENDIF ELSE BEGIN
      sanomiss = anomiss
   ENDELSE

   ;  Compute the minimum and the maximum values of array within the allowable
   ;  range:
   amin = MIN(sanomiss)
   amax = MAX(sanomiss)

   ;  Compute the rank of the observation in array corresponding to the
   ;  desired percentile:
   IF (KEYWORD_SET(double)) THEN BEGIN
      rank = per * DOUBLE(count + 1)
   ENDIF ELSE BEGIN
      rank = per * FLOAT(count + 1)
   ENDELSE

   ;  Check for extreme cases arising with small arrays:
   IF (rank LT 1.0) THEN BEGIN
      thresh = sanomiss[0]
      RETURN, error_code
   ENDIF
   IF (rank GT FLOAT(count)) THEN BEGIN
      thresh = sanomiss[count - 1]
      RETURN, error_code
   ENDIF

   ;  If the rank corresponds to an existing observation, return that
   ;  observation:
   flo = FLOOR(rank)
   IF (rank EQ FLOAT(flo)) THEN BEGIN
      thresh = sanomiss[flo - 1]
      RETURN, error_code
   ENDIF

   ;  In all other cases, assign the percentile as a weighted average of
   ;  the two relevant observations in the sorted array. First identify
   ;  the observations that bracket the desired percentile:
   a1 = sanomiss[flo - 1]
   a2 = sanomiss[flo]

   ;  Compute the interpolated percentile:
   thresh = a1 + (rank - FLOAT(flo)) * (a2 - a1)

   RETURN, error_code

END
