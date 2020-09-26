#!/usr/bin/python3


from Class_IncDec  import *

eintrittsZaehler = IncDec(100)
austrittsZaehler = IncDec(500,2,12)

print(eintrittsZaehler.getValue())
eintrittsZaehler.inc()
eintrittsZaehler.inc()
eintrittsZaehler.inc()
eintrittsZaehler.inc()
print(eintrittsZaehler.getValue())

print(austrittsZaehler.getValue())
austrittsZaehler.inc()
print(austrittsZaehler.getValue())
austrittsZaehler.inc()
print(austrittsZaehler.getValue())
austrittsZaehler.inc()
print(austrittsZaehler.getValue())
austrittsZaehler.dec()
print(austrittsZaehler.getValue())
print(eintrittsZaehler.getValue())