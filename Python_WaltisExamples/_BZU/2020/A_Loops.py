i = 1  # startwert
while i <= 10:
    print("    ", i)
    i += 1      # i = i + 1
print("while ende!")

aTestValue = 54
for i in [3, False, 1, 4, 6, 12.8, "hello", 'BZU', True, 2*5, aTestValue*2.1]:
    print("    ", i)
print("for ende!")

for i in "BZU":
    print("   ", i)
print("string ende")

for i in range(10):        # [0, 1, 2, 3, 4,...9]
    print("   ", i)
print("range(10) ende")


for i in range(10, 20):    # [10, 11, 12, .... 19]
    print("   ", i)
print("range(10,20) ende")

for i in range(10, 20, 3):    # [10, 13, 16, 19]
    print("   ", i)
print("range(10,20,3) ende")