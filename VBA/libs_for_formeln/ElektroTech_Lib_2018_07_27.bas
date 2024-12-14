Attribute VB_Name = "ElektroTech_Lib_2018_07_27"
' ===================
' VBA excel functions
' ===================

' START---------------------------------------------------------------------
' Author:      Walter Rothlin
' Description: Common functions for Elektrotechnik
'
' File Name: ElektroTech_Lib_yyyy_mm_dd
'
' 02-Dec-2013    V1.0  Walter Rothlin       Initial Version
' 03-Dec-2013    V1.1  Walter Rothlin       Merged with formeln
' 06-Dec-2013    V1.2  Walter Rothlin       Merged with Functionsimulator
'                                           Added Wechselstrom Function
' 19-Dec-2013    V1.3  Walter Rothlin       Add action listner for fourier analyses
' 10-Feb-2014    V1.4  Walter Rothlin       Modified code and fixed erros
' 12-Feb-2014    V1.5  Walter Rothlin       Added save/restore functionparameters
' 11-Aug-2016    V1.6  Walter Rothlin       Added R_Paral and R_Serie
' 27-Jul-2018    V1.7  Walter Rothlin       Moved R_Paral and R_Serie to WaltisVBA_Library
' END-----------------------------------------------------------------------

Public Const Version_ElektroTech_Lib As String = "V1.7"
Public Const ElTechGrapfPage As String = "Funktionsgraphen"
Public Const ElTechFctGraphVectorTbl As String = "Vektor"

Public Const FctParaRange As String = "A3:K9"
Public Const FctParaRange_1 As String = "B14:D17"

Public Const FctParaRangeSaveAC As String = "V3:AF9"
Public Const FctParaRange_1SaveAC As String = "V10:X13"

Public Const FctParaRangeSaveFct As String = "AM3:AW9"
Public Const FctParaRange_1SaveFct As String = "AM10:AO13"

Public Const FctParaColumAC As String = "V"
Public Const FctParaColumFct As String = "AM"

Public Const FctParaSaveFirstRow As Integer = 100
Public Const FctParaSaveRowStep As Integer = 20


Public Function getElTechLibVersion()
    getElTechLibVersion = Version_ElektroTech_Lib
End Function

Public Function hideUnhideOneFct(ByVal fctNr As Integer, ByVal doHide) As Boolean
    If (fctNr = 1) Then
        Sheets(ElTechGrapfPage).Rows("22:22").EntireRow.Hidden = doHide
        Sheets(ElTechGrapfPage).Rows("6:6").EntireRow.Hidden = doHide
    ElseIf (fctNr = 2) Then
        Sheets(ElTechGrapfPage).Rows("23:23").EntireRow.Hidden = doHide
        Sheets(ElTechGrapfPage).Rows("7:7").EntireRow.Hidden = doHide
    ElseIf (fctNr = 3) Then
        Sheets(ElTechGrapfPage).Rows("24:24").EntireRow.Hidden = doHide
        Sheets(ElTechGrapfPage).Rows("8:8").EntireRow.Hidden = doHide
    ElseIf (fctNr = 4) Then
        Sheets(ElTechGrapfPage).Rows("25:25").EntireRow.Hidden = doHide
        Sheets(ElTechGrapfPage).Rows("9:9").EntireRow.Hidden = doHide
    End If
    hideUnhideOneFct = True
End Function

Public Function hideUnhideAllFct() As Boolean
    Dim tmpRet As Boolean
    tmpRet = hideUnhideOneFct(1, Not (returnInteger(Sheets(ElTechGrapfPage).Range("D14").Value, 1) = 1))
    tmpRet = hideUnhideOneFct(2, Not (returnInteger(Sheets(ElTechGrapfPage).Range("D15").Value, 1) = 1))
    tmpRet = hideUnhideOneFct(3, Not (returnInteger(Sheets(ElTechGrapfPage).Range("D16").Value, 1) = 1))
    tmpRet = hideUnhideOneFct(4, Not (returnInteger(Sheets(ElTechGrapfPage).Range("D17").Value, 1) = 1))
    hideUnhideAllFct = True
End Function


Public Sub switchMainScreen()
    Dim tmpVal As Boolean
    Fct_Simulator.Hide
    If (Sheets(ElTechGrapfPage).Range("A2").Value = "Wechselstrom - Theorie") Then
        ' Wechselstrom ==> Function
        Sheets(ElTechGrapfPage).Range("A2").Value = "Funktionsgraphen"
        ActiveSheet.Shapes.Range(Array("Rounded Rectangle 6")).Select
        Selection.ShapeRange(1).TextFrame2.TextRange.Characters.Text = "Switch to" & Chr(10) & "Wechselstrom - Theorie"
        
        ' Moving Vectorgraph away
        Sheets(ElTechGrapfPage).Shapes("Diagramm 4").IncrementLeft 2000
        Sheets(ElTechGrapfPage).Shapes("Diagramm 4").IncrementTop -1.25
        Sheets(ElTechGrapfPage).Shapes.Range(Array("Abgerundetes Rechteck 3")).IncrementLeft -200
        Sheets(ElTechGrapfPage).Shapes.Range(Array("Abgerundetes Rechteck 3")).IncrementTop -500
        Fct_Simulator.absCheck_4.Enabled = True
        Fct_Simulator.Pwr_4.Enabled = True
        
        ' Save Formulas from Wechselstrom
        Sheets(ElTechGrapfPage).Range(FctParaRangeSaveAC).Value = Sheets(ElTechGrapfPage).Range(FctParaRange).Value
        Sheets(ElTechGrapfPage).Range(FctParaRange_1SaveAC).Value = Sheets(ElTechGrapfPage).Range(FctParaRange_1).Value
        ' Restore Functionparameters
        Sheets(ElTechGrapfPage).Range(FctParaRange).Value = Sheets(ElTechGrapfPage).Range(FctParaRangeSaveFct).Value
        Sheets(ElTechGrapfPage).Range(FctParaRange_1).Value = Sheets(ElTechGrapfPage).Range(FctParaRange_1SaveFct).Value
        
    Else
        ' Function ==> Wechselstrom
        Sheets(ElTechGrapfPage).Range("A2").Value = "Wechselstrom - Theorie"
        ActiveSheet.Shapes.Range(Array("Rounded Rectangle 6")).Select
        Selection.ShapeRange(1).TextFrame2.TextRange.Characters.Text = "Switch to" & Chr(10) & "Funktionsgraphen"

        ' Moving Vectorgraph back
        Sheets(ElTechGrapfPage).Shapes("Diagramm 4").IncrementLeft -2000
        Sheets(ElTechGrapfPage).Shapes("Diagramm 4").IncrementTop 1.25
        Sheets(ElTechGrapfPage).Shapes.Range(Array("Abgerundetes Rechteck 3")).IncrementLeft 200
        Sheets(ElTechGrapfPage).Shapes.Range(Array("Abgerundetes Rechteck 3")).IncrementTop 500
        Fct_Simulator.absCheck_4.Enabled = False
        Fct_Simulator.Pwr_4.Enabled = False

        ' Save Formulas from Functionparameters
        Sheets(ElTechGrapfPage).Range(FctParaRangeSaveFct).Value = Sheets(ElTechGrapfPage).Range(FctParaRange).Value
        Sheets(ElTechGrapfPage).Range(FctParaRange_1SaveFct).Value = Sheets(ElTechGrapfPage).Range(FctParaRange_1).Value
        ' Restore Wechselstrom
        Sheets(ElTechGrapfPage).Range(FctParaRange).Value = Sheets(ElTechGrapfPage).Range(FctParaRangeSaveAC).Value
        Sheets(ElTechGrapfPage).Range(FctParaRange_1).Value = Sheets(ElTechGrapfPage).Range(FctParaRange_1SaveAC).Value
        
    End If
    Sheets(ElTechGrapfPage).Range("B9").FormulaR1C1 = "=CONCATENATE(rmGleich_WR(R[-3]C[-1])," & getDoubleQuote() & " " & getDoubleQuote() & ",R[6]C[1], " & getDoubleQuote() & " " & getDoubleQuote() & ",rmGleich_WR(R[-2]C[-1]))"
        
    DistributeFormulas
    tmpVal = hideUnhideAllFct()
    Sheets(ElTechGrapfPage).Range("A1").Select
End Sub

' For Funktionsgraphen
Public Sub DistributeFormulas()
  Dim FirstPoint
  Dim CountOfPoints
  Dim FirstFunction
  Dim CountOfFunctions
  Dim FirstParameter
  Dim CountOfParameters
  
  FirstPoint = Range("O6").Value
  CountOfPoints = Range("N7").Value
  FirstFunction = Range("O10").Value
  CountOfFunctions = Range("N11").Value
  FirstParameter = Range("O14").Value
  CountOfParameters = Range("N15").Value


  Range("F15").FormulaR1C1 = "=SUBSTITUTE(R[-3]C,R[-2]C,R[-1]C)"
  For i = 0 To CountOfFunctions - 2 ' 2 instead of 1 because f4 is fix f1(x) + f2(x)
     Dim FctStr As String
     FctStr = Range(FirstFunction).Offset(i, 0).Value
     For ii = 0 To CountOfParameters - 1
        Range("F12").Value = FctStr
        Range("F13").Value = Range(FirstParameter).Offset(-1, ii).Value
        
        If (((Range("C3").Value) And (Range("F13").Value = "a")) Or _
            ((Range("D3").Value) And (Range("F13").Value = "b")) Or _
            ((Range("E3").Value) And (Range("F13").Value = "c")) Or _
            ((Range("F3").Value) And (Range("F13").Value = "d")) Or _
            ((Range("G3").Value) And (Range("F13").Value = "e")) Or _
            ((Range("H3").Value) And (Range("F13").Value = "f"))) Then
            Range("F14").Value = "RADX(" & GetCellAddr(Range("N14").Value + i, Range("M14").Value + ii) & ")"
        ' ElseIf ((Range("e2").Value = Range("M16").Value) And (Range("F13").Value = "c")) Then
        '     Range("F14").Value = "RADX(" & GetCellAddr(Range("N14").Value + i, Range("M14").Value + ii) & ")"
        Else
            Range("F14").Value = GetCellAddr(Range("N14").Value + i, Range("M14").Value + ii)
        End If
        FctStr = Range("F15").Value
     Next
     Range("F12").Value = "(ABS_WR(" & FctStr & ",J" & Range("N14").Value + i & "))^K" & Range("N14").Value + i
     
     
     ' Formel for Simulation
     Range("F13").Value = "x"
     Range("F14").Value = GetCellAddr(Range("N10").Value - 1, Range("M10").Value + Range("N14").Value + 1)
     Range(FirstFunction).Offset(i, Range("N15").Value + 1).Value = "=" & Range("F15").Value
     
     ' Formel for Werte-Tabelle
     For iii = 0 To CountOfPoints
       Range("F14").Value = GetCellAddr(Range("N6").Value, Range("M6").Value + iii)
       Range(FirstPoint).Offset(i + 1, iii).Value = "=" & Range("F15").Value
     Next
  Next
  Range("F12:F15").ClearContents
End Sub

Public Function addPreFix(ByVal aStr As String, ByVal preStr As String) As String
    Dim retStr As String
    
    If (aStr = "") Then
        retStr = ""
    Else
        retStr = preStr & aStr
    End If
    addPreFix = retStr
End Function



Public Sub Show_Fct_SimulatorWindow()
    Fct_Simulator.Fct_1_Option.Caption = Sheets(ElTechGrapfPage).Range("A22").Value
    Fct_Simulator.Fct_2_Option.Caption = Sheets(ElTechGrapfPage).Range("A23").Value
    Fct_Simulator.Fct_3_Option.Caption = Sheets(ElTechGrapfPage).Range("A24").Value
    Fct_Simulator.Fct_4_Option.Caption = Sheets(ElTechGrapfPage).Range("A25").Value
   
    ' add labels for parameter
    Fct_Simulator.Param_a.Caption = Sheets(ElTechGrapfPage).Range("C5").Value & addPreFix(Sheets(ElTechGrapfPage).Range("C4").Value, "= ")
    Fct_Simulator.Param_b.Caption = Sheets(ElTechGrapfPage).Range("D5").Value & addPreFix(Sheets(ElTechGrapfPage).Range("D4").Value, "= ")
    Fct_Simulator.Param_c.Caption = Sheets(ElTechGrapfPage).Range("E5").Value & addPreFix(Sheets(ElTechGrapfPage).Range("E4").Value, "= ")
    Fct_Simulator.Param_d.Caption = Sheets(ElTechGrapfPage).Range("F5").Value & addPreFix(Sheets(ElTechGrapfPage).Range("F4").Value, "= ")
    Fct_Simulator.Param_e.Caption = Sheets(ElTechGrapfPage).Range("G5").Value & addPreFix(Sheets(ElTechGrapfPage).Range("G4").Value, "= ")
    Fct_Simulator.Param_f.Caption = Sheets(ElTechGrapfPage).Range("H5").Value & addPreFix(Sheets(ElTechGrapfPage).Range("H4").Value, "= ")
    
    ' grad / rad
    If (Sheets(ElTechGrapfPage).Range("E2").Value = "grad") Then
        Fct_Simulator.grdWinkelChrckBox.Value = True
    Else
        Fct_Simulator.grdWinkelChrckBox.Value = False
    End If

    ' show graphs
    Fct_Simulator.Fct_1_OnOff = (returnInteger(Sheets(ElTechGrapfPage).Range("D14").Value, 1) = 1)
    Fct_Simulator.Fct_2_OnOff = (returnInteger(Sheets(ElTechGrapfPage).Range("D15").Value, 1) = 1)
    Fct_Simulator.Fct_3_OnOff = (returnInteger(Sheets(ElTechGrapfPage).Range("D16").Value, 1) = 1)
    Fct_Simulator.Fct_4_OnOff = (returnInteger(Sheets(ElTechGrapfPage).Range("D17").Value, 1) = 1)

    ' Overloaded functions
    Fct_Simulator.absCheck_1 = Sheets(ElTechGrapfPage).Range("J6").Value
    Fct_Simulator.absCheck_2 = Sheets(ElTechGrapfPage).Range("J7").Value
    Fct_Simulator.absCheck_3 = Sheets(ElTechGrapfPage).Range("J8").Value
    Fct_Simulator.absCheck_4 = Sheets(ElTechGrapfPage).Range("J9").Value
    Fct_Simulator.Pwr_1 = Sheets(ElTechGrapfPage).Range("K6").Value
    Fct_Simulator.Pwr_2 = Sheets(ElTechGrapfPage).Range("K7").Value
    Fct_Simulator.Pwr_3 = Sheets(ElTechGrapfPage).Range("K8").Value
    Fct_Simulator.Pwr_4 = Sheets(ElTechGrapfPage).Range("K9").Value
    
    ' Parameter
    Fct_Simulator.aVal = Sheets(ElTechGrapfPage).Range("C6").Value
    Fct_Simulator.bVal = Sheets(ElTechGrapfPage).Range("D6").Value
    Fct_Simulator.cVal = Sheets(ElTechGrapfPage).Range("E6").Value
    Fct_Simulator.dVal = Sheets(ElTechGrapfPage).Range("F6").Value
    Fct_Simulator.eVal = Sheets(ElTechGrapfPage).Range("G6").Value
    Fct_Simulator.fVal = Sheets(ElTechGrapfPage).Range("H6").Value
    
    ' x-Min/x-Max
    Fct_Simulator.xMin.Value = Sheets(ElTechGrapfPage).Range("B15").Value
    Fct_Simulator.xMax.Value = Sheets(ElTechGrapfPage).Range("B16").Value
    
    ' grad/rad check boc
    Fct_Simulator.aIsWinkel = Sheets(ElTechGrapfPage).Range("C3").Value
    Fct_Simulator.bIsWinkel = Sheets(ElTechGrapfPage).Range("D3").Value
    Fct_Simulator.cIsWinkel = Sheets(ElTechGrapfPage).Range("E3").Value
    Fct_Simulator.dIsWinkel = Sheets(ElTechGrapfPage).Range("F3").Value
    Fct_Simulator.eIsWinkel = Sheets(ElTechGrapfPage).Range("G3").Value
    Fct_Simulator.fIsWinkel = Sheets(ElTechGrapfPage).Range("H3").Value

    ' Resultierende Function
    If Sheets(ElTechGrapfPage).Range("C15").Value = "+" Then
        Fct_Simulator.resFctSumme.Value = True
        Fct_Simulator.resFctDiff.Value = False
        Fct_Simulator.resFctMult.Value = False
    ElseIf Sheets(ElTechGrapfPage).Range("C15").Value = "-" Then
        Fct_Simulator.resFctSumme.Value = False
        Fct_Simulator.resFctDiff.Value = True
        Fct_Simulator.resFctMult.Value = False
    ElseIf Sheets(ElTechGrapfPage).Range("C15").Value = "*" Then
        Fct_Simulator.resFctSumme.Value = False
        Fct_Simulator.resFctDiff.Value = False
        Fct_Simulator.resFctMult.Value = True
    End If
    
    Fct_Simulator.Fct_1_Option.Value = True
    Fct_Simulator.Param_a.Value = True
    Fct_Simulator.Show
End Sub

Public Function getSelParaRow() As String
    Dim row As Integer
    If (Fct_Simulator.Fct_1_Option.Value) Then
       row = 6
    ElseIf (Fct_Simulator.Fct_2_Option.Value) Then
       row = 7
    ElseIf (Fct_Simulator.Fct_3_Option.Value) Then
       row = 8
    ElseIf (Fct_Simulator.Fct_4_Option.Value) Then
       row = 9
    End If
    getSelParaRow = row
End Function


Public Function getSelParaCol() As String
    Dim column As String
    If (Fct_Simulator.Param_a.Value) Then
       column = "C"
    ElseIf (Fct_Simulator.Param_b.Value) Then
       column = "D"
    ElseIf (Fct_Simulator.Param_c.Value) Then
       column = "E"
    ElseIf (Fct_Simulator.Param_d.Value) Then
       column = "F"
    ElseIf (Fct_Simulator.Param_e.Value) Then
       column = "G"
    ElseIf (Fct_Simulator.Param_f.Value) Then
       column = "H"
    End If
    getSelParaCol = column
End Function

Public Function getSelectParameterField() As String
    getSelectParameterField = getSelParaCol() & getSelParaRow()
End Function

Public Function RADX(ByVal Grad As Double) As Double
    RADX = WR_Math_Radx(Grad, Sheets(ElTechGrapfPage).Range("E2").Value)
End Function

Public Function ABS_WR(ByVal iVal As Double, ByVal doAbs As Boolean) As Double
    ABS_WR = WR_Math_ABS(iVal, doAbs)
End Function

Public Function resFct_WR(ByVal iVal_1 As Double, ByVal iVal_2 As Double, ByVal opChr As String) As Double
    resFct_WR = WR_Math_Ops(iVal_1, iVal_2, opChr)
End Function


Public Function rmGleich_WR(ByVal iVal_1 As String) As String
    rmGleich_WR = replaceStringInString(iVal_1, "=", "")
End Function


' Functions / Sub for Save and restore function Parameter
Public Sub saveFunctionParameter()
    Dim tmpBool As String
    Dim columLetter As String
    Dim rowIndex As Integer
    Dim rowIndexStep As Integer
    rowIndex = FctParaSaveFirstRow
    rowIndexStep = FctParaSaveRowStep
    Dim saveName As String
    saveName = Sheets(ElTechGrapfPage).Range("A4").Value
    
    If (saveName <> "") Then
        If (Sheets(ElTechGrapfPage).Range("A2").Value = "Wechselstrom - Theorie") Then
            columLetter = FctParaColumAC
        Else
            columLetter = FctParaColumFct
        End If
        
        ' row suchen, mit dem gleichen Namen oder nächste freie
        Do While ((Sheets(ElTechGrapfPage).Range(columLetter & rowIndex + 1).Value <> saveName) And _
                  (Sheets(ElTechGrapfPage).Range(columLetter & rowIndex + 1).Value <> ""))
    
            rowIndex = rowIndex + rowIndexStep
        Loop
        tmpBool = copyRangeTo("", FctParaRange, "", columLetter & rowIndex)
        tmpBool = copyRangeTo("", FctParaRange_1, "", columLetter & rowIndex + 7)
    End If
End Sub

Public Sub resFctParaBtnAction()
    Dim nArr_1() As Variant
    nArr_1 = splitStringByDelimiterStr(getRestoreNames(), ";")
    Fct_SaveRestore.NameList.Clear
    For i = LBound(nArr_1) + 1 To UBound(nArr_1)
        Fct_SaveRestore.NameList.AddItem (nArr_1(i))
    Next i
    Fct_SaveRestore.Show
End Sub

Public Function restoreFctParam(ByVal profileName As String) As Boolean
    Dim tmpStr As String
    Dim tmpVal As Boolean
    Dim restPosOL As String
    Dim restPosUR As String
    Dim restPosOL_1 As String
    Dim restPosUR_1 As String

    restPosOL = getRestorePosition(profileName)
    restPosUR = moveRange(FctParaRange, restPosOL)
    tmpStr = copyRangeTo("", restPosOL & ":" & restPosUR, "", getFieldFromString(FctParaRange, ":", 0))
    
    restPosOL_1 = getColumnLetterFromAdr(restPosOL) & GetRowIndexFromAdr(restPosOL) + 7
    restPosUR_1 = moveRange(FctParaRange_1, restPosOL_1)
    tmpStr = copyRangeTo("", restPosOL_1 & ":" & restPosUR_1, "", getFieldFromString(FctParaRange_1, ":", 0))
    
    DistributeFormulas
    tmpVal = hideUnhideAllFct()
End Function

Public Function getRestoreNames() As String
    Dim retStr As String
    Dim columLetter As String
    Dim rowIndex As Integer
    Dim rowIndexStep As Integer
    rowIndex = FctParaSaveFirstRow
    rowIndexStep = FctParaSaveRowStep
    retStr = ""
    If (Sheets(ElTechGrapfPage).Range("A2").Value = "Wechselstrom - Theorie") Then
        columLetter = FctParaColumAC
    Else
        columLetter = FctParaColumFct
    End If
    Do While (Sheets(ElTechGrapfPage).Range(columLetter & rowIndex + 1).Value <> "")
        retStr = retStr & ";" & Sheets(ElTechGrapfPage).Range(columLetter & rowIndex + 1).Value
        rowIndex = rowIndex + rowIndexStep
    Loop
    
    getRestoreNames = retStr
End Function


Public Function getRestorePosition(ByVal savedName As String) As String
    Dim retStr As String
    Dim columLetter As String
    Dim rowIndex As Integer
    Dim rowIndexStep As Integer
    rowIndex = FctParaSaveFirstRow
    rowIndexStep = FctParaSaveRowStep
    retStr = ""
    If (Sheets(ElTechGrapfPage).Range("A2").Value = "Wechselstrom - Theorie") Then
        columLetter = FctParaColumAC
    Else
        columLetter = FctParaColumFct
    End If
    Do While ((Sheets(ElTechGrapfPage).Range(columLetter & rowIndex + 1).Value <> savedName) And _
              (Sheets(ElTechGrapfPage).Range(columLetter & rowIndex + 1).Value <> ""))
        rowIndex = rowIndex + rowIndexStep
    Loop
    If (Sheets(ElTechGrapfPage).Range(columLetter & rowIndex + 1).Value = savedName) Then
        getRestorePosition = columLetter & rowIndex
    Else
        getRestorePosition = ""
    End If
End Function



