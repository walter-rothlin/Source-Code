#!/usr/bin/python3

def sayHello(firstname=None, anrede="Hallo"):
    if firstname is None:
        return anrede
    else:
        return anrede + " " + firstname


print("Hello\n", "World!!!")
summand_1 = 43.45
summand_2 = 7.27
print(summand_1, "+", summand_2, "=", summand_1 + summand_2, sep=" ", end='\n')
print(summand_1, "-", summand_2, "=", summand_1 - summand_2, sep=" ", end="\n")
print('{s1:5.3f} - {s2:5.1f} = {summe:5.1f}'.format(s2=summand_2, summe=summand_1 - summand_2, s1=summand_1))


print(sayHello(), "::", sep="")
print(sayHello("HWZ"), "::", sep="")
print(sayHello(firstname="Marco", anrede="Bonjour"), "::", sep="")


