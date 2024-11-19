import requests
import folium

# Base URL for the Nominatim API
BASE_URL = "https://nominatim.openstreetmap.org/search"

# Parameters for the GET request
params = {
    'q': "1600 Amphitheatre Parkway, Mountain View, CA",  # Address query
    'format': 'json',  # Response format
    'addressdetails': 1,  # Include detailed address components
    'limit': 1,  # Limit to one result
    'countrycodes': 'us'  # Restrict to the US
}

params = {
    'q': "Peterliwiese 33, 8855 Wangen",  # Address query
    'format': 'json',  # Response format
    'addressdetails': 1,  # Include detailed address components
    'limit': 1,  # Limit to one result
    'countrycodes': 'ch'  # Restrict to the US
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
    if result:
        # Extract latitude, longitude, and display name
        lat = float(result[0]['lat'])
        lon = float(result[0]['lon'])
        display_name = result[0]['display_name']
        print(f"Latitude: {lat}, Longitude: {lon}, Address: {display_name}")

        # Create a map centered at the result location
        m = folium.Map(location=[lat, lon], zoom_start=16)

        # Add a marker for the location
        folium.Marker(
            location=[lat, lon],
            popup=display_name,
            tooltip="Click for address"
        ).add_to(m)

        # Save the map to an HTML file
        map_file = "address_map.html"
        m.save(map_file)
        print(f"Map has been saved to {map_file}. Open it in your browser.")
    else:
        print("No results found.")
else:
    print(f"Error: {response.status_code} - {response.reason}")
