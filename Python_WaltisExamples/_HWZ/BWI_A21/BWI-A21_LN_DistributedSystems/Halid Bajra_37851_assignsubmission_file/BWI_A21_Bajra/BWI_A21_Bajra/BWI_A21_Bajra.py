from flask import Flask, render_template, request, redirect, url_for, session, jsonify

app = Flask(__name__, static_folder='static')
app.secret_key = 'supersecretkey'


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')


@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']
    password = request.form['password']
    if email == password:
        session['user'] = email
        return jsonify({'success': True, 'message': 'Du wurdest erfolgreich eingeloggt'})
    else:
        return jsonify({'success': False, 'message': 'Passwort muss gleich sein wie E-Mail'})


@app.route('/logout', methods=['POST'])
def logout():
    session.pop('user', None)
    return jsonify({'success': True, 'message': 'Du wurdest erfolgreich ausgeloggt'})


@app.route('/adress_liste')
def adress_liste():
    if 'user' in session:
        addresses = [
            {'name': 'Halid Bajra', 'address': 'Birchstrasse 5, 8156 Oberhasli'},
            {'name': 'Edin Sabani', 'address': 'Baslerstrasse 41, 8048 Zürich'}
        ]
        return render_template('adress_liste.html', addresses=addresses)
    return redirect(url_for('index'))


@app.route('/forgot_password', methods=['POST'])
def forgot_password():
    email = request.form['email']
    return jsonify(
        {'success': True, 'message': 'Link zum zurücksetzen des Passwort wurde an deiner E-Mail-Adresse gesendet'})


@app.route('/register', methods=['POST'])
def register():
    salutation = request.form['salutation']
    firstname = request.form['firstname']
    lastname = request.form['lastname']
    email = request.form['email']
    password = request.form['password']
    if email != password:
        return jsonify({'success': False, 'message': 'Passwort muss gleich sein wie E-Mail'})
    return jsonify({'success': True, 'message': 'Du wurdest erfolgreich registriert, ein Mail wurde versendet'})


if __name__ == '__main__':
    app.run(debug=True)
