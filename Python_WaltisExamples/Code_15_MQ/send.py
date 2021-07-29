#!/usr/bin/python3

# Send via MQ
# -----------
# https://www.rabbitmq.com/tutorials/tutorial-one-python.html
# Install first https://www.rabbitmq.com/install-windows.html#installer

import pika

connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
channel = connection.channel()

channel.queue_declare(queue='hello')

channel.basic_publish(exchange='', routing_key='hello', body='Hello World!!!!!!')
print(" [x] Sent 'Hello World!!!!!'")
connection.close()
