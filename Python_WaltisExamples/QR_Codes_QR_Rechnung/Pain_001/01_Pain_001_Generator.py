
'''
https://www.six-group.com/dam/download/banking-services/standardization/sps/ig-credit-transfer-sps2022-de.pdf
https://www.six-group.com/dam/download/banking-services/interbank-clearing/de/standardization/iso/swiss-recommendations/archives/implementation-guidelines-ct/implementation-guidelines-ct_v1_7_1.pdf
https://github.com/sebastienrousseau/pain001
'''

from datetime import datetime
import  pain001.core as pain

if __name__ == '__main__':
  xml_message_type = 'pain.001.001.03'
  xml_file_path = 'template.xml'
  xsd_file_path = 'schema.xsd'
  csv_file_path = 'data.csv'
  pain.xml_generator
  main(xml_message_type, xml_file_path, xsd_file_path, csv_file_path)

'''
from pain_generator import PainGenerator

# Erstellen Sie eine Instanz des PainGenerator
generator = PainGenerator()

# Füllen Sie die erforderlichen Felder aus
generator.set_sender("Ihr Name", "Ihre Adresse")
generator.set_receiver("Name des Zahlungsempfängers", "Adresse des Zahlungsempfängers", "IBAN des Zahlungsempfängers")
generator.set_amount(100.00, "CHF")
generator.set_purpose("Verwendungszweck der Zahlung")

# Erstellen Sie die Zahlungsdatei
file_name = "Zahlungsdatei_" + datetime.now().strftime("%Y%m%d%H%M%S") + ".xml"
generator.generate(file_name)
'''