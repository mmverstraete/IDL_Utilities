FUNCTION make_bytemap, byte_array, good_vals, good_vals_cols, save_spec, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function generates and saves, in the folder save_spec,
   ;  a PNG-formatted graphic representation of the input positional
   ;  parameter byte_array, where the BYTE values contained in the array
   ;  good_vals are coded in the colors contained in the array
   ;  good_vals_cols.
   ;
   ;  ALGORITHM: This function creates a graphical representation of the
   ;  2-D array byte_array where the values contained in good_vals are
   ;  plotted in the corresponding colors given in good_vals_cols. Values
   ;  in the data array that are not listed in good_vals are assigned the
   ;  default color 0, which is black. The list of recognized colors is
   ;  defined by the World Wide Web Consortium (W3C) and are listed in the
   ;  IDL documentation under the entry !COLOR.
   ;
   ;  SYNTAX: rc = make_bytemap(byte_array, good_vals, good_vals_cols, $
   ;  save_spec, DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   byte_array {BYTE array} [I]: A 2-D array of values of type BYTE.
   ;
   ;  *   good_vals {BYTE array} [I]: A 1-D array of values of type BYTE.
   ;
   ;  *   good_vals_cols {STRING array} [I]: A 1-D array of standard color
   ;      names, as defined by W3C or IDL.
   ;
   ;  *   save_spec {STRING} [I]: The file specification to be used to
   ;      save the graphic file.
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
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided in the call. The output graphic file is saved in the
   ;      location specified by the input argument save_spec.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns a non-zero error code, and the output keyword parameter
   ;      excpt_cond contains a message about the exception condition
   ;      encountered, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided. The output graphic file is not generated and is not
   ;      saved.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameter byte_array is not of type
   ;      BYTE.
   ;
   ;  *   Error 120: Input positional parameter byte_array is not a 2D
   ;      array.
   ;
   ;  *   Error 130: Input positional parameter good_vals is not of type
   ;      BYTE or INT.
   ;
   ;  *   Error 140: Input positional parameter good_vals contains none or
   ;      more than 256 values.
   ;
   ;  *   Error 150: Input positional parameter good_vals_cols must be of
   ;      type STRING.
   ;
   ;  *   Error 160: Input positional parameter good_vals_cols contains
   ;      none or more than 256 values.
   ;
   ;  *   Error 170: Input positional parameters good_vals and
   ;      good_vals_cols must have the same dimensions.
   ;
   ;  *   Error 180: At least one of the specified color names is
   ;      unrecognized.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: Values contained in the input data array byte_array that
   ;      are not listed in the input array good_vals have no explicitly
   ;      assigned color code in the map, which defaults to a color code
   ;      0, and hence to the first color listed in good_vals_cols.
   ;
   ;  *   NOTE 2: Different values of the input array good_vals can be
   ;      assigned the same color in good_vals_cols, as long as these two
   ;      arrays have the same dimension to ensure the correspondence
   ;      between their matching elements.
   ;
   ;  *   NOTE 3: A given value of the input array good_vals can be
   ;      assigned multiple colors in good_vals_cols, as long as these two
   ;      arrays have the same dimension to ensure the correspondence
   ;      between their matching elements. In that case, assignments
   ;      associated with a higher index in those file supersede those
   ;      made previously.
   ;
   ;  *   NOTE 4: The input array good_vals may contain values that are
   ;      not present in the input data array byte_array, as long as the
   ;      input array good_vals_cols also contains a nominal color
   ;      assignment, which will be ignored.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> byte_array = BYTARR(200, 50)
   ;      IDL> FOR i = 0, 146 DO byte_array[i, *] = BYTE(i)
   ;      IDL> good_vals = BINDGEN(147)
   ;      IDL> good_vals_cols = TAG_NAMES(!COLOR)
   ;      IDL> rc = make_bytemap(byte_array, good_vals, good_vals_cols, '/Users/michel/Desktop/test.png', /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, 'rc = ' + strstr(rc) + ' and excpt_cond = >' + excpt_cond + '<'
   ;      rc = 0 and excpt_cond = ><
   ;
   ;  REFERENCES:
   ;
   ;  *   See the color conventions recommended by the World Wide Web
   ;      Consortium (W3C)
   ;      [https://www.w3.org/TR/2018/REC-css-color-3-20180619/], or the
   ;      IDL documentation under the entry !COLOR.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–08–04: Version 0.9 — Initial release.
   ;
   ;  *   2018–08–08: Version 1.0 — Initial public release.
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

   ;  Retrieve the list of 147 official color names, together with their
   ;  indices and RGB values (this standard information is used both for
   ;  testing and implementation purposes):
   list_col_names = TAG_NAMES(!COLOR)
   n_colors = N_ELEMENTS(list_col_names)
   list_col_indices = BINDGEN(n_colors)
   list_col_rgb = BYTARR(3, n_colors)
   FOR i = 0, n_colors - 1 DO BEGIN
      list_col_rgb[0, i] = !COLOR.(i)[0]
      list_col_rgb[1, i] = !COLOR.(i)[1]
      list_col_rgb[2, i] = !COLOR.(i)[2]
   ENDFOR

   IF (debug) THEN BEGIN

   ;  Return to the calling routine with an error message if one or more
   ;  positional parameters are missing:
      n_reqs = 4
      IF (N_PARAMS() NE n_reqs) THEN BEGIN
         error_code = 100
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Routine must be called with ' + strstr(n_reqs) + $
            ' positional parameter(s): byte_array, good_vals, ' + $
            'good_vals_cols, save_spec.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'byte_array' is not of type BYTE:
      size_ba = SIZE(byte_array)
      type_ba = size_ba[N_ELEMENTS(size_ba) - 2]
      IF (type_ba NE 1) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter byte_array must be of type BYTE.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'byte_array' is not a 2D array:
      dim_ba = size_ba[0]
      IF (dim_ba NE 2) THEN BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter byte_array must be a 2D array.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'good_vals' is not of type BYTE or INT:
      size_gv = SIZE(good_vals)
      type_gv = size_gv[N_ELEMENTS(size_gv) - 2]
      IF ((type_gv NE 1) AND (type_gv NE 2)) THEN BEGIN
         error_code = 130
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter good_vals must be of type ' + $
            '1 (BYTE) or 2 (INT), instead of ' + strstr(type_gv) + '.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'good_vals' is not an array of at most 256 values:
      dim_gv = size_gv[0]
      num_gv = size_gv[N_ELEMENTS(size_gv) - 1]
      IF ((dim_gv LT 1) OR (num_gv GT 256)) THEN BEGIN
         error_code = 140
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter good_vals must be an array of ' + $
            'at most 256 elements.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'good_vals_cols' is not of type STRING:
      size_gvc = SIZE(good_vals_cols)
      type_gvc = size_gvc[N_ELEMENTS(size_gvc) - 2]
      IF (type_gvc NE 7) THEN BEGIN
         error_code = 150
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter good_vals_cols must be of type STRING.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the input
   ;  positional parameter 'good_vals_cols' is not an array of at most 256
   ;  values (Note that only 147 values are pre-defined in the !COLOR
   ;  structure):
      dim_gvc = size_gvc[0]
      num_gvc = size_gvc[N_ELEMENTS(size_gvc) - 1]
      IF ((dim_gvc LT 1) OR (num_gvc GT 256)) THEN BEGIN
         error_code = 160
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameter good_vals_cols must be an ' + $
            'array of at most 256 elements.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the dimensions of
   ;  of the good_vals and good_vals_cols arrays do not match:
      IF (num_gv NE num_gvc) THEN BEGIN
         error_code = 170
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Input positional parameters good_vals and good_vals_cols ' + $
            'must have the same dimensions.'
         RETURN, error_code
      ENDIF

   ;  Return to the calling routine with an error message if the color names
   ;  are invalid. First, retrieve the list of 147 official color names, then
   ;  check that each of the specified colors exists and is non ambiguous:
      FOR i = 0, num_gvc - 1 DO BEGIN
         idx = WHERE(STRUPCASE(good_vals_cols[i]) EQ list_col_names, count)
         IF (count NE 1) THEN BEGIN
            error_code = 180
            excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
               ': Requested color ' + good_vals_cols[i] + ' is not recognized.'
            RETURN, error_code
         ENDIF
      ENDFOR
   ENDIF

   ;  Ensure that the array of good values, possibly of type INT, is recast
   ;  in type BYTE:
   good_vals = BYTE(good_vals)
   n_good_vals = N_ELEMENTS(good_vals)

   ;  Set the dimensions of the map, as a number of lines by a number of
   ;  columns and assign the color indices to the values that must be mapped:
   byte_map = BYTARR(size_ba[1], size_ba[2])
   FOR i = 0, n_good_vals - 1 DO BEGIN
      idx = WHERE(byte_array EQ good_vals[i], count_i)
      IF (count_i GT 0) THEN BEGIN
         jdx = WHERE(STRUPCASE(good_vals_cols[i]) EQ list_col_names, count_j)
         col_index = jdx[0]
         byte_map[idx] = col_index
      ENDIF
   ENDFOR

   ;  Save this map as a PNG file in the specified location:
   WRITE_PNG, save_spec, byte_map, list_col_rgb[0, *], list_col_rgb[1, *], $
      list_col_rgb[2, *], /ORDER

   RETURN, return_code

END
