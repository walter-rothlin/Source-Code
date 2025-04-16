from flask import Flask, render_template, request, session, redirect

app = Flask(__name__)
app.secret_key = 'geheimnis'
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"


anrede_default='Frau'

@app.route('/', methods=['GET', 'POST'])
def index():
    # 1. Hole Anrede aus dem Request (POST oder GET)
    anrede = request.form.get("anrede") or request.args.get("anrede")

    # 2. Falls übergeben, in Session speichern
    if anrede:
        session['anrede'] = anrede

    # 3. Hole Anrede aus Session, wenn vorhanden
    anrede = session.get('anrede', anrede_default)

    adress_liste = [
        {'nachname': 'Rothlin', 'vorname': 'Walter'},
        {'nachname': 'Meier', 'vorname': 'Max'},
        {'nachname': 'Roth', 'vorname': 'Josef'},
        {'nachname': 'Bamert', 'vorname': 'Fritz'},
        {'nachname': 'Schnellmann', 'vorname': 'Daniel'}
    ]

    return render_template('BWI_A22_IndexPage.html', stadt_name='<B>Bern</B>', anrede=anrede, adress_liste=adress_liste)
@app.route('/Hallo')
def hello():
    return 'Hallo BWI-A22'

@app.route('/JSON')
def get_JSON():
    return {'Name': 'Rothlin', 'Vorname': 'Walter'}

@app.route('/redirect')
def redir():
    print('redirect() called!!!')
    return redirect("http://www.hwz.ch")

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=5001)