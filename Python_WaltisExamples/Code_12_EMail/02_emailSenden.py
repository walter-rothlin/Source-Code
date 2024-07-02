import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

# Email account credentials
sender_email = r"landwirtschaft@genossame-wangen.ch"   # walter@rothlin.com"
receiver_email = r"walter@rothlin.com"
password = "peterli33"

# Set up the MIME
message = MIMEMultipart()
message['From'] = sender_email
message['To'] = receiver_email
message['Subject'] = "Test Email an walter@rothlin.com"

# Body of the email
body = "Hello, this is a test email sent from Python!"
message.attach(MIMEText(body, 'plain'))

try:
    # Connect to the server and login
    server = smtplib.SMTP('rothlin.com', 587)
    server.starttls()  # Upgrade the connection to a secure encrypted SSL/TLS connection
    server.login(r"walter@rothlin.com", password)

    # Send the email
    text = message.as_string()
    server.sendmail(sender_email, receiver_email, text)

    print("Email sent successfully!")
except Exception as e:
    print(f"Failed to send email: {e}")
finally:
    # Close the connection to the server
    server.quit()
