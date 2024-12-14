Attribute VB_Name = "WR_FourierAnalyseForm"
Private Const shNameFourierAnalyse As String = "Fourier-Analyse"

Sub showFourierAnalyseForm()
    Dim sheetNameStr As String
    Dim aCell As String
    sheetNameStr = whichSheetSelected
    aCell = whichCellSelected()
    
    Sheets(shNameFourierAnalyse).Columns("V:V").EntireColumn.Hidden = Not Sheets(shNameFourierAnalyse).Range("I15").Value
    Sheets(shNameFourierAnalyse).Columns("W:W").EntireColumn.Hidden = Not Sheets(shNameFourierAnalyse).Range("I16").Value
    Sheets(shNameFourierAnalyse).Columns("X:X").EntireColumn.Hidden = Not Sheets(shNameFourierAnalyse).Range("I17").Value
    Sheets(shNameFourierAnalyse).Columns("Y:Y").EntireColumn.Hidden = Not Sheets(shNameFourierAnalyse).Range("I18").Value
    Sheets(shNameFourierAnalyse).Columns("Z:Z").EntireColumn.Hidden = Not Sheets(shNameFourierAnalyse).Range("I19").Value
    Sheets(shNameFourierAnalyse).Columns("AA:AA").EntireColumn.Hidden = Not Sheets(shNameFourierAnalyse).Range("I20").Value
    Sheets(shNameFourierAnalyse).Columns("AB:AB").EntireColumn.Hidden = Not Sheets(shNameFourierAnalyse).Range("I21").Value
    Sheets(shNameFourierAnalyse).Columns("AD:AD").EntireColumn.Hidden = Not Sheets(shNameFourierAnalyse).Range("I22").Value

    WR_fourierForm.currVal.Value = Sheets(sheetNameStr).Range(aCell).Value
    WR_fourierForm.Show
End Sub

Sub setParamForSaegezahn()
    Sheets(shNameFourierAnalyse).Range("C103:G109").Select
    Selection.Copy
    Sheets(shNameFourierAnalyse).Range("C15").Select
    ActiveSheet.Paste
    Sheets(shNameFourierAnalyse).Range("A1").Select
End Sub

Sub setParamForRechteck()
    Sheets(shNameFourierAnalyse).Range("C116:G122").Select
    Selection.Copy
    Sheets(shNameFourierAnalyse).Range("C15").Select
    ActiveSheet.Paste
    Sheets(shNameFourierAnalyse).Range("A1").Select
End Sub

Sub setParamForDreieck()
    Sheets(shNameFourierAnalyse).Range("C129:G135").Select
    Selection.Copy
    Sheets(shNameFourierAnalyse).Range("C15").Select
    ActiveSheet.Paste
    Sheets(shNameFourierAnalyse).Range("A1").Select
End Sub


Sub fourRestoreParam()
    Sheets(shNameFourierAnalyse).Range("C142:G148").Select
    Selection.Copy
    Sheets(shNameFourierAnalyse).Range("C15").Select
    ActiveSheet.Paste
    Sheets(shNameFourierAnalyse).Range("A1").Select
End Sub


Sub fourSaveParam()
    Sheets(shNameFourierAnalyse).Range("C15:G21").Select
    Selection.Copy
    Sheets(shNameFourierAnalyse).Range("C142").Select
    ActiveSheet.Paste
    Sheets(shNameFourierAnalyse).Range("A1").Select
End Sub
