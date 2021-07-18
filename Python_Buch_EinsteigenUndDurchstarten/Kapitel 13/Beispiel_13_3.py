# Beispiel 13.3
#
# Block anhand Spielereingabe setzen
#
from mcpi.minecraft import Minecraft

mc = Minecraft.create()

while True:
    block_id = int(input("Block-ID eingeben (>247 für Ende): "))

    # Abbruch bei ungültiger Block-ID
    if block_id > 247:
        break

    # Aktuelle Position des Spielers ermitteln
    pos = mc.player.getPos()
    
    # Block des gewünschten Typs setzen
    mc.setBlock(pos.x+2, pos.y, pos.z, block_id)
