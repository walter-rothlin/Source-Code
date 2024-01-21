import pytest
from RESTService import app

@pytest.fixture
def client():
    with app.test_client() as client:
        yield client

def test_status_endpoint(client):
    response = client.get('/status')
    assert response.status_code == 200
    assert response.is_json
    data = response.get_json()

    # Schlüsel prüfen (Wird leider bei jedem wieder anders sein...)
    assert 'hostname' in data
    assert data['hostname'] == 'raspberrypi'
    assert 'user' in data
    assert data['user'] == 'alkaensos'
    assert 'ip' in data
    assert data['ip'] == '127.0.1.1'

def test_led_status_endpoint(client):
    response = client.get('/led-status')
    assert response.status_code == 200
    assert response.is_json

    data = response.get_json()

    # Überprüfe, ob die JSON-Antwort das erwartete Format hat (eine Liste von RGB-Werten)
    assert isinstance(data, list)  # Die Antwort muss eine Liste von Elementen sein
    assert all(isinstance(pixel, list) for pixel in data)  # Jedes Element muss Liste sein
    assert all(len(pixel) == 3 for pixel in data)  # Immer 3 Werte

    # Überprüfen ob gültigen Wert
    for pixel in data:
        assert all(isinstance(color_value, int) for color_value in pixel)  # Muss INT sein