FUNCTION get_host_info, os_name, comp_name

   ;Sec-Doc
   ;  PURPOSE: This function reports on the names of the operating system
   ;  and the computer on which it is running.
   ;
   ;  ALGORITHM: This function relies on the IDL !VERSION internal
   ;  variable and on either the hostname command (on computers running
   ;  under Linux or Mac), or the environmental variable COMPUTERNAME (on
   ;  computers running under MS Windows) to define the value of the
   ;  output arguments.
   ;
   ;  SYNTAX: rc = get_host_info(os_name, comp_name)
   ;
   ;  POSITIONAL PARAMETERS [INPUT/OUTPUT]:
   ;
   ;  *   os_name {STRING} [O]: The name of the underlying operating
   ;      system; under IDL Version 8.7, this output positional parameter
   ;      is either linux, or darwin, or Win32.
   ;
   ;  *   comp_name {STRING} [O]: The name of the computer executing this
   ;      routine.
   ;
   ;  KEYWORD PARAMETERS [INPUT/OUTPUT]: None.
   ;
   ;  RETURNED VALUE TYPE: INTEGER.
   ;
   ;  OUTCOME:
   ;
   ;  *   This function does not accept any input argument and does not
   ;      perform any testing for exception conditions. If the operating
   ;      system is recognized _and_ a non-trivial computer name is
   ;      retrieved, this function returns 0 and the output positional
   ;      parameters contain these names.
   ;
   ;  *   If the operating system is not recognized _or_ if a non-trivial
   ;      computer name cannot be retrieved, this function stops the
   ;      processing and returns control to IDL.
   ;
   ;  EXCEPTION CONDITIONS: None.
   ;
   ;  DEPENDENCIES:
   ;
   ;  *   strstr.pro
   ;
   ;  REMARKS:
   ;
   ;  *   NOTE 1: The logic implemented in this function may need to be
   ;      updated either if one of the operating systems changes its
   ;      naming convention, or more or different operating systems should
   ;      be considered, or the mechanism to retrieve the name of the
   ;      computer changes.
   ;
   ;  *   NOTE 2: On computers running under the Microsoft Windows family
   ;      of operating systems, the user should verify that the
   ;      environment variable COMPUTERNAME exists.
   ;
   ;  EXAMPLES:
   ;
   ;      IDL> res = get_host_info(os_name, comp_name)
   ;      IDL> PRINT, 'os_name = ', os_name
   ;      os_name = darwin
   ;      IDL> PRINT, 'comp_name = ', comp_name
   ;      comp_name = MicMac2
   ;
   ;  REFERENCES: None.
   ;
   ;  VERSIONING:
   ;
   ;  *   2018–07–03: Version 0.9 — Initial release.
   ;
   ;  *   2018–07–05: Version 1.0 — Initial public release.
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

;  ==========================
;  [Code section 0: Error handling]
;  ==========================

   ;  Initialize the default return code:
   return_code = 1

   ;  Initialize the output positional parameter(s):
   os_name = ''
   comp_name = ''

   ;  Identify the current operating system:
   os_name = !VERSION.OS

   ;  Identify the computer:
   CASE os_name OF
      'linux': BEGIN
         SPAWN, 'hostname -s', computer
         comp_name = computer[0]
         return_code = 0
         END
      'darwin': BEGIN
         SPAWN, 'hostname -s', computer
         comp_name = computer[0]
         return_code = 0
         END
      'Win32': BEGIN
         comp_name = strstr(GETENV('COMPUTERNAME'))
         return_code = 0
         END
   ENDCASE

   ;  Stop the processing and return control to IDL if either the operating
   ;  system is not recognized or no computer name could be retrieved:
   IF ((os_name EQ '') OR (comp_name EQ '')) THEN $
      STOP, "get_host_info: Unrecognized OS or unretrieved computer name."

   RETURN, return_code

END
