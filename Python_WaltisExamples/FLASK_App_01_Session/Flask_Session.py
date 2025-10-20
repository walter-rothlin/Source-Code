#!/usr/bin/python

# ------------------------------------------------------------------
# Name  : Flask_Session.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/FLASK_App_01/Flask_Session.py
#
# Description: FLASK Web-Applikation with Sessions (Login)
# https://www.geeksforgeeks.org/how-to-use-flask-session-in-python-flask/
#
#
# Autor: Walter Rothlin
#
# History:
# 17-Apr-2023   Walter Rothlin      Initial Version
# 20-Oct_2025   Walter Rothlin      Refactored for HBU PY2
#
# ------------------------------------------------------------------
from flask import Flask, render_template, request, url_for, request, redirect, session


app = Flask(__name__)
app.secret_key = 'super secret key'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"


@app.route("/")
def index():
    if not session.get("name"):
        return redirect("/login")
    return render_template('index.html')


@app.route("/login", methods=["POST", "GET"])
def login():
    if request.method == "POST":
        session["name"] = request.form.get("name")
        return redirect("/")
    return render_template("login.html")


@app.route("/logout")
def logout():
    session["name"] = None
    return redirect("/")


if __name__ == "__main__":
    app.run(debug=True)
