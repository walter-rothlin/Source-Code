#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Web_Stammdaten_Manager.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Stamdaten_Manager/Web_Stammdaten_Manager.py
#
# Description: FLASK Web-Applikation for Maintaining Stammdaten
#
#
# Autor: Walter Rothlin
#
# History:
# 18-Mar-2023   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
from waltisLibrary import *

from flask import Flask, render_template, request, url_for, request, redirect
from flask_restful import Resource, Api
### from flask_sqlalchemy import SQLAlchemy

import mysql.connector
import sqlparse
import csv
import json
from openpyxl import load_workbook

class Stammdaten:
    def __init__(self, host='localhost', schema='stammdaten', user='App_User_Stammdaten', password='1234ABCD12abcd', trace=True):
        if trace:
            print("Connecting to " + schema + "@" + host + "....", end="", flush=True)
        db_connection = mysql.connector.connect(
              host        = host,
              user        = user,
              password    = password,
              database    = schema,
              auth_plugin = 'mysql_native_password'
        )
        if trace:
            print("completed!")
        self.__db_connection = db_connection


    def get_person_details_from_DB_by_ID(self, id=None, search_criterium=None, attr_list=['*']):
        fieldStr = (',\n            ').join(attr_list)

        if id is None:
            if search_criterium is None:
                sql = """
                    SELECT
                        """ + fieldStr + """
                    FROM Personen_Daten
                    Limit 0,20;
                """
            else:
                sql = """
                    SELECT
                        """ + fieldStr + """
                    FROM Personen_Daten
                    WHERE Such_Begriff LIKE '%""" + search_criterium + """%';
                """
        else:
            sql = """
            SELECT
                """ + fieldStr + """
            FROM Personen_Daten 
            WHERE ID = """ + str(id) + """;
            """
        print(sql)
        mycursor = self.__db_connection.cursor(dictionary=True)
        mycursor.execute(sql)
        return mycursor.fetchall()

    def get_version(self):
        return("V1.0.0.0")

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

    app.run(debug=True, host='127.0.0.1', port=5001)
