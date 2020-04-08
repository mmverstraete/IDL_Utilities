FUNCTION cor_arrays, $
   array_1, $
   array_2, $
   stats, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function computes various statistics to describe the
   ;  possible relations between two arrays containing the same number of
   ;  data points. The results are stored in the pre-existing output
   ;  structure stats.
   ;
   ;  ALGORITHM: This function relies on IDL built-in routines to compute
   ;  the desired statistics.
   ;
   ;  SYNTAX: rc = cor_arrays(array_1, array_2, stats, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   array_1 {FLOAT array} [I]: The first array to consider.
   ;
   ;  *   array_2 {FLOAT array} [I]: The second array to consider.
   ;
   ;  *   stats {STRUCTURE} [I/O]: A pre-existing structure to hold the
   ;      statistical results, organized as follows:
   ;
   ;          stats = CREATE_STRUCT(NAME = 'Bivariate', $
   ;             'experiment', 0, $
   ;             'array_1_id', '', $
   ;             'array_2_id', '', $
   ;             'N_points', 0L, $
   ;             'RMSD', 0.0, $
   ;             'Pearson_cc', 0.0, $
   ;             'Spearman_cc', 0.0, $
   ;             'Spearman_sig', 0.0, $
   ;             'Spearman_D', 0.0, $
   ;             'Spearman_PROBD', 0.0, $
   ;             'Spearman_ZD', 0.0, $
   ;             'Linear_fit_1', '', $
   ;             'Linfit_a_1', 0.0, $
   ;             'Linfit_b_1', 0.0, $
   ;             'Linfit_CHISQR_1', 0.0, $
   ;             'Linfit_PROB_1', 0.0, $
   ;             'Linear_fit_2', '', $
   ;             'Linfit_a_2', 0.0, $
   ;             'Linfit_b_2', 0.0, $
   ;             'Linfit_CHISQR_2', 0.0, $
   ;             'Linfit_PROB_2', 0.0)
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
   ;      provided in the call. The desired statistics are contained in
   ;      the output structure stats.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output structure may be empty, incomplete or
   ;      useless.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Positional parameter array_1 or array_2 is not of
   ;      type numeric.
   ;
   ;  *   Error 120: Positional parameter array_1 or array_2 is not an
   ;      array.
   ;
   ;  *   Error 130: Positional parameter array_1 and array_2 are of
   ;      different sizes.
   ;
   ;  *   Error 140: Positional parameter array_1 and array_2 contain
   ;      fewer than 5 elements.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_numeric.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The structure elements experiment, array_1_id and
   ;      array_2_id are intended to contain a numeric identifier for the
   ;      experiment and descriptors of these two positional parameters.
   ;      These should be set prior to calling this function.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> stats = CREATE_STRUCT(NAME = 'Bivariate', $
   ;      IDL>    'experiment', 0, $
   ;      IDL>    'array_1_id', '', $
   ;      IDL>    'array_2_id', '', $
   ;      IDL>    'N_points', 0L, $
   ;      IDL>    'RMSD', 0.0, $
   ;      IDL>    'Pearson_cc', 0.0, $
   ;      IDL>    'Spearman_cc', 0.0, $
   ;      IDL>    'Spearman_sig', 0.0, $
   ;      IDL>    'Spearman_D', 0.0, $
   ;      IDL>    'Spearman_PROBD', 0.0, $
   ;      IDL>    'Spearman_ZD', 0.0, $
   ;      IDL>    'Linear_fit_1', '', $
   ;      IDL>    'Linfit_a_1', 0.0, $
   ;      IDL>    'Linfit_b_1', 0.0, $
   ;      IDL>    'Linfit_CHISQR_1', 0.0, $
   ;      IDL>    'Linfit_PROB_1', 0.0, $
   ;      IDL>    'Linear_fit_2', '', $
   ;      IDL>    'Linfit_a_2', 0.0, $
   ;      IDL>    'Linfit_b_2', 0.0, $
   ;      IDL>    'Linfit_CHISQR_2', 0.0, $
   ;      IDL>    'Linfit_PROB_2', 0.0)
   ;      IDL> x1 = [65,63,67,64,68,62,70,66,68,67,69,71]
   ;      IDL> y1 = [68,66,68,65,69,66,68,65,71,67,68,70]
   ;      IDL> stats.experiment = 1
   ;      IDL> stats.array_1_id = 'x1'
   ;      IDL> stats.array_2_id = 'y1'
   ;      IDL> rc = cor_arrays(x1, y1, stats, /DEBUG, $
   ;      IDL>    EXCPT_COND = excpt_cond)
   ;      IDL> fmt = '(A20, A)'
   ;      IDL> PRINT, 'N_points = ', strstr(stats.N_points), FORMAT = fmt
   ;            N_points = 12
   ;      IDL> PRINT, 'RMSD = ', strstr(stats.RMSD), FORMAT = fmt
   ;            RMSD = 2.10159
   ;      ...
   ;      IDL> PRINT, 'Linear_fit_2 = ', strstr(stats.Linear_fit_2), $
   ;      IDL>    FORMAT = fmt
   ;           Linear_fit_2 = array_1 = a + b x array_2
   ;      IDL> PRINT, 'Linfit_a_2 = ', strstr(stats.Linfit_a_2), $
   ;      IDL>    FORMAT = fmt
   ;           Linfit_a_2 = -3.37687
   ;      ...
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–02–28: Version 0.8 — Initial release under the name
   ;      cor_fields.
   ;
   ;  *   2017–07–20: Version 0.9 — Renamed function to cor_arrays,
   ;      removed any reference to MISR or MISR-HR (generic utility
   ;      routine), updated documentation.
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
   ;
   ;  *   2020–03–05: Version 2.1.1 — Add a test on the input data arrays
   ;      to ensure they contain at least 5 elements.
   ;Sec-Lic
   ;  INTELLECTUAL PROPERTY RIGHTS
   ;
   ;  *   Copyright (C) 2017-2020 Michel M. Verstraete.
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
   ;      be included in their entirety in all copies or substantial
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

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 3
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): array_1, array_2, stats.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if either of the
   ;  input positional parameters 'array_1' or 'array_2' is not of a numeric
   ;  type:
      IF ((is_numeric(array_1) NE 1) OR (is_numeric(array_2) NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': At least one of the input positional parameters array_1 or array_2 is not of ' + $
            'a numeric type.'
         RETURN, error_code
      ENDIF
   ENDIF

   siz_1 = SIZE(array_1)
   n_dims_1 = siz_1[0]
   n_elms_1 = siz_1[1]
   siz_2 = SIZE(array_2)
   n_dims_2 = siz_2[0]
   n_elms_2 = siz_2[1]

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if either of the
   ;  input positional parameters 'array_1' or 'array_2' is not a vector
   ;  (1D array):
      IF ((n_dims_1 NE 1) OR (n_dims_2 NE 1)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Either array_1 or array_2 is not a vector (1D array).'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if input positional
   ;  parameters 'array_1' and 'array_2' are of different sizes:
      IF (n_elms_1 NE n_elms_2) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameters array_1 and array_2 are ' + $
            'not of the same size.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if input positional
   ;  parameters 'array_1' and 'array_2' contain fewer than 5 elements:
      IF (n_elms_1 LT 5) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameters array_1 and array_2 ' + $
            'contain fewer than 5 elements.'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Record the number of points in the input arrays:
   stats.N_points = n_elms_1

   ;  Compute the root-mean-square deviation (RMSD) between those arrays:
   numer = TOTAL((array_1 - array_2) * (array_1 - array_2))
   rmsd = SQRT(numer / n_elms_1)
   stats.RMSD = rmsd

   ;  Compute the linear Pearson correlation coefficient between those arrays:
   pearson_cc = CORRELATE(array_1, array_2, /DOUBLE)
   stats.Pearson_cc = pearson_cc

   ;  Compute the Spearman's rank correlation coefficient between those arrays:
   spearman_cc = R_CORRELATE(array_1, array_2, D = d, PROBD = probd, ZD = zd)
   stats.Spearman_cc = spearman_cc[0]
   stats.Spearman_sig = spearman_cc[1]
   stats.Spearman_D = d
   stats.Spearman_PROBD = probd
   stats.Spearman_ZD = zd

   ;  Fit a linear function to describe 'array_2' as a function of 'array_1':
   res = LINFIT(array_1, array_2, CHISQR = chisqr, PROB = prob, /DOUBLE)
   stats.Linear_fit_1 = 'array_2 = a + b x array_1'
   stats.Linfit_a_1 = res[0]
   stats.Linfit_b_1 = res[1]
   stats.Linfit_CHISQR_1 = chisqr
   stats.Linfit_PROB_1 = prob

   ;  Fit a linear function to describe 'array_1' as a function of 'array_2':
   res = LINFIT(array_2, array_1, CHISQR = chisqr, PROB = prob, /DOUBLE)
   stats.Linear_fit_2 = 'array_1 = a + b x array_2'
   stats.Linfit_a_2 = res[0]
   stats.Linfit_b_2 = res[1]
   stats.Linfit_CHISQR_2 = chisqr
   stats.Linfit_PROB_2 = prob

   RETURN, return_code

END
