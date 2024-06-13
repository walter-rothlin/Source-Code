class Person:
    def __init__(self, anrede, firstname, lastname, username):
        self.anrede = anrede
        self.firstname = firstname
        self.lastname = lastname
        self.username = username

    def __str__(self):
        return f"Sehr geehrte/r {self.anrede} {self.firstname} {self.lastname} es wurde ein Registrierungsmail an: {self.username} gesendet."
