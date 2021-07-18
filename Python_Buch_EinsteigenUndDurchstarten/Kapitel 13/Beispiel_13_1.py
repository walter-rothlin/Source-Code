# Beispiel 13.1
#
# Erster Test mit Minecraft Pi
#
from mcpi.minecraft import Minecraft

mc = Minecraft.create()

# Eine Nachricht im Chat ausgeben
mc.postToChat("Hello World!")
