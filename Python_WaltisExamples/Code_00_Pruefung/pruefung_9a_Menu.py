pi = 3.1415926


doLoop = True
while (doLoop):
    print("  Geometrische Flaechen")
    print("  =====================")
    print("  1: Quadrat")
    print("  2: Dreieck")
    print()
    print("  0: Schluss")

    antwort = input("\n  Wähle:")
    if (antwort == "1"):
        sLaenge = float(input("Quadrat Seite:"))
        flaeche = sLaenge * sLaenge
        umfang = 4 * sLaenge
        print("Umfang :{u:6.2f}".format(u=umfang))
        print("Flaeche:{f:6.2f}".format(f=flaeche))
    elif (antwort == "2"):
        gLine = float(input("Grundlinie Dreieck:"))
        hoehe = float(input("Hoehe      Dreieck:"))
        flaeche = gLine * hoehe / 2
        print("Flaeche:{f:6.2f}".format(f=flaeche))
    elif (antwort == "0"):
        doLoop = False

print("Ende....Done")