# Beispiel 12.1
#
# Eine einfaches Beispiel zum Experimentieren
#
import Auto


def main():
    # Hauptprogramm
    auto_eins = Auto.Auto("Peugeot", "Silber", 100, 3)
    auto_zwei = Auto.Auto("Hyundai", "Weiß", 55, 3)

    print("\nDaten von Auto eins:")
    auto_eins.zeige_daten()

    print("\nDaten von Auto zwei:")
    auto_zwei.zeige_daten()

    print("\nDie Autos fahren ein wenig durch die Gegend...")

    auto_eins.strecke_fahren(64)
    auto_zwei.strecke_fahren(128)

    print("Kilometerstand des ersten Autos:", auto_eins.kilometerstand)
    print("Kilometerstand des zweiten Autos:", auto_zwei.kilometerstand)


main()
