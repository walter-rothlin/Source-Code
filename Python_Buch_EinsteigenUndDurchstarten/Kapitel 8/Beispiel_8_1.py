# Beispiel 8.1
#
# Importieren eines Moduls
#
import Verschluesselung

# Eine Geheimbotschaft
text = "Treffen heute Nacht am alten Pier"
print("Der Klartext lautet :", text)

# Funktionen des Moduls aufrufen
geheimtext = Verschluesselung.text_verschluesseln(text)
print("Verschlüsselter Text:", geheimtext)

klartext = Verschluesselung.text_entschluesseln(geheimtext)
print("Entschlüsselter Text:", klartext)
