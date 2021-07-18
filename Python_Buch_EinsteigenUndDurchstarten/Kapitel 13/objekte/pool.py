from mcpi.minecraft import Minecraft
from mcpi import block
import time


# Funktion zum Bau eines Swimmingpools
def pool_bauen(mc, x_pos, y_pos, z_pos):
    # Den Pool zunächst als großen Block bauen. Anschließend kurz warten
    mc.setBlocks(x_pos, y_pos, z_pos, x_pos + 10, y_pos + 4, z_pos + 15,
                 block.DIAMOND_BLOCK.id)
    time.sleep(0.5)

    # Pool "aushöhlen" und mit Wasser füllen. Wieder kurz warten
    mc.setBlocks(x_pos + 1, y_pos + 1, z_pos + 1, x_pos + 9, y_pos + 4,
                 z_pos + 14, block.WATER.id)
    time.sleep(0.5)

    # Ein kleines Loch in den Boden schlagen, damit Wasser herauslaufen kann
    mc.setBlock(x_pos + 3, y_pos, z_pos + 3, 0)
