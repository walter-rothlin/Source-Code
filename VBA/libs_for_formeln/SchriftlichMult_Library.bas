Attribute VB_Name = "SchriftlichMult_Library"
Sub multipliziereSchriftlich()
   Call ClearAll
   Call splitFactors
   Dim rowCounter As Integer
   rowCounter = 1
   
   Do While rowCounter <= Range("A4").Value
      Call multiOneFactor(rowCounter)
      rowCounter = rowCounter + 1
   Loop
   
   ' summe berechnen
   Dim columnCount
   columnCount = Range("E4").Value
   
   Do While columnCount > 0
      Range("F7").Offset(rowCounter, columnCount).Select
      ActiveCell.FormulaR1C1 = "=SUM(R[-" & rowCounter - 1 & "]C:R[-1]C)"
      columnCount = columnCount - 1
   Loop
   
   columnCount = Range("E4").Value
   Dim behalte
   behalte = 0
   Do While columnCount > 0
      summe = Range("F7").Offset(rowCounter, columnCount).Value + behalte
      If (Len(summe) > 1) Then
           behalte = left(summe, 1)
           summe = right(summe, 1)
      Else
           behalte = 0
      End If
      Range("F7").Offset(rowCounter + 1, columnCount).Value = summe
      
      columnCount = columnCount - 1
   Loop
   
   Call format
End Sub

Sub splitFactors()
   Dim destColOffset
   destColOffset = 0
   
   '
   Call splitZahl("A3", "F7", destColOffset)
   
   destColOffset = destColOffset + Len(Range("A3").Value)
   Range("F7").Offset(0, destColOffset).Value = "*"
   destColOffset = destColOffset + 1
   
   Call splitZahl("C3", "F7", destColOffset)
   
End Sub

Sub splitZahl(zahlPos As String, destStartPos As String, ByVal destColOffset As Integer)
    Dim inputFig
    inputFig = Range(zahlPos).Value

    Dim figLen
    figLen = Len(inputFig)
    Dim colOffset
    colOffset = 0
    
    
    For colOffset = 0 To figLen - 1
       Range(destStartPos).Offset(0, colOffset + destColOffset).Value = Mid(inputFig, colOffset + 1, 1)
    Next
    
End Sub


Sub multiOneFactor(zeilCount As Integer)
   Dim factorA
   factorA = Range("F7").Offset(0, Range("A4").Value - zeilCount).Value
   
   Dim factorBPos
   factorBPos = Range("E4").Value
   
   Dim behalte
   behalte = 0
   
   Do While Range("F7").Offset(0, factorBPos).Value <> "*"
      Dim produkt
      produkt = (Range("F7").Offset(0, factorBPos).Value * factorA) + behalte
      If (Len(produkt) > 1) Then
           behalte = left(produkt, 1)
           produkt = right(produkt, 1)
      Else
           behalte = 0
      End If
      Range("F7").Offset(zeilCount, factorBPos - zeilCount + 1).Value = produkt
      factorBPos = factorBPos - 1
   Loop
   If (behalte <> 0) Then
      Range("F7").Offset(zeilCount, factorBPos - zeilCount + 1).Value = behalte
   End If
End Sub

Sub ClearAll()
    Rows("7:80").Select
    Selection.EntireRow.Hidden = False

    Rows("7:80").Select
    Selection.ClearContents
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    Selection.Borders(xlEdgeLeft).LineStyle = xlNone
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    Selection.Borders(xlEdgeRight).LineStyle = xlNone
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
End Sub

Sub format()
    Range("F7:V7").Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    Selection.Borders(xlEdgeLeft).LineStyle = xlNone
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    Selection.Borders(xlEdgeRight).LineStyle = xlNone
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    
    Dim letzteZeile
    letzteZeile = Range("A4").Value + 7
    Range("F" & letzteZeile & ":V" & letzteZeile).Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    Selection.Borders(xlEdgeLeft).LineStyle = xlNone
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .Weight = xlThin
        .ColorIndex = xlAutomatic
    End With
    Selection.Borders(xlEdgeRight).LineStyle = xlNone
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Rows(letzteZeile + 1 & ":" & letzteZeile + 1).Select
    Selection.EntireRow.Hidden = True
    Range("F" & letzteZeile + 2 & ":V" & letzteZeile + 2).Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    Selection.Borders(xlEdgeLeft).LineStyle = xlNone
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlDouble
        .Weight = xlThick
        .ColorIndex = xlAutomatic
    End With
    Selection.Borders(xlEdgeRight).LineStyle = xlNone
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    
    ' Delete leading zeros
    letzteZeile = Range("A4").Value
    Dim colCount
    colCount = 0
    Dim fertig As Boolean
    continue = True
    
    Do While continue
      If (Range("F7").Offset(letzteZeile + 2, colCount).Value > 0) Then
         continue = False
      Else
         Range("F7").Offset(letzteZeile + 2, colCount).Value = ""
      End If
      colCount = colCount + 1
    Loop
End Sub


