FUNCTION today, $
   FMT = fmt

   ;Sec-Doc
   ;  PURPOSE: This function returns today’s date and time as a string in
   ;  one of the following formats, specified by the optional input
   ;  keyword parameter FMT: default (keyword FMT not set or
   ;  unrecognized), iso, jul, julian, nice, usa, ymd or dmy.
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
   ;  *   FMT = fmt {STRING} [I]: Set this optional keyword to iso, jul,
   ;      julian, nice, usa, ymd or dmy to generate the return value in a
   ;      format different from the default. If the value of this keyword
   ;      is not set or unrecognized, the result will be formatted
   ;      according to the default format.
   ;
   ;  RETURNED VALUE TYPE: STRING.
   ;
   ;  OUTCOME:
   ;
   ;  *   This function returns today’s date to the calling routine in one
   ;      of the following formats:
   ;
   ;      -   If the keyword FMT is NOT set (default), or is unrecognized,
   ;          the current date and time are provided as a string formatted
   ;          like YYYY-MM-DD_hh:mm:ss.
   ;
   ;      -   If the keyword FMT is set to iso, the current date and time
   ;          are provided as a string formatted like
   ;          YYYY-MM-DDThh:mm:ssZ.
   ;
   ;      -   If the keyword FMT is set to jul, the current date is
   ;          provided as the current Julian day number, i.e., a STRING
   ;          representation of a LONG integer.
   ;
   ;      -   If the keyword FMT is set to julian, the current date and
   ;          time are provided as the current Julian day number and time,
   ;          i.e., a STRING representation of a DOUBLE floating point
   ;          number.
   ;
   ;      -   If the keyword FMT is set to nice, the current date and time
   ;          are provided as a string formatted like
   ;          YYYY-MM-DD at hh:mm:ss.
   ;
   ;      -   If the keyword FMT is set to usa, the current date is
   ;          provided as a string formatted like Mo DD, YYYY, where Mon
   ;          is a 3-character string abreviation of the month name.
   ;
   ;      -   If the keyword FMT is set to ymd, the current date is
   ;          provided as a string formatted like YYYY-MM-DD.
   ;
   ;      -   If the keyword FMT is set to dmy, the current date is
   ;          provided as a string formatted like DD Month YYYY, where
   ;          Month is the month name, spelled out in full.
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
   ;  *   2018–01–15: Version 1.1 — Implement optional debugging.
   ;
   ;  *   2019–01–04: Version 1.2 — Add the optional output formats jul
   ;      and julday.
   ;
   ;  *   2019–01–28: Version 2.00 — Systematic update of all routines to
   ;      implement stricter coding standards and improve documentation.
   ;
   ;  *   2019–08–20: Version 2.1.0 — Adopt revised coding and
   ;      documentation standards (in particular regarding the assignment
   ;      of numeric return codes), and switch to 3-parts version
   ;      identifiers.
   ;
   ;  *   2020–01–27: Version 2.1.1 — Add the optional keyword value dmy
   ;      and update the documentation.
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

   ;  Get the current system date and time:
   result = SYSTIME()

   ;  Parse this string:
   sres = STRSPLIT(result, ' ', /EXTRACT)

   ;  Save the current year:
   yyyy = sres[4]

   ;  Save the current month number and name:
   sm = sres[1]
   CASE sm OF
      'Jan': BEGIN
         mm = '01'
         month = 'January'
      END
      'Feb': BEGIN
         mm = '02'
         month = 'February'
      END
      'Mar': BEGIN
         mm = '03'
         month = 'March'
      END
      'Apr': BEGIN
         mm = '04'
         month = 'April'
      END
      'May': BEGIN
         mm = '05'
         month = 'May'
      END
      'Jun': BEGIN
         mm = '06'
         month = 'June'
      END
      'Jul': BEGIN
         mm = '07'
         month = 'July'
      END
      'Aug': BEGIN
         mm = '08'
         month = 'August'
      END
      'Sep': BEGIN
         mm = '09'
         month = 'September'
      END
      'Oct': BEGIN
         mm = '10'
         month = 'October'
      END
      'Nov': BEGIN
         mm = '11'
         month = 'November'
      END
      'Dec': BEGIN
         mm = '12'
         month = 'December'
      END
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
         'iso': ymdhms = yyyy + '-' + mm + '-' + dd + 'T' + sres[3] + 'Z'
         'jul': ymdhms = STRING(JULDAY(mm, dd, yyyy))
         'julian': ymdhms = STRING(JULDAY(mm, dd, yyyy, hor, min, sec), $
            FORMAT='(D15.6)')
         'nice': ymdhms = yyyy + '-' + mm + '-' + dd + ' at ' + sres[3]
         'usa': ymdhms = sres[1] + ' ' + dd + ', ' + yyyy
         'ymd': ymdhms = yyyy + '-' + mm + '-' + dd
         'dmy': ymdhms = dd + ' ' + month + ' ' + yyyy
         ELSE: BEGIN
            ymdhms = yyyy + '-' + mm + '-' + dd + '_' + $
               hor + '-' + min + '-' + sec
         END
      ENDCASE
   ENDIF

   RETURN, ymdhms

END
