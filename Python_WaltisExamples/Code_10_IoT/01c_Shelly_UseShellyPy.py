import ShellyPy

device = ShellyPy.Shelly("192.168.1.131")

device.relay(0, turn=True)
print(device)
# sleep(10)
device.relay(0, turn=False)
