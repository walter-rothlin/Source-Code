#!/usr/bin/python3

# ------------------------------------------------------------------------------------------------
# Name  : 01.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/_HBU/2023_03_PY2/05_Jinja/Generate_Pain001.py
#
# Description: Generiert ein eBanking Upload-File für Zahlungen (Pain001.xml)
#
# Autor: Walter Rothlin
#
# History:
# 08-Jan-2023   Walter Rothlin      Initial Version
# ------------------------------------------------------------------------------------------------
from jinja2 import Template

adress_liste = [
    {'name': 'Rothlin',
     'first_name': 'Walti'},
    {'name': 'Meier',
     'first_name': 'Max'},
    {'name': 'Hugentobler',
     'first_name': 'Fritz'}
]

template_string = '''

{% if with_title %}
    <p>{{ title }}</p>
{% else %}
    <p>No title defined.</p>
{% endif %}

<table>
{% for a_adresse in adress_liste %}
<tr><td>{{ a_adresse['name'] }}<td></td>{{ a_adresse['first_name'] }}</td></tr>
{% endfor %}
</table>
'''

# Create a Jinja2 template object
template = Template(template_string)

# Render the template with variables
output = template.render(adress_liste=adress_liste, title='Adressliste', with_title=False)

# Print the result
print(output)
