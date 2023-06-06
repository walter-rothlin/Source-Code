from flask import Flask, render_template, request, redirect, url_for, session, flash

app = Flask(__name__)
app.secret_key = 'mein_geheimes_schluessel'
#Code durch Chat-GPT überprüfen und teilweise Verbesserungen Implementiert.
@app.route('/')
def home():
    return render_template('index.html', username=session.get('username'))

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html', username=session.get('username'))

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        if len(password) > 5:
            session['username'] = username
            return redirect(url_for('home'))
    return render_template('index.html')

@app.route('/logout')
def logout():
    session.pop('username', None)
    return redirect(url_for('home'))

@app.route('/adress_liste')
def adress_liste():
    if 'username' not in session:
        flash('Bitte loggen Sie sich ein, um die Adressliste zu sehen.')
        return redirect(url_for('home'))
    return render_template('adress_liste.html', username=session['username'])

@app.route('/passwort_vergessen', methods=['GET', 'POST'])
def passwort_vergessen():
    if request.method == 'POST':
        email = request.form.get('email')
        
        # Simulierter E-Mail - Print in der Konsole
        print(f"Passwort-Wiederherstellung für Email: {email}")
        
        return redirect(url_for('home'))
    
    return render_template('passwort_vergessen.html')

@app.route('/registrieren', methods=['GET', 'POST'])
def registrieren():
    if request.method == 'POST':
        anrede = request.form.get('anrede')
        vorname = request.form.get('vorname')
        nachname = request.form.get('nachname')
        email = request.form.get('email')
        password = request.form.get('password')
        
        
        # Simulierter E-Mail - Print in der Konsole
        print(f"Registrierungsinformationen:\nAnrede: {anrede}\nVorname: {vorname}\nNachname: {nachname}\nEmail: {email}\nPasswort: {password}")
        
        return redirect(url_for('home'))
    
    return render_template('registrieren.html')


if __name__ == '__main__':
    app.run(debug=True)
