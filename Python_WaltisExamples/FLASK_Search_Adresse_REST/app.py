from flask import Flask, render_template, request, jsonify
import requests


app = Flask(__name__)

# Dummy address database
ADDRESSES = [
  {"id": 123, "strasse": "Peterliwiese", "hausnummer": "33", "plz": "8855", "ort": "Wangen", "land": "CH"},
  {"id": 124, "strasse": "Peterliwiese", "hausnummer": "34", "plz": "8855", "ort": "Wangen", "land": "CH"},
  {"id": 125, "strasse": "Hauptstrasse", "hausnummer": "1", "plz": "8000", "ort": "Zürich", "land": "CH"},
  {"id": 126, "strasse": "Hauptstrasse", "hausnummer": "2", "plz": "8000", "ort": "Zürich", "land": "CH"},
  {"id": 127, "strasse": "Bahnhofstrasse", "hausnummer": "10", "plz": "8001", "ort": "Zürich", "land": "CH"},
  {"id": 128, "strasse": "Bahnhofstrasse", "hausnummer": "12", "plz": "8001", "ort": "Zürich", "land": "CH"},
  {"id": 129, "strasse": "Limmatquai", "hausnummer": "3", "plz": "8001", "ort": "Zürich", "land": "CH"},
  {"id": 130, "strasse": "Limmatquai", "hausnummer": "5", "plz": "8001", "ort": "Zürich", "land": "CH"},
  {"id": 131, "strasse": "Seestrasse", "hausnummer": "20", "plz": "8700", "ort": "Küsnacht", "land": "CH"},
  {"id": 132, "strasse": "Seestrasse", "hausnummer": "21", "plz": "8700", "ort": "Küsnacht", "land": "CH"},
  {"id": 133, "strasse": "Bahnhofplatz", "hausnummer": "1", "plz": "9000", "ort": "St. Gallen", "land": "CH"},
  {"id": 134, "strasse": "Bahnhofplatz", "hausnummer": "2", "plz": "9000", "ort": "St. Gallen", "land": "CH"},
  {"id": 135, "strasse": "Marktgasse", "hausnummer": "5", "plz": "9000", "ort": "St. Gallen", "land": "CH"},
  {"id": 136, "strasse": "Marktgasse", "hausnummer": "6", "plz": "9000", "ort": "St. Gallen", "land": "CH"},
  {"id": 137, "strasse": "Rathausstrasse", "hausnummer": "3", "plz": "5000", "ort": "Aarau", "land": "CH"},
  {"id": 138, "strasse": "Rathausstrasse", "hausnummer": "4", "plz": "5000", "ort": "Aarau", "land": "CH"},
  {"id": 139, "strasse": "Hirschengraben", "hausnummer": "8", "plz": "3011", "ort": "Bern", "land": "CH"},
  {"id": 140, "strasse": "Hirschengraben", "hausnummer": "9", "plz": "3011", "ort": "Bern", "land": "CH"},
  {"id": 141, "strasse": "Kramgasse", "hausnummer": "15", "plz": "3011", "ort": "Bern", "land": "CH"},
  {"id": 142, "strasse": "Kramgasse", "hausnummer": "16", "plz": "3011", "ort": "Bern", "land": "CH"},
  {"id": 143, "strasse": "Rosenweg", "hausnummer": "1", "plz": "4051", "ort": "Basel", "land": "CH"},
  {"id": 144, "strasse": "Rosenweg", "hausnummer": "2", "plz": "4051", "ort": "Basel", "land": "CH"},
]


port = 6001
BACKEND_SEARCH_URL = "http://localhost:6001/search_address"


def remove_duplicate_ids(addresses):
    """
    Entfernt doppelte Einträge basierend auf der 'id'.
    Behalte nur das erste Vorkommen jeder ID.
    """
    seen_ids = set()
    unique_addresses = []
    for addr in addresses:
        if addr["id"] not in seen_ids:
            unique_addresses.append(addr)
            seen_ids.add(addr["id"])
    return unique_addresses


@app.route("/search_address")
def search_address():
    print(f"search_address: q={request.args.get('q','')}")
    q = request.args.get("q", "").lower()
    if not q:
        return jsonify([])

    q_part = q.split(" ")
    filtered_addresses = []
    for addrn in ADDRESSES:
        addr_str = f"{addrn['strasse']} {addrn['hausnummer']} {addrn['plz']} {addrn['ort']} {addrn['land']}".lower()
        part_found = True
        for part in q_part:
            if part not in addr_str:
                part_found = False

        if part_found:
            filtered_addresses.append(addrn)

    return remove_duplicate_ids(filtered_addresses)


@app.route("/")
def index():
    return render_template("index.html")

@app.route("/api/search")
def api_search():
    print(f"api_search: q={request.args.get('q','')}")
    q = request.args.get("q", "")
    if not q:
        return jsonify([])

    response = requests.get(
        BACKEND_SEARCH_URL,
        params={"q": q},
        timeout=3
    )

    return jsonify(response.json())

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=port, debug=False, use_reloader=False)
