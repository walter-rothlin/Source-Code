# Module der Pakete auf verschiedene Weisen importieren
from Crypt import asymmetrisch, symmetrisch
from Text import rechtschreibung
import Text.wortfilter

# Umbenennung des Namensraums
import Text.wortfilter as zensur

# Import einer einzelnen Funktion plus Umbenennung
from Text.autocomplete import wortvorschlag_unterbreiten as vorschlag

# Aufrufen der einzelnen Funktionen
asymmetrisch.verschluesseln()
symmetrisch.verschluesseln()
rechtschreibung.check()
Text.wortfilter.filtern()
zensur.filtern()
vorschlag()
