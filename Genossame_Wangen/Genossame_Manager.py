#!/usr/bin/python3

# ------------------------------------------------------------------
# Name  : Genossame_Manager.py
# Source: https://raw.githubusercontent.com/walter-rothlin/Source-Code/master/Python_WaltisExamples/Genossame_Manager/Stammdaten_Manager.py
#
# Description: Manager für Genossame-Daten
#
# Autor: Walter Rothlin
#
# History:
# 01-Jan-2023   Walter Rothlin      Initial Version
# 21-Jun-2023   Walter Rothlin      Added Commen_Defs
#
# ------------------------------------------------------------------
from Genossame_Common_Defs import *


# -------------------------------------------
# ++++++++++++ Main Main Main +++++++++++++++
# -------------------------------------------
db_attr_excel_column_mapping = [
    # Person_Details
    # --------------
    {'excel': 'Source'},
    {'excel': 'History'},
    {'excel': 'Bemerkungen'},
    {'excel': 'Zivilstand'},
    {'excel': 'Kategorien'},
    {'excel': 'Funktion'},
    {'excel': 'Firma'},

    {'excel': 'Geschlecht', 'db': 'Sex'},
    {'excel': 'Vorname'},
    {'excel': 'Vorname_2'},
    {'excel': 'Familien_Name', 'db': 'Pre'},
    {'excel': 'Ledig_Name'},
    {'excel': 'Partner_Name'},
    {'excel': 'Partner_Name_Angenommen'},

    {'excel': 'AHV_Nr'},
    {'excel': 'Betriebs_Nr'},
    {'excel': 'SAK'},

    {'excel': 'Baulandgesuch_Details'},
    {'excel': 'Bezahlte_Aufnahme_Gebühr'},
    {'excel': 'Ausbezahlter_Bürgertaglohn'},

    # Verwandtschaft
    # --------------
    {'excel': 'Partner_ID'},
    {'excel': 'Vater_ID'},
    {'excel': 'Mutter_ID'},

    # Private Adresse
    # ---------------
    {'excel': 'Private_Adressen_ID', 'db': 'Privat_Adressen_ID'},
    {'excel': 'Private_Strassen_Adresse', 'db': 'Pre'},
    {'excel': 'Private_Ort_ID', 'db': 'Pre'},
    {'excel': 'Private_PLZ_Ort', 'db': 'Pre'},
    {'excel': 'Private_Land_ID', 'db': 'Pre'},
    {'excel': 'Private_Land', 'db': 'Pre'},

    # Geschäft Adresse
    # ----------------
    {'excel': 'Geschaeft_Adressen_ID', 'db': 'Privat_Adressen_ID'},
    {'excel': 'Geschaeft_Strassen_Adresse', 'db': 'Pre'},
    {'excel': 'Geschaeft_Ort_ID', 'db': 'Pre'},
    {'excel': 'Geschaeft_PLZ_Ort', 'db': 'Pre'},
    {'excel': 'Geschaeft_Land_ID', 'db': 'Pre'},
    {'excel': 'Geschaeft_Land', 'db': 'Pre'},

    # Dates
    # -----
    {'excel': 'Geburtstag'},
    {'excel': 'Todestag'},
    {'excel': 'Nach_Wangen_Gezogen'},
    {'excel': 'Von_Wangen_Weggezogen'},
    {'excel': 'Baulandgesuch_Eingereicht_Am'},
    {'excel': 'Bauland_Gekauft_Am'},
    {'excel': 'Angemeldet_Am'},
    {'excel': 'Aufnahme_Gebühr_bezahlt_Am'},
    {'excel': 'Aufgenommen_Am'},
    {'excel': 'Sich_Für_Bürgertag_Angemeldet_Am'},
    {'excel': 'Sich_Für_Bürgertag_definitiv_abgemeldet_Am'},
    {'excel': 'Neubürgertag_gemacht_Am'},
    {'excel': 'Funktion_Uebernommen_Am'},
    {'excel': 'Funktion_Abgegeben_Am'},
    {'excel': 'Chronik_Bezogen_Am'},
    {'excel': 'Newsletter_Abonniert_Am'},

    {'excel': 'eMail_Detail_Long',    'db': 'Join'},
    {'excel': 'eMail_1_Detail_Long',  'db': 'Join'},
    {'excel': 'eMail_2_Detail_Long',  'db': 'Join'},

    {'excel': 'Tel_Nr_Detail_Long',   'db': 'Join'},
    {'excel': 'Tel_Nr_1_Detail_Long', 'db': 'Join'},
    {'excel': 'Tel_Nr_2_Detail_Long', 'db': 'Join'},

    {'excel': 'IBAN_Detail_Long',     'db': 'Join'},

]

if __name__ == '__main__':

    use_production_db = True
    geno_schema = db_connect(connect_to_prod=use_production_db, trace=True)

    # Landteile von Excel laden
    # =========================
    if True:
        initial_load_pachtland(geno_schema, r'V:\Landwirtschaft\Pachtland\Infotabellen_Landwirte.xlsx', verbal=True)


    # Cleanup Date
    # ============
    if True:
        print('\n\n')
        print('==================')
        print('Cleanup DB        ')
        print('==================')
        execute_important_sql_queries(geno_schema)


    # Check Password
    # ==============
    if False:
        print('Password Tests')
        personen_db = Stammdaten(use_prod=use_production_db)
        user_name = 'walter@rothlin.com'
        print(user_name, ' --> ', personen_db.get_user_id_for_email(user_name))
        user_name = 'landwirtschaft@genossame-wangen.ch'
        print(user_name, ' -->', personen_db.get_user_id_for_email(user_name))
        user_name = 'i.vogt@genossame-wangen.ch'
        print(user_name, ' -->', personen_db.get_user_id_for_email(user_name))
        user_name = 'isabella.vogt@bluewin.ch'
        print(user_name, ' -->', personen_db.get_user_id_for_email(user_name))

        password = 'PWD_Hallo'
        login_details = personen_db.is_password_correct('walter@rothlin.com', password)
        print(login_details)
        login_details = personen_db.is_password_correct('landwirtschaft@genossame-wangen.ch', password)
        print(login_details)
        login_details = personen_db.is_password_correct('i.vogt@genossame-wangen.ch', password)
        print(login_details)
        login_details = personen_db.is_password_correct('isabella.vogt@bluewin.ch', password)
        print(login_details)

        print('644 --> ', personen_db.get_priviliges_for_pers_ID(644))
        print('533 --> ', personen_db.get_priviliges_for_pers_ID(533))



    if False:
        import getpass
        username = getpass.getuser()
        print("Logged-in username:", username)


    if False:
        from ldap3 import Server, Connection, SUBTREE

        # Replace these values with your Active Directory server details
        ad_server = 'ldap://your_ad_server'
        ad_user = 'your_username'
        ad_password = 'your_password'

        # Create an LDAP server object
        server = Server(ad_server)

        # Create an LDAP connection object
        with Connection(server, user=ad_user, password=ad_password, auto_bind=True) as conn:
            # Perform a simple search
            search_base = 'DC=your_domain,DC=com'  # Replace with your Active Directory base
            search_filter = '(objectClass=user)'
            attributes = ['cn', 'sAMAccountName', 'mail']

            conn.search(search_base, search_filter, attributes=attributes, search_scope=SUBTREE)

            # Retrieve search results
            for entry in conn.entries:
                print("CN:", entry.cn)
                print("Username:", entry.sAMAccountName)
                print("Email:", entry.mail)
                print("----------------------")


