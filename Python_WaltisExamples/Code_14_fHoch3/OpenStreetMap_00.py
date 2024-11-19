import requests



# Base URL for the Nominatim API
BASE_URL = "https://nominatim.openstreetmap.org/search"

# Parameters for the GET request
params = {
    'q': "Peterliwiese 33, 8855 Wangen",  # Address query
    'format': 'json',       # Response format
    'addressdetails': 1,    # Include detailed address components
    'limit': 1,             # Limit to one result
    'countrycodes': 'ch'    # Restrict to the US
}

# Custom headers to comply with API usage guidelines
headers = {
    'User-Agent': 'PythonApp/1.0 (your_email@example.com)'  # Replace with your email
}

# Sending the GET request
response = requests.get(BASE_URL, params=params, headers=headers)

# Check if the request was successful
if response.status_code == 200:
    # Parse the JSON response
    result = response.json()
    print("Result:", result)
    if result:
        # Extract specific data
        lat = result[0]['lat']
        lon = result[0]['lon']
        display_name = result[0]['display_name']
        print(f"Latitude: {lat}, Longitude: {lon}, Address: {display_name}")
    else:
        print("No results found.")
else:
    print(f"Error: {response.status_code} - {response.reason}")
