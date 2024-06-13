from flask import Flask, render_template, request, redirect, url_for, session, jsonify

app = Flask(__name__)
app.secret_key = 'your_secret_key'

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/contact')
def contact():
    return render_template('contact.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        if password == email:
            session['user'] = email
            return jsonify(success=True)
        return jsonify(success=False)
    return render_template('login.html')

@app.route('/logout', methods=['POST'])
def logout():
    if request.form.get('confirm') == 'yes':
        session.pop('user', None)
    return redirect(url_for('index'))

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        email = request.form['email']
        return jsonify(success=True, message=f'Registration email sent to {email}')
    return render_template('register.html')

@app.route('/password_reset', methods=['GET', 'POST'])
def password_reset():
    if request.method == 'POST':
        email = request.form['email']
        return jsonify(success=True, message=f'Password reset email sent to {email}')
    return render_template('password_reset.html')

@app.route('/adress_liste')
def adress_liste():
    if 'user' not in session:
        return redirect(url_for('index'))
    addresses = [
        {'name': 'John Doe', 'address': '1234 Main St', 'city': 'Anytown', 'state': 'CA', 'zip': '12345'},
        {'name': 'Jane Doe', 'address': '5678 Second St', 'city': 'Othertown', 'state': 'TX', 'zip': '67890'}
    ]
    return render_template('adress_liste.html', addresses=addresses)

if __name__ == '__main__':
    app.run(debug=True)
