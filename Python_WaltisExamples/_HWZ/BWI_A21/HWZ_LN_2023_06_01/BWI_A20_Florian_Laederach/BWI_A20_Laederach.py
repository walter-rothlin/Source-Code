# Running this: Type into Terminal: $env:FLASK_APP = "Flaskblog.py" , and then: flask run
# Or start Flask in Debug mode, see end of code for that

# render_template enables using the separate HTML files, url_for enables using a separate CSS file
# flash enables flash-messages, redirect enables redirection, session is for logging in
from flask import Flask, render_template, url_for, flash, redirect, session
app = Flask(__name__)

# Import the Form classes from separate forms.py File
from forms import LoginForm

# Secret Key for Login, Secret key generated with python command: secrets.token_hex(16), 16 means 16 bytes
app.config['SECRET_KEY'] = 'f3672a60343b9475267a1dce3ba777bf'

# Dummy Posts for content on Welcome Page
posts = [
    {
        'author': 'Florian Laederach',
        'title': 'Welcome to my site',
        'content': 'First Post Content',
        'date_posted': 'May 27, 2023'
    },
    {
        'author': 'John Doe',
        'title': 'Blog Post 2',
        'content': 'Second Post Content',
        'date_posted': 'May 28, 2023'
    }
]


@app.route("/")
@app.route("/home")
def home():
    return render_template('index.html', title='Home', posts=posts)


@app.route("/kontakt")
def kontakt():
    return render_template('kontakt.html', title='Kontakt')


@app.route("/adressen")
def adressen():
    return render_template('adress_liste.html', title='Adressen')


@app.route("/login", methods=['GET', 'POST'])
def login():
    form = LoginForm()
    # Check if the Form validated, flash the appropriate message and redirect to Home page if successfully
    # 'success' and 'danger' are a Bootstrap Styles
    # Dummy data is used for credentials: Email = admin@blog.com, Password = password
    # Copied from Corey Schafer https://www.youtube.com/@coreyms
    if form.validate_on_submit():
        if form.email.data == 'admin@flask.com' and form.password.data == 'password':
            flash('You have been logged in!', 'success')
            # Set the session data to logged in
            session['logged_in'] = True
            return redirect(url_for('home'))
        else:
            flash('Login Unsuccessful. Please check credentials', 'danger')
    return render_template('login.html', title='Login', form=form)


@app.route('/authenticated')
def authenticated():
    # Set the 'logged_in' key in session to True
    session['logged_in'] = True
    return redirect(url_for('home'))


@app.route('/logout')
def logout():
    # Remove the 'logged_in' key from session
    session.pop('logged_in', None)
    return redirect(url_for('home'))


# This activates Debug Mode whenever Flask is run on localhost
# With this you can run this flask with: python .\Flaskblog.py
if __name__ == '__main__':
    app.run(debug=True)
