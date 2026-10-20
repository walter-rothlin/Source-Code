#!/usr/bin/python


from jinja2 import Template

adressliste = [
    {'firstname': 'Fritz', 'lastname': 'Meier'},
    {'firstname': 'Fredy', 'lastname': 'Collet'},
]

absender_vorname = 'Walti'
absender_nachname = 'Rothlin'


# Template-Datei einlesen
with open("brief.txt", "r", encoding="utf-8") as file:
    template_text = file.read()

template = Template(template_text)

serien_brief = template.render(sender_firstname=absender_vorname, sender_lastname=absender_nachname, adressliste=adressliste)

print(template_text)
print('\n\n')
print(serien_brief)
