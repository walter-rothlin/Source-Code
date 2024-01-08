#!/usr/bin/python3

# ------------------------------------------------------------------------------------------------
# Name  : Generate_GeoTag.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2023_03_PY2/05_Jinja/Generate_GeoTag.py
#
# Description: Generiert ein kml file for importing into geomap admin or google maps
#
# Autor: Walter Rothlin
#
# History:
# 08-Jan-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------------------------------------

from jinja2 import Environment, FileSystemLoader
from datetime import datetime


def get_kml_msg(placemarks):
    env = Environment(loader=FileSystemLoader('./Templates'))
    template = env.get_template('kml_template.xml')
    return template.render(placemarks=placemarks)

# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
placemarks = [
    {'name': 'Mein Wohnort',
     'description': 'Hier bin ich zu Hause',
     'icon': 'https://api3.geo.admin.ch/color/255,0,0/marker-24@2x.png',
     'label_color': 'ff0000ff',
     'long': '8.887271009997784',
     'lat': '47.19449920346176'},
    {'name': 'Mein Aufenthaltsort',
     'description': 'Hier bin ich gerade',
     'icon': 'https://api3.geo.admin.ch/color/255,0,0/marker-24@2x.png',
     'label_color': 'ff0000ff',
     'long': '8.887271009997784',
     'lat': '47.19449920346176'}
]

if __name__ == '__main__':
    kml_text = get_kml_msg(placemarks=placemarks)
    print(kml_text)
