#!/usr/bin/python3

print("\n\n")
print("# read from stty")
print("# --------------")

# python3 is input instead of raw_input
name = input("What's your name? ")
print("Nice to meet you " + name + "!")
age = int(input("What is your age? "))
print("So " + name + ", you are already " + str(age) + " years old!")
print("name:   value:", name, "    type:", type(name))
print("age :   value:", age , "    type:", type(age))
print("\n")

calcStr = input("Rechnung (z.B. 5*6-2): ")
print(calcStr, " = ", eval(calcStr))

