doLoop = True
while doLoop:
print("Geometrische Flaechen")
print("====================")
print("1: Rechteck")
print("2: Kreis")
print("")
print("0: Schluss")

antwort = input("\n Wähle:") if (antwort == "1"): gradValue=float(input("Rechteck Laenge:")) radValue=float(input("Rechteck Breite:")) print("Rechteck Umfang:", gradValue+gradValue+radValue+gradValue) print("Rechteck Flaeche:", radValue*gradValue)


antwort = input("\n Wähle:") if (antwort == "2"): gradValue=float(input("Rechteck Laenge:")) radValue=float(input("Rechteck Breite:")) print("Rechteck Umfang:", gradValue+gradValue+radValue+gradValue) print("Rechteck Flaeche:", radValue*gradValue)


print("Ende.....Done")

    if Antwort == "0":
        print("Schluss")
doloop = False