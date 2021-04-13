import time

zaehler = 0
while True:
    print("{n:10d}: Hallo HWZ".format(n=zaehler))

    # busy wait
    # for i in range(100000):
    #     tmp = 4.5 * 2.1

    # timer-Event (Scheduler Anfrage)
    time.sleep(1)
    zaehler += 1