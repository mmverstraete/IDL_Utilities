FUNCTION set_year_range, jul_ini_date, jul_fin_date, $
   DEBUG = debug, EXCPT_COND = excpt_cond

   ;Sec-Doc
   ;  PURPOSE: This function returns a time interval, defined by two
   ;  Julian dates, containing complete common years, that includes the
   ;  time interval specified by jul_ini_date and jul_fin_date.
   ;
   ;  ALGORITHM: This routines returns an array of two Julian dates
   ;  ranging from the 31st of December of the year before the specified
   ;  initial date to the 1st of January of the year following the
   ;  specified final date.
   ;
   ;  SYNTAX: res = set_year_range(jul_ini_date, jul_fin_date, $
   ;  DEBUG = debug, EXCPT_COND = excpt_cond)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   jul_ini_date {DOUBLE} [I]: The initial Julian date.
   ;
   ;  *   jul_fin_date {DOUBLE} [I]: The final Julian date.
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
   ;  RETURNED VALUE TYPE: DOUBLE array.
   ;
   ;  OUTCOME:
   ;
   ;  *   If no exception condition has been detected, this function
   ;      returns the date interval that includes the time interval
   ;      specified by jul_ini_date and jul_fin_date and comprises full
   ;      common years. The output keyword parameter excpt_cond is set to
   ;      a null string, if the optional input keyword parameter DEBUG is
   ;      set and if the optional output keyword parameter EXCPT_COND is
   ;      provided.
   ;
   ;  *   If an exception condition has been detected, this function
   ;      returns the dummy range res = [-99.9D, -99.9D], and the output
   ;      keyword parameter excpt_cond contains a message about the
   ;      exception condition encountered, if the optional input keyword
   ;      parameter DEBUG is set and if the optional output keyword
   ;      parameter EXCPT_COND is provided.
   ;
   ;  EXCEPTION CONDITIONS:
   ;
   ;  *   Error 100: One or more positional parameter(s) are missing.
   ;
   ;  *   Error 110: Input positional parameters jul_ini_date and
   ;      jul_fin_date must both be of type DOUBLE.
   ;
   ;  *   Error 120: Input positional parameters jul_ini_date and
   ;      jul_fin_date must both be posterior to 4 October 1582.
   ;
   ;  *   Error 300: Julian date jul_ini_date must precede Julian date
   ;      jul_fin_date.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: This function is useful to set the time axis on time
   ;      series plots so that the graphic display includes full common
   ;      years.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> jul1 = JULDAY(2, 24, 2000)
   ;      IDL> jul2 = JULDAY(6, 13, 2015)
   ;      IDL> PRINT, jul1, jul2
   ;           2451599     2457187
   ;      IDL> res = set_year_range(jul1, jul2, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;           2451544     2457389
   ;      IDL> PRINT, 'excpt_cond = >' + excpt_cond + '<'
   ;      excpt_cond = ><
   ;      IDL> CALDAT, 2451544, mo1, dy1, yr1
   ;      IDL> CALDAT, 2457389, mo2, dy2, yr2
   ;      IDL> PRINT, mo1, dy1, yr1
   ;                12          31        1999
   ;      IDL> PRINT, mo2, dy2, yr2
   ;                 1           1        2016
   ;
   ;      IDL> res = set_year_range(jul2, jul1, /DEBUG, EXCPT_COND = excpt_cond)
   ;      IDL> PRINT, res
   ;           -99.9000     -99.9000
   ;      IDL> PRINT, 'excpt_cond = ' + excpt_cond
   ;      excpt_cond = Error 1000 in set_date_range:
   ;         Julian date 'jul_ini_date' = 2457187 must precede
   ;         Julian date 'jul_fin_date' = 2451599.
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
   return_code = [-99.9D, -99.9D]
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
            ' positional parameter(s): jul_ini_date, jul_fin_date.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the Julian dates
   ;  provided are not double precision numbers:
      IF ((is_double(jul_ini_date) NE 1) OR $
         (is_double(jul_fin_date) NE 1)) THEN BEGIN
         error_code = 110
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Arguments jul_ini_date = ' + strstr(jul_ini_date) + $
            ' and jul_fin_date = ' + strstr(jul_fin_date) + $
            ' must both be of type DOUBLE.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if the Julian dates
   ;  provided are anterior to 4 October 1582:
      start_date = JULDAY(10, 4, 1582)
      IF ((jul_ini_date LT start_date) OR $
         (jul_fin_date LT start_date)) THEN  BEGIN
         error_code = 120
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Arguments jul_ini_date = ' + strstr(jul_ini_date) + $
            ' and jul_fin_date = ' + strstr(jul_fin_date) + $
            ' must both be posterior to ' + strstr(start_date) + '.'
         RETURN, return_code
      ENDIF

   ;  Return to the calling routine with an error message if 'jul_ini_date'
   ;  follows 'jul_fin_date':
      IF (jul_ini_date GT jul_fin_date) THEN BEGIN
         error_code = 300
         excpt_cond = 'Error ' + strstr(error_code) + ' in ' + rout_name + $
            ': Julian date jul_ini_date = ' + strstr(jul_ini_date) + $
            ' must precede Julian date jul_fin_date = ' + $
            strstr(jul_fin_date) + '.'
         RETURN, return_code
      ENDIF
   ENDIF

   ;  Retrieve the common years of the initial and final dates:
   CALDAT, jul_ini_date, mon1, day1, year1
   CALDAT, jul_fin_date, mon2, day2, year2

   ;  Generate the desired initial and final dates:
   jdate1 = JULDAY(12, 31, year1 - 1)
   jdate2 = JULDAY(1, 1, year2 + 1)

   RETURN, [jdate1, jdate2]

END
