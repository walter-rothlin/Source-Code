# Beispiel 13.12
#
# Mengenlehre visuell
#
from mcpi.minecraft import Minecraft
from mcpi import block

# Aktuelle Position des Spielers ermitteln
mc = Minecraft.create()
pos = mc.player.getPos()


# Funktion zum Darstellen eines Sets anhand von Blöcken
def set_darstellen(bloecke, abstand):
    position = 0
    for block in bloecke:
        mc.setBlock(pos.x + position, pos.y, pos.z + abstand, block)
        position += 1


# Hauptprogramm
def main():
    # Steine
    steine = set((block.STONE.id, block.COBBLESTONE.id, block.BEDROCK.id,
                  block.SANDSTONE.id, block.OBSIDIAN.id,
                  block.GLOWSTONE_BLOCK.id))

    # Erze
    erze = set((block.DIAMOND_ORE.id, block.IRON_ORE.id, block.REDSTONE_ORE.id,
                block.GOLD_ORE.id, block.LAPIS_LAZULI_ORE.id, block.COAL_ORE.id))

    # Gelbe Blöcke
    gelbe_bloecke = set((block.SANDSTONE.id, block.GLOWSTONE_BLOCK.id,
                         block.GOLD_ORE.id, block.IRON_ORE.id))

    # Blaue Blöcke
    blaue_bloecke = set((block.DIAMOND_ORE.id, block.LAPIS_LAZULI_ORE.id))

    # Schwarze Blöcke
    schwarze_bloecke = set((block.COAL_ORE.id, block.OBSIDIAN.id,
                            block.BEDROCK.id))
    
    # Steine und Erze darstellen
    set_darstellen(steine, 2)
    set_darstellen(erze, 4)
    
    # Steine und Erze zusammenfassen und darstellen
    alle_bloecke = steine.union(erze)    
    set_darstellen(alle_bloecke, 6)
    
    # Schwarze Blöcke "aussortieren" (Differenzmenge) und darstellen
    aussortiert = alle_bloecke.difference(schwarze_bloecke)    
    set_darstellen(aussortiert, 8)

    # Obsidian hinzufügen und symmetrische Differenz anzeigen
    aussortiert.update((block.OBSIDIAN.id,))    
    aussortiert.symmetric_difference_update(alle_bloecke)
        
    set_darstellen(aussortiert, 10)

    
main()
