from flask import Flask, render_template, request, redirect, url_for, session, flash
import re

app = Flask(__name__)
app.secret_key = 'geheim123'

@app.route('/', methods=['GET', 'POST'])
@app.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
            flash("Ungültige E-Mail-Adresse.", "danger")
            return redirect(url_for('home', modal='login'))

        if (len(password) < 6 or
            not re.search(r"[a-z]", password) or
            not re.search(r"[A-Z]", password) or
            not re.search(r"[0-9]", password)):
            flash("Passwort entspricht nicht den Anforderungen.", "danger")
            return redirect(url_for('home', modal='login'))

        session['email'] = email
        return redirect(url_for('home'))

    return render_template('index.html')


@app.route('/kontakt', methods=['GET', 'POST'])
def kontakt():
    if request.method == 'POST':
        name = request.form.get('name')
        nachricht = request.form.get('nachricht')

        if name and nachricht:
            flash(f"Vielen Dank, {name}! Wir haben deine Nachricht erhalten und melden uns bald bei dir.", "success")
        else:
            flash("Bitte fülle alle Felder aus, bevor du das Formular absendest.", "danger")

        return redirect(url_for('kontakt'))

    return render_template('kontakt.html')



@app.route('/adress_liste')
def adress_liste():
    # if 'email' not in session:
    #    flash("Bitte logge dich zuerst ein, um die Adressliste zu sehen.", "warning")
    #    return redirect(url_for('home'))
    return render_template('adress_liste.html')

@app.route('/logout')
def logout():
    session.pop('email', None)
    return redirect(url_for('home'))

@app.route('/forgot-password', methods=['POST'])
def forgot_password():
    flash("Ein Link zum Zurücksetzen deines Passworts wurde per E-Mail versendet.", "info")
    return redirect(url_for('home'))

@app.route('/register', methods=['POST'])
def register():
    email = request.form['email']
    password = request.form['password']

    if not re.match(r"[^@]+@[^@]+\.[^@]+", email):
        flash("Ungültige E-Mail-Adresse.", "danger")
        return redirect(url_for('home', modal='register'))

    if (len(password) < 6 or
        not re.search(r"[a-z]", password) or
        not re.search(r"[A-Z]", password) or
        not re.search(r"[0-9]", password)):
        flash("Passwort muss mindestens 6 Zeichen lang sein und Gross-/Kleinbuchstaben sowie Zahlen enthalten.", "danger")
        return redirect(url_for('home', modal='register'))

    flash("Ein Registrierungs-Link wurde an deine E-Mail-Adresse gesendet.", "success")
    return redirect(url_for('home'))

if __name__ == '__main__':
    app.run(debug=True)
