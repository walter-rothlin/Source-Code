#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01_HTML_Flask.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/FLASK/01_HTML_Flask.py
#
# Description: FLASK Web-Applikation
# https://flask-restful.readthedocs.io/en/latest/quickstart.html#a-minimal-api
#
#
# Autor: Walter Rothlin
#
# History:
# 30-Dec-2021   Walter Rothlin      Initial Version
#
# ------------------------------------------------------------------
from flask import Flask, request

app = Flask(__name__)

@app.route('/')
def index():
    return '''<H1>Hello Requester!</H1>
    Einige Links zur Applikation:</BR>
    <UL>
        <LI><A href='/emojiOverview'>Page mit Emojis</A></LI>
        <LI><A href='/echo?lastName=Rothlin&firstName=Walti'>HTML-Page with parameter</A></LI>
        <LI><A href='/rest?firstName=Felix&lastName=Muster'>JSON response with parameter</A></LI>
    </UL>
    '''

@app.route('/emojiOverview')
def emojiOverview():
    responseHtml = '''
            <H1>Page mit &#129322; &#129323; &#129324;</H1>
            <A target="_new" href="https://unicode-table.com/de/emoji/smileys-and-emotion/">Emoji-Seite</A></BR>
    '''
    for i in range(127000, 129999):
        responseHtml += f'<A href="/singleEmoji?htmlCode={i}">&#{i};</A>'

    return responseHtml

@app.route('/singleEmoji')
def singleEmoji():
    emojiHTML_code = request.args.get("htmlCode")
    responseHtml = f'''
            <H1>&#{emojiHTML_code};</H1>
    '''
    responseHtml += "HTML: &amp;#{eCode:1s};".format(eCode=emojiHTML_code)

    return responseHtml

@app.route('/echo', methods = ['GET', 'POST'])
def echo():
    args = request.args
    responseHtml = '''
    <!DOCTYPE html>
    <html>
    <head>
    <style>
    table, th, td {
      border: 1px solid black;
      border-collapse: collapse;
    }
    </style>
    </head>
    <body>
    <H1>Parameters passed</H1>
    <table border="1" cellspace="0">
    <tr>
      <th>Parameter-Name</th>
      <th>Parameter-Value</th>
    </tr>
    '''
    for k, v in args.items():
        responseHtml += f"<tr><td>{k}</td><td>{v}</td></tr>"
    responseHtml += '</table>'
    return responseHtml

@app.route('/rest', methods = ['GET', 'POST'])
def REST():
    lastName = request.args.get("lastName")
    firstName = request.args.get("firstName")
    noName = request.args.get("noName")
    return {'Key': 'Value', 'lastName': lastName, 'firstName': firstName, 'noName': noName}, 200, {'Etag': 'some-opaque-string'}

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
