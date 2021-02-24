import smtplib
from email.MIMEMultipart import MIMEMultipart
from email.MIMEText import MIMEText

senderEmail = "jp42@gmx.de"
empfangsEmail = "samuel.brinasdfasdfkmann@googlemail.com"
msg = MIMEMultipart()
msg['From'] = senderEmail
msg['To'] = empfangsEmail
msg['Subject'] = "Deine Pflanze verdurstet"

emailText = "Diese E-Mail kommt von deinem <b>Raspberr</b> Pi"
msg.attach(MIMEText(emailText, 'html'))

server = smtplib.SMTP('mail.gmx.net', 587)  # Die Server Daten
server.starttls()
server.login(senderEmail, "deinPasswort")   # Das Passwort
text = msg.as_string()
server.sendmail(senderEmail, empfangsEmail, text)
server.quit()