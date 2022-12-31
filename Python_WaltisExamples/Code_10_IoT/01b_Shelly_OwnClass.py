
from Class_Shelly import *



if __name__ == '__main__':

    shellyList = [
        {'ip': "192.168.1.131",
         'shelly_name': "Mit Schalter",
         'shelly_type': ShellyTyps.Shelly_1_Blau,
         'obj': None
         },
        {'ip': "192.168.1.134",
         'shelly_name': "Rot 1",
         'shelly_type': ShellyTyps.Shelly_1PM_Rot,
         'obj': None
         },
        {'ip': "192.168.1.135",
         'shelly_name': "Rot 2",
         'shelly_type': ShellyTyps.Shelly_1PM_Rot,
         'obj': None
         },
        {'ip': "192.168.1.133",
         'shelly_name': "Mehrfach-Shelly_1",
         'shelly_type': ShellyTyps.ShellyPro_4PM_Tableau,
         'obj': None
         },
    ]

    shellyList = [
        {'ip': "192.168.178.36",
         'shelly_name': "Mehrfach-Shelly_1",
         'shelly_type': ShellyTyps.ShellyPro_4PM_Tableau,
         'obj': None
         },
    ]

    print("instantiates shelly objects....")
    for aShellyConfig in shellyList:
        aShellyConfig['obj'] = ShellyAPI(
                                  ip=aShellyConfig['ip'],
                                  shelly_name=aShellyConfig['shelly_name'],
                                  shelly_type=aShellyConfig['shelly_type'])
        print(aShellyConfig['obj'].get_device_settings())

        shellyList[0]['obj'].turn_on()
        print("==>", shellyList[0]['obj'].get_current_power_usage(switchNo=0, doTrace=False), "W")
        print("==>", shellyList[0]['obj'].get_energy_meter_value(switchNo=0, doTrace=False), "Wh")

        sleep(5)
        print("==>", shellyList[0]['obj'].get_energy_meter_value(switchNo=0, doTrace=False), "Wh")
        shellyList[0]['obj'].turn_off()




