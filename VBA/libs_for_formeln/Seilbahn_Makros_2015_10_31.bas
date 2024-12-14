Attribute VB_Name = "Seilbahn_Makros_2015_10_31"
Dim SeilbahnRecord As Boolean
Dim SeilbahnRecordLine As Integer

Public Sub Seilbahn_Talwärts()
    If (Sheets("Mechanik_Seilbahn").Range("C9").Value > Sheets("Mechanik_Seilbahn").Range("B39").Value) Then
        Sheets("Mechanik_Seilbahn").Range("C9").Value = Sheets("Mechanik_Seilbahn").Range("C9").Value - Sheets("Mechanik_Seilbahn").Range("B39").Value
    End If
End Sub

Public Sub Seilbahn_Bergwärts()
    Dim retVal As Boolean
    If (Sheets("Mechanik_Seilbahn").Range("C9").Value < Sheets("Mechanik_Seilbahn").Range("C11").Value - (2 * Sheets("Mechanik_Seilbahn").Range("B39").Value)) Then
        Sheets("Mechanik_Seilbahn").Range("C9").Value = Sheets("Mechanik_Seilbahn").Range("C9").Value + Sheets("Mechanik_Seilbahn").Range("B39").Value
        retValue = StoreValuePair()
    End If
End Sub

Public Sub Seilbahn_ZurBergstation()
    Sheets("Mechanik_Seilbahn").Range("C9").Value = Sheets("Mechanik_Seilbahn").Range("C11").Value - Sheets("Mechanik_Seilbahn").Range("B39").Value
End Sub

Public Sub Seilbahn_ZurTalstation()
    Sheets("Mechanik_Seilbahn").Range("C9").Value = Sheets("Mechanik_Seilbahn").Range("B39").Value
End Sub

Public Sub Seilbahn_ZurMitte()
    Sheets("Mechanik_Seilbahn").Range("C9").Value = Sheets("Mechanik_Seilbahn").Range("C11").Value / 2
End Sub

Public Sub Seilbahn_Record()
    SeilbahnRecord = True
    SeilbahnRecordLine = 42
    Call Seilbahn_ZurTalstation
    Sheets("Mechanik_Seilbahn").Range("A42:C245").ClearContents
    For i = 1 To 50
        Call Seilbahn_Bergwärts
        Application.ScreenUpdating = True
    Next i
    SeilbahnRecord = False
End Sub

Private Function StoreValuePair() As Boolean
    If (SeilbahnRecord = True) Then
        Sheets("Mechanik_Seilbahn").Range("A" & SeilbahnRecordLine).Value = Sheets("Mechanik_Seilbahn").Range("C9").Value
        Sheets("Mechanik_Seilbahn").Range("B" & SeilbahnRecordLine).Value = Sheets("Mechanik_Seilbahn").Range("G14").Value
        Sheets("Mechanik_Seilbahn").Range("C" & SeilbahnRecordLine).Value = Sheets("Mechanik_Seilbahn").Range("G15").Value
        SeilbahnRecordLine = SeilbahnRecordLine + 1
    End If
    StoreValuePair = True
End Function

Public Sub VecAdd_Reset()
    Dim retVal As Boolean
    Sheets("Mechanik_ResKraft").Range("H58").Value = 100
    Sheets("Mechanik_ResKraft").Range("H59").Value = 0
    Sheets("Mechanik_ResKraft").Range("H60").Value = 0
    Sheets("Mechanik_ResKraft").Range("H61").Value = 0
    
    Sheets("Mechanik_ResKraft").Range("H64").Value = 0
End Sub

Public Sub VecAdd_Move()
    Dim retVal As Boolean
    If (Sheets("Mechanik_ResKraft").Range("H58").Value < 100) Then
        Sheets("Mechanik_ResKraft").Range("H58").Value = Sheets("Mechanik_ResKraft").Range("H58").Value + Sheets("Mechanik_ResKraft").Range("D59").Value
        If (Sheets("Mechanik_ResKraft").Range("H58").Value > 100) Then
            Sheets("Mechanik_ResKraft").Range("H58").Value = 100
        End If
    ElseIf (Sheets("Mechanik_ResKraft").Range("H59").Value < 100) Then
        Sheets("Mechanik_ResKraft").Range("H59").Value = Sheets("Mechanik_ResKraft").Range("H59").Value + Sheets("Mechanik_ResKraft").Range("D59").Value
        If (Sheets("Mechanik_ResKraft").Range("H59").Value > 100) Then
            Sheets("Mechanik_ResKraft").Range("H59").Value = 100
        End If
    ElseIf (Sheets("Mechanik_ResKraft").Range("H60").Value < 100) Then
        Sheets("Mechanik_ResKraft").Range("H60").Value = Sheets("Mechanik_ResKraft").Range("H60").Value + Sheets("Mechanik_ResKraft").Range("D59").Value
        If (Sheets("Mechanik_ResKraft").Range("H60").Value > 100) Then
            Sheets("Mechanik_ResKraft").Range("H60").Value = 100
        End If
    ElseIf (Sheets("Mechanik_ResKraft").Range("H61").Value < 100) Then
        Sheets("Mechanik_ResKraft").Range("H61").Value = Sheets("Mechanik_ResKraft").Range("H61").Value + Sheets("Mechanik_ResKraft").Range("D59").Value
        If (Sheets("Mechanik_ResKraft").Range("H61").Value > 100) Then
            Sheets("Mechanik_ResKraft").Range("H61").Value = 100
        End If
    ElseIf (Sheets("Mechanik_ResKraft").Range("H64").Value < 100) Then
        Sheets("Mechanik_ResKraft").Range("H64").Value = Sheets("Mechanik_ResKraft").Range("H64").Value + Sheets("Mechanik_ResKraft").Range("D59").Value
        If (Sheets("Mechanik_ResKraft").Range("H64").Value > 100) Then
            Sheets("Mechanik_ResKraft").Range("H64").Value = 100
        End If
    End If
End Sub


Public Sub VecAdd_Play()
    Call VecAdd_Reset
    
    For i = 0 To ((4 * 100) / Sheets("Mechanik_ResKraft").Range("D59").Value)
        Call VecAdd_Move
        Application.ScreenUpdating = True
    Next i
End Sub
