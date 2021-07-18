# Beispiel 6.17
#
# Darum sind Strings unveränderlich
#


# Klassendefinition (Hund)
class Hund:
    def __init__(self, name):
        self.name = name


def main():
    name = "Dingo"
    hund = Hund(name)

    # IDs ausgeben
    print("Vor der Veränderung des lokalen Strings")
    print("Variable \"name\" ({0}): {1}".format(name, id(name)))
    print("Attribut \"Hund.name\" ({0}): {1}".format(hund.name, id(hund.name)))

    # Name verändern
    name = "Arti"

    # Erneut die IDs ausgeben.
    print("\nNach der Veränderung des lokalen Strings")
    print("Variable \"name\" ({0}): {1}".format(name, id(name)))
    print("Attribut \"Hund.name\" ({0}): {1}".format(hund.name, id(hund.name)))


main()
