"""Eine Sammlung von Verschlüsselungsfunktionen"""


def text_verschluesseln(text):
    """Verschlüsselt den übergeben Text und gibt ihn zurück"""
    verschluesselung = text[::-1]
    verschluesselung = verschluesselung.replace("e", "#")
    verschluesselung = verschluesselung.replace("a", "?")

    return verschluesselung


def text_entschluesseln(text):
    """Entschlüsselt den übergeben Text und gibt ihn zurück"""
    entschluesselung = text[::-1]
    entschluesselung = entschluesselung.replace("#", "e")
    entschluesselung = entschluesselung.replace("?", "a")

    return entschluesselung


# Beschreibung des verwendeten Schlüssels
schluesselbeschreibung = "# entspricht e, ? entspricht a. Text rückwärts lesen!"
