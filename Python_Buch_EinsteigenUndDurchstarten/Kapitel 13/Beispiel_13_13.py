# Beispiel 13.13
#
# Module und Pakete
#
from mcpi.minecraft import Minecraft
from mcpi import block
from objekte import geometrie
from objekte import pool


# Hauptprogramm
def main():
    # Aktuelle Position des Spielers ermitteln
    mc = Minecraft.create()
    pos = mc.player.getPos()

    # Zwei Pyramiden bauen
    geometrie.pyramide_bauen(mc, pos.x-8, pos.y-5, pos.z+4,
                             6, blocktyp=block.OBSIDIAN.id)

    geometrie.pyramide_bauen(mc, pos.x+5, pos.y+9, pos.z+7,
                             9, blocktyp=block.ICE.id)

    # Einen Oktaeder bauen
    geometrie.oktaeder_bauen(mc, pos.x+10, pos.y-9, pos.z+10,
                             8, 2, -1, block.TNT.id, block.MELON.id)

    # Einen Pool bauen
    pool.pool_bauen(mc, pos.x-3, pos.y-14, pos.z+3)


main()
