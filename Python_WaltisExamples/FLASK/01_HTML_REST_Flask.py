#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : 01_HTML_REST_Flask.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/FLASK/01_HTML_REST_Flask.py
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
from flask import Flask, render_template, url_for, request, redirect

app = Flask(__name__)



# Response produced by String-Oberations
# ======================================
@app.route('/')
def index():
    return '''
    <H1>Welcome requester on index-page!</H1>
    Some links to static pages or fully produced response text:</BR>
    <UL>
        <LI>Source-Code: <A href='https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/FLASK/01_HTML_Flask.py'>This FLASK application</A></LI>
        <LI>Just a Link: <A href='http://www.fh-hwz.ch'>Link to another external page</A></LI>
        <LI>From this FLASK App: <A href='/emojiOverview'>Page with Emojis</A></LI>
        <LI>Echo-Page :<A href='/echo?lastName=Rothlin&firstName=Walti'>HTML-Page with request-parameters</A></LI>
    </UL>
    </BR>
    Links to this Applications (other endpoints):</BR>
    <UL>
        <LI>Static-Page: <A href='/get_static_page?filename=static/html/index_static.html'>static/html/index_static.html:</A></LI>
        <LI>Parsed Template-Page: <A href='/get_parsed_template?filename=index_template.html'>index_template.html:</A></LI>
        <LI>Parsed Template-Page: <A href='/get_parsed_template?filename=table_template.html'>table_template.html:</A></LI>
        <LI>Parsed Template-Page with parameters: <A href='/adresslist/Roth'>table_template.html:</A></LI>
        <LI>REST Request / JSON Response: <A href='/simple_REST?firstName=Felix&lastName=Muster'>JSON response with parameter</A></LI>
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

@app.route('/echo', methods=['GET', 'POST'])
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


# Response read from static file
# ==============================
@app.route('/get_static_page', methods=['GET', 'POST'])
def get_static_page():
    filename = request.args.get("filename")
    print("get_static_page():", filename)
    if filename is None:
        filename = 'static/html/index_static.html'
    '''
    # read file into string variable
    text_file = open(filename, "r")
    file_content = text_file.read()
    text_file.close()
    '''

    # read file into string variable
    with open(filename) as text_file:
        file_content = text_file.read()

    # print(file_content)
    return file_content


# Response Using Templats (
# ==============================
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


# Response as JSON Structure
# ==========================
@app.route('/simple_REST', methods=['GET', 'POST'])
def simple_REST():
    lastName = request.args.get("lastName")
    firstName = request.args.get("firstName")

    rs = {'Title:': 'Turnverein',
          'adress_data':
              [
                  {'key': 1, 'lastName': 'Rothlin'    , 'firstName': 'Walter'},
                  {'key': 2, 'lastName': 'Meier'      , 'firstName': 'Max'},
                  {'key': 3, 'lastName': 'Roth'       , 'firstName': 'Josef'},
                  {'key': 4, 'lastName': 'Bamert'     , 'firstName': 'Fritz'},
                  {'key': 5, 'lastName': 'Schnellmann', 'firstName': 'Daniel'}
              ]
         }
    rs['adress_data'].append({'key': 6, 'lastName': lastName, 'firstName': firstName})

    return rs, 200, {'Etag': 'some-opaque-string'}




# =========================================================
# main
# =========================================================
if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)
