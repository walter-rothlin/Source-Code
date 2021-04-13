import time
from threading import Timer


def hello(msg, text1, countOfLoops=0):
    i = 0
    if countOfLoops == 0:
        while True:
            print(i, msg, text1)
            i += 1
            time.sleep(1)
    else:
        for i in range(countOfLoops+1):
            print(i, msg, text1)
            i += 1
            time.sleep(1)

# hello("Morgen", "Studiengruppe")

print("Thread 1 gestarted")
t1 = Timer(4, hello, args=["t1: hallo", "BWI", 10])
t1.start()

print("Thread 2 gestarted")
t2 = Timer(8, hello, args=["t2: hallo", "HWZ", 5])
t2.start()

print("Wait for t1...")
t1.join()

print("Wait for t2...")
t2.join()

print()
print("Threats terminated. Back in main")
hello("Gugus", "BWI", 6)
print("Finished")
