# Beispiel 13.4
#
# Automatisches Bewegen
#
from mcpi.minecraft import Minecraft

# Aktuelle Position des Spielers ermitteln
mc = Minecraft.create()
pos = mc.player.getPos()
    
schritt = 0
naechster_block = 0
    
# So lange laufen, bis 20 Schritte gemacht wurden oder der
# Spieler auf ein Hindernis trifft
while naechster_block == 0 and schritt < 20:
    # Neue Spielerposition setzen
    mc.player.setPos(pos.x+schritt, pos.y, pos.z)
    
    # Nächsten Schritt vorbereiten
    schritt += 1
    naechster_block = mc.getBlock(pos.x+schritt, pos.y, pos.z)
