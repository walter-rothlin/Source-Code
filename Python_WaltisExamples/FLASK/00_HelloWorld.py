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
from flask import Flask, request, render_template

app = Flask(__name__)

class State():
    def __init__(self):
        self.__req_count = 0

    def inc(self):
        self.__req_count += 1

    def get_req_count(self):
        return str(self.__req_count)

@app.route('/')
def index():
    state.inc()
    return '''
    <H1>Home End-Point (index)</H1>
    <UL>
        <LI><A href="/Hallo">Hallo</A></LI>
        <LI><A href="/Reihe">Reihe</A></LI>
        <LI><A href="/Reihe?start_point=5">Reihe?start_point=5</A><BR/></LI>
    </UL> 
    <UL>    
        <LI><A href="/JSON">JSON</A><BR/></LI>
    </UL> 
    <UL>     
        <LI><A href="/get_static_page">get_static_page</A></LI>
        <LI><A href="/get_parsed_template">get_parsed_template</A></LI>
        <LI><A href="/adresslist/Rothlin">adresslist</A></LI>
    </UL>
    '''

@app.route('/Hallo')
def hello():
    state.inc()
    return 'Guten <B>Abend</B> Studenten'

@app.route('/Reihe')
def zahlenreihe():
    state.inc()
    start_point = request.args.get("start_point")
    if start_point is None:
        start_point = '0'
    ret_string = '<H1>Zahlenreihe ' + state.get_req_count() + '</H1>'
    ret_string += 'start_point:' + start_point + "<BR/>"
    ret_string += '<table>'
    for i in range(int(start_point), int(start_point) + 10):
        ret_string += '''
        <TR>
            <TD>''' + str(i)    + '''      </TD>
            <TD>''' + str(i**2) + '''      </TD>
        </TR>'''
    ret_string += '</table>'
    return ret_string

@app.route('/JSON')
def return_json():
    return {
             'Name': 'Rothlin',
             'Vorname': 'Walti'
            }

@app.route('/get_static_page', methods=['GET', 'POST'])
def get_static_page():
    filename = request.args.get("filename")
    # print("get_static_page():", filename)
    if filename is None:
        filename = 'static/html/index_static.html'

    # read file into string variable
    with open(filename) as text_file:
        file_content = text_file.read()

    # print(file_content)
    return file_content

@app.route('/get_parsed_template')
def get_parsed_template():
    filename = request.args.get("filename")
    print("get_static_page():", filename)
    if filename is None:
        filename = 'index_template.html'
    return render_template(filename)


@app.route('/adresslist/<string:search_criterium>', methods=['GET', 'POST'])
def adresslist(search_criterium):
    rs = [{'nachname': 'Rothlin'    , 'vorname': 'Walter'},
          {'nachname': 'Meier'      , 'vorname': 'Max'},
          {'nachname': 'Roth'       , 'vorname': 'Josef'},
          {'nachname': 'Bamert'     , 'vorname': 'Fritz'},
          {'nachname': 'Schnellmann', 'vorname': 'Daniel'}]
    print(rs)
    return render_template('table_template.html', result_liste=rs, search_criterium=search_criterium)
# =========================================================
# main
# =========================================================
if __name__ == '__main__':
    state = State()
    app.run(debug=True, host='127.0.0.1', port=5001)
