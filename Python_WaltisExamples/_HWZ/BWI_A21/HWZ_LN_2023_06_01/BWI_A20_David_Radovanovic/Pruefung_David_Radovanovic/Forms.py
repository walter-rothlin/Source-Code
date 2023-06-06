#Author: David Radovanovic
#Datum: 01.06.2023
#Fach: BWI-A20-6 Distributed und Mobile Systems
#Prüfung.
################################################################################################

from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, BooleanField, SelectField
from wtforms.validators import DataRequired, Length, Email, EqualTo, InputRequired
from wtforms import ValidationError

#Mail überprüfen ob @ / .  Symbol enthalten ist.
def contains_at_symbol(form, field):
    if '@' not in field.data:
        raise ValidationError('Muss @ enthalten.')
    if '.' not in field.data:
        raise ValidationError('Must . enthalten.')

class RegistrationForm(FlaskForm):
    anrede_options = [('Herr', 'Herr'), ('Frau', 'Frau')]
    anrede = SelectField('Anrede', choices=anrede_options, validators=[InputRequired()])
    vorname = StringField('Vorname', validators=[DataRequired(), Length(min=2, max=20)])
    nachname = StringField('Nachname', validators=[DataRequired(), Length(min=2, max=30)])
    #E-MAIL Validation konnte nicht sauber geladen werden.
    email = StringField('Email', validators=[DataRequired(), contains_at_symbol])
    password = PasswordField('Passwort', validators=[DataRequired()])
    confirm_password = PasswordField('Erneut Passwort', validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Registrieren')


#Login field kann kopiert werden vom Registration. Felder die gebraucht werden, sollten gleich bleiben.
class LoginForm(FlaskForm):
    email = StringField('Email', validators=[DataRequired()])
    password = PasswordField('Passwort', validators=[DataRequired()])
    remember = BooleanField('Remember Me')
    submit = SubmitField('Login')