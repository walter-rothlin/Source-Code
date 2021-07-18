# Beispiel 13.8
#
# Einen Oktaeder bauen
#
from mcpi.minecraft import Minecraft
from mcpi import block


# Funktion zum Bau einer Pyramide
def pyramide_bauen(mc, hoehe, stufenschritt=1, blocktyp=block.SANDSTONE.id):
    # Spielerposition ermitteln
    pos = mc.player.getPos()

    breite = hoehe*2 - 1

    # Pyramide bauen
    for y in range(0, hoehe):
        mc.setBlocks(pos.x+y, pos.y+y*stufenschritt, pos.z+y,
                     pos.x+breite-y, pos.y+y*stufenschritt, pos.z+breite-y,
                     blocktyp)


# Hauptprogramm
def main():
    mc = Minecraft.create()

    # Oktaeder bauen
    hoehe = 7
    pyramide_bauen(mc, hoehe, blocktyp=block.GLASS.id)
    pyramide_bauen(mc, hoehe, -2, block.WOOD.id)

    # Eine andere Variante
    #hoehe=9
    #pyramide_bauen(mc, hoehe, 3)
    #pyramide_bauen(mc, hoehe, -1)


main()
