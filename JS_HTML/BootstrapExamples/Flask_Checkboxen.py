# app.py
from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def form():
    # Data for checkboxes and list box options
    checkboxes = [
        {'id': 'option1', 'label': 'Newsletter abonnieren', 'checked': True},
        {'id': 'option2', 'label': 'Benachrichtigungen erhalten', 'checked': False},
        {'id': 'option3', 'label': 'Angebote und Aktionen erhalten', 'checked': True},
        {'id': 'option4', 'label': 'Teilnahme an Umfragen', 'checked': False}
    ]
    listbox_options = [
        {'value': 'category1', 'label': 'Technologie'},
        {'value': 'category2', 'label': 'Gesundheit'},
        {'value': 'category3', 'label': 'Bildung'},
        {'value': 'category4', 'label': 'Unterhaltung'}
    ]
    return render_template('Flask_Checkboxen.html', checkboxes=checkboxes, listbox_options=listbox_options)

if __name__ == '__main__':
    app.run(debug=True)
