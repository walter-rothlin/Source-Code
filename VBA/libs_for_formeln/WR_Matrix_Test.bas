Attribute VB_Name = "WR_Matrix_Test"
Sub Matrix_TestCases_Convert()

Dim tmp As String
Dim wbName As String

wbName = Sheets("TableOfContent").Range("B3").Value   ' getActivatedWorkbook()
tmp = MatrixToTable("", wbName, "MATRIX_TestCase_Source", Range("AB6").Value, _
                    "", wbName, "MATRIX_TestCase_Dest", "F5", Range("AB4").Value)
Debug.Print ("Last Cell: " & tmp)
End Sub

