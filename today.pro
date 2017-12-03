FUNCTION today, FMT = fmt

   ;Sec-Doc
   ;  PURPOSE: This function returns today’s date and time as a string in
   ;  one of the following formats: default (keyword FMT not set), iso,
   ;  nice, usa or ymd.
   ;
   ;  ALGORITHM: This routine implements some of the recommendations by
   ;  World Wide Web Consortium (W3C) regarding simplified formats to
   ;  represent dates and times, as provided originally by the ISO 8601
   ;  standard. It relies on the IDL function SYSTIME to generate the
   ;  information (in IDL’s format) and reformats the result as described
   ;  below.
   ;
   ;  SYNTAX: res = today(FMT = fmt)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]: None.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   FMT = fmt {STRING} [I]: Set this optional keyword to iso, nice,
   ;      usa or ymd to generate the return value in a format different
   ;      from the default. If the value of this keyword is not set or
   ;      unrecognized, the result will be formatted according to the
   ;      default format.
   ;
   ;  RETURNED VALUE TYPE: STRING.
   ;
   ;  OUTCOME:
   ;
   ;  *   This function returns today’s date to the calling routine in one
   ;      of the following formats:
   ;
   ;      -   If the keyword FMT is NOT set (default), or unrecognized,
   ;          the current date and time are provided as a string formatted
   ;          like YYYY-MM-DD_hh:mm:ss.
   ;
   ;      -   If the keyword FMT is set to iso, the current date and time
   ;          are provided as a string formatted like YYYY-MM-DDThh:mm:ss.
   ;
   ;      -   If the keyword FMT is set to nice, the current date and time
   ;          are provided as a string formatted like
   ;          YYYY-MM-DD at hh:mm:ss.
   ;
   ;      -   If the keyword FMT is set to usa, the current date is
   ;          provided as a string formatted like MM DD, YYYY.
   ;
   ;      -   If the keyword FMT is set to ymd, the current date is
   ;          provided as a string formatted like YYYY-MM-DD.
   ;
   ;  *   This routine does not provide diagnostic information on
   ;      exception conditions.
   ;
   ;  EXCEPTION CONDITIONS: None.
   ;
   ;  DEPENDENCIES: None.
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The format option FMT can be specified in either upper
   ;      or lower (or even mixed) case.
   ;
   ;  *   NOTE 2: This routine does not (currently) attempt to report on
   ;      the time zone.
   ;
   ;  *   NOTE 3: The output formats nice and usa may be less desirable
   ;      for use in filenames because of the presence of blank
   ;      characters.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = today()
   ;      IDL> PRINT, res
   ;      2017-03-09_20-56-45
   ;
   ;      IDL> res = today(FMT = 'nice')
   ;      IDL> PRINT, res
   ;      2017-03-09 at 20:57:14
   ;
   ;      IDL> res = today(FMT = 'ymd')
   ;      IDL> PRINT, res
   ;      2017-03-09
   ;
   ;  REFERENCES:
   ;
   ;  *   Web page: https://www.w3.org/TR/NOTE-datetime.
   ;
   ;  VERSIONING:
   ;
   ;  *   2017–07–05: Version 0.9 — Initial release.
   ;
   ;  *   2017–11–20: Version 1.0 — Initial public release.
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
   ;  Initialize the return code and the error message:
   ;  Get the current system date and time:
   result = SYSTIME()

   ;  Parse this string:
   sres = STRSPLIT(result, ' ', /EXTRACT)

   ;  Save the current year:
   yyyy = sres[4]

   ;  Save the current month:
   sm = sres[1]
   CASE sm OF
      'Jan': mm = '01'
      'Feb': mm = '02'
      'Mar': mm = '03'
      'Apr': mm = '04'
      'May': mm = '05'
      'Jun': mm = '06'
      'Jul': mm = '07'
      'Aug': mm = '08'
      'Sep': mm = '09'
      'Oct': mm = '10'
      'Nov': mm = '11'
      'Dec': mm = '12'
   ENDCASE

   ;  Save the current day:
   dd = sres[2]
   ddn = FIX(dd)
   IF (ddn LT 10) THEN dd = STRTRIM(STRING(ddn, FORMAT = '(I02)'), 2)

   ;  Save the hours, minutes and seconds:
   hms = STRSPLIT(sres[3], ':', /EXTRACT)
   hor = hms[0]
   min = hms[1]
   sec = hms[2]

   ;  Default format:
   ymdhms = yyyy + '-' + mm + '-' + dd + '_' + hor + '-' + min + '-' + sec

   ;  Reset the outcome if the optional keyword FMT has been set:
   IF (KEYWORD_SET(fmt)) THEN BEGIN
      fmt = STRLOWCASE(fmt)
      CASE fmt OF
         'iso': ymdhms = yyyy + '-' + mm + '-' + dd + 'T' + sres[3]
         'nice': ymdhms = yyyy + '-' + mm + '-' + dd + ' at ' + sres[3]
         'usa': ymdhms = mm + ' ' + dd + ', ' + yyyy
         'ymd': ymdhms = yyyy + '-' + mm + '-' + dd
         ELSE: BEGIN
            ymdhms = yyyy + '-' + mm + '-' + dd + '_' + $
               hor + '-' + min + '-' + sec
         END
      ENDCASE
   ENDIF

   RETURN, ymdhms

END
