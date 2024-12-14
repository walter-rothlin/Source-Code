Attribute VB_Name = "Sodoku_Library_2015_11_05"
' Functions for Sudoku
' ====================

Sub clearFeld()
' Löscht alle 8 Felder um den Mittelpunkt und färbt die Zahl rot oder blau ein
' Selektiertes Feld: Mitte im kleinsten Quadrat
    For varCount_i = -1 To 1
       For varCount_k = -1 To 1
         If ((varCount_k <> 0) Or (varCount_i <> 0)) Then
            Selection.Offset(varCount_k, varCount_i).Value = ""
         End If
       Next
    Next
    Selection.Font.ColorIndex = Range("AF43").Value
    Selection.Interior.ColorIndex = Range("AG43").Value
End Sub

Sub clearRow()
' Löscht alle Felder in der Zeile. Selektiertes Feld: in der vordersten Spalte
    For varCount = 0 To 8
        If (Range("AF16").Value = 5) Then
           If (Selection.Offset(0, varCount * 3).Value = 5) Then
             Selection.Offset(0, varCount * 3).Value = ""
           End If
        Else
          Selection.Offset(0, varCount * 3).Value = ""
        End If
    Next
End Sub
Sub löscheColumn()
' Löscht alle Felder in der Spalte. Selektiertes Feld: in oberster Reihe
    For varCount = 0 To 8
        If (Range("AF16").Value = 5) Then
          If (Selection.Offset(varCount * 3, 0).Value = 5) Then
             Selection.Offset(varCount * 3, 0).Value = ""
          End If
        Else
          Selection.Offset(varCount * 3, 0).Value = ""
        End If
    Next
End Sub
Sub löscheQuadrat()
' Löscht alle Felder in einem Quadrat. Selektiertes Feld: oberstes linkes Feld
    For varCount_i = 0 To 2
       For varCount_k = 0 To 2
            If (Range("AF16").Value = 5) Then
              If (Selection.Offset(varCount_k * 3, varCount_i * 3).Value = 5) Then
                 Selection.Offset(varCount_k * 3, varCount_i * 3).Value = ""
              End If
            Else
              Selection.Offset(varCount_k * 3, varCount_i * 3).Value = ""
            End If
       Next
    Next

End Sub

Sub processOneEntryBtnPressed()
  Dim selAdr As String
  selAdr = whichCellSelected()
  Range("AE43").Value = Range("AE40").Value
  Call SetCellColorSudoku
  Call processOneEntry
  Range(selAdr).Select
  ActiveWindow.SmallScroll Down:=-30
End Sub

Sub processOneEntry()
' Verarbeitet eine Sudoku Eingabe

    ' Einagbe sicher
    Range("AF16").Value = Selection.Value
    Range("AF17").Value = ActiveCell.Address
    Range("AF18").Value = ActiveCell.column
    Range("AF19").Value = ActiveCell.row
    Range("AF20").Value = Selection.Font.ColorIndex
    
    
    ' Feld löschen
    Application.Run "clearFeld"
    
    ' Berechnen der Koordinaten für Zeilenlöschung
    ActiveCell.Offset(-1, -Range("AF18").Value + 1).Select
    
    If (Range("AF16").Value <= 3) Then
        ActiveCell.Offset(0, Range("AF16").Value - 1).Select
    ElseIf (Range("AF16").Value <= 6) Then
        ActiveCell.Offset(1, Range("AF16").Value - 4).Select
    ElseIf (Range("AF16").Value <= 9) Then
        ActiveCell.Offset(2, Range("AF16").Value - 7).Select
    End If
    
    ' Zeile löschen
    Application.Run "clearRow"
    
    ' Berechnen der Koordinaten für Spaltenlöschung
    Range(Range("AF17").Value).Select
    ActiveCell.Offset(-Range("AF19").Value + 1, -1).Select

    If (Range("AF16").Value <= 3) Then
        ActiveCell.Offset(0, Range("AF16").Value - 1).Select
    ElseIf (Range("AF16").Value <= 6) Then
        ActiveCell.Offset(1, Range("AF16").Value - 4).Select
    ElseIf (Range("AF16").Value <= 9) Then
        ActiveCell.Offset(2, Range("AF16").Value - 7).Select
    End If

    ' Spalte löschen
    Application.Run "löscheColumn"

    ' Berechnung der Koordinaten für Quadratlöschung
    If ((Range("AF18").Value <= 9) And (Range("AF19").Value <= 9)) Then
        Range("A1").Select
    ElseIf ((Range("AF18").Value <= 18) And (Range("AF19").Value <= 9)) Then
        Range("J1").Select
    ElseIf ((Range("AF18").Value <= 27) And (Range("AF19").Value <= 9)) Then
        Range("S1").Select
    ElseIf ((Range("AF18").Value <= 9) And (Range("AF19").Value <= 18)) Then
        Range("A10").Select
    ElseIf ((Range("AF18").Value <= 18) And (Range("AF19").Value <= 18)) Then
        Range("J10").Select
    ElseIf ((Range("AF18").Value <= 27) And (Range("AF19").Value <= 18)) Then
        Range("S10").Select
    ElseIf ((Range("AF18").Value <= 9) And (Range("AF19").Value <= 27)) Then
        Range("A19").Select
    ElseIf ((Range("AF18").Value <= 18) And (Range("AF19").Value <= 27)) Then
        Range("J19").Select
    ElseIf ((Range("AF18").Value <= 27) And (Range("AF19").Value <= 27)) Then
        Range("S19").Select
    End If

    If (Range("AF16").Value <= 3) Then
        ActiveCell.Offset(0, Range("AF16").Value - 1).Select
    ElseIf (Range("AF16").Value <= 6) Then
        ActiveCell.Offset(1, Range("AF16").Value - 4).Select
    ElseIf (Range("AF16").Value <= 9) Then
        ActiveCell.Offset(2, Range("AF16").Value - 7).Select
    End If

    ' Quadrat löschen
    Application.Run "löscheQuadrat"
    
    ' Eingegebener Wert nochmals setzen
    Range(Range("AF17").Value).Select
    ActiveCell.Value = Range("AF16").Value
    ActiveCell.Font.ColorIndex = Range("AF43").Value
    ActiveCell.Interior.ColorIndex = Range("AG43").Value
    
    ' Update Ausgangslage
    Dim lSpalte As Integer
    Dim lZeile As Integer
    lSpalte = Int(Range("AF18").Value / 3)
    lZeile = Int(Range("AF19").Value / 3)
    
    Dim adrKlein As String
    adrKlein = getCoordiKleinesSudokuFeld(lSpalte, lZeile, 6, 35)
    Range(adrKlein).Select
    ActiveCell.Value = Range("AF16").Value
    ActiveCell.Font.ColorIndex = Range("AF43").Value
    ActiveCell.Interior.ColorIndex = Range("AG43").Value
End Sub


' function to create a new game
' =============================
Sub createNewSudokuFormular()
    Dim colChar As String
    Dim colIndex As Integer
    Dim rowIndex As Integer
    
    For rowIndex = 2 To 26 Step 3
      For colIndex = 2 To 26 Step 3
        colChar = getColumnLetterFromColumnIndex(colIndex)
        resetOneField (colChar & rowIndex)
      Next
    Next
    
    Call SetCellColorSudoku
End Sub

Sub resetOneField(fieldAdr As String)
    ' Setzt alle Felder auf 1 2 3 ... zurück
    Dim foreGroundColor As Integer
    Dim backGroundColor As Integer
    
    foreGroundColor = Range("AF36").Value
    backGroundColor = Range("AG36").Value
    
    Range(fieldAdr).Offset(-1, -1).Value = "1"
    Range(fieldAdr).Offset(-1, -1).Font.ColorIndex = foreGroundColor
    Range(fieldAdr).Offset(-1, -1).Interior.ColorIndex = backGroundColor
   
    Range(fieldAdr).Offset(-1, 0).Value = "2"
    Range(fieldAdr).Offset(-1, 0).Font.ColorIndex = foreGroundColor
    Range(fieldAdr).Offset(-1, 0).Interior.ColorIndex = backGroundColor

    Range(fieldAdr).Offset(-1, 1).Value = "3"
    Range(fieldAdr).Offset(-1, 1).Font.ColorIndex = foreGroundColor
    Range(fieldAdr).Offset(-1, 1).Interior.ColorIndex = backGroundColor

    Range(fieldAdr).Offset(0, -1).Value = "4"
    Range(fieldAdr).Offset(0, -1).Font.ColorIndex = foreGroundColor
    Range(fieldAdr).Offset(0, -1).Interior.ColorIndex = backGroundColor

    Range(fieldAdr).Offset(0, 0).Value = "5"
    Range(fieldAdr).Offset(0, 0).Font.ColorIndex = foreGroundColor
    Range(fieldAdr).Offset(0, 0).Interior.ColorIndex = backGroundColor

    Range(fieldAdr).Offset(0, 1).Value = "6"
    Range(fieldAdr).Offset(0, 1).Font.ColorIndex = foreGroundColor
    Range(fieldAdr).Offset(0, 1).Interior.ColorIndex = backGroundColor

    Range(fieldAdr).Offset(1, -1).Value = "7"
    Range(fieldAdr).Offset(1, -1).Font.ColorIndex = foreGroundColor
    Range(fieldAdr).Offset(1, -1).Interior.ColorIndex = backGroundColor

    Range(fieldAdr).Offset(1, 0).Value = "8"
    Range(fieldAdr).Offset(1, 0).Font.ColorIndex = foreGroundColor
    Range(fieldAdr).Offset(1, 0).Interior.ColorIndex = backGroundColor

    Range(fieldAdr).Offset(1, 1).Value = "9"
    Range(fieldAdr).Offset(1, 1).Font.ColorIndex = foreGroundColor
    Range(fieldAdr).Offset(1, 1).Interior.ColorIndex = backGroundColor
End Sub


Sub SetCellColorSudoku()
    For colorRowIndex = 35 To 35 + 55
       Range("AJ" & colorRowIndex).Interior.ColorIndex = Range("AI" & colorRowIndex).Value
    Next
    For colorRowIndex = 36 To 36 + 5
       Range("AE" & colorRowIndex).Interior.ColorIndex = Range("AG" & colorRowIndex).Value
       Range("AE" & colorRowIndex).Font.ColorIndex = Range("AF" & colorRowIndex).Value
    Next
    
    Range("AE43").Interior.ColorIndex = Range("AG43").Value
    Range("AE43").Font.ColorIndex = Range("AF43").Value
End Sub

Function getCoordiGrossesSudokuFeld(x As Integer, y As Integer, xOffset As Integer, yOffset As Integer) As String
    getCoordiGrossesSudokuFeld = getColumnLetterFromColumnIndex((x * 3) + 2 + xOffset) & (y * 3) + 2 + yOffset
End Function

Function getCoordiKleinesSudokuFeld(x As Integer, y As Integer, xOffset As Integer, yOffset As Integer) As String
    getCoordiKleinesSudokuFeld = getColumnLetterFromColumnIndex(x + 1 + xOffset) & (y + 1 + yOffset)
End Function

Sub takeOverStartValue()
    Dim rowIndex As Integer
    Dim colIndex As Integer
    Dim adrKlein As String
    Dim adrGross As String
    
    Range("AE43").Value = Range("AE37").Value
    For rowIndex = 0 To 8
      For colIndex = 0 To 8
         adrKlein = getCoordiKleinesSudokuFeld(colIndex, rowIndex, 6, 35)
         If Range(adrKlein).Value <> "" Then
            Range(adrKlein).Font.ColorIndex = Range("AF43").Value
            Range(adrKlein).Interior.ColorIndex = Range("AG43").Value
            adrGross = getCoordiGrossesSudokuFeld(colIndex, rowIndex, 0, 0)
            Range(adrGross).Select
            ActiveCell.Value = Range(adrKlein).Value
            processOneEntry
         End If
      Next
    Next
    
    Call SetCellColorSudoku
End Sub

Sub deleteSudokuStartValue()
    Dim rowIndex As Integer
    Dim colIndex As Integer
    Dim adrKlein As String

    For rowIndex = 0 To 8
      For colIndex = 0 To 8
         adrKlein = getCoordiKleinesSudokuFeld(colIndex, rowIndex, 6, 35)
         Range(adrKlein).Value = ""
         Range(adrKlein).Font.ColorIndex = Range("AF36").Value
         Range(adrKlein).Interior.ColorIndex = Range("AG36").Value
      Next
    Next
    
    Call SetCellColorSudoku
End Sub

Sub deleteSudokuResultValues()
    Dim rowIndex As Integer
    Dim colIndex As Integer
    Dim adrKlein As String

    For rowIndex = 0 To 8
      For colIndex = 0 To 8
         adrKlein = getCoordiKleinesSudokuFeld(colIndex, rowIndex, 6, 35)
         If ((Range(adrKlein).Font.ColorIndex = Range("AF38").Value) And _
             (Range(adrKlein).Font.ColorIndex = Range("AF38").Value)) Then
           Range(adrKlein).Value = ""
           Range(adrKlein).Font.ColorIndex = Range("AF36").Value
           Range(adrKlein).Interior.ColorIndex = Range("AG36").Value
         End If
      Next
    Next
    
    Call SetCellColorSudoku
End Sub

Function getRemainingSudokuValues(centreAdr As String) As String
    Dim remainValues As String
    Dim valueCount As Integer
    Dim rowIndex As Integer
    Dim colIndex As Integer
     
    valueCount = 0
    For rowIndex = -1 To 1
      For colIndex = -1 To 1
        If Range(centreAdr).Offset(rowIndex, colIndex).Value <> "" Then
            valueCount = valueCount + 1
            remainValues = remainValues & Range(centreAdr).Offset(rowIndex, colIndex).Value
        End If
      Next
    Next
    getRemainingSudokuValues = remainValues
End Function

Function getRemainingSudokuValuesAsArray(centreAdr As String) As Variant
    getRemainingSudokuValuesAsArray = splitStringByChar(getRemainingSudokuValues(centreAdr))
End Function

Function getFiguresInRow(adrToExc As String) As Variant
   Dim retValFinal() As Variant
   Dim retVal1()      As Variant
   retValFinal = Array()
   
   Dim currentRow As Integer
   Dim currentColumn As Integer
   Dim colIndex As Integer
   Dim adrIndex As String
   
   currentRow = GetRowIndexFromAdr(adrToExc)
   currentColumn = GetColumnIndexFromColumnLetter(getColumnLetterFromAdr(adrToExc))
   For colIndex = 2 To 26 Step 3
         If (colIndex <> currentColumn) Then
            adrIndex = GetCellAddr(currentRow, colIndex)
            retVal1 = getRemainingSudokuValuesAsArray(adrIndex)
            retValFinal = getUnionOfArrays(retVal1, retValFinal)
         End If
   Next
   getFiguresInRow = retValFinal
End Function

Function getFiguresInColumn(adrToExc As String) As Variant
   Dim retValFinal() As Variant
   Dim retVal1()      As Variant
   retValFinal = Array()
   
   Dim currentRow As Integer
   Dim currentColumn As Integer
   Dim rowIndex As Integer
   Dim adrIndex As String
   
   currentRow = GetRowIndexFromAdr(adrToExc)
   currentColumn = GetColumnIndexFromColumnLetter(getColumnLetterFromAdr(adrToExc))
   For rowIndex = 2 To 26 Step 3
         If (rowIndex <> currentRow) Then
            adrIndex = GetCellAddr(rowIndex, currentColumn)
            retVal1 = getRemainingSudokuValuesAsArray(adrIndex)
            retValFinal = getUnionOfArrays(retVal1, retValFinal)
         End If
   Next
   getFiguresInColumn = retValFinal
End Function

Function getFiguresInSqaure(adrToExc As String) As Variant
   Dim retValFinal() As Variant
   Dim retVal1()      As Variant
   retValFinal = Array()
   
   Dim currentRow As Integer
   Dim currentColumn As Integer
   Dim rowIndex As Integer
   Dim colIndex As Integer
   Dim adrIndex As String
   
   currentRow = GetRowIndexFromAdr(adrToExc)
   currentColumn = GetColumnIndexFromColumnLetter(getColumnLetterFromAdr(adrToExc))
   
   ' search center square
   Dim centerRow As Integer
   Dim centerColumn As Integer
   centerRow = getCenterCoordi(currentRow)
   centerColumn = getCenterCoordi(currentColumn)
   
   
   For rowIndex = centerRow - 3 To centerRow + 3 Step 3
      For colIndex = centerColumn - 3 To centerColumn + 3 Step 3
         If ((rowIndex <> currentRow) Or (colIndex <> currentColumn)) Then
            adrIndex = GetCellAddr(rowIndex, colIndex)
            retVal1 = getRemainingSudokuValuesAsArray(adrIndex)
            retValFinal = getUnionOfArrays(retVal1, retValFinal)
         End If
      Next
   Next
   getFiguresInSqaure = retValFinal
End Function

Function getCenterCoordi(rowOrCol As Integer) As Integer
    Dim retVal As Integer
    If (rowOrCol <= 9) Then
       retVal = 5
    ElseIf (rowOrCol <= 18) Then
       retVal = 14
    ElseIf (rowOrCol <= 27) Then
       retVal = 23
    Else
       retVal = 0
    End If
    getCenterCoordi = retVal
End Function

Sub sudokuWeiterspielen()
    Dim reVal As String
    Dim rowIndex As Integer
    Dim colIndex As Integer
    Dim adrKlein As String
    Dim adrGross As String
      
    Range("AE43").Value = Range("AE38").Value
    For rowIndex = 0 To 8
      For colIndex = 0 To 8
         adrKlein = getCoordiKleinesSudokuFeld(colIndex, rowIndex, 6, 35)
         adrGross = getCoordiGrossesSudokuFeld(colIndex, rowIndex, 0, 0)
         reVal = getRemainingSudokuValues(adrGross)
         If (Len(reVal) = 1) And (Range(adrKlein).Value = "") Then
            Range(adrKlein).Value = reVal
            Range(adrKlein).Font.ColorIndex = Range("AF43").Value
            Range(adrKlein).Interior.ColorIndex = Range("AG43").Value
            Range(adrGross).Select
            ActiveCell.Value = Range(adrKlein).Value
            processOneEntry
         End If
      Next
    Next
    
    Call SetCellColorSudoku
End Sub

Sub sudokuWeiterspielenStrategie_2()
    Dim remainingCallValues() As Variant
    Dim posValues() As Variant
    Dim availableValues() As Variant
    Dim centerFieldAdr As String
    Dim rowIndex As Integer
    Dim colIndex As Integer
    
    For rowIndex = 0 To 8
      For colIndex = 0 To 8
        centerFieldAdr = getCoordiGrossesSudokuFeld(colIndex, rowIndex, 0, 0)
        remainingCallValues = getRemainingSudokuValuesAsArray(centerFieldAdr)
        If (arraySize(remainingCallValues) > 1) Then
            ' Check in row
            availableValues = getFiguresInRow(centerFieldAdr)
            ' displayArray (remainingCallValues)
            ' Debug.Print ""
            ' displayArray (availableValues)
            ' Debug.Print ""
            
            posValues = getExclutionOfArrays(remainingCallValues, availableValues)
            
            If (arraySize(posValues) = 1) Then
               Debug.Print "Found in Row: " & centerFieldAdr & "  " & posValues(0)
               Range(centerFieldAdr).Value = posValues(0)
               Range(centerFieldAdr).Select
               Range("AE43").Value = Range("AE39").Value
               
               processOneEntry
               ' displayArray (posValues)
            End If

            ' Check in column
            availableValues = getFiguresInColumn(centerFieldAdr)
            posValues = getExclutionOfArrays(remainingCallValues, availableValues)

            If (arraySize(posValues) = 1) Then
               Debug.Print "Found in Column: " & centerFieldAdr & "  " & posValues(0)
               Range(centerFieldAdr).Value = posValues(0)
               Range(centerFieldAdr).Select
               Range("AE43").Value = Range("AE39").Value
               
               processOneEntry
               ' displayArray (posValues)
            End If

            ' Check in square
            availableValues = getFiguresInSqaure(centerFieldAdr)
            posValues = getExclutionOfArrays(remainingCallValues, availableValues)

            If (arraySize(posValues) = 1) Then
               Debug.Print "Found in Square: " & centerFieldAdr & "  " & posValues(0)
               Range(centerFieldAdr).Value = posValues(0)
               Range(centerFieldAdr).Select
               Range("AE43").Value = Range("AE39").Value
               
               processOneEntry
               ' displayArray (posValues)
            End If

        End If
      Next
    Next
    
    Call SetCellColorSudoku
End Sub

Sub takeExample_1()
    Range("C49:K57").Select
    Selection.Copy
    Range("G36").Select
    ActiveSheet.Paste
    Range("V44").Select
End Sub

Sub takeExample_2()
    Range("C61:K69").Select
    Selection.Copy
    Range("G36").Select
    ActiveSheet.Paste
    Range("V44").Select
End Sub

Sub takeExample_3()
    Range("C73:K81").Select
    Selection.Copy
    Range("G36").Select
    ActiveSheet.Paste
    Range("V44").Select
End Sub
