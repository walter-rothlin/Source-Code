# BWI_A21_Derrer.py
from flask import Flask, render_template, url_for, flash, redirect, session, request
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired, Email

app = Flask(__name__)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
app.config['SECRET_KEY'] = '308eec5128ace6f03673588b1c21a6f5'

class LoginForm(FlaskForm):
    email = StringField('Email', validators=[DataRequired(), Email()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Login')

@app.route('/')
@app.route('/home')
def home():
    return render_template('index.html')

@app.route('/kontakt')
def kontakt():
    return render_template('kontakt.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        if form.email.data == form.password.data:  # Simple check: password must match email
            session['email'] = form.email.data
            flash('You have been logged in!', 'success')
            return redirect(url_for('home'))
        else:
            flash('Login unsuccessful. Please check email and password', 'danger')
    return render_template('login.html', title='Login', form=form)

@app.route('/logout')
def logout():
    session.pop('email', None)
    flash('You have been logged out!', 'info')
    return redirect(url_for('home'))

@app.route('/adress')
def adress():
    if 'email' not in session:
        flash('Please log in to view this page', 'danger')
        return redirect(url_for('login'))
    return render_template('adress_liste.html')

if __name__ == '__main__':
    app.run(debug=True, port=5050)
