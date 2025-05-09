import string

def is_password_valid(

        password,
        min_length=None,
        min_count_figures=None,
        min_count_uppercase=None,
        min_count_lowercase=None,
        min_count_special_char=None
):
    '''
# ----------------------------------------------
# Passwortregeln:
# ----------------------------------------------
# Ein korrektes Passwort muss je nach Vorgaben:
# - eine Mindestlänge haben
# - eine Mindestanzahl an Ziffern enthalten
# - eine Mindestanzahl an Großbuchstaben enthalten
# - eine Mindestanzahl an Kleinbuchstaben enthalten
# - eine Mindestanzahl an Sonderzeichen enthalten
# ----------------------------------------------
    '''
    if not isinstance(password, str):
        return False

    count_digits = sum(1 for c in password if c.isdigit())
    count_upper = sum(1 for c in password if c.isupper())
    count_lower = sum(1 for c in password if c.islower())
    count_special = sum(1 for c in password if c in string.punctuation)

    if min_length is not None and len(password) < min_length:
        return False
    if min_count_figures is not None and count_digits < min_count_figures:
        return False
    if min_count_uppercase is not None and count_upper < min_count_uppercase:
        return False
    if min_count_lowercase is not None and count_lower < min_count_lowercase:
        return False
    if min_count_special_char is not None and count_special < min_count_special_char:
        return False

    return True

# ---------------------------------------------------
# Testfunktion mit verschiedenen Test-Cases
# ---------------------------------------------------
def password_checker_test():
    test_cases = [
        {
            "password": "Passw0rd",
            "rules": {
                "min_length": 8,
                "min_count_figures": 1,
                "min_count_uppercase": 1,
                "min_count_lowercase": 1,
                "min_count_special_char": 0,
            },
            "expected": True,
        },
        {
            "password": "short7!",
            "rules": {
                "min_length": 8,
                "min_count_figures": 1,
                "min_count_uppercase": 1,
                "min_count_lowercase": 1,
                "min_count_special_char": 1,
            },
            "expected": False,
        },
        {
            "password": "password1!",
            "rules": {
                "min_length": 8,
                "min_count_figures": 1,
                "min_count_uppercase": 1,
                "min_count_lowercase": 1,
                "min_count_special_char": 1,
            },
            "expected": False,
        },
        {
            "password": "ValidPassword123!",
            "rules": {
                "min_length": 10,
                "min_count_figures": 2,
                "min_count_uppercase": 1,
                "min_count_lowercase": 3,
                "min_count_special_char": 1,
            },
            "expected": True,
        },
    ]

    for i, test in enumerate(test_cases):
        result = is_password_valid(test["password"], **test["rules"])
        passed = result == test["expected"]
        print(f"Testfall {i + 1}: {'✅ OK' if passed else '❌ FEHLER'}")

if __name__ == "__main__":
    password_checker_test()
