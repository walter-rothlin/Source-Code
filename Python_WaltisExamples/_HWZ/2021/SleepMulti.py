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
t = Timer(4, hello, args=["hallo", "HWZ", 10])
t.start()

print("Thread 2 gestarted")
t1 = Timer(8, hello, args=["hallo", "Schweiz"])
t1.start()

t.join()

hello("Gugus", "BWI", 30)
print("Finished")
