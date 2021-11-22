#!/usr/bin/python3

# ------------------------------------------------------------------
# Name: MQ_Receive_1.py
#
# Description: Receives a hard-coded Message via an MQ
#
# Receive via MQ
# --------------
# https://www.rabbitmq.com/tutorials/tutorial-one-python.html
# Install first https://www.rabbitmq.com/install-windows.html#installer
#
# Autor: Walter Rothlin
#
# History:
# 22-Nov-2021   Walter Rothlin      Initial Version
# ------------------------------------------------------------------
from waltisLibrary import *

import pika, sys, os

def waitForMsg(qName="HWZ"):
    connection = pika.BlockingConnection(pika.ConnectionParameters(host='localhost'))
    channel = connection.channel()

    channel.queue_declare(queue=qName)

    def callback(ch, method, properties, body):
        print(getTimestamp(), end=' ')
        print(" Received:%r" % body.decode())

    channel.basic_consume(queue=qName, on_message_callback=callback, auto_ack=True)

    print(' Waiting for messages on queue=', qName, '. To exit press CTRL+C', sep='')
    channel.start_consuming()

if __name__ == '__main__':
    try:
        waitForMsg()
    except KeyboardInterrupt:
        print('Interrupted')
        try:
            sys.exit(0)
        except SystemExit:
            os._exit(0)
