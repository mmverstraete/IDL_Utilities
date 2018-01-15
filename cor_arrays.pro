FUNCTION cor_arrays, array_1, array_2, stats, $
   DEBUG = debug, EXCPT_COND = excpt_cond

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
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns 0, the desired statistics are contained in the output
   ;      structure stats, and the output keyword parameter excpt_cond is
   ;      set to a null string, if the optional input keyword parameter
   ;      DEBUG is set and if the optional output keyword parameter
   ;      EXCPT_COND is provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, the output structure is not
   ;      filled and the output keyword parameter excpt_cond contains a
   ;      message about the exception condition encountered, if the
   ;      optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
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
   ;      experiment and descriptors of the two arguments. These should be
   ;      set in the calling routine.
   ;
   ;  EXAMPLES:
   ;
   ;      Program 'tst_cor_arrays.pro' sets the following inputs:
   ;
   ;      x = [65, 63, 67, 64, 68, 62, 70, 66, 68, 67, 69, 71]
   ;      y = [68, 66, 68, 65, 69, 66, 68, 65, 71, 67, 68, 70]
   ;
   ;      defines the structure 'stats', calls 'cor_arrays' and outputs:
   ;
   ;               N_points = 12
   ;                   RMSD = 2.10159
   ;             Pearson_cc = 0.702652
   ;            Spearman_cc = 0.740262
   ;           Spearman_sig = 0.00590285
   ;             Spearman_D = 72.5000
   ;         Spearman_PROBD = 0.0140817
   ;            Spearman_ZD = -2.45517
   ;           Linear_fit_1 = array_2 = a + b x array_1
   ;             Linfit_a_1 = 35.8248
   ;             Linfit_b_1 = 0.476378
   ;        Linfit_CHISQR_1 = 19.7028
   ;          Linfit_PROB_1 = 1.00000
   ;           Linear_fit_2 = array_1 = a + b x array_2
   ;             Linfit_a_2 = -3.37687
   ;             Linfit_b_2 = 1.03640
   ;        Linfit_CHISQR_2 = 42.8651
   ;          Linfit_PROB_2 = 1.00000
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

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if this function is
   ;  called with the wrong number of required positional parameters:
      n_reqs = 3
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): array_1, array_2, stats.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if either argument
   ;  'array_1' or 'array_2' is not of a numeric type:
      IF ((is_numeric(array_1) NE 1) OR (is_numeric(array_2) NE 1)) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': At least one of the arguments array_1 or array_2 is not of ' + $
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

   ;  Return to the calling routine with an error message if either argument
   ;  'array_1' or 'array_2' is not of a vector (1D array):
      IF ((n_dims_1 NE 1) OR (n_dims_2 NE 1)) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Either array_1 or array_2 is not a vector (1D array).'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if arguments
   ;  'array_1' and 'array_2' are of different sizes:
      IF (n_elms_1 NE n_elms_2) THEN BEGIN
         info = SCOPE_TRACEBACK(/STRUCTURE)
         rout_name = info[N_ELEMENTS(info) - 1].ROUTINE
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The arguments array_1 and array_2 are not of the same size.'
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
