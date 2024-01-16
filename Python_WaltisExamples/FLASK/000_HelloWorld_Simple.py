#!/usr/bin/python3

from flask import Flask, request, render_template
app = Flask(__name__)

@app.route('/')
def index():
    return 'Hallo World!!!!'

# =========================================================
# main
# =========================================================
if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
