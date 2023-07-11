#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Web_Stammdaten_Manager.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Stammdaten_Manager/Web_Stammdaten_Manager.py
#
# Description: FLASK Web-Applikation for Maintaining Stammdaten
#
#
# Autor: Walter Rothlin
#
# History:
# 18-Mar-2023   Walter Rothlin      Initial Version
# 21-Jun-2023   Walter Rothlin      Migration to Production
#
# ------------------------------------------------------------------
from Genossame_Common_Defs import *

from flask import Flask, render_template, request, url_for, request, redirect
## from flask_restful import Resource, Api
### from flask_sqlalchemy import SQLAlchemy


# ----------------------------------------------------------------------------
# Web End-Points
# ----------------------------------------------------------------------------
app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/person_details/<int:id>', methods=['GET', 'POST'])
def person_details(id):
    rs = genossame.get_person_details_from_DB_by_ID(id=id)
    # print(rs)
    return render_template('person_details.html', details=rs[0])


@app.route('/adresslist/<string:search_criterium>', methods=['GET', 'POST'])
def adresslist(search_criterium):
    rs = genossame.get_person_details_from_DB_by_ID(search_criterium=search_criterium)
    print(rs)
    return render_template('personen_liste.html', result_liste=rs)


if __name__ == '__main__':
    genossame = Stammdaten()

    app.run(debug=True, host='127.0.0.1', port=5002)
