Attribute VB_Name = "Picasso_2014_05_26"
' Picassofunctions
' ================

Public Const PicassoStunden_DayHopX As Integer = 48

Sub Picasso_Sort()
    Range("A12:C15").Select
    ActiveWorkbook.Worksheets("Picasso").Sort.SortFields.Clear
    ActiveWorkbook.Worksheets("Picasso").Sort.SortFields.Add Key:=Range("B13:B15" _
        ), SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:=xlSortNormal
    With ActiveWorkbook.Worksheets("Picasso").Sort
        .SetRange Range("A12:C15")
        .header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
End Sub

Sub formatPicasso_Stunden()
    Dim countOfDays As Integer
    countOfDays = 9
    
    Dim aDayTopLeftCallAdr As String
    aDayTopLeftCallAdr = Worksheets("Picasso_Stunden").Range("A8").Value
    Application.ScreenUpdating = False
    For i = 1 To countOfDays
        Call addGitterToOneDay(aDayTopLeftCallAdr, Worksheets("Picasso_Stunden").Range("B8").Value - 1)
        aDayTopLeftCallAdr = getAdrByAddingOffset(aDayTopLeftCallAdr, PicassoStunden_DayHopX, 0)
    Next i
    Application.ScreenUpdating = True
End Sub

Sub addGitterToOneDay(ByVal topLeftCellAdr As String, ByVal lastRow As Integer)
    Dim tmp As Boolean
    Dim bottomRightCellAdr As String
    Dim rowOffset As Integer
    rowOffset = lastRow - GetRowIndexFromAdr(topLeftCellAdr)
    bottomRightCellAdr = getAdrByAddingOffset(topLeftCellAdr, PicassoStunden_DayHopX - 1, rowOffset)
    tmp = addGitterToRange(topLeftCellAdr, bottomRightCellAdr, 2, 1)
End Sub

