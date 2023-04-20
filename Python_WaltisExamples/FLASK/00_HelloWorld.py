#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 00_HelloWorld.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/FLASK/00_HelloWorld.py
#
# Description: FLASK Web-Applikation
# https://flask-restful.readthedocs.io/en/latest/quickstart.html#a-minimal-api
#
#
# Autor: Walter Rothlin
#
# History:
# 20-Apr-2023   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
from flask import Flask

app = Flask(__name__)

@app.route('/')
def index():
    return 'Hallo HWZ'

# =========================================================
# main
# =========================================================
if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
