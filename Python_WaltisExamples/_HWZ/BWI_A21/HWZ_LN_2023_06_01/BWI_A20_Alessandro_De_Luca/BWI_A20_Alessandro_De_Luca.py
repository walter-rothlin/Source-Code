from flask import Flask, render_template, request, session, redirect, url_for

app = Flask(__name__)
app.secret_key = 'doesitevenmatter?'


@app.route('/')
def index():
    username = session.get('email')
    return render_template('index.html', username=username)


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        if len(password) > 5:
            session['email'] = email
            return redirect(url_for('index'))
        else:
            return render_template('login.html', message='Invalid password. Please try again with a minimum of 5 characters.')

    return render_template('login.html')


@app.route('/logout')
def logout():
    session.pop('email', None)
    return redirect(url_for('index'))


@app.route('/adress-list')
def adress_liste():
    username = session.get('email')
    if 'email' not in session:
        return redirect(url_for('login'))
   
    return render_template('adress_list.html', username=username)


@app.route('/contact')
def contact():
    username = session.get('email')
    return render_template('contact.html', username=username)


if __name__ == '__main__':
    app.run(debug=True)