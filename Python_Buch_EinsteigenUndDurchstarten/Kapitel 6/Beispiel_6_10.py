# Beispiel 6.10
#
# Listen verknüpfen
#

# Eine Einkaufsliste initialisieren
einkaufsliste = ["Eier", "Milch", "Mehl", "Kaffee"]

# Zusätzliche Einkaufslisten
weitere_einkaeufe = ["Wasser", "Cola", "Saft"]
noch_mehr_sachen = ["Essig", "Öl", "Salz"]

# Einkaufslisten ausgeben
print("Ursprüngliche Einkaufsliste:", einkaufsliste)

# Einkaufsliste ergänzen
einkaufsliste += weitere_einkaeufe
print("Erweiterte Einkaufsliste:", einkaufsliste)

# Einkaufsliste vervollständigen
einkaufsliste.extend(noch_mehr_sachen)
print("Vollständige Einkaufsliste:", einkaufsliste)

# Neue Liste durch Addition zweier Listen erzeugen
vergessene_einkaeufe = weitere_einkaeufe + noch_mehr_sachen
print("Das hätte man fast vergessen:", vergessene_einkaeufe)
