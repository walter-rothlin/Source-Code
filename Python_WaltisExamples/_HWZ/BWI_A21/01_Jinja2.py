
from jinja2 import Template

first_name = 'Walter'
last_name = 'Rothlin'

names_liste = [
    {'f_name': 'Peter',
     'l_name': 'Meier',
     'wohnort':'Oerlikon'},
    {'f_name': 'Heiri',
     'l_name': 'Müller'},
]

template_string = '''
{% if return_html %}
    <HTML>
    <BODY>
        <H1>Titel</H1>
        <table>
        {% for a_adresse in names_liste %}
            <tr><td>{{ a_adresse["f_name"] }}</td><td>{{ a_adresse["l_name"] }}</td><td>{{ a_adresse["wohnort"] }}</td></tr>    
        {% endfor %}
        </table>
    </BODY>
    </HTML>

{% else %}
    {% for a_adresse in names_liste %}{{ a_adresse["f_name"] }}  {{ a_adresse["l_name"] }}  {{ a_adresse["wohnort"] }}
    {% endfor %}
{% endif %}
'''

template = Template(template_string)
output = template.render(vorname=first_name, lastname=last_name, names_liste=names_liste, return_html=False)

print(output)
