i = 1
while i <= 12:
    print("    ",i)
    i += 1    # i = i + 1
print("end of while")

for i in [1, False, 5*4, 1, -3.1415, "-+"*4, -3, 7, 5, 12.5, "BZU", True]:
    print("    ",i)
print("end of for")

for i in range(15):
    print("    ", i)
print("end of for range(15)")

for i in range(15, 20):
    print("    ", i)
print("end of for range(15, 20)")

for i in range(15, 20, 3):
    print("    ", i)
print("end of for range(15, 20, 3)")