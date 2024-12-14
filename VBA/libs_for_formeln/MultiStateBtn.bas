Attribute VB_Name = "MultiStateBtn"
Option Explicit

Function MultiStateBtn_Fct_1() As String
    Range("U7").Value = "Fct_1"
    MultiStateBtn_Fct_1 = ""
End Function

Function MultiStateBtn_Fct_2() As String
    Range("U7").Value = "Fct_2"
    MultiStateBtn_Fct_2 = ""
End Function

Function MultiStateBtn_Fct_3() As String
    Range("U7").Value = "Fct_3"
    MultiStateBtn_Fct_3 = ""
End Function

Function MultiStateBtn_Fct_4() As String
    Range("U7").Value = "Fct_4"
    MultiStateBtn_Fct_4 = ""
End Function

Function MultiStateBtn_Fct_5() As String
    Range("U7").Value = "Fct_5"
    MultiStateBtn_Fct_5 = ""
End Function

Sub Macro2()
Attribute Macro2.VB_ProcData.VB_Invoke_Func = " \n14"
    ' Range("T7").Value: currentState
    ' Range("S7").Value: count of states
    Dim retVal As String
    Range("T7").Value = Range("T7").Value + 1
    If (Range("T7").Value > Range("S7").Value) Then
         Range("T7").Value = 1
    End If
    ActiveSheet.Shapes.Range(Array("Rectangle 1")).TextFrame2.TextRange.Characters.Text = Range("S8").Offset(Range("T7").Value - 1, 0).Value & "   " & Range("T7").Value
    If (Range("T7").Value = 1) Then
        retVal = MultiStateBtn_Fct_1()
    ElseIf (Range("T7").Value = 1) Then
        retVal = MultiStateBtn_Fct_1()
    ElseIf (Range("T7").Value = 2) Then
        retVal = MultiStateBtn_Fct_2()
    ElseIf (Range("T7").Value = 3) Then
        retVal = MultiStateBtn_Fct_3()
    ElseIf (Range("T7").Value = 4) Then
        retVal = MultiStateBtn_Fct_4()
    ElseIf (Range("T7").Value = 5) Then
        retVal = MultiStateBtn_Fct_5()
    Else
        Range("U7").Value = "Error: MultiStateBtn Unknown State:" & Range("T7").Value
    End If
End Sub
