#!/usr/bin/python3

print("\n\n")
print("# for loops")
print("# ---------")

for i in [3,6,9,1,33]:
   print(i)
print("\n")

print("--> for aNumber in [1,5,5.5]:")
for aNumber in [1,5,5.5]:
    print(aNumber)
print("\n")

for i in ["walti",True,5*3,"Claudia",9,1,33,3.1415926]:
    print(i)
print("\n")

print("--> for aNumber in [1,5,5.5]:")
for aNumber in [1,5,5.5]:
    print(aNumber)
print("\n")

print("--> for aName in [\"walti\",\"claudia\",\"fritz\"]:")
for aName in ["walti","claudia","fritz"]:
    print(aName)
print("\n")
	
print("--> for aChar in \"BINGO\":")
for aChar in "BINGO":
    print(aChar)
print("\n")

print("--> for i in range(5):")
for i in range(5):
    print(i,"Hellooooo")
print("\n")

print("\n")
for i in range(10):
   print(i)
   
print("--> range(5, 10)")
for i in range(5, 10):
    print(i)   # 5 through 9
print("\n")

print("--> range(0, 10, 3)")
for i in range(0, 10, 3):
    print(i)   # 0, 3, 6, 9
print("\n")

print("--> range(-10, -100, -30)")
for i in range(-10, -100, -30):
    print(i)   # -10, -40, -70
print("\n")


words = ['catiputzi', 'window', 'defenestrate','mac','RPi',]
print(words)
for w in words[:]:
    print(w, len(w))

for w in words[:]:  # Loop over a slice copy of the entire list.
    if len(w) > 6:
        words.insert(0, w)
print(words)   # ['defenestrate', 'cat', 'window', 'defenestrate']
print("\n")


print("\nLoop break, else, continue")
for n in range(2, 10):
    for x in range(2, n):
        if n % x == 0:
            print(n, ' = ', x, '*', n//x)
            break
        else:
            # loop fell through without finding a factor
            print(n, 'is a prime number')
print("\n")

for num in range(2, 10):
    if num % 2 == 0:
        print("Found an even number", num)
        continue
    print("Found a number", num)
print("\n")

print("\n\n")
print("# while-loops")
print("# ------------")
a, b = 0, 1
while b < 10:
    print(a, b)
    a, b = b, a+b
print("\n")

doLoop = True
while doLoop:
    ant = int(input("0:break 1:normal exit  "))
    if ant == 0:
        print("if-then")
        break
    elif ant == 1:
        print("if-elif")
        doLoop = False
    else:
        print("if-else")
        continue
    print("after if-then-else")
else:
    print("else in while loop (will not executed in case you break)")
    print("THERE IS NO DO-WHILE LOOP IN PYTHON!!!!")
