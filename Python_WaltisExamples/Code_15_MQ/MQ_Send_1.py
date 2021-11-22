#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: MQ_Send_1.py
#
# Description: Sends a hard-coded Message via an MQ
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
import pika

qName = "HWZ"

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.queue_declare(queue=qName)
channel.basic_publish(exchange='', routing_key=qName, body='Hello World!!????!')
print(" [x] Sent 'Hello World!!!!!'")
connection.close()
