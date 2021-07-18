# Beispiel 13.7
#
# Eigene Swimmingpools bauen
#
from mcpi.minecraft import Minecraft
from mcpi import block
import time


# Funktion zum Bau eines Swimmingpools
def pool_bauen(mc, abstand_x, abstand_y, abstand_z):
    # Spielerposition ermitteln und gewünschten Abstand dazuzählen
    pos = mc.player.getPos()
    pos.x += abstand_x
    pos.y += abstand_y
    pos.z += abstand_z

    # Den Pool zunächst als großen Block bauen. Anschließend kurz warten
    mc.setBlocks(pos.x, pos.y, pos.z, pos.x + 10, pos.y + 4, pos.z + 15,
                 block.DIAMOND_BLOCK.id)
    time.sleep(0.5)

    # Pool "aushöhlen" und mit Wasser füllen. Wieder kurz warten
    mc.setBlocks(pos.x + 1, pos.y + 1, pos.z + 1, pos.x + 9, pos.y + 4,
                 pos.z + 14, block.WATER.id)
    time.sleep(0.5)

    # Ein kleines Loch in den Boden schlagen, damit Wasser herauslaufen kann
    mc.setBlock(pos.x + 3, pos.y, pos.z + 3, 0)


# Hauptprogramm
def main():
    mc = Minecraft.create()

    # Drei Pools bauen
    pool_bauen(mc, 5, 0, 5)
    pool_bauen(mc, 9, 9, 12)
    pool_bauen(mc, 16, 19, 17)


main()
