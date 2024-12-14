Attribute VB_Name = "WR_Form_EntryForm_VBA"
Sub InputViaEntryForm()
Attribute InputViaEntryForm.VB_ProcData.VB_Invoke_Func = "i\n14"
    ' Tastenkombination: Strg+i
    
    Dim sheetNameStr As String
    Dim aCell As String
    sheetNameStr = whichSheetSelected
    aCell = whichCellSelected()
    
    WR_EntryForm.Caption = "Hallo"
    WR_EntryForm.tb_entryStr.Value = Sheets(sheetNameStr).Range(aCell).Value
    WR_EntryForm.Show
End Sub
