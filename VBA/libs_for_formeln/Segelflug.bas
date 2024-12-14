Attribute VB_Name = "Segelflug"
Sub SF_SetNormDruck()
Attribute SF_SetNormDruck.VB_ProcData.VB_Invoke_Func = " \n14"
    Range("D68").Value = "1013.25"
End Sub

Sub SF_IncNormDruck()
    If (Range("D68").Value = "1013.25") Then
       Range("D68").Value = "1014"
    Else
       Range("D68").Value = Range("D68").Value + 1
    End If
End Sub


Sub SF_DecNormDruck()
    If (Range("D68").Value = "1013.25") Then
       Range("D68").Value = "1013"
    Else
       Range("D68").Value = Range("D68").Value - 1
    End If
End Sub
