###  PyC0FFEE  ###
'''
0.16    26.11.2022  Basis Code mit Kontroll-Strukturen und Klassen für 20x2 Zeichen-LCD, 
                    Breath LED, Tasten-Entprellung, Status LEDs, PWM, Temperatur und 
                    Flow-Sensor.
0.17    30.11.2022  Klasse für das Erstellen von Log-Dateien erstellt, manuelles Setzen der 
                    PWM Duty Cycle über Tasten für Regler-Tests, erster funktionsfähiger
                    P-Regler mit je einem Kp-Wert für Aufheizen und Kaffee-Ausgabe.
0.18    13.12.2022  Ersatz des Zeichen-LCDs durch 480x320 Pixel TFT, Implementierung eines
                    Framebuffers mit halber Auflösung und Skalierung während Datenübertragung.
0.19    14.12.2022  Beschleunigung der TFT-Ausgabe von 3200 ms pro Frame auf 123 ms mittels
                    Code-Optimierung, @micropython.viper Dekorator, Pointern und Multi-Threading.
0.20    14.01.2023  Methode zum Einlesen von PPM-Dateien (Portable Pixmam): Einlesen und
                    Übertragen in Framebuffer dauert 3800 ms > Optimierung auf 800 ms pro Bild.
0.21    20.01.2023  Python-Konverter für PPM-Datei im RGB888-Format (3 Byte per Pixel) in 
                    PPH-Datei mit RGB565 (2 Bytes per Pixel) erstellt, Einlese-Methode optmiert,
                    ohne Farbraum-Konvertierung und Optimierungen Einlesen und Anzeigen auf 275 ms
                    reduziert.
0.22    31.01.2023  Code und Kommentare überarbeitet
0.23    02.02.2023  Screenshot-Funktion hinzugefügt
0.24    03.02.2023  Temperatur-Graph in Status-Bildschirm
0.25    05.02.2023  State-Machine für Kaffee-Ausgabe implementiert -> Feature Stopp!
'''

version = 0.25

from machine import Pin, PWM, SPI, ADC, freq
from utime import ticks_ms, sleep_ms, ticks_diff
import framebuf
from math import sin, pi, log
import _thread
import gc
from micropython import mem_info
from sys import exit


class TFT_LCD_ILI9488(framebuf.FrameBuffer):
    '''
    Klasse zur Unterstützung des Waveshare 3.5" TFT-LCD Bildschirms mit ILI9488-Controller.
    '''

    def __init__(self, update_time):
        '''
        Initialisierung der TFT-LCD-Klasse. 
        
        Die Übertragung des Framebuffers von der CPU zum RAM des Bildschirms benötigt
        mindestens 125 ms, abhängig vom Clock des SPI-Bus. Empfohlen sind Werte von 
        250 ms (4 FPS) bis 500 ms (2 FPS).

        Argumente:      update_time     Aktualisierungs-Intervall in ms
        '''
        # Pinbelegung Waveshare 3.5" ILI9488 TFT Display
        LCD_DC   = 8
        LCD_CS   = 9
        LCD_SCK  = 10
        LCD_MOSI = 11
        LCD_MISO = 12
        LCD_RST  = 15
        self.LCD_BL   = 13

        self.RED   =  self.RGB888_to_RGB565(255, 0, 0)
        self.GREEN =  self.RGB888_to_RGB565(0, 255, 0)
        self.BLUE  =  self.RGB888_to_RGB565(0, 0, 255)
        self.WHITE =  0xffff
        self.BLACK =  0x0000
        self.BROWN =  self.RGB888_to_RGB565(168, 98, 0)
        self.DARK_BROWN =  self.RGB888_to_RGB565(135,62,35)
        self.LIGHT_BROWN =  self.RGB888_to_RGB565(247, 226, 200)
        self.ORANGE =  self.RGB888_to_RGB565(254, 127, 0)
        
        self.width = 240
        self.height = 160
        self.busy = False
        self.update_time = update_time
        self.update_tmark = ticks_ms()

        self.cs = Pin(LCD_CS,Pin.OUT)
        self.rst = Pin(LCD_RST,Pin.OUT)
        self.dc = Pin(LCD_DC,Pin.OUT)
        
        self.cs.on()
        self.dc.on()
        self.rst.on()
        self.spi = SPI(1,60_000_000,sck=Pin(LCD_SCK),mosi=Pin(LCD_MOSI),miso=Pin(LCD_MISO))

        self.title = "   --=| PyC0FFEE V{:4.2} |=--".format(version)
        self.line1 = ""
        self.line2 = ""
        self.line3 = ""
        self.graph_buffer_len = 200
        self.graph_buffer = []
        self.graph_buffer.extend(self.graph_buffer_len*(0,))

        self.buffer_tmp = bytearray(480 * 2)
        self.buffer = bytearray(self.height * self.width * 2)
        super().__init__(self.buffer, self.width, self.height, framebuf.RGB565)
        self.init_display()


    def write_cmd(self, buf):
        '''
        Überträgt Daten per SPI an das TFT-Display. Der erste Wert muss ein 
        gültiges Kommando sein, gefolgt von Datenwerten.
        
        Argumente:      buf     bytestring b'\xC5\x00\x1E\x80' oder List [0xC5, 0x00, 0x1E, 0x80]
        '''
        cmd = True
        for b in buf:
            self.cs.on()
            if cmd: 
                self.dc.off()
                cmd = False
            else:
                self.dc.on()
            self.cs.off()
            self.spi.write(bytearray([b]))
            self.cs.on()


    def init_display(self):
        '''
        Setzt das TFT-Display per Reset-Cycle in Ursprungszustand zurück und sendet dann 
        eine Initialisierungs-Sequenz für den Betriebsmodus mit RGB565-Farbraum und Anzeige
        im Queerformat.
        '''
        # Reset TFT Display
        self.rst.on()
        sleep_ms(5)
        self.rst.off()
        sleep_ms(10)
        self.rst.on()
        sleep_ms(5)
        # Initialisierungs-Sequenz an TFT-Display senden
        self.write_cmd(b'\x21')
        self.write_cmd(b'\xC2\x33')
        self.write_cmd(b'\xC5\x00\x1E\x80')
        self.write_cmd(b'\xB1\xB0')
        self.write_cmd(b'\x36\x28')
        self.write_cmd(b'\xE0\x00\x13\x18\x04\x0F\x06\x3A\x56\x4D\x03\x0A\x06\x30\x3E\x0F')
        self.write_cmd(b'\xE1\x00\x13\x18\x01\x11\x06\x38\x34\x4D\x06\x0D\x0B\x31\x37\x0F') 
        self.write_cmd(b'\x3A\x55')
        self.write_cmd(b'\x11')
        sleep_ms(120)
        self.write_cmd(b'\x29')
        self.write_cmd(b'\xB6\x00\x62')
        self.write_cmd(b'\x36\x28')


    def show(self):
        '''
        Setzt Spalten und Zeilen-Adresse auf 0 und überträgt den Framebuffer 
        in den Speicher des TFT-Displays.
        '''
        self.write_cmd(b'\x2A\x00\x00\x01\xdf') # Column Address 0 - 479: 0
        self.write_cmd(b'\x2B\x00\x00\x01\x3f') # Page Address 0 - 319: 0
        self.write_cmd(b'\x2C')                 # Memory Write (2Ch)
                
        self.cs.on()
        self.dc.on()
        self.cs.off()
        self.__write_framebuffer()
        self.cs.on()
        self.busy = False

    @micropython.viper  # type: ignore
    def __write_framebuffer(self):
        # 
        # Für schnellen Bytecode optimierte Sub-Routine der show-Methode
        # zur Skalierung und Übertragung des Framebuffers. Mehr als 20x 
        # schneller als konventioneller Python-Code!
        #
        cache1 = ptr16(self.buffer) # type: ignore
        cache2 = ptr16(self.buffer_tmp)  # type: ignore
        for y in range(0, 38400, 240):
            for x in range(0, 480, 2):
                cache2[x] = cache2[x+1] = cache1[y+(x>>1)]
            self.spi.write(self.buffer_tmp)
            self.spi.write(self.buffer_tmp)


    def update(self):
        '''
        Die Update-Methode muss ein Mal pro Durchlauf in der Main-Loop aufgerufen werden. 
        Sie aktualisiert den TFT-Bildschirm mit den aktuellen Status-Informationen wenn:
        - der Zeitintervall für die regelmässige Aktualisierung abgelaufen ist
        - keine manuell angeforderte Bildschirmaktualisierung aktiv ist
        
        Argumente:              keine
        '''
        if ticks_diff(ticks_ms(), self.update_tmark) > self.update_time and not self.busy:
            self.busy = True    # Status-Flag, gesetzt wenn Aktualisierung aktiv

            # Hintergrundbild laden und Titel schreiben
            self.loadPicture(0, 0, "cb_background_dark.pph")
            self.text(self.title,0,22,self.WHITE)
            # Statuszeilen in Framebuffer schreiben
            self.text(self.line1,20,40,self.WHITE)
            self.text(self.line2,20,50,self.WHITE)
            self.text(self.line3,20,60,self.WHITE)

            # Temperaturverlauf graphisch darstellen
            self.rect(19,79,202,62,self.LIGHT_BROWN)

            for i in range(self.graph_buffer_len-1):
                tval1 = int(limit(self.graph_buffer[i], 1, 119) / 2 +0.5)
                x1_pos = 20 + i
                y1_pos = self.height - 20 - tval1

                tval2 = int(limit(self.graph_buffer[i+1], 1, 119) / 2 +0.5)
                x2_pos = 20 + i + 1
                y2_pos = self.height - 20 - tval2

                self.line(x1_pos, y1_pos, x2_pos, y2_pos, self.ORANGE)

            if multi_threading_enabled:
                # Garbage Collector manuell ausführen um genügend Speicher bereitzustellen
                gc.collect()
                # unabhängigen Thread auf zweitem Core ausführen
                _thread.start_new_thread(self.show, ())
            else:
                # Single-Thread Bildschirmaktualisierung -> sehr CPU-intensiv, führt zu 
                # unregelmässiger Ausführung des Main-Loops
                self.show()
            self.update_tmark = ticks_ms() # Zeitmarker für Anzeige-Intervall aktualisieren


    def loadPicture(self, x_pos, y_pos, file_name, transparency=-1):
        '''
        Lädt Bilder im PPH-Format (RGB565) in den Framebuffer des TFT-Displays.

        Argumente:      x_pos, y_pos    X- und Y-Wert von Einfügeposition
                        file_name       Name der Bitmap-Datei (PPH-Format)
                        transparency    Farbwert, welcher Transparenz markiert
        '''
        with open(file_name, "r") as file:
            header = file.readline().split()

        magic_number = header[0]
        width, height, max_brightness = [eval(i) for i in header[1:]]

        # print("\nMagic Number =", magic_number, ", Width =", width, ", Height =", height, ", Max Brightness =", max_brightness, "\n")
        if (x_pos >= 0) and (y_pos >= 0) and (x_pos + width <= self.width) and (y_pos + height <= self.height):
            self.__copyPicture(x_pos, y_pos, file_name, width, height, magic_number, transparency)

    @micropython.viper # type: ignore
    def __copyPicture(self, x_pos:int, y_pos:int, file_name, width:int, height:int, magic_number, transparency:int):
        #
        # Für schnellen Bytecode optimierte Sub-Routine der loadPicture-Methode
        # zum Einlesen der Bilddaten. 12x schneller als konventioneller Python-Code!
        #
        if magic_number == "P6":
            with open(file_name, "rb") as file:
                file.readline()     # Erste Zeile mit Metadaten überspringen
                cache = ptr16(self.buffer) # type: ignore
                for y in range(height):
                    line = ptr16(file.read(width*2)) # type: ignore
                    for x in range(width):
                        pos = (y_pos + y)*240 + (x_pos + x) # Berechne aus x und y die Position im linearen Ziel-Array
                        color = line[x]                     # Aktueller Farbwert
                        if (color != transparency):         # Transparenz-Farbewert berücksichtigen
                            cache[pos] = color


    def screenshot(self, file_name='screenshot.ppm'):
        '''
        Speichert den aktuellen Framebuffer als Portable Pixmap Grafik-Datei (*.ppm) im Flash-Speicher.

        Argumente:      file_name   Datei-Name für das gespeicherte Bild.
        '''        
        with open(file_name, "wb") as file:
            header = bytes("P6 " + str(self.width) + " " + str(self.height) + " 255\n","ascii")
            file.write(header)
            
            for i in range(self.width * self.height):
                # read msb and lsb from framebuffer
                msb = self.buffer[i*2]
                lsb = self.buffer[i*2+1]

                # shift bit patterns to right place and fill missing bits with 1
                r = (msb & 0xF8) | 0x07
                g = ((msb & 0x07) << 5) | ((lsb & 0xE0) >> 3) | 0x03
                b = (lsb & 0x1F) << 3  | 0x07
 
                # write rgb tripple to file
                file.write(bytes([r, g, b])) # rgb = b'\xff\x80\x00'


    def bl_ctrl(self,duty):
        '''
        Setzt Helligkeit der Hintergrund-Beleuchtung.

        Argumente:      duty        Duty-Cycle 0-100%
        '''
        pwm = PWM(Pin(self.LCD_BL))
        pwm.freq(1000)
        if(duty>=100):
            pwm.duty_u16(65535)
        else:
            pwm.duty_u16(655*duty)


    def RGB888_to_RGB565(self, r, g, b):
        '''
        Wandelt einen 3-Byte RGB-Farbwert in einen 2-Byte RGB-Farbewert um. Der Framebuffer arbeitet
        im Little-Endian Format. Der Rückgabewert erfolgt in der Byte-Reihenfolge LSB/MSB und wird
        so in den Buffer übertragen.

            RGB565 Farb-Bitmuster
            Farbe   -Hex--    -MSB----- -LSB-----
            RED =   0x00F8  # 1111 1000 0000 0000
            GREEN = 0xE007  # 0000 0111 1110 0000
            BLUE =  0x1F00  # 0000 0000 0001 1111

        Argumente:      r, g, b     Drei Farbwerte von 0-254 für Rot, Blau und Grün
        Rückgabewert:               16-Bit Farbwert im RGB565-Format
        '''
        r = r & 0xF8
        g = (g & 0xE0) >>5 | (g & 0x1C) << 11
        b = (b & 0xF8) <<5

        return(r | g | b)


class BreathLED:
    '''
    Langsam pulsierende Status-LED. Unregelmässiger Helligkeitsverlauf deutet auf hohe
    CPU-Last oder blockierenden Programm-Code hin.
    '''

    def __init__(self, led_pin, duration = 1000):
        '''
        Initialisierung der Status-LED.

        Argumente:      led_pin     GPIO-Pin, an dem die LED angeschlossen ist
                        duration    Zeit für einen Zyklus in ms
        '''
        self.led_PWM = PWM(Pin(led_pin))
        self.led_PWM.freq(1000)
        self.breath_duration = duration
        self.breath_time = 0
        self.breath_tmark = ticks_ms()


    def update(self):
        ''' 
        Aktualisiert den Zustand der Breath-LED. Muss in der Main-Loop 
        ein Mal pro Durchlauf aufgerufen werden.
        '''
        self.breath_time += ticks_diff(ticks_ms(), self.breath_tmark)
        self.breath_tmark = ticks_ms()
        
        if self.breath_time > self.breath_duration:
            self.breath_time -= self.breath_duration

        pwm_value = int((sin(2*pi / self.breath_duration * self.breath_time) +1) * 65535/2)
        self.led_PWM.duty_u16(pwm_value)


class PushButton:
    '''
    Wertet die Tasten über Interrupts aus. Nach der Entprellung setzt der 
    Interrupt-Handler die Eigenschaft 'pressed' als Signal für die gedrückte 
    Taste.
    '''
 
    def __init__(self, pin, debounce_time):
        '''
        Initialiserung des Tasten-Objekts.

        Argumente:      pin             Nummer des verwendeten GPIO-Pins
                        debounce_time   minimale Zeit in ms, in der keine 
                                        Pegeländerung auftreten darf
        '''
        self.pin = Pin(pin, Pin.IN, Pin.PULL_DOWN)
        self.debounce_time = debounce_time
        self.pressed = False
        self.blocked = False
        self.debounce_tm = ticks_ms()

    def irq_handler(self, pin):
        '''
        IRQ-Handler zur Tastenauswertung. Wird über die IRQ-Methode von 
        MicroPython mit dem Interrupt verbunden:

        button.pin.irq(trigger=Pin.IRQ_RISING, handler=button.irq_handler)

        Argumente:      pin         Wird von MicroPython beim Aufruf übergeben
        '''
        if not self.pressed and not self.blocked:
            self.pressed = True
            self.blocked = True
            self.debounce_tm = ticks_ms()


    def debounce(self):
        '''
        Entprellung, wertet Mehrfachauslösung von Tasten aus (Debouncing).
        '''
        if self.pin.value() == 0 and self.blocked:
            if ticks_diff(ticks_ms(), self.debounce_tm) > self.debounce_time:
                self.blocked = False
        if self.pin.value() == 1:
            self.debounce_tm = ticks_ms()


    def clear(self):
        '''
        Setzt die Eigenschaft 'pressed' eines Tastenobjektes zurück. Wird 
        üblicherweise nach der Umsetzung des mit der Taste verbundenen 
        Programm-Codes zurückgesetzt.
        '''
        self.pressed = False


class FlowSensor:
    '''
    Wertet den Flüssigkeits-Volumen-Sensor über einen Interrupt aus. Der Sensor 
    liefert ~2000 Impulse pro 1000 ml. 
    '''

    def __init__(self, pin):
        '''
        Initialisierung des Sensor-Objekts.

        Argumente:      pin         GPIO-Pin, an dem der Sensor angeschlossen ist.
        '''
        self.pin = Pin(pin, Pin.IN)
        self.debounce_time = 0
        self.flow_count = 0
        self.flow_count_tm = ticks_ms()


    def get_count(self):
        '''
        Liefert die Anzahl gezählter Impulse seit der letzten Rücksetzung.

        Rückgabewert:               Anzahl Impulse (~2000 pro 1000 ml)
        '''
        return self.flow_count


    def reset(self):
        '''
        Setzt den Zähler auf Null zurück.
        '''
        self.flow_count = 0


    def irq_handler(self, pin):
        '''
        Interrupt-Handler für die Signalauswertung. Wird über die IRQ-Methode von 
        MicroPython mit dem Interrupt verbunden:

        flow_sensor.pin.irq(trigger=Pin.IRQ_RISING, handler=flow_sensor.irq_handler)

        Argumente:      pin         Wird von MicroPython beim Aufruf übergeben
        '''
        if ticks_diff(ticks_ms(), self.flow_count_tm) > self.debounce_time:
            self.flow_count += 1
            self.flow_count_tm = ticks_ms()


class FrontLED:
    '''
    Klasse zur Steuerung der in den Tasten integrierten LEDs.
    '''

    def __init__(self, pin):
        '''
        Initialisiert das LED-Objekt.

        Argumente:      pin         GPIO-Pin, an der die Kathode der LED angeschlossen 
                                    ist. (VCC)---|>|---[ R ]---(Open Drain)
        '''
        self.pin = Pin(pin, Pin.OPEN_DRAIN)


    def on(self):
        '''
        Aktiviert die LED.
        '''
        self.pin.low()


    def off(self):
        '''
        Schaltet die LED aus.
        '''
        self.pin.high()


    def toggle(self):
        '''
        Invertiert den aktuellen Zustand der LED.
        '''
        self.pin.toggle()


class WaterPump:
    '''
    Steuert die Wasserpumpe.
    '''

    def __init__(self, pin):
        '''
        Initialisiert das Objekt für die Wasser-Pumpe.

        Argumente:      pin     GPIO-Pin, über den die Pumpe gesteuert wird.
        '''
        self.pin = Pin(pin, Pin.OUT)
        self.__enabled = False


    def on(self):
        '''
        Aktiviert die Wasser-Pumpe.
        '''
        self.__enabled = True
        self.pin.high()


    def off(self):
        '''
        Schaltet die Wasser-Pumpe aus.
        '''
        self.__enabled = False
        self.pin.low()


    def get_state(self):
        '''
        Gibt den aktuellen Zustand der Wasser-Pumpe zurück.
        '''
        return (self.__enabled)


class WaterHeater:
    '''
    Klasse zur Steuerung des Heiz-Elements über PWM. Da der Pi Pico PWM
    in Hardware erst ab 7 Hz unterstützt, enthält die Klasse eine eigene 
    PWM-Implementierung. Zusammen mit einer Nulldurchgangs-Erkennung der 
    Leistungsstufe lassen sich so passende Wellenpakete für die Heizung
    erzeugen.

    Bei 50 Hz Netzfrequenz und einer Periodenndauer von 1000 ms entspricht
    ein Tastverhätnis von 10 % einem Paket von 5 Sinus-Vollwellen.
    '''

    def __init__(self, pin, cycle_time=1000):
        '''
        Initialisiert das Objekt für das Heizungs-Elements.

        Argumente:      pin         GPIO-Pin, welcher die Leistungsstufe steuert
                        cycle_time  Dauer einer PWM-Periode, Default = 1000 ms.

        '''
        self.__pin = Pin(pin, Pin.OUT)
        self.__pwm_cycle_time = cycle_time # ms
        self.__pwm_on_time = 0
        self.__pwm_duty_cycle = 0 # duty cycle in percent (0-100%)
        self.__pwm_cycle_begin_tm = ticks_ms()
        self.__pwm_enabled = False


    def on(self):
        '''
        Aktiviert die Ausgabe des PWM-Signals mit dem aktuell gesetzten 
        PWM-Tastverhältnis.
        '''
        self.__pwm_enabled = True


    def off(self):
        '''
        Deaktiviert die Ausgabe des PWM-Signals.
        '''
        self.__pwm_enabled = False
        self.__pin.low()


    def set_duty(self, duty_cycle):
        '''
        Setzt das Tastverhältnis des PWM-Signals. Die Ausgabe an die 
        Leistungsstufe erfolgt erst nach Aufruf der on-Methode.

        Argument:   duty_cycle      Tastverhältnis, 0-100%
        '''
        if 0 <= duty_cycle <= 100:
            duty_cycle = limit(duty_cycle, 0, 99) # max 99% to keep SecureGate re-triggered
            self.__pwm_on_time = int((self.__pwm_cycle_time/100)*duty_cycle)
            self.__pwm_duty_cycle = duty_cycle
        else:
            self.__pwm_on_time = 0
            self.__pwm_duty_cycle = 0


    def get_duty(self):
        '''
        Liefert das aktuell gesetzte Tastverhältnis zurück (int).
        '''
        return (self.__pwm_duty_cycle)


    def get_state(self):
        '''
        Liefert den aktuellen Zustand der Signal-Ausgabe zurück (bool).
        '''
        return (self.__pwm_enabled)


    def update(self):
        '''
        Aktualisiert das PWM-Signal. Wird über die Main-Loop aufgerufen. Für
        eine stabile Signalisierung sollte die Methode mindestens alle 100 ms
        ausgeführt werden.
        '''
        if self.__pwm_enabled:
            if ticks_diff(ticks_ms(), self.__pwm_cycle_begin_tm) < self.__pwm_on_time:
                self.__pin.high()
            else: 
                self.__pin.low()

        if ticks_diff(ticks_ms(), self.__pwm_cycle_begin_tm) >= self.__pwm_cycle_time:
            self.__pwm_cycle_begin_tm = ticks_ms()


class TempSensor:
    '''
    Diese Klasse wertet den vorgegebenen NTC-Temperaturfühler der Maschine aus.
    Statt über eine grafisch bestimmte Linearisierung wird die Temperatur unter
    Berücksichtigung der ausgemessenen Werte der Messschaltung und des NTC 
    berechnet.
    '''

    def __init__(self, adc_pin, R0, RT, R1, R2, VREF):
        '''
        Initialisierung des Temperatur-Sensor-Objekts. Für die Berechnung sind
        die tatsächlichen Werte der in der Schaltung eingesetzten Bauelemente
        notwendig.

        Argumente:      adc_pin     ADC-Eingang für die Messwerterfassung.
                        R0          Widerstand NTC @ 25°C
                        RT          Widerstand NTC @ 85°C
                        R1          Wert R1 aus Messschaltung [Ohm]
                        R2          Wert R2 aus Messschaltung [Ohm]
                        VREF        Referenz-Spannung des ADC
        '''
        self.__TF = 273.15             # Grad Kelvin bei 0° Celsius
        self.__ADC = ADC(adc_pin)
        self.__R0 = R0
        self.__RT = RT
        self.__R1 = R1
        self.__R2 = R2
        self.__VREF = VREF
        self.__temp = 25
        self.__read_sensor_interval = 100 # ms, Messintervall
        self.__read_sensor_avg_time = 300 # ms, berücksichtigter Zeitraum für Mittelwert
        self.__UadcList = []              # Liste der ADC-Messwerte
        # Anzahl Elemente der ADC-Messwert-Liste
        self.__UadcListLength = int(self.__read_sensor_avg_time/self.__read_sensor_interval)
        self.__read_sensor_tm = ticks_ms()

        #B(25°/85°)
        self.__T0 = 25 + self.__TF    # 25°C -> °K
        self.__T = 85 + self.__TF     # 85°C -> °K
        self.__B = (self.__T*self.__T0)/(self.__T0-self.__T) * log(self.__RT/self.__R0)


    def update(self):
        '''
        Aktualisiert die Temperatur-Berechnungen. Muss ein Mal pro Durchgang
        in der Main-Loop aufgerufen werden.
        '''
        if ticks_diff(ticks_ms(), self.__read_sensor_tm) > self.__read_sensor_interval:
            UADC = (self.__VREF / pow(2, 16)) * self.__ADC.read_u16()

            if len(self.__UadcList) >= self.__UadcListLength:
                del self.__UadcList[0]
            
            self.__UadcList.append(UADC)
            UADC = sum(self.__UadcList)/len(self.__UadcList)

            if UADC != 0:
                RNTC = 1 / (1 / ((self.__R2*VREF)/UADC - self.__R2) - 1/self.__R1) * 1.03 # * calibration factor to match real value to measured value 
            else:
                RNTC = 99999

            self.__temp = 1 / (log(RNTC/self.__R0)/self.__B + 1/self.__T0) - self.__TF
            self.__read_sensor_tm = ticks_ms()


    def get_temp(self):
        '''
        Liefert die aktuell ermittelte Temperatur in °C zurück.
        '''
        return self.__temp


class LoopCounter:

    def __init__(self):
        self.__loop_count_start = ticks_ms()
        self.__loop_duration = 1000 # ms
        self.__loop_start = ticks_ms()
        self.__loop_times = []

    def update(self):
        if ticks_diff(ticks_ms(), self.__loop_count_start) < self.__loop_duration:
            self.__loop_times.append(ticks_diff(ticks_ms(), self.__loop_start))
            self.__loop_start = ticks_ms()
        else:
            print("{:d} loops\t".format(len(self.__loop_times)), end='')
            print("{:d} ms min\t".format(min(self.__loop_times)), end='')
            print("{:d} ms max\t".format(max(self.__loop_times)), end='')
            print("{:.1f} ms avg".format(sum(self.__loop_times)/len(self.__loop_times)))
            self.__loop_times.clear()
            self.__loop_start = ticks_ms()
            self.__loop_count_start = ticks_ms()


class LogOutput:
    '''
    Bereitet diverse Mess- und Status-werte für eine regelmässige Ausgabe auf der Konsole
    oder für die Übernahme in die Log-Datei auf. 
    '''

    def __init__(self, interval):
        '''
        Initialisierung des Log-Objektes.

        Argumente:      interval    Ausgabe-Intervall in ms.
        '''
        self.__disp_log_tm = ticks_ms()
        self.__disp_interval = interval
        self.__disp_header_done = False
        self.__log_data = []
        self.__new_data = False


    def update(self, show = True):
        '''
        Aktualisiert alle Log-Werte im definierten Zeitintervall. Muss ein 
        Mal pro Durchgang in der Main-Loop aufgerufen werden.

        Argumente:      show    True = Ausgabe auf Konsole
        '''
        if ticks_diff(ticks_ms(), self.__disp_log_tm) > self.__disp_interval:
            if self.__disp_header_done == False and show:
                # Spaltenbeschriftung der Konsolen-Ausgabe
                print(" Time\tPump\tHeater\t Duty\t Temp\t  Xa\t   P\t   I\t   D\tRAM  \tStatus")
                self.__disp_header_done = True
            
            # Aufbau der Ausgabe-Zeile
            self.__log_data.clear()
            self.__log_data.append("{:5d}".format(int(ticks_ms()/1000)))
            self.__log_data.append("{:3.d}".format(int((lambda x: "1" if x else "0")(water_pump.get_state()))))
            self.__log_data.append("{:3.d}".format(int((lambda x: "1" if x else "0")(water_heater.get_state()))))
            self.__log_data.append("{:5.1f}".format((lambda x: water_heater.get_duty() if x else 0)(water_heater.get_state())))
            self.__log_data.append("{:6.2f}".format(temp_sensor.get_temp()))
            self.__log_data.append("{:5.1f}".format(heater_PID.output))
            self.__log_data.append("{:5.1f}".format(heater_PID.P_value))
            self.__log_data.append("{:5.1f}".format(heater_PID.I_value))
            self.__log_data.append("{:5.1f}".format(heater_PID.D_value))
            self.__log_data.append("{:3.d}".format(int(gc.mem_free()/1024)))
            self.__log_data.append((lambda x: "OVERTEMP!" if x else "")(overtemp))

            # Graph-Buffer aktualisieren
            LCD.graph_buffer.pop(0)
            LCD.graph_buffer.append(int(temp_sensor.get_temp()))

            # Fall aktiv, Ausgabe der Werte auf Konsole im definierten Zeitintervall
            if show:
                for i in range(len(self.__log_data)):
                    print(self.__log_data[i] + "\t", end='')
                print()
            
            self.__new_data = True
            self.__disp_log_tm = ticks_ms()


    def new_data(self):
        '''
        Prüft, ob seit letzter Abfrage neue Werte vorliegen.

        Argumente:      keine
        Rückgabewert:   True, wenn neue Werte anleigen, sonst False
        '''
        if self.__new_data == True:
            self.__new_data = False
            return True
        else:
            return False


    def get_data(self):
        '''
        Liefert Liste mit allen Werten zurück, z.B. zur Speicherung in einer 
        Datei über die Methoden der Klasse Log2File.

        Argumente:      keine
        Rückgabewert:   Liste mit aktuellen Log-Werten.
                        [Time, Pump, Heater, Duty, Temp, Xa, P, I, D, RAM, Status]
        '''
        return self.__log_data


class Log2File:
    '''
    Klasse: log2disk.py

    Schreibt Log-Daten in Datei.
    '''

    def __init__(self, fname="log.txt", headline='', delimiter=";", max_entries=0, append=False):
        '''
        Initialisierung: x = log2disk(fname = "logname.txt", fpath = ".")

        Argumente:  fname          Name der Logdatei
                    fpath          Pfad der Logdatei
                    delimiter      Standardwert = '|'
                    max_entries    Standardwert 0 = Endlos-Aufzeichnung
                    append         True = Fügt Datein bestehendem Log an
        '''
        self.__log_filename = fname
        self.__log_delimiter = delimiter
        self.__max_entries = max_entries  # 0 = keine Limitierung
        self.__log_entries = 0

        # Falls Daten nicht angefügt werden sollen, 
        # Datei neu erstellen und Kopfzeilen einfügen.
        if not append:
            try:
                with open(self.__log_filename, "w", encoding='utf-8') as f:
                    f.write(headline + "\n")
            except OSError:
                print("OSError: Error creating logfile!")

        # Falls doch, Anzahl schon bestehender Einträge ermitteln.
        else:
            with open(self.__log_filename, "r", encoding='utf-8') as f:
                self.__log_entries = len(f.readlines())-3


    def writeln(self, logdata):
        '''
        Schreibt aktuelle Werte in Log-Datei.

        Argumente:  logdata         Log-Einträge als Liste.
        '''
        # Falls maximale Anzahl Einträge erreicht, vor Schreiben von neuem Eintrag 
        # den ersten Eintrag entfernen. Wenn max_entries = 0: Keine Limitierung.
        if (self.__max_entries != 0 and self.__log_entries >= self.__max_entries):
            self.removeFirstLogEntry()

        logtext=""
        for i in range(len(logdata)):
            logtext = logtext + logdata[i] + self.__log_delimiter

        with open(self.__log_filename, "a", encoding='utf-8') as f:
            f.write(logtext + "\n")

        self.__log_entries +=1


    def removeFirstLogEntry(self):
        '''
        Entfernt ersten Log-Eintrag aus Log-Datei. Wird bei rollender Aufzeichnung
        vor dem Anfügen eines neuen Eintrages aufgerufen.

        Argumente:          keine
        '''
        with open(self.__log_filename, "r", encoding='utf-8') as f:
            log_lines = f.readlines()
        
        with open(self.__log_filename, "w", encoding='utf-8') as f:
            for log_entry_count, log_line in enumerate(log_lines):
                if (log_entry_count != 1):
                    f.write(log_line)


class PID:
    '''
    Klasse eines einfachen PID-Kontrollers. 
    http://brettbeauregard.com/blog/2011/04/improving-the-beginners-pid-introduction/
    
    '''

    def __init__(self, set_point, Kp=3, Ki=0.01, Kd=0.0, sample_time=1000):
        '''
        Initialisiert das PID-Objekt.

        Argumente:      set_point       Sollwert, z.B. Zieltemperatur
                        Kp              Proportionaler Beiwert, Default = 3
                        Ki              Integraler Beiwert, Default = 0.01
                        Kd              Differenzieller Beiwert, Default = 0
                        sample_time     Zeitintervall zwischen zwei Berechnungen
        '''

        self.sample_time = sample_time

        self.Kp, self.Ki, self.Kd = Kp, Ki*(self.sample_time/1000), Kd/(self.sample_time/1000)
        self.P_value, self.I_value, self.D_value = 0, 0, 0
        
        self.out_max =  100     # = 100% PWM
        self.out_min =    0     # =   0% PWM

        self.manual_mode = True
        self.set_point = set_point
        self.prev_value = 0
        self.current_value = 0
        self.last_error = 0
        self.output = 0

        self.__new_output = False
        self.last_update_time = ticks_ms()


    def set(self, Kp, Ki, Kd):
        '''
        Setzt bei Bedarf neue PID-Werte. Dann sinvoll, wenn eine Strecke sich 
        je nach Betriebszustand sehr unterschiedlich verhält. Z.B. mit und ohne
        starker Wärmeabführung.
        '''
        self.Kp, self.Ki, self.Kd = Kp, Ki*(self.sample_time/1000), Kd/(self.sample_time/1000)


    def update(self, input):
        """
        Berechnet im vorgegebenen Intervall eine neue Stellgrösse. Die Update-
        Methode muss mindestens ein Mal pro Zeitintervall über die Main-Loop
        aufgerufen werden.

        Argumente:      input   Istwert, aktuelle Rückführgrösse
        """

        if ticks_diff(ticks_ms(), self.last_update_time) > self.sample_time:

            if self.manual_mode == False:
                
                # Regeldifferenz, d.h. Abweichung zwischen Sollwert und Istwert berechnen
                self.current_value = input
                error = self.set_point - self.current_value
                
                # neue Stellgrösse berechnen
                self.P_value = self.Kp * error                                  # Abweichung * Kp
                self.I_value += self.Ki * error                                 # Integralanteil nachführen
                self.I_value = limit(self.I_value, self.out_min, self.out_max)  # Anti-Windup von I
                self.D_value = self.Kd * (self.current_value - self.prev_value) # Differenzanteil aus Steigung * Kd bestimmen
                self.output = self.P_value + self.I_value - self.D_value        # Stellgrösse = Summe aller Korrekturfaktoren
                self.output = limit(self.output, self.out_min, self.out_max)    # Stellgrösse limitieren (0-100%)

                # Aktuelle Werte für nächste Berechnung merken
                self.prev_value = self.current_value
                self.last_error = error
                self.last_update_time=ticks_ms()

            self.__new_output = True


    def set_manual_mode(self, manual_mode=False):
        '''
        Wird der Aktor (z.B. Heizelement) manuell deaktiviert, sollte auch
        der PID-Regler in den manuellen Modus geschaltet werden, um ein
        ungünstiges Hochlaufen der Regeldifferenz zu verhindern.
        Bei Wiederaufnahme der Berechnung startet der PID-Regler mit dem
        aktuellen Istwert und eingeschränktem Integralteil.

        Argument:       manual_mode     True = kontinuierliche Berechnung
                                        False = Nachführung ausgesetzt
        '''
        if manual_mode == False:
            self.prev_value = self.current_value
            self.I_term = limit(self.output, self.out_min, self.out_max)
            self.manual_mode = False
        else:
            self.manual_mode = True


    def new_output(self):
        '''
        Prüft, on eine neue Stellgrösse vorliegt.

        Argumente:      keine
        Rückgabewert:   True, wenn neue Stellgrösse, sonst False
        '''
        if self.__new_output == True:
            self.__new_output = False
            return True
        else:
            return False


def limit(value, minimum, maximum):
    '''
    Limitiert einen beliebigen Wert auf einen definierten Bereich.

    Argumente:      value       zu prüfender Wert
                    minimum     Minimalwert
                    maximum     Maximalwert

    Rückgabewert:   Minimum <= Wert <= Maximum
    '''
    return (maximum if value > maximum else minimum if value < minimum else value)



# initialize objects

LCD = TFT_LCD_ILI9488(1000)

status_led = BreathLED(14, 2000) # Pin, time in ms
log_output = LogOutput(1000) # interval in ms

debounce_time = 60
btn_left = PushButton(0, debounce_time) # Pin, debonce time in ms
btn_right = PushButton(1, debounce_time) # Pin, debonce time in ms
led_left = FrontLED(2) # Pin
led_right = FrontLED(3) # Pin

flow_sensor = FlowSensor(7) # Pin
water_pump = WaterPump(6) # Pin
water_heater = WaterHeater(4, 1000) # Pin, cycle time in ms

# bind input pins and irq handlers
btn_left.pin.irq(trigger=Pin.IRQ_RISING, handler=btn_left.irq_handler)
btn_right.pin.irq(trigger=Pin.IRQ_RISING, handler=btn_right.irq_handler)
flow_sensor.pin.irq(trigger=Pin.IRQ_RISING, handler=flow_sensor.irq_handler)

loop_counter = LoopCounter()

#------------- temperature sensor settings ------------
R0 = 96288              # NTC "610" @ 25°C
RT = 8969               # NTC "610" @ 85°C
R1 = 829700             # 2. lower limit, less impact to upper limit, lower R -> lower T
R2 = 32582              # 1. upper limit, lower R, higher R -> lower T  
VREF = 3.274 * 0.995    # exact value * correction factor to calibrate real value vs. measured value

temp_sensor = TempSensor(26, R0, RT, R1, R2, VREF)
setpoint = 90 # Target water temperature


#--------------------PID------------------------------
Tu = 13     # s
Ti = 20     # s

dX = 20     # °C
dT =  4     # s
dY =  1     # 1 = 100% PWM
#Ki = dX / (dT/dY)
#Ki = 1 / Ti

Kp = 0.4 * (Ti/Tu)
Tn = 3.2 * Tu
Tv = 0.8 * Tu

Kp = 1
Ki = 0
Kd = 0

print("Sp = {:.d}   Kp = {:.1f}   Ki = {:.3f}   Kd = {:.3f}\n". format(setpoint, Kp, Ki, Kd))
heater_PID = PID(setpoint, Kp, Ki, Kd, 1000)


#--temperature log file------------------------------------------------
headline = "Time;Pump;Heater;Duty;Temp;Xa;P;I;D;RAM;Status"
headline += ";Sp = {:.d};Kp = {:.1f};Ki = {:.3f}; Kd = {:.3f}".format(setpoint, Kp, Ki, Kd)
logdata = Log2File("templog.csv", headline, delimiter=";", max_entries=300, append=False)


#--System Init---------------
freq(180_000_000)   # type: ignore
print("Clock Speed: {:3.d} MHz".format(int(freq()/1000000)))
print("Memory free: {:3.d} KBytes".format(int(gc.mem_free()/1024)))
mem_info()
print()

overtemp = False
multi_threading_enabled = True

#--------------------------- M A I N -------------------------------------------
def main():
    '''
    Main-Loop für uController

    '''
    global overtemp

    LCD.loadPicture(0, 0, "title_screen_little.pph")
    LCD.text("Version " + str(version),8,50,LCD.BROWN)
    LCD.show()
    #LCD.screenshot()
    sleep_ms(3000)

    # Zustandsmaschine initialisieren
    state = 'init'
    transition = True
    sm_tmark = ticks_ms()
    serving_done = False
    output_count_heated = 0
    output_count_unheated = 0

    #------------- uC Loop ----------------------------------
    while True:

        status_led.update()
        btn_right.debounce()
        btn_left.debounce()
        temp_sensor.update()
        water_heater.update()
        #log_output.update(show=True)
        log_output.update(show=False)
        #loop_counter.update()

        if not LCD.buffer: # Ahhhhhhhhhhhhhhhhhhhhhhhhhhhh!
            if log_output.new_data():
                logdata.writeln(log_output.get_data())

        LCD.update()

        heater_PID.update(temp_sensor.get_temp())
        if heater_PID.new_output():
            water_heater.set_duty(heater_PID.output)
        
        if btn_left.pressed:
            water_heater.off()
            heater_PID.set_manual_mode(True)
            if water_pump.get_state() == False:
                water_pump.on()
                led_left.on()
            else:
                water_pump.off()
                led_left.off()
            btn_left.clear()

        ### STATE MACHINE ####################################################

        if state == 'init': #-------------------------------------------------
            
            # Zustand initialisieren
            if transition:
                transition = False

            water_heater.set_duty(0)
            water_heater.off()
            water_pump.off()
            heater_PID.set_manual_mode(True)
            led_right.off()

            # Zustandswechsel einleiten
            transition = True
            state = 'standby'

        elif state == 'standby': #--------------------------------------------

            # Zustand initialisieren
            if transition:
                water_heater.set_duty(0)
                water_heater.off()
                water_pump.off()
                heater_PID.set_manual_mode(True)
                sm_tmark = ticks_ms()
                transition = False

            if ticks_diff(ticks_ms(), sm_tmark) > 1000:
                led_right.toggle()
                sm_tmark = ticks_ms()

            # Zustandswechsel einleiten
            if btn_right.pressed:
                transition = True
                state = 'heating'
                btn_right.clear()

        elif state == 'heating': #--------------------------------------------

            # Zustand initialisieren
            if transition:
                sm_tmark = ticks_ms()
                print("PID setzen: (Auf-)Heizen")
                heater_PID.set(Kp, Ki, Kd)
                heater_PID.set_manual_mode(False)
                water_heater.on()
                transition = False

            if temp_sensor.get_temp() <= setpoint - 5:
                if ticks_diff(ticks_ms(), sm_tmark) > 500:
                    led_right.toggle()
                    sm_tmark = ticks_ms()
            else:
                led_right.on()

            # Zustandswechsel einleiten
            if (temp_sensor.get_temp() > setpoint - 5) and btn_right.pressed:
                transition = True
                state = 'serving'
                btn_right.clear()

        elif state == 'serving': #--------------------------------------------

            # Zustand initialisieren
            if transition:
                sm_tmark = ticks_ms()
                print("PID setzen: Ausgabe")
                heater_PID.set(6, 0, 0)
                flow_sensor.reset()
                serving_done = False
                print("Pump on")
                water_pump.on()
                output_volume = 180 # coffee volume in ml
                cool_down_volume = 10 
                output_count_heated = 2000 / 1000 * (output_volume - cool_down_volume) # flow sensor: 2000 pulses per 1000 ml
                output_count_unheated = 2000 / 1000 * output_volume # flow sensor: 2000 pulses per 1000 ml
                transition = False

            if ticks_diff(ticks_ms(), sm_tmark) > 500:
                print(".", end="")
                sm_tmark = ticks_ms()

            # Normale Ausgabe mit Nachheizen
            if water_heater.get_state() == True and flow_sensor.get_count() > output_count_heated:
                print("\nHeater off")
                heater_PID.set_manual_mode(True)
                water_heater.off()

            # Ausgabe ohne weitere Heizenergie -> Überschiessen der Temperatur verhindern
            if flow_sensor.get_count() > output_count_unheated:
                print("\nPump off")
                water_pump.off()
                serving_done = True

            # Zustandswechsel einleiten
            if serving_done:
                transition = True
                state = 'heating'

        elif state == 'error': #----------------------------------------------

           # Zustand initialisieren
            if transition:
                transition = False

            print("Unknown Error!")

            # Zustandswechsel einleiten
            transition = True
            state = 'init'

        else:
            # unerwarteter Zustand, Programm sofort beenden
            water_heater.off()
            water_pump.off()
            print("Unexpected state, terminate program...")
            exit()

        ######################################################################

        # EMERGENCY CUT OFF
        if temp_sensor.get_temp() > 100:
            heater_PID.set_manual_mode(True)
            water_heater.off()
            overtemp = True


        LCD.line1 = "Pmp   " + (lambda x: " on" if x else "off")(water_pump.get_state())
        LCD.line1 += "   Htr   " + (lambda x: " on " if x else "off")(water_heater.get_state())
        LCD.line2 = "Dty " + "{:5.1f}".format(water_heater.get_duty())
        LCD.line2 += "   Tmp " + "{:5.1f}".format(temp_sensor.get_temp())
        LCD.line3 = "Flw " + "{:3d}".format(flow_sensor.get_count()) + "     S: " + state


if __name__ == "__main__":
    main()

