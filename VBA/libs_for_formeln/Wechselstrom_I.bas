Attribute VB_Name = "Wechselstrom_I"
Sub loadSzene_1_Wechselstrom()
Attribute loadSzene_1_Wechselstrom.VB_ProcData.VB_Invoke_Func = " \n14"
    loadSzenenValues ("G")
    
    ' Range("N5").Select

End Sub

Sub loadSzene_2_Wechselstrom()
    loadSzenenValues ("H")
End Sub

Sub loadSzene_3_Wechselstrom()
    loadSzenenValues ("I")
End Sub

Sub loadSzene_4_Wechselstrom()
    loadSzenenValues ("J")
End Sub

Public Function loadSzenenValues(ByVal szene As String)
    Range("D5").Value = Range(szene & "42").Value

    ' Sinus
    Range("J5").Value = Range(szene & "43").Value
    Range("K5").Value = Range(szene & "44").Value
    Range("L5").Value = Range(szene & "45").Value
    Range("M5").Value = Range(szene & "46").Value
    Range("N5").Value = Range(szene & "47").Value
    Range("BX13").Value = Range(szene & "48").Value
    
    ' Sinus_2
    Range("J6").Value = Range(szene & "49").Value
    Range("K6").Value = Range(szene & "50").Value
    Range("L6").Value = Range(szene & "51").Value
    Range("M6").Value = Range(szene & "52").Value
    Range("N6").Value = Range(szene & "53").Value
    Range("CA13").Value = Range(szene & "54").Value
    
    'Sinus + Sinus_2
    Range("M9").Value = Range(szene & "56").Value
    Range("N9").Value = Range(szene & "57").Value
    
    'Sinus * Sinus_2
    Range("M8").Value = Range(szene & "59").Value
    Range("N8").Value = Range(szene & "60").Value

    ' Messlinie_1
    Range("G13").Value = Range(szene & "62").Value
    Range("H13").Value = Range(szene & "63").Value
    
    ' Messlinie_2
    Range("I13").Value = Range(szene & "65").Value
    Range("J13").Value = Range(szene & "66").Value
    
    ' Pfeil in Zeitdiagramm
    Range("S2").Value = Range(szene & "67").Value
    
    ' Sinus in Vektordiagramm
    Range("AE2").Value = Range(szene & "68").Value
    
    
    ' Set focus
    Dim focusOnField As String
    focusOnField = Range(szene & "69").Value
    If (focusOnField <> "") Then
        Range(focusOnField).Select
        Call InputViaEntryForm
    End If
End Function
