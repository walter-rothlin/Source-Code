
Function SagHallo(Anrede As String, Vorname As String) As String
    SagHallo = Anrede & " " & Vorname & ","
End Function

Function GradToRad(GradWert As Double) As Double
    GradToRad = 3.1415 * GradWert / 180
End Function

Function GetInitialen(Vorname As String, Nachname As String) As String
    GetInitialen = UCase(Left(Vorname, 1)) & "." & UCase(Left(Nachname, 1)) & "."
End Function

Function CalcQuaderVolumen(Laenge As Double, Optional Breite As Double = 0, Optional Hoehe As Double = 0) As Double
    If Hoehe = 0 Then
        Hoehe = Laenge
    End If
    If Breite = 0 Then
        Breite = Laenge
    End If
    If (Laenge < 0) Or (Breite < 0) Or (Hoehe < 0) Then
        CalcQuaderVolumen = 0
    Else
        CalcQuaderVolumen = Laenge * Breite * Hoehe
    End If
End Function

Function OrtFuerAdressLabel(Land As String, PLZ As Long, Ort As String) As String
    Dim retValue As String
    retValue = Land & "-" & PLZ & " <U>" & Ort & "</U>"

    OrtFuerAdressLabel = retValue
End Function

Function AddNummern(EndNummer As Integer) As Integer
    Dim retVal As Integer
    retVal = 0
    If EndNummer > 0 Then
        For aNummer = 1 To EndNummer
            retVal = retVal + aNummer
        Next
    End If
    AddNummern = retVal
End Function
