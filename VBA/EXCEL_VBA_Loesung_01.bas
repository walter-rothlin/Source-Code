
' Mathematische (Formel) Implementationen
' =======================================
' Die Fct berechnet die Fläche eines Rechteckes mit der Formel:
' A = Laenge * Breite
'
' Falls Laenge oder Breite <0 sind, wird Wert 0 zurückgegeben.
Function CalcRechteck(laenge As Double, breite As Double) As Double
    If (laenge < 0) Or (breite < 0) Then
        CalcRechteck = 0
    Else
        CalcRechteck = (laenge * breite)
    End If
End Function


' -------------------------------------------------------------------
' Die Fct berechnet das Volumen eines Zylinders mit der Formel:
' V=(Durchmesser^2 * 3.1415926 * Hoehe / 4)
'
' Falls Durchmesser oder Hoehe <0 sind, wird Wert 0 zurückgegeben.
Function GetCylinderVolume(durchmesser As Double, hoehe As Double) As Double
    If (durchmesser < 0) Or (hoehe < 0) Then
        GetCylinderVolume = 0
    Else
        GetCylinderVolume = (durchmesser ^ 2 * 3.1415926 * hoehe / 4)
    End If
End Function




' String-Operationen
' ==================
' Die Fct gibt "Hello BZU" zurück. 
' Falls ein Parameter übergeben wird, gibt die Fct "Hello {Name}" zurück.
Function Hello(Optional vorname As String = "") As String
    If vorname = "" Then
         Hello = "Hallo BZU"
    Else
        Hello = "Hallo " & vorname & "!"
    End If
End Function


' -------------------------------------------------------------------
' Die Fct gibt "Hello!" zurück. 
' Falls ein Vorname mitgegeben wird und PerDu True ist, wird "Hallo Vorname" zurückgegeben!
' Falls ein Name mitgegeben wird und PerDu False ist, wird "Sehr geehrter Herr Name" zurückgegeben!
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
' Die Fct gibt den 1.Buchstaben vom Vorname (als Grossbuchstabe) 
' gefolgt von einem "." gefolg von einem Space und danach 
' der Nachname, ebenfalls mit einem Grossbuchstaben begonnen.
Function GetAnrede(vorname As String, nachname As String) As String
    GetAnrede = UCase(Left(vorname, 1)) & ". " & UCase(Left(nachname, 1)) & Right(nachname, Len(nachname) - 1)
End Function


' -------------------------------------------------------------------
' Die Fct gibt die HTML formatierte Ortsbezeichnung zurück. 
' Falls das Land <> "CH" ist, wird der einstellige Ländercode vorgestellt.
Function GetOrtsAnschrift(Land As String, PLZ As Long, Ort As String) As String
    Dim retValue As String
    retValue = Land & "-" & PLZ & " <U>" & Ort & "</U>"

    GetOrtsAnschrift = retValue
End Function




' Mathematische (Formel) Implementationen
' =======================================
' Die Fct gibt die Summe von 1/1 + 1/2 + 1/3 + 1/4 +…+ 1/n zurück.
' Ist n <= 0 wird 0 zurück gegeben. Default von n ist 100.
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
' Die Fct gibt die Summe der Zahlen von Start bis Ende zurück.
Function AddFigureRange(startVal As Integer, endVal As Integer) As Integer
    Dim summe As Integer
    summe = 0
    For i = startVal To endVal
        summe = summe + i
    Next
    AddFigureRange = summe
End Function


' -------------------------------------------------------------------
' Die Fct gibt das Produkt der Zahlen von Start bis Ende zurück. 
' Falls Ende nicht spezifiziert wird, wird die Fakultät(Start) 
' berechnet (Produkt der Zahlen von 2 bis Start)
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

