import random
import time

# https://www.python-lernen.de/zufallszahlen-random.htm


for i in range(5):
    print(random.random())
    time.sleep(1)

print("\n  --> Dadurch bekommen wir Zahlen zwischen 1 und unter 10")
def zufallszahl():
    return random.random() * 9 + 1
print(zufallszahl())

print(random.uniform(5, 8))
print(random.normalvariate(5, 0.1))
print("\n  --> 1..6")
for i in range(10):
    print(random.randint(1, 6))

handgeste = ['Schere', 'Stein', 'Papier', 23]
print("\n  --> ", handgeste)
for i in range(10):
    print(random.choice(handgeste))
