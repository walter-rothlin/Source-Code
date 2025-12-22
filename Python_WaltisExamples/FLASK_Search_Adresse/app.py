from flask import Flask, render_template, request, jsonify

app = Flask(__name__)

# Dummy address database
ADDRESSES = [
    "Peterliwiese 33, 8855 Wangen",
    "Bahnhofstrasse 1, 8001 Zürich",
    "Seestrasse 10, 8702 Zollikon",
    "Hauptstrasse 5, 8853 Lachen",
    "Industriestrasse 12, 8604 Volketswil",
    "Poststrasse 7, 9000 St. Gallen",
]

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/search")
def search():
    query = request.args.get("q", "").lower()
    results = [a for a in ADDRESSES if query in a.lower()]
    return jsonify(results)

if __name__ == "__main__":
    app.run(debug=True)
