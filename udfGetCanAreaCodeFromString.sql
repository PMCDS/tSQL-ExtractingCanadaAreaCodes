/*******************************************************************************
** File:	  udfGetCanAreaCodeFromString.sql 
**
** Name:	  udfGetCanAreaCodeFromString
**
** Target:  SQL Server 2012+
**
** Desc:	  This function looks recursively for the 1st correct Canada Area Code withing a string and
		  returns it in the varchar(7) fomat or 'n/a' if not found. Works for both formats 
		  'CA 90405' and 'CA90405'. The recursion ensures that if the Area Code pattern is found 
		  but it is not a valid Area Code (it could be just a string section coincidentaly formatted as 
		  Area Code) it moves to another pattern match.

		  The number of recursions allowed per one string search can be set by the 2nd parameter to
		  prevent infinite looping in some strange cases. Max recursuon value is 32 - SQL default.
**
** Auth:	  Copyleft, Milan Polak (2017 - 2018)
** Ref:	  (https://www.copyleft.org/)
**
** Sample Usage: Select Area Code from a string with maximum recursion set to 15
**    
**				SELECT dbo.udfGetCanAreaCodeFromString(1, 15, 1, @addressString)
**
** Change History:
**
** Version	 Date		  Author	    Description 
** -------	 --------		  -------	    ------------------------------------
** 1.000		 2018-03-01      Mpo	    Initial Version
**
*********************************************************************************/

CREATE FUNCTION udfGetCanAreaCodeFromString(@rec INT, @maxRec INT, @offset INT, @addressString nVARCHAR(max))
RETURNS VARCHAR(7)  
WITH EXECUTE AS CALLER  
AS  
BEGIN

    DECLARE @zip AS VARCHAR(8)  = 'n/a';
    DECLARE @addressStringTr AS nVARCHAR(max) = REPLACE(SUBSTRING(@addressString, @offset, 40000), ' ', '');

    -- Filter on valid Zip nums & valid Zip aplha-codes.
    -- Mutual check for both formts 'V9Z 0V1' and 'V9Z0V1'
    IF SUBSTRING(@addressStringTr, PATINDEX('%[a-zA-Z][0-9][a-zA-Z][0-9][a-zA-Z][0-9]%', @addressStringTr),2) IN(
	   'A0','A1','A2','A5','A8','B0','B1','B2','B3','B4','B5','B6','B9','E1','E2','E3','E4',
	   'E5','E6','E7','E8','E9','G0','G1','G2','G3','G4','G5','G6','G7','G8','G9','H0','H1',
	   'H2','H3','H4','H5','H7','H8','H9','J0','J1','J2','J3','J4','J5','J6','J7','J8','J9',
	   'K0','K1','K2','K4','K6','K7','K8','K9','L0','L1','L2','L3','L4','L5','L6','L7','L8',
	   'L9','M1','M2','M3','M4','M5','M6','M7','M8','M9','N0','N1','N2','N3','N4','N5','N6',
	   'N7','N8','N9','P0','P1','P2','P3','P4','P5','P6','P7','P8','P9','R0','R1','R2','R3',
	   'R4','R5','R6','R7','R8','R9','S0','S2','S3','S4','S6','S7','S9','T0','T1','T2','T3',
	   'T4','T5','T6','T7','T8','T9','V0','V1','V2','V3','V4','V5','V6','V7','V8','V9','X0',
	   'X1','Y0','Y1')
    BEGIN
	  SELECT @zip = IIF(PATINDEX('%[a-zA-Z][0-9][a-zA-Z][0-9][a-zA-Z][0-9]%', @addressStringTr) > 0, 
					   STUFF(SUBSTRING(@addressStringTr, PATINDEX('%[a-zA-Z][0-9][a-zA-Z][0-9][a-zA-Z][0-9]%', 
					   @addressStringTr), 6), 4, 0, ' '), 'n/a');
    END
    ELSE
    BEGIN
	   SET @offset = @offset + PATINDEX('%[0-9][0-9][0-9][0-9][0-9]%', @addressStringTr);
	    
	   IF @maxRec > @rec
	   BEGIN
		  SELECT @zip = dbo.udfGetZipCodeFromString(@rec + 1, @maxRec, @offset, @addressStringTr)
	   END

    END

	   RETURN(@zip); 
END;