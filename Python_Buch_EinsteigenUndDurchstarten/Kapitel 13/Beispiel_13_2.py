# Beispiel 13.2
#
# Blöcke platzieren, Kamera fixieren
#
from mcpi.minecraft import Minecraft
from mcpi import block
from mcpi import vec3

mc = Minecraft.create()

# Aktuelle Position des Spielers ermitteln
pos = mc.player.getPos()

# Rote Wolle neben der Spielfigur platzieren
mc.setBlock(pos.x+1, pos.y, pos.z, 35, 14)

# Blaue Wolle neben der Spielfigur platzieren
mc.setBlock(pos.x+2, pos.y, pos.z, block.WOOL.id, 11)

# Kamera fixieren
mc.camera.setFixed()

# Kamera über dem Spieler platzieren
pos.y += 10
mc.camera.setPos(pos)
