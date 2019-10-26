FUNCTION haversine, $
   lat_1, $
   lon_1, $
   lat_2, $
   lon_2, $
   distance, $
   DEBUG = debug, $
   EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function computes the haversine distance between the
   ;  two locations specified by their latitudes and longitudes in decimal
   ;  degrees.
   ;
   ;  ALGORITHM: This function implements the classical haversine formula,
   ;  as described in the references below.
   ;
   ;  SYNTAX: rc = haversine(lat_1, lon_1, lat_2, lon_2, $
   ;  distance, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   lat_1 {DOUBLE} [I]: The latitude of the first location, in
   ;      decimal degrees.
   ;
   ;  *   lon_1 {DOUBLE} [I]: The longitude of the first location, in
   ;      decimal degrees.
   ;
   ;  *   lat_2 {DOUBLE} [I]: The latitude of the second location, in
   ;      decimal degrees.
   ;
   ;  *   lon_2 {DOUBLE} [I]: The longitude of the second location, in
   ;      decimal degrees.
   ;
   ;  *   distance {DOUBLE} [O]: The shortest distance between the two
   ;      locations, in m, following a great circle on a spherical Earth.
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
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The distance between the 2 input locations
   ;      is provided in output positional parameter.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The distance between the 2 locations may be undefined,
   ;      incomplete or incorrect.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: The input positional parameter lat_1 is not of type
   ;      FLOAT or DOUBLE.
   ;
   ;  *   Error 112: The input positional parameter lat_1 must be in the
   ;      range [-90.0D, 90.0D].
   ;
   ;  *   Error 120: The input positional parameter lon_1 is not of type
   ;      FLOAT or DOUBLE.
   ;
   ;  *   Error 122: The input positional parameter lon_1 must be in the
   ;      range [-180.0D, 180.0D].
   ;
   ;  *   Error 130: The input positional parameter lat_2 is not of type
   ;      FLOAT or DOUBLE.
   ;
   ;  *   Error 132: The input positional parameter lat_2 must be in the
   ;      range [-90.0D, 90.0D].
   ;
   ;  *   Error 140: The input positional parameter lon_2 is not of type
   ;      FLOAT or DOUBLE.
   ;
   ;  *   Error 142: The input positional parameter lon_2 must be in the
   ;      range [-180.0D, 180.0D].
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   is_double.pro
   ;
   ;  *   is_float.pro
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The shortest distance between two locations returned by
   ;      this function does not take into account any differences in
   ;      altitude: it only reports on the distance between the specified
   ;      latitudes and longitudes, on a spherical Earth, at the mean sea
   ;      level.
   ;
   ;  *   NOTE 2: The outcome of this routine is quite sensitive to the
   ;      number of decimal places and the numerical precision with which
   ;      the input latitudes and longitudes are provided: this is
   ;      particularly important for small distances (compare the results
   ;      of the two examples below).
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> lat_1 = -27.34439555D
   ;      IDL> lon_1 = 30.13553714D
   ;      IDL> lat_2 = -27.34400537D
   ;      IDL> lon_2 = 30.13680177D
   ;      IDL> rc = haversine(lat_1, lon_1, lat_2, lon_2, distance)
   ;      IDL> PRINT, 'distance = ', distance, ' m.', $
   ;         FORMAT = '(3X, A12, D12.8, A)'
   ;      distance = 132.22838583 m.
   ;
   ;      IDL> lat_1 = -27.344D
   ;      IDL> lon_1 = 30.135D
   ;      IDL> lat_2 = -27.344D
   ;      IDL> lon_2 = 30.136D
   ;      IDL> rc = haversine(lat_1, lon_1, lat_2, lon_2, distance)
   ;      IDL> PRINT, 'distance = ', distance, ' m.', $
   ;         FORMAT = '(3X, A12, D12.8, A)'
   ;      distance =  98.77053613 m.
   ;
   ;  REFERENCES:
   ;
   ;  *   https://www.movable-type.co.uk/scripts/latlong.html, visited on
   ;      6 April 2019.
   ;
   ;  *   https://en.wikipedia.org/wiki/Earth_radius, visited on 6
   ;      April 2019.
   ;
   ;  VERSIONING:
   ;
   ;  *   2019–04–06: Version 1.0 — Initial release.
   ;
   ;  *   2019–04–06: Version 2.00 — Systematic update of all routines to
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

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 5
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): lat_1, lon_1, lat_2, lon_2' + $
            'distance.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lat_1' is not of type FLOAT or DOUBLE:
      res1 = is_float(lat_1)
      res2 = is_double(lat_1)
      IF ((res1 NE 1) AND (res2 NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lat_1 is not a FLOAT or a ' + $
            'DOUBLE variable.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lat_1' is invalid:
      IF ((lat_1 LT -90.0D) OR (lat_1 GT 90.0D)) THEN BEGIN
         error_code = 112
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lat_1 must be in the range ' + $
            '[-90.0D, 90.0D].'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lon_1' is not of type FLOAT or DOUBLE:
      res1 = is_float(lon_1)
      res2 = is_double(lon_1)
      IF ((res1 NE 1) AND (res2 NE 1)) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lon_1 is not a FLOAT or a ' + $
            'DOUBLE variable.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lon_1' is invalid:
      IF ((lon_1 LT -180.0D) OR (lon_1 GT 180.0D)) THEN BEGIN
         error_code = 122
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lon_1 must be in the range ' + $
            '[-180.0D, 180.0D].'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lat_2' is not of type FLOAT or DOUBLE:
      res1 = is_float(lat_2)
      res2 = is_double(lat_2)
      IF ((res1 NE 1) AND (res2 NE 1)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lat_2 is not a FLOAT or a ' + $
            'DOUBLE variable.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lat_2' is invalid:
      IF ((lat_2 LT -90.0D) OR (lat_2 GT 90.0D)) THEN BEGIN
         error_code = 132
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lat_2 must be in the range ' + $
            '[-90.0D, 90.0D].'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lon_2' is not of type FLOAT or DOUBLE:
      res1 = is_float(lon_2)
      res2 = is_double(lon_2)
      IF ((res1 NE 1) AND (res2 NE 1)) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lon_2 is not a FLOAT or a ' + $
            'DOUBLE variable.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'lon_2' is invalid:
      IF ((lon_2 LT -180.0D) OR (lon_2 GT 180.0D)) THEN BEGIN
         error_code = 142
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': The input positional parameter lon_2 must be in the range ' + $
            '[-180.0D, 180.0D].'
         RETURN, error_code
      ENDIF
   ENDIF

   ;  Ensure the geographical coordinates are of type DOUBLE:
   lat_1 = DOUBLE(lat_1)
   lon_1 = DOUBLE(lon_1)
   lat_2 = DOUBLE(lat_2)
   lon_2 = DOUBLE(lon_2)

   ;  Set the mean Earth radius:
   radius = 6371000.0D

   ;  Convert the latitudes from decimal degrees to radians:
   phi_1 = lat_1 * !PI / 180.0D
   phi_2 = lat_2 * !PI / 180.0D

   ;  Convert the differences in latitudes and longitudes from decimal degrees
   ;  to radians:
   del_phi = (lat_2 - lat_1) * !PI / 180.0D
   del_lam = (lon_2 - lon_1) * !PI / 180.0D

   ;  Compute the haversine distance between the two locations:
   a = SIN(del_phi / 2.0D) * SIN(del_phi / 2.0D) + $
      COS(phi_1) * COS(phi_2) * $
      SIN(del_lam / 2.0D) * SIN(del_lam / 2.0D)
   c = 2.0D * ATAN(SQRT(a), SQRT(1.0D - a))
   distance = radius * c

   RETURN, return_code

END
