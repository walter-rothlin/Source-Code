from mcpi.minecraft import Minecraft
from mcpi import block


# Funktion zum Bau einer Pyramide
def pyramide_bauen(mc, x_pos, y_pos, z_pos, hoehe,
                   stufenschritt=1, blocktyp=block.SANDSTONE.id):
    breite = hoehe*2 - 1

    # Pyramide bauen
    for y in range(0, hoehe):
        mc.setBlocks(x_pos+y, y_pos+y*stufenschritt, z_pos+y,
                     x_pos+breite-y, y_pos+y*stufenschritt, z_pos+breite-y,
                     blocktyp)
        
        
# Funktion zum Bau eines Oktaeders
def oktaeder_bauen(mc, x_pos, y_pos, z_pos, hoehe, schritt_oben, schritt_unten,
                   blocktyp_oben=block.STONE.id, blocktyp_unten=block.STONE.id):
    pyramide_bauen(mc, x_pos, y_pos, z_pos, hoehe, schritt_oben, blocktyp_oben)
    pyramide_bauen(mc, x_pos, y_pos, z_pos, hoehe, schritt_unten, blocktyp_unten)
