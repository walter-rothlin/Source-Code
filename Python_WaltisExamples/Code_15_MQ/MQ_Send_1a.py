#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: MQ_Send_1a.py
#
# Description: Sends a Message via an MQ
#
# Send via MQ
# -----------
# https://www.rabbitmq.com/tutorials/tutorial-one-python.html
# Install first https://www.rabbitmq.com/install-windows.html#installer
#
# Autor: Walter Rothlin
#
# History:
# 22-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from waltisLibrary import *
import pika

qName = "HWZ"

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.queue_declare(queue=qName)

msg = 'Hello World!!????!'
while msg != "":
    msg = input("Nachricht:")
    channel.basic_publish(exchange='', routing_key=qName, body=msg)
    print(getTimestamp(), end=' ')
    print(" Sent:", msg, sep='')
connection.close()
