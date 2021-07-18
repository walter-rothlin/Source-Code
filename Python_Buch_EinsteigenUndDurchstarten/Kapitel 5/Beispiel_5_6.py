# Beispiel 5.6
#
# Klassenattribute und Instanzen
#


# Klassendefinition
class Auto:
    # Klassenattribute
    intervall_erste_hu = 36

    def __init__(self, marke):
        self.marke = marke

        print("Neues Auto erstellt")


def main():
    # Hauptprogramm
    trabbi = Auto("Wartburg")
    kaefer = Auto("VW")

    print("Intervall vor der Änderung:")
    print("Zugriff über Objekt (Trabbi):", trabbi.intervall_erste_hu)
    print("Zugriff über Objekt (Käfer):", kaefer.intervall_erste_hu)
    print("Zugriff über Klasse:", Auto.intervall_erste_hu)

    trabbi.intervall_erste_hu = 48

    print("\nIntervall nach der Änderung:")
    print("Zugriff über Objekt (Trabbi):", trabbi.intervall_erste_hu)
    print("Zugriff über Objekt (Käfer):", kaefer.intervall_erste_hu)
    print("Zugriff über Klasse:", Auto.intervall_erste_hu)


main()
