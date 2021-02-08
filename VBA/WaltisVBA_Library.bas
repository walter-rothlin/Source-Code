Attribute VB_Name = "WaltisVBA_Library"
' ===================
' VBA excel functions
' ===================

' START---------------------------------------------------------------------
' Author:        Walter Rothlin
' Description: Common and helpfull VBA excel functions
'
' File Name: Module1 in formel.xls is original
'
' 28-Dec-2010    V1.0  Walter Rothlin       Initial Version
' 07-Jan-2011    V1.1  Walter Rothlin       Added Array and String functions
' 20-Feb-2011    V1.2  Walter Rothlin       Added Binar/Hex
'                                           Added some more Math (logarithmen)
'
' 08-Jun-2011    V1.3  Walter Rothlin       Added convertStringToCode
'                                                 replaceSpezCharFromString
'                                                 convertMinStrInStunden
'                                                 getPrevPrimzahl
'                                                 getDoubleQuote
'                                                 getAdrByAddingOffset
'
' 06-Sep-2011    V1.4  Walter Rothlin       Added getMonthNr
'                                                 getWeekdayNr
'                                                 getArrayIndex
'                                                 getLastWeekdayBeforeDate
'
' 26-Jun-2012    V1.5  Walter Rothlin       Added getFieldFromString
'                                                 strContains
'                                                 isInputRequired
'                                                 inputRequired
'                                           Added group  "Physical units calculations"
' 06-Jul-2012    V1.6  Walter Rothlin       Added roundDoubleAsString
' 10-Jul-2012    V1.7  Walter Rothlin       Added getMaxDaysForMonth
' 14-Jul-2012    V1.8  Walter Rothlin       Added truncDoubleAsString, Fixed issue with roundDoubleAsString
' 15-Jul-2012    V1.9  Walter Rothlin       Added formateSecondsToTimeStr, getDateMinusTime, getNextDate, addDaysToDate, getDatePlusTime
' 16-Jul-2012    V1.9  Walter Rothlin       Added findCellContent
' 19-Jul-2012    V1.10 Walter Rothlin       Added getIntegerFromString, IsIN, strContains, strAreEqual, findPatternPosition, phy_m__inch, phy_inch__m
' 23-Jul-2012    V1.10 Walter Rothlin       Added SheetExists
' 30-Jul-2012    V1.11 Walter Rothlin       Added WGS84 / CH1903 convertion functions
' 03-Aug-2012    V1.12 Walter Rothlin       Added Coord functions, Geradengleichung, compareDouble
' 17-Aug-2012    V1.13 Walter Rothlin       Added swissMap Basic-functions xol
'                                                 strToFile
' 31-Aug-2012    V1.14 Walter Rothlin       Added abc_trompete_xxxx, xol_addABC_KreisImKreis
' 03-Sep-2012    V1.15 Walter Rothlin       Added saveAsCsvFile
'                                           Improved Error handling for strToFile
'                                           Added Filefunctions
'                                               getFileName,getPathToFileName
' 04-Sep-2012    V1.16 Walter Rothlin       Fixed issue in strToFile
' 06-Sep-2012    V1.17 Walter Rothlin       Added strStarts, strEnds, SftpGet, SftpPut, readCsvFile, pause
' 30-Sep-2012    V1.18 Walter Rothlin       Added xol_addNavigationLine (added %o to the labels)
' 03-Oct-2012    V1.19 Walter Rothlin       Extended getFieldFromString
'                                           Added Labels to the points on the Trompete
' 04-Oct-2012    V1.20 Walter Rothlin       Modified xol_addABC_Trompete to take fill
' 13-Oct-2012    V1.21 Walter Rothlin       Modified findCellContent
'                                           Added LookUpWR, getFieldValue
' 23-Oct-2012    V1.22 Walter Rothlin       Added Refresh, formatGitterFct, insertRow
' 30-Oct-2012    V1.23 Walter Rothlin       Modified getCRLF, duplicateStr
'                                           Added getLF, concatenateRange, parseString, replaceSinglePlaceholder
' 02-Nov-2012    V1.24 Walter Rothlin       Modified getFieldValue (better names for parameters)
' 12-Nov-2012    V1.25 Walter Rothlin       Added LookUpAndReplacePlaceholders, getPlaceholderFromString, replaceStringInString
' 13-Nov-2012    V1.26 Walter Rothlin       Fixed findCellContent, xol_addABC_Trompete
' 14-Nov-2012    V1.27 Walter Rothlin       Fixed phy_Rad__grad
'                                           Added nowAsString
' 20-Nov-2012    V1.28 Walter Rothlin       Added getNextEmptyCellHorizontal, getNextEmptyCellVertical, splitStringByDelimiterStr
'                                                 whichSheetSelected,whichColumnSelected, whichRowSelected, whichCellSelected
' 22-Nov-2012    V1.29 Walter Rothlin       Added more ByVal to existing functions
' 27-Nov-2012    V1.30 Walter Rothlin       Added setSelectedRangeValues, getAdrFromSelectedRange, setCellColor
' 20-Dec-2012    V1.31 Walter Rothlin       Added ABC-Rechenscheiben formeln. ABC_SetDefaultForX
' 28-Dec-2012    V1.32 Walter Rothlin       Mod xol_addABC_Trompete, xol_addABC_KreisImKreis to handle flag string instead of boolean (language dependency)
' 08-Mar-2013    V1.31 Walter Rothlin       Added getSelectedFilenameFromDialog, copyRangeToTAB, getLowerRightAdr
' 11-Mar-2013    V1.32 Walter Rothlin       Added getLowColumnFromRange , getHighColumnFromRange
' 12-Mar-2013    V1.33 Walter Rothlin       Fixed getSelectedFilenameFromDialog
'                                           Added clearRange
' 22-Mar-2013    V1.34 Walter Rothlin       Fixed getSelectedFilenameFromDialog, readCsvFile
'                                           Added getTimeStampStr
' 23-Mar-2013    V1.35 Walter Rothlin       Changed all file function not to use #1
'                                           Added isFileA_UnixAsciiFile, ConvertASCII_File, CopyFile_WR
' 25-Mar-2013    V1.36 Walter Rothlin       Added lineCountInFile
' 13-Apr-2013    V1.37 Walter Rothlin       Added more Array functions walkTroughtTree and more
' 14-Apr-2013    V1.38 Walter Rothlin       Mod walkTroughtTree (added end-Points attributes with :
' 17-Apr-2013    V1.39 Walter Rothlin       Added isFileExists; Bug fix readCsvFile
' 19-Apr-2013    V1.40 Walter Rothlin       Fixed minor issues
'                                           Added MyName
' 27-May-2013    V1.41 Walter Rothlin       Added getCountOfWorksheets, getWorksheetName
'                                           Added Workbook operations
'                                           Added LoadExcelAndPutItIntoTAB
' 28-May-2013    V1.42 Walter Rothlin       Bug fixes
' 06-Jun-2013    V1.43 Walter Rothlin       Added getLibVersion, getNextFilledColumnRelative
' 09-Jun-2013    V1.44 Walter Rothlin       Added getPathInTree, isTreeEndPoint, setEingabeListForField, fixCellAddr
' 11-Jun-2013    V1.45 Walter Rothlin       Added getCountOfFieldsInString
' 14-Jun-2013    V1.46 Walter Rothlin       Added mkBorderRemoveAll, mkBorderSmallHorizontalOnly, mkBorderSmallJustAround
' 25-Jun-2013    V1.47 Walter Rothlin       Added getRangeIntoArray
' 01-Nov-2013    V1.48 Walter Rothlin       Added regEx functions
'                                                 isStringDecimal, .....
'                                                 getValueAsDouble (timestr, decimal, integer)
'                                                 isStringMatchesRegEx
' 22-Nov-2013    V1.49 Walter Rothlin       Added replaceStringInStringRegEx
'                                                 writeBulletListInCel
'                                                 fmtAsBulletList
'                                                 formatAsBulletList
' 07-Dec-2013    V1.50 Walter Rothlin       Added getPowerFacFromKiloMega
'                                                 getFactorFromPowerFac
'                                                 getFacFromKiloMega
'                                           Extendend getTimeDifferenceFromTimestamp
'                                           Added getDoubleFromKiloMega
'                                           Added Wechselstrom Function(elTec_.....)
' 15-Dec-2013    V1.51 Walter Rothlin       Added getEinheitFromKiloMega
'                                                 getFigureFromKiloMega
' 17-Dec-2013    V1.53 Walter Rothlin       Modified getTimeDifferenceFromTimestamp (RegEx)
' 24-Dec-2013    V1.54 Walter Rothlin       Add diskriminante, quadratischeGleichungSolution,elTec_RLC_Serie_Guete
' 25-Dec-2013    V1.55 Walter Rothlin       Bug-fixes
' 27-Dec-2013    V1.56 Walter Rothlin       Added convertDoubletoKiloMega
' 28-Dec-2013    V1.57 Walter Rothlin       Added daytime_RegEx
' 30-Dec-2013    V1.58 Walter Rothlin       Added getEinheitFromTitle
' 03-Jan-2014    V1.59 Walter Rothlin       Modified getDoubleFromKiloMega
' 25-Jan-2014    V1.60 Walter Rothlin       Added DeleteWorksheets
' 02-Feb-2014    V1.61 Walter Rothlin       Added Svenja's functions
'                                               RemoveFormatsFromWorksheet (RemoveFormats)
'                                               SaveWB
'                                               CloseWB
'                                               copyTable (TabelleKopieren)
'                                               MatrixToTable (MatrixZuTabelle)Public Function RADX(ByVal Grad As Double) As Double
' 10-Feb-2014    V1.62 Walter Rothlin       Added
'                                               WR_Math_ABS
'                                               WR_Math_Ops
'                                               WR_Math_Radx
'                                               rowCountFromRange
'                                               columnCountFromRange
'                                               moveRange
'                                               copyRangeTo
' 14-Feb-2014    V1.63 Walter Rothlin       Added
'                                               findColumnLetterFromHeader
' 17-Feb-2014    V1.64 Walter Rothlin       Modified parseString
' 20-Feb-2014    V1.65 Walter Rothlin       Added Email Function
' 24-Feb-2014    V1.66 Walter Rothlin       Bugfix Email Function
' 25-Feb-2014    V1.67 Walter Rothlin       Added   fullAnrede
'                                                   swapFieldsFromString
' 26-Feb-2014    V1.68 Walter Rothlin       Bugfix Email Function
' 27-Feb-2014    V1.69 Walter Rothlin       Added   truncString
' 07-Mar-2014    V1.70 Walter Rothlin       Added   getDoubleFromPhyVal
'                                                   convertDoubleToPhyVal
' 09-Mar-2014    V1.71 Walter Rothlin       Modified getDoubleFromKiloMeg,....to handle i.g. U1 =5kV (incl inc and dec fct)
' 15-Apr-2014    V1.72 Walter Rothlin       Added lin_a_aP1, lin_c_aP1
' 26-May-2014    V1.73 Walter Rothlin       Added more Gitter-Methoden
'                                               addGitterToRange
'                                               addBorderToRange
' 16_Jun-2014    V1.74 Walter Rothlin       Added Matrix-Functions and Test-Cases
' 27-Jul-2014    V1.75 Walter Rothlin       Added getWinkelFromCosinussatz
' 07-Aug-2014    V1.76 Walter Rothlin       Added getGegenseiteFromCosinussatz
'                                                 getAnseiteFromCosinussatz
'                                                 get_cFromAlfa_b_summeca_Intervallschachtelung
' 09-Aug-2014    V1.77 Walter Rothlin       Added vector_xxxx functions
' 03-Sep-2014    V1.78 Walter Rothlin       Changed roundDoubleAsString to work with Application.DecimalSeparator
' 05-Sep-2014    V1.79 Walter Rothlin       Added more vec functions
' 11-Sep-2014    V1.80 Walter Rothlin       Added ggT function
' 26-Sep-2014    V1.81 Walter Rothlin       Added more Einheiten-Umrechnungsformeln
' 02-Oct-2014    V1.82 Walter Rothlin       Added Kinematik_2
' 11-Oct-2014    V1.83 Walter Rothlin       Added vector_mulVector, vector_sub_vector, vector_divVector
' 19-Oct-2014    V1.84 Walter Rothlin       Added fieldType,fieldToDate,strToDate
' 02-Nov-2014    V1.85 Walter Rothlin       Added morevector (Skalarprodukt)
' 01-Feb-2015    V1.86 Walter Rothlin       Added signedFigure
' 11-Feb-2015    V1.87 Walter Rothlin       Added phyGetWinkelinRad,phyGetWinkelinGrad
' 26-Feb-2015    V1.88 Walter Rothlin       Added lin_render_P2x
' 03_Mar-2015    V1.89 Walter Rothlin       Added lin_render_P1x, lin_render_P1y, lin_render_P2x, lin_render_P2y
' 16-May-2015    V1.90 Walter Rothlin       Added isVector3D, vectorThird (3D-Vektor operation), vector_kreuzProduct
' 05-Aug-2015    V1.91 Walter Rothlin       Added poly-functions
' 18-Aug-2015    V1.92 Walter Rothlin       Added get2D_RangeIntoArray and Matrix- / Determinaten-Functions
' 09-Sep-2015    V1.93 Walter Rothlin       Bug-fixes in Vektor Functions
' 10-Sep-2015    V1.94 Walter Rothlin       Added Ganzzahlige-Reihen (Integer Series)
' 17-Sep-2015    V1.95 Walter Rothlin       Added removeLastFieldFromString, getLastFieldFromString, polyCleanPolyStr
' 18-Oct-2015    V1.96 Walter Rothlin       Added areAllFieldsEqualInString
' 31-Oct-2015    V1.97 Walter Rothlin       Added Vector adding simulation
' 22-Jan-2016    V1.98 Walter Rothlin       Added rechtwinkligesDreieick_a  (tba)
' 27-May-2016    V1.99 Walter Rothlin       Added True Air Speed
' 26-Oct-2016    V1.100 Walter Rothlin      Added cosinussatz formuals (e.g. getWinkelFromCosinussatz,...)
' 02-Nov-2016    V1.101 Walter Rothlin      Changed getWinkelFromCosinussatz,....
' 09-Dec-2016    V1.102 Walter Rothlin      Added getHunderstelSecondsFromTime
' 04-Feb-2017    V1.103 Walter Rothlin      Merged versions
' 21-Feb-2017    V1.104 Walter Rothlin      Added addTimeToTimestamp
' 20-Mar-2017    V1.105 Walter Rothlin      Added setFooterAndHeader, convertStringToDate, formatTelnr
' 29-Mar-2017    V1.106 Walter Rothlin      Added arrToString /  Changed getThisWorkbook, getActivatedWorkbook
' 08-Apr-2017    V1.107 Walter Rothlin      Added findY_Interpolation
' 04-May-2017    V1.108 Walter Rothlin      Changed MatrixToTable
' 05-May-2017    V1.109 Walter Rothlin      Added getWorkbook
' 04-Oct-2017    V1.110 Walter Rothlin      Added special holidays getholidayDate()
' 12-Oct-2017    V1.111 Walter Rothlin      Added GetBackgroundColorIndex, RefreshButton_Click
' 17-Nov-2017    V1.112 Walter Rothlin      Added getHolidayNameForDate()
' 07-Mar-2018    V1.113 Walter Rothlin      Bugfix elTec_XRLC_SeriePhi()
' 27-Jul-2018    V1.114 Walter Rothlin      Added Elektrotechnik Function
' 17-Sep-2018    V1.115 Walter Rothlin      Added concatenateStringWithSep, appendWithSepIfNotEmpty, powerTen, roundDoubleAsString, compressSeats, decompressSeats
' 18-Sep-2018    V1.116 Walter Rothlin      Added sortSeats
' 24-Sep-2018    V1.117 Walter Rothlin      Added removeFieldValueFromString
' 10-Nov-2018    V1.118 Walter Rothlin      Added convertASCII_to_HEX, convertHEX_to_ASCII
' 04-Oct-2019    V1.119 Walter Rothlin      Added function to calculate Hamming-Code
' 15-Dec-2019    V1.120 Walter Rothlin      Added function CreateCalendarEntry
' 06-Jan-2020    V1.121 Walter Rothlin      Changed CHtoWGS_Latitude, CHtoWGS_Longitude, CHtoWGS_High to handle new CH coordinates (LV95)
' 06-Feb-2020    V1.122 Walter Rothlin      Changed WGS84 / CH1903 Functions (LV95)
' 09-Feb-2020    V1.123 Walter Rothlin      Added getWorksheets, ftpFilesFct
' 02-Aug-2020    V1.124 Walter Rothlin      Added selectFromTable
' 03-Sep-2020    V1.125 Walter Rothlin      Added istPrimzahl
' 28-Sep-2020    V1.126 Walter Rothlin      Added equalsWithinTolerance, MyProper
' 07-Oct-2020    V1.127 Walter Rothlin      Added tojson
' 05-Jan-2021    V1.128 Walter Rothlin      Added convert_AsciiToUnicode
' 08-Feb-2021    V1.129 Walter Rothlin      Added Moodle Questions generator
' 08-Feb-2021    V1.130 Walter Rothlin      Added Bruch functions
' END-----------------------------------------------------------------------

Dim PrimMaxColums

Public Const Version_WaltisVBA_Library As String = "V1.129"

Public Const Pi As Double = 3.14159265358979
Public Const e  As Double = 2.71828182845905
Public Const cstrSftp As String = """C:\Program Files (x86)\Putty\pscp.exe"""

' regular expressions
Public Const email_RegEx As String = "(\w+\.)+(\w+@)(\w|-|\.)+"

Public Const integerPosive_RegEx As String = "\d+"
Public Const integer_RegEx As String = "(-)?\d+"

Public Const floatPosPoint_RegEx As String = "\d+(\.\d+)?"
Public Const floatPoint_RegEx As String = "(-)?\d+(\.\d+)?"

Public Const floatPointExponent_RegEx As String = "(-)?\d+(\.\d+)?(E(-)?\d+)?"

Public Const floatPosComma_RegEx As String = "\d+(,\d+)?"
Public Const floatComma_RegEx As String = "(-)?\d+(,\d+)?"

Public Const floatPos_RegEx As String = "\d+((\.|,)\d+)?"
Public Const float_RegEx As String = "(-)?\d+((\.|,)\d+)?"

Public Const cifNoFormated_RegEx As String = "(\d){4}-(\d){7}-\d"
Public Const cifNo_RegEx As String = "(\d){4}(-)?(\d){7}(-)?\d"

Public Const datum_RegEx As String = "(\d{4}|[0-2][0-9]|3[01])([-/.])((0[1-9]|1[012])|([0-2][0-9]|3[01]))([-/.])((\d{4})|(0[1-9]|1[012])|([0-2][0-9]|3[01]))"
Public Const time_RegEx As String = "(([0-2][0-9]:)?[0-5]?[0-9]:[0-5][0-9](\.[0-9]+)?)"
Public Const daytime_RegEx As String = "([01]?[0-9]|2[0-3]):[0-5][0-9](:[0-5][0-9](.[\d]+)?)?"

' Public Const einheitInTitle_RegEx As String = "\[\s?\w+\s?\]"
Public Const einheitInTitle_RegEx As String = "\[\s?.+\s?\]"

Public Const aGanzeZahl_RegEx As String = "\d+"
Public Const aBruch_RegEx As String = "([0-9]+/[0-9]+)"
Public Const aGemischterBruch_RegEx As String = "(\d+ [0-9]+/[0-9]+)"

' Constants
' ======================================================
Public Function getLibVersion()
    getLibVersion = Version_WaltisVBA_Library
End Function

Public Function getDoubleQuote()
   getDoubleQuote = Chr(34)
End Function

Public Function getCRLF(Optional countOfRepeats As Integer = 1, Optional aCR_LF As Boolean = True)
   Dim retStr As String
   Dim i As Integer
   Dim aStr As String
   
      If (countOfRepeats <= 0) Then
        retStr = ""
   Else
        If (aCR_LF) Then
             aStr = Chr(10) & Chr(13)
        Else
             aStr = Chr(10)
        End If
        retStr = ""
        For i = 1 To countOfRepeats
             retStr = retStr + aStr
        Next i
   End If
   getCRLF = retStr
End Function

Public Function getLF(Optional ByVal countOfLF = 1) As String
   Dim retStr As String
   Dim i As Integer
   
   If (countOfLF <= 0) Then
        retStr = ""
   Else
        retStr = ""
        For i = 1 To countOfLF
           retStr = retStr & Chr(10)
        Next i
   End If
   getLF = retStr
End Function



' Trigonometrie
' ======================================================
 Function ArcSin(x As Double) As Double
    ArcSin = Atn(x / Sqr(-x * x + 1))
End Function

Function ArcCos(x As Double) As Double
    ArcCos = Atn(-x / Sqr(-x * x + 1)) + 2 * Atn(1)
End Function


' Physical units calculations
' ======================================================

'Winkelmasse
'-----------
Public Function phy_artpromil__grad(ByVal ArtPromil As Double) As Double
    phy_artpromil__grad = 360 * ArtPromil / 6400
End Function

Public Function phy_grad__artpromil(ByVal Grad As Double) As Double
    phy_grad__artpromil = 6400 * Grad / 360
End Function

Public Function phy_grad__Rad(ByVal Grad As Double) As Double
    phy_grad__Rad = Grad * Pi / 180
End Function

Public Function phy_Rad__grad(ByVal Rad As Double) As Double
    phy_Rad__grad = Rad / Pi * 180
End Function

Public Function phy_Rad__NoSign(ByVal Rad As Double) As Double
    If (Rad < 0) Then
        phy_Rad__NoSign = 2 * Pi + Rad
    Else
        phy_Rad__NoSign = Rad
    End If
End Function

Public Function phy_grad__NoSign(ByVal Grad As Double) As Double
    If (Rad < 0) Then
        phy_grad__NoSign = 360 + Grad
    Else
        phy_grad__NoSign = Grad
    End If
End Function

Public Function phyIsGrad(ByVal aStr As String) As Boolean
    Dim einheit As String
    einheit = RTrim(LTrim(UCase(getEinheitFromKiloMega(aStr))))
    If ((einheit = "GRAD") Or (einheit = "DEG") Or (einheit = "°")) Then
        phyIsGrad = True
    Else
        phyIsGrad = False
    End If
End Function

Public Function phyIsRad(ByVal aStr As String) As Boolean
    Dim einheit As String
    einheit = RTrim(LTrim(UCase(getEinheitFromKiloMega(aStr))))
    If (einheit = "RAD") Then
        phyIsRad = True
    Else
        phyIsRad = False
    End If
End Function

Public Function phyIsWinkelEinheit(ByVal aStr As String) As Boolean
    If ((phyIsGrad(aStr) = True) Or (phyIsRad(aStr) = True)) Then
        phyIsWinkelEinheit = True
    Else
        phyIsWinkelEinheit = False
    End If
End Function

' °, Deg, Grad => GRAD     rest is rad
Public Function phy_toRad_Always(ByVal aWinkelStr As String) As Double
  Dim zVal As Double
  Dim einheit As String
  
  zVal = getStringsForRegEx(aWinkelStr, float_RegEx)
  einheit = RTrim(LTrim(UCase(replaceStringInStringRegEx(aWinkelStr, float_RegEx, ""))))
  
  If (phyIsGrad(einheit)) Then
    phy_toRad_Always = phy_grad__Rad(zVal)
  Else
    phy_toRad_Always = zVal
  End If
End Function

' °, Deg, Grad => GRAD     rest is rad
Public Function phy_toGrad_Always(ByVal aWinkelStr As String) As Double
  Dim zVal As Double
  Dim einheit As String
  
  zVal = getStringsForRegEx(aWinkelStr, float_RegEx)
  einheit = RTrim(LTrim(UCase(replaceStringInStringRegEx(aWinkelStr, float_RegEx, ""))))
  
  If (phyIsGrad(einheit)) Then
    phy_toGrad_Always = zVal
  Else
    phy_toGrad_Always = phy_Rad__grad(zVal)
  End If
End Function

Public Function WR_Math_Radx(ByVal angle As Double, Optional ByVal einheit As String = "GRAD") As Double
    If (left(UCase(einheit), 1) = "G") Then
        WR_Math_Radx = angle * Pi / 180
    Else
        WR_Math_Radx = angle
    End If
End Function

Public Function getWinkelFromSinussatz(ByVal a As Double, _
                                       ByVal alpha As Double, _
                                       ByVal b As Double, _
                                       Optional ByVal einheit As String = "GRAD", _
                                       Optional ByVal kommastellen As Integer = -1) As String
    Dim beta As Double
    
    einheit = RTrim(LTrim(UCase(einheit)))
    If (phyIsGrad(einheit)) Then
        alpha = phy_grad__Rad(alpha)
    End If
    beta = ArcSin(b * (Sin(alpha) / a))
    If (phyIsGrad(einheit)) Then
        beta = phy_Rad__grad(beta)
    End If
    If (kommastellen > 0) Then
        getWinkelFromSinussatz = roundDoubleAsString(beta, kommastellen)
    Else
        getWinkelFromSinussatz = beta
    End If
End Function
                                         
Public Function getSeiteFromSinussatz(ByVal a As Double, _
                                      ByVal alpha As Double, _
                                      ByVal beta As Double, _
                                      Optional ByVal einheit As String = "GRAD", _
                                      Optional ByVal kommastellen As Integer = -1) As String
    Dim b As Double
    
    einheit = RTrim(LTrim(UCase(einheit)))
    If (phyIsGrad(einheit)) Then
        alpha = phy_grad__Rad(alpha)
        beta = phy_grad__Rad(beta)
    End If
    b = Sin(beta) * (a / Sin(alpha))

    If (kommastellen > 0) Then
        getSeiteFromSinussatz = roundDoubleAsString(b, kommastellen)
    Else
        getSeiteFromSinussatz = b
    End If
End Function

Public Function getThirdWinkel(ByVal winkelA As String, _
                               ByVal winkelB As String) As String
                               
     winkelA = rmStrInStr_1(winkelA, "=")
     winkelB = rmStrInStr_1(winkelB, "=")
     If (((winkelA = "ALFA") And (winkelB = "BETA")) Or ((winkelB = "ALFA") And (winkelA = "BETA"))) Then
        getThirdWinkel = "GAMMA"
     ElseIf (((winkelA = "ALFA") And (winkelB = "GAMMA")) Or ((winkelB = "ALFA") And (winkelA = "GAMMA"))) Then
        getThirdWinkel = "BETA"
     ElseIf (((winkelA = "BETA") And (winkelB = "GAMMA")) Or ((winkelB = "BETA") And (winkelA = "GAMMA"))) Then
        getThirdWinkel = "ALFA"
     End If
End Function


Public Function getWinkelFromCosinussatz(ByVal a As Double, _
                                         ByVal b As Double, _
                                         ByVal c As Double, _
                                         Optional ByVal gesuchterWinkel As String = "ALFA", _
                                         Optional ByVal einheit As String = "GRAD", _
                                         Optional ByVal fehlerWert As String = "Kein Dreieck möglich", _
                                         Optional ByVal kommastellen As Integer = -1) As String
    Dim cosinusWinkel As Double
    Dim winkel As Double
    
    gesuchterWinkel = RTrim(LTrim(UCase(gesuchterWinkel)))
    einheit = RTrim(LTrim(UCase(einheit)))
    
    If (gesuchterWinkel = "ALFA") Then
        cosinusWinkel = (b ^ 2 + c ^ 2 - a ^ 2) / (2 * b * c)
    ElseIf (gesuchterWinkel = "BETA") Then
        cosinusWinkel = (a ^ 2 + c ^ 2 - b ^ 2) / (2 * a * c)
    ElseIf (gesuchterWinkel = "GAMMA") Then
        cosinusWinkel = (a ^ 2 + b ^ 2 - c ^ 2) / (2 * a * b)
    End If
    
    If (Abs(cosinusWinkel) > 1) Then
        getWinkelFromCosinussatz = fehlerWert
    Else
        winkel = ArcCos(cosinusWinkel)
        If (phyIsGrad(einheit)) Then
            If (kommastellen > 0) Then
                getWinkelFromCosinussatz = roundDoubleAsString(phy_Rad__grad(winkel), kommastellen)
            Else
                getWinkelFromCosinussatz = phy_Rad__grad(winkel)
            End If
        Else
            getWinkelFromCosinussatz = roundDoubleAsString(winkel, kommastellen)
        End If
    End If
End Function


Public Function getGegenseiteFromCosinussatz(ByVal a As Double, _
                                             ByVal b As Double, _
                                             ByVal gamma As Double, _
                                             Optional ByVal einheit As String = "GRAD", _
                                             Optional ByVal fehlerWert As String = "Kein Dreieck möglich", _
                                             Optional ByVal kommastellen As Integer = -1) As String
    
    Dim wurzelAusdruck As Double
    
    einheit = RTrim(LTrim(UCase(einheit)))
    If (phyIsGrad(einheit)) Then
        gamma = phy_grad__Rad(gamma)
    End If
    
    wurzelAusdruck = a ^ 2 + b ^ 2 - 2 * a * b * Cos(gamma)
    
    If (wurzelAusdruck <= 0) Then
        getGegenseiteFromCosinussatz = fehlerWert
    Else
        If (kommastellen > 0) Then
            getGegenseiteFromCosinussatz = roundDoubleAsString(wurzelAusdruck ^ (1 / 2), kommastellen)
        Else
            getGegenseiteFromCosinussatz = wurzelAusdruck ^ (1 / 2)
        End If
    End If
End Function

Public Function getAnseiteFromCosinussatz_1(ByVal a As Double, _
                                            ByVal b As Double, _
                                            ByVal alfa As Double, _
                                            Optional ByVal einheit As String = "GRAD", _
                                            Optional ByVal fehlerWert As String = "Kein Dreieck möglich", _
                                            Optional ByVal kommastellen As Integer = -1) As String
    
    Dim qa As Double
    Dim qb As Double
    Dim qc As Double
    Dim diskr As Double
    
    
    einheit = RTrim(LTrim(UCase(einheit)))
    If (phyIsGrad(einheit)) Then
        alfa = phy_grad__Rad(alfa)
    End If
    
    qa = 1
    qb = -2 * b * Cos(alfa)
    qc = b ^ 2 - a ^ 2
    diskr = diskriminante(qa, qb, qc)
    
    
    If (diskr < 0) Then
        getAnseiteFromCosinussatz_1 = fehlerWert
    Else
        If (kommastellen > 0) Then
            getAnseiteFromCosinussatz_1 = roundDoubleAsString(quadratischeGleichungSolution(qa, qb, qc, True), kommastellen)
        Else
            getAnseiteFromCosinussatz_1 = quadratischeGleichungSolution(qa, qb, qc, True)
        End If
    End If
End Function

Public Function getAnseiteFromCosinussatz_2(ByVal a As Double, _
                                            ByVal b As Double, _
                                            ByVal alfa As Double, _
                                            Optional ByVal einheit As String = "GRAD", _
                                            Optional ByVal fehlerWert As String = "Kein Dreieck möglich", _
                                            Optional ByVal kommastellen As Integer = -1) As String
    
    Dim qa As Double
    Dim qb As Double
    Dim qc As Double
    Dim diskr As Double
    
    
    einheit = RTrim(LTrim(UCase(einheit)))
    If (phyIsGrad(einheit)) Then
        alfa = phy_grad__Rad(alfa)
    End If
    
    qa = 1
    qb = -2 * b * Cos(alfa)
    qc = b ^ 2 - a ^ 2
    diskr = diskriminante(qa, qb, qc)
    
    
    If (diskr < 0) Then
        getAnseiteFromCosinussatz_2 = fehlerWert
    Else
        If (kommastellen > 0) Then
            getAnseiteFromCosinussatz_2 = roundDoubleAsString(quadratischeGleichungSolution(qa, qb, qc, False), kommastellen)
        Else
            getAnseiteFromCosinussatz_2 = quadratischeGleichungSolution(qa, qb, qc, False)
        End If
    End If
End Function

' Berechnung der minimalen Talseillänge bevor Bergseil schlaff wird
Public Function get_cFromAlfa_b_summeca_Intervallschachtelung( _
                                            ByVal alfa As Double, _
                                            ByVal b As Double, _
                                            ByVal summeca As Double, _
                                            Optional ByVal einheit As String = "GRAD", _
                                            Optional ByVal genauigkeit As Double = 0.01, _
                                            Optional ByVal kommastellen As Integer = -1) As String
    
    Dim fctValUnten As Double
    Dim fctValMitte As Double
    Dim fctValOben As Double
    Dim cTestenUnten As Double
    Dim cTestenMitte As Double
    Dim cTestenOben As Double
    Dim cTesten As Double
    Dim aTesten As Double
    Dim fertig As Boolean
    Dim retVal As String
    
    fertig = False
    
    einheit = RTrim(LTrim(UCase(einheit)))
    If (phyIsGrad(einheit)) Then
        alfa = phy_grad__Rad(alfa)
    End If
    
    cTestenOben = summeca
    cTestenUnten = 0
    
    Do While (fertig = False)
        aTesten = summeca - cTestenOben
        fctValOben = b ^ 2 + cTestenOben ^ 2 - aTesten ^ 2 - 2 * b * cTestenOben * Cos(alfa)
        
        aTesten = summeca - cTestenUnten
        fctValUnten = b ^ 2 + cTestenUnten ^ 2 - aTesten ^ 2 - 2 * b * cTestenUnten * Cos(alfa)
        
        If (((fctValUnten > 0) And (fctVaOben > 0)) Or ((fctValUnten < 0) And (fctVaOben < 0))) Then
            fertig = True
            retVal = "Keine Lösung möglich"
        End If
        cTestenMitte = (cTestenOben + cTestenUnten) / 2
        aTesten = summeca - cTestenMitte
        fctValMitte = b ^ 2 + cTestenMitte ^ 2 - aTesten ^ 2 - 2 * b * cTestenMitte * Cos(alfa)
        
        If (Abs(fctValMitte) <= genauigkeit) Then
            fertig = True
            retVal = cTestenMitte
        Else
            If ((fctValUnten / fctValMitte) > 0) Then
                cTestenUnten = cTestenMitte
            Else
                cTestenOben = cTestenMitte
            End If
        End If
    Loop
    If (kommastellen > 0) Then
        get_cFromAlfa_b_summeca_Intervallschachtelung = roundDoubleAsString(retVal, kommastellen)
    Else
        get_cFromAlfa_b_summeca_Intervallschachtelung = retVal
    End If
End Function


'Geschwindigkeiten
'-----------------
Public Function phy_kmh__ms(ByVal kmProStunde As Double) As Double
    phy_kmh__ms = 1000 * kmProStunde / 3600
End Function

Public Function phy_ms__kmh(ByVal mProSekunde As Double) As Double
    phy_ms__kmh = 3600 * mProSekunde / 1000
End Function

Public Function phy_ms__knoten(ByVal mProSekunde As Double) As Double
    phy_ms__knoten = 1.943 * mProSekunde
End Function

Public Function phy_knoten__ms(ByVal Knoten As Double) As Double
    phy_knoten__ms = Knoten / 1.943
End Function

Public Function phy_mph__ms(ByVal MilesPerHour As Double) As Double
    phy_mph__ms = 0.477 * MilesPerHour
End Function

Public Function phy_ms__mph(ByVal mProSekunde As Double) As Double
    phy_ms__mph = mProSekunde / 0.477
End Function

Public Function phy_mph__kmh(ByVal MilesPerHour As Double) As Double
    phy_mph__kmh = MilesPerHour * 1.609
End Function

Public Function phy_kmh__mph(ByVal kmProStunde As Double) As Double
    phy_kmh__mph = kmProStunde / 1.609
End Function

Public Function phy_kmh__beaufort(ByVal kmProStunde As Double) As Double
    If (kmProStunde < 1) Then
        resRet = 0
    ElseIf (kmProStunde <= 5.5) Then
        resRet = 1
    ElseIf (kmProStunde <= 11) Then
        resRet = 2
    ElseIf (kmProStunde <= 19) Then
        resRet = 3
    ElseIf (kmProStunde <= 28) Then
        resRet = 4
    ElseIf (kmProStunde <= 38) Then
        resRet = 5
    ElseIf (kmProStunde <= 49) Then
        resRet = 6
    ElseIf (kmProStunde <= 61) Then
        resRet = 7
    ElseIf (kmProStunde <= 74) Then
        resRet = 8
    ElseIf (kmProStunde <= 88) Then
        resRet = 9
    ElseIf (kmProStunde <= 102) Then
        resRet = 10
    ElseIf (kmProStunde <= 117) Then
        resRet = 11
    Else
        resRet = 12
    End If
    phy_kmh__beaufort = resRet
End Function

'Temperaturen
'------------
'   0°C =>  32°F
' 100°C => 212°F
Public Function phy_Celsius__Fahrenheit(ByVal Celsius As Double) As Double
    phy_Celsius__Fahrenheit = Celsius * (212 - 32) / 100 + 32
End Function

Public Function phy_Fahrenheit__Celsius(ByVal Fahrenheit As Double) As Double
    phy_Fahrenheit__Celsius = Fahrenheit * (100 / (212 - 32)) - (100 / (212 - 32)) * 32
End Function

Public Function phy_Celsius__Kelvin(ByVal Celsius As Double) As Double
    phy_Celsius__Kelvin = Celsius + 273.15
End Function

Public Function phy_Kelvin__Celsius(ByVal Kelvin As Double) As Double
    phy_Kelvin__Celsius = Kelvin - 273.15
End Function

'Längenmasse
'-----------
Public Function phy_m__feet(ByVal m As Double) As Double
    phy_m__feet = m / 0.3048
End Function

Public Function phy_feet__m(ByVal feet As Double) As Double
    phy_feet__m = feet * 0.3048
End Function

Public Function phy_m__inch(ByVal m As Double) As Double
    phy_m__inch = m / 0.0254
End Function

Public Function phy_inch__m(ByVal inch As Double) As Double
    phy_inch__m = inch * 0.0254
End Function


' Common Math functions
' ======================================================
Function EqualsWithinTolerance(ist As Double, soll As Double, Optional abweichungProzent As Double = 1) As Boolean
    If (soll = 0) And (ist = 0) Then
        EqualsWithinTolerance = True
    Else
        If Abs(100 - (ist * 100 / soll)) > abweichungProzent Then
            EqualsWithinTolerance = False
        Else
            EqualsWithinTolerance = True
        End If
    End If
End Function

Public Function powerTen(ByVal exp As Integer) As Long
    Dim retVal As Long
    If (exp <= 0) Then
        retVal = 1
    Else
        retVal = 10
        For i = 2 To exp
            retVal = retVal * 10
        Next i
    End If
    powerTen = retVal
End Function

Public Function isIntegerEven(ByVal aInt As Integer) As Boolean
    If (aInt Mod 2 = 0) Then
        isIntegerEven = True
    Else
        isIntegerEven = False
    End If
End Function

Public Function returnInteger(ByVal inVal1 As String, Optional ByVal defVal As Integer = 0) As Integer
    If (inVal1 = "") Then
        returnInteger = defVal
    Else
        returnInteger = inVal1
    End If
End Function

Public Function returnDouble(ByVal inVal1 As String, Optional ByVal defVal As Double = 0#) As Double
    If (inVal1 = "") Then
        returnDouble = defVal
    Else
        returnDouble = inVal1
    End If
End Function

' compares two doubles if there are within a toleranz(e.g. 0.01 => 1%)
' Results:
'   valA < valB: - 1
'   valA = valB:   0(within toleranze)
'   valA > valB:   1
Public Function compareDouble(ByVal valA As Double, ByVal valB As Double, Optional ByVal toleranz As Double = 0.01) As Integer
    Dim tol As Double
    tol = compareDouble_toleranz(valA, valB)
    If (tol < toleranz) Then
        compareDouble = 0
    ElseIf (valA < valB) Then
        compareDouble = -1
    Else
        compareDouble = 1
    End If
End Function


Public Function compareDouble_toleranz(valA As Double, valB As Double) As Double
    If ((valA > -0.01) And (valA < 0.01)) Then
        If ((valB > -0.01) And (valB < 0.01)) Then
            compareDouble_toleranz = 0
        Else
            compareDouble_toleranz = 9999
        End If
    Else
        compareDouble_toleranz = Abs((valB / valA) - 1)
    End If
End Function

Public Function equalsDouble(valA As Double, valB As Double) As Boolean
    If (compareDouble(valA, valB) = 0) Then
        equalsDouble = True
    Else
        equalsDouble = False
    End If
End Function

Public Function notEqualsDouble(valA As Double, valB As Double) As Boolean
    If (compareDouble(valA, valB) = 0) Then
        notEqualsDouble = False
    Else
        notEqualsDouble = True
    End If
End Function

Public Function wMaximum(ByVal x As Integer, ParamArray y())
    Dim i As Integer
    Dim max As Integer

    max = x
    For i = LBound(y) To UBound(y)
        max = IIf(max < y(i), y(i), max)
    Next
    wMaximum = max
End Function

Public Function log_e(ByVal numerus As Double) As Double
   log_e = Log(numerus)
End Function

Public Function log_10(ByVal numerus As Double) As Double
   log_10 = Log(numerus) / Log(10)
End Function

Public Function log_2(ByVal numerus As Double) As Double
   log_2 = Log(numerus) / Log(2)
End Function

Public Function nextVielfaches(aZahl As Integer, reihe As Integer) As Integer
   Dim rest As Integer
   rest = aZahl Mod reihe
   If (rest = 0) Then
     nextVielfaches = aZahl
   Else
     nextVielfaches = (aZahl - rest) + reihe
   End If
End Function

Public Function trunc(inVal1 As Double) As Integer
   trunc = Fix(inVal1)
End Function

Public Function WR_Math_ABS(ByVal iVal As Double, ByVal doAbs As Boolean) As Double
    If (doAbs = True) Then
        WR_Math_ABS = Abs(iVal)
    Else
        WR_Math_ABS = iVal
    End If
End Function

Public Function WR_Math_Ops(ByVal iVal_1 As Double, ByVal iVal_2 As Double, ByVal opChr As String) As Double
    If (opChr = "+") Then
        WR_Math_Ops = iVal_1 + iVal_2
    ElseIf (opChr = "*") Then
        WR_Math_Ops = iVal_1 * iVal_2
    ElseIf (opChr = "-") Then
        WR_Math_Ops = iVal_1 - iVal_2
    ElseIf (opChr = "/") Then
        WR_Math_Ops = iVal_1 / iVal_2
    End If
End Function

' Quadrantenbereinigte cotangens funktion(Winkel zur x-Achse (0 .. 180°,0 .. -180°)==> Einheit: [Rad]
Public Function Atn2_VBA(x As Double, y As Double) As Double
    If x > 0 Then
        Atn2_VBA = Atn(y / x)
     ElseIf y = 0 Then
            If (x < 0) Then
                Atn2_VBA = Pi
            Else
                Atn2_VBA = 0
            End If
     ElseIf x < 0 Then
        Atn2_VBA = Sgn(y) * (Pi - Atn(Abs(y / x)))
     Else
        Atn2_VBA = Sgn(y) * Pi / 2
    End If
End Function

' Quadratische Gleichung
Public Function diskriminante(ByVal a As Double, ByVal b As Double, ByVal c As Double) As Double
    diskriminante = b * b - 4 * a * c
End Function

Public Function quadratischeGleichungSolution(ByVal a As Double, ByVal b As Double, ByVal c As Double, Optional ByVal firstSolution As Boolean = True, Optional ByVal errorVal As Double = -9999999) As Double
    Dim retVal As Double
    Dim diskrim As Double
    diskrim = diskriminante(a, b, c)
    If (diskrim < 0) Then
        retVal = errorVal
    Else
        If (firstSolution) Then
            retVal = (-b + (diskrim) ^ (1 / 2)) / (2 * a)
        Else
            retVal = (-b - (diskrim) ^ (1 / 2)) / (2 * a)
        End If
    End If
    quadratischeGleichungSolution = retVal
End Function

' System Functions
' ======================================================
Public Function Refresh() As String
   Application.CalculateFull
   Refresh = "Done"
End Function

Public Function getLoggedinUser()
    getLoggedinUser = Environ("USERNAME")
End Function

Public Function getNodeName()
    getNodeName = Environ("COMPUTERNAME")
End Function

Public Function pause(Optional ByVal hours As Integer = 0, Optional ByVal minutes As Integer = 0, Optional ByVal seconds As Integer = 1) As String
    Application.Wait Now + TimeSerial(hours, minutes, seconds)
    pause = ""
End Function

' activ has focus; this is where the code runs (makro belongs to)
Public Function MyName(Optional ByVal useThis As Boolean = True) As String
    If (useThis) Then
        MyName = ThisWorkbook.name
    Else
        MyName = ActiveWorkbook.name
    End If
End Function


Public Function MyFullName(Optional ByVal useThis As Boolean = True) As String
    If (useThis) Then
        MyFullName = ThisWorkbook.fullName
    Else
        MyFullName = ActiveWorkbook.fullName
    End If
End Function


' File functions
' ======================================================
' file-dialog
Public Function getSelectedFilenameFromDialog( _
        Optional ByVal ToRead As Boolean = True, _
        Optional ByVal titleStr As String = "Title", _
        Optional ByVal Filter_1_Str As String = "Text Files", _
        Optional ByVal Filter_2_Str As String = "*.txt;*.csv;*.tab;*.asc", _
        Optional ByVal ButtonStr As String = "Select", _
        Optional ByVal defaultFilename As String = "UnknowFile") As String
        

    Dim fd As FileDialog
    Dim fileChosen As Integer
    Dim filename As String
    Dim fdMode As Integer
    If (ToRead) Then
        Set fd = Application.FileDialog(msoFileDialogFilePicker)
        fd.AllowMultiSelect = False
        fd.ButtonName = ButtonStr
        fd.Title = titleStr
        fd.InitialView = msoFileDialogViewDetails
        fd.Filters.Add Filter_1_Str, Filter_2_Str, 1
        fileChosen = fd.Show
        If fileChosen <> -1 Then
            'Wenn keine Datei ausgewählt wurde
            filename = "ERROR: No file selected"
            GoTo EndOf_getSelectedFilenameFromDialog:
        Else
            'Pfad und Dateiname in Zelle übernehmen
            filename = fd.SelectedItems(1)
        End If
        
        If fd.SelectedItems(1) = "" Then
            filename = defaultFilename
        End If
EndOf_getSelectedFilenameFromDialog:
        Set fd = Nothing
    Else
        Dim retVal As Variant
        retVal = Application.GetSaveAsFilename( _
            InitialFileName:=defaultFilename, _
            FileFilter:=Filter_1_Str & ", " & Filter_2_Str & ", All Files (*.*), *.*", _
            Title:=titleStr, _
            ButtonText:=ButtonStr)
        filename = retVal
        If retVal = False Then
            filename = "ERROR: Cancel pressed!!!"
        End If
        
        If filename = "" Then
            filename = defaultFilename
        End If
    End If
    getSelectedFilenameFromDialog = filename
End Function


Public Function getSelectedFilenameFromDialog_Old( _
        Optional ByVal ToRead As Boolean = True, _
        Optional ByVal titleStr As String = "Title", _
        Optional ByVal Filter_1_Str As String = "Text Files", _
        Optional ByVal Filter_2_Str As String = "*.txt;*.csv;*.tab;*.asc", _
        Optional ByVal ButtonStr As String = "Select", _
        Optional ByVal defaultFilename As String = "UnknowFile") As String
        

    Dim fd As FileDialog
    Dim fileChosen As Integer
    Dim filname As String
    Dim fdMode As Integer
    If (ToRead) Then
        fdMode = msoFileDialogFilePicker
    Else
        fdMode = msoFileDialogSaveAs
    End If
    
    Set fd = Application.FileDialog(fdMode)
    fd.AllowMultiSelect = False
    fd.ButtonName = ButtonStr
    fd.Title = titleStr
    fd.InitialView = msoFileDialogViewDetails
    If (ToRead) Then
        fd.Filters.Add Filter_1_Str, Filter_2_Str, 1
    Else
        fd.InitialFileName = "*.txt"

    End If
    fileChosen = fd.Show
    If fileChosen <> -1 Then
        'Wenn keine Datei ausgewählt wurde
        filname = "ERROR: No file selected"
        GoTo EndOf_getSelectedFilenameFromDialog:
    Else
        'Pfad und Dateiname in Zelle übernehmen
        filname = fd.SelectedItems(1)
    End If
    
    If fd.SelectedItems(1) = "" Then
        filname = defaultFilename
    End If
    
EndOf_getSelectedFilenameFromDialog:
    Set fd = Nothing
    getSelectedFilenameFromDialog_Old = filname
End Function


Public Function getFileName(fullPath As String)
    Dim StrFind As String
    Do Until left(StrFind, 1) = "\"
        iCount = iCount + 1
        StrFind = right(fullPath, iCount)
            If iCount = Len(fullPath) Then Exit Do
    Loop
    getFileName = right(StrFind, Len(StrFind) - 1)
End Function

Public Function getPathToFileName(fullPath As String)
    Dim szPathSep As String
    szPathSep = Application.PathSeparator
     
    Dim szCut As String
    szCut = CStr(Empty)
     
    Dim i As Long
    i = Len(fullPath)
     
    Dim szPath As String
    Dim szFile As String
     
    If i > 0 Then
        Do While szCut <> szPathSep
            szCut = Mid$(fullPath, i, 1)
            If szCut = szPathSep Then
                szPath = left$(fullPath, i)
                szFile = right$(fullPath, Len(fullPath) - i)
            End If
            i = i - 1
        Loop
        getPathToFileName = szPath
    Else
        getPathToFileName = ""
    End If
End Function

Public Function lineCountInFile(ByVal inFn As String) As Integer
    Dim lineCount As Integer
    Dim fileNum As Integer
    Dim lineContent As String
    lineCount = 0
        
    On Error GoTo FileNotOpen:
    fileNum = FreeFile
    Open inFn For Input As #fileNum
    Do While Not EOF(fileNum)
       Line Input #fileNum, lineContent  ' If a UNIX file, then the entire text is one line
       lineCount = lineCount + 1
    Loop
    Close #fileNum
    GoTo EndFct:
FileNotOpen:
    lineCount = -1
EndFct:
    lineCountInFile = lineCount
End Function

' Windows-ASCII file with CR/LF(13/10) as line end; A UNIX file ends with LF(10)
Public Function isFileA_UnixAsciiFile(ByVal inFn As String) As String
    Dim fileNum As Integer
    Dim retVal As String
    Dim lineContent As String
    Dim lineCount As Integer
    retVal = "False"
    
    lineCount = lineCountInFile(inFn)
    If lineCount > 1 Then
        retVal = "False"
        GoTo EndFct:
    Else
        On Error GoTo FileNotOpen:
        fileNum = FreeFile
        Open inFn For Input As #fileNum
        Do While Not EOF(fileNum)
           Line Input #fileNum, lineContent  ' If a UNIX file, then the entire text is one line
           If lineContent <> "" Then
               If strContains(lineContent, vbLf) Then
                   retVal = "True"
                   ' Debug.Print inFn & ":" & " Is a UNIX ASCII file!"
               End If
           End If
        Loop
        Close #fileNum
        GoTo EndFct:
    
FileNotOpen:
        isFileA_UnixAsciiFile = inFn & ":" & ErrorStr
    End If

EndFct:
    isFileA_UnixAsciiFile = retVal
End Function

Public Function isFileExists(ByVal fName As String) As Boolean
    Dim retVal As Boolean
    retVal = False
    
    If Len(Dir$(fName)) > 0 Then
        retVal = True
    End If
    isFileExists = retVal
End Function


' Converts an UNIX to a WINDOWS ASCII fiel or visa verse
Public Function ConvertASCII_File( _
            ByVal OriginalFile As String, _
            ByVal NewFile As String, _
            Optional ByVal eConvertType As String = "dos2unix", _
            Optional ByVal DeleteOriginal As Boolean = True)
    
   Dim OpenFileNum, SaveFileNum As Integer
   Dim NewFileBuffer As String
 
   ' This function will open a file and convert it to
   ' a txt file format usable under *nix or dos
   On Error GoTo Error_Found
   
   OpenFileNum = FreeFile ' grab the first free file
   Open OriginalFile For Input As #OpenFileNum ' open the unix file
       SaveFileNum = FreeFile ' get another free file to write to
       Open NewFile For Binary As #SaveFileNum ' open/create the save file
           Do While Not EOF(OpenFileNum)
               Line Input #OpenFileNum, NewFileBuffer ' retrive the text (if a unix file, then the entire text is on one line)
               If eConvertType = "dos2unix" Then ' Check what type of conversion to do
                   NewFileBuffer = NewFileBuffer & Chr(10)
               Else
                   NewFileBuffer = Replace(NewFileBuffer, Chr(10), vbCrLf)
               End If
               Put #SaveFileNum, , NewFileBuffer ' write out the file
           Loop
       Close #SaveFileNum
   Close #OpenFileNum
   
   If DeleteOriginal = True Then
        Kill OriginalFile
        CopyFile_WR NewFile, OriginalFile
   End If

Exit_Sub:
   Exit Function
   
Error_Found:
   MsgBox "Error: " & Err.Description & vbCrLf & "Number: " & Err.Number
   Exit Function
End Function
 
 
Public Function CopyFile_WR( _
            ByVal fromFile As String, _
            ByVal toFile As String)
            
    Dim fs As Object
    Set fs = CreateObject("Scripting.FileSystemObject")
    fs.CopyFile fromFile, toFile 'This file was an .xls file
    Set fs = Nothing
End Function

' any Excel or csv file to load into a TAB
Function LoadExcelAndPutItIntoTAB( _
                ByVal inputFilename As String, _
                ByVal inputTabName As String, _
                ByVal destTabName As String, _
                Optional ByVal fBrowserText As String = "Filename Cifs from Config DB") As String
                
    Dim retVal As String
    Dim thisFileName As String
    thisFileName = MyName()
    
    Application.ScreenUpdating = False
    Application.DisplayAlerts = False
    
    If (inputFilename = "") Then
        inputFilename = getSelectedFilenameFromDialog(True, fBrowserText)
    End If
    
    If (Not (strStarts(inputFilename, "ERROR:"))) Then
        Workbooks.OpenText filename:=inputFilename, _
                           Origin:=xlWindows, _
                           startRow:=1, _
                           DataType:=xlDelimited, _
                           TextQualifier:=xlDoubleQuote, _
                           ConsecutiveDelimiter:=False, _
                           Tab:=False, _
                           Semicolon:=True, _
                           Comma:=False, _
                           Space:=False, _
                           Other:=False, _
                           TrailingMinusNumbers:=True
        
        ' delete content of old TAB
        Windows(thisFileName).Activate
        Sheets(destTabName).Select
        Cells.Select
        Selection.Delete Shift:=xlUp
        
        ' copy
        retVal = activateWorkbookWorksheet(inputFilename, inputTabName)
        Cells.Select
        Selection.Copy
        
        ' paste
        Windows(thisFileName).Activate
        Range("A1").Select
        ActiveSheet.Paste
        
        ' load file close
        retVal = activateWorkbookWorksheet(inputFilename, inputTabName)
        ActiveWindow.Close
        
        
        retVal = ""
    End If
        
    Application.DisplayAlerts = True
    Application.ScreenUpdating = True
    
    
    LoadExcelAndPutItIntoTAB = retVal
End Function

' The input file has to be a WINDOWS ASCII file!
Public Function readCsvFile( _
        ByVal inFn As String, _
        ByVal sheetName As String, _
        ByVal upperLeftCell As String, _
        ByVal lowerRightCell As String, _
        Optional ByVal delimiter As String = ";", _
        Optional ByVal CompleteStr As String = "Done", _
        Optional ByVal ErrorStr As String = "File could not be read", _
        Optional ByVal HeaderLine As String = "", _
        Optional ByVal TempFilename As String = "\\chca6021.eur.beluni.net\a438995$\Desktop\DynamicCif\ft_cif_groups_CONVERTED.csv")
        
    Dim iLine As Integer
    Dim iColumn As String
    Dim lineContent As String
    Dim cellAdr As String
    Dim fileNum As Integer
    Dim retStr As String
    
    ' check first if it is a UNIX ASCII file
    If isFileA_UnixAsciiFile(inFn) Then
        If isFileExists(TempFilename) Then
            Kill TempFilename
        End If
        delme = ConvertASCII_File(OriginalFile:=inFn, NewFile:=TempFilename, eConvertType:="unix2dos", DeleteOriginal:=True)
    End If
    
    On Error GoTo FileNotOpen:
    iLine = GetRowIndexFromAdr(upperLeftCell)
    iColumn = getColumnLetterFromAdr(upperLeftCell)
    fileNum = FreeFile
    
    Open inFn For Input As #fileNum

    Application.DisplayAlerts = False
    Application.ScreenUpdating = False
    
    Do While Not EOF(fileNum)
       Line Input #fileNum, lineContent  ' If a UNIX file, then the entire text is one line
       If lineContent <> "" Then
           If Not strStarts(lineContent, "#") Then
               ' Debug.Print lineContent
               ' Debug.Print ""
               cellAdr = iColumn & iLine
               Sheets(sheetName).Range(cellAdr).Value = lineContent
               Sheets(sheetName).Range(cellAdr).WrapText = False
               ' Dim arrAct As Variant
               ' arrAct = SplitString(lineContent, ",")
               ' For intCol = 1 To UBound(arrAct)
               '    Cells(intRow, intCol).Value = arrAct(intCol)
               ' Next intCol
               Sheets(sheetName).Range(cellAdr).TextToColumns Destination:=Range(cellAdr), DataType:=xlDelimited, TextQualifier:=xlDoubleQuote, FieldInfo:=Array(Array(1, 2)), Other:=True, OtherChar:=";", TrailingMinusNumbers:=True
               iLine = iLine + 1
           End If
       End If
    Loop
    
    Close #fileNum
    readCsvFile = CompleteStr
    GoTo EndFct:
    
FileNotOpen:
    readCsvFile = inFn & ":" & ErrorStr

EndFct:
    Application.ScreenUpdating = True
    Application.DisplayAlerts = True
End Function

Public Function saveAsCsvFile( _
        ByVal outFn As String, _
        ByVal sheetName As String, _
        ByVal upperLeftCell As String, _
        ByVal lowerRightCell As String, _
        Optional ByVal delimiter As String = ";", _
        Optional ByVal CompleteStr As String = "Done", _
        Optional ByVal ErrorStr As String = "File could not be written", _
        Optional ByVal HeaderLine As String = "")
        
    Dim iLine As Integer
    Dim iColumn As String
    Dim lineContent As String
    Dim cellAdr As String
    Dim fileNum As Integer
    
    On Error GoTo FileNotOpen:
    fileNum = FreeFile
    Open outFn For Output As #fileNum
    
    If (HeaderLine <> "") Then
        Print #fileNum, HeaderLine
    End If
    For iLine = GetRowIndexFromAdr(upperLeftCell) To GetRowIndexFromAdr(lowerRightCell)
        lineContent = ""
        iColumn = getColumnLetterFromAdr(upperLeftCell)
        Do While iColumn <> getColumnLetterFromAdr(lowerRightCell)
            cellAdr = iColumn & iLine
            lineContent = lineContent & Sheets(sheetName).Range(cellAdr).Value & delimiter
            iColumn = getNextColumnLetter(iColumn)
        Loop
        cellAdr = iColumn & iLine
        lineContent = lineContent & Sheets(sheetName).Range(cellAdr).Value
        Print #fileNum, lineContent
    Next iLine
    
    Close #fileNum
    saveAsCsvFile = CompleteStr
    GoTo EndFct:
    
FileNotOpen:
    saveAsCsvFile = outFn & ":" & ErrorStr

EndFct:
End Function

Public Function strToFile(inStr1 As String, outFn As String, Optional ByVal CompleteStr As String = "Done", Optional ByVal ErrorStr As String = "File could not be written") As String
    Dim fileNum As Integer
    
    On Error GoTo FileNotOpen:
    fileNum = FreeFile
  
    Open outFn For Output As #fileNum
    Print #fileNum, inStr1
    Close #fileNum
    strToFile = CompleteStr
    GoTo EndFct:
    
FileNotOpen:
    strToFile = outFn & ":" & ErrorStr

EndFct:
End Function

' Outlook: Email, Calendar Function
' ======================================================
Public Function SendAnEmail(ByVal toAdr As String, _
                            ByVal subjectStr As String, _
                            ByVal msgBody As String, _
                            Optional ByVal attachmentPathList As String = "", _
                            Optional ByVal fromAdr As String = "", _
                            Optional ByVal ccAdr As String = "", _
                            Optional ByVal bccAdr As String = "", _
                            Optional ByVal rReceiptRequested As String = "", _
                            Optional ByVal importanceStr As String = "") As String ' importanceStr:: default and 1: Normal;       0: Low;        2: High
    Dim retVal As String
    Dim readReceiptRequested As Boolean
    rReceiptRequested = UCase(rReceiptRequested)
    If ((rReceiptRequested = "") Or _
        (rReceiptRequested = "NO") Or _
        (rReceiptRequested = "NEIN") Or _
        (rReceiptRequested = "FALSE") Or _
        (rReceiptRequested = "FALSCH") Or _
        (rReceiptRequested = "0") Or _
        (rReceiptRequested = "NIENTE")) Then
        readReceiptRequested = False
    Else
        readReceiptRequested = True
    End If
    retVal = ""
    Dim olApp As Object
    Set olApp = CreateObject("Outlook.Application")
    If (olApp Is Nothing) Then
        retVal = retVal & "  Outlook is not started! Pls start Outlook."
        MsgBox retVal, vbOKOnly, "Error"
    Else
        With olApp.CreateItem(0)
            ' .Recipients.Add toAdr
            .To = toAdr
            .cc = ccAdr
            .bcc = bccAdr
            If (fromAdr <> "") Then
                .SentOnBehalfOfName = fromAdr
            End If
            
            .Subject = subjectStr
            If (strStarts(msgBody, "<!-- HTML Sytle -->")) Then
                .HTMLBody = msgBody
            Else
                .Body = msgBody
            End If
            
            .readReceiptRequested = readReceiptRequested
    
            Dim attachmentArray() As Variant
            attachmentArray = splitStringByDelimiterStr(attachmentPathList, ";")
            For i = LBound(attachmentArray) To UBound(attachmentArray)
                Dim attachmentPath As String
                attachmentPath = attachmentArray(i)
                If (attachmentPath <> "") Then
                    If (isFileExists(attachmentPath)) Then
                        .Attachments.Add attachmentPath
                    Else
                        retVal = retVal & "  Attachment " & attachmentPath & " is not existing"
                        MsgBox retVal, vbOKOnly, "Error"
                    End If
                End If
            Next
                
            If (importanceStr <> "") Then
                .importance = importanceStr
            End If
            .Send
        End With
        Set olApp = Nothing
    End If
    SendAnEmail = retVal
End Function

'fRef = sheetName!A4:email    rowIndex=5
' looks for email column name in header starting at A4 on sheet sheetName i.g. E4
' than gets the value of cell sheetName!E10  (4 + 5 + 1) back
Public Function parseFieldReference(ByVal fRef As String, ByVal rowIndex As Integer, fieldVal As String) As String
    
    Dim shName As String
    Dim topLeftAdr As String
    Dim fieldNameOrValue As String
    Dim columnLetter As String
    
    Dim retVal As String
    columnLetter = ""
    shName = getFieldFromString(getFieldFromString(fRef, ":", 0), "!", 0)
    topLeftAdr = getFieldFromString(getFieldFromString(fRef, ":", 0), "!", 1)
    fieldNameOrValue = getFieldFromString(fRef, ":", 1)
    If (shName = FixedValueStr) Then
        fieldVal = fieldNameOrValue
    ElseIf (shName = "") Then
        fieldVal = fRef
    Else
        If (SheetExists(shName)) Then
            If (fieldNameOrValue = "") Then
                fieldVal = Sheets(shName).Range(topLeftAdr).Value
            Else
                columnLetter = findColumnLetterFromHeader(topLeftAdr, fieldNameOrValue, shName)
                retVal = ""
                fieldVal = Sheets(shName).Range(columnLetter & GetRowIndexFromAdr(topLeftAdr) + rowIndex + 1).Value
            End If
        Else
            retVal = shName & " is not existing (" & fRef & ")"
            MsgBox retVal, vbOKOnly, "Error"
            fieldVal = fRef
        End If
    End If

    parseFieldReference = retVal
End Function

Public Function sendSerienMail( _
           ByVal ca_emailColName As String, _
           ByVal ca_MsgTemplate As String, _
           ByVal ca_subjectColName As String, _
           Optional ByVal ca_sendConditionColName As String = "", _
           Optional ByVal ca_valSendConditionColName As String = "", _
           Optional ByVal ca_ccColName As String = "", _
           Optional ByVal ca_bccColName As String = "", _
           Optional ByVal ca_fromEmailColName As String = "", _
           Optional ByVal ca_receiptColName As String = "", _
           Optional ByVal ca_attachmentColName As String = "", _
           Optional ByVal ca_importanceColName As String = "") As String
          
    Dim retVal As String
    
    'i.g.  walter@rothlin.com
    Dim v_email As String
    Dim v_MsgTemplate As String
    Dim v_subject As String
    Dim v_sendCondition As String
    Dim v_valSendCondition As String
    Dim v_cc As String
    Dim v_bcc As String
    Dim v_fromEmail As String
    Dim v_receipt As String
    Dim v_attachment As String
    Dim v_importance As String

    Dim valMeldung As String
    Dim columnIndex As Integer
    retVal = ""
    
    columnIndex = 0
    Do
        retVal = parseFieldReference(ca_emailColName, columnIndex, v_email)
        retVal = parseFieldReference(ca_MsgTemplate, columnIndex, v_MsgTemplate)
        retVal = parseFieldReference(ca_subjectColName, columnIndex, v_subject)
        retVal = parseFieldReference(ca_sendConditionColName, columnIndex, v_sendCondition)
        retVal = parseFieldReference(ca_valSendConditionColName, columnIndex, v_valSendCondition)
        retVal = parseFieldReference(ca_ccColName, columnIndex, v_cc)
        retVal = parseFieldReference(ca_bccColName, columnIndex, v_bcc)
        retVal = parseFieldReference(ca_fromEmailColName, columnIndex, v_fromEmail)
        retVal = parseFieldReference(ca_receiptColName, columnIndex, v_receipt)
        retVal = parseFieldReference(ca_attachmentColName, columnIndex, v_attachment)
        retVal = parseFieldReference(ca_importanceColName, columnIndex, v_importance)

        If ((v_email <> "") And (v_sendCondition = v_valSendCondition)) Then
            Dim templateListName As String
            Dim templateTopLeft As String
            Dim endCellOfHeader As String
            Dim valueRange As String
            templateListName = getFieldFromString(getFieldFromString(ca_emailColName, ":", 0), "!", 0)
            templateTopLeft = getFieldFromString(getFieldFromString(ca_emailColName, ":", 0), "!", 1)
            endCellOfHeader = getAdrByAddingOffset(templateTopLeft, getLastColumnRelative(templateListName, templateTopLeft) - 1, 0)
            
            valueRange = getAdrByAddingOffset(templateTopLeft, 0, columnIndex + 1) & ":" & getAdrByAddingOffset(endCellOfHeader, 0, columnIndex + 1)
                        
            valMeldung = parseStringTemplate(v_MsgTemplate, templateListName, templateTopLeft & ":" & endCellOfHeader, valueRange, "{;}")
            retVal = SendAnEmail(v_email, v_subject, valMeldung, v_attachment, v_fromEmail, v_cc, v_bcc, v_receipt, v_importance)
        End If
        
        columnIndex = columnIndex + 1
    Loop Until v_sendCondition = ""
    
    sendSerienMail = retVal
End Function

Public Function fullAnrede( _
           ByVal sex As String, _
           ByVal name As String, _
           ByVal vorname As String, _
           ByVal perDu As String, _
           Optional zeile1 As Boolean = True, _
           Optional asHTML As Boolean = True) As String
           
    Dim retStr As String
    Dim aSex As String
    Dim aName As String
    Dim aVorname As String
    Dim aPerDu As String
    Dim pos As Integer
    Dim lineSep As String
    
    If (asHTML) Then
        lineSep = ",<BR/>" & getCRLF()
    Else
        lineSep = "," & getCRLF()
    End If
    
    If (zeile1) Then
        pos = 0
    Else
        pos = 1
    End If
    aSex = getFieldFromString(sex, "+", pos, True)
    aName = getFieldFromString(name, "+", pos, True, name)
    aName = getFieldFromString(aName, "-", 0)
    aVorname = getFieldFromString(vorname, "+", pos, True)
    aPerDu = getFieldFromString(perDu, "+", pos, True, perDu)
    
    If (aSex = "") Then
        retStr = ""
    Else
        If (aPerDu = "Ja") Then
            If (aSex = "Herr") Then
                retStr = "Lieber " & aVorname
            Else
                retStr = "Liebe " & aVorname
            End If
        Else
            If (aSex = "Herr") Then
                retStr = "Sehr geehrter " & aSex & " " & aName
            Else
                retStr = "Sehr geehrte " & aSex & " " & aName
            End If
        End If
    End If
    If (retStr <> "") Then
        fullAnrede = retStr & lineSep
    Else
         fullAnrede = retStr
    End If
    
End Function

' Outlook Calendar
' ----------------
'
' all properties https://docs.microsoft.com/en-us/office/vba/api/outlook.appointmentitem
' e.g.
'   dateAndTime = "24.12.2019 12:00"
'   duration = 0  all day or in minutes
'   importanceStr = 0   default and 0: Normal;       1: Wichtigkeit hoch;        2: Wichtigkeit tief    3: Wichtigkeit hoch + Private;        2: Wichtigkeit tief + Private
Public Function CreateCalendarEntry(ByVal startDateAndTime As String, _
                            ByVal meetingName As String, _
                            ByVal ort As String, _
                            Optional ByVal meetingText As String = "", _
                            Optional ByVal busy As Boolean = True, _
                            Optional ByVal dauer As Integer = 60, _
                            Optional ByVal reminder As Integer = 15, _
                            Optional ByVal endDateAndTime As String = "", _
                            Optional ByVal inviteOptionalAdr As String = "", _
                            Optional ByVal importanceStr As String = "0", _
                            Optional ByVal cat As String = "") As String

    Dim retVal As String
    retVal = True

    Dim OutApp As Object, apptOutApp As Object
    
    Set OutApp = CreateObject("Outlook.Application")
    Set apptOutApp = OutApp.CreateItem(1)
    apptOutApp.Start = startDateAndTime
    apptOutApp.Subject = meetingName
    apptOutApp.location = ort
    apptOutApp.Body = meetingText
    apptOutApp.BusyStatus = busy

    If (dauer > 0) Then
        apptOutApp.AllDayEvent = False
        apptOutApp.duration = dauer
    Else
        apptOutApp.AllDayEvent = True
        apptOutApp.duration = 0
    End If
    
    If (reminder > 0) Then
        apptOutApp.ReminderMinutesBeforeStart = reminder
        apptOutApp.ReminderPlaySound = True
        apptOutApp.ReminderSet = True
    Else
        apptOutApp.ReminderMinutesBeforeStart = 0
        apptOutApp.ReminderPlaySound = False
        apptOutApp.ReminderSet = False
    End If
    
    If (endDateAndTime <> "") Then
         apptOutApp.End = endDateAndTime
    End If
    
    apptOutApp.Categories = cat
    
    apptOutApp.Save
    Set apptOutApp = Nothing
    Set OutApp = Nothing
    CreateCalendarEntry = retVal
End Function

' JSON functions
' ======================================================
Public Sub tojson()
    Dim fso As Object
    Set fso = CreateObject("Scripting.FileSystemObject")
    jsonFilename = fso.GetBaseName(ActiveWorkbook.name) & ".json"
    fullFilePath = Application.ActiveWorkbook.Path & "\" & jsonFilename

    Dim fileStream As Object
    Set fileStream = CreateObject("ADODB.Stream")
    fileStream.Type = 2 'Specify stream type - we want To save text/string data.
    fileStream.Charset = "utf-8" 'Specify charset For the source text data.
    fileStream.Open 'Open the stream And write binary data To the object

    Dim wkb As Workbook
    Set wkb = ThisWorkbook

    Dim wks As Worksheet
    Set wks = wkb.Sheets(1)

    lcolumn = wks.Cells(1, Columns.Count).End(xlToLeft).column
    lrow = wks.Cells(Rows.Count, "A").End(xlUp).row
    Dim titles() As String
    ReDim titles(lcolumn)
    For i = 1 To lcolumn
        titles(i) = wks.Cells(1, i)
    Next i
    fileStream.WriteText "["
    dq = """"
    escapedDq = "\"""
    For j = 2 To lrow
        For i = 1 To lcolumn
            If i = 1 Then
                fileStream.WriteText "{"
            End If
            cellValue = Replace(wks.Cells(j, i), dq, escapedDq)
            fileStream.WriteText dq & titles(i) & dq & ":" & dq & cellValue & dq
            If i <> lcolumn Then
                fileStream.WriteText ","
            End If
        Next i
        fileStream.WriteText "}"
        If j <> lrow Then
            fileStream.WriteText ","
        End If
    Next j
    fileStream.WriteText "]"
    fileStream.SaveToFile fullFilePath, 2 'Save binary data To disk
    a = MsgBox("Saved to " & fullFilePath, vbOKOnly)
End Sub


' Ftp functions
' ======================================================
Public Function ftpFileFct(tmpFN As String, sourceFN As String, serverName As String, userName As String, Password As String, targetDir As String, Optional ByVal transferMode As String = "ascii", Optional ByVal targetFN As String = "")
  Dim filename As String
  Dim fileNum As Integer
  fileNum = FreeFile
  Debug.Print "tmpFN       :" & tmpFN
  filename = getFileName(sourceFN)
  Debug.Print "--> FTP Details"
  Debug.Print "tmpFN       :" & tmpFN
  Debug.Print "sourceFN    :" & sourceFN
  Debug.Print "serverName  :" & serverName
  Debug.Print "userName    :" & userName
  Debug.Print "password    :" & Password
  Debug.Print "targetDir   :" & targetDir
  Debug.Print "transferMode:" & transferMode
  Debug.Print "targetFN    :" & targetFN
  Open tmpFN For Output As #fileNum
  Print #fileNum, userName
  Print #fileNum, Password
  Print #fileNum, "cd " & targetDir
  Print #fileNum, transferMode
  Print #fileNum, "put " & sourceFN
  If (targetFN <> "") Then
      Print #fileNum, "rename " & filename & " " & targetFN
  End If
  Print #fileNum, "bye" '"quit"
  Print #fileNum, "pause"
  Close
  Shell "ftp -d -s:" & tmpFN & " " & serverName, vbNormalFocus  'vbHide
  ftpFileFct = "ftp completed"
  ' Kill Sheets("Test Page FtpFile").[c4]
End Function

Public Function ftpFilesFct(tmpFN As String, sourceFNs As String, serverName As String, userName As String, Password As String, targetDir As String, Optional ByVal transferMode As String = "ascii", Optional ByVal targetFNs As String = "")
  Dim filename As String
  Dim fileNum As Integer
  Dim sourceFN_List() As String
  Dim targetFN_List() As String
  Dim sourceFN As String
  Dim targetFN As String
  
  fileNum = FreeFile
  Debug.Print "tmpFN       :" & tmpFN
  Debug.Print "--> FTP Details"
  Debug.Print "tmpFN       :" & tmpFN
  Debug.Print "sourceFNs   :" & sourceFNs
  Debug.Print "serverName  :" & serverName
  Debug.Print "userName    :" & userName
  Debug.Print "password    :" & Password
  Debug.Print "targetDir   :" & targetDir
  Debug.Print "transferMode:" & transferMode
  Debug.Print "targetFNs   :" & targetFNs
  Open tmpFN For Output As #fileNum
  Print #fileNum, userName
  Print #fileNum, Password
  Print #fileNum, "cd " & targetDir
  Print #fileNum, transferMode
  
  sourceFN_List = Split(sourceFNs, ";")
  targetFN_List = Split(targetFNs, ";")
  
  Dim arrIndex As Integer
  For arrIndex = LBound(sourceFN_List) To UBound(sourceFN_List)
      sourceFN = sourceFN_List(arrIndex)
      Print #fileNum, "put " & sourceFN
      
      If (arrIndex >= LBound(targetFN_List)) And (arrIndex <= UBound(targetFN_List)) Then
        targetFN = targetFN_List(arrIndex)
      Else
        targetFN = ""
      End If
    
      If (targetFN <> "") Then
          filename = getFileName(sourceFN)
          Print #fileNum, "rename " & filename & " " & targetFN
      End If
  Next
  
  Print #fileNum, "bye" '"quit"
  Print #fileNum, "pause"
  Close
  Shell "ftp -d -s:" & tmpFN & " " & serverName, vbNormalFocus  'vbHide
  ftpFilesFct = "ftp completed"
  ' Kill Sheets("Test Page FtpFile").[c4]
End Function

Public Function SftpPut(ByVal sourceFN As String, ByVal serverName As String, ByVal userName As String, ByVal targetDir As String, Optional ByVal Password As String = "")
    Dim strCommand As String
    Dim pPass As String
    If (Password <> "") Then
        pPass = " -pw " & Password & " "
    Else
        pPass = " "
    End If
    strCommand = cstrSftp & " -sftp -l " & userName & pPass & sourceFN & " " & serverName & ":" & targetDir
    Debug.Print strCommand
    Shell strCommand, 1
    SftpPut = "sftp put completed"
End Function

Public Function SftpGet(ByVal localFullFN As String, ByVal remoteFullFN As String, ByVal serverName As String, ByVal userName As String, Optional ByVal Password As String = "")
    Dim strCommand As String
    strCommand = cstrSftp & " -sftp " & userName & "@" & serverName & ":" & remoteFullFN & " " & localFullFN
    Debug.Print strCommand
    Shell strCommand, 1
    SftpGet = "sftp get completed"
End Function

' Common String functions
' ======================================================
Function MyProper(aString As String) As String
    ' MyProper = Proper(aString)     ' geht NICHT!!!!
    MyProper = WorksheetFunction.Proper(aString)
    ' MyProper = StrConv(aString, vbProperCase)    ' geht auch
End Function


Public Function convert_AsciiToUnicode(ByVal inStr1 As String) As String
    Dim retStr As String
    
    retStr = ""
    For i = 1 To Len(inStr1)
      If (Asc(Mid(inStr1, i, 1)) > 128) Then
         retStr = retStr & "&#" & Asc(Mid(inStr1, i, 1)) & ";"
      Else
         retStr = retStr & Mid(inStr1, i, 1)
      End If
    Next

    convert_AsciiToUnicode = retStr
End Function


Public Function formatTelnr(ByVal telnr As String) As String
    Dim returnStr As String
    returnStr = replaceStringInString(telnr, " ", "")
    If (returnStr <> "") Then
        returnStr = left(returnStr, 3) & " " & Mid(returnStr, 4, 3) & " " & Mid(returnStr, 7, 2) & " " & Mid(returnStr, 9, 2)
    End If
    formatTelnr = returnStr
End Function

Function reverseString(ByVal aStr As String) As String
    Dim i As Integer
    Dim strNew As String
    Dim strOld As String
    strOld = Trim(aStr)
    For i = 1 To Len(strOld)
      strNew = Mid(strOld, i, 1) & strNew
    Next i
    reverseString = strNew
End Function

Public Function strContains(ByVal istr1 As String, ByVal sString As String) As Boolean
   strContains = InStr(istr1, sString)
End Function

Public Function strStarts(ByVal istr1 As String, ByVal sString As String) As Boolean
   If (left(istr1, Len(sString)) = sString) Then
        strStarts = True
   Else
        strStarts = False
   End If
End Function

Public Function strEnds(ByVal istr1 As String, ByVal sString As String) As Boolean
   If (right(istr1, Len(sString)) = sString) Then
        strEnds = True
   Else
        strEnds = False
   End If
End Function

Public Function strAreEqual(ByVal istr1 As String, ByVal istr2 As String) As Boolean
    Dim retVal As Boolean
    If (Len(istr1) = Len(istr2)) Then
        If (strContains(istr1, istr2)) Then
            retVal = True
        Else
            retVal = False
        End If
    Else
        retVal = False
    End If
    strAreEqual = retVal
End Function


Public Function signedFigure(ByVal inZahl As Double, Optional ByVal kommastellen As Integer = 2, Optional ByVal isNegativ As Boolean = False) As String
    If (isNegativ) Then
        If (inZahl < 0) Then
            signedFigure = " + " & roundDoubleAsString(Abs(inZahl), kommastellen)
        Else
            signedFigure = " - " & roundDoubleAsString(Abs(inZahl), kommastellen)
        End If
    Else
        If (inZahl < 0) Then
            signedFigure = " - " & roundDoubleAsString(Abs(inZahl), kommastellen)
        Else
            signedFigure = " + " & roundDoubleAsString(Abs(inZahl), kommastellen)
        End If
    End If

End Function

' tbc = is hard coded
Public Function rmStrInStr_1(ByVal myStr1 As String, ByVal pattern As String, Optional ByVal doTrim As Boolean = True) As String
    If (doTrim) Then
        rmStrInStr_1 = RTrim(LTrim(replaceStringInStringRegEx(myStr1, "\s*=\s*")))
    Else
        rmStrInStr_1 = RTrim(LTrim(replaceStringInStringRegEx(myStr1, "\s*=\s*")))
    End If
End Function

Public Function removeLeadingZeros(ByVal inStr1 As String) As String
   Dim strLen As Integer
   strLen = Len(inStr1)
   ' Debug.Print "inStr1: " & inStr1
   ' Debug.Print "strLen: " & strLen
   
   Dim retValFinal As String
   Dim sChar As String
   Dim doCopy As Boolean
   doCopy = False
   
   For i = 1 To strLen
      sChar = Mid(inStr1, i, 1)
      If ((sChar <> "0") And (doCopy = False)) Then
          doCopy = True
      End If
      If (doCopy) Then
          retValFinal = retValFinal & sChar
      End If
   Next i
   removeLeadingZeros = retValFinal
End Function

Public Function convertStringToCode(ByVal inStr1 As String, ByVal sep As String) As String
   Dim retStr As String
   Dim first As Boolean
   first = True
   
   For i = 1 To Len(inStr1)
     If (first) Then
        retStr = Asc(Mid(inStr1, i, 1))
        first = False
     Else
        retStr = retStr & sep & Asc(Mid(inStr1, i, 1))
     End If
   Next
   convertStringToCode = retStr
End Function

Public Function convertStringToDouble(ByVal inStrxx As String) As Double
    Dim decValue As Variant
    decValue = CDec(inStrxx)
    convertStringToDouble = decValue
End Function

Public Function replaceStringInString(ByVal iString As String, ByVal searchStr As String, ByVal replaceValue As String) As String
    replaceStringInString = replaceSinglePlaceholder(iString, searchStr, replaceValue)
End Function

Public Function replaceSpezCharFromString(ByVal inStr1 As String, ByVal spezChar As Integer, ByVal repChar As String) As String
   Dim retStr As String
   
   For i = 1 To Len(inStr1)
     If (Asc(Mid(inStr1, i, 1)) <> spezChar) Then
        retStr = retStr & Mid(inStr1, i, 1)
     Else
        retStr = retStr & repChar
     End If
   Next
   replaceSpezCharFromString = retStr
End Function

Public Function duplicateStr(ByVal inStr1 As String, Optional ByVal periode As Integer = 1) As String
   Dim i As Integer
   Dim retStr As String
   retStr = ""
   For i = 1 To periode
      retStr = retStr & inStr1
   Next i
   duplicateStr = retStr
End Function

Public Function truncString(ByVal inStr1 As String, ByVal newStrLen As Integer) As String
   Dim strLen As Integer
   strLen = Len(inStr1)
   If (Abs(newStrLen) >= strLen) Then
        truncString = inStr1
   Else
        Dim retStr As String
        Dim extLen As Integer
        extLen = Abs(newStrLen)
        
        If (newStrLen < 0) Then
          retStr = right(inStr1, extLen)
        Else
          retStr = left(inStr1, extLen)
        End If
        truncString = retStr
   End If
End Function


Public Function padString(ByVal inStr1 As String, ByVal padStr As String, ByVal newStrLen As Integer) As String
   Dim strLen As Integer
   strLen = Len(inStr1)
   If (Abs(newStrLen) <= strLen) Then
        padString = inStr1
   Else
        Dim retStr As String
        Dim extLen As Integer
        extLen = Abs(newStrLen) - strLen
        If (padStr = "") Then
          padStr = " "
        End If
        Dim trailor As String
        trailor = left(duplicateStr(padStr, extLen), extLen)
        
        If (newStrLen < 0) Then
          retStr = inStr1 & trailor
        Else
          retStr = trailor & inStr1
        End If
        padString = retStr
   End If
End Function

' concatenateStringWithSep(":","Rothlin";"Walti")  ==> Rothlin:Walti
Public Function concatenateStringWithSep(ByVal sepStr As String, Optional ByVal str1 As String = "", Optional ByVal str2 As String = "", Optional ByVal str3 As String = "", Optional ByVal str4 As String = "", Optional ByVal str5 As String = "", Optional ByVal str6 As String = "") As String
    Dim retStr As String
    
    If (str1 <> "") Then
        retStr = str1
    End If

    If (str2 <> "") Then
        retStr = retStr & sepStr & str2
    End If

    If (str3 <> "") Then
        retStr = retStr & sepStr & str3
    End If
    
    If (str4 <> "") Then
        retStr = retStr & sepStr & str4
    End If
    
    If (str5 <> "") Then
        retStr = retStr & sepStr & str5
    End If

    If (str6 <> "") Then
        retStr = retStr & sepStr & str6
    End If
    
    concatenateStringWithSep = retStr
End Function

' appendWithSepIfNotEmpty("Hallo",":";"Walti")  ==> Hallo:Walti
' appendWithSepIfNotEmpty(""     ,":";"Walti")  ==> Walti
Public Function appendWithSepIfNotEmpty(ByVal inStr1 As String, ByVal sepStr As String, ByVal appendStr As String) As String
    Dim retStr As String
    
    If (inStr1 = "") Then
        retStr = appendStr
    Else
        retStr = inStr1 & sepStr & appendStr
    End If
    
    appendWithSepIfNotEmpty = retStr
End Function

Public Function addSeparator(ByVal inStr1 As String, ByVal sepStr As String, ByVal pos As Integer) As String
   Dim retStr As String
   retStr = ""
   Dim i As Integer
   Dim sChar As String
   Dim sepPos As Integer
   If (sepStr = "") Then
      sepStr = "'"
   End If

   retStr = ""
   sepPos = 0
   If (pos < 0) Then
     pos = Abs(pos)
     For i = 1 To Len(inStr1)
      sChar = Mid(inStr1, i, 1)
      If (sepPos = pos) Then
          sepPos = 0
          retStr = retStr & sepStr
      End If
      sepPos = sepPos + 1
      retStr = retStr & sChar
     Next i
   Else
     For i = Len(inStr1) To 1 Step -1
      sChar = Mid(inStr1, i, 1)
      If (sepPos = pos) Then
          sepPos = 0
          retStr = sepStr & retStr
      End If
      sepPos = sepPos + 1
      retStr = sChar & retStr
     Next i
   End If
   addSeparator = retStr
End Function

Public Function removeSeparator(ByVal inStr1 As String, ByVal sepStr As String) As String
   Dim strLen As Integer
   strLen = Len(inStr1)
   If (sepStr = "") Then
      sepStr = "'"
   End If

   Dim retValFinal As String
   retValFinal = ""
   Dim sChar As String
   
   For i = 1 To strLen
      sChar = Mid(inStr1, i, 1)
      If (sChar <> sepStr) Then
        retValFinal = retValFinal & sChar
      End If
   Next i
   removeSeparator = retValFinal
End Function



        
        
Public Function IsIN(x, StringSetElementsAsArray)
    IsIN = InStr(1, Join(StringSetElementsAsArray, Chr(0)), x, vbTextCompare) > 0
End Function

' kkkk566.999996MSH ==> 566.999996   fieldNr not implemented yet   use getStringforRegEx !!!!!!
Public Function getIntegerFromString(ByVal inputString As String, ByVal fieldNr As Integer) As String
   Dim retInt As String
   Dim figurePartStarted As Boolean
   figurePartStarted = False
   
   retInt = ""
   For i = 1 To Len(inputString)
      If (figurePartStarted = False) Then
         If (IsIN(Mid(inputString, i, 1), Array(".", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9))) Then
           figurePartStarted = True
           retInt = Mid(inputString, i, 1)
         Else
           figurePartStarted = False
         End If
      Else
         If (IsIN(Mid(inputString, i, 1), Array(".", 0, 1, 2, 3, 4, 5, 6, 7, 8, 9))) Then
           figurePartStarted = True
           retInt = retInt & Mid(inputString, i, 1)
         Else
           figurePartStarted = False
         End If
    
      End If
   Next i
   getIntegerFromString = retInt
End Function

Public Function splitStringByChar(ByVal inStr1 As String) As Variant
   Dim strLen As Integer
   strLen = Len(inStr1)
   ' Debug.Print "inStr1: " & inStr1
   ' Debug.Print "strLen: " & strLen
   
   Dim retValFinal() As Variant
   retValFinal = Array()
   Dim sChar As String
   
   For i = 1 To strLen
      sChar = Mid(inStr1, i, 1)
      retValFinal = wPush(retValFinal, sChar)
   Next i
   splitStringByChar = retValFinal
End Function

Public Function splitStringByDelimiterStr(ByVal inStr1 As String, Optional ByVal delimStr As String = ";") As Variant
   Dim strLen As Integer
   Dim retValFinal() As Variant
   Dim inStrToSplit As String
   Dim startPos As Long
   
   strLen = Len(inStr1)
   retValFinal = Array()
   inStrToSplit = inStr1
   
   startPos = InStr(1, inStrToSplit, delimStr)
   Do While startPos >= 1
       Dim aField As String
       aField = left(inStrToSplit, startPos - 1)
       retValFinal = wPush(retValFinal, aField)
       inStrToSplit = right(inStrToSplit, Len(inStrToSplit) - startPos - Len(delimStr) + 1)
       ' Debug.Print ("aField:" & aField)
       ' Debug.Print ("inStrToSplit:" & inStrToSplit)
       startPos = InStr(1, inStrToSplit, delimStr)
   Loop
   retValFinal = wPush(retValFinal, inStrToSplit)
   
   splitStringByDelimiterStr = retValFinal
End Function

' converts an hh:mm:ss.00 mm:ss mm:ss.0 string in a double
'    also handels integer and doubles
Public Function getValueAsDouble(ByVal inVal As String, Optional ByVal errorVal As Integer = -1234) As Double
    If (InStr(inVal, ":")) Then
        Dim firstPart As String
        Dim firstPartD As Double
        Dim secPart As String
        Dim secPartD As Double
        
        ' Debug.Print ("In: " & inVal)
        firstPart = getFieldFromString(inVal, Application.DecimalSeparator, 0)
        secPart = getFieldFromString(inVal, Application.DecimalSeparator, 1)
        ' Debug.Print ("    First:" & firstPart & "  Second:" & secPart)
         
        If (secPart = "") Then
            getValueAsDouble = TimeValue(firstPart)
        Else
            ' Debug.Print ("FirstPart: " & firstPart & "    Mid: " & Mid(firstPart, 2, 1))
            If ((Len(firstPart) = 4) And (Mid(firstPart, 2, 1) = ":")) Then   ' 2:30
                firstPart = "00:0" & firstPart
            ElseIf ((Len(firstPart) = 5) And (Mid(firstPart, 3, 1) = ":")) Then   ' 02:30
                firstPart = "00:" & firstPart
            End If
            ' Debug.Print ("firstPart: " & firstPart)
            firstPartD = TimeValue(firstPart)
            
            If (isStringMatchesRegEx(secPart, "\d")) Then
                secPartD = secPart / 864000
            Else
                secPartD = secPart / 8640000
            End If
            getValueAsDouble = firstPartD + secPartD
        End If
        
    ElseIf (isStringDecimalExponent(inVal)) Then
        getValueAsDouble = inVal
    Else
        getValueAsDouble = errorVal
    End If
    ' Debug.Print ("")
End Function

Public Function replaceStringInStringRegEx(ByVal iString As String, ByVal searchRegEx As String, Optional ByVal replaceValue As String = "") As String
    Dim retVal As String
    Set objRegEx = CreateObject("vbscript.regexp")
    With objRegEx
        .Global = True
        .IgnoreCase = True
        .MultiLine = False
        .pattern = searchRegEx
        retVal = .Replace(iString, replaceValue)
    End With
    Set objRegEx = Nothing
    replaceStringInStringRegEx = retVal
End Function

' String operationen mit regular expressions
Public Function isStringMatchesRegEx(ByVal inStr11 As String, ByVal regExStr As String, Optional ByVal doTrim As Boolean = True) As Boolean
    Dim objRegEx As Object, objMatch As Object
    Dim intIndex As Integer
    Dim retVal As Boolean
    
    If (doTrim) Then
        inStr11 = RTrim(LTrim(inStr11))
    End If
    
    Set objRegEx = CreateObject("vbscript.regexp")
    With objRegEx
        .Global = True
        .IgnoreCase = True
        .MultiLine = False
        .pattern = regExStr
        Set objMatch = .Execute(inStr11)
    End With
    intIndex = objMatch.Count
    If (intIndex = 1) Then
        retVal = (objMatch(intIndex - 1) = inStr11)
    Else
        retVal = False
    End If
    Set objRegEx = Nothing
    Set objMatch = Nothing
    
    isStringMatchesRegEx = retVal
End Function

' String operationen mit regular expressions
Public Function isStringContainsRegEx(ByVal inStr11 As String, ByVal regExStr As String, Optional ByVal doTrim As Boolean = True) As Boolean
    Dim objRegEx As Object, objMatch As Object
    Dim intIndex As Integer
    Dim retVal As Boolean
    
    If (doTrim) Then
        inStr11 = RTrim(LTrim(inStr11))
    End If
    
    Set objRegEx = CreateObject("vbscript.regexp")
    With objRegEx
        .Global = True
        .IgnoreCase = True
        .MultiLine = False
        .pattern = regExStr
        Set objMatch = .Execute(inStr11)
    End With
    intIndex = objMatch.Count
    If (intIndex = 1) Then
        retVal = strContains(inStr11, objMatch(intIndex - 1))
    Else
        retVal = False
    End If
    Set objRegEx = Nothing
    Set objMatch = Nothing
    
    isStringContainsRegEx = retVal
End Function

Public Function isStringTime(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As Boolean
    isStringTime = isStringMatchesRegEx(inStr11, time_RegEx, doTrim)
End Function

Public Function isStringDayTime(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As Boolean
    isStringDayTime = isStringMatchesRegEx(inStr11, daytime_RegEx, doTrim)
End Function

Public Function getStringTime(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As String
    If (isStringContainsRegEx(inStr11, time_RegEx, doTrim)) Then
        getStringTime = getStringsForRegEx(inStr11, time_RegEx)
    Else
        getStringTime = 0
    End If
End Function

Public Function getStringDayTime(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As String
    If (isStringContainsRegEx(inStr11, time_RegEx, doTrim)) Then
        getStringDayTime = getStringsForRegEx(inStr11, daytime_RegEx)
    Else
        getStringDayTime = 0
    End If
End Function

Public Function isStringDecimal(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As Boolean
    isStringDecimal = isStringMatchesRegEx(inStr11, float_RegEx, doTrim)
End Function

Public Function isStringDecimalExponent(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As Boolean
    isStringDecimalExponent = isStringMatchesRegEx(inStr11, floatPointExponent_RegEx, doTrim)
End Function

Public Function isStringPostiveInteger(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As Boolean
    isStringPostiveInteger = isStringMatchesRegEx(inStr11, integerPosive_RegEx, doTrim)
End Function

Public Function isStringInteger(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As Boolean
    isStringInteger = isStringMatchesRegEx(inStr11, integer_RegEx, doTrim)
End Function

Public Function isStringEmail(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As Boolean
    isStringEmail = isStringMatchesRegEx(inStr11, email_RegEx, doTrim)
End Function

Public Function isStringCifFormated(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As Boolean
    isStringCifFormated = isStringMatchesRegEx(inStr11, cifNoFormated_RegEx, doTrim)
End Function

Public Function isStringCif(ByVal inStr11 As String, Optional ByVal doTrim As Boolean = True) As Boolean
    isStringCif = isStringMatchesRegEx(inStr11, cifNo_RegEx, doTrim)
End Function

Public Function getStringsForRegEx(ByVal inStr11 As String, ByVal regExPattern As String, Optional ByVal sep As String = "  ;  ") As String
    Dim objRegEx As Object, objMatch As Object
    Dim retStr As String
    Dim intIndex As Integer
    Set objRegEx = CreateObject("vbscript.regexp")
    With objRegEx
        .Global = True
        .IgnoreCase = True
        .MultiLine = False
        .pattern = regExPattern
        Set objMatch = .Execute(inStr11)
    End With
    For intIndex = 0 To objMatch.Count - 1
        If (retStr = "") Then
            retStr = objMatch(intIndex)
        Else
            retStr = retStr & sep & objMatch(intIndex)
        End If
    Next
    Set objRegEx = Nothing
    Set objMatch = Nothing
    getStringsForRegEx = retStr
End Function


' Just an example
Sub regExBeispiel()
    Dim objRegEx As Object, objMatch As Object
    Dim strText As String
    Dim intIndex As Integer
    strText = "Die masse meiner Stereoanalge sind 40 x 20.33 x 0.30 x .34  0,30 0."
    Set objRegEx = CreateObject("vbscript.regexp")
    With objRegEx
        .Global = True
        .IgnoreCase = True
        .MultiLine = False
        .pattern = "([0-9]+[\.|,][0-9]*)|([0-9]*[\.|,][0-9]+)|([0-9]+)"
        Set objMatch = .Execute(strText)
    End With
    For intIndex = 0 To objMatch.Count - 1
        Debug.Print "--> " & objMatch(intIndex)
    Next
    Set objRegEx = Nothing
    Set objMatch = Nothing
End Sub

Public Function roundDoubleAsString(ByVal wert As Double, ByVal nachkommaStellen As Integer, Optional ByVal retStrIfZero As String = "EMPTY") As String
    Dim roundedVal As Double
    Dim roundedValStr As String
    Dim decTrenner As String
    Dim vorKomma As String
    Dim nachKomma As String
    
    decTrenner = Application.DecimalSeparator
    roundedVal = wert
    roundedVal = Math.Round(roundedVal, nachkommaStellen)
    roundedValStr = "" & roundedVal
    
    If (nachkommaStellen >= 0) Then
        roundedVal = Math.Round(roundedVal, nachkommaStellen)
        roundedValStr = "" & roundedVal
        If (strContains(roundedValStr, decTrenner)) Then
            vorKomma = getFieldFromString(roundedValStr, decTrenner, 0)
            nachKomma = getFieldFromString(roundedValStr, decTrenner, 1)
        Else
            vorKomma = getFieldFromString(roundedValStr, decTrenner, 0)
        End If
        If (vorKomma <> "") Then
            nachKomma = padString(nachKomma, "0", -nachkommaStellen)
            If (nachKomma = "") Then
                roundedValStr = vorKomma
            Else
                roundedValStr = vorKomma & decTrenner & nachKomma
            End If
        Else
            roundedValStr = ""
        End If
        
    End If
    If (roundedValStr = 0) And (retStrIfZero = "EMPTY") Then
        roundDoubleAsString = ""
    Else
        roundDoubleAsString = roundedValStr
    End If
End Function

Public Function roundDoubleAsString_OLD(ByVal wert As Double, ByVal nachkommaStellen As Integer) As String
    Dim roundedVal As Double
    roundedVal = wert
    If (nachkommaStellen >= 0) Then
        roundedVal = Math.Round(roundedVal, nachkommaStellen)
    End If
    roundDoubleAsString_OLD = "" & roundedVal
End Function

Public Function roundDoubleAsString_VERY_OLD(ByVal wert As Double, ByVal nachkommaStellen As Integer) As String
    Dim retString As String
    Dim roundFigure As String
    Dim isNegativ As Boolean
        
    nachkommaStellen = Abs(nachkommaStellen)
    retString = wert
    isNegativ = (wert <> Abs(wert))
    
    Dim decTrenner As String
    Dim thousTrenner As String
    decTrenner = Application.DecimalSeparator
    thousTrenner = Application.ThousandsSeparator
    
    Dim laenge As Integer
    laenge = Len(retString)
    stellen = Len(retString) - InStr(1, retString, decTrenner)
    If (InStr(1, retString, decTrenner) > 0) Then
        If (nachkommaStellen = 0) Then
            retString = left(retString, InStr(1, retString, decTrenner) - 1)
            roundFigure = Mid(wert, Len(retString) + 2, 1)
        ElseIf (nachkommaStellen < stellen) Then
            retString = left(retString, InStr(1, retString, decTrenner) + nachkommaStellen)
            roundFigure = Mid(wert, Len(retString) + 1, 1)
        ElseIf (nachkommaStellen = stellen) Then
            roundFigure = 0
        Else
            roundFigure = 0
        End If

        Dim i As Double
        i = 1
        For k = 1 To nachkommaStellen
            i = i / 10
        Next k
        
        If (roundFigure >= 5) Then
            If (isNegativ = True) Then
                retString = retString - i
            Else
                retString = retString + i
            End If
        End If
    End If
    roundDoubleAsString_VERY_OLD = retString
End Function

Public Function truncDoubleAsString(ByVal wert As Double, ByVal nachkommaStellen As Integer) As String
    Dim retString As String
    nachkommaStellen = Abs(nachkommaStellen)
    retString = wert
    
    Dim laenge As Integer
    laenge = Len(retString)
    stellen = Len(retString) - InStr(1, retString, Application.DecimalSeparator)
    If (InStr(1, retString, Application.DecimalSeparator) > 0) Then
        If (nachkommaStellen = 0) Then
            retString = left(retString, InStr(1, retString, Application.DecimalSeparator) - 1)
        ElseIf (nachkommaStellen < stellen) Then
            retString = left(retString, InStr(1, retString, Application.DecimalSeparator) + nachkommaStellen)
        End If
    End If
    
    truncDoubleAsString = retString
End Function

Public Function replaceSinglePlaceholder(ByVal iString As String, ByVal placeholder As String, ByVal placeholderValue As String) As String
    Dim retVal As String
    Dim startPos As Integer
    Dim endPos As Integer
    Dim startStr As String
    Dim endStr As String
    
    retVal = iString
    If (placeholder <> "") Then
        startPos = InStr(1, retVal, placeholder)
        Do While startPos > 0
            startPos = InStr(1, retVal, placeholder)
            If (startPos > 0) Then
                endPos = Len(retVal) - (startPos + Len(placeholder))
                
                startStr = left(retVal, startPos - 1)
                endStr = right(retVal, endPos + 1)
                
                retVal = startStr & placeholderValue & endStr
            End If
        Loop
    End If
    replaceSinglePlaceholder = retVal
End Function

Public Function parseString(ByVal textTemplate As String, ByVal paramTitleRange As Range, ByVal paramValueRange As Range, Optional ByVal placeHolderMarker As String = "", Optional ByVal titleMarker As String = "", Optional ByVal markerSeparator As String = ";") As String
    Dim retVal As String
    Dim paramTitleRangeStr As String
    Dim paramValueRangeStr As String
    Dim mappingTblSheetName As String
    mappingTblSheetName = paramTitleRange.Worksheet.name
    paramTitleRangeStr = paramTitleRange.Address(False, False, xlA1)
    paramValueRangeStr = paramValueRange.Address(False, False, xlA1)
    retVal = parseStringTemplate(textTemplate, mappingTblSheetName, paramTitleRangeStr, paramValueRangeStr, placeHolderMarker, titleMarker, markerSeparator)
    parseString = retVal
End Function


Public Function parseStringTemplate(ByVal textTemplate As String, ByVal mappingTblSheetName As String, ByVal paramTitleRange As String, ByVal paramValueRange As String, Optional ByVal placeHolderMarker As String = "", Optional ByVal titleMarker As String = "", Optional ByVal markerSeparator As String = ";") As String
    Dim retVal As String
    Dim parameterName As String
    Dim parameterValue As String
    Dim countOfColumns As Integer
    Dim countOfRows As Integer
    Dim countOfCells As Integer
    Dim placeHolderMarker_1 As String
    Dim placeHolderMarker_2 As String
    Dim titleMarker_1 As String
    Dim titleMarker_2 As String
    
    Dim i As Integer
    countOfColumns = columnCountFromRange(paramTitleRange)
    countOfRows = rowCountFromRange(paramTitleRange)
    
    If ((mappingTblSheetName = "") Or (Not (SheetExists(mappingTblSheetName)))) Then
        mappingTblSheetName = whichSheetSelected()
    End If
    
    ' check if range are one dimession and have the same amount of cells (titles and values)
    If (countOfColumns <> columnCountFromRange(paramValueRange)) Then
        retVal = "ERROR: Count of Columns are different between Titles and Values"
        GoTo FunctionReturn:
    End If
    If (countOfRows <> rowCountFromRange(paramValueRange)) Then
        retVal = "ERROR: Count of Rows are different between Titles and Values"
        GoTo FunctionReturn:
    End If
    If (countOfColumns > 1) Then
        If (countOfRows > 1) Then
            retVal = "ERROR: Ranges for Titles and Values can only be one dimessional"
            GoTo FunctionReturn:
        Else
            countOfCells = countOfColumns
        End If
    Else
        countOfCells = countOfRows
    End If
    
    If (placeHolderMarker <> "") Then
        placeHolderMarker_1 = getFieldFromString(placeHolderMarker, markerSeparator, 0)
        placeHolderMarker_2 = getFieldFromString(placeHolderMarker, markerSeparator, 1)
    Else
        placeHolderMarker_1 = ""
        placeHolderMarker_2 = ""
    End If
    
    If (titleMarker <> "") Then
        titleMarker_1 = getFieldFromString(titleMarker, markerSeparator, 0)
        titleMarker_2 = getFieldFromString(titleMarker, markerSeparator, 1)
    Else
        titleMarker_1 = ""
        titleMarker_2 = ""
    End If

ParameterOK:
    retVal = textTemplate
    For i = 0 To countOfCells - 1
        Dim paramTitle As String
        paramTitle = Sheets(mappingTblSheetName).Range(getAdrByAddingOffset(upperLeftFromRangeStr(paramTitleRange), i, 0)).Value
        If (paramTitle <> "") Then
            If (titleMarker_1 <> "") Then
                If (left(paramTitle, Len(titleMarker_1)) = titleMarker_1) Then
                    paramTitle = right(paramTitle, Len(paramTitle) - Len(titleMarker_1))
                Else
                    Debug.Print ("WARNING: parseString:" & paramTitle & ": starts not with :" & titleMarker_1 & ":")
                End If
            End If
            If (titleMarker_2 <> "") Then
                If (right(paramTitle, Len(titleMarker_2)) = titleMarker_2) Then
                    paramTitle = left(paramTitle, Len(paramTitle) - Len(titleMarker_2))
                Else
                    Debug.Print ("WARNING: parseString:" & paramTitle & ": ends not with :" & titleMarker_2 & ":")
                End If
            End If
            
            parameterName = placeHolderMarker_1 & paramTitle & placeHolderMarker_2
            parameterValue = "" & Sheets(mappingTblSheetName).Range(getAdrByAddingOffset(upperLeftFromRangeStr(paramValueRange), i, 0)).Value & ""
            retVal = replaceSinglePlaceholder(retVal, parameterName, parameterValue)
        Else
            Debug.Print ("WARNING: parseString: Title " & i & " is empty")
        End If
    Next i
    
FunctionReturn:
    parseStringTemplate = retVal
End Function

Public Function concatenateRange(filedsToConcatenate As Range, Optional ByVal countOf_LF_BetweenRangeFields As Integer = 2, Optional ByVal titleStr As String = "", Optional ByVal separetorStringBetweenRangeFields As String = "", Optional ByVal countOf_LF_AfterTitle As Integer = 1)
    Dim retVal As String

    Dim countOfColumns As Integer
    Dim countOfRows As Integer
    Dim i As Integer
    Dim j As Integer

    titleStr = titleStr & getLF(countOf_LF_AfterTitle)
    retVal = titleStr
    For i = 1 To filedsToConcatenate.Rows.Count
      For j = 1 To filedsToConcatenate.Columns.Count
        If (retVal = titleStr) Then
            retVal = retVal & filedsToConcatenate(i, j)
        Else
            retVal = retVal & getLF(countOf_LF_BetweenRangeFields) & separetorStringBetweenRangeFields & filedsToConcatenate(i, j)
        End If
      Next j
    Next i

    concatenateRange = retVal
End Function

Public Function getBooleanFromYesNo(ByVal aValue As String) As Boolean
    Dim retVal As Boolean
    retVal = False
    
    If UCase(aValue) = "JA" Or UCase(aValue) = "YES" Or UCase(aValue) = "J" Or UCase(aValue) = "Y" Then
        retVal = True
    End If
    getBooleanFromYesNo = retVal
End Function

' 51.02,51.03,51.04,52.10,52.11  --> 51.02 - 51.04, 52.10 - 52.11
Public Function compressSeats(ByVal inString As String, Optional ByVal sepStr As String = ";", Optional ByVal nachkommaStellen As Integer = 2, Optional ByVal fromToSep As String = " - ") As String
    Dim retStr As String
    
    Dim resArray
    Dim oldSeatNr As Integer
    Dim tmpSeatStr As String
    Dim seatNr As Integer
    Dim justAdded As Boolean
    Dim nachKommaMulti As Integer
        
    nachKommaMulti = powerTen(nachkommaStellen)
    inString = decompressSeats(inString)
    
    oldSeatNr = -10000
    tmpSeatStr = ""
    resArray = Split(inString, sepStr, -1, 1)
    For i = LBound(resArray) To UBound(resArray)
        Dim fieldStr As String
        justAdded = False
        fieldStr = resArray(i)
        RTrim (LTrim(fieldStr))
        seatNr = fieldStr * nachKommaMulti

        If (seatNr = oldSeatNr + 1) Then
            If (tmpSeatStr = "") Then
                tmpSeatStr = fromToSep
            End If
        Else
            If (tmpSeatStr <> "") Then
                tmpSeatStr = tmpSeatStr & (roundDoubleAsString(oldSeatNr / nachKommaMulti, nachkommaStellen))
            End If
            retStr = retStr & tmpSeatStr
            retStr = appendWithSepIfNotEmpty(retStr, sepStr, roundDoubleAsString(seatNr / nachKommaMulti, nachkommaStellen))
            tmpSeatStr = ""
            justAdded = True
        End If
        oldSeatNr = seatNr
    Next i

    If (justAdded = False) Then
        retStr = retStr & tmpSeatStr
        retStr = appendWithSepIfNotEmpty(retStr, sepStr, roundDoubleAsString(seatNr / nachKommaMulti, nachkommaStellen))
    End If
    retStr = replaceStringInString(retStr, fromToSep & sepStr, fromToSep)
    If (retStr = "0") Then
        retStr = ""
    End If
    
    compressSeats = retStr
End Function

' 51.02 - 51.04, 52.10 - 52.11  --> 51.02,51.03,51.04,52.10,52.11
Public Function decompressSeats(ByVal inString As String, Optional ByVal sepStr As String = ";", Optional ByVal nachkommaStellen As Integer = 2, Optional ByVal fromToSep As String = " - ") As String
    Dim retStr As String
    Dim resArray
    Dim nachKommaMulti As Integer
        
    nachKommaMulti = powerTen(nachkommaStellen)
    
    resArray = Split(inString, sepStr, -1, 1)
    For i = LBound(resArray) To UBound(resArray)
        Dim fieldStr As String
        fieldStr = resArray(i)
        RTrim (LTrim(fieldStr))

        If (strContains(fieldStr, fromToSep)) Then
            Dim fromZahl As Integer
            Dim toZahl As Integer
            
            fromZahl = getFieldFromString(fieldStr, fromToSep, 0) * nachKommaMulti
            toZahl = getFieldFromString(fieldStr, fromToSep, 1) * nachKommaMulti
            For ii = fromZahl To toZahl
                retStr = appendWithSepIfNotEmpty(retStr, sepStr, roundDoubleAsString(ii / nachKommaMulti, nachkommaStellen))
            Next ii
        Else
            retStr = appendWithSepIfNotEmpty(retStr, sepStr, fieldStr)
        End If
    Next i
    
    decompressSeats = retStr
End Function

' 52.10 - 52.11, 51.02 - 51.04,21.05,21.07   --> 21.05,21.07,51.02 - 51.04, 52.10 - 52.11
Public Function sortSeats(ByVal inString As String, Optional ByVal sepStr As String = ";", Optional ByVal nachkommaStellen As Integer = 2, Optional ByVal fromToSep As String = " - ", Optional ByVal doResultCompress As Boolean = True) As String
    Dim retStr As String
    Dim resArray
    Dim nachKommaMulti As Integer
    Dim isSorted As Boolean
        
    nachKommaMulti = powerTen(nachkommaStellen)
    inString = decompressSeats(inString, sepStr, nachkommaStellen, fromToSep)
    resArray = Split(inString, sepStr, -1, 1)
    
    ' clean array
    For i = LBound(resArray) To UBound(resArray)
        Dim fieldStr As String
        fieldStr = resArray(i)
        RTrim (LTrim(fieldStr))
        fieldStr = roundDoubleAsString(fieldStr, nachkommaStellen)
        resArray(i) = fieldStr
    Next
    
    ' sort array
    isSorted = False
    Do While (Not isSorted)
        isSorted = True
        For i = LBound(resArray) To UBound(resArray) - 1
            If (resArray(i) > resArray(i + 1)) Then
                Dim swapZahl As Double
                isSorted = False
                swapZahl = resArray(i)
                resArray(i) = resArray(i + 1)
                resArray(i + 1) = swapZahl
            End If
        Next i
    Loop
    
    ' writeArray
    For i = LBound(resArray) To UBound(resArray)
        retStr = appendWithSepIfNotEmpty(retStr, sepStr, resArray(i))
    Next
    
    If (doResultCompress) Then
        retStr = compressSeats(retStr, sepStr, nachkommaStellen, fromToSep)
    End If
    
    sortSeats = retStr
End Function


' csv String functions
' ======================================================

' fieldNr starts with 0
Public Function getFieldFromString( _
        ByVal inputString As String, _
        ByVal splitStr As String, _
        ByVal fieldNr As Integer, _
        Optional ByVal doTrim As Boolean = True, _
        Optional ByVal defaultRetVal As String = "") As String
        
   Dim resArray
   resArray = Split(inputString, splitStr, -1, 1)

   If ((fieldNr > UBound(resArray)) Or (fieldNr < LBound(resArray))) Then
        If (defaultRetVal = "TakeInputString") Then
            getFieldFromString = inputString
        Else
            getFieldFromString = defaultRetVal
        End If
   Else
        If (doTrim) Then
            getFieldFromString = RTrim(LTrim(resArray(fieldNr)))
        Else
            getFieldFromString = resArray(fieldNr)
        End If
   End If
End Function

Public Function getLastFieldFromString( _
        ByVal inputString As String, _
        ByVal splitStr As String, _
        Optional ByVal doTrim As Boolean = True, _
        Optional ByVal defaultRetVal As String = "") As String

    Dim fieldCount As Integer
    Dim tmpStr As String
    fieldCount = getCountOfFieldsInString(inputString, splitStr)
    tmpStr = getFieldFromString(inputString, splitStr, fieldCount - 1, doTrim, defaultRetVal)
    getLastFieldFromString = tmpStr
End Function
        
Public Function removeLastFieldFromString( _
        ByVal inputString As String, _
        ByVal splitStr As String, _
        Optional ByVal doTrim As Boolean = True) As String
        
    Dim fieldCount As Integer
    Dim tmpStr As String
    fieldCount = getCountOfFieldsInString(inputString, splitStr)
    tmpStr = removeFieldFromString(inputString, splitStr, fieldCount - 1, doTrim)
    removeLastFieldFromString = tmpStr
End Function

' fieldNr starts with 0
Public Function removeFieldFromString( _
        ByVal inputString As String, _
        ByVal splitStr As String, _
        Optional ByVal fieldNr As Integer = 0, _
        Optional ByVal doTrim As Boolean = True) As String
        
   Dim resArray
   resArray = Split(inputString, splitStr, -1, 1)
   Dim retStr As String
   retStr = ""

   If ((fieldNr > UBound(resArray)) Or (fieldNr < LBound(resArray))) Then
        removeFieldFromString = inputString
   Else
        For i = LBound(resArray) To UBound(resArray)
            If (i <> fieldNr) Then
                Dim aValue As String
                aValue = resArray(i)
                If (doTrim) Then
                    aValue = RTrim(LTrim(aValue))
                End If
        
                If (retStr = "") Then
                    retStr = aValue
                Else
                    retStr = retStr & splitStr & aValue
                End If
            End If
        Next i
   End If
   removeFieldFromString = retStr
End Function

Public Function removeFieldValueFromString( _
        ByVal inputString As String, _
        ByVal splitStr As String, _
        ByVal fieldValue As String, _
        Optional ByVal doTrim As Boolean = True) As String
        
    Dim resArray
    Dim retStr As String
    Dim aValue As String
        
    resArray = Split(inputString, splitStr, -1, 1)

    retStr = ""

    For i = LBound(resArray) To UBound(resArray)
        aValue = resArray(i)
        If (fieldValue <> aValue) Then
            If (doTrim) Then
                aValue = RTrim(LTrim(aValue))
            End If
    
            If (retStr = "") Then
                retStr = aValue
            Else
                retStr = retStr & splitStr & aValue
            End If
        End If
    Next i
    removeFieldValueFromString = retStr
End Function

Public Function areAllFieldsEqualInString(ByVal inputString As String, ByVal splitStr As String, Optional ByVal doTrim As Boolean = True) As Boolean
    Dim retVal As Boolean
    Dim lastFieldVal As String
    
    Dim resArray
    
    retVal = True
    resArray = Split(inputString, splitStr, -1, 1)
    If (doTrim) Then
        lastFieldVal = RTrim(LTrim(resArray(LBound(resArray))))
    Else
        lastFieldVal = resArray(LBound(resArray))
    End If
    
    For i = LBound(resArray) To UBound(resArray)
        Dim aValue As String
        aValue = resArray(i)
        If (doTrim) Then
            aValue = RTrim(LTrim(aValue))
        End If
        If (aValue <> lastFieldVal) Then
            retVal = False
        End If
    Next i
        
    areAllFieldsEqualInString = retVal
End Function

Public Function turnFieldsInString(ByVal inputString As String, ByVal splitStr As String) As String
   Dim retStr As String
   Dim resArray
   resArray = Split(inputString, splitStr, -1, 1)
   For i = LBound(resArray) To UBound(resArray)
        retStr = resArray(i) & splitStr & retStr
   Next i
   retStr = left(retStr, Len(retStr) - 1)
   turnFieldsInString = retStr
End Function

Public Function replaceFieldFromString( _
        ByVal inputString As String, _
        ByVal splitStr As String, _
        ByVal fieldNr As Integer, _
        ByVal replaceStr As String, _
        Optional ByVal doTrim As Boolean = True) As String
        
    Dim retStr As String
    Dim resArray
    resArray = Split(inputString, splitStr, -1, 1)
    For i = LBound(resArray) To UBound(resArray)
        Dim fieldStr As String
        If (i = fieldNr) Then
            fieldStr = replaceStr
        Else
            fieldStr = resArray(i)
        End If
        If (doTrim) Then
            RTrim (LTrim(fieldStr))
        End If
        If (retStr = "") Then
            retStr = fieldStr
        Else
            retStr = retStr & splitStr & fieldStr
        End If
    Next i


    replaceFieldFromString = retStr
End Function

Public Function swapFieldsFromString( _
        ByVal inputString As String, _
        ByVal splitStr As String, _
        ByVal fieldNr_1 As Integer, _
        ByVal fieldNr_2 As Integer, _
        Optional ByVal doTrim As Boolean = True, _
        Optional ByVal defaultRetVal As String = "") As String
        
        
    Dim retStr As String
    Dim field_1 As String
    Dim preStr As String
    Dim postStr As String
    Dim tmp As Integer
        
    If (fieldNr_1 > fieldNr_2) Then
        tmp = fieldNr_1
        fieldNr_1 = fieldNr_2
        fieldNr_2 = tmp
    End If
    field_1 = getFieldFromString(inputString, splitStr, fieldNr_1)
    field_2 = getFieldFromString(inputString, splitStr, fieldNr_2)
    preStr = getFieldFromString(inputString, field_1, 0)
    postStr = getFieldFromString(inputString, field_2, 1)
    
    retStr = preStr & field_2 & splitStr & field_1 & postStr
    swapFieldsFromString = retStr
End Function

Public Function getCountOfFieldsInString( _
        ByVal inputString As String, _
        ByVal splitStr As String) As Integer

    Dim resArray
    resArray = Split(inputString, splitStr, -1, 1)
    getCountOfFieldsInString = UBound(resArray) - LBound(resArray) + 1
End Function

' functions for Ranges
' ======================================================
'
' s_topLeftCell von Mehrzeiligen-Mehrspaltigen Title Matrizen
' +------+------+------+-----+----+
' |______|A     |B     |C    |D   |
' |aa    |Aaa   |Baa   |Caa  |Daa |
' |bb    |Abb   |Bbb   |Cbb  |Dbb |
' |cc    |Acc   |Bcc   |Ccc  |Dcc |
' |dd    |Add   |Bdd   |Cdd  |Ddd |
' |ee    |Aee   |Bee   |Cee  |Dee |
' |ff    |Aff   |Bff   |Cff  |Dff |
' |      |      |      |     |    |
' +------+------+------+-----+----+
Function MatrixToTable(ByVal s_bookPath As String, _
                    ByVal s_workbook As String, _
                    ByVal s_worksheet As String, _
                    ByVal s_topLeftCell As String, _
                    ByVal d_bookPath As String, _
                    ByVal d_workbook As String, _
                    ByVal d_worksheet As String, _
                    ByVal d_TopLeftCell As String, _
                    Optional s_farTopLeftCell As String = "", _
                    Optional writeNullValues As Boolean = True) As String
                    
    Dim tmpStr As String
    
    Dim matrixRowTitle As String
    Dim matrixColumnTitle As String
    Dim cellValue As String
    Const maxCountRowTitles As Integer = 100
    Const maxCountColumnTitles As Integer = 100
    
    
    Dim sourceRowTitleCounter As Integer
    Dim sourceColumnTitleCounter As Integer
    Dim sourceStartPointC As String
    Dim sourceActiveFiled As Integer
    
    Dim farTopLeftLetter As String
    Dim farTopLeftNumber As Integer
    
    Dim iSourceRow As Integer
    Dim iDestRow As Integer
    Dim iSourceColumn As String
    Dim iDestColumn As String
    Dim speicherZelle As String
    
    Dim sourceColumnActTitleHeader(maxCountColumnTitles) As String
    Dim sourceRowActTitleHeader(maxCountRowTitles) As String
    
    
    iSourceRow = GetRowIndexFromAdr(s_topLeftCell)
    iSourceColumn = getColumnLetterFromAdr(s_topLeftCell)
    iDestRow = GetRowIndexFromAdr(d_TopLeftCell)
    iDestColumn = getPrevColumnLetter(getColumnLetterFromAdr(d_TopLeftCell))

    tmpStr = WorkSheetExistsOrCreate(d_workbook, d_worksheet)
    
    If (s_workbook <> d_workbook) Then
        Workbooks.Open filename:=s_bookPath & s_workbook
    End If
    
    'if to check for the optional parameter farTopLeftCell
    If (s_farTopLeftCell <> "") Then
        farTopLeftNumber = GetRowIndexFromAdr(s_farTopLeftCell)
        farTopLeftLetter = getColumnLetterFromAdr(s_farTopLeftCell)
        sourceColumnTitleCounter = (iSourceRow - (farTopLeftNumber - 1))
        sourceRowTitleCounter = GetColumnIndexFromColumnLetter(iSourceColumn) - GetColumnIndexFromColumnLetter(farTopLeftLetter) + 1
    Else
        Dim finished As Boolean
        finished = False
        sourceColumnTitleCounter = 0
        Do While Not finished
            If ((iSourceRow - sourceRowTitleCounter) > 0) Then
                If (IsEmpty((Sheets(s_worksheet).Cells(iSourceRow - sourceRowTitleCounter, GetColumnIndexFromColumnLetter(iSourceColumn) + 1)))) Then
                    finished = True
                Else
                    sourceRowTitleCounter = sourceRowTitleCounter + 1
                End If
            Else
                finished = True
            End If
        Loop
        
        finished = False
        sourceRowTitleCoutner = 0
        Do While Not finished
            If (((GetColumnIndexFromColumnLetter(iSourceColumn) - sourceColumnTitleCounter) > 0)) Then
                If (IsEmpty((Sheets(s_worksheet).Cells(iSourceRow + 1, GetColumnIndexFromColumnLetter(iSourceColumn) - sourceColumnTitleCounter)))) Then
                    finished = True
                Else
                    sourceColumnTitleCounter = sourceColumnTitleCounter + 1
                End If
            Else
                   finished = True
            End If
        Loop
    End If
    
    iSourceRow = iSourceRow + 1
    iDestRow = iDestRow

    Do Until (Workbooks(s_workbook).Worksheets(s_worksheet).Range(getColumnLetterFromAdr(s_topLeftCell) & iSourceRow) = "")
        'rowDown
        ' matrixRow = Workbooks(s_workbook).Worksheets(s_worksheet).Range(getColumnLetterFromAdr(s_topLeftCell) & iSourceRow)
        iSourceColumn = getNextColumnLetter(iSourceColumn)
    
        Do Until (Workbooks(s_workbook).Worksheets(s_worksheet).Range(iSourceColumn & GetRowIndexFromAdr(s_topLeftCell)) = "")
            'columnSideways
            cellValue = Workbooks(s_workbook).Worksheets(s_worksheet).Range(iSourceColumn & iSourceRow)
            
            Dim writeRowCounter As Integer
            writeRowCounter = sourceRowTitleCounter
            Dim writeColumnCounter As Integer
            writeColumnCounter = sourceColumnTitleCounter
            
            ' inhalt in neue mappe schreiben
            If ((writeNullValues) Or (cellValue <> "")) Then
            
                iDestColumn = getNextColumnLetter(iDestColumn)
                '----------------------------------------------------------------'
                Do While (writeColumnCounter <> 0)
                    matrixColumnTitle = Workbooks(s_workbook).Worksheets(s_worksheet).Range(getAdrByAddingOffset(iSourceColumn & GetRowIndexFromAdr(s_topLeftCell), 0, 1 - writeColumnCounter)).Value
                     
                     If (matrixColumnTitle <> "") Then
                      sourceColumnActTitleHeader(writeColumnCounter) = matrixColumnTitle
                     End If
                     
                    Worksheets(d_worksheet).Range(iDestColumn & iDestRow) = sourceColumnActTitleHeader(writeColumnCounter)
                    iDestColumn = getNextColumnLetter(iDestColumn)
                    writeColumnCounter = writeColumnCounter - 1
                Loop
                '----------------------------------------------------------------'
                Do While (writeRowCounter <> 0)
                    matrixRowTitle = Workbooks(s_workbook).Worksheets(s_worksheet).Range(getAdrByAddingOffset(getNextColumnLetter(getColumnLetterFromAdr(s_topLeftCell)) & iSourceRow, 0 - writeRowCounter, 0)).Value
                    
                    If (matrixRowTitle <> "") Then
                      sourceRowActTitleHeader(writeRowCounter) = matrixRowTitle
                    End If
                    
                    Workbooks(d_workbook).Worksheets(d_worksheet).Range(iDestColumn & iDestRow) = sourceRowActTitleHeader(writeRowCounter)
                    iDestColumn = getNextColumnLetter(iDestColumn)
                    writeRowCounter = writeRowCounter - 1
                Loop
                Workbooks(d_workbook).Worksheets(d_worksheet).Range(iDestColumn & iDestRow) = cellValue
                iDestRow = iDestRow + 1
            End If
            iSourceColumn = getNextColumnLetter(iSourceColumn)
            iDestColumn = getPrevColumnLetter(getColumnLetterFromAdr(d_TopLeftCell))
        Loop
        writeColumnCounter = sourceColumnTitleCounter
        writeRowCounter = sourceRowTitleCounter
        iSourceRow = iSourceRow + 1
        iSourceColumn = getColumnLetterFromAdr(s_topLeftCell)
        iDestColumn = getPrevColumnLetter(getColumnLetterFromAdr(d_TopLeftCell))
    Loop
    Workbooks(d_workbook).Activate
    Workbooks(d_workbook).Save
    MatrixToTable = iDestColumn & iDestRow
End Function



Function copyTable(ByVal s_bookPath As String, _
                    ByVal s_workbook As String, _
                    ByVal s_worksheet As String, _
                    ByVal s_topLeftCell As String, _
                    ByVal d_bookPath As String, _
                    ByVal d_workbook As String, _
                    ByVal d_worksheet As String, _
                    ByVal d_TopLeftCell As String)
                    
    Dim zeile As Integer
    Dim iSourceRow As Integer
    Dim iDestRow As Integer
    Dim iSourceColumn As String
    Dim iDestColumn As String
    Dim speicherZelle As String
    
    Application.Workbooks.Open s_bookPath & s_workbook
    
    iSourceRow = GetRowIndexFromAdr(s_topLeftCell)
    iSourceColumn = getColumnLetterFromAdr(s_topLeftCell)
    
    iDestRow = GetRowIndexFromAdr(d_TopLeftCell)
    iDestColumn = getColumnLetterFromAdr(d_TopLeftCell)

    Do Until (Workbooks(s_workbook).Worksheets(s_worksheet).Range(iSourceColumn & iSourceRow) = "")
        Workbooks(d_workbook).Worksheets(d_worksheet).Range(iDestColumn & iDestRow) = s_workbook
        iDestColumn = getNextColumnLetter(iDestColumn)
        Do Until (Workbooks(s_workbook).Worksheets(s_worksheet).Range(iSourceColumn & iSourceRow) = "")
            Workbooks(d_workbook).Worksheets(d_worksheet).Range(iDestColumn & iDestRow) = Workbooks(s_workbook).Worksheets(s_worksheet).Range(iSourceColumn & iSourceRow)
            iSourceColumn = getNextColumnLetter(iSourceColumn)
            iDestColumn = getNextColumnLetter(iDestColumn)
        Loop
        iSourceRow = iSourceRow + 1
        iDestRow = iDestRow + 1
        iSourceColumn = getColumnLetterFromAdr(s_topLeftCell)
        iDestColumn = getColumnLetterFromAdr(d_TopLeftCell)
    Loop
    copyTable = True
End Function


' Bullet List functions
' ======================================================
Function writeBulletListInCel(ByVal shName As String, ByVal cellAdr As String, inArr As Variant) As Boolean
    Sheets(shName).Range(cellAdr).Value = formatAsBulletList(inArr)
    writeBulletListInCel = True
End Function

Function fmtAsBulletList(multiLineStr As String, Optional lineSepStr As String = ";", Optional bulletChr As String = "• ") As String
    Dim testArr_1() As Variant
    testArr_1 = splitStringByDelimiterStr(multiLineStr, lineSepStr)
    ' displayArray (testArr_1)
    fmtAsBulletList = formatAsBulletList(testArr_1, bulletChr)
End Function

Function formatAsBulletList(inArr As Variant, Optional bulletChr As String = "• ") As String
    Dim retString As String
    Dim bulletNum As String
    Dim bulletType As Integer  ' 0 = default bullet   1 = letter bullet    2 = number bullet
    Dim bulletPreTxt As String
    Dim bulletPostTxt As String
    
    bulletPreTxt = ""
    bulletPostTxt = ""
    
    bulletNum = getStringsForRegEx(bulletChr, "[0-9]+")
    If bulletNum = "" Then
        bulletNum = getStringsForRegEx(bulletChr, "[A-Z]|[a-z]")
        If bulletNum = "" Then
            bulletNum = bulletChr
            bulletType = 0
        Else
            bulletPreTxt = getFieldFromString(bulletChr, bulletNum, 0, False, "")
            bulletPostTxt = getFieldFromString(bulletChr, bulletNum, 1, False, "")
            bulletType = 1
        End If
    Else
        bulletPreTxt = getFieldFromString(bulletChr, bulletNum, 0, False, "")
        bulletPostTxt = getFieldFromString(bulletChr, bulletNum, 1, False, "")
        bulletType = 2
    End If
    
    
    retString = ""
    For i = LBound(inArr) To UBound(inArr)
        If Not i = LBound(inArr) Then
            retString = retString & Chr(10)
        End If
        
        retString = retString & bulletPreTxt & bulletNum & bulletPostTxt & inArr(i)
    
        If bulletType = 1 Then
            bulletNum = Chr(Asc(bulletNum) + 1)
        ElseIf bulletType = 2 Then
            bulletNum = bulletNum + 1
        End If
        
    Next i
    formatAsBulletList = retString
End Function

' Array functions
' ======================================================
Sub Test_foundInArray()
   Dim testArr_1() As Variant
   Dim testArr_2() As Variant
   Dim resArr_1() As Variant
   
   Dim retVal As Boolean
   
   testArr_1 = Array("7", "1", "2", "3", "4")
   retVal = foundInArray(testArr_1, "3")
   ' Debug.Print retVal
   
   retVal = foundInArray(testArr_1, "6")
   ' Debug.Print retVal
   
   testArr_2 = Array("2", "3", "4", "5", "6", "7")
   'displayArray (testArr_2)
   'Debug.Print ""
   
   testArr_2 = wPush(testArr_2, "Walti")
   'displayArray (testArr_2)
   'Debug.Print ""
      
   resArr_1 = getIntersectionOfArrays(testArr_1, testArr_2)
   'displayArray (resArr_1)
   'Debug.Print ""
   'displayArray (testArr_1)
   'Debug.Print ""
   'displayArray (testArr_2)
   'Debug.Print ""


   resArr_1 = getUnionOfArrays(testArr_1, testArr_2)
   'displayArray (resArr_1)
   'Debug.Print ""
   'displayArray (testArr_1)
   'Debug.Print ""
   'displayArray (testArr_2)
   'Debug.Print ""

   resArr_1 = getExclutionOfArrays(testArr_1, testArr_2)
   'displayArray (resArr_1)
   'Debug.Print ""
   'displayArray (testArr_1)
   'Debug.Print ""
   'displayArray (testArr_2)
   'Debug.Print ""
   
   testArr_1 = Array("4", "6", "8")
   testArr_2 = Array("9", "2", "3", "4", "5", "6", "8", "1", "7")
   resArr_1 = getExclutionOfArrays(testArr_1, testArr_2)
   displayArray (resArr_1)
   Debug.Print ""
   displayArray (testArr_1)
   Debug.Print ""
   displayArray (testArr_2)
   Debug.Print ""


   testArr_1 = splitStringByChar("Walti")
   'displayArray (testArr_1)
   Call swapArrayFields(testArr_1, 3, 1)
   'displayArray (testArr_1)
   'Debug.Print "Size:" & arraySize(testArr_1)
End Sub

Sub swapArrayFields(ByRef inArr1 As Variant, i1 As Integer, i2 As Integer)
   Dim tmp As Variant

   If (((i1 >= LBound(inArr1)) And (i1 <= UBound(inArr1))) And _
       ((i2 >= LBound(inArr1)) And (i2 <= UBound(inArr1)))) Then
      tmp = inArr1(i1)
      inArr1(i1) = inArr1(i2)
      inArr1(i2) = tmp
   End If
End Sub

Sub displayArray(inArr As Variant)
   For i = LBound(inArr) To UBound(inArr)
      Debug.Print i & ":" & inArr(i)
   Next i
End Sub

Sub display2DimArray(inArr As Variant)
  Dim i As Integer
  Dim j As Integer
 
  Dim linstr As String
  Debug.Print "Two Dim Array"
  For i = LBound(inArr, 1) To UBound(inArr, 1)
    linstr = i & ": "
    For j = LBound(inArr, 2) To UBound(inArr, 2)
        linstr = linstr & padString(inArr(i, j), " ", 5) & " ; "
    Next j
    Debug.Print linstr
  Next i
End Sub

Public Function getArrayFrom2DimArray(inArr As Variant, ByVal arrNr As Integer) As Variant
    Dim retValFinal() As Variant
    retValFinal = Array()
    Dim j As Integer
    For j = LBound(inArr, 2) To UBound(inArr, 2)
        ' Debug.Print " " & inArr(arrNr, J)
        retValFinal = wPush(retValFinal, inArr(arrNr, j))
    Next j
    getArrayFrom2DimArray = retValFinal
 End Function

Public Function removeElementFromArrayByIndex(inArr() As Variant, ByVal index As Integer) As Variant
    Dim i As Integer
    Dim retValFinal() As Variant
    retValFinal = Array()

    For i = LBound(inArr) To UBound(inArr)
        If (i <> index) Then
            retValFinal = wPush(retValFinal, inArr(i))
        End If
    Next
    removeElementFromArrayByIndex = retValFinal
End Function

Public Sub removeElementFromArrayByValxxxxx(inArr() As Variant, ByVal val As String, Optional ByVal once As Boolean = True)
    Dim i As Integer
    Dim retValFinal() As Variant
    retValFinal = Array()
    Dim onlyCopy As Boolean
    onlyCopy = False
    Dim chrLeftOut As Integer
    chrLeftOut = 0
    
    
    For i = LBound(inArr) To UBound(inArr)
        If (onlyCopy = True) Then
            retValFinal = wPush(retValFinal, inArr(i))
        Else
            If (inArr(i) = val) Then
                chrLeftOut = chrLeftOut + 1
                If (once = True) Then
                    onlyCopy = True
                End If
            Else
                retValFinal = wPush(retValFinal, inArr(i))
            End If
        End If
    Next
    For i = 1 To chrLeftOut
        retValFinal = wPush(retValFinal, "!!!EMPTY!!!")
    Next
    removeElementFromArrayByVal = retValFinal()
End Sub

Public Sub DeleteArrayItem(ItemArray As Variant, ByVal valToRemove As String)
    Dim i As Long
    Dim ItemElement As Long
    ItemElement = LBound(ItemArray)
    
    If Not IsArray(ItemArray) Then
        Err.Raise 13, , "Type Mismatch"
        Exit Sub
    End If
    If ItemElement < LBound(ItemArray) Or ItemElement > UBound(ItemArray) Then
        Err.Raise 9, , "Subscript out of Range"
        Exit Sub
    End If
    For i = ItemElement To lTop - 1
        If (ItemArray(i) = valToRemove) Then
            ItemArray(i) = ItemArray(i + 1)
        End If
    Next
    On Error GoTo ErrorHandler:
    ReDim Preserve ItemArray(LBound(ItemArray) To UBound(ItemArray) - 1)
    Exit Sub
ErrorHandler:
    '~~> An error will occur if array is fixed
    Err.Raise Err.Number, , _
    "Array not resizable."
End Sub

Public Function arraySize(inArr() As Variant) As Integer
    arraySize = UBound(inArr) - LBound(inArr) + 1
End Function

Public Sub ReDim2DimArray(ByRef MyArray As Variant, _
  ByVal iDimX As Integer, _
  ByVal iDimY As Integer)
 
  Dim MyTempArray As Variant
  Dim i As Integer
  Dim j As Integer
 
  MyTempArray = MyArray
 
  ReDim MyArray(iDimX, iDimY)
 
  For i = LBound(MyTempArray, 1) To UBound(MyTempArray, 1)
    For j = LBound(MyTempArray, 2) To UBound(MyTempArray, 2)
      If i <= iDimX And j <= iDimY Then
        MyArray(i, j) = MyTempArray(i, j)
      End If
    Next j
  Next i
End Sub

Public Function wPush(inArr As Variant, newValue As Variant) As Variant
   Dim retArr() As Variant
   Dim lowerIndex As Integer
   Dim upperIndex As Integer
   lowerIndex = LBound(inArr)
   upperIndex = UBound(inArr)
   ReDim retArr(lowerIndex To upperIndex + 1)
   For i = LBound(inArr) To UBound(inArr)
      retArr(i) = inArr(i)
   Next i
   If (newValue <> "!!!EMPTY!!!") Then
        retArr(UBound(inArr) + 1) = newValue
   End If
   wPush = retArr
End Function

Public Function foundInArray(inArr() As Variant, inValue As Variant) As Boolean
   Dim retVal As Boolean
   retVal = False
   
   For Each aVal In inArr
      If aVal = inValue Then
         retVal = True
         Exit For
      End If
   Next aVal
   foundInArray = retVal
End Function

Public Function getArrayIndex(inArr() As Variant, inValue As Variant) As Integer
   Dim retVal As Integer
   Dim arrIndex As Integer
   
   arrIndex = 1
   
   For Each aVal In inArr
      If aVal = inValue Then
         retVal = arrIndex
         Exit For
      End If
      arrIndex = arrIndex + 1
   Next aVal
   getArrayIndex = retVal
End Function

Public Function initArray(inArr() As Variant, ByVal initValue As Variant, ByVal arrLength As Integer) As Variant
    Dim i As Integer
    For i = 1 To arrLength
        inArr = wPush(inArr, initValue)
    Next i
    initArray = ""
End Function

Public Function setArrayField(inArr() As Variant, ByVal newValue As Variant, ByVal pos As Integer) As Variant
    inArr(pos) = newValue
    setArrayField = ""
End Function


'Returns each element in the given array in one string. The elemenets will be separated by the given delimiter (default: ";")
Public Function arrToString(ByVal inputArray As Variant, Optional ByVal delimiter As String = ";") As String
    For i = LBound(inputArray) To UBound(inputArray)
        If i = LBound(inputArray) Then
            arrToString = inputArray(i)
        Else
            arrToString = arrToString & delimiter & inputArray(i)
        End If
    Next i
End Function

Public Function arrayToString(inArr() As Variant, ByVal sep As String, Optional ByVal preStr As String = "", Optional ByVal postStr As String = "") As String
    Dim retStr As String
    Dim aVal As Variant
    
    For Each aVal In inArr
        If aVal <> "" Then
            If retStr = "" Then
                retStr = preStr & aVal & postStr
            Else
                retStr = retStr & sep & preStr & aVal & postStr
            End If
        End If
    Next aVal
    arrayToString = retStr
End Function

Public Function clearArrayFields(inArr As Variant, Optional ByVal newValue As String = "", Optional ByVal fromIndex As Integer = 0) As String
    Dim lowerIndex As Integer
    Dim upperIndex As Integer
    Dim i As Integer
    lowerIndex = LBound(inArr)
    upperIndex = UBound(inArr)
   
    For i = fromIndex To UBound(inArr)
        inArr(i) = newValue
    Next i
    clearArrayFields = ""
End Function

Public Function getPathInTree( _
        ByVal endRow As String, _
        Optional ByVal sheetName As String = "", _
        Optional ByVal topLeftCellOfTree As String = "A1", _
        Optional ByVal delimiter As String = "\", _
        Optional ByVal preFix As String = "", _
        Optional ByVal postFix As String = "") As String

    Dim endCell As String
    Dim firstRow As Integer
    Dim firstCol As String
    Dim currRow As Integer
    Dim currCol As String
    Dim iRow As Integer
    Dim iCol As String
    
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    
    firstRow = GetRowIndexFromAdr(topLeftCellOfTree)
    firstCol = getColumnLetterFromAdr(topLeftCellOfTree)
    currRow = GetRowIndexFromAdr(endRow)
    currCol = getColumnLetterFromAdr(endRow)
    If (currCol = "") Then
        currCol = firstCol
        endCell = currCol & currRow
    Else
        endCell = endRow
    End If
    

    Dim treeStr As String
    Dim loopEnd As Boolean
    loopEnd = False
    
    If (firstCol = currCol) Then
        If (firstRow = currRow) Then
            treeStr = Worksheets(sheetName).Range(topLeftCellOfTree).Value
        Else
            Do
                endCell = getAdrByAddingOffset(endCell, getNextFilledColumnRelative(sheetName, endCell), 0)
                If (treeStr = "") Then
                    treeStr = Worksheets(sheetName).Range(endCell).Value
                Else
                    treeStr = Worksheets(sheetName).Range(endCell).Value & delimiter & treeStr
                End If
                If getColumnLetterFromAdr(endCell) = firstCol Then
                    loopEnd = True
                Else
                    endCell = getAdrByAddingOffset(endCell, -1, 0)
                    endCell = getAdrByAddingOffset(endCell, 0, getPrevFilledRowRelative(sheetName, endCell))
                End If
            Loop Until loopEnd
        End If
    End If
    

    getPathInTree = preFix & treeStr & postFix
End Function

Public Function isTreeEndPoint( _
        ByVal endRow As String, _
        Optional ByVal sheetName As String = "", _
        Optional ByVal topLeftCellOfTree As String = "A1") As Boolean
      
    Dim endCell As String
    Dim firstRow As Integer
    Dim firstCol As String
    Dim currRow As Integer
    Dim currCol As String
    Dim iRow As Integer
    Dim iCol As String
    
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    
    firstRow = GetRowIndexFromAdr(topLeftCellOfTree)
    firstCol = getColumnLetterFromAdr(topLeftCellOfTree)
    currRow = GetRowIndexFromAdr(endRow)
    currCol = getColumnLetterFromAdr(endRow)
    If (currCol = "") Then
        currCol = firstCol
        endCell = currCol & currRow
    Else
        endCell = endRow
    End If
    

    Dim retVal As Boolean
    
    If (firstCol = currCol) Then
        If (firstRow = currRow) Then
            endCell = topLeftCellOfTree
        Else
            endCell = getAdrByAddingOffset(endCell, getNextFilledColumnRelative(sheetName, endCell), 0)
        End If
    End If
    
    
    If (Worksheets(sheetName).Range(getAdrByAddingOffset(endCell, 1, 1)).Value = "") Then
        retVal = True
    Else
        retVal = False
    End If
    
    isTreeEndPoint = retVal
End Function

        
Public Function walkTroughtTree( _
        Optional ByVal sheetName As String = "", _
        Optional ByVal topLeftCell As String = "A1", _
        Optional ByVal delimiter As String = "\", _
        Optional ByVal preFix As String = "", _
        Optional ByVal postFix As String = "", _
        Optional ByVal attrDelim As String = "::::::") As Variant
        
    Dim retArr() As Variant
    Dim currCell As String
    Dim dirLevel As Integer
    Dim dirPathArr() As Variant
    Dim tmp As Variant
    Dim endFound As Boolean
    Dim tmpStr As String
    
    dirPathArr = Array()
    retArr = Array()

    tmp = initArray(dirPathArr, "", 20)

    endFound = False
    
    currCell = topLeftCell
    dirLevel = 1
    
    Do Until endFound
        If dirLevel = 1 And Sheets(sheetName).Range(currCell).Value = "" Then
            endFound = True
        Else
            tmp = setArrayField(dirPathArr, Sheets(sheetName).Range(currCell).Value, dirLevel - 1)
            tmp = clearArrayFields(dirPathArr, "", dirLevel)
            ' Debug.Print "Case 0: " & arrayToString(dirPathArr, delimiter)
            ' displayArray (dirPathArr)
            ' Debug.Print ""
            If isDirIdent(sheetName, getAdrByAddingOffset(currCell, 0, 1)) Then ' cell tiefer gesetzt ==> Struktur auf gleichem Level
                tmpStr = getDoubleQuote & preFix & arrayToString(dirPathArr, delimiter) & postFix & getDoubleQuote & addDirAttr(sheetName, currCell, attrDelim)
                ' Debug.Print "Case 2 (" & currCell & "): "; tmpStr
                retArr = wPush(retArr, tmpStr)
                currCell = getAdrByAddingOffset(currCell, 0, 1)
            ElseIf isDirIdent(sheetName, getAdrByAddingOffset(currCell, 1, 1)) Then ' cell rechts tiefer gesetzt ==> Struktur geht tiefer
                currCell = getAdrByAddingOffset(currCell, 1, 1)
                dirLevel = dirLevel + 1
            Else
                tmpStr = getDoubleQuote & preFix & arrayToString(dirPathArr, delimiter) & postFix & getDoubleQuote & addDirAttr(sheetName, currCell, attrDelim)
                ' Debug.Print "Case 3 (" & currCell & "): "; tmpStr
                retArr = wPush(retArr, tmpStr)
                currCell = getAdrByAddingOffset(currCell, 0, 1)
                Do Until isDirIdent(sheetName, currCell) Or dirLevel <= 1
                    currCell = getAdrByAddingOffset(currCell, -1, 0)
                    dirLevel = dirLevel - 1
                Loop
            End If
        End If
    Loop
    walkTroughtTree = retArr
End Function

Public Function isDirIdent(ByVal sheetName As String, ByVal currCell As String) As Boolean
    Dim retVal As Boolean
    retVal = False
    
    If Sheets(sheetName).Range(currCell).Value <> "" Then
        If (Not strStarts(Sheets(sheetName).Range(currCell).Value, ":")) Then
            retVal = True
        End If
    End If
    isDirIdent = retVal
End Function

Public Function addDirAttr(ByVal sheetName As String, ByVal currCell As String, ByVal delim As String) As String
    Dim attrStr As String
    attrStr = ""
    If Sheets(sheetName).Range(getAdrByAddingOffset(currCell, 1, 0)).Value <> "" Then
        attrStr = delim & Sheets(sheetName).Range(getAdrByAddingOffset(currCell, 1, 0)).Value
    End If
    addDirAttr = attrStr
End Function

Public Function getValueStringFromRange(ByVal matrixRange As Range, Optional ByVal byColumn As Boolean = True, Optional ByVal separatorStr As String = ";") As String
    Dim retVal As String
    Dim rangeAdrStr As String
    Dim retArr() As Variant
        
    rangeAdrStr = getStringRangeFromRange(matrixRange)
    retArr = get2D_RangeIntoArray("", upperLeftFromRangeStr(rangeAdrStr), lowerRigthFromRange(rangeAdrStr), byColumn)

    retVal = arrayToString(retArr, separatorStr)
    
    getValueStringFromRange = retVal
End Function

' loads a list (vertical or horizontal) into an array
Public Function get2D_RangeIntoArray( _
            Optional ByVal sheetName As String = "", _
            Optional ByVal startCell As String = "A1", _
            Optional endCell As String = "", _
            Optional vertical As Boolean = True) As Variant
    Dim horizontalDimension As Integer
    Dim vertikalDimension As Integer
    
    Dim retArr() As Variant
    retArr = Array()
    
    Dim iCell As String
    
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    If (endCell = "") Then
        If (vertical = True) Then
            endCell = getAdrByAddingOffset(startCell, 0, getLastRowRelative(sheetName, startCell) - 1)
        Else
            endCell = getAdrByAddingOffset(startCell, getLastColumnRelative(sheetName, startCell) - 1, 0)
        End If
    End If
    
    iCell = startCell
    Dim done As Boolean
    
    horizontalDimension = columnCountFromRange(startCell & ":" & endCell)
    vertikalDimension = rowCountFromRange(startCell & ":" & endCell)

    If (vertical = False) Then
        For iv = 0 To vertikalDimension - 1
            For ih = 0 To horizontalDimension - 1
                iCell = getAdrByAddingOffset(startCell, ih, iv)
                retArr = wPush(retArr, Sheets(sheetName).Range(iCell).Value)
            Next ih
        Next iv
    Else
        For ih = 0 To horizontalDimension - 1
            For iv = 0 To vertikalDimension - 1
                iCell = getAdrByAddingOffset(startCell, ih, iv)
                retArr = wPush(retArr, Sheets(sheetName).Range(iCell).Value)
            Next iv
        Next ih
    End If
    get2D_RangeIntoArray = retArr
End Function

' loads a list (vertical or horizontal) into an array
Public Function getRangeIntoArray( _
            Optional ByVal sheetName As String = "", _
            Optional ByVal startCell As String = "A1", _
            Optional endCell As String = "", _
            Optional vertical As Boolean = True) As Variant
    Dim retArr() As Variant
    retArr = Array()
    
    Dim iCell As String
    
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    If (endCell = "") Then
        If (vertical = True) Then
            endCell = getAdrByAddingOffset(startCell, 0, getLastRowRelative(sheetName, startCell) - 1)
        Else
            endCell = getAdrByAddingOffset(startCell, getLastColumnRelative(sheetName, startCell) - 1, 0)
        End If
    End If
    
    iCell = startCell
    Dim done As Boolean

    Do
        retArr = wPush(retArr, Sheets(sheetName).Range(iCell).Value)
        If (iCell = endCell) Then Exit Do
        If (vertical = True) Then
            iCell = getAdrByAddingOffset(iCell, 0, 1)
        Else
            iCell = getAdrByAddingOffset(iCell, 1, 0)
        End If
    Loop
   
    getRangeIntoArray = retArr
End Function

' loads a list (vertical one) having an optional title into an array
Public Function getListeInArray( _
        Optional ByVal sheetName As String = "", _
        Optional ByVal topCell As String = "A1", _
        Optional ByVal listName As String = "") As Variant
    Dim retArr() As Variant
    Dim currCell As String
    retArr = Array()
    currCell = topCell
    Do Until Sheets(sheetName).Range(currCell).Value = listName Or Sheets(sheetName).Range(currCell).Value = ""
        currCell = getAdrByAddingOffset(currCell, 0, 1)
    Loop
    currCell = getAdrByAddingOffset(currCell, 0, 1)
    Do Until strStarts(Sheets(sheetName).Range(currCell).Value, ":") Or Sheets(sheetName).Range(currCell).Value = ""
        retArr = wPush(retArr, Sheets(sheetName).Range(currCell).Value)
        currCell = getAdrByAddingOffset(currCell, 0, 1)
    Loop
    
    
    getListeInArray = retArr
End Function

Public Function getIntersectionOfArrays(arr1() As Variant, arr2() As Variant) As Variant
   Dim aVal1 As Variant
   Dim arr1a() As Variant
   Dim arr2a() As Variant
   Dim doShift As Boolean
   doShift = False
   
   Dim retValFinal() As Variant
   retValFinal = Array()
   
   For Each aVal1 In arr1
      If (foundInArray(arr2, aVal1)) Then
         retValFinal = wPush(retValFinal, aVal1)
         
         ' remove found value in arr2
         For i = LBound(arr2) To UBound(arr2) - 1
              If (doShift = True) Then
                 arr2(i) = arr2(i + 1)
              Else
                If (arr2(i) = aVal1) Then
                    doShift = True
                End If
              End If
        Next
        arr2(UBound(arr2)) = ""
      End If
   Next aVal1
   getIntersectionOfArrays = retValFinal
End Function

Public Function getUnionOfArrays(arr1() As Variant, arr2() As Variant) As Variant
   Dim aVal1 As Variant
   Dim retValFinal() As Variant
   retValFinal = arr1
   
   For Each aVal1 In arr2
      If (Not (foundInArray(arr1, aVal1))) Then
         retValFinal = wPush(retValFinal, aVal1)
      End If
   Next aVal1
   getUnionOfArrays = retValFinal
End Function

Public Function getExclutionOfArrays(mainSet() As Variant, arr2() As Variant) As Variant
   Dim aVal1 As Variant
   Dim retValFinal() As Variant
   retValFinal = Array()
      
   For Each aVal1 In mainSet
      If (Not (foundInArray(arr2, aVal1))) Then
         retValFinal = wPush(retValFinal, aVal1)
      End If
   Next aVal1
   getExclutionOfArrays = retValFinal
End Function


' Functions for Primefactors and Teilers
' ======================================================
Public Function getSmallestPrimefigure() As Integer
   Range("B21").Select
   Dim smallestFig
   smallestFig = Range(Selection.Value).Offset(Selection.Offset(1, 0).Value, 0).Value
   For columnCount = 1 To PrimMaxColums - 1
       Selection.Offset(0, 1).Select
       Dim smallestFigTemp
       smallestFigTemp = getSmallest(smallestFig, Range(Selection.Value).Offset(Selection.Offset(1, 0).Value, 0).Value)
       smallestFig = smallestFigTemp
   Next
   getSmallestPrimefigure = smallestFig
End Function

Public Function getSmallest(ByVal a As Integer, ByVal b As Integer) As Integer
   If (a = NaN) Then
     getSmallest = b
   Else
     If (b = NaN) Then
        getSmallest = a
     Else
        If (a < b) Then
           getSmallest = a
        Else
           getSmallest = b
        End If
     End If
   End If
End Function

Function calcFakultaet(N As Integer) As Integer
    Dim fakultaet As Long
    
    If (N >= 0) Then
        fakultaet = 1
        Do While (N > 1)
            fakultaet = fakultaet * N
            N = N - 1
        Loop
    Else
        fakultaet = -1 ' Fehler
    End If
    calcFakultaet = fakultaet
End Function

Function istPrimzahl(eineZahl As Integer) As Boolean
    Dim isA_Prim As Boolean
    isA_Prim = True
    If (eineZahl = 1) Then
        isA_Prim = True
    Else
        If (eineZahl = 2) Then
            isA_Prim = True
        Else
            Dim divisor As Integer
            divisor = 2
            Do While (divisor <= (eineZahl - 1))
                If ((eineZahl Mod divisor) = 0) Then
                    isA_Prim = False
                End If
                divisor = divisor + 1
            Loop
        End If
    End If
    istPrimzahl = isA_Prim
End Function


Public Function isPrimzahl(eineZahl As Integer) As Boolean
    Dim isPrim As Boolean
    isPrim = True
    If ((eineZahl = 1) And (eineZahl = 2)) Then
        isPrim = True
    Else
        For divisor = 2 To (eineZahl \ 2) + 1
            If ((eineZahl Mod divisor) = 0) Then
                isPrim = False
                Exit For
            End If
        Next

    End If
    isPrimzahl = isPrim
End Function

Public Function getNextPrimzahl(zahl As Integer) As Integer
  Dim aZahl As Integer
  aZahl = zahl + 1
  While isPrimzahl(aZahl) = False
     aZahl = aZahl + 1
  Wend
  getNextPrimzahl = aZahl
End Function

Public Function getPrevPrimzahl(zahl As Integer) As Integer
  Dim aZahl As Integer
  aZahl = zahl - 1
  If (zahl <= 1) Then
    getPrevPrimzahl = 1
  Else
    While isPrimzahl(aZahl) = False
       aZahl = aZahl - 1
    Wend
    getPrevPrimzahl = aZahl
  End If
End Function


Public Function getPrimfactors(ByVal zahl As Integer, sep As String) As String
   Dim aZahl As Integer
   Dim aDivisor As Integer
   Dim retStr As String
   retStr = ""
   aZahl = Abs(zahl)
   aDivisor = 2
   If zahl = 1 Then
     retStr = "1"
   Else
     If zahl = 2 Then
        retStr = "2"
     Else
        While isPrimzahl(aZahl) = False
           If aZahl Mod aDivisor = 0 Then
              If aZahl > 1 Then
                 retStr = retStr & sep & aDivisor
              End If
              aZahl = aZahl \ aDivisor
           Else
              aDivisor = getNextPrimzahl(aDivisor)
           End If
        Wend
        If aZahl > 1 Then
          retStr = retStr & sep & aZahl
        End If
        retStr = right(retStr, Len(retStr) - 1)
     End If
   End If
   getPrimfactors = retStr
End Function

Public Function getDivisors(zahl As Integer, sep As String) As String
   Dim aZahl As Integer
   Dim aDivisor As Integer
   Dim retStr As String
   retStr = ""
   aZahl = Abs(zahl)
   aDivisor = 2
   While aDivisor < aZahl
      If aZahl Mod aDivisor = 0 Then
         retStr = retStr & sep & aDivisor
      End If
      aDivisor = aDivisor + 1
   Wend

   retStr = retStr & sep & aZahl
   retStr = right(retStr, Len(retStr) - 1)
   getDivisors = retStr
End Function

Public Function ggT(Arg1 As Range, ParamArray Args2() As Variant) As Long
    ' put all parameter in an array
    Dim elemArr() As Variant
    elemArr = Array()
    Dim elem As Variant
    Dim i As Long
    For Each elem In Arg1
        elemArr = wPush(elemArr, elem.Value)
        ' Debug.Print "Arg1: " & elem.Value
    Next elem
    For i = LBound(Args2) To UBound(Args2)
        For Each elem In Args2(i)
            elemArr = wPush(elemArr, elem.Value)
            ' Debug.Print "i: " & elem.Value
        Next elem
    Next i
    ' displayArray (elemArr)
    Dim countOfFigures As Integer
    countOfFigures = arraySize(elemArr)
    ' Debug.Print "countOfFigures: " & countOfFigures
    
    ' Primezahlen Zerlegung
    Dim arr2Dim() As Variant
    ReDim arr2Dim(countOfFigures - 1, 10)
    Dim prFigStr As String
     For ii = LBound(elemArr) To UBound(elemArr)
        prFigStr = getPrimfactors(elemArr(ii), ";")
        Dim strLen As Integer
        Dim inStrToSplit As String
        Dim startPos As Long
        strLen = Len(prFigStr)
        inStrToSplit = prFigStr
        startPos = InStr(1, inStrToSplit, ";")
        Dim iik As Integer
        iik = 0
        Do While startPos >= 1
            Dim aField As String
            aField = left(inStrToSplit, startPos - 1)
            arr2Dim(ii, iik) = aField
            iik = iik + 1
            inStrToSplit = right(inStrToSplit, Len(inStrToSplit) - startPos - Len(";") + 1)
            startPos = InStr(1, inStrToSplit, ";")
        Loop
        arr2Dim(ii, iik) = inStrToSplit
    Next ii
    ' display2DimArray (arr2Dim)

    ' Schnittmenge bilden
    Dim testArr_1() As Variant
    Dim testArr_2() As Variant
    Dim resArr_1() As Variant
   
    testArr_1 = Array()
    testArr_2 = Array()
    testArr_1 = getArrayFrom2DimArray(arr2Dim, 0)
    testArr_2 = getArrayFrom2DimArray(arr2Dim, 1)
    resArr_1 = getIntersectionOfArrays(testArr_1, testArr_2)
    For ii = 2 To countOfFigures - 1
        ' Debug.Print "Zwischenresultat"
        ' displayArray (resArr_1)
        testArr_1 = getArrayFrom2DimArray(arr2Dim, ii)
        resArr_1 = getIntersectionOfArrays(resArr_1, testArr_1)
    Next ii
    
    ' Debug.Print "final prime figures"
    ' displayArray (resArr_1)
    
    
    ' Multiplication
    Dim ggtVal As Long
    ggtVal = 1
    For ii = LBound(resArr_1) To UBound(resArr_1)
       If (resArr_1(ii) <> NaN) Then
            ' Debug.Print "ggtVal: " & ggtVal&; "   Val:" & resArr_1(ii)
            ggtVal = ggtVal * resArr_1(ii)
        End If
    Next ii
    ggT = ggtVal
End Function



Sub PrimZerlegungAll()
  Application.ScreenUpdating = False
  
  Range("C1:C20").ClearContents
  Range("F1:F20").ClearContents
  Range("I1:I20").ClearContents
  Range("L1:L20").ClearContents
  Range("O1:O20").ClearContents
  Range("P2:P20").ClearContents
  Range("Q2:Q20").ClearContents
  
  Call PrimZerlegung1
  Call PrimZerlegung2
  Call PrimZerlegung3
  Call PrimZerlegung4
  Call PrimZerlegung5
  
  Call sortFactoren
  
  Call get_kgvFactors
  Call get_ggtFactors
  Range("A1").Select
  Application.ScreenUpdating = True
End Sub

Sub PrimZerlegung1()
    Dim fName As String
    fName = "A1"
    Call Primzahlenzerlegung(Sheets("kgv-ggt").Range(fName).Value, fName)
End Sub

Sub PrimZerlegung2()
    Dim fName As String
    fName = "D1"
    Call Primzahlenzerlegung(Sheets("kgv-ggt").Range(fName).Value, fName)
End Sub

Sub PrimZerlegung3()
    Dim fName As String
    fName = "G1"
    Call Primzahlenzerlegung(Sheets("kgv-ggt").Range(fName).Value, fName)
End Sub

Sub PrimZerlegung4()
    Dim fName As String
    fName = "J1"
    Call Primzahlenzerlegung(Sheets("kgv-ggt").Range(fName).Value, fName)
End Sub

Sub PrimZerlegung5()
    Dim fName As String
    fName = "M1"
    Call Primzahlenzerlegung(Sheets("kgv-ggt").Range(fName).Value, fName)
End Sub

Sub Primzahlenzerlegung(zahlToSplit As Integer, Fieldname As String)
    Sheets("Primzahlenzerlegung 2-10000").Select
    
    Dim i
    i = 0
    Do While Range("A1").Offset(i, 0).Value <> zahlToSplit
      i = i + 1
    Loop
    If (Range("A1").Offset(i, 1).Value = "Primzahl") Then
       Sheets("kgv-ggt").Range(Fieldname).Offset(1, 0).Value = zahlToSplit
       For columnCount = 2 To 13
        Sheets("kgv-ggt").Range(Fieldname).Offset(columnCount, 0).Value = ""
       Next
    Else
       For columnCount = 1 To 13
          Sheets("kgv-ggt").Range(Fieldname).Offset(columnCount, 0).Value = Range("A1").Offset(i, columnCount).Value
       Next
    End If
    Sheets("kgv-ggt").Select
End Sub

Sub sortFactoren()
   'Initialisierung
   PrimMaxColums = 5
   For columnCount = 1 To PrimMaxColums
       Sheets("kgv-ggt").Range("A22").Offset(0, columnCount).Value = 0
   Next
   Sheets("kgv-ggt").Range("A22").Offset(0, PrimMaxColums + 2).Value = 0
   
   Dim maxColumnsUsed
   If Sheets("kgv-ggt").Range("A1").Value <> 1 Then
     maxColumnsUsed = maxColumnsUsed + 1
     If Sheets("kgv-ggt").Range("D1").Value <> 1 Then
        maxColumnsUsed = maxColumnsUsed + 1
        If Sheets("kgv-ggt").Range("G1").Value <> 1 Then
            maxColumnsUsed = maxColumnsUsed + 1
            If Sheets("kgv-ggt").Range("J1").Value <> 1 Then
               maxColumnsUsed = maxColumnsUsed + 1
               If Sheets("kgv-ggt").Range("M1").Value <> 1 Then
                maxColumnsUsed = maxColumnsUsed + 1
               End If
            End If
        End If
     End If
   End If
   PrimMaxColums = maxColumnsUsed

   
   Range("C1:C20").ClearContents
   Range("F1:F20").ClearContents
   Range("I1:I20").ClearContents
   Range("L1:L20").ClearContents
   Range("O1:O20").ClearContents
   Range("P2:P20").ClearContents
   Range("Q2:Q20").ClearContents
   
   Dim smallestPrimFig
   smallestPrimFig = getSmallestPrimefigure()
   Dim outPutIndex
   outPutIndex = 0
   Do While smallestPrimFig > 0
      For columnCount = 0 To PrimMaxColums - 1
        If Range(Range("B21").Offset(0, columnCount).Value).Offset(Range("B21").Offset(1, columnCount).Value, 0).Value = smallestPrimFig Then
           Range(Range("B21").Offset(0, columnCount).Value).Offset(outPutIndex, 2).Value = smallestPrimFig
           Range("B21").Offset(1, columnCount).Value = Range("B21").Offset(1, columnCount).Value + 1
        End If
      Next
      outPutIndex = outPutIndex + 1
      smallestPrimFig = getSmallestPrimefigure()
   Loop
End Sub

Sub get_kgvFactors()
   Range("P2:P20").ClearContents
   Range("C2").Select
   Dim kgv
   kgv = 1
   For rowIndex = 0 To 18
      For columnIndex = 0 To PrimMaxColums - 1
      If Selection.Offset(rowIndex, columnIndex * 3).Value <> NaN Then
         If Selection.Offset(rowIndex, columnIndex * 3).Value <> 1 Then
            Range("P2").Offset(rowIndex, 0).Value = Selection.Offset(rowIndex, columnIndex * 3).Value
        End If
      End If
      Next
      'kgv = kgv * Range("P2").Offset(RowIndex, 0).Value
   Next
   Range("A1").Select
End Sub

Sub get_ggtFactors()
   Range("Q2:Q20").ClearContents
   Range("C2").Select
   
   Dim RowIndexLoc
   RowIndexLoc = 0
   For rowIndex = 0 To 18
      Dim lastFig
      lastFig = Selection.Offset(rowIndex, 0).Value
      Dim endCheck
      endCheck = False
      For columnIndex = 1 To PrimMaxColums - 1
        If endCheck = False Then
          If Selection.Offset(rowIndex, columnIndex * 3).Value <> lastFig Then
             endCheck = True
             lastFig = 1
          End If
        End If
      Next
      If lastFig <> 1 Then
        Range("Q2").Offset(RowIndexLoc, 0).Value = lastFig
        RowIndexLoc = RowIndexLoc + 1
      End If
   Next
   Range("A1").Select
End Sub

' Workbook operations
' ======================================================
Function getWorkbook(Optional ByVal fullPath As Boolean = True) As String
    If (fullPath) Then
            getWorkbook = ActiveWorkbook.Path & "\" & ActiveWorkbook.name
        Else
            getWorkbook = ActiveWorkbook.name
        End If
End Function


Public Function getWorkbooks(Optional ByVal deli As String = ";", _
                             Optional ByVal fullPath As Boolean = True) As String
    Dim retVal As String
    Dim wb As Workbook

    For Each wb In Workbooks
        Dim aName As String
        If (fullPath) Then
            aName = wb.Path & "\" & wb.name
        Else
            aName = wb.name
        End If
        If retVal = "" Then
            retVal = aName
        Else
            retVal = retVal & deli & aName
        End If
    Next wb
    getWorkbooks = retVal
End Function

' gives an open workbook the focus
' workBookName full or name only
Public Function activateWorkbookWorksheet(ByVal workBookName As String, _
                                          Optional ByVal workSheetName As String = "") As String
    Dim retVal As String
    Dim wb As Workbook
    
    For Each wb In Workbooks
        If ((wb.Path & "\" & wb.name = workBookName) Or (wb.name = workBookName)) Then
            retVal = wb.Path & "\" & wb.name
            Exit For
        Else
            retVal = ""
        End If
    Next wb
    
    ' Debug.Print "Count of Worksheets in THIS : " & getCountOfWorksheets(True)
    ' Debug.Print "Count of Worksheets in ACTIV: " & getCountOfWorksheets(False)
    If (retVal <> "") Then
        If (workBookName <> "") Then
            Workbooks(getFileName(retVal)).Activate
            If (SheetExists(workSheetName, False)) Then
                Sheets(workSheetName).Select
            Else
                Sheets(1).Select
            End If
        Else
            Sheets(1).Select
        End If
    End If
    activateWorkbookWorksheet = retVal
End Function

' activ is the workbook which has the focus
Public Function getActivatedWorkbook(Optional ByVal fullPath As Boolean = True) As String
    Dim aName As String
    If (fullPath) Then
        aName = ActiveWorkbook.Path & "\" & ActiveWorkbook.name
    Else
        aName = ActiveWorkbook.name
    End If
    getActivatedWorkbook = aName
End Function

' this is the workbook the code is running
Public Function getThisWorkbook(Optional ByVal fullPath As Boolean = True) As String
    Dim aName As String
    If (fullPath) Then
        aName = ThisWorkbook.Path & "\" & ThisWorkbook.name
    Else
        aName = ThisWorkbook.name
    End If
    getThisWorkbook = aName
End Function

Sub SaveWB(ByVal wb As String)
    Workbooks(wb).Save
End Sub

Sub CloseWB(ByVal wb As String)
    Workbooks(wb).Close
End Sub


' Worksheet operations
' ======================================================
Public Function whichSheetSelected() As String
   whichSheetSelected = ActiveSheet.name
End Function

Public Function WorkSheetExistsOrCreate(ByVal d_workbook As String, ByVal d_worksheet As String) As String
    On Error Resume Next
    If (Not (Workbooks(d_workbook).Worksheets(d_worksheet).name <> "")) Then
        Workbooks(d_workbook).Sheets.Add
        ActiveSheet.name = d_worksheet
    End If
    WorkSheetExistsOrCreate = "done"
End Function

Public Function getCountOfWorksheets(Optional ByVal useThis As Boolean = True) As Integer
    If (useThis) Then
        getCountOfWorksheets = ThisWorkbook.Worksheets.Count
    Else
        getCountOfWorksheets = ActiveWorkbook.Worksheets.Count
    End If
End Function

' first sheet is 1
Public Function getWorksheetName(Optional ByVal wsNumber As Integer = 1) As String
    getWorksheetName = Worksheets(wsNumber).name
End Function

Public Function SheetExists(ByVal sheetName As String, Optional ByVal useThis As Boolean = True) As Boolean
    Dim retVal As Boolean
    retVal = False

    If (useThis) Then
        Dim ws1 As Worksheet
        For Each ws1 In ThisWorkbook.Worksheets
            If ws1.name = sheetName Then
                retVal = True
                Exit For
            End If
        Next ws1
    Else
        Dim ws2 As Worksheet
        For Each ws2 In ActiveWorkbook.Worksheets
            If ws2.name = sheetName Then
                retVal = True
                Exit For
            End If
        Next ws2
    End If
    SheetExists = retVal
End Function

Public Function DeleteWorksheets(ByVal sheetNamePattern As String, Optional ByVal patternPos As String = "EQUAL", Optional ByVal useThis As Boolean = True) As Integer
    Dim retVal As Integer
    retVal = 0

    Application.DisplayAlerts = False
    If (useThis) Then
        Dim ws1 As Worksheet
        For Each ws1 In ThisWorkbook.Worksheets
            If (findPatternPosition(ws1.name, sheetNamePattern) = patternPos) Then
                Sheets(ws1.name).Delete
                retVal = retVal + 1
            End If
        Next ws1
    Else
        Dim ws2 As Worksheet
        For Each ws2 In ActiveWorkbook.Worksheets
            If (findPatternPosition(ws1.name, sheetNamePattern) = patternPos) Then
                Sheets(ws1.name).Delete
                retVal = retVal + 1
            End If
        Next ws2
    End If
    Application.DisplayAlerts = True
    DeleteWorksheets = retVal
End Function

Public Function getWorksheets(ByVal sheetNamePattern As String, Optional ByVal patternPos As String = "EQUAL", Optional ByVal useThis As Boolean = True) As String
    Dim retVal As String
    retVal = ""

    If (useThis) Then
        Dim ws1 As Worksheet
        For Each ws1 In ThisWorkbook.Worksheets
            If (findPatternPosition(ws1.name, sheetNamePattern) = patternPos) Then
                retVal = retVal & ";" & ws1.name
            End If
        Next ws1
    Else
        Dim ws2 As Worksheet
        For Each ws2 In ActiveWorkbook.Worksheets
            If (findPatternPosition(ws1.name, sheetNamePattern) = patternPos) Then
                retVal = retVal & ";" & ws1.name
            End If
        Next ws2
    End If
    getWorksheets = right(retVal, Len(retVal) - 1)
End Function

Function RemoveFormatsFromWorksheet(Optional ByVal sheetName As String = "")
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    Worksheets(sheetName).Select
    Cells.Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    Selection.Borders(xlEdgeLeft).LineStyle = xlNone
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    Selection.Borders(xlEdgeRight).LineStyle = xlNone
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    With Selection.Interior
        .pattern = xlNone
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    RemoveFormatsFromWorksheet = True
End Function

' functions calculating fractions (Bruch)
' ======================================================


Function Bruch_cleanIt(ByVal inBruchStr As String) As String
    inBruchStr = RTrim(LTrim(inBruchStr))
    inBruchStr = replaceStringInStringRegEx(inBruchStr, "\s+", " ")
    Bruch_cleanIt = inBruchStr
End Function

Function Bruch_getBruchSign(ByVal inBruchStr As String) As Integer
    inBruchStr = Bruch_cleanIt(inBruchStr)
    retVal = 1
    If strStarts(inBruchStr, "-") Then
        retVal = -1
    End If
    Bruch_getBruchSign = retVal
End Function

Function Bruch_RemoveSign(ByVal inBruchStr As String) As String
    inBruchStr = replaceStringInStringRegEx(inBruchStr, "^(-|\+)", "")
    Bruch_RemoveSign = RTrim(LTrim(inBruchStr))
    
End Function

Function Bruch_getBruchType(ByVal inBruchStr As String) As String
    inBruchStr = Bruch_cleanIt(inBruchStr)
    
    Dim bruchSign As Integer
    bruchSign = Bruch_getBruchSign(inBruchStr)
    inBruchStr = Bruch_RemoveSign(inBruchStr)
    
    retString = ""
    If (inBruchStr = "") Then
        retString = "0"
    ElseIf isStringMatchesRegEx(inBruchStr, aBruch_RegEx) Then
        retString = "z/n"    ' 23/12
    ElseIf isStringMatchesRegEx(inBruchStr, aGanzeZahl_RegEx) Then
        retString = "g"    ' 23
    ElseIf isStringMatchesRegEx(inBruchStr, aGemischterBruch_RegEx) Then
        retString = "g z/n"    ' 23 4/5
    Else
        retString = inBruchStr & "   Not a valid fraction!"
    End If
    
    If (bruchSign = -1) Then
        Bruch_getBruchType = "-" & retString
    Else
        Bruch_getBruchType = retString
    End If
End Function

Function Bruch_getGanzahligerTeil(ByVal inBruchStr As String) As Integer
    inBruchStr = Bruch_cleanIt(inBruchStr)
    
    Dim bruchSign As Integer
    bruchSign = Bruch_getBruchSign(inBruchStr)
    inBruchStr = Bruch_RemoveSign(inBruchStr)
    
    Dim bruchType As String
    bruchType = Bruch_getBruchType(inBruchStr)
    
    Dim ganzzahligerTeil As Integer
    If (bruchType = "g") Then
        ganzzahligerTeil = inBruchStr * bruchSign
    ElseIf (bruchType = "g z/n") Then
        gstr = getFieldFromString(inBruchStr, " ", 0)
        ganzzahligerTeil = gstr * bruchSign
    Else
        ganzzahligerTeil = 0
    End If
    Bruch_getGanzahligerTeil = ganzzahligerTeil
End Function

Function Bruch_getZaehler(ByVal inBruchStr As String) As Integer
    inBruchStr = Bruch_cleanIt(inBruchStr)
    
    Dim bruchSign As Integer
    bruchSign = Bruch_getBruchSign(inBruchStr)
    inBruchStr = Bruch_RemoveSign(inBruchStr)
    
    Dim bruchType As String
    bruchType = Bruch_getBruchType(inBruchStr)
    
    Dim bruchPart As String
    bruchPart = ""
    Dim zaehler As Integer
    If (bruchType = "g z/n") Then
        bruchPart = getFieldFromString(inBruchStr, " ", 1)
        zaehler = getFieldFromString(bruchPart, "/", 0)
        zaehler = zaehler * 1
    ElseIf (bruchType = "z/n") Then
        bruchPart = inBruchStr
        zaehler = getFieldFromString(bruchPart, "/", 0)
        zaehler = zaehler * bruchSign
    Else
        zaehler = 0
    End If
    Bruch_getZaehler = zaehler
End Function

Function Bruch_getNenner(ByVal inBruchStr As String) As Integer
    inBruchStr = Bruch_cleanIt(inBruchStr)
    
    Dim bruchSign As Integer
    bruchSign = Bruch_getBruchSign(inBruchStr)
    inBruchStr = Bruch_RemoveSign(inBruchStr)
    
    Dim bruchType As String
    bruchType = Bruch_getBruchType(inBruchStr)
    
    Dim bruchPart As String
    bruchPart = ""
    Dim zaehler As Integer
    If (bruchType = "g z/n") Then
        bruchPart = getFieldFromString(inBruchStr, " ", 1)
        nenner = getFieldFromString(bruchPart, "/", 1)
        nenner = nenner * 1
    ElseIf (bruchType = "z/n") Then
        bruchPart = inBruchStr
        nenner = getFieldFromString(bruchPart, "/", 1)
        nenner = nenner * 1
    Else
        nenner = 1
    End If
    Bruch_getNenner = nenner
End Function

Function Bruch_getUnechter(ByVal factor_1 As String) As String
    Bruch_getUnechter = ((Bruch_getGanzahligerTeil(factor_1) * Bruch_getNenner(factor_1)) + Bruch_getZaehler(factor_1)) & "/" & Bruch_getNenner(factor_1)
End Function

Function Bruch_add(ByVal summand_1 As String, ByVal summand_2 As String) As String
    bruch_1 = Bruch_getUnechter(summand_1)
    bruch_2 = Bruch_getUnechter(summand_2)
    Bruch_add = Bruch_getZaehler(bruch_1) * Bruch_getNenner(bruch_2) + Bruch_getZaehler(bruch_2) * Bruch_getNenner(bruch_1) & "/" & Bruch_getNenner(bruch_1) * Bruch_getNenner(bruch_2)
End Function

Function Bruch_mul(ByVal factor_1 As String, ByVal factor_2 As String) As String
    bruch_1 = Bruch_getUnechter(factor_1)
    bruch_2 = Bruch_getUnechter(factor_2)
    Bruch_mul = Bruch_getZaehler(bruch_1) * Bruch_getZaehler(bruch_2) & "/" & Bruch_getNenner(bruch_1) * Bruch_getNenner(bruch_2)
End Function

Function Bruch_div(ByVal dividend As String, ByVal divisor As String) As String
    bruch_1 = Bruch_getUnechter(dividend)
    bruch_2 = Bruch_getUnechter(divisor)
    Bruch_div = Bruch_getZaehler(bruch_1) * Bruch_getNenner(bruch_2) & "/" & Bruch_getNenner(bruch_1) * Bruch_getZaehler(bruch_2)
End Function

Function Bruch_sub(ByVal minuend As String, ByVal subtrahend As String) As String
    bruch_1 = Bruch_getUnechter(minuend)
    bruch_2 = Bruch_getUnechter(subtrahend)
    Bruch_sub = Bruch_getZaehler(bruch_1) * Bruch_getNenner(bruch_2) - Bruch_getZaehler(bruch_2) * Bruch_getNenner(bruch_1) & "/" & Bruch_getNenner(bruch_1) * Bruch_getNenner(bruch_2)
End Function

Function Bruch_eval(ByVal bruchTerm As String) As String
    bruchTerm = RTrim(LTrim(bruchTerm))
    If strContains(bruchTerm, "+") Then
        bruch_1 = RTrim(LTrim(getFieldFromString(bruchTerm, "+", 0)))
        bruch_2 = RTrim(LTrim(getFieldFromString(bruchTerm, "+", 1)))
        Bruch_eval = Bruch_add(bruch_1, bruch_2)
    ElseIf strContains(bruchTerm, "-") Then
        bruch_1 = RTrim(LTrim(getFieldFromString(bruchTerm, "-", 0)))
        bruch_2 = RTrim(LTrim(getFieldFromString(bruchTerm, "-", 1)))
        Bruch_eval = Bruch_sub(bruch_1, bruch_2)
    ElseIf strContains(bruchTerm, "*") Then
        bruch_1 = RTrim(LTrim(getFieldFromString(bruchTerm, "*", 0)))
        bruch_2 = RTrim(LTrim(getFieldFromString(bruchTerm, "*", 1)))
        Bruch_eval = Bruch_mul(bruch_1, bruch_2)
    ElseIf strContains(bruchTerm, ":") Then
        bruch_1 = RTrim(LTrim(getFieldFromString(bruchTerm, ":", 0)))
        bruch_2 = RTrim(LTrim(getFieldFromString(bruchTerm, ":", 1)))
        Bruch_eval = Bruch_div(bruch_1, bruch_2)
    End If
End Function

' functions for ranges as string
' ======================================================

'returns a string with the adresses of a passed range
Public Function getStringRangeFromRange(ByVal matrixRange As Range) As String
    Dim retVal As String
    Dim matrixRangeStr As String
    matrixRangeStr = matrixRange.Address(False, False, xlA1)
    retVal = matrixRangeStr
    getStringRangeFromRange = retVal
End Function


' depricated
Public Function getLowColumnFromRange(ByVal aRange As String) As String
    getLowColumnFromRange = upperLeftFromRangeStr(aRange)
End Function

Public Function upperLeftFromRangeStr(ByVal aRange As String) As String
    upperLeftFromRangeStr = getFieldFromString(aRange, ":", 0)
End Function

' depricated
Public Function getHighColumnFromRange(ByVal aRange As String) As String
    getHighColumnFromRange = lowerRigthFromRange(aRange)
End Function

Public Function lowerRigthFromRange(ByVal aRange As String) As String
    lowerRigthFromRange = getFieldFromString(aRange, ":", 1)
End Function

Public Function rowCountFromRange(ByVal aRange As String) As Integer
    Dim firstAddr As String
    Dim lastAddr As String
    firstAddr = getFieldFromString(aRange, ":", 0)
    lastAddr = getFieldFromString(aRange, ":", 1)
    rowCountFromRange = GetRowIndexFromAdr(lastAddr) - GetRowIndexFromAdr(firstAddr) + 1
End Function

Public Function columnCountFromRange(ByVal aRange As String) As Integer
    Dim firstAddr As String
    Dim lastAddr As String
    firstAddr = getFieldFromString(aRange, ":", 0)
    lastAddr = getFieldFromString(aRange, ":", 1)
    columnCountFromRange = GetColumnIndexFromColumnLetter(getColumnLetterFromAdr(lastAddr)) - GetColumnIndexFromColumnLetter(getColumnLetterFromAdr(firstAddr)) + 1
End Function

Public Function moveRange(ByVal sourceRange As String, ByVal destToLeftCell As String) As String
    Dim countRowOfRange As Integer
    Dim countColOfRange As Integer
    Dim destLowRigthCell As String
    countRowOfRange = rowCountFromRange(sourceRange)
    countColOfRange = columnCountFromRange(sourceRange)
    destLowRigthCell = getAdrByAddingOffset(destToLeftCell, countColOfRange - 1, countRowOfRange - 1)
    moveRange = destLowRigthCell
End Function

Public Function getAdrFromSelectedRange() As String
    getAdrFromSelectedRange = Selection.Address(ReferenceStyle:=xlA1, RowAbsolute:=False, ColumnAbsolute:=False)
End Function

' function for cell adrs and column identifiers
' ======================================================
Public Function whichColumnSelected() As String
   whichColumnSelected = getColumnLetterFromColumnIndex(ActiveCell.column)
End Function

Public Function whichRowSelected() As String
   whichRowSelected = ActiveCell.row
End Function

Public Function whichCellSelected() As String
   whichCellSelected = whichColumnSelected() & whichRowSelected()
End Function

Public Function setSelectedRangeValues(Optional ByVal sheetName As String = "", Optional ByVal newVal As String = "") As String
   If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
   End If

    Dim c As Range
    For Each c In Worksheets(shName).Range(getAdrFromSelectedRange()).Cells
        cellAdr = c.Address(ReferenceStyle:=xlA1, RowAbsolute:=False, ColumnAbsolute:=False)
        Worksheets(sheetName).Range(cellAdr).Value = newVal
    Next
    setSelectedRangeValues = ""
End Function

Public Function insertRow(ByVal startRow As Integer, Optional ByVal lastRow As Integer = -1, Optional ByVal shName As String = "")
    If (lastRow = -1) Then
        lastRow = startRow
    End If
    If (shName = "") Then
        shName = ActiveWorkbook.ActiveSheet.name
    End If
    Rows(startRow & ":0" & lastRow).Insert Shift:=xlDown, CopyOrigin:=xlFormatFromLeftOrAbove
    insertRow = ""
End Function

Public Function GetCellAddr(ByVal row As Integer, ByVal column As Integer) As String
    Dim columnStr As String
    columnStr = GetExcelColumnIdentifier(column - 1)
    GetCellAddr = columnStr & row
End Function

Public Function GetCellAddrIntStr(ByVal row As Integer, ByVal columnStr As String) As String
    Dim rowStr As String
    rowStr = row
    GetCellAddrIntStr = columnStr & rowStr
End Function

' returns C5,1,2 -> D7
Public Function getAdrByAddingOffset(ByVal adr As String, ByVal xOffset As Integer, ByVal yOffset As Integer)
  Dim rowIndex As Integer
  Dim columnIndex As Integer
  
  rowIndex = GetRowIndexFromAdr(adr) + yOffset
  columnIndex = GetColumnIndexFromColumnLetter(getColumnLetterFromAdr(adr)) + xOffset
  getAdrByAddingOffset = GetCellAddr(rowIndex, columnIndex)
End Function

' returns D -> 4
Public Function GetColumnIndexFromColumnLetter(ByVal columnLetter As String) As Integer
   columnLetter = UCase(columnLetter)
   If Len(columnLetter) = 1 Then
      GetColumnIndexFromColumnLetter = Asc(columnLetter) - Asc("A") + 1
   Else
      If Len(columnLetter) = 2 Then
          Dim firstChar As String
          Dim secondChar As String
          firstChar = left(columnLetter, 1)
          secondChar = right(columnLetter, 1)
          GetColumnIndexFromColumnLetter = ((Asc(firstChar) - Asc("A") + 1) * 26) + Asc(secondChar) - Asc("A") + 1
      Else
          GetColumnIndexFromColumnLetter = 0
      End If
   End If
   
End Function

' returns A23 -> 23
Public Function GetRowIndexFromAdr(ByVal cellAddr As String) As Integer
   Dim singleChar() As String
   singleChar = Split(StrConv(cellAddr, vbUnicode), vbNullChar)
   
   Dim arrIndex As Integer
   Dim retStr As String
   retStr = ""
   For arrIndex = LBound(singleChar) To UBound(singleChar)
      If (singleChar(arrIndex) >= "0" And singleChar(arrIndex) <= "9") Then
         retStr = retStr & singleChar(arrIndex)
      Else
         retStr = retStr
      End If
   Next
   GetRowIndexFromAdr = retStr
End Function


Public Function GetExcelColumnIdentifier(ByVal columnNumberStartAtZero As Integer) As String
  GetExcelColumnIdentifier = getColumnLetterFromColumnIndex(columnNumberStartAtZero + 1)
End Function

' returns AB for 28
Public Function getColumnLetterFromColumnIndex(ByVal columnNr As Integer) As String
   Dim cellAdr As String
   cellAdr = Cells(1, columnNr).Address(False, False)
   getColumnLetterFromColumnIndex = left(cellAdr, Len(cellAdr) - 1)
End Function

' returns AB for AB34
Public Function getColumnLetterFromAdr(ByVal cellAddr As String) As String
   Dim singleChar() As String
   singleChar = Split(StrConv(cellAddr, vbUnicode), vbNullChar)
   
   Dim arrIndex As Integer
   Dim retStr As String
   retStr = ""
   For arrIndex = LBound(singleChar) To UBound(singleChar)
      If (singleChar(arrIndex) >= "0" And singleChar(arrIndex) <= "9") Then
         retStr = retStr
      Else
         retStr = retStr & singleChar(arrIndex)
      End If
   Next
   getColumnLetterFromAdr = retStr
End Function

' returns C -> D
Public Function getNextColumnLetter(ByVal column As String) As String
   getNextColumnLetter = getColumnLetterFromColumnIndex(GetColumnIndexFromColumnLetter(column) + 1)
End Function

' returns D -> C
Public Function getPrevColumnLetter(ByVal column As String) As String
   getPrevColumnLetter = getColumnLetterFromColumnIndex(GetColumnIndexFromColumnLetter(column) - 1)
End Function

Function setColumnLetterInAdr(ByVal inAdr As String, ByVal newColumnLetter As String) As String
   setColumnLetterInAdr = newColumnLetter & GetRowIndexFromAdr(inAdr)
End Function

Function setRowNrInAdr(ByVal inAdr As String, ByVal newRowNr As Integer) As String
   setRowNrInAdr = getColumnLetterFromAdr(inAdr) & newRowNr
End Function

Public Function getRelativeColumnLetter(ByVal column As String, ByVal distance As Integer) As String
   getRelativeColumnLetter = getColumnLetterFromColumnIndex(GetColumnIndexFromColumnLetter(column) + distance)
End Function

Public Function getLastColumnRelative(ByVal sheetName As String, ByVal startCellAdr As String) As Integer
   Dim columnIndex As Integer
   columnIndex = 0
   Do While Sheets(sheetName).Range(startCellAdr).Offset(0, columnIndex).Value <> ""
      columnIndex = columnIndex + 1
   Loop
   getLastColumnRelative = columnIndex
End Function

Public Function getNextFilledColumnRelative(ByVal sheetName As String, ByVal startCellAdr As String) As Integer
   Dim columnIndex As Integer
   columnIndex = 0
   Do While (Sheets(sheetName).Range(startCellAdr).Offset(0, columnIndex).Value = "") Or (columnIndex > 10000)
      columnIndex = columnIndex + 1
   Loop
   getNextFilledColumnRelative = columnIndex
End Function

Public Function getPrevFilledRowRelative(ByVal sheetName As String, ByVal startCellAdr As String) As Integer
   Dim rowIndex As Integer
   rowIndex = 0
   Do While (Sheets(sheetName).Range(startCellAdr).Offset(rowIndex, 0).Value = "") Or (rowIndex < -10000)
      rowIndex = rowIndex - 1
   Loop
   getPrevFilledRowRelative = rowIndex
End Function

Public Function getNextEmptyCellHorizontal(ByVal startCell As String, Optional ByVal sheetName As String = "") As String
   If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
   End If

    getNextEmptyCellHorizontal = getAdrByAddingOffset(startCell, getLastColumnRelative(sheetName, startCell), 0)
End Function

Public Function getNextEmptyCellVertical(ByVal startCell As String, Optional ByVal sheetName As String = "") As String
   If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
   End If

    getNextEmptyCellVertical = getAdrByAddingOffset(startCell, 0, getLastRowRelative(sheetName, startCell))
End Function


Public Function getLastRowRelative(ByVal sheetName As String, ByVal startCellAdr As String)
   Dim rowIndex As Integer
   rowIndex = 0
   Do While Sheets(sheetName).Range(startCellAdr).Offset(rowIndex, 0).Value <> ""
      rowIndex = rowIndex + 1
   Loop
   getLastRowRelative = rowIndex
End Function

Public Function getLowerRightAdr(ByVal sheetName As String, ByVal startCellAdr As String)
    getLowerRightAdr = getAdrByAddingOffset(startCellAdr, _
                            getLastColumnRelative(sheetName, startCellAdr) - 1, _
                            getLastRowRelative(sheetName, startCellAdr) - 1)
End Function

' returns A5 -> $A$5
Public Function fixCellAddr(ByVal aCellAdr As String) As String
    fixCellAddr = "$" & getColumnLetterFromAdr(aCellAdr) & "$" & GetRowIndexFromAdr(aCellAdr)
End Function

' Lookup methods
' ======================================================
Public Function findColumnLetterFromHeader( _
    ByVal topLeftAdr As String, _
    ByVal columnTitle As String, _
    ByVal sheetNameStr As String, _
    Optional ByVal notFoundStr As String = "NOT FOUND") As String
    
    Dim endCellOfHeader As String
    Dim foundCell As String
    
    endCellOfHeader = getAdrByAddingOffset(topLeftAdr, getLastColumnRelative(sheetNameStr, topLeftAdr) - 1, 0)
    foundCell = LookUpWR(columnTitle, topLeftAdr, endCellOfHeader, sheetNameStr)
    If foundCell = "NOT FOUND" Then
        findColumnLetterFromHeader = notFoundStr
    Else
        findColumnLetterFromHeader = getColumnLetterFromAdr(foundCell)
    End If
End Function


Public Function findCellContent( _
    ByVal sheetNameStr As String, _
    ByVal patternStr As String, _
    ByVal startCellAdr As String, _
    ByVal endCellAdr As String, _
    Optional ByVal patternPos As String = "STARTS", _
    Optional ByVal notFoundStr As String = "NOT FOUND") As String
    
   Dim rowStart As Integer
   Dim rowEnd As Integer
   Dim colStart As String
   Dim retVal As String
   Dim iRow As Integer
   Dim iCellAdr As String
   
   If (patternPos = "") Then
        patternPos = "STARTS"
   End If
   patternPos = UCase(patternPos)

   rowStart = GetRowIndexFromAdr(startCellAdr)
   rowEnd = GetRowIndexFromAdr(endCellAdr)
   colStart = getColumnLetterFromAdr(startCellAdr)
   
   iRow = rowStart
   iCellAdr = colStart & iRow
   Do While ((findPatternPosition(Sheets(sheetNameStr).Range(iCellAdr).Value, patternStr) <> patternPos) And (iRow <= rowEnd))
      iRow = iRow + 1
      iCellAdr = colStart & iRow
   Loop

   If InStr(1, Sheets(sheetNameStr).Range(iCellAdr).Value, patternStr) > 0 Then
      retVal = Sheets(sheetNameStr).Range(iCellAdr).Value
   Else
      retVal = notFoundStr
   End If
   findCellContent = retVal
End Function


' returns the cellAdr of the cell in a range matching the pattern
' use Refresh function to get it updated
Public Function LookUpWR( _
    ByVal patternStr As String, _
    ByVal startCellAdr As String, _
    ByVal endCellAdr As String, _
    Optional ByVal sheetName As String = "", _
    Optional ByVal patternPos As String = "EQUAL", _
    Optional ByVal notFoundStr As String = "NOT FOUND") As String

   Dim rowStart As Integer
   Dim rowEnd As Integer
   Dim colStart As String
   Dim colEnd As String
   Dim retVal As String
   Dim iRow As Integer
   Dim iCol As String
   Dim iCellAdr As String

   If (patternPos = "") Then
        patternPos = "EQUAL"
   End If

   patternPos = UCase(patternPos)

   rowStart = GetRowIndexFromAdr(startCellAdr)
   rowEnd = GetRowIndexFromAdr(endCellAdr)
   colStart = getColumnLetterFromAdr(startCellAdr)
   colEnd = getColumnLetterFromAdr(endCellAdr)
   
   retVal = notFoundStr
   iCol = colStart
   
   If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
   End If
   
   Do While (iCol <> getNextColumnLetter(colEnd) And (retVal = notFoundStr))
       iRow = rowStart
       iCellAdr = iCol & iRow
       Do While ((findPatternPosition(Sheets(sheetName).Range(iCellAdr).Value, patternStr) <> patternPos) And (iRow <= rowEnd))
          iRow = iRow + 1
          iCellAdr = iCol & iRow
       Loop
       If InStr(1, Sheets(sheetName).Range(iCellAdr).Value, patternStr) > 0 Then
          retVal = iCellAdr
       End If
       iCol = getNextColumnLetter(iCol)
   Loop
   
   LookUpWR = retVal
End Function

Public Function LookUpAndReplacePlaceholders( _
    ByVal patternStr As String, _
    ByVal startCellAdr As String, _
    ByVal endCellAdr As String, _
    Optional ByVal sheetNameStr As String = "", _
    Optional ByVal rowOffset As Integer = 1, _
    Optional ByVal columnOffset As Integer = 0, _
    Optional ByVal patternPos As String = "EQUAL", _
    Optional ByVal defaultValueForReplacement As String = "___KeepPlaceholder", _
    Optional ByVal maxCountOfInterations As Integer = 10) As String
    
    Dim retVal As String
    Dim aPlaceholderValue As String
    Dim aPlaceholderName As String ' without {}
    Dim aPlaceholder As String     ' with {}
    Dim countOfInterations As Integer
    Dim nothingFoundStr As String
    Dim notFoundStr As String
    notFoundStr = "NICHTGEFUNDEN"
    
    countOfInterations = 1
    nothingFoundStr = "NOTHING FOUND"
    retVal = getFieldValue(LookUpWR(patternStr, startCellAdr, endCellAdr, sheetNameStr, patternPos, notFoundStr), rowOffset, columnOffset, sheetName, notFoundStr)
    
    Do While (countOfInterations < maxCountOfInterations)
        aPlaceholder = getPlaceholderFromString(retVal, "{", "}", nothingFoundStr)
        If (aPlaceholder = nothingFoundStr) Then
            countOfInterations = maxCountOfInterations + 5
        Else
            aPlaceholderName = Mid(aPlaceholder, 2, Len(aPlaceholder) - 2)
            aPlaceholderValue = getFieldValue(LookUpWR(aPlaceholderName, startCellAdr, endCellAdr, sheetNameStr, patternPos, notFoundStr), rowOffset, columnOffset, sheetNameStr, notFoundStr)
            If (aPlaceholderValue = notFoundStr) Then
                 If (defaultValueForReplacement = "___KeepPlaceholder") Then
                    aPlaceholderValue = "[[[" & aPlaceholderName & "]]]"
                 Else
                    aPlaceholderValue = defaultValueForReplacement
                 End If
            End If
            retVal = replaceSinglePlaceholder(retVal, aPlaceholder, aPlaceholderValue)
            countOfInterations = countOfInterations + 1
        End If
    Loop
    
    retVal = replaceStringInString(retVal, "[[[", "{")
    retVal = replaceStringInString(retVal, "]]]", "}")
    LookUpAndReplacePlaceholders = retVal
End Function

' returns palceholder including the start- and end-pattern (If no placeholder found ==> returns nothingFound
Public Function getPlaceholderFromString( _
    ByVal inString1 As String, _
    Optional ByVal startPattern As String = "{", _
    Optional ByVal endPattern As String = "}", _
    Optional ByVal nothingFound As String = "", _
    Optional ByVal startPoint As Integer = 1) As String
   
    Dim retVal As String
    Dim startPos As Long
    Dim endPos As Long
    
    startPos = InStr(startPoint, inString1, startPattern)
    endPos = InStr(startPoint, inString1, endPattern)
    
    If (endPos > startPos) Then
        retVal = Mid(inString1, startPos, endPos - startPos + 1)
    Else
        retVal = nothingFound
    End If
   
    getPlaceholderFromString = retVal
End Function

' returns palceholder including the start- and end-pattern (If no placeholder found ==> returns nothingFound
Public Function getAllPlaceholdersFromString( _
    ByVal inString1 As String, _
    Optional ByVal startPattern As String = "{", _
    Optional ByVal endPattern As String = "}", _
    Optional ByVal nothingFound As String = "", _
    Optional ByVal returnValSep As String = ";") As String
   
    Dim retVal As String
    Dim tmpVal As String
    Dim startPos As Integer
    Dim doSearch As Boolean
    doSearch = True
    startPos = 1
    
    Do While doSearch
        tempVal = getPlaceholderFromString(inString1, startPattern, endPattern, nothingFound, startPos)
        If (tempVal = nothingFound) Then
            doSearch = False
        Else
            If (retVal = "") Then
                retVal = tempVal
            Else
                retVal = retVal & returnValSep & tempVal
            End If
            startPos = InStr(1, inString1, tempVal) + Len(tempVal) + 1
        End If
    Loop
    getAllPlaceholdersFromString = retVal
End Function

Function selectFromTable( _
        ByVal attrToSelect As String, _
        ByVal whereValue As String, _
        ByVal keyAttr As String, _
        Optional ByVal sheetName As String = "", _
        Optional ByVal upperLeft As String = "B1", _
        Optional ByVal keyAttrNotFountMsg As String = "KEY NOT FOUND", _
        Optional ByVal selectAttrNotFountMsg As String = "SELECT ATTRIBUTE NOT FOUND", _
        Optional ByVal patternNotFountMsg As String = "PATTERN NOT FOUND") As String
        
    Dim retVal As String
    Dim keyFieldColumn As String
    Dim attrToSelectColumn As String
    Dim lastRow As Integer
    Dim foundRow As Integer
    
    
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    
    lastRow = getLastRowRelative(sheetName, upperLeft)
    
    
    keyFieldColumn = findColumnLetterFromHeader(upperLeft, keyAttr, sheetName)
    If (keyFieldColumn = "NOT FOUND") Then
         retVal = keyAttrNotFountMsg
    Else
        attrToSelectColumn = findColumnLetterFromHeader(upperLeft, attrToSelect, sheetName)
        If (attrToSelectColumn = "NOT FOUND") Then
            retVal = selectAttrNotFountMsg
        Else
            keyColumnUpperLeft = keyFieldColumn & GetRowIndexFromAdr(upperLeft)
            matchAddr = LookUpWR(whereValue, keyColumnUpperLeft, getAdrByAddingOffset(keyColumnUpperLeft, 0, lastRow - 1), sheetName)
            If matchAddr = "NOT FOUND" Then
                retVal = patternNotFountMsg
            Else
                foundRow = GetRowIndexFromAdr(matchAddr)
                retVal = Sheets(sheetName).Range(attrToSelectColumn & foundRow).Value
            End If
        End If
    End If
    selectFromTable = retVal
End Function

Function getCellAdrFromMatrix( _
        ByVal X_Pattern As String, _
        ByVal Y_Pattern As String, _
        Optional ByVal shName As String = "", _
        Optional ByVal firstX_Cell As String = "B1", _
        Optional ByVal firstY_Cell As String = "A4", _
        Optional ByVal yStep As Integer = 1, _
        Optional ByVal xStep As Integer = 1, _
        Optional ByVal yPatternPos As String = "EQUAL", _
        Optional ByVal xPatternPos As String = "EQUAL", _
        Optional ByVal yNotFountMsg As String = "Y NOT FOUND", _
        Optional ByVal xNotFountMsg As String = "X NOT FOUND") As String
        
   ' check for cash
   If ((lastCash_X_Pattern = X_Pattern) And (lastCash_Y_Pattern = Y_Pattern)) Then
           getCellAdrFromMatrix = lastCash_CellMatrix
           ' Debug.Print ("Adr found in Cash:" & getCellAdrFromMatrix)
   Else
           lastCash_X_Pattern = X_Pattern
           lastCash_Y_Pattern = Y_Pattern
        
           If ((shName = "") Or (Not (SheetExists(shName)))) Then
                shName = whichSheetSelected()
           End If
           
           yPatternPos = UCase(yPatternPos)
           xPatternPos = UCase(xPatternPos)
        
           Dim xAdrResult As String
           Dim yAdrResult As String
        
           Dim xIndex As String
           Dim yIndex As Integer
           Dim patternFound As Boolean
           
           'looking vor X
           xIndex = getColumnLetterFromAdr(firstX_Cell)
           yIndex = GetRowIndexFromAdr(firstX_Cell)
           xAdrResult = xIndex & yIndex
           patternFound = False
           Do While ((Sheets(shName).Range(xAdrResult).Value <> "") And (patternFound = False))
               If (findPatternPosition(Sheets(shName).Range(xAdrResult).Value, X_Pattern) <> xPatternPos) Then
                    xIndex = getRelativeColumnLetter(xIndex, xStep)
                Else
                    patternFound = True
               End If
               xAdrResult = xIndex & yIndex
           Loop
           
           If (patternFound = True) Then
                'looking vor Y
                xIndex = getColumnLetterFromAdr(firstY_Cell)
                yIndex = GetRowIndexFromAdr(firstY_Cell)
                yAdrResult = xIndex & yIndex
                patternFound = False
                Do While ((Sheets(shName).Range(yAdrResult).Value <> "") And (patternFound = False))
                    If (findPatternPosition(Sheets(shName).Range(yAdrResult).Value, Y_Pattern) <> yPatternPos) Then
                         yIndex = yIndex + yStep
                     Else
                         patternFound = True
                    End If
                    yAdrResult = xIndex & yIndex
                Loop
                If (patternFound = True) Then
                    getCellAdrFromMatrix = getColumnLetterFromAdr(xAdrResult) & GetRowIndexFromAdr(yAdrResult)
                Else
                    getCellAdrFromMatrix = yNotFountMsg
                End If
           Else
                getCellAdrFromMatrix = xNotFountMsg
           End If
           
           lastCash_CellMatrix = getCellAdrFromMatrix
   End If
End Function


Public Function getFieldValue( _
    ByVal iCellAdr As String, _
    Optional ByVal rowOffest As Integer = 0, _
    Optional ByVal columnOffest As Integer = 0, _
    Optional ByVal sheetName As String = "", _
    Optional ByVal notFoundStr As String = "NOT FOUND") As String
    
    Dim retVal As String
    retVal = notFoundStr
    
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If

    If (iCellAdr <> notFoundStr) Then 'Not a valid cell Adr
        retVal = Sheets(sheetName).Range(iCellAdr).Offset(rowOffest, columnOffest).Value
    End If
    getFieldValue = retVal
End Function

Public Function findPatternPosition(ByVal inStr1 As String, ByVal patternStr As String) As String
    Dim inStrRes As Integer
    Dim retStr As String
    
    inStrRes = InStr(1, inStr1, patternStr)
    If (inStrRes = 0) Then
        retStr = "NOT FOUND"
    ElseIf (inStrRes = 1) Then
        If (Len(inStr1) = Len(patternStr)) Then
            retStr = "EQUAL"
        Else
            retStr = "STARTS"
        End If
    ElseIf (inStrRes = Len(inStr1) - Len(patternStr) + 1) Then
        retStr = "ENDS"
    Else
        retStr = "CONTAINS"
    End If
    findPatternPosition = retStr
End Function

Public Function inStrWalti(inStr1 As String, patternStr As String) As Integer
  inStrWalti = InStr(1, inStr1, patternStr, vbTextCompare)
End Function

Public Function clearRange( _
    Optional ByVal sheetName As String = "", _
    Optional ByVal upperLeft As String = "", _
    Optional ByVal lowerRight As String = "", _
    Optional ByVal clearString As String = "") As String
    
    Dim retString As String
    retString = ""
    
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If

    If ((upperLeft = "") And (lowerRight = "")) Then
        If (clearString = "") Then
            Sheets(sheetName).Cells.ClearContents
            retString = "INFO: Cleared whole sheet"
        Else
            ' Sheets(sheetName).Cells.Values = clearString
            retString = "ERROR: Set all cells in whole sheet to " & clearString & " is not allowed"
        End If
    Else
        If (clearString = "") Then
            Sheets(sheetName).Range(upperLeft & ":" & lowerRight).ClearContents
            retString = "INFO: Cleared range of cells in sheet"
        Else
            Sheets(sheetName).Range(upperLeft & ":" & lowerRight).Value = clearString
            retString = "INFO: Set range of cells to " & clearString
        End If
    End If
    clearRange = retString
End Function

Public Function findY_Interpolation( _
    ByVal xValue As Double, _
    ByVal xRange As Range, _
    ByVal yRange As Range) As Double
    
    Dim x1 As Double
    Dim y1 As Double
    
    Dim x2 As Double
    Dim y2 As Double
    
    Dim rangeSize As Integer
    
    Dim a As Double ' Steigung
    Dim c As Double ' Y-Achsenabschnitt
    Dim i As Integer
    i = 1
    
    
    If ((xRange.Rows.Count = 1) And (yRange.Rows.Count = 1)) Then
        If (xRange.Columns.Count = yRange.Columns.Count) Then
            rangeSize = xRange.Columns.Count
        Else
            rangeSize = -1
        End If
    Else
        If ((xRange.Columns.Count = 1) And (yRange.Columns.Count = 1)) Then
            If (xRange.Rows.Count = yRange.Rows.Count) Then
                rangeSize = xRange.Rows.Count
            Else
                rangeSize = -2
            End If
        Else
            rangeSize = -3
        End If
    End If
    
    ' Debug.Print ("rangeSize:" & rangeSize)
    While i <= rangeSize
        ' Debug.Print i & ":" & xRange(i).Value & "   /  " & yRange(i).Value
        If (xValue >= xRange(i).Value) Then
            x1 = xRange(i).Value
            y1 = yRange(i).Value
            x2 = xRange(i + 1).Value
            y2 = yRange(i + 1).Value
        End If
        i = i + 1
    Wend
    
    a = lin_a_P1P2(x1, y1, x2, y2)
    c = lin_c_P1P2(x1, y1, x2, y2)
    findY_Interpolation = lin_y_ac(a, c, xValue)
End Function

' timestamp function where timestamp contains milliseconds
' Timestamp examples
'            '2010-10-14T09:08:21.0733483'
'             2010-10-14 09:08:25,4034
' ======================================================
Public Function getNow() As Date
    getNow = Now
End Function

Public Function convertStringToDate(ByVal aStr As String) As Date
    convertStringToDate = aStr
End Function

Public Function getTimeDifferenceFromTimestamp(ByVal timeStamp1 As String, ByVal timeStamp2 As String) As Double
    Const secondsPerDay As Long = 86400
    
    Dim inputStringHasDate As Boolean
    inputStringHasDate = False
    
    Dim time1 As Double
    Dim time2 As Double
    Dim date1 As Date
    Dim date2 As Date
    
    time1 = getSecondsFromTime(getTimeFromTimestamp(RTrim(LTrim(Replace(timeStamp1, "'", " ")))))
    time2 = getSecondsFromTime(getTimeFromTimestamp(RTrim(LTrim(Replace(timeStamp2, "'", " ")))))

    If (isStringContainsRegEx(timeStamp1, datum_RegEx)) Then
        date1 = getStringsForRegEx(timeStamp1, datum_RegEx)
        inputStringHasDate = True
    End If
    If (isStringContainsRegEx(timeStamp2, datum_RegEx)) Then
        date2 = getStringsForRegEx(timeStamp2, datum_RegEx)
        inputStringHasDate = True
    End If
    
    If ((date1 - date2 = 0) Or (inputStringHasDate = False)) Then
        getTimeDifferenceFromTimestamp = Abs(time1 - time2)
    Else
        getTimeDifferenceFromTimestamp = Abs(Abs(time1 - time2) - Abs(date1 - date2) * secondsPerDay)
    End If
End Function

Public Function getDateMinusTime(ByVal timeStamp1 As String, ByVal timeStamp2 As String) As String
    Dim time1 As Long
    Dim dateStr1 As String
    Dim time2 As Long
    Dim retVal As String
    Dim tDiff As Long
    Dim tDiffStr As String
    
    time1 = getSecondsFromTime(getTimeFromTimestamp(RTrim(LTrim(Replace(timeStamp1, "'", " ")))))
    dateStr1 = getDateFromTimestamp(timeStamp1)
    time2 = getSecondsFromTime(RTrim(LTrim(Replace(timeStamp2, "'", " "))))
    If (time1 >= time2) Then
        retVal = dateStr1 & " " & formateSecondsToTimeStr(time1 - time2)
    Else
        tDiff = 86400 - time2
        tDiff = tDiff + time1
        tDiffStr = tDiff
        retVal = getPrevDate(dateStr1) & " " & formateSecondsToTimeStr(tDiffStr)
    End If
    getDateMinusTime = retVal
End Function

Public Function getDatePlusTime(ByVal timeStamp1 As String, ByVal timeStamp2 As String) As String
    Dim time1 As Long
    Dim dateStr1 As String
    Dim time2 As Long
    Dim retVal As String
    Dim timeSum As Long
    Dim timeSumStr As String
    
    time1 = getSecondsFromTime(getTimeFromTimestamp(RTrim(LTrim(Replace(timeStamp1, "'", " ")))))
    dateStr1 = getDateFromTimestamp(timeStamp1)
    time2 = getSecondsFromTime(RTrim(LTrim(Replace(timeStamp2, "'", " "))))
    timeSum = time1 + time2
    timeSumStr = timeSum
    If (timeSum < 86400) Then
        retVal = dateStr1 & " " & formateSecondsToTimeStr(timeSumStr)
    Else
        timeSum = timeSum - 86400
        timeSumStr = timeSum
        retVal = getNextDate(dateStr1) & " " & formateSecondsToTimeStr(timeSumStr)
    End If
    getDatePlusTime = retVal
End Function

Public Function addTimeToTimestamp(ByVal timeStamp As Date, ByVal duration As Double, ByVal einheit As String) As Date
    einheit = UCase(einheit)
    If ((einheit = "STUNDEN") Or (einheit = "HOURES") Or (einheit = "H")) Then
        duration = duration / 24
        
    End If
    
    addTimeToTimestamp = timeStamp + duration

End Function

Public Function getDateFromTimestamp(ByVal time As String) As String
   time = RTrim(LTrim(Replace(time, "'", " ")))
   getDateFromTimestamp = left(time, 10)
End Function

Public Function getTimeFromTimestamp(ByVal time As String) As String
   time = RTrim(LTrim(Replace(time, "'", " ")))
   getTimeFromTimestamp = Mid(time, 12)
End Function

Public Function nowAsString() As String
    Dim retVal As String
    retVal = getDateFromTimestamp(Now()) & " " & getTimeFromTimestamp(Now())
    nowAsString = retVal
End Function

Public Function getSecondsFromTimeOld(ByVal time As String) As Long
   Dim s As Long
   Dim m As Long
   Dim h As Long
   time = RTrim(LTrim(Replace(time, "'", " ")))
   
   h = left(time, 2)
   m = Mid(time, 4, 2)
   s = Replace(Mid(time, 7), ",", ".")
   s = s + (3600 * h) + (60 * m)
   getSecondsFromTime = s
End Function

' 2:04.10       => 12410
' 2min 4.10 sec => 12410
Public Function getHunderstelSecondsFromTime(ByVal timeStr As String) As Double
    If (getCountOfFieldsInString(timeStr, Application.DecimalSeparator) = 2) Then ' format 02:05:45.10 or 32:23.07
        getHunderstelSecondsFromTime = 100 * getSecondsFromTime(getFieldFromString(timeStr, Application.DecimalSeparator, 0)) + getFieldFromString(timeStr, Application.DecimalSeparator, 1)
    Else
        getHunderstelSecondsFromTime = 100 * getSecondsFromTime(timeStr)
    End If
End Function


' 2:04       => 124
' 2min 4 sec => 124
Public Function getSecondsFromTime(ByVal timeStr As String) As Double
   Dim s As Double
   Dim m As Double
   Dim h As Double
   
   timeStr = RTrim(LTrim(timeStr))
   If (timeStr = "") Then
    getSecondsFromTime = 0
    Exit Function
   End If
   If (strContains(timeStr, ".")) Or strContains(timeStr, ",") Then
        timeStr = Replace(timeStr, ".", Application.DecimalSeparator)
        timeStr = Replace(timeStr, ",", Application.DecimalSeparator)
   End If
   
   timeStr = LCase(RTrim(LTrim(Replace(timeStr, " ", ""))))
   timeStr = Replace(timeStr, "min", "'")
   timeStr = Replace(timeStr, "m", "'")
   timeStr = Replace(timeStr, "sec", getDoubleQuote())
   timeStr = Replace(timeStr, "s", getDoubleQuote())

   If (getCountOfFieldsInString(timeStr, ":") = 3) Then ' format 02:05:45
        h = getFieldFromString(timeStr, ":", 0)
        m = getFieldFromString(timeStr, ":", 1)
        s = getFieldFromString(timeStr, ":", 2)
   ElseIf (getCountOfFieldsInString(timeStr, ":") = 2) Then ' format 05:45  5Min 45 Sec
        h = 0
        m = getFieldFromString(timeStr, ":", 0)
        s = getFieldFromString(timeStr, ":", 1)
   Else
        If (strContains(timeStr, "h")) Then
            h = getFieldFromString(timeStr, "h", 0)
            Dim restStr As String
            restStr = getFieldFromString(timeStr, "h", 1)
        Else
            h = 0
            restStr = timeStr
        End If
        
        If (strContains(restStr, "'")) Then
            m = getFieldFromString(restStr, "'", 0)
            restStr = getFieldFromString(restStr, "'", 1)
        Else
            m = 0
            restStr = restStr
        End If
        
        If (strContains(restStr, getDoubleQuote())) Then
            s = getFieldFromString(restStr, getDoubleQuote(), 0)
        Else
            s = 0
        End If
   End If
   
   ' s = 1.000000000002 * s
   s = s + (3600 * h) + (60 * m)
   getSecondsFromTime = s
End Function


' 120'  ==> 2
' 3600" ==> 1
Public Function convertMinStrInStunden(ByVal inStr1 As String) As Long
   If (right(inStr1, 1) = "'") Then
      convertMinStrInStunden = (left(inStr1, Len(inStr1) - 1) / 60)
   ElseIf (right(inStr1, 1) = getDoubleQuote()) Then
      convertMinStrInStunden = (left(inStr1, Len(inStr1) - 1) / 3600)
   Else
      convertMinStrInStunden = inStr1
   End If
End Function

Public Function formateSecondsToTimeStr(ByVal s1 As String, Optional ByVal timeFormat As String = "hh:mm:ss") As String
   Dim s As Double
   Dim m As Double
   Dim h As Double
   h = s1 \ 3600
   m = (s1 - h * 3600) \ 60
   s = (s1 - h * 3600 - m * 60)
   
   Dim sStr As String
   Dim mStr As String
   Dim hStr As String
   sStr = s
   mStr = m
   hStr = h
   If ((timeFormat = "hh:mm:ss") Or (timeFormat = "")) Then
        formateSecondsToTimeStr = padString(hStr, "0", 2) & ":" & padString(mStr, "0", 2) & ":" & left(padString(sStr, "0", 2), 2)
   ElseIf (timeFormat = "h.") Then
        formateSecondsToTimeStr = h + (m / 60) + (s / 3600)
   ElseIf (timeFormat = "m.") Then
        formateSecondsToTimeStr = h * 60 + m + (s / 60)
   ElseIf (timeFormat = "s.") Then
        formateSecondsToTimeStr = "" & (h * 3600) + (m * 60) + s
   Else
        formateSecondsToTimeStr = padString(hStr, "0", 2) & getFieldFromString(timeFormat, ":", 0, False) & padString(mStr, "0", 2) & getFieldFromString(timeFormat, ":", 1, False) & padString(sStr, "0", 2) & getFieldFromString(timeFormat, ":", 2, False)
   End If
End Function

Public Function getTimeStampStr( _
        Optional ByVal WithDate As Boolean = True, _
        Optional ByVal WithTime As Boolean = True, _
        Optional ByVal DateSep As String = "_", _
        Optional ByVal TimeSep As String = ":", _
        Optional ByVal DateTimeSep As String = " ") As String

    Dim retStr As String
    Dim jetzt As Date
    jetzt = getNow()
    retStr = ""
    If WithDate Then
        retStr = retStr & Year(jetzt) & DateSep & padString(Month(jetzt), "0", 2) & DateSep & padString(Day(jetzt), "0", 2)
    End If
    If WithTime Then
        retStr = retStr & DateTimeSep & Hour(jetzt) & TimeSep & padString(Minute(jetzt), "0", 2) & TimeSep & padString(Second(jetzt), "0", 2)
    End If
    getTimeStampStr = retStr
End Function

' Date functions
' ======================================================
Public Function strToDate(ByVal dateStr As String) As Date
    strToDate = dateStr
End Function

Public Function fieldToDate(ByVal dateStr As Variant) As Date
    Dim dateStr1 As String
    Dim dateVal As Date
    
    If (fieldType(dateStr) = "DATE") Then
        fieldToDate = dateStr
    ElseIf (fieldType(dateStr) = "STRING") Then
        fieldToDate = strToDate(dateStr)
    End If
End Function

Public Function getWeekday(ByVal aDate As Date, Optional ByVal short As Boolean = True, Optional ByVal german As Boolean = True) As String
   Dim weekdayNr As Integer
   Dim weekdays() As Variant
   
   If short Then
      If german Then
         weekdays = Array("So", "Mo", "Di", "Mi", "Do", "Fr", "Sa")
      Else
         weekdays = Array("Su", "Mo", "Tu", "We", "Th", "Fr", "Sa")
      End If
   Else
      If german Then
         weekdays = Array("Sonntag", "Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag")
      Else
         weekdays = Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
      End If
   End If
   
   weekdayNr = weekday(aDate, 1)
   getWeekday = weekdays(weekdayNr - 1)
End Function

Public Function formatDate(ByVal aDate As Date, _
                           Optional ByVal shortDay As Boolean = True, _
                           Optional ByVal shortMonth As Boolean = True, _
                           Optional ByVal german As Boolean = True) As String
    Dim dayStr As String
    Dim monthStr As String
    Dim iDay As Integer
    Dim iYear As Integer

    dayStr = getWeekday(aDate, shortDay, german)
    monthStr = getMonthName(aDate, shortMonth, german)
    iDay = Day(aDate)
    iYear = Year(aDate)
    If (german) Then
        formatDate = dayStr & ", " & iDay & ". " & monthStr & " " & iYear
    Else
        formatDate = dayStr & ", " & monthStr & " " & iDay & "th  " & iYear
    End If
End Function

Public Function getWeekdayNr(ByVal weekdayName As String) As Integer
   weekdayName = UCase(weekdayName)
   Dim arrIndex As Integer
   Dim weekdays() As Variant
   weekdays = Array("SO", "MO", "DI", "MI", "DO", "FR", "SA")
      
   arrIndex = getArrayIndex(weekdays, weekdayName)
   If (arrIndex = 0) Then
      weekdays = Array("SU", "MO", "TU", "WE", "TH", "FR", "SA")
      arrIndex = getArrayIndex(weekdays, weekdayName)
      If (arrIndex = 0) Then
            weekdays = Array("SONNTAGA", "MONTAG", "DIENSTAG", "MITTWOCH", "DONNERSTAG", "FREITAG", "SAMSTAG")
            arrIndex = getArrayIndex(weekdays, weekdayName)
            If (arrIndex = 0) Then
                  weekdays = Array("SUNDAY", "MONDAY", "TUESDAY", "WEDNESDAY", "THURSDAY", "FRIDAY", "SATURDAY")
                  arrIndex = getArrayIndex(weekdays, weekdayName)
            End If
      End If
   End If
   
   getWeekdayNr = arrIndex
End Function

Public Function getMonthName(ByVal aDate As Date, Optional ByVal short As Boolean = True, Optional ByVal german As Boolean = True) As String
   Dim monthNr As Integer
   Dim monthNames() As Variant
   
   If short Then
      If german Then
         monthNames = Array("Jan", "Feb", "Mar", "Apr", "Mai", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dez")
      Else
         monthNames = Array("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
      End If
   Else
      If german Then
         monthNames = Array("Januar", "Februar", "März", "April", "Mai", "Juni", "Juli", "August", "September", "Oktober", "November", "Dezember")
      Else
         monthNames = Array("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
      End If
   End If
   
   monthNr = Month(aDate)
   getMonthName = monthNames(monthNr - 1)
End Function

Public Function getMonthNr(ByVal monthName As String) As Integer
   monthName = UCase(monthName)
   monthName = left(monthName, 3)
   Dim monthNames() As Variant
   monthNames = Array("JAN", "FEB", UCase("Mär"), "APR", "MAI", "JUN", "JUL", "AUG", "SEP", "OKT", "NOV", "DEZ")
   
   Dim arrIndex As Integer
   arrIndex = getArrayIndex(monthNames, monthName)
   If (arrIndex = 0) Then
     monthNames = Array("JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC")
     arrIndex = getArrayIndex(monthNames, monthName)
   End If
   getMonthNr = arrIndex
End Function

Public Function isLeapyear(ByVal aDate As Date) As Boolean
   isLeapyear = isSchaltjahr(Year(aDate))
End Function

Public Function isSchaltjahr(ByVal Jahreszahl As Integer) As Boolean
  If (Jahreszahl Mod 4) = 0 And (Jahreszahl Mod 100) <> 0 Or _
    ((Jahreszahl Mod 400) = 0) Then
     isSchaltjahr = True
  Else
     isSchaltjahr = False
  End If
End Function

Public Function getMaxDaysForMonth(ByVal monthNr As Integer, ByVal yearNr As Integer) As Integer
  Dim retVal1 As Integer
  retVal1 = 31
  If (monthNr = 4) Or (monthNr = 6) Or (monthNr = 9) Or (monthNr = 11) Then
    retVal1 = 30
  ElseIf (monthNr = 2) Then
     If isSchaltjahr(yearNr) Then
       retVal1 = 29
     Else
       retVal1 = 30
     End If
  End If
  getMaxDaysForMonth = retVal1
End Function

Public Function getLastWeekdayBeforeDate(ByVal aDate As Date, ByVal weekdayName As String) As Date
   Dim weekdayNr As Integer
   Dim reqWeekdayNr As Integer
   
   reqWeekdayNr = getWeekdayNr(weekdayName)
   weekdayNr = weekday(aDate, 1)
   If (weekdayNr >= reqWeekdayNr) Then
       getLastWeekdayBeforeDate = aDate - (weekdayNr - reqWeekdayNr)
   Else
       getLastWeekdayBeforeDate = aDate - (reqWeekdayNr - weekdayNr) - 5
   End If
End Function

Public Function getPrevDate(ByVal aDate1 As String) As String
   Dim aDate1Date As Date
   aDate1Date = aDate1
   getPrevDate = aDate1Date - 1
End Function

Public Function getNextDate(ByVal aDate1 As String) As String
   Dim aDate1Date As Date
   aDate1Date = aDate1
   getNextDate = aDate1Date + 1
End Function

Public Function addDaysToDate(ByVal aDate1 As String, ByVal daysToAdd As Integer) As String
   Dim aDate1Date As Date
   aDate1Date = aDate1
   addDaysToDate = aDate1Date + daysToAdd
End Function


Public Function fieldType(ByVal aFieldVal As Variant, Optional ByVal resAsString As Boolean = True) As String
    Dim fType As String
    fType = VarType(aFieldVal)
    If (resAsString = True) Then
        If (fType = "0") Then
            fieldType = "EMPTY"
        ElseIf (fType = "1") Then
            fieldType = "NOT_VALID"
        ElseIf (fType = "2") Then
            fieldType = "INTEGER"
        ElseIf (fType = "3") Then
            fieldType = "LONG_INTEGER"
        ElseIf (fType = "4") Then
            fieldType = "SINGLE"
        ElseIf (fType = "5") Then
            fieldType = "DOUBLE"
        ElseIf (fType = "6") Then
            fieldType = "CURRENCY"
        ElseIf (fType = "7") Then
            fieldType = "DATE"
        ElseIf (fType = "8") Then
            fieldType = "STRING"
        ElseIf (fType = "9") Then
            fieldType = "OBJECT"
        ElseIf (fType = "10") Then
            fieldType = "ERROR"
        ElseIf (fType = "11") Then
            fieldType = "BOOLEAN"
        ElseIf (fType = "12") Then
            fieldType = "VARIANT"
        ElseIf (fType = "13") Then
            fieldType = "DATA_ACCESS_OBJECT"
        ElseIf (fType = "14") Then
            fieldType = "DECIMAL"
        ElseIf (fType = "17") Then
            fieldType = "BYTE"
        ElseIf (fType = "36") Then
            fieldType = "USER_DEFINED"
        ElseIf (fType = "8192") Then
            fieldType = "ARRAY"
        Else
            fieldType = "UNKNOWN-TYPE:" & fType
        End If
    Else
        fieldType = fType
    End If
    
End Function

' Special Holidays (Zurich)
' ======================================================
Function getEaster(intYear As Integer) As Date
   Dim x As Double, y As Double, str As Date, z As Date

    x = Minute(intYear / 38)
    y = Day(x / 2 + 56)
    str = y & "/5/" & intYear
    z = Application.WorksheetFunction.Floor(str, 7) - 34
    getEaster = CDate(z)
End Function

Function getChristmas(intYear As Integer) As Date
    Dim x As Date

    x = intYear & "/12/25"
    getChristmas = CDate(x)
End Function

Function getNewYear(intYear As Integer) As Date
    Dim x As Date
    
    x = intYear & "/1/1"
    getNewYear = CDate(x)
End Function

Function getBerchtoldstag(intYear As Integer) As Date
    Dim x As Date

    x = intYear & "/1/2"
    getBerchtoldstag = CDate(x)
End Function

Function getHolyThursday(intYear As Integer) As Date
    Dim x As Date

    x = getEaster(intYear) - 3
    getHolyThursday = CDate(x)
End Function

Function getGoodFriday(intYear As Integer) As Date
    Dim x As Date

    x = getHolyThursday(intYear) + 1
    getGoodFriday = CDate(x)
End Function

Function getEasterMonday(intYear As Integer) As Date
    Dim x As Date

    x = getEaster(intYear) + 1

    getEasterMonday = CDate(x)
End Function

Function getLaborDay(intYear As Integer) As Date
    Dim x As Date

    x = intYear & "/5/1"
    getLaborDay = CDate(x)
End Function

Function getWednesdayBeforeAscension(intYear As Integer) As Date
    Dim x As Date

    x = getEaster(intYear) + 38
    getWednesdayBeforeAscension = CDate(x)
End Function

Function getAscension(intYear As Integer) As Date
    Dim x As Date

    x = getWednesdayBeforeAscension(intYear) + 1
    getAscension = CDate(x)
End Function

Function getPentecost(intYear As Integer) As Date
    Dim x As Date

    x = getEaster(intYear) + 49
    getPentecost = CDate(x)
End Function

Function getPentecostMonday(intYear As Integer) As Date
    Dim x As Date

    x = getPentecost(intYear) + 1
    getPentecostMonday = CDate(x)
End Function

Function getNationalHoliday(intYear As Integer) As Date
    Dim x As Date

    x = intYear & "/8/1"
    getNationalHoliday = CDate(x)
End Function

Function getChristmasEve(intYear As Integer) As Date
    Dim x As Date

    x = intYear & "/12/24"
    getChristmasEve = CDate(x)
End Function

Function getBoxingDay(intYear As Integer) As Date
    Dim x As Date

    x = intYear & "/12/26"
    getBoxingDay = CDate(x)
End Function

Function getNewYearsEve(intYear As Integer) As Date
    Dim x As Date

    x = intYear & "/12/31"
    getNewYearsEve = CDate(x)
End Function

Function getHolidayDate(intYear As Integer, holiday As String) As Date
    Dim holidayName As String

    ' holidaynames in german and english / caseinsensitive and abreviations accepted
    holidayName = LCase(holiday)

    If holidayName = "new year" Or holidayName = "neujahr" Or holidayName = "ny" Then
        getHolidayDate = getNewYear(intYear)
    ElseIf holidayName = "berchtoldstag" Or holidayName = "berch" Or holidayName = "ber" Then
        getHolidayDate = getBerchtoldstag(intYear)
    ElseIf holidayName = "holy thursday" Or holidayName = "gründonnerstag" Or holidayName = "ht" Or holidayName = "hol" Then
        getHolidayDate = getHolyThursday(intYear)
    ElseIf holidayName = "good friday" Or holidayName = "karfreitag" Or holidayName = "gf" Or holidayName = "kar" Then
        getHolidayDate = getGoodFriday(intYear)
    ElseIf holidayName = "easter" Or holidayName = "easter" Or holidayName = "eas" Or holidayName = "east" Or holidayName = "ostern" Or holidayName = "ost" Then
        getHolidayDate = getEaster(intYear)
    ElseIf holidayName = "easter monday" Or holidayName = "ostermontag" Or holidayName = "em" Then
        getHolidayDate = getEasterMonday(intYear)
    ElseIf holidayName = "labor day" Or holidayName = "tag der arbeit" Or holidayName = "ld" Or holidayName = "tda" Then
        getHolidayDate = getLaborDay(intYear)
    ElseIf holidayName = "wednesday before ascension" Or holidayName = "mittwoch vor auffahrt" Or holidayName = "wba" Or holidayName = "mva" Or holidayName = "mittwoch vor der auffahrt" Or holidayName = "mvda" Then
        getHolidayDate = getWednesdayBeforeAscension(intYear)
    ElseIf holidayName = "ascension" Or holidayName = "auffahrt" Or holidayName = "asc" Or holidayName = "asce" Then
        getHolidayDate = getAscension(intYear)
    ElseIf holidayName = "pentecost" Or holidayName = "pfingsten" Or holidayName = "pen" Or holidayName = "pent" Then
        getHolidayDate = getPentecost(intYear)
    ElseIf holidayName = "pentecost monday" Or holidayName = "pfingstmontag" Or holidayName = "pent mon" Or holidayName = "pen mon" Then
        getHolidayDate = getPentecostMonday(intYear)
    ElseIf holidayName = "national holiday" Or holidayName = "nationalfeiertag" Or holidayName = "nat" Then
        getHolidayDate = getNationalHoliday(intYear)
    ElseIf holidayName = "christmas eve" Or holidayName = "heiligabend" Or holidayName = "chris eve" Or holidayName = "heil" Then
        getHolidayDate = getChristmasEve(intYear)
    ElseIf holidayName = "christmas" Or holidayName = "weihnachten" Or holidayName = "chris" Or holidayName = "wei" Or holidayName = "weih" Then
        getHolidayDate = getChristmas(intYear)
    ElseIf holidayName = "boxing day" Or holidayName = "stefanstag" Or holidayName = "boxing" Or holidayName = "box" Then
        getHolidayDate = getBoxingDay(intYear)
    ElseIf holidayName = "new years eve" Or holidayName = "silvestertag" Or holidayName = "nye" Or holidayName = "silvester" Then
        getHolidayDate = getNewYearsEve(intYear)
    End If
End Function

Function getHolidayNames(Optional ByVal sep As String = ",", Optional ByVal language As String = "DE") As String
    Dim retStr As String
    If ((language = "DE") Or (language = "German")) Then
        retStr = "Neujahr" & sep & "Berchtoldstag" & sep & "Gründonnerstag" & sep & "Karfreitag" & sep & "Ostern" & sep & "Ostermontag" & sep & "Tag der Arbeit" & sep & "Mittwoch vor Auffahrt" & sep & "Auffahrt" & sep & "Pfingsten" & sep & "Pfingstmontag" & sep & "Nationalfeiertag" & sep & "Heiligabend" & sep & "Weihnachten" & sep & "Stefanstag" & sep & "Silvester"
    Else
        retStr = "New Year" & sep & "Berchtoldstag" & sep & "Holy Thursday" & sep & "Good Friday" & sep & "Easter" & sep & "Easter Monday" & sep & "Labor Day" & sep & "Wednesday Before Ascension" & sep & "Ascension" & sep & "Pentecost" & sep & "Pentecost Monday" & sep & "National Holiday" & sep & "Christmas Eve" & sep & "Christmas" & sep & "Boxing Day" & sep & "New Years Eve"
    End If
    
    getHolidayNames = retStr
End Function

Function getHolidayNameForDate(ByVal aDate As Date, Optional language As String = "DE") As String
    Dim holidayList As String
    Dim retStr As String
    Dim resArray
    Dim bbDate As Date
    Dim aHoliName As String
    
    If (language = "German") Then
        language = "DE"
    End If
    retStr = ""
    holidayList = getHolidayNames(",", language)
    resArray = Split(holidayList, ",", -1, 1)
    For i = LBound(resArray) To UBound(resArray)
        aHoliName = resArray(i)
        bbDate = getHolidayDate(Year(aDate), aHoliName)
        If (aDate = bbDate) Then
            retStr = aHoliName
            Exit For
        End If
    Next i
    getHolidayNameForDate = retStr
End Function

' Workday calculation
' ======================================================

' Date and Workdays calculation
' ======================================================
Public Function WorkDays(ByVal startDate As Date, ByVal endDate As Date) As Long

   Dim dtFirstSunday As Date
   Dim dtLastSaturday As Date
   Dim lngWorkDays As Long

   ' get first sunday in range
   dtFirstSunday = startDate + ((8 - weekday(startDate)) Mod 7)

   ' get last saturday in range
   dtLastSaturday = endDate - (weekday(endDate) Mod 7)

   ' get work days between first sunday and last saturday
   lngWorkDays = (((dtLastSaturday - dtFirstSunday) + 1) / 7) * 5

   ' if first sunday is not begin date
   If dtFirstSunday <> startDate Then

      ' assume first sunday is after begin date
      ' add workdays from begin date to first sunday
      lngWorkDays = lngWorkDays + (7 - weekday(startDate))

   End If

   ' if last saturday is not end date
   If dtLastSaturday <> endDate Then

      ' assume last saturday is before end date
      ' add workdays from last saturday to end date
      lngWorkDays = lngWorkDays + (weekday(endDate) - 1)

   End If

   ' return working days
   WorkDays = lngWorkDays

End Function

Public Function dhAddWorkDaysA( _
               daysToAdd As Long, _
      Optional startDate As Date = 0, _
      Optional holidaysDates As Variant) As Date
    ' Add the specified number of work days to the
    ' specified date.
        
    ' In:
    '   lngDays:
    '       Number of work days to add to the start date.
    '   dtmDate:
    '       date on which to start looking.
    '       Use the current date, if none was specified.
    '   holidaysDates (Optional):
    '       Array containing holiday dates. Can also be a single
    '       date value, if that's what you want.
    ' Out:
    '   Return Value:
    '       The date of the working day lngDays from the start, taking
    '       into account weekends and holidays.
    ' Example:
    '   dhAddWorkDaysA(10, #2/9/2000#, Array(#2/16/2000#, #2/17/2000#))
    '   returns #2/25/2000#, which is the date 10 work days
    '   after 2/9/2000, if you treat 2/16 and 2/17 as holidays
    '   (just made-up holidays, for example purposes only).
    
    ' Did the caller pass in a date? If not, use
    ' the current date.
    Dim lngCount As Long
    Dim dtmTemp As Date
    
    If startDate = 0 Then
        startDate = Date
    End If
    
    dtmTemp = startDate
    For lngCount = 1 To daysToAdd
        dtmTemp = dhNextWorkdayA(dtmTemp, holidaysDates)
    Next lngCount
    dhAddWorkDaysA = dtmTemp
End Function

Public Function dhNextWorkdayA( _
       Optional startDate As Date = 0, _
       Optional holidaysDates As Variant = Empty) As Date
    
    ' Return the next working day after the specified date.
    
    ' Requires:
    '   SkipHolidays
    '   IsWeekend
    
    ' In:
    '   startDate:
    '       date on which to start looking.
    '       Use the current date, if none was specified.
    '   holidaysDates (Optional):
    '       Array containing holiday dates. Can also be a single
    '       date value.
    ' Out:
    '   Return Value:
    '       The date of the next working day, taking
    '       into account weekends and holidays.
    ' Example:
    '   ' Find the next working date after 5/30/97
    '   startDate = dhNextWorkdayA(#5/23/1997#, #5/26/97#)
    '   ' startDate should be 5/27/97, because 5/26/97 is Memorial day.
    
    ' Did the caller pass in a date? If not, use
    ' the current date.
    If startDate = 0 Then
        startDate = Date
    End If
    
    dhNextWorkdayA = SkipHolidaysA(holidaysDates, startDate + 1, 1)
End Function

Public Function dhPreviousWorkdayA( _
       Optional startDate As Date = 0, _
       Optional holidaysDates As Variant = Empty) As Date
    
    ' Return the previous working day before the specified date.
        
    ' Requires:
    '   SkipHolidays
    '   IsWeekend
    
    ' In:
    '   startDate:
    '       date on which to start looking.
    '       Use the current date, if none was specified.
    '   holidaysDates (Optional):
    '       Array containing holiday dates. Can also be a single
    '       date value.
    ' Out:
    '   Return Value:
    '       The date of the previous working day, taking
    '       into account weekends and holidays.
    ' Example:
    '   ' Find the next working date before 1/1/2000
    
    '   startDate = dhPreviousWorkdayA(#1/1/2000#, Array(#12/31/1999#, #1/1/2000#))
    '   ' startDate should be 12/30/1999, because of the New Year's holidays.
    
    ' Did the caller pass in a date? If not, use
    ' the current date.
    If startDate = 0 Then
        startDate = Date
    End If
    
    dhPreviousWorkdayA = SkipHolidaysA(holidaysDates, startDate - 1, -1)
End Function

Public Function dhFirstWorkdayInMonthA( _
          Optional startDate As Date = 0, _
          Optional holidaysDates As Variant = Empty) As Date
    
    ' Return the first working day in the month specified.
        
    ' Requires:
    '   SkipHolidays
    '   IsWeekend
    
    ' In:
    '   startDate:
    '       date within the month of interest.
    '       Use the current date, if none was specified.
    '   holidaysDates (Optional):
    '       Array containing holiday dates. Can also be a single
    '       date value.
    ' Out:
    '   Return Value:
    '       The date of the first working day in the month, taking
    '       into account weekends and holidays.
    ' Example:
    '   ' Find the first working day in 1999
    '   startDate = dhFirstWorkdayInMonthA(#1/1/1999#, #1/1/1999#)
    
    Dim dtmTemp As Date
    
    ' Did the caller pass in a date? If not, use
    ' the current date.
    If startDate = 0 Then
        startDate = Date
    End If
    
    dtmTemp = DateSerial(Year(startDate), Month(startDate), 1)
    dhFirstWorkdayInMonthA = SkipHolidaysA(holidaysDates, dtmTemp, 1)
End Function

Public Function dhLastWorkdayInMonthA( _
        Optional startDate As Date = 0, _
        Optional holidaysDates As Variant = Empty) As Date
    
    ' Return the last working day in the month specified.
        
    ' Requires:
    '   SkipHolidays
    '   IsWeekend
    
    ' In:
    '   startDate:
    '       date within the month of interest.
    '       Use the current date, if none was specified.
    '   holidaysDates (Optional):
    '       Array containing holiday dates. Can also be a single
    '       date value.
    ' Out:
    '   Return Value:
    '       The date of the last working day in the month, taking
    '       into account weekends and holidays.
    ' Example:
    '   ' Find the last working day in 1999
    '   startDate = dhLastWorkdayInMonthA(#12/1/1999#, #12/31/1999#)
    
    Dim dtmTemp As Date
    
    ' Did the caller pass in a date? If not, use
    ' the current date.
    If startDate = 0 Then
        startDate = Date
    End If
    
    dtmTemp = DateSerial(Year(startDate), Month(startDate) + 1, 0)
    dhLastWorkdayInMonthA = SkipHolidaysA(holidaysDates, dtmTemp, -1)
End Function


Public Function dhCountWorkdaysA( _
               ByVal startDate As Date, _
               ByVal endDate As Date, _
               Optional holidaysDates As Variant = Empty) As Integer

    ' Count the business days (not counting weekends/holidays) in
    ' a given date range.
        
    ' Requires:
    '   SkipHolidays
    '   CountHolidays
    '   IsWeekend
    
    ' In:
    '   startDate:
    '       Date specifying the start of the range (inclusive)
    '   endDate:
    '       Date specifying the end of the range (inclusive)
    '       (dates will be swapped if out of order)
    '   holidaysDates (Optional):
    '       Array containing holiday dates. Can also be a single
    '       date value.
    ' Out:
    '   Return Value:
    '       Number of working days (not counting weekends and optionally, holidays)
    '       in the specified range.
    ' Example:
    '   Debug.Print dhCountWorkdaysA(#7/2/2000#, #7/5/2000#, _
    '    Array(#1/1/2000#, #7/4/2000#))
    '
    '   returns 2, because 7/2/2000 is Sunday, 7/4/2000 is a holiday,
    '   leaving 7/3 and 7/5 as workdays.
    
    Dim intDays As Integer
    Dim dtmTemp As Date
    Dim intSubtract As Integer
    
    ' Swap the dates if necessary.>
    If endDate < startDate Then
        dtmTemp = startDate
        startDate = endDate
        endDate = dtmTemp
    End If
    
    ' Get the start and end dates to be weekdays.
    startDate = SkipHolidaysA(holidaysDates, startDate, 1)
    endDate = SkipHolidaysA(holidaysDates, endDate, -1)
    If startDate > endDate Then
        ' Sorry, no Workdays to be had. Just return 0.
        dhCountWorkdaysA = 0
    Else
        intDays = endDate - startDate + 1
        
        ' Subtract off weekend days.  Do this by figuring out how
        ' many calendar weeks there are between the dates, and
        ' multiplying the difference by two (because there are two
        ' weekend days for each week). That is, if the difference
        ' is 0, the two days are in the same week. If the
        ' difference is 1, then we have two weekend days.
        intSubtract = (DateDiff("ww", startDate, endDate) * 2)
        
        ' The answer to our quest is all the weekdays, minus any
        ' holidays found in the table.
        intSubtract = intSubtract + _
         CountHolidaysA(holidaysDates, startDate, endDate)
        
        dhCountWorkdaysA = intDays - intSubtract
    End If
End Function

Private Function CountHolidaysA( _
    adtmDates As Variant, _
    dtmStart As Date, dtmEnd As Date) As Long

    ' Count holidays between two end dates.
    
    ' Required by:
    '   dhCountWorkdays
    
    ' Requires:
    '   IsWeekend
    
    
    Dim lngItem As Long
    Dim lngCount As Long
    Dim blnFound As Long
    Dim dtmTemp As Date
    
    On Error GoTo HandleErr
    lngCount = 0
    Select Case VarType(adtmDates)
        Case vbArray + vbDate, vbArray + vbVariant
            ' You got an array of variants, or of dates.
            ' Loop through, looking for non-weekend values
            ' between the two endpoints.
            For lngItem = LBound(adtmDates) To UBound(adtmDates)
                dtmTemp = adtmDates(lngItem)
                If dtmTemp >= dtmStart And dtmTemp <= dtmEnd Then
                    If Not IsWeekend(dtmTemp) Then
                        lngCount = lngCount + 1
                    End If
                End If
            Next lngItem
        Case vbDate
            ' You got one date. So see if it's a non-weekend
            ' date between the two endpoints.
            If adtmDates >= dtmStart And adtmDates <= dtmEnd Then
                If Not IsWeekend(adtmDates) Then
                    lngCount = 1
                End If
            End If
    End Select

ExitHere:
    CountHolidaysA = lngCount
    Exit Function
    
HandleErr:
    ' No matter what the error, just
    ' return without complaining.
    ' The worst that could happen is that the code
    ' include a holiday as a real day, even if
    ' it's in the table.
    Resume ExitHere
End Function

Private Function FindItemInArray(varItemToFind As Variant, _
    avarItemsToSearch As Variant) As Boolean
    Dim lngItem As Long
    
    On Error GoTo HandleErrors
    
    For lngItem = LBound(avarItemsToSearch) To UBound(avarItemsToSearch)
        If avarItemsToSearch(lngItem) = varItemToFind Then
            FindItemInArray = True
            GoTo ExitHere
        End If
    Next lngItem
    
ExitHere:
    Exit Function
    
HandleErrors:
    ' Do nothing at all.
    ' Return False.
    Resume ExitHere
End Function

Private Function IsWeekend(dtmTemp As Variant) As Boolean
    ' If your weekends aren't Saturday (day 7) and Sunday (day 1),
    ' change this routine to return True for whatever days
    ' you DO treat as weekend days.
        
    ' Required by:
    '   SkipHolidays
    '   dhFirstWorkdayInMonth
    '   dbLastWorkdayInMonth
    '   dhNextWorkday
    '   dhPreviousWorkday
    '   dhCountWorkdays
    
    If VarType(dtmTemp) = vbDate Then
        Select Case weekday(dtmTemp)
            Case vbSaturday, vbSunday
                IsWeekend = True
            Case Else
                IsWeekend = False
        End Select
    End If
End Function

Private Function SkipHolidaysA( _
    adtmDates As Variant, _
    dtmTemp As Date, intIncrement As Integer) As Date
    ' Skip weekend days, and holidays in the array referred to by adtmDates.
    ' Return dtmTemp + as many days as it takes to get to a day that's not
    ' a holiday or weekend.
        
    ' Required by:
    '   dhFirstWorkdayInMonthA
    '   dbLastWorkdayInMonthA
    '   dhNextWorkdayA
    '   dhPreviousWorkdayA
    '   dhCountWorkdaysA
    
    ' Requires:
    '   IsWeekend
    
    Dim strCriteria As String
    Dim strFieldName As String
    Dim lngItem As Long
    Dim blnFound As Boolean
    
    On Error GoTo HandleErrors
    
    ' Move up to the first Monday/last Friday, if the first/last
    ' of the month was a weekend date. Then skip holidays.
    ' Repeat this entire process until you get to a weekday.
    ' Unless adtmDates an item for every day in the year (!)
    ' this should finally converge on a weekday.
    
    Do
        Do While IsWeekend(dtmTemp)
            dtmTemp = dtmTemp + intIncrement
        Loop
        Select Case VarType(adtmDates)
            Case vbArray + vbDate, vbArray + vbVariant
                Do
                    blnFound = FindItemInArray(dtmTemp, adtmDates)
                    If blnFound Then
                        dtmTemp = dtmTemp + intIncrement
                    End If
                Loop Until Not blnFound
            Case vbDate
                If dtmTemp = adtmDates Then
                    dtmTemp = dtmTemp + intIncrement
                End If
        End Select
    Loop Until Not IsWeekend(dtmTemp)
    
ExitHere:
    SkipHolidaysA = dtmTemp
    Exit Function
    
HandleErrors:
    ' No matter what the error, just
    ' return without complaining.
    ' The worst that could happen is that we
    ' include a holiday as a real day, even if
    ' it's in the array.
    Resume ExitHere
End Function




' Army Ranking functions
' ======================================================
Public Function getGradeFromOrd(ordValue As Integer, short As Boolean) As String
   Dim grades() As Variant
   If (ordValue < 0) Or (ordValue > 26) Then
        getGradeFromOrd = "Unknown"
   Else
        If short Then
          grades = Array("Sdt", "Gfr", "Obgfr", "Kpl", "Wm", "Obwm", "Fw", "Four", "Hptfw", "Adj", "Stabsadj", "Hptadj", "Chefadj", "Lt", "Oblt", "Htpm", "Hptm i Gst", "Maj", "Maj i Gst", "Oberstlt", "Oberstlt  i Gst", "Oberst", "Oberst  i Gst", "Br", "Div", "KKdt", "General")
        Else
          grades = Array("Soldat", "Gefreiter", "Obergefreiter", "Korporal", "Wachtmeisterm", "Oberwameister", "Feldweibel", "Fourier", "Hauptfeldweibel", "Adjutant Unteroffizier", "Stabsadjutant", "Hauptadjutant", "Chefadjutant", "Leutnant", "Oberleutnant", "Hauptmann", "Hauptmann i Gst", "Major", "Major i Gst", "Oberstleutnant", "Oberstleutnant  i Gst", "Oberst", "Oberst  i Gst", "Brigadier", "Divisionär", "Korpskommandant", "General")
        End If
        getGradeFromOrd = grades(ordValue)
   End If
End Function

Public Function getOrdFromGrade(grade As String) As Integer
   Dim retValue As Integer
   Dim gIndexInt As Integer
   retValue = -1
   
   Dim gradesShort() As Variant
   Dim gradesLong() As Variant
   gradesShort = Array("Sdt", "Gfr", "Obgfr", "Kpl", "Wm", "Obwm", "Fw", "Four", "Hptfw", "Adj", "Stabsadj", "Hptadj", "Chefadj", "Lt", "Oblt", "Htpm", "Hptm i Gst", "Maj", "Maj i Gst", "Oberstlt", "Oberstlt  i Gst", "Oberst", "Oberst  i Gst", "Br", "Div", "KKdt", "General")
   gradesLong = Array("Soldat", "Gefreiter", "Obergefreiter", "Korporal", "Wachtmeisterm", "Oberwameister", "Feldweibel", "Fourier", "Hauptfeldweibel", "Adjutant Unteroffizier", "Stabsadjutant", "Hauptadjutant", "Chefadjutant", "Leutnant", "Oberleutnant", "Hauptmann", "Hauptmann i Gst", "Major", "Major i Gst", "Oberstleutnant", "Oberstleutnant  i Gst", "Oberst", "Oberst  i Gst", "Brigadier", "Divisionär", "Korpskommandant", "General")
   
   
   For gIndexInt = 0 To UBound(gradesShort)
       If UCase(gradesShort(gIndexInt)) = UCase(grade) Then
           retValue = gIndexInt
           Exit For
       End If
   Next
   If retValue = -1 Then
      For gIndexInt = 0 To UBound(gradesLong)
       If UCase(gradesLong(gIndexInt)) = UCase(grade) Then
           retValue = gIndexInt
           Exit For
       End If
      Next
   End If
   
   getOrdFromGrade = retValue
End Function

Public Function isOfficer(ordValue As Integer) As Boolean
   If (ordValue >= 13) And (ordValue <= 26) Then
      isOfficer = True
   Else
      isOfficer = False
   End If
End Function

Public Function isSubOfficer(ordValue As Integer) As Boolean
   If (ordValue >= 3) And (ordValue < 13) Then
      isSubOfficer = True
   Else
      isSubOfficer = False
   End If
End Function

Public Function getNextGrade(grade As String, retStringShort As Boolean) As String
   Dim ordVal As Integer
   ordVal = getOrdFromGrade(grade)
   If (ordVal >= 0) And (ordVal <= 26) Then
      getNextGrade = getGradeFromOrd(ordVal + 1, retStringShort)
   Else
      getNextGrade = "Unknown"
   End If
End Function

Public Function getPrevGrade(grade As String, retStringShort As Boolean) As String
   Dim ordVal As Integer
   ordVal = getOrdFromGrade(grade)
   If (ordVal >= 0) And (ordVal <= 26) Then
      getPrevGrade = getGradeFromOrd(ordVal - 1, retStringShort)
   Else
      getPrevGrade = "Unknown"
   End If
End Function

' Hidding columns which are emty for non hidden rows
' ======================================================
Sub Test_isColumnEmtyForNotHiddenRows()
   If isColumnEmtyForNotHiddenRows("C", 5, 14) Then
     Columns("C:C").EntireColumn.Hidden = True
   Else
     Columns("C:C").EntireColumn.Hidden = False
   End If
End Sub

Public Function isColumnEmtyForNotHiddenRows(column As String, startRow As Integer, endRow As Integer) As Boolean
   Dim retVal As Boolean
   retVal = True
   For rowIndex = startRow To endRow
      If Not (Rows(rowIndex & ":" & rowIndex).Hidden) Then
         If Range(column & rowIndex).Value <> "" Then
            retVal = False
         End If
      End If
   Next
   isColumnEmtyForNotHiddenRows = retVal
End Function


' Eng Functions
' ======================================================
Public Function getPowerFacFromKiloMega(ByVal kiloStr As String) As Integer
  If ((kiloStr = "h") Or (LCase(kiloStr) = "hekto")) Then
     getPowerFacFromKiloMega = 2
  ElseIf ((kiloStr = "k") Or (LCase(kiloStr) = "kilo")) Then
     getPowerFacFromKiloMega = 3
  ElseIf ((kiloStr = "M") Or (LCase(kiloStr) = "mega")) Then
     getPowerFacFromKiloMega = 6
  ElseIf ((kiloStr = "G") Or (LCase(kiloStr) = "giga")) Then
     getPowerFacFromKiloMega = 9
  ElseIf ((kiloStr = "T") Or (LCase(kiloStr) = "tera")) Then
     getPowerFacFromKiloMega = 12
  ElseIf ((kiloStr = "P") Or (LCase(kiloStr) = "peta")) Then
     getPowerFacFromKiloMega = 15
  ElseIf ((kiloStr = "E") Or (LCase(kiloStr) = "exa")) Then
     getPowerFacFromKiloMega = 18
  ElseIf ((kiloStr = "Z") Or (LCase(kiloStr) = "zetta")) Then
     getPowerFacFromKiloMega = 21
  ElseIf ((kiloStr = "Y") Or (LCase(kiloStr) = "yotta")) Then
     getPowerFacFromKiloMega = 24
     
  ElseIf ((kiloStr = "d") Or (LCase(kiloStr) = "dezi")) Then
     getPowerFacFromKiloMega = -1
  ElseIf ((kiloStr = "c") Or (LCase(kiloStr) = "centi")) Then
     getPowerFacFromKiloMega = -2
  ElseIf ((kiloStr = "m") Or (LCase(kiloStr) = "mili")) Then
     getPowerFacFromKiloMega = -3
  ElseIf ((kiloStr = "u") Or (LCase(kiloStr) = "mikro")) Then
     getPowerFacFromKiloMega = -6
  ElseIf ((kiloStr = "n") Or (LCase(kiloStr) = "nano")) Then
     getPowerFacFromKiloMega = -9
  ElseIf ((kiloStr = "p") Or (LCase(kiloStr) = "piko")) Then
     getPowerFacFromKiloMega = -12
  Else
    getPowerFacFromKiloMega = 0
  End If
End Function

'returns 10^x
Public Function getFactorFromPowerFac(ByVal Exponent As Integer) As Double
    getFactorFromPowerFac = 10 ^ Exponent
End Function

' m ->0.001    k->1000
Public Function getFacFromKiloMega(ByVal kiloStr As String) As Double
  getFacFromKiloMega = getFactorFromPowerFac(getPowerFacFromKiloMega(kiloStr))
End Function

' e.g. U1 = 5kV mit Verrechnung von kilo,....
Public Function getDoubleFromPhyVal(ByVal phyVal As String) As Double
  Dim zVal As Double
  Dim doubleKiloStr As String
  Dim kiloMegaStr As String
  Dim tmpStr As String
  
  If (strContains(phyVal, "=")) Then
    doubleKiloStr = getFieldFromString(phyVal, "=", 1)
    doubleKiloStr = RTrim(LTrim(doubleKiloStr))
  Else
    doubleKiloStr = phyVal
  End If
  getDoubleFromPhyVal = getDoubleFromKiloMega(doubleKiloStr)
End Function

' dm3 -> 3
Public Function getPotenzFromEinheit(ByVal einheit As String) As Integer
    Select Case (right(einheit, 1))
    Case 2 To 9
        getPotenzFromEinheit = right(einheit, 1)
    Case Else
        getPotenzFromEinheit = 1
    End Select
End Function

' dm3 -> dm
Public Function removePotenzFromEinheit(ByVal einheit As String) As String
    Select Case (right(einheit, 1))
    Case 1 To 9
        removePotenzFromEinheit = left(einheit, Len(einheit) - 1)
    Case Else
        removePotenzFromEinheit = einheit
    End Select
End Function

' mit Verrechnung von kilo,....
Public Function getDoubleFromKiloMega(ByVal doubleKiloStr As String) As Double
  Dim zVal As Double
  Dim kiloMegaStr As String
  Dim zFac As Double
  Dim nFac As Double
  Dim zEinheit As String
  Dim nEinheit As String
   
  Dim zEinheitPotenz As Integer
  Dim nEinheitPotenz As Integer


  zVal = getFigureFromKiloMega(doubleKiloStr)
  zEinheit = getZaehlerEinheitFromKiloMega(doubleKiloStr)
  nEinheit = getNennerEinheitFromKiloMega(doubleKiloStr)
  
  zEinheitPotenz = getPotenzFromEinheit(zEinheit)
  zEinheit = removePotenzFromEinheit(zEinheit)
  nEinheitPotenz = getPotenzFromEinheit(nEinheit)
  nEinheit = removePotenzFromEinheit(nEinheit)
  
  If (Len(zEinheit) > 1) Then
    zFac = getFacFromKiloMega(left(zEinheit, 1))
  Else
    If (zEinheit = "h") Then
        zFac = 3600
    Else
        zFac = 1
    End If
  End If
  zFac = zFac ^ zEinheitPotenz
  
  If (Len(nEinheit) > 1) Then
    nFac = getFacFromKiloMega(left(nEinheit, 1))
  Else
    If (nEinheit = "h") Then
        nFac = 3600
    Else
        nFac = 1
    End If
  End If
  nFac = nFac ^ nEinheitPotenz
  
  getDoubleFromKiloMega = zVal * zFac / nFac
End Function

' ohne Verrechnung von kilo,....
Public Function getFigureFromKiloMega(ByVal doubleKiloStr As String) As Double
  Dim zVal As Double
  Dim regExRes As String
  
  If (strContains(doubleKiloStr, "=")) Then
    doubleKiloStr = getFieldFromString(doubleKiloStr, "=", 1)
    doubleKiloStr = RTrim(LTrim(doubleKiloStr))
  End If
  
  doubleKiloStr = replaceStringInStringRegEx(doubleKiloStr, "( |')", "")
  regExRes = getFieldFromString(getStringsForRegEx(doubleKiloStr, float_RegEx), ";", 0)
  If (strContains(regExRes, ".")) Or strContains(regExRes, ",") Then
        regExRes = Replace(regExRes, ".", Application.DecimalSeparator)
        regExRes = Replace(regExRes, ",", Application.DecimalSeparator)
   End If

  zVal = regExRes
  getFigureFromKiloMega = zVal
End Function

'I1 = 507mA  ->  mA
Public Function getEinheitFromKiloMega(ByVal doubleKiloStr As String) As String
  Dim kiloMegaStr As String
  Dim regExRes As String
    
  If (strContains(doubleKiloStr, "=")) Then
    doubleKiloStr = getFieldFromString(doubleKiloStr, "=", 1)
    doubleKiloStr = RTrim(LTrim(doubleKiloStr))
  End If
  
  doubleKiloStr = replaceStringInStringRegEx(doubleKiloStr, "( |')", "")
  regExRes = getFieldFromString(getStringsForRegEx(doubleKiloStr, float_RegEx), ";", 0)
  
  kiloMegaStr = Replace(doubleKiloStr, regExRes, "", , 1)
  getEinheitFromKiloMega = kiloMegaStr
End Function

' v =5km/h => km
Public Function getZaehlerEinheitFromKiloMega(ByVal doubleKiloStr As String) As String
  Dim einheit As String
  einheit = getEinheitFromKiloMega(doubleKiloStr)
  
  getZaehlerEinheitFromKiloMega = getFieldFromString(einheit, "/", 0)
End Function

' v =5km/h => h
Public Function getNennerEinheitFromKiloMega(ByVal doubleKiloStr As String) As String
  Dim einheit As String
  einheit = getEinheitFromKiloMega(doubleKiloStr)
  
  getNennerEinheitFromKiloMega = getFieldFromString(einheit, "/", 1)
End Function

'I1 = 507mA  ->  A
Public Function getBaseEinheitFromKiloMega(ByVal doubleKiloStr As String) As String
  Dim kiloMegaStr As String
  If (strContains(doubleKiloStr, "=")) Then
    doubleKiloStr = getFieldFromString(doubleKiloStr, "=", 1)
    doubleKiloStr = RTrim(LTrim(doubleKiloStr))
  End If
  
  doubleKiloStr = replaceStringInStringRegEx(doubleKiloStr, "( |')", "")
  kiloMegaStr = replaceStringInStringRegEx(doubleKiloStr, float_RegEx, "")
  If ((Len(kiloMegaStr) > 1) And (getPowerFacFromKiloMega(left(kiloMegaStr, 1))) <> 0) Then
    kiloMegaStr = right(kiloMegaStr, Len(kiloMegaStr) - 1)
  End If
  
  getBaseEinheitFromKiloMega = kiloMegaStr
End Function

'I1 = 507mA  ->  I1=
Public Function getPrestrFromPhyVal(ByVal phyVal As String) As String
  Dim retStr As String
  If (strContains(phyVal, "=")) Then
    retStr = getFieldFromString(phyVal, "=", 0)
    retStr = retStr & "= "
  Else
    retStr = ""
  End If
  getPrestrFromPhyVal = retStr
End Function

' Masse[mA] -> mA
Public Function getEinheitFromTitle(ByVal titleStr As String) As String
    Dim retStr As String
    retStr = getStringsForRegEx(titleStr, einheitInTitle_RegEx)
    If (retStr = "") Then
        getEinheitFromTitle = ""
    Else
        retStr = Mid(retStr, 2, Len(retStr) - 2)
        getEinheitFromTitle = RTrim(LTrim(retStr))
    End If
End Function

' wandelt eine Zahl in Eng k,m,...um i.e. I1 = 5mA
Public Function convertDoubleToPhyVal(ByVal inVal_1 As Double, Optional ByVal preStr As String = "", Optional ByVal einheit As String = "", Optional ByVal engOnly As Boolean = True, Optional ByVal stellen As Integer = -1, Optional ByVal noEngAtAll As Boolean = False) As String
  Dim vorzeichen As String
  If (inVal_1 <= 0) Then
    vorzeichen = "-"
  Else
    vorzeichen = ""
  End If
  inVal_1 = Abs(inVal_1)
  Dim kiloMegaStr As String
  
  If (noEngAtAll = False) Then
      If (inVal_1 < 0.000000001) Then
        inVal_1 = inVal_1 * 1000000000000#
        kiloMegaStr = "p"
      ElseIf (inVal_1 < 0.000001) Then
        inVal_1 = inVal_1 * 1000000000
        kiloMegaStr = "n"
      ElseIf (inVal_1 < 0.001) Then
        inVal_1 = inVal_1 * 1000000
        kiloMegaStr = "u"
    
      ElseIf ((inVal_1 <= 0.01) And (engOnly = False)) Then
        inVal_1 = inVal_1 * 1000
        kiloMegaStr = "m"
      ElseIf ((inVal_1 <= 0.1) And (engOnly = False)) Then
        inVal_1 = inVal_1 * 100
        kiloMegaStr = "c"
      ElseIf ((inVal_1 <= 1) And (engOnly = False)) Then
        inVal_1 = inVal_1 * 10
        kiloMegaStr = "d"
        
      ElseIf (inVal_1 <= 1) Then
        inVal_1 = inVal_1 * 1000
        kiloMegaStr = "m"
    
      ElseIf (inVal_1 >= 1000000000000#) Then
        inVal_1 = inVal_1 / 1000000000000#
        kiloMegaStr = "T"
      ElseIf (inVal_1 >= 1000000000) Then
        inVal_1 = inVal_1 / 1000000000
        kiloMegaStr = "G"
      ElseIf (inVal_1 >= 1000000) Then
        inVal_1 = inVal_1 / 1000000
        kiloMegaStr = "M"
      ElseIf (inVal_1 >= 1000) Then
        inVal_1 = inVal_1 / 1000
        kiloMegaStr = "k"
    
      ElseIf ((inVal_1 >= 100) And (engOnly = False)) Then
        inVal_1 = inVal_1 / 100
        kiloMegaStr = "h"
      Else
        inVal_1 = inVal_1
        kiloMegaStr = ""
      End If
  End If
  ' stellenzahl
  If (stellen = -1) Then
    If (inVal_1 > 99) Then
        stellen = 1
    ElseIf (inVal_1 > 9) Then
        stellen = 2
    Else
        stellen = 3
    End If
  End If
  
  inVal_1 = roundDoubleAsString(inVal_1, stellen)
  
  convertDoubleToPhyVal = preStr & vorzeichen & inVal_1 & kiloMegaStr & einheit
End Function

' t = 5h 2Min 3s  ==> 18123
Public Function getSecFromPhyVal(ByVal inStr_1 As String) As Long
  If (strContains(inStr_1, "=")) Then
    inStr_1 = RTrim(LTrim(getFieldFromString(inStr_1, "=", 1)))
  End If
  getSecFromPhyVal = getSecondsFromTime(inStr_1)
End Function


' wandelt eine Zahl in Eng k,m,...um
Public Function convertDoubleToKiloMega(ByVal inVal_1 As Double, Optional ByVal einheit As String = "", Optional ByVal engOnly As Boolean = True, Optional ByVal stellen As Integer = -1) As String
  convertDoubleToKiloMega = convertDoubleToPhyVal(inVal_1, "", einheit, engOnly, stellen)
End Function

' Vector functions
' ======================================================
' Possible 2-D Vector strings: 5kN|30°         6MN|1rad           8kN|-2kN        4kN
' Possible 3-D Vector strings: 5kN|30°|60°     6MN|1rad|0.5rad    8kN|-2kN|1kN    (x|y|z)
Public Function isVector3D(ByVal vecStr As String) As String
    isVector3D = (getCountOfFieldsInString(vecStr, "|") = 3)
End Function

Public Function vectorFirst(ByVal vecStr As String) As String
    vectorFirst = RTrim(LTrim(getFieldFromString(vecStr, "|", 0)))
End Function

Public Function vectorSecond(ByVal vecStr As String) As String
    vectorSecond = RTrim(LTrim(getFieldFromString(vecStr, "|", 1)))
End Function

Public Function vectorThird(ByVal vecStr As String) As String
    If (isVector3D(vecStr)) Then
        vectorThird = RTrim(LTrim(getFieldFromString(vecStr, "|", 2)))
    Else
        vectorThird = "0"
    End If
End Function

Public Function vectorIsKartesisch(ByVal vecStr As String) As Boolean
    If (isVector3D(vecStr)) Then
        vectorIsKartesisch = (Not (phyIsWinkelEinheit(getEinheitFromKiloMega(vectorSecond(vecStr)))) And (Not phyIsWinkelEinheit(getEinheitFromKiloMega(vectorSecond(vecStr)))))
    Else
        vectorIsKartesisch = Not phyIsWinkelEinheit(getEinheitFromKiloMega(vectorSecond(vecStr)))
    End If
End Function

Public Function vectorIsPolar(ByVal vecStr As String) As Boolean
    If (isVector3D(vecStr)) Then
        vectorIsPolar = (phyIsWinkelEinheit(getEinheitFromKiloMega(vectorSecond(vecStr))) And phyIsWinkelEinheit(getEinheitFromKiloMega(vectorSecond(vecStr))))
    Else
        vectorIsPolar = phyIsWinkelEinheit(getEinheitFromKiloMega(vectorSecond(vecStr)))
    End If
End Function

Public Function vector_Betrag(ByVal vecStr As String) As Double
    If ((vectorSecond(vecStr) = "") Or (vectorIsPolar(vecStr) = True)) Then
        vector_Betrag = Abs(getDoubleFromKiloMega(vectorFirst(vecStr)))
    Else
        If (isVector3D(vecStr)) Then
            vector_Betrag = (getDoubleFromKiloMega(vectorFirst(vecStr)) ^ 2 + getDoubleFromKiloMega(vectorSecond(vecStr)) ^ 2 + getDoubleFromKiloMega(vectorThird(vecStr)) ^ 2) ^ 0.5
        Else
            vector_Betrag = (getDoubleFromKiloMega(vectorFirst(vecStr)) ^ 2 + getDoubleFromKiloMega(vectorSecond(vecStr)) ^ 2) ^ 0.5
        End If
    End If
End Function

Public Function vector_BasisEinheit(ByVal vecStr As String) As String
    vector_BasisEinheit = getBaseEinheitFromKiloMega(vectorFirst(vecStr))
End Function

' Winkel von x-Achse aus Richtung y-Achse (Bei 3D-Vektor Winkel in der xy-Ebene)
' Azimut
Public Function vector_WinkelGrad(ByVal vecStr As String) As Double
    If (vectorIsPolar(vecStr)) Then
       If (phyIsGrad(vectorSecond(vecStr))) Then
         vector_WinkelGrad = getDoubleFromKiloMega(vectorSecond(vecStr))
       Else
         vector_WinkelGrad = phy_Rad__grad(getDoubleFromKiloMega(vectorSecond(vecStr)))
       End If
    Else
        If (vectorSecond(vecStr) = "") Then
            If (getDoubleFromKiloMega(vectorFirst(vecStr)) > 0) Then
                vector_WinkelGrad = 0
            Else
                vector_WinkelGrad = 180
            End If
        Else
            vector_WinkelGrad = phy_Rad__grad(Atn2_VBA(getDoubleFromKiloMega(vectorFirst(vecStr)), getDoubleFromKiloMega(vectorSecond(vecStr))))
        End If
    End If
End Function

' Winkel von der Projektion des Vektors in der xy-Ebene zum Vektor in z-Richtung
' Elevation
Public Function vector_WinkelElevationGrad(ByVal vecStr As String) As Double
    If ((vectorThird(vecStr) = "") Or (vectorSecond(vecStr) = "")) Then
        vector_WinkelElevationGrad = 0
    Else
        If (vectorIsPolar(vecStr)) Then
           If (phyIsGrad(vectorThird(vecStr))) Then
             vector_WinkelElevationGrad = getDoubleFromKiloMega(vectorThird(vecStr))
           Else
             vector_WinkelElevationGrad = phy_Rad__grad(getDoubleFromKiloMega(vectorThird(vecStr)))
           End If
        Else
            vector_WinkelElevationGrad = phy_Rad__grad(Atn2_VBA((getDoubleFromKiloMega(vectorFirst(vecStr)) ^ 2 + getDoubleFromKiloMega(vectorSecond(vecStr)) ^ 2) ^ 0.5, getDoubleFromKiloMega(vectorThird(vecStr))))
        End If
    End If
End Function

Public Function phyGetWinkelInRad(ByVal winkelStr As String, Optional ByVal defaultIsGrad As Boolean = False) As Double
    ' Dim value As Double
    ' Dim einheit As String
    ' value = getFigureFromKiloMega(winkelStr)
    ' einheit = getBaseEinheitFromKiloMega(winkelStr)
    If ((phyIsRad(winkelStr) = False) And (phyIsGrad(winkelStr) = False)) Then
        If (defaultIsGrad) Then
            phyGetWinkelInRad = phy_grad__Rad(getFigureFromKiloMega(winkelStr))
        Else
            phyGetWinkelInRad = getFigureFromKiloMega(winkelStr)
        End If
    Else
        If (phyIsGrad(winkelStr)) Then
             phyGetWinkelInRad = phy_grad__Rad(getFigureFromKiloMega(winkelStr))
        Else
             phyGetWinkelInRad = getFigureFromKiloMega(winkelStr)
        End If
    End If
End Function

Public Function phyGetWinkelInGrad(ByVal winkelStr As String, Optional ByVal defaultIsGrad As Boolean = False) As Double
    ' Dim value As Double
    ' Dim einheit As String
    ' value = getFigureFromKiloMega(winkelStr)
    ' einheit = getBaseEinheitFromKiloMega(winkelStr)
    Dim tmp As Boolean
    tmp = phyIsRad(winkelStr)
    tmp = phyIsRad(winkelStr)
    If ((phyIsRad(winkelStr) = False) And (phyIsGrad(winkelStr) = False)) Then
        If (defaultIsGrad) Then
            phyGetWinkelInGrad = getFigureFromKiloMega(winkelStr)
        Else
            phyGetWinkelInGrad = phy_Rad__grad(getFigureFromKiloMega(winkelStr))
        End If
    Else
        If (phyIsRad(winkelStr)) Then
             phyGetWinkelInGrad = phy_Rad__grad(getFigureFromKiloMega(winkelStr))
        Else
             phyGetWinkelInGrad = getFigureFromKiloMega(winkelStr)
        End If
    End If
End Function

Public Function vector_WinkelRad(ByVal vecStr As String) As Double
    vector_WinkelRad = phy_grad__Rad(vector_WinkelGrad(vecStr))
End Function

Public Function vector_WinkelElevationRad(ByVal vecStr As String) As Double
    vector_WinkelElevationRad = phy_grad__Rad(vector_WinkelElevationGrad(vecStr))
End Function

Public Function vector_xKomponente(ByVal vecStr As String) As Double
    If (isVector3D(vecStr)) Then
        Dim azimut As Double
        Dim elevation As Double
        azimut = vector_WinkelRad(vecStr)
        elevation = vector_WinkelElevationRad(vecStr)
        vector_xKomponente = vector_Betrag(vecStr) * Cos(elevation) * Cos(azimut)
    Else
        If (vectorIsPolar(vecStr)) Then
            vector_xKomponente = vector_Betrag(vecStr) * Cos(vector_WinkelRad(vecStr))
        Else
            vector_xKomponente = getDoubleFromKiloMega(vectorFirst(vecStr))
        End If
    End If
End Function

Public Function vector_yKomponente(ByVal vecStr As String) As Double
    If (isVector3D(vecStr)) Then
        Dim azimut As Double
        Dim elevation As Double
        azimut = vector_WinkelRad(vecStr)
        elevation = vector_WinkelElevationRad(vecStr)
        vector_yKomponente = vector_Betrag(vecStr) * Cos(elevation) * Sin(azimut)
    Else
        If (vectorIsPolar(vecStr)) Then
            vector_yKomponente = vector_Betrag(vecStr) * Sin(vector_WinkelRad(vecStr))
        Else
            If ((vecStr = "") Or (vecStr = "-0") Or (vecStr = "0")) Then
               vector_yKomponente = 0
            Else
                vector_yKomponente = getDoubleFromKiloMega(vectorSecond(vecStr))
            End If
        End If
    End If
End Function

Public Function vector_zKomponente(ByVal vecStr As String) As Double
    If (isVector3D(vecStr)) Then
        If (vectorIsPolar(vecStr)) Then
            vector_zKomponente = vector_Betrag(vecStr) * Sin(vector_WinkelElevationRad(vecStr))
        Else
            vector_zKomponente = getDoubleFromKiloMega(vectorThird(vecStr))
        End If
    Else
        vector_zKomponente = 0
    End If
End Function

Public Function vector_format(ByVal vecStr As String, ByVal format As String, Optional ByVal stellen As Integer = -1, Optional ByVal stellenWinkelRad As Integer = 3, Optional ByVal stellenWinkelGrad As Integer = 0, Optional ByVal engFormat As Boolean = False) As String
    engFormat = Not engFormat
    
    If (format = "Kartesisch") Then
        vector_format = convertDoubleToPhyVal(vector_xKomponente(vecStr), "", vector_BasisEinheit(vecStr), True, stellen, engFormat)
        If (vector_yKomponente(vecStr) <> 0) Then
            vector_format = vector_format & "|" & convertDoubleToPhyVal(vector_yKomponente(vecStr), "", vector_BasisEinheit(vecStr), True, stellen, engFormat)
            If (vector_zKomponente(vecStr) <> 0) Then
                vector_format = vector_format & "|" & convertDoubleToPhyVal(vector_zKomponente(vecStr), "", vector_BasisEinheit(vecStr), True, stellen, engFormat)
            End If
        End If
    ElseIf (format = "PolarRad") Then
        If (isVector3D(vecStr)) Then
            vector_format = convertDoubleToPhyVal(vector_Betrag(vecStr), "", vector_BasisEinheit(vecStr), True, stellen, engFormat) & "|" & _
                           roundDoubleAsString(vector_WinkelRad(vecStr), stellenWinkelRad) & "rad" & "|" & _
                           roundDoubleAsString(vector_WinkelElevationRad(vecStr), stellenWinkelRad) & "rad"
                           
        Else
            vector_format = convertDoubleToPhyVal(vector_Betrag(vecStr), "", vector_BasisEinheit(vecStr), True, stellen, engFormat) & "|" & _
                           roundDoubleAsString(vector_WinkelRad(vecStr), stellenWinkelRad) & "rad"
        End If
    ElseIf (format = "PolarGrad") Then
        If (isVector3D(vecStr)) Then
            vector_format = convertDoubleToPhyVal(vector_Betrag(vecStr), "", vector_BasisEinheit(vecStr), True, stellen, engFormat) & "|" & _
                            roundDoubleAsString(vector_WinkelGrad(vecStr), stellenWinkelGrad) & "°" & "|" & _
                            roundDoubleAsString(vector_WinkelElevationGrad(vecStr), stellenWinkelGrad) & "°"
        
        Else
            vector_format = convertDoubleToPhyVal(vector_Betrag(vecStr), "", vector_BasisEinheit(vecStr), True, stellen, engFormat) & "|" & _
                            roundDoubleAsString(vector_WinkelGrad(vecStr), stellenWinkelGrad) & "°"
        End If
    Else
        vector_format = "ERROR: Format " & format & " is unknown"
    End If
End Function

Public Function vector_addVector(ByVal vecStr1 As String, ByVal vecStr2 As String) As String
    Dim vec1Is3D As Boolean
    Dim vec2Is3D As Boolean
    vec1Is3D = isVector3D(vecStr1)
    vec2Is3D = isVector3D(vecStr2)

    If (vec1Is3D Or vec2Is3D) Then
        vector_addVector = (vector_xKomponente(vecStr1) + vector_xKomponente(vecStr2)) & vector_BasisEinheit(vecStr1) & "|" & _
                           (vector_yKomponente(vecStr1) + vector_yKomponente(vecStr2)) & vector_BasisEinheit(vecStr1) & "|" & _
                           (vector_zKomponente(vecStr1) + vector_zKomponente(vecStr2)) & vector_BasisEinheit(vecStr1)
    Else
        vector_addVector = (vector_xKomponente(vecStr1) + vector_xKomponente(vecStr2)) & vector_BasisEinheit(vecStr1) & "|" & _
                           (vector_yKomponente(vecStr1) + vector_yKomponente(vecStr2)) & vector_BasisEinheit(vecStr1)
    End If
End Function

Public Function vector_add_helpLine_1x0(ByVal vecStr1 As String, ByVal vecStr2 As String) As Double
    vector_add_helpLine_1x0 = vector_xKomponente(vecStr2)
End Function

Public Function vector_add_helpLine_1y0(ByVal vecStr1 As String, ByVal vecStr2 As String) As Double
    vector_add_helpLine_1y0 = vector_yKomponente(vecStr2)
End Function

Public Function vector_add_helpLine_1x1(ByVal vecStr1 As String, ByVal vecStr2 As String) As Double
    vector_add_helpLine_1x1 = vector_xKomponente(vecStr1) + vector_xKomponente(vecStr2)
End Function

Public Function vector_add_helpLine_1y1(ByVal vecStr1 As String, ByVal vecStr2 As String) As Double
    vector_add_helpLine_1y1 = vector_yKomponente(vecStr1) + vector_yKomponente(vecStr2)
End Function



Public Function vector_add_helpLine_2x0(ByVal vecStr1 As String, ByVal vecStr2 As String) As Double
    vector_add_helpLine_2x0 = vector_xKomponente(vecStr1)
End Function

Public Function vector_add_helpLine_2y0(ByVal vecStr1 As String, ByVal vecStr2 As String) As Double
    vector_add_helpLine_2y0 = vector_yKomponente(vecStr1)
End Function

Public Function vector_add_helpLine_2x1(ByVal vecStr1 As String, ByVal vecStr2 As String) As Double
    vector_add_helpLine_2x1 = vector_xKomponente(vecStr1) + vector_xKomponente(vecStr2)
End Function

Public Function vector_add_helpLine_2y1(ByVal vecStr1 As String, ByVal vecStr2 As String) As Double
    vector_add_helpLine_2y1 = vector_yKomponente(vecStr1) + vector_yKomponente(vecStr2)
End Function

Public Function vector_diffVector(ByVal vecStr1 As String, ByVal vecStr2 As String) As String
    Dim vec1Is3D As Boolean
    Dim vec2Is3D As Boolean
    vec1Is3D = isVector3D(vecStr1)
    vec2Is3D = isVector3D(vecStr2)

    If (vec1Is3D Or vec2Is3D) Then
        vector_diffVector = (vector_xKomponente(vecStr1) - vector_xKomponente(vecStr2)) & vector_BasisEinheit(vecStr1) & "|" & _
                            (vector_yKomponente(vecStr1) - vector_yKomponente(vecStr2)) & vector_BasisEinheit(vecStr1) & "|" & _
                            (vector_zKomponente(vecStr1) - vector_zKomponente(vecStr2)) & vector_BasisEinheit(vecStr1)
    Else
        vector_diffVector = (vector_xKomponente(vecStr1) - vector_xKomponente(vecStr2)) & vector_BasisEinheit(vecStr1) & "|" & _
                            (vector_yKomponente(vecStr1) - vector_yKomponente(vecStr2)) & vector_BasisEinheit(vecStr1)
    End If
End Function

Public Function vector_subVector(ByVal vecStr1 As String, ByVal vecStr2 As String) As String
    vector_subVector = vector_diffVector(vecStr1, vecStr2)
End Function


Public Function vector_mulVector(ByVal vecStr1 As String, ByVal vecStr2 As String) As String
    Dim vec1Is3D As Boolean
    Dim vec2Is3D As Boolean
    vec1Is3D = isVector3D(vecStr1)
    vec2Is3D = isVector3D(vecStr2)

    If (vec1Is3D Or vec2Is3D) Then
        vector_mulVector = "vector_mulVector is not 3D capable"
    Else
        vector_mulVector = vector_format( _
                            (vector_Betrag(vecStr1) * vector_Betrag(vecStr2)) & "|" & _
                            (vector_WinkelGrad(vecStr1) + vector_WinkelGrad(vecStr2)) & "°", _
                            "Kartesisch", , , , False)
    End If
End Function

Public Function vector_divVector(ByVal vecStr1 As String, ByVal vecStr2 As String) As String
    Dim vec1Is3D As Boolean
    Dim vec2Is3D As Boolean
    vec1Is3D = isVector3D(vecStr1)
    vec2Is3D = isVector3D(vecStr2)

    If (vec1Is3D Or vec2Is3D) Then
        vector_divVector = "vector_divVector is not 3D capable"
    Else
        vector_divVector = vector_format( _
                            (vector_Betrag(vecStr1) / vector_Betrag(vecStr2)) & "|" & _
                            (vector_WinkelGrad(vecStr1) - vector_WinkelGrad(vecStr2)) & "°", _
                            "Kartesisch", , , , False)
    End If
End Function

Public Function vector_scalarProduct(ByVal vecStr1 As String, ByVal vecStr2 As String) As Double
    Dim vec1Is3D As Boolean
    Dim vec2Is3D As Boolean
    vec1Is3D = isVector3D(vecStr1)
    vec2Is3D = isVector3D(vecStr2)

    If (vec1Is3D Or vec2Is3D) Then
        vector_scalarProduct = (vector_xKomponente(vecStr1) * vector_xKomponente(vecStr2)) + _
                               (vector_yKomponente(vecStr1) * vector_yKomponente(vecStr2)) + _
                               (vector_zKomponente(vecStr1) * vector_zKomponente(vecStr2))
    
    Else
        vector_scalarProduct = (vector_xKomponente(vecStr1) * vector_xKomponente(vecStr2)) + _
                               (vector_yKomponente(vecStr1) * vector_yKomponente(vecStr2))
    End If
End Function

Public Function vector_scalarProductCosPhi(ByVal vecStr1 As String, ByVal vecStr2 As String, Optional ByVal stellen As Integer = -1) As Double
        vector_scalarProductCosPhi = roundDoubleAsString((vector_scalarProduct(vecStr1, vecStr2)) / _
                                                         (vector_Betrag(vecStr1) * vector_Betrag(vecStr2)), stellen)
End Function

Public Function vector_scalarProductPhi(ByVal vecStr1 As String, ByVal vecStr2 As String, Optional ByVal format As String = "Grad", Optional ByVal stellen As Integer = -1) As Double
    Dim cosPhi As Double
    Dim phi As Double
    
    cosPhi = vector_scalarProductCosPhi(vecStr1, vecStr2)
    phi = ArcCos(cosPhi)
    
    If (format = "Grad") Then
        vector_scalarProductPhi = roundDoubleAsString(phy_Rad__grad(phi), stellen)
    Else
        vector_scalarProductPhi = roundDoubleAsString(phi, stellen)
    End If
End Function

' Kreuzprodukt, Vektorprodukt, äusseres Produkt
Public Function vector_kreuzProduct(ByVal vecStr1 As String, ByVal vecStr2 As String, Optional ByVal stellen As Integer = -1) As String
    Dim resX As Double
    Dim resY As Double
    Dim resZ As Double
    Dim resStr As String
    
    resX = (vector_yKomponente(vecStr1) * vector_zKomponente(vecStr2)) - (vector_zKomponente(vecStr1) * vector_yKomponente(vecStr2))
    resY = (vector_zKomponente(vecStr1) * vector_xKomponente(vecStr2)) - (vector_xKomponente(vecStr1) * vector_zKomponente(vecStr2))
    resZ = (vector_xKomponente(vecStr1) * vector_yKomponente(vecStr2)) - (vector_yKomponente(vecStr1) * vector_xKomponente(vecStr2))
    If (stellen > -1) Then
        resStr = roundDoubleAsString(resX, stellen) & "|" & roundDoubleAsString(resY, stellen) & "|" & roundDoubleAsString(resZ, stellen)
    Else
        resStr = resX & "|" & resY & "|" & resZ
    End If
    ' Debug.Print ("vector_kreuzProduct: " & resStr)
    
    vector_kreuzProduct = resStr
End Function

' BinHex functions
' ======================================================
' "1001" -> 9
Public Function BinToDec(ByVal binStr As String) As Integer
    Dim retVal As Integer
    retVal = 0
    Do While Len(binStr) >= 1
        retVal = retVal * 2 + left(binStr, 1)
        binStr = right(binStr, Len(binStr) - 1)
    
    Loop
    BinToDec = retVal
End Function

' "32" -> 50
Public Function HexToDec(ByVal hexStr As String) As Integer
    Dim retVal As Integer
    Do While Len(hexStr) >= 1
        singleHexStr = left(hexStr, 1)
        retVal = retVal * 16 + charToValue(singleHexStr)
        hexStr = right(hexStr, Len(hexStr) - 1)
    
    Loop
    HexToDec = retVal
End Function

' 50 -> "32"
Public Function DecToHex(ByVal decValue As Integer) As String
    Dim tmpVal As Double
    tmpVal = decValue
    DecToHex = DecTo_X(tmpVal, 16)
End Function

' "323141" -> 21A
Public Function convertHEX_to_ASCII(ByVal hexStr As String) As String
    Dim retStr As String
    Dim single2HexStr As String
    Dim singleDecVal As Integer
    
    retStr = ""
    Do While Len(hexStr) >= 2
        single2HexStr = left(hexStr, 2)
        retStr = retStr & Chr(HexToDec(single2HexStr))
        hexStr = right(hexStr, Len(hexStr) - 2)
    Loop
    
    convertHEX_to_ASCII = retStr
End Function

' "21A" --> "323141"
Public Function convertASCII_to_HEX(ByVal asciiStr As String) As String
    Dim retStr As String
    Dim singleAsciiStr As String
    
    retStr = ""
    Do While Len(asciiStr) >= 1
        singleAsciiStr = left(asciiStr, 2)
        retStr = retStr & DecToHex(Asc(singleAsciiStr))
        asciiStr = right(asciiStr, Len(asciiStr) - 1)
    Loop
    
    convertASCII_to_HEX = retStr
End Function

' "A" -> 10
Public Function charToValue(ByVal inChr1 As String) As Integer
   inChr1 = UCase(inChr1)
   If ((inChr1 >= "0") And (inChr1 <= "9")) Then
      charToValue = Asc(inChr1) - Asc("0")
   Else
      charToValue = Asc(inChr1) - Asc("A") + 10
   End If
End Function

' 10 -> "A"
Public Function valueToChar(ByVal inVal1 As Integer) As String
   If (inVal1 >= 10) Then
      valueToChar = Chr(inVal1 - 10 + Asc("A"))
   Else
      valueToChar = Chr(inVal1 + Asc("0"))
   End If
End Function

Public Function getKiloMegaFromDual(exp As Integer, doShort As Boolean) As String
  If (exp > 80) Then
     If doShort Then
         getKiloMegaFromDual = "Y"
     Else
         getKiloMegaFromDual = "Yotta"
     End If
  ElseIf (exp > 70) Then
     If doShort Then
         getKiloMegaFromDual = "Z"
     Else
         getKiloMegaFromDual = "Zetta"
     End If
  ElseIf (exp > 60) Then
     If doShort Then
         getKiloMegaFromDual = "E"
     Else
         getKiloMegaFromDual = "Exa"
     End If
  ElseIf (exp > 50) Then
     If doShort Then
         getKiloMegaFromDual = "P"
     Else
         getKiloMegaFromDual = "Peta"
     End If
  ElseIf (exp > 40) Then
     If doShort Then
         getKiloMegaFromDual = "T"
     Else
         getKiloMegaFromDual = "Tera"
     End If
  ElseIf (exp > 30) Then
     If doShort Then
         getKiloMegaFromDual = "G"
     Else
         getKiloMegaFromDual = "Giga"
     End If
  ElseIf (exp > 20) Then
     If doShort Then
         getKiloMegaFromDual = "M"
     Else
         getKiloMegaFromDual = "Mega"
     End If
  ElseIf (exp > 10) Then
     If doShort Then
         getKiloMegaFromDual = "k"
     Else
         getKiloMegaFromDual = "Kilo"
     End If
  End If
End Function


Public Function getDualFromKiloMega(kiloStr As String) As Integer
  kiloStr = LCase(kiloStr)
  If ((kiloStr = "k") Or (kiloStr = "kilo")) Then
     getDualFromKiloMega = 10
  ElseIf ((kiloStr = "m") Or (kiloStr = "mega")) Then
     getDualFromKiloMega = 20
  ElseIf ((kiloStr = "g") Or (kiloStr = "giga")) Then
     getDualFromKiloMega = 30
  ElseIf ((kiloStr = "t") Or (kiloStr = "tera")) Then
     getDualFromKiloMega = 40
  ElseIf ((kiloStr = "p") Or (kiloStr = "peta")) Then
     getDualFromKiloMega = 50
  ElseIf ((kiloStr = "e") Or (kiloStr = "exa")) Then
     getDualFromKiloMega = 60
  ElseIf ((kiloStr = "z") Or (kiloStr = "zetta")) Then
     getDualFromKiloMega = 70
  ElseIf ((kiloStr = "y") Or (kiloStr = "yotta")) Then
     getDualFromKiloMega = 80
  End If
End Function

Public Function decCountsOfValues(countOfPositions As Integer, basis As Integer, shortResult As Boolean, shortKiloMega As Boolean) As String
  Dim retStr1 As String
  retStr1 = basis ^ countOfPositions
  If (shortResult) Then
     Dim exp As Double
     exp = log_2(retStr1)
     If (Int(exp) = exp) Then
       Dim remainingExponent As Integer
       remainingExponent = exp - getDualFromKiloMega(getKiloMegaFromDual(Int(exp), shortKiloMega))
       retStr1 = 2 ^ remainingExponent & getKiloMegaFromDual(Int(exp), shortKiloMega)
     End If
  End If
  decCountsOfValues = retStr1
End Function

Public Function singleHexToBin(inChr1 As String) As String
  Dim binValues() As Variant
  binValues = Array("0", "1", "10", "11", "100", "101", "110", "111", "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111")
  singleHexToBin = binValues(charToValue(inChr1))
End Function

Public Function singleBinToHex(inStr1 As String) As String
  inStr1 = padString(inStr1, "0", 4)
  Dim binValues() As Variant
  binValues = Array("0000", "0001", "0010", "0011", "0100", "0101", "0110", "0111", "1000", "1001", "1010", "1011", "1100", "1101", "1110", "1111")
  Dim pos As Integer
  pos = 0
  Do While binValues(pos) <> inStr1
    pos = pos + 1
  Loop
  singleBinToHex = valueToChar(pos)
End Function


Public Function singleOctToBin(inChr1 As String) As String
  Dim binValues() As Variant
  binValues = Array("0", "1", "10", "11", "100", "101", "110", "111")
  singleOctToBin = binValues(charToValue(inChr1))
End Function

Public Function singleBinToOct(inStr1 As String) As String
  inStr1 = padString(inStr1, "0", 3)
  Dim binValues() As Variant
  binValues = Array("000", "001", "010", "011", "100", "101", "110", "111")
  Dim pos As Integer
  pos = 0
  Do While binValues(pos) <> inStr1
    pos = pos + 1
  Loop
  singleBinToOct = valueToChar(pos)
End Function

Public Function directHexToBin(hexString As String) As String
   hexString = UCase(hexString)
   Dim strLen As Integer
   strLen = Len(hexString)
   
   Dim retValFinal As String
   Dim sChar As String
   
   For i = 1 To strLen
      sChar = Mid(hexString, i, 1)
      retValFinal = retValFinal & padString(singleHexToBin(sChar), "0", 4)
   Next i
   directHexToBin = retValFinal
End Function

Public Function directBinToHex(binString As String) As String
   binString = removeSeparator(binString, "'")
   Dim groupSize As Integer
   groupSize = 4
   
   Dim strLenNew As Integer
   strLenNew = nextVielfaches(Len(binString), groupSize)
   binString = padString(binString, "0", strLenNew)
   
   Dim retValFinal As String
   Dim sStr As String
   
   For i = strLenNew To 1 Step -groupSize
      sStr = Mid(binString, i - groupSize + 1, groupSize)
      retValFinal = singleBinToHex(sStr) & retValFinal
   Next i
   directBinToHex = retValFinal
End Function

Public Function directOctToBin(octString As String) As String
   hexString = UCase(hexString)
   Dim strLen As Integer
   strLen = Len(octString)
   
   Dim retValFinal As String
   Dim sChar As String
   
   For i = 1 To strLen
      sChar = Mid(octString, i, 1)
      retValFinal = retValFinal & padString(singleOctToBin(sChar), "0", 3)
   Next i
   directOctToBin = retValFinal
End Function

Public Function directBinToOct(binString As String) As String
   binString = removeSeparator(binString, "'")
   Dim groupSize As Integer
   groupSize = 3
   
   Dim strLenNew As Integer
   strLenNew = nextVielfaches(Len(binString), groupSize)
   binString = padString(binString, "0", strLenNew)
   
   Dim retValFinal As String
   Dim sStr As String
   
   For i = strLenNew To 1 Step -groupSize
      sStr = Mid(binString, i - groupSize + 1, groupSize)
      retValFinal = singleBinToOct(sStr) & retValFinal
   Next i
   directBinToOct = retValFinal
End Function

Public Function X_ToDec(xString As String, basisX As Integer) As Double
   Dim result As Double
   xString = UCase(xString)
   Dim strLen As Integer
   strLen = Len(xString)
   
   For i = 1 To strLen
      sChar = Mid(xString, i, 1)
      Dim stellenwert As Double
      stellenwert = basisX ^ (strLen - i)
      result = result + charToValue(sChar) * stellenwert
   Next i
   X_ToDec = result
End Function

Public Function DecTo_X(decString As Double, basisX As Integer) As String
   Dim result As String
   Dim rest As Integer
   Dim ganzzahligerTeil As Integer
   ganzzahligerTeil = decString
   Do While ganzzahligerTeil > 0
      rest = ganzzahligerTeil Mod basisX
      result = valueToChar(rest) & result
      ganzzahligerTeil = ganzzahligerTeil \ basisX
   Loop
   DecTo_X = result
End Function


' Navigation
' ==========
Public Function isInputRequired(istr1 As String) As Boolean
   strContains = InStr(istr1, "==>")
End Function

Public Function inputRequired(istr1 As String) As String
Dim retStr As String
   If (InStr(istr1, "==>")) Then
     retStr = "Input required"
   Else
      retStr = ""
   End If
   inputRequired = retStr
End Function

' WGS84 / CH1903 Functions
' ======================================================

' Convert CH y/x to WGS latitude (Breite)
Public Function CHtoWGS_Latitude(y As Long, x As Long) As Double
    ' Converts militar to civil and  to unit = 1000km
    ' Axiliary values (% Bern)

    If (y > 2000000) Then
        y = y - 2000000
    End If
    If (x > 2000000) Then
        x = x - 2000000
    End If

    If (y > 1000000) Then
        y = y - 1000000
    End If
    If (x > 1000000) Then
        x = x - 1000000
    End If

    If (x > y) Then
       Dim tmp As Double
       tmp = x
       x = y
       y = tmp
    End If

    Dim y_aux As Double
    Dim x_aux As Double
    y_aux = (y - 600000) / 1000000
    x_aux = (x - 200000) / 1000000
    
    ' Process lat
    Dim latitude As Double
    latitude = 16.9023892 _
       + 3.238272 * x_aux _
       - 0.270978 * y_aux ^ 2 _
       - 0.002528 * x_aux ^ 2 _
       - 0.0447 * y_aux ^ 2 * x_aux _
       - 0.014 * x_aux ^ 3
    latitude = latitude * 100 / 36
    CHtoWGS_Latitude = latitude
End Function

' Convert CH y/x to WGS longitude (Länge)
Public Function CHtoWGS_Longitude(y As Long, x As Long) As Double
    ' Converts militar to civil and  to unit = 1000km
    ' Axiliary values (% Bern)

    If (y > 2000000) Then
        y = y - 2000000
    End If
    If (x > 2000000) Then
        x = x - 2000000
    End If

    If (y > 1000000) Then
        y = y - 1000000
    End If
    If (x > 1000000) Then
        x = x - 1000000
    End If

    If (x > y) Then
       Dim tmp As Double
       tmp = x
       x = y
       y = tmp
    End If

    Dim y_aux As Double
    Dim x_aux As Double
    y_aux = (y - 600000) / 1000000
    x_aux = (x - 200000) / 1000000

    ' Process long
    Dim longitude As Double
    longitude = 2.6779094 _
        + 4.728982 * y_aux _
        + 0.791484 * y_aux * x_aux _
        + 0.1306 * y_aux * x_aux ^ 2 _
        - 0.0436 * y_aux ^ 3
    longitude = longitude * 100 / 36
    CHtoWGS_Longitude = longitude
End Function

' Convert Höhe über Meer (CH Karten) to WGS high (Ellipsoidischen Höhen (GPS Messung))
Public Function CHtoWGS_High(y As Long, x As Long, h_aux As Double) As Double
    ' Converts militar to civil and  to unit = 1000km
    ' Axiliary values (% Bern)

    If (y > 2000000) Then
        y = y - 2000000
    End If
    If (x > 2000000) Then
        x = x - 2000000
    End If

    If (y > 1000000) Then
        y = y - 1000000
    End If
    If (x > 1000000) Then
        x = x - 1000000
    End If

    If (x > y) Then
       Dim tmp As Double
       tmp = x
       x = y
       y = tmp
    End If
    
    Dim y_aux As Double
    Dim x_aux As Double
    y_aux = (y - 600000) / 1000000
    x_aux = (x - 200000) / 1000000

    ' Process long
    Dim h As Double
    h = h_aux + 49.55 _
        - 12.6 * y_aux _
        - 22.64 * x_aux
    CHtoWGS_High = h
End Function


' Convert WGS lat/long (° dec) to CH x
Public Function WGStoCH_x(lat As Double, lng As Double, Optional ByVal system As String = "LV95") As Double
    Dim x As Double
    
    ' Converts degrees dec to sex
    lat = DECtoSEX(lat)
    lng = DECtoSEX(lng)

    ' Converts degrees to seconds (sex)
    lat = DEGtoSEC(lat)
    lng = DEGtoSEC(lng)

    Dim lat_aux As Double
    Dim lng_aux As Double
    
    ' Axiliary values (% Bern)
    lat_aux = (lat - 169028.66) / 10000
    lng_aux = (lng - 26782.5) / 10000

    ' Process x
    x = 600072.37 _
     + 211455.93 * lng_aux _
     - 10938.51 * lng_aux * lat_aux _
     - 0.36 * lng_aux * lat_aux ^ 2 _
     - 44.54 * lng_aux ^ 3
    If (system = "LV95") Then
        x = x + 2000000
    End If
    WGStoCH_x = x
End Function

' Convert WGS lat/long (° dec) to CH y
Public Function WGStoCH_y(lat As Double, lng As Double, Optional ByVal system As String = "LV95") As Double
    Dim y As Double
    
    ' Converts degrees dec to sex
    lat = DECtoSEX(lat)
    lng = DECtoSEX(lng)

    ' Converts degrees to seconds (sex)
    lat = DEGtoSEC(lat)
    lng = DEGtoSEC(lng)

    Dim lat_aux As Double
    Dim lng_aux As Double
  
    ' Axiliary values (% Bern)
    lat_aux = (lat - 169028.66) / 10000
    lng_aux = (lng - 26782.5) / 10000

    ' Process y
    y = 200147.07 _
     + 308807.95 * lat_aux _
     + 3745.25 * lng_aux ^ 2 _
     + 76.63 * lat_aux ^ 2 _
     - 194.56 * lng_aux ^ 2 * lat_aux _
     + 119.79 * lat_aux ^ 3
 
    If (system = "LV95") Then
        y = y + 1000000
    End If

    WGStoCH_y = y
End Function

Public Function WGS84_getGrad(wgsVal As Double) As Integer
    WGS84_getGrad = trunc(wgsVal)
End Function

Public Function WGS84_getMinutes(wgsVal As Double) As Integer
    Dim restVal As Double
    restVal = Abs(wgsVal - trunc(wgsVal))
    WGS84_getMinutes = trunc(restVal * 60)
End Function

Public Function WGS84_getSeconds(wgsVal As Double) As Double
    Dim restVal As Double
    restVal = Abs(wgsVal - trunc(wgsVal))
    restVal = restVal - (trunc(restVal * 60)) / 60
    WGS84_getSeconds = restVal * 3600
End Function


' Convert Degrees angle to seconds
' DEG : angle (dd.mmss) => 12.34576 means 12° 34' 56.7"  ==> 77698 [seconds]
Public Function DEGtoSEC(angle As Double) As Long
    Dim deg As Long
    Dim min As Long
    Dim sec As Double
    
    ' Extract DMS
    deg = trunc(angle)
    min = trunc((angle - deg) * 100)
    sec = (((angle - deg) * 100) - min) * 100
    
    ' Result in degrees sex (dd.mmss)
    DEGtoSEC = sec + min * 60 + deg * 3600
End Function

' Convert DEC angle to SEX DMS
Public Function DECtoSEX(angle As Double) As Double
    Dim deg As Long
    Dim min As Long
    Dim sec As Double

    ' Extract DMS
    deg = trunc(angle)
    min = trunc((angle - deg) * 60)
    sec = (((angle - deg) * 60) - min) * 60
    
    ' Result in degrees sex
    DECtoSEX = deg + min / 100 + sec / 10000
End Function

' Convert DMS angle to DEC
Public Function SEXtoDEC(angle As Double) As Double
    Dim deg As Long
    Dim min As Long
    Dim sec As Double

    ' Extract DMS
    deg = trunc(angle)
    min = trunc((angle - deg) * 100)
    sec = (((angle - deg) * 100) - min) * 100

    ' Result in degrees sex
    SEXtoDEC = deg + (sec / 60 + min) / 60
End Function

Public Function WGS84_getLongitudeString(deg As Integer, minutes As Integer, seconds As Double) As String
    Dim retStr As String
    Dim degStr As String
    Dim minStr As String
    
    If (deg < 0) Then
      retStr = "W "
    Else
      retStr = "E "
    End If
    deg = Abs(deg)
    degStr = deg
    minStr = minutes
    retStr = retStr & padString(degStr, "0", 3) & "° " & padString(minStr, "0", 2) & "' " & roundDoubleAsString(seconds, 2) & """"
    WGS84_getLongitudeString = retStr
End Function

Public Function WGS84_getLatitudeString(deg As Integer, minutes As Integer, seconds As Double) As String
    Dim retStr As String
    Dim degStr As String
    Dim minStr As String
    
    If (deg < 0) Then
      retStr = "S "
    Else
      retStr = "N "
    End If
    deg = Abs(deg)
    degStr = deg
    minStr = minutes
    retStr = retStr & padString(degStr, "0", 3) & "° " & padString(minStr, "0", 2) & "' " & roundDoubleAsString(seconds, 2) & """"
    WGS84_getLatitudeString = retStr
End Function

' Azimut, Koordinaten und Distanz functions
' ======================================================

' Gegeben: Winkel im Koordinatensystem(bezogen auf x-Achse(0 .. 180°,0 .. -180°) ==> Resultat von Atan2
' Gesucht: Winkel zur Nordrichtung (0 .. 360°) ==> Azimut
Public Function coord_Azimut_Winkel(winkel As Double) As Double
    Dim resWinkel As Double
    
    If (winkel <= 90) Then
        resWinkel = 90 - winkel
    Else
        resWinkel = 360 - (winkel - 90)
    End If
    coord_Azimut_Winkel = resWinkel
End Function

' Gegeben: Winkel zur Nordrichtung (0 .. 360°) ==> Azimut
' Gesucht: Winkel im Koordinatensystem(bezogen auf x-Achse(0 .. 180°,0 .. -180°) ==> Resultat von Atan2
Public Function coord_Winkel_Azimut(azimut As Double) As Double
    Dim resWinkel As Double
    If (azimut < 270) Then
        resWinkel = 90 - azimut
    Else
        resWinkel = -azimut + 450
    End If
    coord_Winkel_Azimut = resWinkel
End Function

' Gegeben: 2 Punkte (P1 und P2)
' Gesucht: Distanz zwischen P1 und P2
Public Function coord_Distanz_P1P2(x1 As Double, y1 As Double, x2 As Double, y2 As Double) As Double
    coord_Distanz_P1P2 = ((x1 - x2) ^ 2 + (y1 - y2) ^ 2) ^ 0.5
End Function

' Gegeben: 2 Punkte (P1 und P2)
' Gesucht: Azimut von P1 zu P2
Public Function coord_Azimut_P1P2(x1 As Double, y1 As Double, x2 As Double, y2 As Double) As Double
    coord_Azimut_P1P2 = coord_Azimut_Winkel(phy_Rad__grad(Atn2_VBA((x2 - x1), (y2 - y1))))
End Function

' Gegeben: 2 Punkte (P1 und P2)
' Gesucht: Winkel (zur x-Achse) von P1 zu P2
Public Function coord_Winkel_P1P2(x1 As Double, y1 As Double, x2 As Double, y2 As Double) As Double
    coord_Winkel_P1P2 = phy_Rad__grad(Atn2_VBA((x2 - x1), (y2 - y1)))
End Function

' Gegeben. 1 Punkt (P1), Distanz und Azimut
' Gesucht: P2
Public Function coord_x2_P1DistAzi(ByVal x1 As Double, ByVal y1 As Double, ByVal distanz As Double, ByVal azimut As Double) As Double
    Dim aziRad As Double
    aziRad = phy_grad__Rad(coord_modAzimut(azimut))
    
    coord_x2_P1DistAzi = x1 + Sin(aziRad) * distanz
End Function

Public Function coord_y2_P1DistAzi(ByVal x1 As Double, ByVal y1 As Double, ByVal distanz As Double, ByVal azimut As Double) As Double
    Dim aziRad As Double
    aziRad = phy_grad__Rad(coord_modAzimut(azimut))
    
    coord_y2_P1DistAzi = y1 + Cos(aziRad) * distanz
End Function

' Gegeben. 2 Punkte (P1 und P2) mit je einem Azimut (Vorwärts-Einschneiden)
' Gesucht: Schnittpunkt P3
Public Function coord_x_P1Az1P2Az2(x1 As Double, y1 As Double, azimut1 As Double, x2 As Double, y2 As Double, azimut2 As Double) As Double
    Dim a1 As Double
    Dim c1 As Double
    Dim a2 As Double
    Dim c2 As Double
    
    a1 = lin_a_Azimut(azimut1)
    c1 = lin_c_P1Az1(x1, y1, azimut1)
    a2 = lin_a_Azimut(azimut2)
    c2 = lin_c_P1Az1(x2, y2, azimut2)
    
    coord_x_P1Az1P2Az2 = (c2 - c1) / (a1 - a2)
End Function

' Gegeben. 3 Punkte (P1, P2 und P3) mit je einem Azimut (Vorwärts-Einschneiden)
' Gesucht: Schnittpunkt(gemittelt)
Public Function coord_x_P1Az1P2Az2P3Az3(x1 As Double, y1 As Double, azimut1 As Double, _
                                 x2 As Double, y2 As Double, azimut2 As Double, _
                                 x3 As Double, y3 As Double, azimut3 As Double) As Double
    
    Dim x12 As Double
    Dim x13 As Double
    Dim x23 As Double
    
    x12 = coord_x_P1Az1P2Az2(x1, y1, azimut1, x2, y2, azimut2)
    x13 = coord_x_P1Az1P2Az2(x1, y1, azimut1, x3, y3, azimut3)
    x23 = coord_x_P1Az1P2Az2(x2, y2, azimut2, x3, y3, azimut3)
    
    coord_x_P1Az1P2Az2P3Az3 = roundDoubleAsString((x12 + x13 + x23) / 3, 0)
End Function

' Gegeben. 3 Punkte (P1, P2 und P3) mit je einem Azimut (Vorwärts-Einschneiden)
' Gesucht: Schnittpunkt(gemittelt)
Public Function coord_y_P1Az1P2Az2P3Az3(x1 As Double, y1 As Double, azimut1 As Double, _
                                 x2 As Double, y2 As Double, azimut2 As Double, _
                                 x3 As Double, y3 As Double, azimut3 As Double) As Double
    
    Dim y12 As Double
    Dim y13 As Double
    Dim y23 As Double
    
    y12 = coord_y_P1Az1P2Az2(x1, y1, azimut1, x2, y2, azimut2)
    y13 = coord_y_P1Az1P2Az2(x1, y1, azimut1, x3, y3, azimut3)
    y23 = coord_y_P1Az1P2Az2(x2, y2, azimut2, x3, y3, azimut3)
    
    coord_y_P1Az1P2Az2P3Az3 = roundDoubleAsString((y12 + y13 + y23) / 3, 0)
End Function


' Gegeben. 2 Punkte (P1 und P2) mit je einem Azimut (Vorwärts-Einschneiden)
' Gesucht: Schnittpunkt P3
Public Function coord_y_P1Az1P2Az2(x1 As Double, y1 As Double, azimut1 As Double, x2 As Double, y2 As Double, azimut2 As Double) As Double
    Dim a1 As Double
    Dim c1 As Double
    Dim xx1 As Double
    
    a1 = lin_a_Azimut(azimut1)
    c1 = lin_c_P1Az1(x1, y1, azimut1)
    xx1 = coord_x_P1Az1P2Az2(x1, y1, azimut1, x2, y2, azimut2)
    
    coord_y_P1Az1P2Az2 = a1 * xx1 + c1
End Function

' If you add or subtract angles to an azimut the result can be more than 360° or -360°
' This function reduces the angle to [0 .. 360[
Public Function coord_modAzimut(ByVal azimut1 As Double) As Double
    Dim retVal As Double
    Dim fac As Integer
    
    If (Abs(azimut1) > 360) Then
        Fact = Abs(azimut1) \ 360
        If (azimut1 > 0) Then
            retVal = azimut1 - (360 * Fact)
        Else
            retVal = azimut1 + (360 * Fact)
        End If
    Else
        retVal = azimut1
    End If
    If (retVal < 0) Then
       retVal = 360 + retVal
    End If
    
    If (retVal >= 360) Then
       retVal = retVal - 360
    End If
    coord_modAzimut = retVal
End Function

Public Function coord_gegenwind(ByVal azimut1 As Double) As Double
   coord_gegenwind = coord_modAzimut(azimut1 + 180)
End Function

Public Function coord_PistenNr_azimut(ByVal pistennr As String) As Integer
    coord_PistenNr_azimut = pistennr * 10
End Function

Public Function coord_azimut_PistenNr(ByVal azimut As Integer) As String
    coord_azimut_PistenNr = padString(coord_modAzimut(azimut) \ 10, "0", 2)
End Function

Public Function coord_Gegen_PistenNr(ByVal pistennr As String) As String
    coord_Gegen_PistenNr = padString(coord_modAzimut(coord_gegenwind(coord_PistenNr_azimut(pistennr))) \ 10, "0", 2)
End Function


' Rechtwinkles Dreieck berechnen
' ======================================================
Public Function rechtwinkligesDreieick_a(ByVal valStr_1 As String, ByVal valStr_2 As String, Optional ByVal hypotenuse As String = "c") As Double
    Dim op_1 As String
    Dim val_1 As Double
    Dim op_2 As String
    Dim val_2 As Double


    op_1 = getFieldFromString(valStr_1, "=", 0)
    val_1 = getFieldFromString(valStr_1, "=", 1)
   
    op_2 = getFieldFromString(valStr_2, "=", 0)
    val_2 = getFieldFromString(valStr_2, "=", 1)
   
    If (op_1 = "a") Then
        rechtwinkligesDreieick_a = val_1
    ElseIf (op_2 = "a") Then
        rechtwinkligesDreieick_a = val_2
        
    End If
   
End Function


' Geradengleichung y=ax + c
' ======================================================

' Gegeben: 2 Punkte (P1 und P2)
' Gesucht: Steigung a
Public Function lin_a_P1P2(x1 As Double, y1 As Double, x2 As Double, y2 As Double) As Double
    lin_a_P1P2 = (y2 - y1) / (x2 - x1)
End Function

' Gegeben: Steigung a
' Gesucht: Winkel zur x-Achse (in Grad)
' Die Steigung ist nicht gerichtet, dadurch gibt
' diese Funktion nur Winkel im Bereich von 0..180° zurück
Public Function lin_Winkel_a(ByVal a As Double) As Double
    Dim resVal As Double
    resVal = phy_Rad__grad(Atn2_VBA(1, a))
    If (resVal < 0) Then
        resVal = 180 + resVal
    End If
    lin_Winkel_a = resVal
End Function

' Gegeben: Steigung a
' Gesucht: Azimut (in Grad)
' Die Steigung ist nicht gerichtet, der Azimut schon
' (d.h. die Steigung zwischen 2 Punkten ist unabhängig von der Richtung,
'  beim Azimut spielt es aber eine Rolle, ob ich von P1 nach P2 gehe oder umgekehrt)
' Diese Funktion gibt nur Azimuts im Bereich von 0..180° zurück
Public Function lin_Azimut_a(ByVal a As Double) As Double
    lin_Azimut_a = coord_Azimut_Winkel(lin_Winkel_a(a))
End Function

' Gegeben: Winkel zur x-Achse (in Grad)
' Gesucht: Steigung a
Public Function lin_a_winkel(ByVal winkel As Double) As Double
    Dim resVal As Double
    Dim x1 As Double
    Dim y1 As Double
    
    azimut = phy_grad__Rad(winkel)
    If (azimut = 0) Then
        resVal = 0
    Else
        resVal = Sin(azimut) / Cos(azimut)
    End If
    lin_a_winkel = resVal
End Function

' Gegeben: Azimut (in Grad)
' Gesucht: Steigung a
Public Function lin_a_Azimut(ByVal azimut As Double) As Double
    lin_a_Azimut = lin_a_winkel(coord_Winkel_Azimut(azimut))
End Function

' Gegeben: 2 Punkte (P1 und P2)
' Gesucht: Schnittpunkt mit y-Achse=c
Public Function lin_c_P1P2(ByVal x1 As Double, ByVal y1 As Double, ByVal x2 As Double, ByVal y2 As Double) As Double
    Dim a As Double
    a = (y2 - y1) / (x2 - x1)
    lin_c_P1P2 = y1 - x1 * a
End Function

' Gegeben: 1 Punkt und Azimut (in Grad)
' Gesucht: Schnittpunkt mit y-Achse c
Public Function lin_c_P1Az1(ByVal x1 As Double, ByVal y1 As Double, ByVal azimut As Double) As Double
    Dim resVal As Double
    Dim a As Double
    
    a = lin_a_Azimut(azimut)
    resVal = y1 - a * x1
    
    lin_c_P1Az1 = resVal
End Function

' Gegeben: 2 Punkte (P1 und P2)
' Gesucht: Winkel (zur x-Achse) von P1 zu P2 in Grad
Public Function lin_winkel_P1P2(ByVal x1 As Double, ByVal y1 As Double, ByVal x2 As Double, ByVal y2 As Double) As Double
    lin_winkel_P1P2 = coord_Winkel_P1P2(x1, y1, x2, y2)
End Function


' Gegeben: Geradengleichung (a,c) und x
' Gesucht: y =f(x)
Public Function lin_y_ac(ByVal Steigung_a As Double, ByVal Schnittpunkt_c As Double, ByVal x As Double) As Double
    lin_y_ac = Steigung_a * x + Schnittpunkt_c
End Function

' Gegeben: Geradengleichung (a,c) und y
' Gesucht: x
Public Function lin_x_ac(ByVal Steigung_a As Double, ByVal Schnittpunkt_c As Double, ByVal y As Double) As Double
    lin_x_ac = (y - Schnittpunkt_c) / Steigung_a
End Function

' Gegeben: a der Geradengleichung und ein Punkt P1
' Gesucht: c
Public Function lin_c_aP1(ByVal Steigung_a As Double, ByVal x1 As Double, ByVal y1 As Double) As Double
    lin_c_aP1 = y1 - Steigung_a * x1
End Function

' Gegeben: c der Geradengleichung und ein Punkt P1
' Gesucht: a
Public Function lin_a_cP1(ByVal Schnittpunkt_c As Double, ByVal x1 As Double, ByVal y1 As Double) As Double
    lin_a_cP1 = (y1 - Schnittpunkt_c) / x1
End Function

' Gegeben: a,c und max/min xy-Koordinaten
' Gesucht: 2 Schnittpunkt P1/P2 mit dem Koordinatenrand
Public Function lin_render_P1x(ByVal a As Double, ByVal c As Double, ByVal xMax As Double, ByVal xMin As Double, ByVal yMax As Double, ByVal yMin As Double) As Double
    Dim yAtXmax As Double
    yAtXmax = lin_y_ac(a, c, xMax)
    
    If (yAtXmax > yMax) Then
        lin_render_P1x = lin_x_ac(a, c, yMax)
    ElseIf (yAtXmax < yMin) Then
        lin_render_P1x = lin_x_ac(a, c, yMin)
    Else
        lin_render_P1x = xMax
    End If
End Function

Public Function lin_render_P2x(ByVal a As Double, ByVal c As Double, ByVal xMax As Double, ByVal xMin As Double, ByVal yMax As Double, ByVal yMin As Double) As Double
    Dim yAtXmin As Double
    yAtXmin = lin_y_ac(a, c, xMin)
    
    If (yAtXmin > yMax) Then
        lin_render_P2x = lin_x_ac(a, c, yMax)
    ElseIf (yAtXmin < yMin) Then
        lin_render_P2x = lin_x_ac(a, c, yMin)
    Else
        lin_render_P2x = xMin
    End If
End Function

Public Function lin_render_P1y(ByVal a As Double, ByVal c As Double, ByVal xMax As Double, ByVal xMin As Double, ByVal yMax As Double, ByVal yMin As Double) As Double
    lin_render_P1y = lin_y_ac(a, c, lin_render_P1x(a, c, xMax, xMin, yMax, yMin))
End Function

Public Function lin_render_P2y(ByVal a As Double, ByVal c As Double, ByVal xMax As Double, ByVal xMin As Double, ByVal yMax As Double, ByVal yMin As Double) As Double
    lin_render_P2y = lin_y_ac(a, c, lin_render_P2x(a, c, xMax, xMin, yMax, yMin))
End Function



' Swissmap functions
' ======================================================
Public Function xol_composeXML( _
        CenterX As String, _
        CenterY As String, _
        Shapes As String) As String
        
        Dim retStr As String
        retStr = "<?xml version=" & getDoubleQuote() & "1.0" & getDoubleQuote() & " encoding=" & getDoubleQuote() & "iso-8859-1" & getDoubleQuote() & "?>" & Chr(10)
        retStr = retStr & "<overlays>" & Chr(10)
        retStr = retStr & "  <overlay version=" & getDoubleQuote() & "1.0" & getDoubleQuote() & ">" & Chr(10)
        retStr = retStr & "    <center x=" & getDoubleQuote() & CenterX & getDoubleQuote() & " y=" & getDoubleQuote() & CenterY & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & "    <shapes>" & Chr(10)
        retStr = retStr & Shapes
        retStr = retStr & "    </shapes>" & Chr(10)
        retStr = retStr & "  </overlay>" & Chr(10)
        retStr = retStr & "</overlays>" & Chr(10)
        xol_composeXML = retStr
End Function

Public Function xol_addLine(Spaces As Integer, _
        name As String, _
        Comment As String, _
        LineSize As Integer, _
        LineColor As String, _
        LineStyle As String, _
        Link As String, _
        LinkType As String, _
        StartX As String, _
        StartY As String, _
        EndX As String, _
        EndY As String) As String
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
           
        retStr = tabSp & "<shape type=" & getDoubleQuote() & "polyline" & getDoubleQuote() & " name=" & getDoubleQuote() & name & getDoubleQuote()
        If (Comment <> "") Then
            retStr = retStr & " comment=" & getDoubleQuote() & Comment & getDoubleQuote()
        End If
        retStr = retStr & " lineSize=" & getDoubleQuote() & LineSize & getDoubleQuote()
        retStr = retStr & " lineColor=" & getDoubleQuote() & "#" & LineColor & getDoubleQuote()
        retStr = retStr & " lineStyle=" & getDoubleQuote() & LineStyle & getDoubleQuote() & ">" & Chr(10)
        retStr = retStr & tabSp & "  <points>" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & StartX & getDoubleQuote() & " y=" & getDoubleQuote() & StartY & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & EndX & getDoubleQuote() & " y=" & getDoubleQuote() & EndY & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "  </points>" & Chr(10)
        If (LinkType <> "") And (Link <> "") Then
            retStr = retStr & tabSp & "  <links select=" & getDoubleQuote() & Link & getDoubleQuote() & ">" & Chr(10)
            retStr = retStr & tabSp & "    <link type=" & getDoubleQuote() & LinkType & getDoubleQuote() & ">" & Link & "</link>" & Chr(10)
            retStr = retStr & tabSp & "  </links>" & Chr(10)
        End If
        retStr = retStr & tabSp & "</shape>" & Chr(10)
        
        xol_addLine = retStr
End Function

Public Function xol_addKoordinatenKreuz(Spaces As Integer, _
        name As String, _
        Comment As String, _
        LineSize As Integer, _
        LineColor As String, _
        LineStyle As String, _
        Link As String, _
        LinkType As String, _
        CenterX As String, _
        CenterY As String, _
        Length As String) As String
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
   
        Dim lPoint1a_X As Long
        Dim lPoint1a_Y As Long
        Dim lPoint1b_X As Long
        Dim lPoint1b_Y As Long
        Dim lPoint1a_Xstr As String
        Dim lPoint1a_Ystr As String
        Dim lPoint1b_Xstr As String
        Dim lPoint1b_Ystr As String

        lPoint1a_X = CenterX
        lPoint1a_Y = CenterY - Length
        lPoint1b_X = CenterX
        lPoint1b_Y = CenterY + (1 * Length)
        lPoint1a_Xstr = lPoint1a_X
        lPoint1a_Ystr = lPoint1a_Y
        lPoint1b_Xstr = lPoint1b_X
        lPoint1b_Ystr = lPoint1b_Y
        retStr = xol_addLine(Spaces, name, "KooKreuz", LineSize, LineColor, LineStyle, Link, LinkType, lPoint1a_Xstr, lPoint1a_Ystr, lPoint1b_Xstr, lPoint1b_Ystr)
                
        lPoint1a_X = CenterX - Length
        lPoint1a_Y = CenterY
        lPoint1b_X = CenterX + (1 * Length)
        lPoint1b_Y = CenterY
        lPoint1a_Xstr = lPoint1a_X
        lPoint1a_Ystr = lPoint1a_Y
        lPoint1b_Xstr = lPoint1b_X
        lPoint1b_Ystr = lPoint1b_Y
        retStr = retStr & xol_addLine(Spaces, name, "KooKreuz", LineSize, LineColor, LineStyle, Link, LinkType, lPoint1a_Xstr, lPoint1a_Ystr, lPoint1b_Xstr, lPoint1b_Ystr)
        
        xol_addKoordinatenKreuz = retStr
End Function

Public Function xol_addKreuz(Spaces As Integer, _
        name As String, _
        Comment As String, _
        LineSize As Integer, _
        LineColor As String, _
        LineStyle As String, _
        Link As String, _
        LinkType As String, _
        CenterX As String, _
        CenterY As String, _
        Length As String) As String
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
   
        Dim lPoint1a_X As Long
        Dim lPoint1a_Y As Long
        Dim lPoint1b_X As Long
        Dim lPoint1b_Y As Long
        Dim lPoint1a_Xstr As String
        Dim lPoint1a_Ystr As String
        Dim lPoint1b_Xstr As String
        Dim lPoint1b_Ystr As String
        Dim lengthInt As Double
        lengthInt = Length / (2 ^ (1 / 2))


        lPoint1a_X = CenterX - lengthInt
        lPoint1a_Y = CenterY - lengthInt
        lPoint1b_X = CenterX + lengthInt
        lPoint1b_Y = CenterY + lengthInt
        lPoint1a_Xstr = lPoint1a_X
        lPoint1a_Ystr = lPoint1a_Y
        lPoint1b_Xstr = lPoint1b_X
        lPoint1b_Ystr = lPoint1b_Y
        retStr = xol_addLine(Spaces, name, "Kreuz", LineSize, LineColor, LineStyle, Link, LinkType, lPoint1a_Xstr, lPoint1a_Ystr, lPoint1b_Xstr, lPoint1b_Ystr)
                
        lPoint1a_X = CenterX - lengthInt
        lPoint1a_Y = CenterY + lengthInt
        lPoint1b_X = CenterX + lengthInt
        lPoint1b_Y = CenterY - lengthInt
        lPoint1a_Xstr = lPoint1a_X
        lPoint1a_Ystr = lPoint1a_Y
        lPoint1b_Xstr = lPoint1b_X
        lPoint1b_Ystr = lPoint1b_Y
        retStr = retStr & xol_addLine(Spaces, name, "Kreuz", LineSize, LineColor, LineStyle, Link, LinkType, lPoint1a_Xstr, lPoint1a_Ystr, lPoint1b_Xstr, lPoint1b_Ystr)
        
        xol_addKreuz = retStr
End Function


Public Function xol_addElipse(Spaces As Integer, _
        name As String, _
        Comment As String, _
        LineSize As Integer, _
        LineColor As String, _
        LineStyle As String, _
        FillColor As String, _
        FillStyle As String, _
        Link As String, _
        LinkType As String, _
        UpperLeftX As String, _
        UpperLeftY As String, _
        LowerRightX As String, _
        LowerRightY As String) As String
        
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
        
        retStr = tabSp & "<shape type=" & getDoubleQuote() & "ellipse" & getDoubleQuote() & " name=" & getDoubleQuote() & name & getDoubleQuote()
        If (Comment <> "") Then
            retStr = retStr & " comment=" & getDoubleQuote() & Comment & getDoubleQuote()
        End If
        retStr = retStr & " lineSize=" & getDoubleQuote() & LineSize & getDoubleQuote()
        retStr = retStr & " lineColor=" & getDoubleQuote() & "#" & LineColor & getDoubleQuote()
        retStr = retStr & " fillColor=" & getDoubleQuote() & "#" & FillColor & getDoubleQuote()
        retStr = retStr & " lineStyle=" & getDoubleQuote() & LineStyle & getDoubleQuote()
        retStr = retStr & " fillStyle=" & getDoubleQuote() & FillStyle & getDoubleQuote() & ">" & Chr(10)
        retStr = retStr & tabSp & "  <points>" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & UpperLeftX & getDoubleQuote() & " y=" & getDoubleQuote() & UpperLeftY & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & LowerRightX & getDoubleQuote() & " y=" & getDoubleQuote() & LowerRightY & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "  </points>" & Chr(10)
        If (LinkType <> "") And (Link <> "") Then
            retStr = retStr & tabSp & "  <links select=" & getDoubleQuote() & Link & getDoubleQuote() & ">" & Chr(10)
            retStr = retStr & tabSp & "    <link type=" & getDoubleQuote() & LinkType & getDoubleQuote() & ">" & Link & "</link>" & Chr(10)
            retStr = retStr & tabSp & "  </links>" & Chr(10)
        End If
        retStr = retStr & tabSp & "</shape>" & Chr(10)
        xol_addElipse = retStr
End Function

Public Function xol_addKreis_CenterRadius(Spaces As Integer, _
        name As String, _
        Comment As String, _
        LineSize As Integer, _
        LineColor As String, _
        LineStyle As String, _
        FillColor As String, _
        FillStyle As String, _
        Link As String, _
        LinkType As String, _
        CenterX As String, _
        CenterY As String, _
        radius As String) As String
        
        Dim UpperLeftX As Long
        Dim UpperLeftY As Long
        Dim LowerRightX As Long
        Dim LowerRightY As Long
    
        UpperLeftX = CenterX - radius
        UpperLeftY = CenterY + (radius * 1)
        LowerRightX = CenterX + (radius * 1)
        LowerRightY = CenterY - radius
        
        Dim UpperLeftXstr As String
        Dim UpperLeftYstr As String
        Dim LowerRightXstr As String
        Dim LowerRightYstr As String
    
        UpperLeftXstr = UpperLeftX
        UpperLeftYstr = UpperLeftY
        LowerRightXstr = LowerRightX
        LowerRightYstr = LowerRightY


    xol_addKreis_CenterRadius = xol_addElipse(Spaces, _
        name, _
        Comment, _
        LineSize, _
        LineColor, _
        LineStyle, _
        FillColor, _
        FillStyle, _
        Link, _
        LinkType, _
        UpperLeftXstr, _
        UpperLeftYstr, _
        LowerRightXstr, _
        LowerRightYstr)
End Function

Public Function xol_addKreis_CenterAndPoint(Spaces As Integer, _
        name As String, _
        Comment As String, _
        LineSize As Integer, _
        LineColor As String, _
        LineStyle As String, _
        FillColor As String, _
        FillStyle As String, _
        Link As String, _
        LinkType As String, _
        CenterX As String, _
        CenterY As String, _
        PointX As String, _
        PointY As String) As String
        
        Dim UpperLeftX As Long
        Dim UpperLeftY As Long
        Dim LowerRightX As Long
        Dim LowerRightY As Long
    
        Dim radius As Long
        radius = ((CenterX - PointX) ^ 2 + (CenterY - PointY) ^ 2) ^ 0.5
    
        UpperLeftX = CenterX - radius
        UpperLeftY = CenterY + (radius * 1)
        LowerRightX = CenterX + (radius * 1)
        LowerRightY = CenterY - radius
        
        Dim UpperLeftXstr As String
        Dim UpperLeftYstr As String
        Dim LowerRightXstr As String
        Dim LowerRightYstr As String
    
        UpperLeftXstr = UpperLeftX
        UpperLeftYstr = UpperLeftY
        LowerRightXstr = LowerRightX
        LowerRightYstr = LowerRightY


    xol_addKreis_CenterAndPoint = xol_addElipse(Spaces, _
        name, _
        Comment, _
        LineSize, _
        LineColor, _
        LineStyle, _
        FillColor, _
        FillStyle, _
        Link, _
        LinkType, _
        UpperLeftXstr, _
        UpperLeftYstr, _
        LowerRightXstr, _
        LowerRightYstr)
End Function

Public Function xol_addBitmap(Spaces As Integer, _
        name As String, _
        Comment As String, _
        Rotation As Integer, _
        Transparency As String, _
        BitmapFile As String, _
        Link As String, _
        LinkType As String, _
        UpperLeftX As String, _
        UpperLeftY As String, _
        LowerRightX As String, _
        LowerRightY As String) As String
        
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
        
        retStr = tabSp & "<shape type=" & getDoubleQuote() & "bitmap" & getDoubleQuote() & " name=" & getDoubleQuote() & name & getDoubleQuote()
        If (Comment <> "") Then
            retStr = retStr & " comment=" & getDoubleQuote() & Comment & getDoubleQuote()
        End If
        retStr = retStr & " rotation=" & getDoubleQuote() & Rotation & getDoubleQuote()
        retStr = retStr & " transparentBG=" & getDoubleQuote() & Transparency & getDoubleQuote()
        retStr = retStr & " src=" & getDoubleQuote() & BitmapFile & getDoubleQuote() & ">" & Chr(10)
        retStr = retStr & tabSp & "  <points>" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & UpperLeftX & getDoubleQuote() & " y=" & getDoubleQuote() & UpperLeftY & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & LowerRightX & getDoubleQuote() & " y=" & getDoubleQuote() & LowerRightY & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "  </points>" & Chr(10)
        If (LinkType <> "") And (Link <> "") Then
            retStr = retStr & tabSp & "  <links select=" & getDoubleQuote() & Link & getDoubleQuote() & ">" & Chr(10)
            retStr = retStr & tabSp & "    <link type=" & getDoubleQuote() & LinkType & getDoubleQuote() & ">" & Link & "</link>" & Chr(10)
            retStr = retStr & tabSp & "  </links>" & Chr(10)
        End If
        retStr = retStr & tabSp & "</shape>" & Chr(10)
        xol_addBitmap = retStr
End Function

Public Function xol_addRectangle(Spaces As Integer, _
        name As String, _
        Comment As String, _
        Rotation As Integer, _
        Transparency As String, _
        LineSize As Integer, _
        LineColor As String, _
        LineStyle As String, _
        FillColor As String, _
        FillStyle As String, _
        Link As String, _
        LinkType As String, _
        UpperLeftX As String, _
        UpperLeftY As String, _
        LowerRightX As String, _
        LowerRightY As String) As String
        
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
        
        retStr = tabSp & "<shape type=" & getDoubleQuote() & "rect" & getDoubleQuote() & " name=" & getDoubleQuote() & name & getDoubleQuote()
        If (Comment <> "") Then
            retStr = retStr & " comment=" & getDoubleQuote() & Comment & getDoubleQuote()
        End If
        retStr = retStr & " rotation=" & getDoubleQuote() & Rotation & getDoubleQuote()
        retStr = retStr & " transparentBG=" & getDoubleQuote() & Transparency & getDoubleQuote()
        retStr = retStr & " lineSize=" & getDoubleQuote() & LineSize & getDoubleQuote()
        retStr = retStr & " lineColor=" & getDoubleQuote() & "#" & LineColor & getDoubleQuote()
        retStr = retStr & " fillColor=" & getDoubleQuote() & "#" & FillColor & getDoubleQuote()
        retStr = retStr & " lineStyle=" & getDoubleQuote() & LineStyle & getDoubleQuote()
        retStr = retStr & " fillStyle=" & getDoubleQuote() & FillStyle & getDoubleQuote() & ">" & Chr(10)
        retStr = retStr & tabSp & "  <points>" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & UpperLeftX & getDoubleQuote() & " y=" & getDoubleQuote() & UpperLeftY & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & LowerRightX & getDoubleQuote() & " y=" & getDoubleQuote() & LowerRightY & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "  </points>" & Chr(10)
        If (LinkType <> "") And (Link <> "") Then
            retStr = retStr & tabSp & "  <links select=" & getDoubleQuote() & Link & getDoubleQuote() & ">" & Chr(10)
            retStr = retStr & tabSp & "    <link type=" & getDoubleQuote() & LinkType & getDoubleQuote() & ">" & Link & "</link>" & Chr(10)
            retStr = retStr & tabSp & "  </links>" & Chr(10)
        End If
        retStr = retStr & tabSp & "</shape>" & Chr(10)
        xol_addRectangle = retStr
End Function

Public Function xol_addTriangle(Spaces As Integer, _
        name As String, _
        Comment As String, _
        Transparency As String, _
        LineSize As Integer, _
        LineColor As String, _
        LineStyle As String, _
        FillColor As String, _
        FillStyle As String, _
        Link As String, _
        LinkType As String, _
        Point_1_X As String, _
        Point_1_Y As String, _
        Point_2_X As String, _
        Point_2_Y As String, _
        Point_3_X As String, _
        Point_3_Y As String) As String
        
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
        
        retStr = tabSp & "<shape type=" & getDoubleQuote() & "triangle" & getDoubleQuote() & " name=" & getDoubleQuote() & name & getDoubleQuote()
        If (Comment <> "") Then
            retStr = retStr & " comment=" & getDoubleQuote() & Comment & getDoubleQuote()
        End If
        retStr = retStr & " transparentBG=" & getDoubleQuote() & Transparency & getDoubleQuote()
        retStr = retStr & " lineSize=" & getDoubleQuote() & LineSize & getDoubleQuote()
        retStr = retStr & " lineColor=" & getDoubleQuote() & "#" & LineColor & getDoubleQuote()
        retStr = retStr & " fillColor=" & getDoubleQuote() & "#" & FillColor & getDoubleQuote()
        retStr = retStr & " lineStyle=" & getDoubleQuote() & LineStyle & getDoubleQuote()
        retStr = retStr & " fillStyle=" & getDoubleQuote() & FillStyle & getDoubleQuote() & ">" & Chr(10)
        retStr = retStr & tabSp & "  <points>" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & Point_1_X & getDoubleQuote() & " y=" & getDoubleQuote() & Point_1_Y & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & Point_2_X & getDoubleQuote() & " y=" & getDoubleQuote() & Point_2_Y & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & Point_3_X & getDoubleQuote() & " y=" & getDoubleQuote() & Point_3_Y & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "  </points>" & Chr(10)
        If (LinkType <> "") And (Link <> "") Then
            retStr = retStr & tabSp & "  <links select=" & getDoubleQuote() & Link & getDoubleQuote() & ">" & Chr(10)
            retStr = retStr & tabSp & "    <link type=" & getDoubleQuote() & LinkType & getDoubleQuote() & ">" & Link & "</link>" & Chr(10)
            retStr = retStr & tabSp & "  </links>" & Chr(10)
        End If
        retStr = retStr & tabSp & "</shape>" & Chr(10)
        xol_addTriangle = retStr
End Function

Public Function xol_addText( _
        ByVal Point_X As String, _
        ByVal Point_Y As String, _
        ByVal Text_1 As String, _
        Optional ByVal Text_2 As String = "", _
        Optional ByVal Text_3 As String = "", _
        Optional ByVal Text_4 As String = "", _
        Optional ByVal Spaces As Integer = 8, _
        Optional ByVal Rotation As String = "0", _
        Optional ByVal FontSize As String = "14", _
        Optional ByVal LineColor As String = "000000", _
        Optional ByVal FillColor As String = "FFFFFF", _
        Optional ByVal FontFamily As String = "Arial", _
        Optional ByVal Bold As Boolean = False, _
        Optional ByVal Italic As Boolean = False, _
        Optional ByVal Underline As Boolean = False) As String
        
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
        
        Dim boldItalicUnderline As String
        boldItalicUnderline = ""
        If (Bold) Then
            boldItalicUnderline = boldItalicUnderline & " bold= " & getDoubleQuote() & "1" & getDoubleQuote()
        End If
        If (Italic) Then
            boldItalicUnderline = boldItalicUnderline & " italic= " & getDoubleQuote() & "1" & getDoubleQuote()
        End If
        If (Underline) Then
            boldItalicUnderline = boldItalicUnderline & " underline= " & getDoubleQuote() & "1" & getDoubleQuote()
        End If

        retStr = tabSp & "<shape type=" & getDoubleQuote() & "text" & getDoubleQuote() & " rotation=" & getDoubleQuote() & Rotation & getDoubleQuote() & " fontSize=" & getDoubleQuote() & FontSize & getDoubleQuote() & " lineColor=" & getDoubleQuote() & "#" & LineColor & getDoubleQuote() & " fillColor=" & getDoubleQuote() & "#" & FillColor & getDoubleQuote() & " fontFamily=" & getDoubleQuote() & FontFamily & getDoubleQuote() & boldItalicUnderline & ">" & Chr(10)
        retStr = retStr & tabSp & "  <points>" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & Point_X & getDoubleQuote() & " y=" & getDoubleQuote() & Point_Y & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "  </points>" & Chr(10)
        retStr = retStr & tabSp & "  <text>" & Text_1
        If (Text_2 <> "") Then
            retStr = retStr & Chr(10) & Text_2
        End If
        If (Text_3 <> "") Then
            retStr = retStr & Chr(10) & Text_3
        End If
        If (Text_4 <> "") Then
            retStr = retStr & Chr(10) & Text_4
        End If
        retStr = retStr & "</text>" & Chr(10)
        retStr = retStr & tabSp & "</shape>" & Chr(10)
        xol_addText = retStr
End Function


Public Function xol_addNavigationLine( _
        ByVal Spaces As Integer, _
        ByVal name As String, _
        ByVal Comment As String, _
        ByVal LineSize As Integer, _
        ByVal LineColor As String, _
        ByVal LineStyle As String, _
        ByVal Link As String, _
        ByVal LinkType As String, _
        ByVal StartX As String, _
        ByVal StartY As String, _
        ByVal azimut As String, _
        ByVal Length As String) As String
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
        
        Dim P2x As Double
        Dim P2xStr As String
        P2x = coord_x2_P1DistAzi(StartX, StartY, Length, azimut)
        P2xStr = roundDoubleAsString(P2x, 0)
        
        Dim P2y As Double
        Dim P2yStr As String
        P2y = coord_y2_P1DistAzi(StartX, StartY, Length, azimut)
        P2yStr = roundDoubleAsString(P2y, 0)

        retStr = xol_addKreuz( _
            Spaces, _
            name, _
            Comment, _
            LineSize, _
            LineColor, _
            LineStyle, _
            Link, _
            LinkType, _
            StartX, _
            StartY, _
            50)
        
        retStr = retStr & xol_addLine( _
                            Spaces, _
                            name, _
                            Comment, _
                            LineSize, _
                            LineColor, _
                            LineStyle, _
                            Link, _
                            LinkType, _
                            StartX, _
                            StartY, _
                            P2xStr, _
                            P2yStr)
        
        xol_addNavigationLine = retStr
End Function

Public Function xol_addNavigationTriangle( _
        ByVal Spaces As Integer, _
        ByVal name As String, _
        ByVal Comment As String, _
        ByVal LineSize As Integer, _
        ByVal LineColor As String, _
        ByVal LineStyle As String, _
        ByVal Link As String, _
        ByVal LinkType As String, _
        ByVal StartX_1 As String, _
        ByVal StartY_1 As String, _
        ByVal Azimut_1 As String, _
        ByVal StartX_2 As String, _
        ByVal StartY_2 As String, _
        ByVal Azimut_2 As String, _
        ByVal StartX_3 As String, _
        ByVal StartY_3 As String, _
        ByVal Azimut_3 As String) As String
        
        Const ueb As Integer = 500
        
        Dim retStr As String
        Dim dStartX_1 As Double
        Dim dStartY_1 As Double
        Dim dAzimut_1 As Double
        Dim dStartX_2 As Double
        Dim dStartY_2 As Double
        Dim dAzimut_2 As Double
        Dim dStartX_3 As Double
        Dim dStartY_3 As Double
        Dim dAzimut_3 As Double

        Dim sp_1_2_x As Double
        Dim sp_1_2_y As Double
        Dim sp_1_3_x As Double
        Dim sp_1_3_y As Double
        Dim sp_2_3_x As Double
        Dim sp_2_3_y As Double
        
        Dim tempLen1 As Double
        Dim tempLen2 As Double
        
        Dim Laenge_1 As Double
        Dim Laenge_2 As Double
        Dim Laenge_3 As Double
        
        dStartX_1 = StartX_1
        dStartY_1 = StartY_1
        dAzimut_1 = Azimut_1
        dStartX_2 = StartX_2
        dStartY_2 = StartY_2
        dAzimut_2 = Azimut_2
        dStartX_3 = StartX_3
        dStartY_3 = StartY_3
        dAzimut_3 = Azimut_3

        ' calculate Schnittpunkte to colculate length of lines
        sp_1_2_x = coord_x_P1Az1P2Az2(dStartX_1, dStartY_1, dAzimut_1, dStartX_2, dStartY_2, dAzimut_2)
        sp_1_2_y = coord_y_P1Az1P2Az2(dStartX_1, dStartY_1, dAzimut_1, dStartX_2, dStartY_2, dAzimut_2)
        
        sp_1_3_x = coord_x_P1Az1P2Az2(dStartX_1, dStartY_1, dAzimut_1, dStartX_3, dStartY_3, dAzimut_3)
        sp_1_3_y = coord_y_P1Az1P2Az2(dStartX_1, dStartY_1, dAzimut_1, dStartX_3, dStartY_3, dAzimut_3)

        sp_2_3_x = coord_x_P1Az1P2Az2(dStartX_2, dStartY_2, dAzimut_2, dStartX_3, dStartY_3, dAzimut_3)
        sp_2_3_y = coord_y_P1Az1P2Az2(dStartX_2, dStartY_2, dAzimut_2, dStartX_3, dStartY_3, dAzimut_3)
        
        tempLen1 = coord_Distanz_P1P2(dStartX_1, dStartY_1, sp_1_2_x, sp_1_2_y)
        tempLen2 = coord_Distanz_P1P2(dStartX_1, dStartY_1, sp_1_3_x, sp_1_3_y)
        If (tempLen1 > tempLen2) Then
            Laenge_1 = tempLen1 + ueb
        Else
            Laenge_1 = tempLen2 + ueb
        End If
        
        tempLen1 = coord_Distanz_P1P2(dStartX_2, dStartY_2, sp_1_2_x, sp_1_2_y)
        tempLen2 = coord_Distanz_P1P2(dStartX_2, dStartY_2, sp_2_3_x, sp_2_3_y)
        If (tempLen1 > tempLen2) Then
            Laenge_2 = tempLen1 + ueb
        Else
            Laenge_2 = tempLen2 + ueb
        End If
        
        tempLen1 = coord_Distanz_P1P2(dStartX_3, dStartY_3, sp_1_3_x, sp_1_3_y)
        tempLen2 = coord_Distanz_P1P2(dStartX_3, dStartY_3, sp_2_3_x, sp_2_3_y)
        If (tempLen1 > tempLen2) Then
            Laenge_3 = tempLen1 + ueb
        Else
            Laenge_3 = tempLen2 + ueb
        End If
        
        
        'Draw lines
        retStr = xol_addNavigationLine( _
                        Spaces, _
                        name, _
                        Comment, _
                        LineSize, _
                        LineColor, _
                        LineStyle, _
                        Link, _
                        LinkType, _
                        StartX_1, _
                        StartY_1, _
                        Azimut_1, _
                        Laenge_1)
        retStr = retStr & xol_addText(StartX_1, StartY_1, "(" & StartX_1 & "/" & StartY_1 & ")", "Azimut: " & roundDoubleAsString(Azimut_1, 0) & "° / " & roundDoubleAsString(phy_grad__artpromil(Azimut_1), 0) & "%o")
                
                
        retStr = retStr & xol_addNavigationLine( _
                        Spaces, _
                        name, _
                        Comment, _
                        LineSize, _
                        LineColor, _
                        LineStyle, _
                        Link, _
                        LinkType, _
                        StartX_2, _
                        StartY_2, _
                        Azimut_2, _
                        Laenge_2)
        retStr = retStr & xol_addText(StartX_2, StartY_2, "(" & StartX_2 & "/" & StartY_2 & ")", "Azimut: " & roundDoubleAsString(Azimut_2, 0) & "° / " & roundDoubleAsString(phy_grad__artpromil(Azimut_2), 0) & "%o")
        
        retStr = retStr & xol_addNavigationLine( _
                        Spaces, _
                        name, _
                        Comment, _
                        LineSize, _
                        LineColor, _
                        LineStyle, _
                        Link, _
                        LinkType, _
                        StartX_3, _
                        StartY_3, _
                        Azimut_3, _
                        Laenge_3)
        retStr = retStr & xol_addText(StartX_3, StartY_3, "(" & StartX_3 & "/" & StartY_3 & ")", "Azimut: " & roundDoubleAsString(Azimut_3, 0) & "° / " & roundDoubleAsString(phy_grad__artpromil(Azimut_3), 0) & "%o")
        
        ' calculate Schnittpunkt
        Dim xSchnittpunktMittel As Double
        Dim xSchnittpunktMittelStr As String
        xSchnittpunktMittel = coord_x_P1Az1P2Az2P3Az3( _
                                 dStartX_1, dStartY_1, dAzimut_1, _
                                 dStartX_2, dStartY_2, dAzimut_2, _
                                 dStartX_3, dStartY_3, dAzimut_3)
        xSchnittpunktMittelStr = roundDoubleAsString(xSchnittpunktMittel, 0)
        
        Dim ySchnittpunktMittel As Double
        Dim ySchnittpunktMittelStr As String
        ySchnittpunktMittel = coord_y_P1Az1P2Az2P3Az3( _
                                 dStartX_1, dStartY_1, dAzimut_1, _
                                 dStartX_2, dStartY_2, dAzimut_2, _
                                 dStartX_3, dStartY_3, dAzimut_3)
        ySchnittpunktMittelStr = roundDoubleAsString(ySchnittpunktMittel, 0)
        
        retStr = retStr & xol_addKreuz( _
            Spaces, _
            "Berechneter Ort", _
            "Gemittelt", _
            LineSize, _
            "FF0000", _
            LineStyle, _
            Link, _
            LinkType, _
            xSchnittpunktMittelStr, _
            ySchnittpunktMittelStr, _
            50)
        retStr = retStr & xol_addText(xSchnittpunktMittelStr, ySchnittpunktMittelStr, "(" & xSchnittpunktMittelStr & "/" & ySchnittpunktMittelStr & ")")
            
        xol_addNavigationTriangle = retStr
End Function

Public Function xol_addABC_Polygon(Spaces As Integer, _
        name As String, _
        Comment As String, _
        Transparency As String, _
        LineSize As Integer, _
        LineColor As String, _
        LineStyle As String, _
        FillColor As String, _
        FillStyle As String, _
        Link As String, _
        LinkType As String, _
        Point_2_X As String, _
        Point_2_Y As String, _
        Point_3_X As String, _
        Point_3_Y As String, _
        Point_4_X As String, _
        Point_4_Y As String, _
        Point_5_X As String, _
        Point_5_Y As String) As String
        
        Dim retStr As String
        Dim tabSp As String
        tabSp = left("                                                                ", Spaces)
        
        retStr = tabSp & "<shape type=" & getDoubleQuote() & "polygon" & getDoubleQuote() & " name=" & getDoubleQuote() & name & getDoubleQuote()
        If (Comment <> "") Then
            retStr = retStr & " comment=" & getDoubleQuote() & Comment & getDoubleQuote()
        End If
        retStr = retStr & " transparentBG=" & getDoubleQuote() & Transparency & getDoubleQuote()
        retStr = retStr & " lineSize=" & getDoubleQuote() & LineSize & getDoubleQuote()
        retStr = retStr & " lineColor=" & getDoubleQuote() & "#" & LineColor & getDoubleQuote()
        retStr = retStr & " fillColor=" & getDoubleQuote() & "#" & FillColor & getDoubleQuote()
        retStr = retStr & " lineStyle=" & getDoubleQuote() & LineStyle & getDoubleQuote()
        retStr = retStr & " fillStyle=" & getDoubleQuote() & FillStyle & getDoubleQuote() & ">" & Chr(10)
        retStr = retStr & tabSp & "  <points>" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & Point_2_X & getDoubleQuote() & " y=" & getDoubleQuote() & Point_2_Y & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & Point_3_X & getDoubleQuote() & " y=" & getDoubleQuote() & Point_3_Y & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & Point_4_X & getDoubleQuote() & " y=" & getDoubleQuote() & Point_4_Y & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "    <point x=" & getDoubleQuote() & Point_5_X & getDoubleQuote() & " y=" & getDoubleQuote() & Point_5_Y & getDoubleQuote() & " />" & Chr(10)
        retStr = retStr & tabSp & "  </points>" & Chr(10)
        If (LinkType <> "") And (Link <> "") Then
            retStr = retStr & tabSp & "  <links select=" & getDoubleQuote() & Link & getDoubleQuote() & ">" & Chr(10)
            retStr = retStr & tabSp & "    <link type=" & getDoubleQuote() & LinkType & getDoubleQuote() & ">" & Link & "</link>" & Chr(10)
            retStr = retStr & tabSp & "  </links>" & Chr(10)
        End If
        retStr = retStr & tabSp & "</shape>" & Chr(10)
        xol_addABC_Polygon = retStr
End Function

Public Function xol_addABC_TrompeteNativ( _
        ByVal Spaces As Integer, _
        ByVal name As String, _
        ByVal Comment As String, _
        ByVal Transparency As String, _
        ByVal LineSize As Integer, _
        ByVal LineColor As String, _
        ByVal LineStyle As String, _
        ByVal FillColor As String, _
        ByVal FillStyle As String, _
        ByVal Link As String, _
        ByVal LinkType As String, _
        ByVal Point_1a_X As String, _
        ByVal Point_1a_Y As String, _
        ByVal Point_2_X As String, _
        ByVal Point_2_Y As String, _
        ByVal Point_3_X As String, _
        ByVal Point_3_Y As String, _
        ByVal Point_4_X As String, _
        ByVal Point_4_Y As String, _
        ByVal Point_5_X As String, _
        ByVal Point_5_Y As String, _
        Optional ByVal LabelPoints As String = "YES", _
        Optional ByVal FillColorFreisetzZone As String = "", _
        Optional ByVal FillStyleFreisetzZone As String = "", Optional ByVal addKreuz As Boolean = True) As String
        
        
        Dim retStr As String
        If (FillColorFreisetzZone = "") Then
            FillColorFreisetzZone = FillColor
        End If
        If (FillStyleFreisetzZone = "") Then
            FillStyleFreisetzZone = FillStyle
        End If
        
        retStr = xol_addABC_Polygon(Spaces, "Gefahrenzone", Comment, Transparency, LineSize, LineColor, LineStyle, FillColor, FillStyle, Link, LinkType, Point_2_X, Point_2_Y, Point_3_X, Point_3_Y, Point_4_X, Point_4_Y, Point_5_X, Point_5_Y)
        retStr = retStr & xol_addKreis_CenterAndPoint(Spaces, "Freisetzungszone", Comment, LineSize, LineColor, LineStyle, FillColorFreisetzZone, FillStyleFreisetzZone, Link, LinkType, Point_1a_X, Point_1a_Y, Point_2_X, Point_2_Y)
        ' retStr = retStr & xol_addKoordinatenKreuz(Spaces, Name, Comment, LineSize, LineColor, LineStyle, Link, LinkType, Point_1a_X, Point_1a_Y, 100)
        If (addKreuz = True) Then
            retStr = retStr & xol_addKreuz(Spaces, "Stao Ereignis", Comment, LineSize, LineColor, LineStyle, Link, LinkType, Point_1a_X, Point_1a_Y, 100)
        End If
        
        If (LabelPoints = "YES") Then
            retStr = retStr & xol_addText(Point_1a_X, Point_1a_Y, "(P1a: " & Point_1a_X & "/" & Point_1a_Y & ")", "", "", "", 8, "0", "14", "000000", "FFFFFF", "Arial", True, False, False)
            retStr = retStr & xol_addText(Point_2_X, Point_2_Y, "(P2: " & Point_2_X & "/" & Point_2_Y & ")")
            retStr = retStr & xol_addText(Point_3_X, Point_3_Y, "(P3: " & Point_3_X & "/" & Point_3_Y & ")")
            retStr = retStr & xol_addText(Point_4_X, Point_4_Y, "(P4: " & Point_4_X & "/" & Point_4_Y & ")")
            retStr = retStr & xol_addText(Point_5_X, Point_5_Y, "(P5: " & Point_5_X & "/" & Point_5_Y & ")")
        End If
        
        xol_addABC_TrompeteNativ = retStr
End Function



Public Function xol_addABC_Trompete( _
        ByVal Point_1a_X As String, _
        ByVal Point_1a_Y As String, _
        ByVal Windrichtung As String, _
        Optional ByVal rk As String = "2000", _
        Optional ByVal Rg As String = "10000", _
        Optional ByVal Spaces As Integer = 8, _
        Optional ByVal name As String, _
        Optional ByVal Comment As String, _
        Optional ByVal Transparency As String = "1", _
        Optional ByVal LineSize As Integer = 3, _
        Optional ByVal LineColor As String = "000000", _
        Optional ByVal LineStyle As String = "solid", _
        Optional ByVal FillColor As String = "FFFF00", _
        Optional ByVal FillStyle As String = "solid", _
        Optional ByVal Link As String, _
        Optional ByVal LinkType As String, _
        Optional ByVal Point_1b_X As String = "", _
        Optional ByVal Point_1b_Y As String = "", _
        Optional ByVal LabelPoints As String = "YES", _
        Optional ByVal FillColorFreisetzZone As String = "", _
        Optional ByVal FillStyleFreisetzZone As String = "") As String
        
        Dim Point_2_X As String
        Dim Point_2_Y As String
        Dim Point_3_X As String
        Dim Point_3_Y As String
        Dim Point_4_X As String
        Dim Point_4_Y As String
        Dim Point_5_X As String
        Dim Point_5_Y As String
        
        Dim Point_2a_X As String
        Dim Point_2a_Y As String
        Dim Point_3a_X As String
        Dim Point_3a_Y As String
        Dim Point_4a_X As String
        Dim Point_4a_Y As String
        Dim Point_5a_X As String
        Dim Point_5a_Y As String

        
        If (FillColorFreisetzZone = "") Then
            FillColorFreisetzZone = FillColor
        End If
        If (FillStyleFreisetzZone = "") Then
            FillStyleFreisetzZone = FillStyle
        End If
        
        Dim retStr As String

        Point_2_X = abc_trompete_get_P2_X(Point_1a_X, Point_1a_Y, Windrichtung, rk, Rg)
        Point_2_Y = abc_trompete_get_P2_Y(Point_1a_X, Point_1a_Y, Windrichtung, rk, Rg)
        Point_3_X = abc_trompete_get_P3_X(Point_1a_X, Point_1a_Y, Windrichtung, rk, Rg)
        Point_3_Y = abc_trompete_get_P3_Y(Point_1a_X, Point_1a_Y, Windrichtung, rk, Rg)
        Point_4_X = abc_trompete_get_P4_X(Point_1a_X, Point_1a_Y, Windrichtung, rk, Rg)
        Point_4_Y = abc_trompete_get_P4_Y(Point_1a_X, Point_1a_Y, Windrichtung, rk, Rg)
        Point_5_X = abc_trompete_get_P5_X(Point_1a_X, Point_1a_Y, Windrichtung, rk, Rg)
        Point_5_Y = abc_trompete_get_P5_Y(Point_1a_X, Point_1a_Y, Windrichtung, rk, Rg)
        
        Point_2a_X = Point_2_X
        Point_2a_Y = Point_2_Y
        Point_3a_X = Point_3_X
        Point_3a_Y = Point_3_Y
        Point_4a_X = Point_4_X
        Point_4a_Y = Point_4_Y
        Point_5a_X = Point_5_X
        Point_5a_Y = Point_5_Y

        Dim doLabelNativ As String
        doLabelNativ = LabelPoints
        ' False if Absprühvorgang => Label erst am Schluss zeichnen
        If (Point_1b_X <> "") Then
            doLabelNativ = ""
        End If
        
        retStr = xol_addABC_TrompeteNativ(Spaces, _
            name, _
            Comment, _
            Transparency, _
            LineSize, _
            LineColor, _
            LineStyle, _
            FillColor, _
            FillStyle, _
            Link, _
            LinkType, _
            Point_1a_X, _
            Point_1a_Y, _
            Point_2_X, _
            Point_2_Y, _
            Point_3_X, _
            Point_3_Y, _
            Point_4_X, _
            Point_4_Y, _
            Point_5_X, _
            Point_5_Y, _
            doLabelNativ, _
            FillColorFreisetzZone, _
            FillStyleFreisetzZone, (Point_1b_X = ""))
            
        If (Point_1b_X <> "") Then
            Point_2_X = abc_trompete_get_P2_X(Point_1b_X, Point_1b_Y, Windrichtung, rk, Rg)
            Point_2_Y = abc_trompete_get_P2_Y(Point_1b_X, Point_1b_Y, Windrichtung, rk, Rg)
            Point_3_X = abc_trompete_get_P3_X(Point_1b_X, Point_1b_Y, Windrichtung, rk, Rg)
            Point_3_Y = abc_trompete_get_P3_Y(Point_1b_X, Point_1b_Y, Windrichtung, rk, Rg)
            Point_4_X = abc_trompete_get_P4_X(Point_1b_X, Point_1b_Y, Windrichtung, rk, Rg)
            Point_4_Y = abc_trompete_get_P4_Y(Point_1b_X, Point_1b_Y, Windrichtung, rk, Rg)
            Point_5_X = abc_trompete_get_P5_X(Point_1b_X, Point_1b_Y, Windrichtung, rk, Rg)
            Point_5_Y = abc_trompete_get_P5_Y(Point_1b_X, Point_1b_Y, Windrichtung, rk, Rg)
    


            retStr = retStr & xol_addABC_TrompeteNativ(Spaces, _
                name, _
                Comment, _
                Transparency, _
                LineSize, _
                LineColor, _
                LineStyle, _
                FillColor, _
                FillStyle, _
                Link, _
                LinkType, _
                Point_1b_X, _
                Point_1b_Y, _
                Point_2_X, _
                Point_2_Y, _
                Point_3_X, _
                Point_3_Y, _
                Point_4_X, _
                Point_4_Y, _
                Point_5_X, _
                Point_5_Y, _
                doLabelNativ, _
                FillColorFreisetzZone, _
                FillStyleFreisetzZone, False)
                    
            retStr = retStr & drawTromp_Absprueheinsatz(Point_2a_X, Point_2a_Y, Point_3a_X, Point_3a_Y, Point_4a_X, Point_4a_Y, Point_5a_X, Point_5a_Y, Point_2_X, Point_2_Y, Point_3_X, Point_3_Y, Point_4_X, Point_4_Y, Point_5_X, Point_5_Y, Spaces, "Gefahrenzone", Comment, Transparency, LineSize, LineColor, LineStyle, FillColor, FillStyle)
            retStr = retStr & drawZone_Absprueheinsatz(Point_1a_X, Point_1a_Y, Point_1b_X, Point_1b_Y, rk, Spaces, "Freisetzungszone", Comment, Transparency, LineSize, LineColor, LineStyle, FillColorFreisetzZone, FillStyleFreisetzZone)
            
            retStr = retStr & xol_addLine(Spaces, name, "Flugline", 2 * LineSize, "FF0000", LineStyle, Link, LinkType, Point_1a_X, Point_1a_Y, Point_1b_X, Point_1b_Y)
            retStr = retStr & xol_addKreuz(Spaces, "P1a-Kreuz", Comment, LineSize, LineColor, LineStyle, Link, LinkType, Point_1a_X, Point_1a_Y, 100)
            retStr = retStr & xol_addKreuz(Spaces, "P1b-Kreuz", Comment, LineSize, LineColor, LineStyle, Link, LinkType, Point_1b_X, Point_1b_Y, 100)

            If (LabelPoints = "YES") Then
                retStr = retStr & xol_addText(Point_1b_X, Point_1b_Y, "(P1b: " & Point_1b_X & "/" & Point_1b_Y & ")", "", "", "", 8, "0", "14", "000000", "FFFFFF", "Arial", True, False, False)
                retStr = retStr & xol_addText(Point_2_X, Point_2_Y, "(P2: " & Point_2_X & "/" & Point_2_Y & ")")
                retStr = retStr & xol_addText(Point_3_X, Point_3_Y, "(P3: " & Point_3_X & "/" & Point_3_Y & ")")
                retStr = retStr & xol_addText(Point_4_X, Point_4_Y, "(P4: " & Point_4_X & "/" & Point_4_Y & ")")
                retStr = retStr & xol_addText(Point_5_X, Point_5_Y, "(P5: " & Point_5_X & "/" & Point_5_Y & ")")
                
                retStr = retStr & xol_addText(Point_1a_X, Point_1a_Y, "(P1a: " & Point_1a_X & "/" & Point_1a_Y & ")", "", "", "", 8, "0", "14", "000000", "FFFFFF", "Arial", True, False, False)
                retStr = retStr & xol_addText(Point_2a_X, Point_2a_Y, "(P2: " & Point_2a_X & "/" & Point_2a_Y & ")")
                retStr = retStr & xol_addText(Point_3a_X, Point_3a_Y, "(P3: " & Point_3a_X & "/" & Point_3a_Y & ")")
                retStr = retStr & xol_addText(Point_4a_X, Point_4a_Y, "(P4: " & Point_4a_X & "/" & Point_4a_Y & ")")
                retStr = retStr & xol_addText(Point_5a_X, Point_5a_Y, "(P5: " & Point_5a_X & "/" & Point_5a_Y & ")")

            End If
        End If
        
        retStr = retStr & xol_addText(Point_1a_X, Point_1a_Y, " Wind: " & Windrichtung & "°", "", "", "", 8, "0", "18", "000000", "FFFFFF", "Arial", True, False, True)
            
        xol_addABC_Trompete = retStr
End Function

Public Function drawTromp_Absprueheinsatz( _
        ByVal Point_2a_X As String, ByVal Point_2a_Y As String, _
        ByVal Point_3a_X As String, ByVal Point_3a_Y As String, _
        ByVal Point_4a_X As String, ByVal Point_4a_Y As String, _
        ByVal Point_5a_X As String, ByVal Point_5a_Y As String, _
        ByVal Point_2b_X As String, ByVal Point_2b_Y As String, _
        ByVal Point_3b_X As String, ByVal Point_3b_Y As String, _
        ByVal Point_4b_X As String, ByVal Point_4b_Y As String, _
        ByVal Point_5b_X As String, ByVal Point_5b_Y As String, _
        Optional Spaces As Integer, _
        Optional ByVal name As String, _
        Optional ByVal Comment As String, _
        Optional ByVal Transparency As String = "1", _
        Optional ByVal LineSize As Integer = 3, _
        Optional ByVal LineColor As String = "000000", _
        Optional ByVal LineStyle As String = "solid", _
        Optional ByVal FillColor As String = "FFFF00", _
        Optional ByVal FillStyle As String = "solid") As String
        
        Dim retStr As String
        retStr = ""
                
        retStr = xol_addABC_Polygon(Spaces, name, Comment, Transparency, LineSize, LineColor, LineStyle, FillColor, FillStyle, "", "", _
                         Point_3a_X, Point_3a_Y, Point_3b_X, Point_3b_Y, _
                         Point_4b_X, Point_4b_Y, Point_4a_X, Point_4a_Y)
                         
        retStr = retStr & xol_addABC_Polygon(Spaces, name, Comment, Transparency, LineSize, LineColor, LineStyle, FillColor, FillStyle, "", "", _
                         Point_5a_X, Point_5a_Y, Point_4a_X, Point_4a_Y, _
                         Point_3b_X, Point_3b_Y, Point_2b_X, Point_2b_Y)

        retStr = retStr & xol_addABC_Polygon(Spaces, name, Comment, Transparency, LineSize, LineColor, LineStyle, FillColor, FillStyle, "", "", _
                         Point_5b_X, Point_5b_Y, Point_4b_X, Point_4b_Y, _
                         Point_3a_X, Point_3a_Y, Point_2a_X, Point_2a_Y)
                             
        retStr = retStr & xol_addLine(Spaces, name, Comment, LineSize, LineColor, LineStyle, "", "", Point_3a_X, Point_3a_Y, Point_3b_X, Point_3b_Y)
        retStr = retStr & xol_addLine(Spaces, name, Comment, LineSize, LineColor, LineStyle, "", "", Point_4a_X, Point_4a_Y, Point_4b_X, Point_4b_Y)
        drawTromp_Absprueheinsatz = retStr
End Function


Public Function drawZone_Absprueheinsatz( _
        ByVal Point_1a_X As String, _
        ByVal Point_1a_Y As String, _
        ByVal Point_1b_X As String, _
        ByVal Point_1b_Y As String, _
        radius As String, _
        Optional Spaces As Integer, _
        Optional ByVal name As String, _
        Optional ByVal Comment As String, _
        Optional ByVal Transparency As String = "1", _
        Optional ByVal LineSize As Integer = 3, _
        Optional ByVal LineColor As String = "000000", _
        Optional ByVal LineStyle As String = "solid", _
        Optional ByVal FillColor As String = "FFFF00", _
        Optional ByVal FillStyle As String = "solid") As String
        
        Dim retStr As String
        retStr = ""

        Dim p1a_1_X As Double
        Dim p1a_1_Y As Double
        Dim p1a_2_X As Double
        Dim p1a_2_Y As Double
        
        Dim p1b_1_X As Double
        Dim p1b_1_Y As Double
        Dim p1b_2_X As Double
        Dim p1b_2_Y As Double
            
        Dim flugazimut As Double
        flugazimut = coord_Azimut_P1P2(Point_1a_X * 1, Point_1a_Y * 1, Point_1b_X * 1, Point_1b_Y * 1)
        
        p1a_1_X = coord_x2_P1DistAzi(Point_1a_X, Point_1a_Y, radius, flugazimut + 90)
        p1a_1_Y = coord_y2_P1DistAzi(Point_1a_X, Point_1a_Y, radius, flugazimut + 90)
        p1a_2_X = coord_x2_P1DistAzi(Point_1a_X, Point_1a_Y, radius, flugazimut - 90)
        p1a_2_Y = coord_y2_P1DistAzi(Point_1a_X, Point_1a_Y, radius, flugazimut - 90)

        p1b_1_X = coord_x2_P1DistAzi(Point_1b_X, Point_1b_Y, radius, flugazimut + 90)
        p1b_1_Y = coord_y2_P1DistAzi(Point_1b_X, Point_1b_Y, radius, flugazimut + 90)
        p1b_2_X = coord_x2_P1DistAzi(Point_1b_X, Point_1b_Y, radius, flugazimut - 90)
        p1b_2_Y = coord_y2_P1DistAzi(Point_1b_X, Point_1b_Y, radius, flugazimut - 90)
        
        
        Dim p1a_1_X_Str As String
        Dim p1a_1_Y_Str As String
        Dim p1a_2_X_Str As String
        Dim p1a_2_Y_Str As String
        
        Dim p1b_1_X_Str As String
        Dim p1b_1_Y_Str As String
        Dim p1b_2_X_Str As String
        Dim p1b_2_Y_Str As String
        
        p1a_1_X_Str = p1a_1_X
        p1a_1_Y_Str = p1a_1_Y
        p1a_2_X_Str = p1a_2_X
        p1a_2_Y_Str = p1a_2_Y
        
        p1b_1_X_Str = p1b_1_X
        p1b_1_Y_Str = p1b_1_Y
        p1b_2_X_Str = p1b_2_X
        p1b_2_Y_Str = p1b_2_Y
        
        retStr = retStr & xol_addKreis_CenterRadius(Spaces, name, Comment, LineSize, LineColor, LineStyle, FillColor, FillStyle, "", "", Point_1a_X, Point_1a_Y, radius)
        retStr = retStr & xol_addKreis_CenterRadius(Spaces, name, Comment, LineSize, LineColor, LineStyle, FillColor, FillStyle, "", "", Point_1b_X, Point_1b_Y, radius)
       
        retStr = retStr & xol_addABC_Polygon(Spaces, name, Comment, Transparency, LineSize, FillColor, LineStyle, FillColor, FillStyle, "", "", _
                         p1a_1_X_Str, p1a_1_Y_Str, p1a_2_X_Str, p1a_2_Y_Str, _
                         p1b_2_X_Str, p1b_2_Y_Str, p1b_1_X_Str, p1b_1_Y_Str)
                             
        retStr = retStr & xol_addLine(Spaces, name, Comment, LineSize, LineColor, LineStyle, "", "", p1a_1_X_Str, p1a_1_Y_Str, p1b_1_X_Str, p1b_1_Y_Str)
        retStr = retStr & xol_addLine(Spaces, name, Comment, LineSize, LineColor, LineStyle, "", "", p1a_2_X_Str, p1a_2_Y_Str, p1b_2_X_Str, p1b_2_Y_Str)
        drawZone_Absprueheinsatz = retStr
End Function

Public Function xol_addABC_KreisImKreis( _
        Point_1a_X As String, _
        Point_1a_Y As String, _
        Windrichtung As String, _
        Optional ByVal rk As String = "2000", _
        Optional ByVal Rg As String = "10000", _
        Optional ByVal Spaces As Integer, _
        Optional ByVal name As String, _
        Optional ByVal Comment As String, _
        Optional ByVal Transparency As String = "1", _
        Optional ByVal LineSize As Integer = 3, _
        Optional ByVal LineColor As String = "000000", _
        Optional ByVal LineStyle As String = "solid", _
        Optional ByVal FillColor As String = "FFFF00", _
        Optional ByVal FillStyle As String = "solid", _
        Optional ByVal Link As String = "", _
        Optional ByVal LinkType As String = "", _
        Optional ByVal Point_1b_X As String = "", _
        Optional ByVal Point_1b_Y As String = "", _
        Optional ByVal LabelPoints As String = "YES", _
        Optional ByVal FillColorFreisetzZone As String = "", _
        Optional ByVal FillStyleFreisetzZone As String = "") As String

        If (FillColorFreisetzZone = "") Then
            FillColorFreisetzZone = FillColor
        End If
        If (FillStyleFreisetzZone = "") Then
            FillStyleFreisetzZone = FillStyle
        End If
                
        Dim retStr As String
        retStr = ""
        
        If (Point_1b_X <> "") Then
        
        End If
        
        retStr = retStr & xol_addKreis_CenterRadius(Spaces, "Gefahrenzone", Comment, LineSize, LineColor, LineStyle, FillColor, FillStyle, Link, LinkType, Point_1a_X, Point_1a_Y, Rg)
        retStr = retStr & xol_addKreis_CenterRadius(Spaces, "Freisetzungszone", Comment, LineSize, LineColor, LineStyle, FillColor, FillStyle, Link, LinkType, Point_1a_X, Point_1a_Y, rk)
        retStr = retStr & xol_addKreuz(Spaces, name, Comment, LineSize, LineColor, LineStyle, Link, LinkType, Point_1a_X, Point_1a_Y, 100)
        
        If (Point_1b_X <> "") Then
            retStr = xol_addKreis_CenterRadius(Spaces, "Gefahrenzone", Comment, LineSize, LineColor, LineStyle, FillColor, FillStyle, Link, LinkType, Point_1a_X, Point_1a_Y, Rg)
            
            retStr = retStr & xol_addKreis_CenterRadius(Spaces, "Gefahrenzone", Comment, LineSize, LineColor, LineStyle, FillColor, FillStyle, Link, LinkType, Point_1b_X, Point_1b_Y, Rg)
            retStr = retStr & xol_addKreis_CenterRadius(Spaces, "Freisetzungszone", Comment, LineSize, LineColor, LineStyle, FillColorFreisetzZone, FillStyleFreisetzZone, Link, LinkType, Point_1b_X, Point_1b_Y, rk)
            retStr = retStr & xol_addKreis_CenterRadius(Spaces, "Freisetzungszone", Comment, LineSize, LineColor, LineStyle, FillColorFreisetzZone, FillStyleFreisetzZone, Link, LinkType, Point_1a_X, Point_1a_Y, rk)
            retStr = retStr & drawZone_Absprueheinsatz(Point_1a_X, Point_1a_Y, Point_1b_X, Point_1b_Y, Rg, Spaces, "Gefahrenzone", Comment, Transparency, LineSize, LineColor, LineStyle, FillColor, FillStyle)
            retStr = retStr & drawZone_Absprueheinsatz(Point_1a_X, Point_1a_Y, Point_1b_X, Point_1b_Y, rk, Spaces, "Freisetzungszone", Comment, Transparency, LineSize, LineColor, LineStyle, FillColorFreisetzZone, FillStyleFreisetzZone)
            
            retStr = retStr & xol_addLine(Spaces, name, "Flugline", 2 * LineSize, "FF0000", LineStyle, Link, LinkType, Point_1a_X, Point_1a_Y, Point_1b_X, Point_1b_Y)
            retStr = retStr & xol_addKreuz(Spaces, name, Comment, LineSize, LineColor, LineStyle, Link, LinkType, Point_1a_X, Point_1a_Y, 100)
            retStr = retStr & xol_addKreuz(Spaces, name, Comment, LineSize, LineColor, LineStyle, Link, LinkType, Point_1b_X, Point_1b_Y, 100)
           
        Else
            retStr = xol_addKreis_CenterRadius(Spaces, "Gefahrenzone", Comment, LineSize, LineColor, LineStyle, FillColor, FillStyle, Link, LinkType, Point_1a_X, Point_1a_Y, Rg)
            retStr = retStr & xol_addKreis_CenterRadius(Spaces, "Freisetzungszone", Comment, LineSize, LineColor, LineStyle, FillColorFreisetzZone, FillStyleFreisetzZone, Link, LinkType, Point_1a_X, Point_1a_Y, rk)
            retStr = retStr & xol_addKreuz(Spaces, name, Comment, LineSize, LineColor, LineStyle, Link, LinkType, Point_1a_X, Point_1a_Y, 100)
        End If
        
        If (LabelPoints = "YES") Then
            retStr = retStr & xol_addText(Point_1a_X, Point_1a_Y, "(" & Point_1a_X & "/" & Point_1a_Y & ")")
            retStr = retStr & xol_addText(Point_1b_X, Point_1b_Y, "(" & Point_1b_X & "/" & Point_1b_Y & ")")
        End If
        
        xol_addABC_KreisImKreis = retStr
End Function


' ABC Trompete Koordinaten
' ======================================================

' P1x
Public Function abc_trompete_get_P1x_X(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    abc_trompete_get_P1x_X = roundDoubleAsString(coord_x2_P1DistAzi(P1aX, P1aY, dis_P1a_P1x, azi_P1a_P1x), 0)
End Function

Public Function abc_trompete_get_P1x_Y(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    abc_trompete_get_P1x_Y = roundDoubleAsString(coord_y2_P1DistAzi(P1aX, P1aY, dis_P1a_P1x, azi_P1a_P1x), 0)
End Function

' P1
Public Function abc_trompete_get_P1_X(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    abc_trompete_get_P1_X = roundDoubleAsString(coord_x2_P1DistAzi(P1aX, P1aY, rk, azi_P1a_P1x), 0)
End Function

Public Function abc_trompete_get_P1_Y(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    abc_trompete_get_P1_Y = roundDoubleAsString(coord_y2_P1DistAzi(P1aX, P1aY, rk, azi_P1a_P1x), 0)
End Function

' P2
Public Function abc_trompete_get_P2_X(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    abc_trompete_get_P2_X = roundDoubleAsString(coord_x2_P1DistAzi(P1aX, P1aY, rk, azi_P1a_P2), 0)
End Function

Public Function abc_trompete_get_P2_Y(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    abc_trompete_get_P2_Y = roundDoubleAsString(coord_y2_P1DistAzi(P1aX, P1aY, rk, azi_P1a_P2), 0)
End Function

' P3
Public Function abc_trompete_get_P3_X(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    Dim P1x_X As Double
    Dim P1x_Y As Double
    
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    P1x_X = abc_trompete_get_P1x_X(P1aX, P1aY, Windrichtung, rk, Rg)
    P1x_Y = abc_trompete_get_P1x_Y(P1aX, P1aY, Windrichtung, rk, Rg)
    abc_trompete_get_P3_X = roundDoubleAsString(coord_x2_P1DistAzi(P1x_X, P1x_Y, dist_P1x_P3, azi_P1x_P3), 0)
End Function

Function abc_trompete_get_P3_Y(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    Dim P1x_X As Double
    Dim P1x_Y As Double
    
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    P1x_X = abc_trompete_get_P1x_X(P1aX, P1aY, Windrichtung, rk, Rg)
    P1x_Y = abc_trompete_get_P1x_Y(P1aX, P1aY, Windrichtung, rk, Rg)
    abc_trompete_get_P3_Y = roundDoubleAsString(coord_y2_P1DistAzi(P1x_X, P1x_Y, dist_P1x_P3, azi_P1x_P3), 0)
End Function

' P4
Public Function abc_trompete_get_P4_X(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    Dim P1x_X As Double
    Dim P1x_Y As Double
    
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    P1x_X = abc_trompete_get_P1x_X(P1aX, P1aY, Windrichtung, rk, Rg)
    P1x_Y = abc_trompete_get_P1x_Y(P1aX, P1aY, Windrichtung, rk, Rg)
    abc_trompete_get_P4_X = roundDoubleAsString(coord_x2_P1DistAzi(P1x_X, P1x_Y, dist_P1x_P3, azi_P1x_P4), 0)
End Function

Public Function abc_trompete_get_P4_Y(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    Dim P1x_X As Double
    Dim P1x_Y As Double
    
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    P1x_X = abc_trompete_get_P1x_X(P1aX, P1aY, Windrichtung, rk, Rg)
    P1x_Y = abc_trompete_get_P1x_Y(P1aX, P1aY, Windrichtung, rk, Rg)
    abc_trompete_get_P4_Y = roundDoubleAsString(coord_y2_P1DistAzi(P1x_X, P1x_Y, dist_P1x_P3, azi_P1x_P4), 0)
End Function

' P5
Public Function abc_trompete_get_P5_X(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    abc_trompete_get_P5_X = roundDoubleAsString(coord_x2_P1DistAzi(P1aX, P1aY, rk, azi_P1a_P5), 0)
End Function

Public Function abc_trompete_get_P5_Y(ByVal P1aX As Double, ByVal P1aY As Double, ByVal Windrichtung As Double, ByVal rk As Double, ByVal Rg As Double) As String
    Dim azi_P1a_P2 As Double
    Dim dis_P1a_P1x As Double
    Dim azi_P1a_P1x As Double
    Dim azi_P1a_P5 As Double
    Dim dist_P1x_P3 As Double
    Dim azi_P1x_P3 As Double
    Dim azi_P1x_P4 As Double
    
    azi_P1a_P2 = coord_modAzimut(Windrichtung - 120)
    dis_P1a_P1x = 2 * rk
    azi_P1a_P1x = coord_gegenwind(Windrichtung)
    azi_P1a_P5 = coord_modAzimut(Windrichtung - 120 - 120)
    dist_P1x_P3 = 2 * (Rg + 2 * rk) / 3 ^ (1 / 2)
    azi_P1x_P3 = coord_modAzimut(Windrichtung - 30)
    azi_P1x_P4 = coord_modAzimut(Windrichtung + 30)
    
    abc_trompete_get_P5_Y = roundDoubleAsString(coord_y2_P1DistAzi(P1aX, P1aY, rk, azi_P1a_P5), 0)
End Function

Sub ABC_SetDefaultForX()
    Dim sName As String
    sName = "ABC-Rechenscheibe"
    Sheets(sName).Range("B20").Value = "1.2"
End Sub

Sub ABC_SetNormForExample()
    Dim sName As String
    sName = "ABC-Rechenscheibe"
    Sheets(sName).Range("C27").Value = Sheets(sName).Range("C10").Value
    Sheets(sName).Range("C39").Value = Sheets(sName).Range("C10").Value
    Sheets(sName).Range("C49").Value = Sheets(sName).Range("C10").Value
    Sheets(sName).Range("M6").Value = Sheets(sName).Range("C10").Value
    Sheets(sName).Range("M7").Value = Sheets(sName).Range("B20").Value
End Sub

Sub ABC_SearchEarliestEntry()
    Dim sName As String
    sName = "ABC-Rechenscheibe"
    Sheets(sName).Range("C53").GoalSeek Goal:=Sheets(sName).Range("C55").Value, ChangingCell:=Sheets(sName).Range("C50")
End Sub

' copy functions
' ======================================================
Public Function copyRangeToTAB( _
        ByVal srcTabName As String, _
        ByVal destTabName As String, _
        ByVal srcUpperLeftCell As String, _
        ByVal srcLowerRightCell As String, _
        Optional ByVal destUpperLeftCell As String = "A1")
        
    Dim src_iLine As Integer
    Dim src_iColumn As String
    Dim src_cellAdr As String
    Dim dest_iLine As Integer
    Dim dest_iColumn As String
    Dim dest_cellAdr As String

    dest_iLine = GetRowIndexFromAdr(destUpperLeftCell)
    For src_iLine = GetRowIndexFromAdr(srcUpperLeftCell) To GetRowIndexFromAdr(srcLowerRightCell)
        src_iColumn = getColumnLetterFromAdr(srcUpperLeftCell)
        dest_iColumn = getColumnLetterFromAdr(destUpperLeftCell)
        Do While src_iColumn <> getColumnLetterFromAdr(srcLowerRightCell)
            src_cellAdr = src_iColumn & src_iLine
            dest_cellAdr = dest_iColumn & dest_iLine
            Sheets(destTabName).Range(dest_cellAdr).NumberFormat = Sheets(srcTabName).Range(src_cellAdr).NumberFormat
            Sheets(destTabName).Range(dest_cellAdr).Value = Sheets(srcTabName).Range(src_cellAdr).Value
            src_iColumn = getNextColumnLetter(src_iColumn)
            dest_iColumn = getNextColumnLetter(dest_iColumn)
        Loop
        src_cellAdr = src_iColumn & src_iLine
        dest_cellAdr = dest_iColumn & dest_iLine
        dest_iLine = dest_iLine + 1
    Next src_iLine
End Function

Public Function copyRangeTo(ByVal sourceShName As String, ByVal sourceRange As String, ByVal destShName As String, ByVal destToLeftCell As String) As String
    Dim destRange As String
    
    If ((sourceShName = "") Or (Not (SheetExists(sourceShName)))) Then
        sourceShName = whichSheetSelected()
    End If

    If ((destShName = "") Or (Not (SheetExists(destShName)))) Then
        destShName = whichSheetSelected()
    End If

    destRange = destToLeftCell & ":" & moveRange(sourceRange, destToLeftCell)
    Sheets(destShName).Range(destRange).Value = Sheets(sourceShName).Range(sourceRange).Value

    copyRangeTo = destRange
End Function

' Format functions
' ======================================================
Function GetBackgroundColorIndex(r As Range) As Integer
    GetBackgroundColorIndex = r.Interior.ColorIndex
End Function

Sub RefreshButton_Click()
    ActiveSheet.EnableCalculation = False
    ActiveSheet.EnableCalculation = True
End Sub

Public Function setFooterAndHeader(ByVal sheetName As String, ByVal leftHeader As String, ByVal centerHeader As String, ByVal rightHeader As String, ByVal leftFooter As String, ByVal centerFooter As String, ByVal rightFooter As String) As String
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    Sheets(sheetName).Select
        
    With ActiveSheet.PageSetup
        .leftHeader = "&""Arial,Regular""&8 " & leftHeader
        .centerHeader = "&""Arial,Regular""&12 " & centerHeader
        .rightHeader = "&""Arial,Regular""&8 " & rightHeader
        .leftFooter = "&""Arial,Regular""&8 " & leftFooter
        .centerFooter = "&""Arial,Regular""&8 " & centerFooter
        .rightFooter = "&""Arial,Regular""&8 " & rightFooter
    End With
    setFooter = ""
End Function


Public Function setEingabeListForField( _
        ByVal listConstraint As String, _
        Optional ByVal sheetName As String = "", _
        Optional ByVal cellAdr As String = "") As String
    
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
        
    If (cellAdr <> "") Then
        Sheets(sheetName).Select
        Range(cellAdr).Select
    End If

    With Selection.Validation
        .Delete
        .Add Type:=xlValidateList, AlertStyle:=xlValidAlertStop, Operator:=xlBetween, Formula1:=listConstraint
        .IgnoreBlank = True
        .InCellDropdown = True
        .InputTitle = ""
        .ErrorTitle = ""
        .InputMessage = ""
        .ErrorMessage = ""
        .ShowInput = True
        .ShowError = True
    End With
End Function

Sub subTestSetColor()
    Call setCellColor("", "Y74:AA76", 4, 6)
End Sub


Sub setCellColor(Optional ByVal shName As String = "", _
                 Optional ByVal cellRange As String = "", _
                 Optional ByVal FillColor As Integer = 0, _
                 Optional ByVal fontColor As Integer = 55)
                      
    If ((shName = "") Or (Not (SheetExists(shName)))) Then
        shName = whichSheetSelected()
    End If
    
    If (cellRange = "") Then
        cellRange = getAdrFromSelectedRange()
    End If
                     
    ' Range("B37").Interior.Color = RGB(Range("H37").Value, Range("H39").Value, Range("H41").Value)
    ' Range("H44").Interior.Color = RGB(Range("B44").Value, Range("B46").Value, Range("B48").Value)

    Sheets(shName).Range(cellRange).Interior.ColorIndex = FillColor
    Sheets(shName).Range(cellRange).Font.Color = fontColor
End Sub

' Format: Remove all grills
Sub mkBorderRemoveAll(ByVal aRange As String, Optional ByVal sheetName As String = "")
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    Sheets(sheetName).Range(aRange).Borders(xlDiagonalDown).LineStyle = xlNone
    Sheets(sheetName).Range(aRange).Borders(xlDiagonalUp).LineStyle = xlNone
    Sheets(sheetName).Range(aRange).Borders(xlEdgeLeft).LineStyle = xlNone
    Sheets(sheetName).Range(aRange).Borders(xlEdgeTop).LineStyle = xlNone
    Sheets(sheetName).Range(aRange).Borders(xlEdgeBottom).LineStyle = xlNone
    Sheets(sheetName).Range(aRange).Borders(xlEdgeRight).LineStyle = xlNone
    Sheets(sheetName).Range(aRange).Borders(xlInsideVertical).LineStyle = xlNone
    Sheets(sheetName).Range(aRange).Borders(xlInsideHorizontal).LineStyle = xlNone
    Sheets(sheetName).Range(aRange).Borders(xlDiagonalDown).LineStyle = xlNone
    Sheets(sheetName).Range(aRange).Borders(xlDiagonalUp).LineStyle = xlNone
End Sub


' Format: samll grill within range (around each cell) and thick frame around range
Public Function formatGitterFct(ByVal shName As String, ByVal aRange As String) As String

    If ((shName = "") Or (Not (SheetExists(shName)))) Then
        shName = whichSheetSelected()
    End If

    Sheets(shName).Range(aRange).Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
    With Selection.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlThin
    End With
   
   formatGitterFct = ""

End Function

Sub FormatGitter(ByVal sheetName As String, ByVal aRange As String)
    Dim retStr As String
    retStr = formatGitterFct(sheetName, aRange)
End Sub


' Format: creates a small (default) border around the range
Sub mkBorderSmallJustAround(ByVal aRange As String, Optional ByVal removeAllFirst As Boolean = True, Optional ByVal sheetName As String = "", Optional ByVal lineWidth As Integer = 1)
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    
    If (lineWidth = 0) Then
        lineWidth = xlNone
    ElseIf (lineWidth = 1) Then
        lineWidth = xlThin
    ElseIf (lineWidth = 2) Then
        lineWidth = xlMedium
    Else
        lineWidth = xlThin
    End If
    
    Sheets(sheetName).Range(aRange).Select
    If (removeAllFirst) Then
        mkBorderRemoveAll aRange
    End If
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = lineWidth
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = lineWidth
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = lineWidth
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = lineWidth
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
End Sub


' Format: creates a thick border around the range
Sub mkBorderThinkJustAround(ByVal aRange As String, Optional ByVal removeAllFirst As Boolean = True, Optional ByVal sheetName As String = "")
    Call mkBorderSmallJustAround(aRange, removeAllFirst, sheetName, 2)
End Sub

' Format: creates horizontal lines to the range
Sub mkBorderSmallHorizontalOnly(ByVal aRange As String, Optional ByVal removeAllFirst As Boolean = True, Optional ByVal sheetName As String = "", Optional ByVal lineWidth As Integer = 1)
    If ((sheetName = "") Or (Not (SheetExists(sheetName)))) Then
        sheetName = whichSheetSelected()
    End If
    
    If (lineWidth = 0) Then
        lineWidth = xlNone
    ElseIf (lineWidth = 1) Then
        lineWidth = xlThin
    ElseIf (lineWidth = 2) Then
        lineWidth = xlMedium
    Else
        lineWidth = xlThin
    End If
    
    Sheets(sheetName).Range(aRange).Select
    If (removeAllFirst) Then
        mkBorderRemoveAll aRange
    End If
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = lineWidth
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = lineWidth
    End With
    With Selection.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = lineWidth
    End With
End Sub

' draws a Gitter around the range (The frame is bold and the Gitter is medium. xHop and yHop defines the Maschenweite
Function addGitterToRange(ByVal topLeftCell As String, _
                            ByVal bottonRightCell As String, _
                            Optional ByVal xHop As Integer = 1, _
                            Optional ByVal yHop As Integer = 1, _
                            Optional ByVal wsName As String = "", _
                            Optional ByVal removeExistingBorders As Boolean = True) As Boolean
    Dim tmp As Boolean
    Dim lastActivityLine As Integer
    Dim countOfLines As Integer
    Dim countOfCoulmns As Integer
    
    If ((wsName = "") Or (Not (SheetExists(wsName)))) Then
        wsName = ActiveWorkbook.ActiveSheet.name
    End If
    
    If (removeExistingBorders) Then
        Call mkBorderRemoveAll(topLeftCell & ":" & bottonRightCell, wsName)
    End If
    
    lastActivityLine = GetRowIndexFromAdr(bottonRightCell)
    countOfLines = lastActivityLine - GetRowIndexFromAdr(topLeftCell)
    countOfColumns = GetColumnIndexFromColumnLetter(getColumnLetterFromAdr(bottonRightCell)) - GetColumnIndexFromColumnLetter(getColumnLetterFromAdr(topLeftCell))
    
    Dim smallTopLeftCell As String
    Dim smallLowRightCell As String
    Dim rowIndex As Integer
    Dim colIndex As Integer
    colIndex = 0
    Do While colIndex <= countOfColumns - 1
        smallTopLeftCell = getAdrByAddingOffset(topLeftCell, colIndex, 0)
        rowIndex = 0
        Do While rowIndex <= lastActivityLine - GetRowIndexFromAdr(topLeftCell)
            smallLowRightCell = getAdrByAddingOffset(topLeftCell, colIndex, rowIndex)
            tmp = addBorderToRange(smallTopLeftCell & ":" & getAdrByAddingOffset(smallLowRightCell, xHop - 1, yHop - 1), wsName, 1, 1, 1, 1)
            rowIndex = rowIndex + yHop
        Loop
        colIndex = colIndex + xHop
    Loop
    tmp = addBorderToRange(topLeftCell & ":" & bottonRightCell, wsName, 2, 2, 2, 2)

    addGitterToRange = True
End Function

' Format: common Grill function to add borders (thick or thin) around a range. each side of the range can be defined thick, thin or nothing
Function addBorderToRange(ByVal aRange As String, _
                              Optional ByVal wsName As String = "", _
                              Optional ByVal top As Integer = 0, _
                              Optional ByVal bottom As Integer = 0, _
                              Optional ByVal left As Integer = 0, _
                              Optional ByVal right As Integer = 0) As Boolean
                              
    If ((wsName = "") Or (Not (SheetExists(wsName)))) Then
        wsName = ActiveWorkbook.ActiveSheet.name
    End If
    
    If (top > 0) Then
        Worksheets(wsName).Range(aRange).Borders(xlEdgeTop).LineStyle = xlContinuous
        Worksheets(wsName).Range(aRange).Borders(xlEdgeTop).ColorIndex = 0
        Worksheets(wsName).Range(aRange).Borders(xlEdgeTop).TintAndShade = 0
        If (top = 1) Then
            Worksheets(wsName).Range(aRange).Borders(xlEdgeTop).Weight = xlThin
        Else
            Worksheets(wsName).Range(aRange).Borders(xlEdgeTop).Weight = xlMedium
        End If
    End If
    If (bottom > 0) Then
        Worksheets(wsName).Range(aRange).Borders(xlEdgeBottom).LineStyle = xlContinuous
        Worksheets(wsName).Range(aRange).Borders(xlEdgeBottom).ColorIndex = 0
        Worksheets(wsName).Range(aRange).Borders(xlEdgeBottom).TintAndShade = 0
        If (bottom = 1) Then
            Worksheets(wsName).Range(aRange).Borders(xlEdgeBottom).Weight = xlThin
        Else
            Worksheets(wsName).Range(aRange).Borders(xlEdgeBottom).Weight = xlMedium
        End If
    End If
    If (left > 0) Then
        Worksheets(wsName).Range(aRange).Borders(xlEdgeLeft).LineStyle = xlContinuous
        Worksheets(wsName).Range(aRange).Borders(xlEdgeLeft).ColorIndex = 0
        Worksheets(wsName).Range(aRange).Borders(xlEdgeLeft).TintAndShade = 0
        If (left = 1) Then
            Worksheets(wsName).Range(aRange).Borders(xlEdgeLeft).Weight = xlThin
        Else
            Worksheets(wsName).Range(aRange).Borders(xlEdgeLeft).Weight = xlMedium
        End If
    End If
    If (right > 0) Then
        Worksheets(wsName).Range(aRange).Borders(xlEdgeRight).LineStyle = xlContinuous
        Worksheets(wsName).Range(aRange).Borders(xlEdgeRight).ColorIndex = 0
        Worksheets(wsName).Range(aRange).Borders(xlEdgeRight).TintAndShade = 0
        If (right = 1) Then
            Worksheets(wsName).Range(aRange).Borders(xlEdgeRight).Weight = xlThin
        Else
            Worksheets(wsName).Range(aRange).Borders(xlEdgeRight).Weight = xlMedium
        End If
    End If
    
    addBorderToRange = True
End Function


' Elektrotechnik Function
' ======================================================
Public Function R_Paral(ByVal r1 As Double, ByVal r2 As Double, ParamArray rx() As Variant) As Double
    Dim Tot As Double
    G_Tot = 1 / r1 + 1 / r2
    Dim i As Integer
    For i = 0 To UBound(rx, 1)
        G_Tot = G_Tot + (1 / rx(i))
    Next i
    R_Paral = 1 / G_Tot
End Function

Public Function R_Serie(ByVal r1 As Double, ByVal r2 As Double, ParamArray rx() As Variant) As Double
    Dim R_Tot As Double
    R_Tot = r1 + r2
    Dim i As Integer
    For i = 0 To UBound(rx, 1)
        R_Tot = R_Tot + rx(i)
    Next i
    R_Serie = R_Tot
End Function

' Stern- / Dreieck-Umwandlungen
' -----------------------------
Public Function Dreieck_Stern_R10(ByVal R12 As Double, ByVal R13 As Double, ByVal R23 As Double) As Double
    Dreieck_Stern_R10 = (R12 * R13) / (R12 + R13 + R23)
End Function

Public Function Dreieck_Stern_R20(ByVal R12 As Double, ByVal R13 As Double, ByVal R23 As Double) As Double
    Dreieck_Stern_R20 = (R12 * R23) / (R12 + R13 + R23)
End Function

Public Function Dreieck_Stern_R30(ByVal R12 As Double, ByVal R13 As Double, ByVal R23 As Double) As Double
    Dreieck_Stern_R30 = (R13 * R23) / (R12 + R13 + R23)
End Function

Public Function Stern_Dreieck_R12(ByVal R10 As Double, ByVal R20 As Double, ByVal R30 As Double) As Double
    Stern_Dreieck_R12 = (R10 * R20 / R30) + R10 + R20
End Function

Public Function Stern_Dreieck_R13(ByVal R10 As Double, ByVal R20 As Double, ByVal R30 As Double) As Double
    Stern_Dreieck_R13 = (R10 * R30 / R20) + R10 + R30
End Function

Public Function Stern_Dreieck_R23(ByVal R10 As Double, ByVal R20 As Double, ByVal R30 As Double) As Double
    Stern_Dreieck_R23 = (R20 * R30 / R10) + R20 + R30
End Function

' Wechselstrom Function
' ======================================================
Public Function elTec_FrequenzFromKreisfres(ByVal kreisfrequenz As String) As Double
    elTec_FrequenzFromKreisfres = getDoubleFromKiloMega(kreisfrequenz) / (2 * Pi)
End Function

Public Function elTec_Kreisfrequenz(ByVal frequenz As String) As Double
    elTec_Kreisfrequenz = 2 * Pi * getDoubleFromKiloMega(frequenz)
End Function

Public Function elTec_Periodendauer(ByVal frequenz As String) As Double
    elTec_Periodendauer = 1 / getDoubleFromKiloMega(frequenz)
End Function

' C- und L-Functions
Public Function elTec_XC(ByVal kapazitaet As String, ByVal frequenz As String) As Double
    Dim dfreq As Double
    dfreq = getDoubleFromKiloMega(frequenz)
    If (dfreq = 0) Then
        dfreq = 0.1
    End If
    elTec_XC = 1 / (getDoubleFromKiloMega(kapazitaet) * elTec_Kreisfrequenz(dfreq))
End Function

Public Function elTec_BC(ByVal kapazitaet As String, ByVal frequenz As String) As Double
    Dim dfreq As Double
    dfreq = getDoubleFromKiloMega(frequenz)
    If (dfreq = 0) Then
        dfreq = 0.1
    End If
    elTec_BC = getDoubleFromKiloMega(kapazitaet) * elTec_Kreisfrequenz(dfreq)
End Function

Public Function elTec_XL(ByVal induktivitaet As String, ByVal frequenz As String) As Double
    elTec_XL = getDoubleFromKiloMega(induktivitaet) * elTec_Kreisfrequenz(frequenz)
End Function

Public Function elTec_BL(ByVal induktivitaet As String, ByVal frequenz As String) As Double
    elTec_BL = 1 / (getDoubleFromKiloMega(induktivitaet) * elTec_Kreisfrequenz(frequenz))
End Function


Public Function elTec_G(ByVal widerstand As String) As Double
    elTec_G = 1 / getDoubleFromKiloMega(widerstand)
End Function

Public Function elTec_XLC(ByVal induktivitaet As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    elTec_XLC = elTec_XL(induktivitaet, frequenz) - elTec_XC(kapazitaet, frequenz)
End Function

Public Function elTec_BLC(ByVal induktivitaet As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    elTec_BLC = elTec_BC(kapazitaet, frequenz) - elTec_BL(induktivitaet, frequenz)
End Function

Public Function elTec_fRes_RLC(ByVal induktivitaet As String, ByVal kapazitaet As String) As Double
    elTec_fRes_RLC = 1 / (2 * Pi * (getDoubleFromKiloMega(induktivitaet) * getDoubleFromKiloMega(kapazitaet)) ^ (1 / 2))
End Function

Public Function elTec_XLC_fBand(ByVal induktivitaet As String, ByVal kapazitaet As String, ByVal widerstand As String, ByVal lowerFreq As Boolean) As Double
    Dim ind As Double
    Dim kap As Double
    Dim wid As Double
    Dim retVal As Double
    
    ind = getDoubleFromKiloMega(induktivitaet)
    kap = getDoubleFromKiloMega(kapazitaet)
    wid = getDoubleFromKiloMega(widerstand)
    
    
    Dim a As Double
    Dim b As Double
    Dim c As Double
    Dim diskrim As Double
    
    a = 1
    b = wid / ind
    c = -1 / (ind * kap)
    diskrim = diskriminante(a, b, c)
    If (diskrim < 0) Then
        retVal = -1
    Else
        retVal = Abs(quadratischeGleichungSolution(a, b, c, lowerFreq))
    End If
    elTec_XLC_fBand = elTec_FrequenzFromKreisfres(retVal)
End Function

' RC-Serie Glieder
Public Function elTec_XRC_Serie(ByVal widerstand As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    Dim pWirkwiderderstand As Double
    Dim pBlindwiderderstand As Double
    Dim dfreq As Double
    dfreq = getDoubleFromKiloMega(frequenz)
    If (dfreq = 0) Then
        dfreq = 0.1
    End If
    pWirkwiderderstand = getDoubleFromKiloMega(widerstand) ^ 2
    pBlindwiderderstand = elTec_XC(kapazitaet, dfreq) ^ 2
    elTec_XRC_Serie = (pBlindwiderderstand + pWirkwiderderstand) ^ (1 / 2)

End Function

Public Function elTec_XRC_SeriePhi(ByVal widerstand As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    Dim wirkwiderderstand As Double
    Dim blindwiderderstand As Double
    wirkwiderderstand = getDoubleFromKiloMega(widerstand)
    Dim dfreq As Double
    dfreq = getDoubleFromKiloMega(frequenz)
    If (dfreq = 0) Then
        elTec_XRC_SeriePhi = 0
    Else
        blindwiderderstand = elTec_XC(kapazitaet, dfreq)
        elTec_XRC_SeriePhi = -1 * phy_Rad__grad(Atn(blindwiderderstand / wirkwiderderstand))
    End If
End Function

Public Function elTec_XRC_Grenzfrequenz(ByVal widerstand As String, ByVal kapazitaet As String) As Double
    elTec_XRC_Grenzfrequenz = 1 / (2 * Pi * getDoubleFromKiloMega(widerstand) * getDoubleFromKiloMega(kapazitaet))
End Function

Public Function elTec_XRC_Guete(ByVal widerstand As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    elTec_XRC_Guete = elTec_XC(kapazitaet, frequenz) / getDoubleFromKiloMega(widerstand)
End Function

' RL-Serie Glieder
Public Function elTec_XRL_Serie(ByVal widerstand As String, ByVal induktivitaet As String, ByVal frequenz As String) As Double
    Dim pWirkwiderderstand As Double
    Dim pBlindwiderderstand As Double
    pWirkwiderderstand = getDoubleFromKiloMega(widerstand) ^ 2
    pBlindwiderderstand = elTec_XL(induktivitaet, frequenz) ^ 2
    elTec_XRL_Serie = (pBlindwiderderstand + pWirkwiderderstand) ^ (1 / 2)
End Function

Public Function elTec_XRL_SeriePhi(ByVal widerstand As String, ByVal induktivitaet As String, ByVal frequenz As String) As Double
    Dim wirkwiderderstand As Double
    Dim blindwiderderstand As Double
    wirkwiderderstand = getDoubleFromKiloMega(widerstand)
    blindwiderderstand = elTec_XL(induktivitaet, frequenz)
    elTec_XRL_SeriePhi = phy_Rad__grad(Atn(blindwiderderstand / wirkwiderderstand))
End Function

Public Function elTec_XRL_Grenzfrequenz(ByVal widerstand As String, ByVal induktivitaet As String) As Double
    elTec_XRL_Grenzfrequenz = getDoubleFromKiloMega(widerstand) / (2 * Pi * getDoubleFromKiloMega(induktivitaet))
End Function

Public Function elTec_XRL_Guete(ByVal widerstand As String, ByVal induktivitaet As String, ByVal frequenz As String) As Double
    elTec_XRL_Guete = elTec_XL(induktivitaet, frequenz) / getDoubleFromKiloMega(widerstand)
End Function

' RLC-Serie Glieder
Public Function elTec_RLC_Serie_Guete(ByVal widerstand As String, ByVal induktivitaet As String, ByVal kapazitaet As String) As Double
    Dim ind As Double
    Dim kap As Double
    Dim wid As Double
    Dim retVal As Double
    
    ind = getDoubleFromKiloMega(induktivitaet)
    kap = getDoubleFromKiloMega(kapazitaet)
    wid = getDoubleFromKiloMega(widerstand)

    elTec_RLC_Serie_Guete = (1 / wid) * ((ind / kap) ^ (1 / 2))
End Function

Public Function elTec_XRLC_Serie(ByVal widerstand As String, ByVal induktivitaet As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    Dim Xlc As Double
    Dim r As Double
    Xlc = elTec_XLC(induktivitaet, kapazitaet, frequenz)
    r = getDoubleFromKiloMega(widerstand)
    elTec_XRLC_Serie = (Xlc ^ 2 + r ^ 2) ^ (1 / 2)
End Function

Public Function elTec_XRLC_SeriePhi(ByVal widerstand As String, ByVal induktivitaet As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    Dim wirkwiderderstand As Double
    Dim blindwiderderstand As Double
    wirkwiderderstand = getDoubleFromKiloMega(widerstand)
    blindwiderderstand = elTec_XLC(induktivitaet, kapazitaet, frequenz)
    elTec_XRLC_SeriePhi = phy_Rad__grad(Atn(blindwiderderstand / wirkwiderderstand))
End Function

' RC-Parallel Glieder
Public Function elTec_Z_RC_Paral(ByVal widerstand As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    elTec_Z_RC_Paral = 1 / elTec_Y_RC_Paral(widerstand, kapazitaet, frequenz)
End Function

Public Function elTec_Y_RC_Paral(ByVal widerstand As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    Dim leitwert As Double
    Dim blindleitwert As Double

    leitwert = elTec_G(widerstand)
    blindleitwert = elTec_BC(kapazitaet, frequenz)
    elTec_Y_RC_Paral = ((leitwert ^ 2) + (blindleitwert ^ 2)) ^ (1 / 2)
End Function

Public Function elTec_XRC_ParalPhi(ByVal widerstand As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    Dim wirkleitwert As Double
    Dim blindleitwert As Double
    wirkleitwert = elTec_G(widerstand)
    Dim dfreq As Double
    dfreq = getDoubleFromKiloMega(frequenz)
    If (dfreq = 0) Then
        elTec_XRC_ParalPhi = 0
    Else
        blindleitwert = elTec_BC(kapazitaet, dfreq)
        elTec_XRC_ParalPhi = phy_Rad__grad(Atn(blindleitwert / wirkleitwert))
    End If
End Function


' RL-Parallel Glieder
Public Function elTec_Z_RL_Paral(ByVal widerstand As String, ByVal induktivitaet As String, ByVal frequenz As String) As Double
    If (getDoubleFromKiloMega(frequenz) = 0) Then
        elTec_Z_RL_Paral = 0
    Else
        elTec_Z_RL_Paral = 1 / elTec_Y_RL_Paral(widerstand, induktivitaet, frequenz)
    End If
End Function

Public Function elTec_Y_RL_Paral(ByVal widerstand As String, ByVal induktivitaet As String, ByVal frequenz As String) As Double
    Dim leitwert As Double
    Dim blindleitwert As Double
    If (getDoubleFromKiloMega(frequenz) = 0) Then
        elTec_Y_RL_Paral = 1E+19
    Else
        leitwert = elTec_G(widerstand)
        blindleitwert = elTec_BL(induktivitaet, frequenz)
        elTec_Y_RL_Paral = ((leitwert ^ 2) + (blindleitwert ^ 2)) ^ (1 / 2)
    End If
End Function

Public Function elTec_XRL_ParalPhi(ByVal widerstand As String, ByVal induktivitaet As String, ByVal frequenz As String) As Double
    Dim wirkleitwert As Double
    Dim blindleitwert As Double
    wirkleitwert = elTec_G(widerstand)
    Dim dfreq As Double
    dfreq = getDoubleFromKiloMega(frequenz)
    If (dfreq = 0) Then
        elTec_XRL_ParalPhi = 0
    Else
        blindleitwert = elTec_BL(induktivitaet, dfreq)
        elTec_XRL_ParalPhi = -1 * phy_Rad__grad(Atn(blindleitwert / wirkleitwert))
    End If
End Function


' RLC-Parallel Glieder
Public Function elTec_ZRLC_Paral(ByVal widerstand As String, ByVal induktivitaet As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
     If (getDoubleFromKiloMega(frequenz) = 0) Then
            elTec_ZRLC_Paral = 0
        Else
            elTec_ZRLC_Paral = 1 / elTec_YRLC_Paral(widerstand, induktivitaet, kapazitaet, frequenz)
        End If
End Function

Public Function elTec_YRLC_Paral(ByVal widerstand As String, ByVal induktivitaet As String, ByVal kapazitaet As String, ByVal frequenz As String) As Double
    Dim Blc As Double
    Dim G As Double
    If (getDoubleFromKiloMega(frequenz) = 0) Then
        elTec_YRLC_Paral = 1E+19
    Else
        Blc = elTec_BLC(induktivitaet, kapazitaet, frequenz)
        G = elTec_G(widerstand)
        elTec_YRLC_Paral = (Blc ^ 2 + G ^ 2) ^ (1 / 2)
    End If
End Function


' Permutationen / Kombinationen
' ======================================================

Public Function nPr(ByVal werteVorrat As Integer, ByVal stichprobenumfang As Integer) As Double
    nPr = per_GeoStichMitReturn(werteVorrat, stichprobenumfang)
End Function

Public Function per_GeoStichMitReturn(ByVal werteVorrat As Integer, ByVal anzahlStellen As Integer) As Double
    Dim retVal As Double
    Dim currVorrat As Integer
    retVal = 1
    currVorrat = werteVorrat
    
    For i = 1 To anzahlStellen
         retVal = retVal * currVorrat
         currVorrat = currVorrat - 1
    Next i
    per_GeoStichMitReturn = retVal
End Function

Public Function per_n_tief_k(ByVal werteVorrat As Integer, ByVal stichprobenumfang As Integer) As Double
    Dim retVal As Double
    Dim currVorrat As Integer
    retVal = 1
    currVorrat = werteVorrat
    
    For i = stichprobenumfang To 1 Step -1
         retVal = retVal * currVorrat / i
         currVorrat = currVorrat - 1
    Next i
    per_n_tief_k = retVal
End Function

Public Function n_tief_k(ByVal werteVorrat As Integer, ByVal stichprobenumfang As Integer) As Double
    n_tief_k = per_n_tief_k(werteVorrat, stichprobenumfang)
End Function

Public Function nCr(ByVal werteVorrat As Integer, ByVal stichprobenumfang As Integer) As Double
    nCr = per_n_tief_k(werteVorrat, stichprobenumfang)
End Function

Public Function Factorial(iNumber As Integer) As Double
  Select Case iNumber
    Case 2 To 170
      Factorial = iNumber * Factorial(iNumber - 1)
    Case 0, 1
      Factorial = 1
    Case Else
      Factorial = Null
  End Select
End Function

Public Function facultaet(iNumber As Integer) As Double
    facultaet = Factorial(iNumber)
End Function


' Polynome-Functions
' ======================================================

' polyCleanPolyStr (20x^3 + 6x^2 - 5)      ==> 20x^3 + 6x^2 + 0x^1 - 5x^0
' polyCleanPolyStr (y = 20x^3 + 6x^2 - 5)  ==> 20x^3 + 6x^2 + 0x^1 - 5x^0
Public Function polyCleanPolyStr(ByVal polyStr As String) As String
    Dim retStr As String
    Dim firstTermIsNegativ As Boolean
    retStr = replaceStringInStringRegEx(polyStr, "\s") ' remove all white spaces
    retStr = getLastFieldFromString(retStr, "=")     ' remove y= if there is one
    retStr = replaceStringInStringRegEx(retStr, "^\+", "") ' removes first +
    
    Dim varName As String
    varName = polyGetVarNameFromPolynome(polyStr)
    
    firstTermIsNegativ = False
    If (isStringMatchesRegEx(retStr, "^\-.*")) Then
        firstTermIsNegativ = True
        retStr = replaceStringInStringRegEx(retStr, "^\-", "") ' removes first -
    End If
    retStr = replaceStringInStringRegEx(retStr, "\+", ";+") ' replace + with ;+
    retStr = replaceStringInStringRegEx(retStr, "\-", ";-") ' replace - with ;-

    
    Dim lastField As String
    lastField = getLastFieldFromString(retStr, ";")
    If (isStringMatchesRegEx(lastField, ".*" & varName & "\^\d+")) Then 'end^s with x^0 , x^4, ....
        ' Debug.Print ("Format perfect: " & lastField)
    ElseIf (isStringMatchesRegEx(lastField, ".*" & varName & "$")) Then
        lastField = lastField & "^1;+0" & varName & "^0"
    Else
        lastField = lastField & varName & "^0"
    End If
    retStr = replaceFieldFromString(retStr, ";", getCountOfFieldsInString(retStr, ";") - 1, lastField)
    
    'false string mit +x,-x oder x beginnt ==> +1x,-1x,1x ersetzen
    retStr = replaceStringInStringRegEx(retStr, "^\+" & varName, "+1" & varName)
    retStr = replaceStringInStringRegEx(retStr, "^\-" & varName, "-1" & varName)
    retStr = replaceStringInStringRegEx(retStr, "^" & varName, "1" & varName)
    
    Dim secondLastField As String
    secondLastField = getFieldFromString(retStr, ";", getCountOfFieldsInString(retStr, ";") - 2)
    If (isStringMatchesRegEx(secondLastField, ".*" & varName & "\^\d+")) Then 'ends with x^0 , x^4, ....
        ' Debug.Print ("Format perfect: " & secondLastField)
    ElseIf (isStringMatchesRegEx(secondLastField, "\d+" & varName & "$")) Then
        secondLastField = secondLastField & "^1"
    ElseIf (isStringMatchesRegEx(secondLastField, ".*" & varName & "$")) Then
        secondLastField = "1" & secondLastField & "^1"
    Else
        secondLastField = secondLastField & varName & "^0"
    End If
    retStr = replaceFieldFromString(retStr, ";", getCountOfFieldsInString(retStr, ";") - 2, secondLastField)
    ' now each factor has now a proper exponent even x^0 or x^1 but polynome still could have missing terms
    
    ' adding the missing terms like 0x^2
    Dim resArray
    resArray = Split(retStr, ";", -1, 1)
    ' displayArray (resArray)
    
    Dim prevExponent As Integer
    Dim highestExponent As Integer
    retStr = resArray(LBound(resArray))
    highestExponent = getFieldFromString(retStr, varName & "^", 1)
    Dim ii As Integer
    ii = LBound(resArray) + 1
    For i = highestExponent - 1 To 0 Step -1
        Dim aExponent As Integer
        Dim fieldStr As String
        If (ii > UBound(resArray)) Then
            fieldStr = "+0" & varName & "^" & i
        Else
            fieldStr = resArray(ii)
            fieldStr = replaceStringInStringRegEx(fieldStr, "\+x", "+1x")
            fieldStr = replaceStringInStringRegEx(fieldStr, "\-x", "-1x")
        End If
        aExponent = getFieldFromString(fieldStr, varName & "^", 1)
        If (aExponent = i) Then
            retStr = retStr & fieldStr
            ii = ii + 1
        Else
            retStr = retStr & "+0" & varName & "^" & i
        End If
    Next i
    
    
    If (firstTermIsNegativ) Then
        retStr = "-" & retStr
    End If
   
    ' Debug.Print (polyStr & " ---> " & retStr)
    polyCleanPolyStr = retStr
End Function

' polyGetPolyStr (20x^3 + 6x^2 - 5)      ==> x|20;6;0;-5
' polyGetPolyStr (y = 20z^3 + 6z^2 - 5)  ==> z|20;6;0;-5
Public Function polyGetPolyStr(ByVal polyStr As String) As String
    Dim retString As String
    Dim resVariablenName As String
    Dim firstTermIsNegativ As Boolean
        
    Dim i As Integer
    
    polyStr = polyCleanPolyStr(polyStr)
    resVariablenName = polyGetVarNameFromPolynome(polyStr)
        
    firstTermIsNegativ = False
    If (isStringMatchesRegEx(polyStr, "^\-.*")) Then
        firstTermIsNegativ = True
        polyStr = replaceStringInStringRegEx(polyStr, "^\-", "") ' removes first -
    End If
    
    polyStr = replaceStringInStringRegEx(polyStr, "\+", ";+") ' replace + with ;+
    polyStr = replaceStringInStringRegEx(polyStr, "\-", ";-") ' replace - with ;-
   
    Dim resArray
    Dim aVal As String
    resArray = Split(polyStr, ";", -1, 1)
    For i = LBound(resArray) To UBound(resArray)
        aVal = getFieldFromString(resArray(i), resVariablenName & "^", 0)
        aVal = replaceStringInStringRegEx(aVal, "\+", "")
        If (i = LBound(resArray)) Then
            If (firstTermIsNegativ) Then
                retString = "-" & aVal
            Else
                retString = aVal
            End If
        Else
            retString = retString & ";" & aVal
        End If
    Next i
      
    polyGetPolyStr = resVariablenName & "|" & retString
End Function

' polyGetVarName (2x^2-3x+4 ==> x)
Public Function polyGetVarNameFromPolynome(ByVal polyStr As String) As String
    Dim resVariablenName As String
    resVariablenName = getLastFieldFromString(polyStr, "=")
    resVariablenName = replaceStringInStringRegEx(resVariablenName, "\+")
    resVariablenName = replaceStringInStringRegEx(resVariablenName, "\-")
    resVariablenName = replaceStringInStringRegEx(resVariablenName, "\^")
    resVariablenName = replaceStringInStringRegEx(resVariablenName, "\d")
    resVariablenName = replaceStringInStringRegEx(resVariablenName, "\s")
    resVariablenName = replaceStringInStringRegEx(resVariablenName, "\.")
    polyGetVarNameFromPolynome = left(resVariablenName, 1)
End Function

' polyGetVarName (x|20;6;0;-5 ==> x)
Public Function polyGetVarName(ByVal polyStr As String) As String
    Dim resVariablenName As String
    Dim realPolyStr As String
    If (Not (strContains(polyStr, "|"))) Then
        polyStr = polyGetPolyStr(polyStr)
    End If
    
    realPolyStr = getFieldFromString(polyStr, "|", 1)
    If (realPolyStr = "") Then
        realPolyStr = getFieldFromString(polyStr, "|", 0)
        resVariablenName = "x"
    Else
        resVariablenName = getFieldFromString(polyStr, "|", 0)
    End If
    polyGetVarName = resVariablenName
End Function

' polyGetPolyFactors (x|20;6;0;-5 ==> 20;6;0;-5)
Public Function polyGetPolyFactors(ByVal polyStr As String) As String
    Dim resVariablenName As String
    Dim realPolyStr As String
    If (Not (strContains(polyStr, "|"))) Then
        polyStr = polyGetPolyStr(polyStr)
    End If
    
    realPolyStr = getFieldFromString(polyStr, "|", 1)
    If (realPolyStr = "") Then
        realPolyStr = getFieldFromString(polyStr, "|", 0)
        resVariablenName = "x"
    Else
        resVariablenName = getFieldFromString(polyStr, "|", 0)
    End If
    polyGetPolyFactors = realPolyStr
End Function


' polyToStr (x|20;6;0;-5 ==> 20x^3 + 6x^2 - 5)
Public Function polyToStr(ByVal polyStr As String) As String
    Dim retString As String
    Dim resVariablenName As String
    Dim realPolyStr As String
    Dim i As Integer
    If (Not (strContains(polyStr, "|"))) Then
        polyStr = polyGetPolyStr(polyStr)
    End If
    
    realPolyStr = polyGetPolyFactors(polyStr)
    resVariablenName = polyGetVarName(polyStr)
    
    resArray = Split(realPolyStr, ";", -1, 1)
    ' displayArray (resArray)
    
    Dim Exponent As Integer
    Exponent = 0
    i = UBound(resArray)
    Do While i >= LBound(resArray)
        Dim aVal As String
        aVal = resArray(i)
        If (i > LBound(resArray)) Then
            If (aVal > 0) Then
               aVal = " + " & aVal
            ElseIf (aVal = 0) Then
               aVal = ""
            Else
                aVal = " - " & Abs(aVal)
            End If
        ElseIf (aVal = 0) Then
            aVal = ""
        End If
        If (resArray(i) <> 0) Then
            If (Exponent = 0) Then
                retString = aVal & retString
            ElseIf (Exponent = 1) Then
                retString = aVal & resVariablenName & retString
            Else
                retString = aVal & resVariablenName & "^" & Exponent & retString
            End If
        End If
        i = i - 1
        Exponent = Exponent + 1
    Loop
    retString = replaceStringInStringRegEx(retString, "^ \+ ", "")
    retString = replaceStringInStringRegEx(retString, "^1" & resVariablenName, "x")
    polyToStr = retString
End Function

' Calculates y-value for a given x-value
Public Function polyGetY_Value(ByVal polyStr As String, ByVal xVal As Double) As Double
    Dim retVal As Double
    Dim realPolyStr As String
    If (Not (strContains(polyStr, "|"))) Then
        polyStr = polyGetPolyStr(polyStr)
    End If
    realPolyStr = polyGetPolyFactors(polyStr)
    resArray = Split(realPolyStr, ";", -1, 1)
    Dim Exponent As Integer
    Exponent = 0
    retVal = 0
    i = UBound(resArray)
    Do While i >= LBound(resArray)
        retVal = retVal + (resArray(i) * (xVal ^ Exponent))
        ' Debug.Print ("retVal :" & retVal)
        i = i - 1
        Exponent = Exponent + 1
    Loop
    polyGetY_Value = retVal
End Function

Public Function polyGetGrad(ByVal polyStr As String) As Integer
    Dim retVal As Integer
    Dim realPolyStr As String
    If (Not (strContains(polyStr, "|"))) Then
        polyStr = polyGetPolyStr(polyStr)
    End If
    
    realPolyStr = polyGetPolyFactors(polyStr)
    resArray = Split(realPolyStr, ";", -1, 1)
    
    polyGetGrad = UBound(resArray) - LBound(resArray)
End Function


Public Function polyAdd(ByVal polyStr_A As String, ByVal polyStr_B As String, Optional ByVal mathOutputFormat As Boolean = False) As String
    Dim retString As String
    Dim resVariablenName_A As String
    Dim realPolyStr_A As String
    Dim resVariablenName_B As String
    Dim realPolyStr_B As String
    Dim i As Integer
    Dim mathOutFormat As Boolean
    mathOutFormat = False
    
    'Maybe the formateneeds to be changed: 2x^2 - 3x + 1 ==> x|2;-3;1
    If (Not (strContains(polyStr_A, "|"))) Then
        ' Debug.Print ("polyStr_A (1):" & polyStr_A)
        polyStr_A = polyGetPolyStr(polyStr_A)
        mathOutFormat = True
        ' Debug.Print ("polyStr_A (2):" & polyStr_A)
    End If
    If (Not (strContains(polyStr_B, ";"))) Then
        ' Debug.Print ("polyStr_B (1):" & polyStr_B)
        polyStr_B = polyGetPolyStr(polyStr_B)
        ' Debug.Print ("polyStr_B (2):" & polyStr_B)
    End If
    
    realPolyStr_A = polyGetPolyFactors(polyStr_A)
    resVariablenName_A = polyGetVarName(polyStr_A)
    realPolyStr_B = polyGetPolyFactors(polyStr_B)
    resVariablenName_B = polyGetVarName(polyStr_B)
    
    resArray_A = Split(turnFieldsInString(realPolyStr_A, ";"), ";", -1, 1)
    ' Debug.Print ("realPolyStr_A")
    ' displayArray (resArray_A)
    
    resArray_B = Split(turnFieldsInString(realPolyStr_B, ";"), ";", -1, 1)
    ' Debug.Print ("")
    ' Debug.Print ("realPolyStr_B")
    ' displayArray (resArray_B)
    
    retString = ""
    If (resVariablenName_A = resVariablenName_B) Then
        i = UBound(resArray_A)
        If (UBound(resArray_A) < UBound(resArray_B)) Then
            i = UBound(resArray_B)
        End If
        
        Do While i >= LBound(resArray_A)
            If (i > UBound(resArray_A)) Then
                retString = retString & ";" & resArray_B(i)
            ElseIf (i > UBound(resArray_B)) Then
                retString = retString & ";" & resArray_A(i)
            Else
                retString = retString & ";" & ((resArray_A(i) * 1) + (resArray_B(i) * 1))
            End If
            i = i - 1
        Loop
        retString = resVariablenName_A & "|" & right(retString, Len(retString) - 1)
        If ((mathOutFormat = True) Or (mathOutputFormat = True)) Then
            retString = polyToStr(retString)
        End If
    Else
        retString = "Polynoms have not the same variables"
    End If
    polyAdd = retString
End Function


Public Function polySub(ByVal polyStr_A As String, ByVal polyStr_B As String, Optional ByVal mathOutputFormat As Boolean = False) As String
    Dim retString As String
    Dim resVariablenName_A As String
    Dim realPolyStr_A As String
    Dim resVariablenName_B As String
    Dim realPolyStr_B As String
    Dim i As Integer
    Dim mathOutFormat As Boolean
    mathOutFormat = False
    
    'Maybe the formateneeds to be changed: 2x^2 - 3x + 1 ==> x|2;-3;1
    If (Not (strContains(polyStr_A, "|"))) Then
        ' Debug.Print ("polyStr_A (1):" & polyStr_A)
        polyStr_A = polyGetPolyStr(polyStr_A)
        mathOutFormat = True
        ' Debug.Print ("polyStr_A (2):" & polyStr_A)
    End If
    If (Not (strContains(polyStr_B, ";"))) Then
        ' Debug.Print ("polyStr_B (1):" & polyStr_B)
        polyStr_B = polyGetPolyStr(polyStr_B)
        ' Debug.Print ("polyStr_B (2):" & polyStr_B)
    End If
    
    realPolyStr_A = polyGetPolyFactors(polyStr_A)
    resVariablenName_A = polyGetVarName(polyStr_A)
    realPolyStr_B = polyGetPolyFactors(polyStr_B)
    resVariablenName_B = polyGetVarName(polyStr_B)
    
    resArray_A = Split(turnFieldsInString(realPolyStr_A, ";"), ";", -1, 1)
    ' Debug.Print ("realPolyStr_A")
    ' displayArray (resArray_A)
    
    resArray_B = Split(turnFieldsInString(realPolyStr_B, ";"), ";", -1, 1)
    ' Debug.Print ("")
    ' Debug.Print ("realPolyStr_B")
    ' displayArray (resArray_B)
    
    retString = ""
    If (resVariablenName_A = resVariablenName_B) Then
        i = UBound(resArray_A)
        If (UBound(resArray_A) < UBound(resArray_B)) Then
            i = UBound(resArray_B)
        End If
        
        Do While i >= LBound(resArray_A)
            If (i > UBound(resArray_A)) Then
                retString = retString & ";" & (0 - (resArray_B(i) * 1))
            ElseIf (i > UBound(resArray_B)) Then
                retString = retString & ";" & resArray_A(i)
            Else
                retString = retString & ";" & ((resArray_A(i) * 1) - (resArray_B(i) * 1))
            End If
            i = i - 1
        Loop
        retString = resVariablenName_A & "|" & right(retString, Len(retString) - 1)
        If ((mathOutFormat = True) Or (mathOutputFormat = True)) Then
            retString = polyToStr(retString)
        End If
    Else
        retString = "Polynoms have not the same variables"
    End If
    polySub = retString
End Function


Public Function polyMul(ByVal polyStr_A As String, ByVal polyStr_B As String, Optional ByVal mathOutputFormat As Boolean = False) As String
    Dim retString As String
    Dim resVariablenName_A As String
    Dim realPolyStr_A As String
    Dim resVariablenName_B As String
    Dim realPolyStr_B As String
    Dim i As Integer
    Dim mathOutFormat As Boolean
    mathOutFormat = False
    
    'Maybe the formateneeds to be changed: 2x^2 - 3x + 1 ==> x|2;-3;1
    If (Not (strContains(polyStr_A, "|"))) Then
        ' Debug.Print ("polyStr_A (1):" & polyStr_A)
        polyStr_A = polyGetPolyStr(polyStr_A)
        mathOutFormat = True
        ' Debug.Print ("polyStr_A (2):" & polyStr_A)
    End If
    If (Not (strContains(polyStr_B, ";"))) Then
        ' Debug.Print ("polyStr_B (1):" & polyStr_B)
        polyStr_B = polyGetPolyStr(polyStr_B)
        ' Debug.Print ("polyStr_B (2):" & polyStr_B)
    End If
    
    Dim retValFinal() As Variant
    retValFinal = Array()
    
    realPolyStr_A = polyGetPolyFactors(polyStr_A)
    resVariablenName_A = polyGetVarName(polyStr_A)
    realPolyStr_B = polyGetPolyFactors(polyStr_B)
    resVariablenName_B = polyGetVarName(polyStr_B)
    
    resArray_A = Split(turnFieldsInString(realPolyStr_A, ";"), ";", -1, 1)
    ' Debug.Print ("realPolyStr_A")
    ' displayArray (resArray_A)
    
    resArray_B = Split(turnFieldsInString(realPolyStr_B, ";"), ";", -1, 1)
    ' Debug.Print ("")
    ' Debug.Print ("realPolyStr_B")
    ' displayArray (resArray_B)
    
    retString = ""
    If (resVariablenName_A = resVariablenName_B) Then
        For i = 0 To (polyGetGrad(polyStr_A) + polyGetGrad(polyStr_B))
            retValFinal = wPush(retValFinal, 0)
        Next i
    
        For ia = UBound(resArray_A) To LBound(resArray_A) Step -1
            For ib = UBound(resArray_B) To LBound(resArray_B) Step -1
                retValFinal(ia + ib) = retValFinal(ia + ib) + (resArray_A(ia) * resArray_B(ib))
                ' Debug.Print ("retValFinal")
                ' displayArray (retValFinal)
            Next ib
        Next ia
        retString = resVariablenName_B & "|" & turnFieldsInString(arrayToString(retValFinal, ";"), ";")
        If ((mathOutFormat = True) Or (mathOutputFormat = True)) Then
            retString = polyToStr(retString)
        End If
    Else
        retString = "Polynoms have not the same variables"
    End If
    polyMul = retString
End Function


Public Function polyAbleiten(ByVal polyStr As String, Optional ByVal mathOutputFormat As Boolean = False) As String
    Dim retString As String
    Dim resVariablenName As String
    Dim realPolyStr As String

    Dim i As Integer
    Dim mathOutFormat As Boolean
    mathOutFormat = False
    
    'Maybe the formateneeds to be changed: 2x^2 - 3x + 1 ==> x|2;-3;1
    If (Not (strContains(polyStr, "|"))) Then
        ' Debug.Print ("polyStr (1):" & polyStr)
        polyStr = polyGetPolyStr(polyStr)
        mathOutFormat = True
        ' Debug.Print ("polyStr (2):" & polyStr)
    End If
    
    Dim retValFinal() As Variant
    retValFinal = Array()
    
    realPolyStr = polyGetPolyFactors(polyStr)
    resVariablenName = polyGetVarName(polyStr)

    
    resArray = Split(turnFieldsInString(realPolyStr, ";"), ";", -1, 1)
    ' Debug.Print ("realPolyStr")
    ' displayArray (resArray)
    
    retString = ""
    For i = 1 To polyGetGrad(polyStr)
        retValFinal = wPush(retValFinal, resArray(i) * i)
    Next i

    retString = resVariablenName & "|" & turnFieldsInString(arrayToString(retValFinal, ";"), ";")
    If ((mathOutFormat = True) Or (mathOutputFormat = True)) Then
        retString = polyToStr(retString)
    End If

    polyAbleiten = retString
End Function

Public Function polynomeInterpolationWithRanges( _
                ByVal xRange As Range, _
                ByVal yRange As Range, _
                Optional ByVal decimalFigures As Integer = 2, _
                Optional ByVal varName As String = "x", _
                Optional ByVal preFix As String = "y = " _
                    ) As String
    polynomeInterpolationWithRanges = polynomeInterpolation(getValueStringFromRange(xRange), getValueStringFromRange(yRange), decimalFigures, varName, preFix)
End Function

Public Function polynomeInterpolation( _
                ByVal xRangeStr As String, _
                ByVal yRangeStr As String, _
                Optional ByVal decimalFigures As Integer = 2, _
                Optional ByVal varName As String = "x", _
                Optional ByVal preFix As String = "y = " _
                    ) As String
                    
    Dim retStr As String
    Dim matrixStr As String

    Dim countOfMesswerteX As Integer
    Dim countOfMesswerteY As Integer
    xMatrix = Split(xRangeStr, ";", -1, 1)
    yMatrix = Split(yRangeStr, ";", -1, 1)
    
    countOfMesswerteX = UBound(xMatrix) - LBound(xMatrix) + 1
    countOfMesswerteY = UBound(yMatrix) - LBound(yMatrix) + 1
    
    'prepare the matrix for n-Gleichungen mit n-Unbekanten
    If (countOfMesswerteX = countOfMesswerteX) Then
        matrixStr = ""
        For iExp = countOfMesswerteX - 1 To 0 Step -1
            For i = 0 To countOfMesswerteX - 1
                If (matrixStr = "") Then
                    matrixStr = "" & xMatrix(i) ^ iExp
                Else
                    matrixStr = matrixStr & ";" & xMatrix(i) ^ iExp
                End If
            Next i
        Next iExp
        
        'calculate the solution for n-Gleichungen mit n-Unbekanten
        retStr = wDetermResolutions(matrixStr, yRangeStr, True, ";", False, decimalFigures)

        'compose polynome string
        Dim expString As String
        
        polyFactors = Split(retStr, ";", -1, 1)
        retStr = ""
        For i = 0 To countOfMesswerteX - 1
            If ((countOfMesswerteX - i - 1) = 0) Then
                expString = ""
            ElseIf ((countOfMesswerteX - i - 1) = 1) Then
                expString = varName
            Else
                expString = varName & "^" & (countOfMesswerteX - i - 1)
            End If
        
            If (retStr = "") Then
                retStr = polyFactors(i) & expString
            Else
                If (polyFactors(i) > 0) Then
                    retStr = retStr & "+" & polyFactors(i) & expString
                ElseIf (polyFactors(i) < 0) Then
                    retStr = retStr & polyFactors(i) & expString
                End If
            End If
        Next i
        retStr = preFix & retStr
    Else
        retStr = "ERROR: Not the same amount of x resp y values!"
    End If
    
    polynomeInterpolation = retStr
End Function

' Matrix-Functions
' ======================================================
Public Function wDeterm(ByVal detStr As String, Optional ByVal lineOrder As Boolean = True, Optional ByVal sepChar As String = ";") As Double
    Dim countOfElements As Integer
    Dim matrixDimension As Integer
    
    inListe = Split(detStr, sepChar, -1, 1)
    countOfElements = UBound(inListe) - LBound(inListe) + 1
    matrixDimension = countOfElements ^ (1 / 2)

    ReDim matrix_A(1 To matrixDimension, 1 To matrixDimension) As Double
                
    Dim iInListe As Integer
    iInListe = 0
    If (lineOrder = True) Then
        For iRow = 1 To matrixDimension
            For iCol = 1 To matrixDimension
                matrix_A(iRow, iCol) = inListe(iInListe)
                iInListe = iInListe + 1
            Next iCol
        Next iRow
    Else
        For iRow = 1 To matrixDimension
            For iCol = 1 To matrixDimension
                matrix_A(iCol, iRow) = inListe(iInListe)
                iInListe = iInListe + 1
            Next iCol
        Next iRow
    End If
    wDeterm = WorksheetFunction.MDeterm(matrix_A)
End Function




Public Function replaceVectorInMatrix(ByVal detStr As String, ByVal vecStr As String, ByVal vecNr As Integer, Optional ByVal byColumn As Boolean = True, Optional ByVal sepChar As String = ";") As String
    Dim countOfElements As Integer
    Dim matrixDimension As Integer
    Dim countOfVecElements As Integer
    Dim retStr As String
    
    
    inMatrix = Split(detStr, sepChar, -1, 1)
    countOfElements = UBound(inMatrix) - LBound(inMatrix) + 1
    matrixDimension = countOfElements ^ (1 / 2)
    
    inVec = Split(vecStr, sepChar, -1, 1)
    countOfVecElements = UBound(inVec) - LBound(inVec) + 1
    
    
    If (((matrixDimension * matrixDimension) = countOfElements) And (matrixDimension = countOfVecElements)) Then
        Dim aVal As Double
        Dim iv As Integer
        iv = 0
        For i = 0 To countOfElements - 1
            If ((i < countOfVecElements * vecNr) Or (i >= countOfVecElements * (vecNr + 1))) Then
                aVal = inMatrix(i)
            Else
                aVal = inVec(iv)
                iv = iv + 1
            End If
            If (Len(retStr) = 0) Then
                retStr = aVal
            Else
                retStr = retStr & sepChar & aVal
            End If
        Next i
    Else
        retStr = "Error: Dimensions are not matching! Matrix:" & matrixDimension & " Vector:" & countOfVecElements
    End If
    replaceVectorInMatrix = retStr
End Function

'Calculates all solutions from n-Gleichungen mit n-Unbekannten
Public Function wDetermResolutions( _
                ByVal detStr As String, _
                ByVal vecStr As String, _
                Optional ByVal byColumn As Boolean = True, _
                Optional ByVal sepChar As String = ";", _
                Optional ByVal withMainDeterminante As Boolean = False, _
                Optional ByVal decimalFigures As Integer = 2 _
                    ) As String
    
    Dim countOfElements As Integer
    Dim matrixDimension As Integer
    Dim countOfVecElements As Integer
    
    Dim determinante As Double
    Dim retStr As String
    
    ' Matrix splitten in 2-dim array
    inMatrix = Split(detStr, sepChar, -1, 1)
    countOfElements = UBound(inMatrix) - LBound(inMatrix) + 1
    matrixDimension = countOfElements ^ (1 / 2)
    
    ' Vector splitten in 1-dim array
    vecInList = Split(vecStr, sepChar, -1, 1)
    countOfVecElements = UBound(vecInList) - LBound(vecInList) + 1
    
    If (((matrixDimension * matrixDimension) = countOfElements) And (matrixDimension = countOfVecElements)) Then
        determinante = wDeterm(detStr, byColumn, sepChar)
        retStr = determinante
        If (determinante = 0) Then
            
        Else
            Dim nebenDeterminante As Double
            Dim aSolution As Double
            Dim aSolutionStr As Double
            
            For i = 0 To matrixDimension - 1
                nebenDeterminante = wDeterm(replaceVectorInMatrix(detStr, vecStr, i, byColumn, sepChar), byColumn, sepChar)
                aSolution = (nebenDeterminante / determinante)
                If (decimalFigures >= 0) Then
                    aSolutionStr = roundDoubleAsString(aSolution, decimalFigures)
                    retStr = retStr & sepChar & aSolutionStr
                Else
                    retStr = retStr & sepChar & aSolution
                End If
            Next i
        End If
    Else
        retStr = "Error: Dimensions are not matching! Matrix:" & matrixDimension & " Vector:" & countOfVecElements
    End If
    
    If (withMainDeterminante = False) Then
        retStr = removeFieldFromString(retStr, sepChar)
    End If
    
    wDetermResolutions = retStr
End Function

Public Function wDetermResolutionsWithRanges( _
                ByVal detRange As Range, _
                ByVal vecRange As Range, _
                Optional ByVal withMainDeterminante As Boolean = False, _
                Optional ByVal decimalFigures As Integer = 2 _
                    ) As String
    wDetermResolutionsWithRanges = wDetermResolutions(getValueStringFromRange(detRange), getValueStringFromRange(vecRange), True, ";", withMainDeterminante, decimalFigures)
End Function


' Matrix-Functions
' ======================================================
Public Function series_SummeFrom_1(ByVal N As Integer) As Integer
    series_SummeFrom_1 = N * (N + 1) / 2
End Function

Public Function series_Summe(ByVal N As Integer, Optional ByVal m As Integer = 1) As Integer
    Dim tmp As Integer
    
    If (N < m) Then
        tmp = N
        N = m
        m = tmp
    End If
    m = m - 1
    series_Summe = series_SummeFrom_1(N) - series_SummeFrom_1(m)
End Function

Public Function series_SummeUnevenFrom_1(ByVal N As Integer) As Integer
    Dim upperI As Integer
    upperI = (N / 2) + 0.5
    
    series_SummeUnevenFrom_1 = upperI ^ 2
End Function

Public Function series_SummeUneven(ByVal N As Integer, Optional ByVal m As Integer = 1) As Integer
    Dim tmp As Integer
    
    If (N < m) Then
        tmp = N
        N = m
        m = tmp
    End If

    If (m >= 3) Then
        m = m - 2
    ElseIf (m = 1) Then
        m = 0
    End If
    
    series_SummeUneven = series_SummeUnevenFrom_1(N) - series_SummeUnevenFrom_1(m)
End Function

Public Function series_SummeQuadratzahlenFrom_1(ByVal N As Integer) As Integer
    series_SummeQuadratzahlenFrom_1 = (N * (N + 1) * (2 * N + 1)) / 6
End Function

Public Function series_Summe1x1ReiheFrom_1(ByVal lastElement As Integer, ByVal reihenFaktor As Integer) As Integer
    series_Summe1x1ReiheFrom_1 = reihenFaktor * series_SummeFrom_1(lastElement / reihenFaktor)
End Function


' Functions to calculate Hamming-Codes
' ====================================
Public Function getHammingBits(ByVal dataBits As String, Optional ByVal useEven As Boolean = False) As String
    ' Debug.Print ("getHammingBits:" & dataBits & ":")
    Dim countOfOnes As Integer
    Dim countOfOnesAsString As String
    Dim resString As String
    resString = ""
    countOfOnes = 0
    For i = 1 To Len(dataBits)
        ' Debug.Print ("getHamming8:" & Mid(dataBits, i, 1))
        If (Mid(dataBits, i, 1) = "1") Then
            If (Len(dataBits) = 8) Then
                If (i = 1) Then
                     countOfOnes = countOfOnes + 1100
                ElseIf (i = 2) Then
                     countOfOnes = countOfOnes + 1011
                ElseIf (i = 3) Then
                     countOfOnes = countOfOnes + 1010
                ElseIf (i = 4) Then
                     countOfOnes = countOfOnes + 1001
                ElseIf (i = 5) Then
                     countOfOnes = countOfOnes + 111
                ElseIf (i = 6) Then
                     countOfOnes = countOfOnes + 110
                ElseIf (i = 7) Then
                     countOfOnes = countOfOnes + 101
                ElseIf (i = 8) Then
                     countOfOnes = countOfOnes + 11
                End If
            End If
            
            If (Len(dataBits) = 12) Then
                If (i = 1) Then
                      countOfOnes = countOfOnes + 1100
                 ElseIf (i = 2) Then
                      countOfOnes = countOfOnes + 1011
                 ElseIf (i = 3) Then
                      countOfOnes = countOfOnes + 1010
                 ElseIf (i = 4) Then
                      countOfOnes = countOfOnes + 1001
                 ElseIf (i = 5) Then
                      countOfOnes = countOfOnes + 1000
                 ElseIf (i = 6) Then
                      countOfOnes = countOfOnes + 111
                 ElseIf (i = 7) Then
                      countOfOnes = countOfOnes + 110
                 ElseIf (i = 8) Then
                      countOfOnes = countOfOnes + 101
                 ElseIf (i = 9) Then
                      countOfOnes = countOfOnes + 100
                 ElseIf (i = 10) Then
                      countOfOnes = countOfOnes + 11
                 ElseIf (i = 11) Then
                      countOfOnes = countOfOnes + 10
                 ElseIf (i = 12) Then
                      countOfOnes = countOfOnes + 1
                 End If
            End If
        End If
    Next i
    countOfOnesAsString = "" & countOfOnes
    For i = 1 To Len(countOfOnesAsString)
          Dim aChar As String
          aChar = Mid(countOfOnesAsString, Len(countOfOnesAsString) - i + 1, 1)
          If (Int(aChar) Mod 2 = 0) Then
               If (useEven) Then
                   resString = "1" & resString
               Else
                   resString = "0" & resString
               End If
          Else
               If (useEven) Then
                   resString = "0" & resString
               Else
                   resString = "1" & resString
               End If
          End If
    Next i
    getHammingBits = resString
End Function

Public Function getHamming8(ByVal dataBits As String, Optional ByVal useEven As Boolean = False) As String
    getHamming8 = Mid(getHammingBits(dataBits, useEven), 1, 1)
End Function

Public Function getHamming4(ByVal dataBits As String, Optional ByVal useEven As Boolean = False) As String
    getHamming4 = Mid(getHammingBits(dataBits, useEven), 2, 1)
End Function

Public Function getHamming2(ByVal dataBits As String, Optional ByVal useEven As Boolean = False) As String
    getHamming2 = Mid(getHammingBits(dataBits, useEven), 3, 1)
End Function

Public Function getHamming1(ByVal dataBits As String, Optional ByVal useEven As Boolean = False) As String
    getHamming1 = Mid(getHammingBits(dataBits, useEven), 4, 1)
End Function

Public Function addHammingBits(ByVal dataBits As String, Optional ByVal useEven As Boolean = False) As String
      Dim hammingBits As String
      Dim resultBits As String
      
      hammingBits = getHammingBits(dataBits, useEven)
      resultBits = Mid(dataBits, 1, 4) & Mid(hammingBits, 1, 1) & Mid(dataBits, 5, 3) & Mid(hammingBits, 2, 1) & Mid(dataBits, 8, 1) & Mid(hammingBits, 3, 2)
      addHammingBits = resultBits
End Function

Public Function verifyHammingCode(ByVal transmittedBits As String, Optional ByVal useEven As Boolean = False) As Integer
      Dim hammingBits As String
      hammingBits = getHammingBits(transmittedBits, useEven)
      verifyHammingCode = BinToDec(hammingBits)
End Function

Public Function correctHammingBits(ByVal transmittedBits As String, Optional ByVal useEven As Boolean = False) As String
      Dim wrongBitPos As Integer
      Dim resultBits As String
      Dim wrongBit As String
      
      wrongBitPos = 12 - verifyHammingCode(transmittedBits, useEven) + 1
      If (wrongBitPos > 12) Then
           resultBits = transmittedBits
      Else
           wrongBit = Mid(transmittedBits, wrongBitPos, 1)
           If (wrongBit = "1") Then
               wrongBit = "0"
           Else
               wrongBit = "1"
           End If
           
           resultBits = Mid(transmittedBits, 1, wrongBitPos - 1) & wrongBit & Mid(transmittedBits, wrongBitPos + 1)
      End If
      correctHammingBits = resultBits
End Function

Public Function decodeHammingBits(ByVal transmittedBits As String, Optional ByVal useEven As Boolean = False) As String
      Dim dataBits As String
      dataBits = Mid(transmittedBits, 1, 1) & Mid(transmittedBits, 2, 1) & Mid(transmittedBits, 3, 1) & Mid(transmittedBits, 4, 1) & Mid(transmittedBits, 6, 1) & Mid(transmittedBits, 7, 1) & Mid(transmittedBits, 8, 1) & Mid(transmittedBits, 10, 1)
      decodeHammingBits = Chr(BinToDec(dataBits))
End Function


