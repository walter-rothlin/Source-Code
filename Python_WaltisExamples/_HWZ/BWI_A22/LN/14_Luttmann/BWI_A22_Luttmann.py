from flask import Flask, render_template, request, redirect, url_for, session
from datetime import timedelta

app = Flask(__name__)
app.secret_key = 'geheime_sitzungsschluessel'
app.permanent_session_lifetime = timedelta(minutes=30)

@app.route('/')
def home():
    return render_template('index.html')

@app.route('/kontakt', methods=['GET', 'POST'])
def kontakt():
    if request.method == 'POST':
        return render_template('kontakt.html', success=True)
    return render_template('kontakt.html')

@app.route('/login', methods=['POST'])
def login():
    email = request.form.get('email')
    password = request.form.get('password')
    if password and len(password) > 5:
        session.permanent = True
        session['email'] = email
        return redirect(url_for('home'))
    return render_template('index.html', error="Ihr Passwort muss länger als 5 Zeichen sein.")

@app.route('/logout')
def logout():
    session.pop('email', None)
    return redirect(url_for('home'))

@app.route('/adress_liste')
def adressen():
    if 'email' in session:
        return render_template('adress_liste.html')
    return redirect(url_for('home'))

@app.route('/forgot_password', methods=['POST'])
def forgot_password():
    return redirect(url_for('home'))

@app.route('/register', methods=['POST'])
def register():
    password = request.form.get('password')
    if not password or len(password) <= 5:
        return render_template(
            'index.html',
            register_error="Passwort muss länger als 5 Zeichen sein.",
            open_modal="register"
        )
    return redirect(url_for('home'))

@app.context_processor
def inject_user():
    return dict(logged_in='email' in session, user_email=session.get('email'))

if __name__ == '__main__':
    app.run(debug=True)
