from flask import Flask, render_template, request, redirect, url_for, flash, session

# Initialize Flask application
app = Flask(__name__)

# Set secret key for session management and flash messages
app.secret_key = 'your-secret-key-here'

# Routes
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/adress_liste')
def adress_liste():
    if 'email' not in session:
        flash('Bitte loggen Sie sich ein, um die Adress-Liste zu sehen.')
        return redirect(url_for('index'))
    return render_template('adress_liste.html')

@app.route('/login', methods=['POST'])
def login():
    email = request.form['email']
    password = request.form['password']
    # New requirement: password must be longer than 5 characters
    if len(password) > 5:
        session['email'] = email
        flash('Erfolgreich eingeloggt!')
        return redirect(url_for('index'))
    else:
        flash('Das Passwort muss länger als 5 Zeichen sein!')
        return redirect(url_for('index'))

@app.route('/logout')
def logout():
    session.pop('email', None)
    flash('Sie wurden erfolgreich ausgeloggt.')
    return redirect(url_for('index'))

@app.route('/password_reset', methods=['POST'])
def password_reset():
    email = request.form['email']
    # Simulate sending a password reset email
    # In a real application, you would generate a token and send an email with a reset link
    flash(f'Eine E-Mail zum Zurücksetzen des Passworts wurde an {email} gesendet.')
    return redirect(url_for('index'))

@app.route('/register', methods=['POST'])
def register():
    anrede = request.form['anrede']
    first_name = request.form['first_name']
    last_name = request.form['last_name']
    email = request.form['email']
    password = request.form['password']
    
    # In a real application, you would validate the data and store it in a database
    flash('Registrierung erfolgreich! Bitte loggen Sie sich ein.')
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5001) 