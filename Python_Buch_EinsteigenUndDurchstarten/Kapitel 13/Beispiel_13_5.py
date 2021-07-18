# Beispiel 13.5
#
# Mit einer for-Schleife eine Treppe bauen
#
from mcpi.minecraft import Minecraft
from mcpi import block

# Aktuelle Position des Spielers ermitteln
mc = Minecraft.create()
pos = mc.player.getPos()

anzahl_stufen = int(input("Bitte Anzahl der Stufen eingeben: "))

# Treppe bauen
for i in range(1, anzahl_stufen):
    mc.setBlock(pos.x+i, pos.y+i, pos.z, block.WOOD.id)
    mc.setBlock(pos.x+i, pos.y+i, pos.z+1, block.WOOD.id)
