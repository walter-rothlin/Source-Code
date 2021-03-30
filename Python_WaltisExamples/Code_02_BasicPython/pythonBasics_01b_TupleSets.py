#!/usr/bin/python3




print("Tuple")
print("=====")
carsTuble = ("Ford", "Volvo", "BMW", "Ford")

print("Whole List   :", carsTuble)
print("1st carsTuble      :", carsTuble[0])
print("2nd carsTuble      :", carsTuble[1])
print("Count of carsTuble :", len(carsTuble))
print("carsTuble          :", carsTuble)
#   carsTuble[0] = "Fiat"     Tubles are unchangeable!!!
print("\n")

carSet  = {"Ford", "Volvo", "BMW", "Ford"}
carSet2 = {4, 7, 8, 12}
print("carSet                         :", carSet)
print("carSet2                        :", carSet2)
if not ("Fiat" in carSet):
    print("Fiat is not in set")
carSet.add("Fiat")
print("carSet.add(\"Fiat)\"             :", carSet)
carSet.update(["Lexus", "Audi"])
print("carSet.update(['Lexus','Audi']):", carSet)
if ("Fiat" in carSet):
    print("Fiat is in set")
carSet.discard("Fiat")
print("carSet.discard(\"Fiat\")         :", carSet)

print("carSet.union(carSet2)          :", carSet.union(carSet2))

