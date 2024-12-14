Attribute VB_Name = "Unknown"
Function myConvertDate(sDate As String)
   Dim iDay As Integer
   Dim sMonth As String
   Dim iYear As Integer

   iDay = left(sDate, 2)
   sMonth = Mid(sDate, 4, 3)
   iYear = right(sDate, 4)

  'myConvertDate = DateValue(iDay & "-" & sMonth & "-" & iYear)
  myConvertDate = iDay & "---" & sMonth & "---" & iYear
End Function

Public Function myEval(strFormula As String) As Double
    myEval = Evaluate(strFormula)
End Function

Public Sub RunFormulaMacro()
    Dim ws As Worksheet
    Set ws = Worksheets("Sheet1")
    ws.Range("B4").Formula = "=" & ws.Range("A4").Value
End Sub

Sub hiddeResultat_Korrektur()
    Columns("C:E").Select
    Selection.EntireColumn.Hidden = True
End Sub

Sub clearResults()
    Range("B7:B49").ClearContents
    Range("B7").Select
End Sub

Sub showCorrectur()
    Columns("B:F").Select
    Selection.EntireColumn.Hidden = False
    Columns("D:F").Select
    Selection.EntireColumn.Hidden = True
    Range("B1").Select
End Sub

Sub AHVDatumAufKalendarCalcUebernehmen()
Attribute AHVDatumAufKalendarCalcUebernehmen.VB_Description = "Makro am 20.01.2005 von Rothlin Walter (KATT 2) aufgezeichnet"
Attribute AHVDatumAufKalendarCalcUebernehmen.VB_ProcData.VB_Invoke_Func = " \n14"
    Range("D44").Select
    ActiveCell.FormulaR1C1 = "=R[-5]C"
    Range("D45").Select
    ActiveCell.FormulaR1C1 = "=R[-4]C"
    Range("D46").Select
End Sub

Sub setCellColor()
    Sheets("Zahlensysteme").Select
    Range("B37").Interior.Color = RGB(Range("H37").Value, Range("H39").Value, Range("H41").Value)
    Range("H44").Interior.Color = RGB(Range("B44").Value, Range("B46").Value, Range("B48").Value)
    For colorRowIndex = 49 To 49 + 55
       Range("Q" & colorRowIndex).Interior.ColorIndex = Range("P" & colorRowIndex).Value
    Next

End Sub

Sub InsertPicture()
    ActiveSheet.Pictures.Insert(Sheets("Bilderliste").Range("B8").Value).Select
    Selection.left = 100
    Selection.top = 200
    Selection.Width = 50
    Selection.Height = 50
    Selection.ShapeRange.IncrementRotation 52.4
End Sub

Sub Show_Wurf_SimulatorWindow()
   Wurf_Simulator.Show
End Sub

