
' Mathematische (Formel) Implementationen
' =======================================
Function CalcRechteck(laenge As Double, breite As Double) As Double
    If (laenge < 0) Or (breite < 0) Then
        CalcRechteck = 0
    Else
        CalcRechteck = (laenge * breite)
    End If
End Function


' -------------------------------------------------------------------
Function GetCylinderVolume(durchmesser As Double, hoehe As Double) As Double
    If (durchmesser < 0) Or (hoehe < 0) Then
        GetCylinderVolume = 0
    Else
        GetCylinderVolume = (durchmesser ^ 2 * 3.1415926 * hoehe / 4)
    End If
End Function




' String-Operationen
' ==================
Function Hello(Optional vorname As String = "") As String
    If vorname = "" Then
         Hello = "Hallo BZU"
    Else
        Hello = "Hallo " & vorname & "!"
    End If
End Function


' -------------------------------------------------------------------
Function HelloPerDu(Optional nachname As String, Optional vorname As String, Optional perDu As Boolean = False) As String
    Dim retVal As String
    retVal = "Hallo!"
    
    If perDu Then
        If (vorname <> "") Then
            retVal = "Hallo " & vorname & ","
        End If
    Else
        If (nachname <> "") Then
            retVal = "Sehr geehrter Herr " & nachname & ","
        End If
    End If
    HelloPerDu = retVal
End Function


' -------------------------------------------------------------------
Function GetAnrede(vorname As String, nachname As String) As String
    GetAnrede = UCase(Left(vorname, 1)) & ". " & UCase(Left(nachname, 1)) & Right(nachname, Len(nachname) - 1)
End Function


' -------------------------------------------------------------------
Function GetOrtsAnschrift(Land As String, PLZ As Long, Ort As String) As String
    Dim retValue As String
    retValue = Land & "-" & PLZ & " <U>" & Ort & "</U>"

    GetOrtsAnschrift = retValue
End Function




' Mathematische (Formel) Implementationen
' =======================================
Function AddFractions(Optional n As Integer = 0) As Double
    Dim retVal As Double
    retVal = 1
    If n <= 0 Then
        retVal = 0
    Else
        For nenner = 2 To n
            retVal = retVal + 1 / nenner
        Next
    End If
    AddFractions = retVal
End Function


' -------------------------------------------------------------------
Function AddFigureRange(startVal As Integer, endVal As Integer) As Integer
    Dim summe As Integer
    summe = 0
    For i = startVal To endVal
        summe = summe + i
    Next
    AddFigureRange = summe
End Function


' -------------------------------------------------------------------
Function MulFigureRange(startVal As Integer, Optional endVal As Integer = -1) As Long
    Dim produkt As Long
    produkt = 1
    If endVal = -1 Then
        endVal = startVal
        startVal = 1
    End If
    For i = startVal To endVal
        produkt = produkt * i
    Next

    MulFigureRange = produkt
End Function

