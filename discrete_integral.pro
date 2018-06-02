FUNCTION discrete_integral, x, y, BASELINE = baseline, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function computes the integral of a mathematical
   ;  function provided as a discrete set of (x, y) points.
   ;
   ;  ALGORITHM: This function calculates the ‘area under the curve’
   ;  defined by the discrete set of (x, y) points, assuming a simple
   ;  linear interpolation between those points (the so-called
   ;  “trapezoidal rule”). The optional BASELINE keyword allows for
   ;  adjusting the arbitrary constant inherent with the estimation of a
   ;  definite integral.
   ;
   ;  SYNTAX: res = discrete_integral(x, y, BASELINE = baseline, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   x {FLOAT} [I]: The array of independent variable values.
   ;
   ;  *   y {FLOAT} [I]: The array of dependent variable values.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   BASELINE = baseline {FLOAT} [I] (Default value: 0.0): The
   ;      reference dependent variable value from which the ‘area under
   ;      the curve’ will be computed.
   ;
   ;  *   DEBUG = debug {INT} [I] (Default value: 0): Flag to activate (1)
   ;      or skip (0) debugging tests.
   ;
   ;  *   EXCPT_COND = excpt_cond {STRING} [O] (Default value: ”):
   ;      Description of the exception condition if one has been
   ;      encountered, or a null string otherwise.
   ;
   ;  RETURNED VALUE TYPE: FLOAT.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns the value of the definite integral of the function
   ;      defined by the discrete set of (x, y) points, and the output
   ;      keyword parameter excpt_cond is set to a null string, if the
   ;      optional input keyword parameter DEBUG was set and if the
   ;      optional output keyword parameter EXCPT_COND was provided in the
   ;      call.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns -9999.00, and the output keyword parameter excpt_cond
   ;      contains a message about the exception condition encountered, if
   ;      the optional input keyword parameter DEBUG is set and if the
   ;      optional output keyword parameter EXCPT_COND is provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Routine arguments x and y must be numeric.
   ;
   ;  *   Error 120: Routine arguments x and y must be arrays containing
   ;      at least 2 elements.
   ;
   ;  *   Error 130: Routine arguments x and y must be arrays of the same
   ;      length.
   ;
   ;  *   Error 140: Optional keyword baseline must be of numeric type.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function implements a strict trapezoidal rule to
   ;      estimate the integral of the function provided as a discrete set
   ;      of (x, y) points. If all y values are larger than the baseline,
   ;      the result may underestimate the integral where the function is
   ;      concave, and overestimate it where the function is convex,
   ;      compared to the outcome of a more sophisticated approach, for
   ;      instance by fitting a smooth curve through the points.
   ;
   ;  *   NOTE 2: This function performs all computations in DOUBLE
   ;      precision, and returns the result as a single precision FLOAT
   ;      value.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> x = [1.0, 2.0]
   ;      IDL> y = [4.0, 6.0]
   ;      IDL> res = discrete_integral(x, y, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'res = ', res
   ;      res =       5.00000
   ;
   ;  REFERENCES:
   ;
   ;  *   https://en.wikipedia.org/wiki/Trapezoidal_rule, accessed on 24
   ;      March 2018.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–03–24: Version 0.9 — Initial release.
   ;
   ;  *   2018–03–25: Version 1.0 — Initial public release.
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
   return_code = -9999.00
   excpt_cond = ''

   ;  Set the default values of essential input keyword parameters:
   IF (KEYWORD_SET(debug)) THEN debug = 1 ELSE debug = 0

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 2
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): x, y.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with non-numerical arguments:
      IF ((is_numeric(x) NE 1) OR (is_numeric(y) NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine arguments x and y must be numeric.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with array arguments containing less then 2 points:
      IF ((N_ELEMENTS(x) LT 2) OR (N_ELEMENTS(y) LT 2)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine arguments x and y must be arrays containing ' + $
            'at least 2 elements.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with array arguments of different lengths:
      IF (N_ELEMENTS(x) NE N_ELEMENTS(y)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine arguments x and y must be arrays of the same length.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if this function is
   ;  called with a non-numeric BASELINE keyword:
      IF (KEYWORD_SET(baseline) AND (is_numeric(baseline) NE 1)) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Optional keyword baseline must be of numeric type.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Set the default value of baseline:
   IF (NOT KEYWORD_SET(baseline)) THEN baseline = 0.0

   ;  Cast both input arrays as DOUBLE for the purpose of the computations:
   x_dbl = DOUBLE(x)
   y_dbl = DOUBLE(y)
   baseline_dbl = DOUBLE(baseline)

   ;  Remove the baseline from the function values:
   y_dbl = y_dbl - baseline_dbl

   ;  Compute the integral:
   n_pts = N_ELEMENTS(x_dbl)
   integral = 0.0D
   FOR i = 0, n_pts - 2 DO BEGIN
      integral = integral + 0.5D * (y_dbl[i + 1] + y_dbl[i]) * $
         (x_dbl[i + 1] - x_dbl[i])
   ENDFOR

   RETURN, FLOAT(integral)

END
