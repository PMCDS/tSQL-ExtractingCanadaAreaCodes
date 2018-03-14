# tSQL-ExtractingCanadaAreaCodes
This tSQL script extracts Canadian area codes from string (recursive)

This function looks recursively for the 1st correct Canada Area Code withing a string and
returns it in the varchar(7) fomat or 'n/a' if not found. Works for both formats 
'CA 90405' and 'CA90405'. The recursion ensures that if the Area Code pattern is found 
but it is not a valid Area Code (it could be just a string section coincidentaly formatted as 
Area Code) it moves to another pattern match.

The number of recursions allowed per one string search can be set by the 2nd parameter to
prevent infinite looping in some strange cases. Max recursuon value is 32 - SQL default.
      
Sample test:

(Create the dbo.udfGetZipCodeFromString first before running the test!)

DECLARE @addressString AS nVARCHAR(1000)
SET @addressString = 'Lorem ipsum dolor sit amet, consectetur V9Z0V1 adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate CA 904O6 velit esse cillum dolore eu fugiat nulla pariatur. V9Z 0V2 Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';

SELECT dbo.udfGetCanAreaCodeFromString(1, 15, 1, @addressString);
