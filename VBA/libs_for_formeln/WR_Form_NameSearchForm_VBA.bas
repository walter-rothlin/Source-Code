Attribute VB_Name = "WR_Form_NameSearchForm_VBA"
Private Const shNameOfListen As String = "SearchEntry"

Sub SearchForm_anlass()
Attribute SearchForm_anlass.VB_ProcData.VB_Invoke_Func = "h\n14"
    ' Tastenkombination: Strg+h
    Dim testBol As Boolean
    testBol = NameSearchForm.setSearchFormValues(6, 8, False, shNameOfListen)
    Dim resCount As Integer
    resCount = NameSearchForm.searchStr(NameSearchForm.SearchTextBox.Text)
    NameSearchForm.Show
End Sub

Sub SearchForm_disziplin()
Attribute SearchForm_disziplin.VB_ProcData.VB_Invoke_Func = "d\n14"
    ' Tastenkombination: Strg+d
    Dim testBol As Boolean
    testBol = NameSearchForm.setSearchFormValues(14, 3, True, shNameOfListen)
    Dim resCount As Integer
    resCount = NameSearchForm.searchStr(NameSearchForm.SearchTextBox.Text)
    NameSearchForm.Show
End Sub

Sub SearchForm_name()
Attribute SearchForm_name.VB_ProcData.VB_Invoke_Func = "n\n14"
    ' Tastenkombination: Strg+n
    Dim testBol As Boolean
    testBol = NameSearchForm.setSearchFormValues(6, 1, True, shNameOfListen)
    Dim resCount As Integer
    resCount = NameSearchForm.searchStr(NameSearchForm.SearchTextBox.Text)
    NameSearchForm.Show
End Sub
