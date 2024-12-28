from machine import Pin
import machine

from gpio_lcd import GpioLcd

class HomeController:
    def __init__(self):
        self.log_idx = 0

        # Init Relais Pins
        self.relais = [Pin(10, Pin.OUT), Pin(11, Pin.OUT), Pin(12, Pin.OUT), Pin(13, Pin.OUT)]

        # Init Status LED Pins
        self.statusLED ={"Green": Pin(28,Pin.OUT), "Yellow": Pin(27,Pin.OUT)}

        # Init Board Switch
        self.boardSwitch = Pin(3, Pin.IN)

        self.boardSwitch.irq(trigger=Pin.IRQ_FALLING, handler=self.board_switch_handler)

        # Init LCD Display
        self.lcd = GpioLcd(rs_pin=Pin(15,Pin.OUT),
                          enable_pin=Pin(14,Pin.OUT),
                          d4_pin=Pin(20,Pin.OUT),
                          d5_pin=Pin(21,Pin.OUT),
                          d6_pin=Pin(22,Pin.OUT),
                          d7_pin=Pin(26,Pin.OUT),
                          num_lines=2, num_columns=16)
        self.lcd.clear()

        # Tun off all Outputs
        for relai in self.relais:
            relai.value(0)


        for led in self.statusLED:
            self.statusLED[led].value(0)    

        self.lcd.putstr("Startup Done.")


    def set_relais(self, relai, value):
        if relai >= 0 and relai < 4 and value >= 0 and value <= 1:
            self.relais[relai].value(value)
            return True
        else:
            return False

    def get_relais(self, relai):
        if relai >= 0 and relai < 4:
            return self.relais[relai].value()
        else:
            return None

    def set_status_led(self, led, value):
        if led in self.statusLED and value >= 0 and value <= 1:
            self.statusLED[led].value(value)
            return True
        else:
            return False

    def get_status_led(self, led):
        if led in self.statusLED:
            return self.statusLED[led].value()
        else:
            return None
        
    def get_board_switch(self):
        return self.boardSwitch.value()
    
    def write_lcd(self, text):
        self.lcd.clear()
        self.lcd.putstr(text)

    def clear_lcd(self):
        self.lcd.clear()

    def board_switch_handler(self, pin):
        self.clear_lcd()
        print("Board Switch Pressed")


   
