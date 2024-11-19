from waltisLibrary import *

search_adress = input('Adresse:')
result = get_coordinates_for_adresse(adress=search_adress, country='ch')
print(f"{result['display_name']}  ({result['lat']}/{result['lon']})")

