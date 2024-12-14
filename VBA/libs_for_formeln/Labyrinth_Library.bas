Attribute VB_Name = "Labyrinth_Library"
' Functions for Labyrinth
' =======================

Sub DrawEmptyLabyrinth()
    ' altes löschen
    Range("A1:AD69").Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    Selection.Borders(xlEdgeLeft).LineStyle = xlNone
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    Selection.Borders(xlEdgeRight).LineStyle = xlNone
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    Columns("A:AD").ColumnWidth = 1.2
    Rows("1:69").RowHeight = 12
    ' Neues zeichnen
    Range(Range("AI6").Value & ":" & Range("AI8").Value).Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Weight = xlMedium
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeTop)
        .LineStyle = xlContinuous
        .Weight = xlMedium
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlMedium
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Weight = xlMedium
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlInsideVertical)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    With Selection.Borders(xlInsideHorizontal)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
End Sub

Sub clearLabPath()
  Dim rowIndex As Integer
  Dim colIndex As Integer
  Dim fieldAdr As String
  For rowIndex = Range("AG7").Value To Range("AG7").Value + Range("AG9").Value - 1
    For colIndex = Range("AG6").Value To Range("AG6").Value + Range("AG8").Value - 1
        fieldAdr = GetCellAddr(rowIndex, colIndex)
        If ((Range(fieldAdr).Value = Range("AF20").Value) Or _
            (Range(fieldAdr).Value = Range("AF21").Value) Or _
            (Range(fieldAdr).Value = Range("AF23").Value) Or _
            (Range(fieldAdr).Value = Range("AF24").Value)) Then
          Range(fieldAdr).Value = ""
        End If
        If (Range(fieldAdr).Value = Range("AF19").Value) Then
           Range(fieldAdr).Interior.ColorIndex = Range("AH19").Value
           Range(fieldAdr).Font.ColorIndex = Range("AG19").Value
        Else
          Range(fieldAdr).Interior.ColorIndex = Range("AH22").Value
          Range(fieldAdr).Font.ColorIndex = Range("AG22").Value
        End If
    Next colIndex
  Next rowIndex
End Sub

Sub findPath()
   Range("AH13").Value = False
   Call findNextStep(Range("AF12").Value, Range("AF13").Value)
End Sub

Sub findNextStep(currentPoint As String, endPoint As String)
   Range(currentPoint).Value = Range("AF20").Value
   Range(currentPoint).Interior.ColorIndex = Range("AH20").Value
   Range(currentPoint).Font.ColorIndex = Range("AG20").Value

   If (currentPoint = endPoint) Then
      Range(currentPoint).Value = Range("AF24").Value
      Range(currentPoint).Interior.ColorIndex = Range("AH24").Value
      Range(currentPoint).Font.ColorIndex = Range("AG24").Value
   End If
   
   If (currentPoint = Range("AF12").Value) Then
      Range(currentPoint).Value = Range("AF23").Value
      Range(currentPoint).Interior.ColorIndex = Range("AH23").Value
      Range(currentPoint).Font.ColorIndex = Range("AG23").Value
   End If

   If (currentPoint <> endPoint) Then
       Dim currentRow As Integer
       Dim currentCol As Integer
       
       currentRow = GetRowIndexFromAdr(currentPoint)
       currentCol = GetColumnIndexFromColumnLetter(getColumnLetterFromAdr(currentPoint))
       ' check north
       If ((Range("AH13").Value = False) And (isMoveToOk(currentRow - 1, currentCol))) Then
           'Debug.Print "Try North"
           Call findNextStep(GetCellAddr(currentRow - 1, currentCol), endPoint)
       End If
       ' check south
       If ((Range("AH13").Value = False) And (isMoveToOk(currentRow + 1, currentCol))) Then
           'Debug.Print "Try South"
           Call findNextStep(GetCellAddr(currentRow + 1, currentCol), endPoint)
       End If
       ' check east
       If ((Range("AH13").Value = False) And (isMoveToOk(currentRow, currentCol + 1))) Then
           'Debug.Print "Try South"
           Call findNextStep(GetCellAddr(currentRow, currentCol + 1), endPoint)
       End If
       ' check west
       If ((Range("AH13").Value = False) And (isMoveToOk(currentRow, currentCol - 1))) Then
           'Debug.Print "Try South"
           Call findNextStep(GetCellAddr(currentRow, currentCol - 1), endPoint)
       End If
   Else
       Range("AH13").Value = True
       'Debug.Print "Ziel gefunden"
   End If
   
   If Range("AH13").Value = False Then
      Range(currentPoint).Value = Range("AF21").Value
      Range(currentPoint).Interior.ColorIndex = Range("AH21").Value
      Range(currentPoint).Font.ColorIndex = Range("AG21").Value
   End If
End Sub

Function isMoveToOk(aRow As Integer, aCol As Integer) As Boolean
      If (((aRow >= Range("AG7").Value) And (aRow <= Range("AG7").Value + Range("AG9").Value - 1)) And _
          ((aCol >= Range("AG6").Value) And (aCol <= Range("AG6").Value + Range("AG8").Value - 1))) Then
          Dim fieldAdr As String
          fieldAdr = GetCellAddr(aRow, aCol)
          If (Range(fieldAdr).Value = "") Then
             isMoveToOk = True
          Else
             isMoveToOk = False
          End If
      Else
        isMoveToOk = False
      End If
End Function

Sub SetCellColorLabyrinth()
    For colorRowIndex = 16 To 35 + 55
       Range("AK" & colorRowIndex).Interior.ColorIndex = Range("AJ" & colorRowIndex).Value
    Next
    For colorRowIndex = 19 To 19 + 6
       Range("AF" & colorRowIndex).Interior.ColorIndex = Range("AH" & colorRowIndex).Value
       Range("AF" & colorRowIndex).Font.ColorIndex = Range("AG" & colorRowIndex).Value
    Next
End Sub

