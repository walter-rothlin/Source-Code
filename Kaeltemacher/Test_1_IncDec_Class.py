#!/usr/bin/python3


from Class_IncDec  import *

eintrittsZaehler = IncDec(100)
austrittsZaehler = IncDec(500,2,12)

print(eintrittsZaehler.get_value())
eintrittsZaehler.inc()
eintrittsZaehler.inc()
eintrittsZaehler.inc()
eintrittsZaehler.inc()
print(eintrittsZaehler.get_value())

print(austrittsZaehler.get_value())
austrittsZaehler.inc()
print(austrittsZaehler.get_value())
austrittsZaehler.inc()
print(austrittsZaehler.get_value())
austrittsZaehler.inc()
print(austrittsZaehler.get_value())
austrittsZaehler.dec()
print(austrittsZaehler.get_value())
print(eintrittsZaehler.get_value())