from jinja2 import Template

# Define a simple template
template_string = '''
Hello, {{ vorname }} {{ nachname }}!

{% if with_count %}
Du hast {{ adress_liste|length }} Adressen!
{% endif %}

{% if adress_liste|length > 5 %}
Du hast ganz viele Adressen ({{ adress_liste|length }})!
{% elif adress_liste|length > 2 %}
Du hast viele Adressen ({{ adress_liste|length }})!
{% else %}
Du hast nur {{ adress_liste|length }} Adressen!
{% endif %}

{% for adresse in adress_liste %}{{ adresse.vorname.strip().upper() }}  {{ adresse.nachname.strip() }}
{% endfor %}
 


'''

adress_liste = [
    {
        'vorname': 'Walter     ',
        'nachname': 'Rothlin',
    },
    {
        'vorname': 'Franz',
        'nachname': 'Meier',
    },
    {
        'vorname': 'Heiri',
        'nachname': 'Vogt',
    },
    {
        'vorname': 'Max',
        'nachname': 'Vogt',
    },
    {
        'vorname': 'Kurt',
        'nachname': 'Vogt',
    },
    {
        'vorname': 'Heiri',
        'nachname': 'Bruhin',
    },
]

# Create a Jinja2 template object
template = Template(template_string)

# Render the template with variables
output = template.render(vorname='John', nachname='Smith', adress_liste=adress_liste, with_count=True)

# Print the result
print(output)
