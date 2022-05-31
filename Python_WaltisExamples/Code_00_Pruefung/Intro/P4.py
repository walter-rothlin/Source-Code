# coding=utf8
# Programmier - Aufgabe 4

def calcMin(timeStrHH_MM):
    HH, MM = timeStrHH_MM.split(":")
    return int(HH) * 60 + int(MM)

def sonnenstand(time):

    """
    time enthält eine Uhrzeit im Format hh:mm
    Mit dem Sonnenstand lässt sich Uhrzeit bestimmen:
    um 06:00 steht die Sonne bei 0 Grad --> geben sie den Wert 0 zurück
    um 12:00 steht die Sonne bei 90 Grad --> geben sie den Wert 90 zurück
    um 18:00 steht die Sonne bei 180 Grad -- geben sie den Wert 180 zurück
    Zeiten ausserhalb von 06:00 - 18:00 ---> Keine Sonne zurückgeben
    """
    MMTime = calcMin(time)
    if calcMin('06:00') < MMTime < calcMin('12:00'):
        print(time, " is between 06:00 - 12:00!    Sonnenstand:", (MMTime - calcMin("06:00"))/4, "°", sep="")
        return float((MMTime - calcMin("06:00"))/4)
    elif calcMin('12:00') < MMTime < calcMin('18:00'):
        print(time, " is between 12:00 - 18:00!    Sonnenstand:", 90 + ((MMTime - calcMin("12:00"))/4), "°", sep="")
        return float(90 + ((MMTime - calcMin("12:00"))/4))
    else:
        return "Keine Sonne!"

if __name__ == '__main__':
    print("Sonnenstand:")

    # Diese "asserts" helfen für die Selbstkontrolle, sind alle Asssert Ok - dann funktioniert ihr Prorgramm
    assert sonnenstand("07:00") == 15
    assert sonnenstand("12:15") == 93.75
    assert sonnenstand("15:45") == 146.25
    assert sonnenstand("18:01") == "Keine Sonne!"
    assert sonnenstand("06:15") == 3.75
    print("Wenn alles korrekt ist, dann wird diese Zeile ausgegeben !")
