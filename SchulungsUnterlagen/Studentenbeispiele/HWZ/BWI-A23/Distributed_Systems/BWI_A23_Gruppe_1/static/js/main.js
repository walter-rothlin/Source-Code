document.addEventListener('DOMContentLoaded', function () {
    // Modal-Wechsel: aktuelles Modal schliessen und Ziel-Modal öffnen.
    document.querySelectorAll('[data-switch-modal]').forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();

            var currentModal = link.closest('.modal');
            var targetModal = document.querySelector(link.getAttribute('data-switch-modal'));

            if (currentModal) bootstrap.Modal.getOrCreateInstance(currentModal).hide();
            if (targetModal) bootstrap.Modal.getOrCreateInstance(targetModal).show();
        });
    });

    // Clientseitige Validierung des Registrieren-Formulars.
    var form = document.querySelector('#registerModal form');
    if (form) {
        var minPasswordLength = Number(document.body.dataset.minPasswordLength || 0);
        // Gleiches Muster wie EMAIL_PATTERN im Server-Code.
        var emailPattern = /^[^@\s]+@[^@\s]+\.[^@\s]+$/;

        var passwordField = document.getElementById('register-password');
        var passwordConfirmField = document.getElementById('register-password-confirm');

        // Validierungsregel pro Feld: liefert true, wenn der Wert gültig ist.
        var rules = {
            'salutation': function (value) { return value !== ''; },
            'first_name': function (value) { return value.trim() !== ''; },
            'last_name': function (value) { return value.trim() !== ''; },
            'register-email': function (value) { return emailPattern.test(value.trim()); },
            'register-password': function (value) { return value.length >= minPasswordLength; },
            'register-password-confirm': function (value) {
                return value.length >= minPasswordLength && value === passwordField.value;
            }
        };

        // Setzt den optischen Zustand: invalid, valid oder neutral.
        function setFieldState(field, state, showValid) {
            field.classList.toggle('is-invalid', state === 'invalid');
            field.classList.toggle('is-valid', state === 'valid' && showValid);
        }

        // Live-Prüfung: ein leeres Feld bleibt neutral, nur Eingaben werden bewertet.
        function liveCheck(id, showValid) {
            var field = document.getElementById(id);
            if (field.value === '') {
                setFieldState(field, 'neutral', showValid);
                return;
            }
            setFieldState(field, rules[id](field.value) ? 'valid' : 'invalid', showValid);
        }

        // Prüfung beim Absenden: leere/falsche Felder werden rot markiert.
        function submitCheck(id, showValid) {
            var field = document.getElementById(id);
            var isValid = rules[id](field.value);
            setFieldState(field, isValid ? 'valid' : 'invalid', showValid);
            return isValid;
        }

        // Live-Feedback beim Tippen: Passwortfelder mit Haken, übrige nur Fehler.
        Object.keys(rules).forEach(function (id) {
            var field = document.getElementById(id);
            var isPassword = (id === 'register-password' || id === 'register-password-confirm');
            var eventName = (field.tagName === 'SELECT') ? 'change' : 'input';

            field.addEventListener(eventName, function () {
                if (isPassword) {
                    // Beide Passwortfelder zusammen bewerten, damit die Übereinstimmung stimmt.
                    liveCheck('register-password', true);
                    liveCheck('register-password-confirm', true);
                } else {
                    liveCheck(id, false);
                }
            });
        });

        // Vor dem Absenden alle Felder prüfen; bei Fehlern nichts senden.
        form.addEventListener('submit', function (event) {
            var allValid = true;

            Object.keys(rules).forEach(function (id) {
                var isPassword = (id === 'register-password' || id === 'register-password-confirm');
                if (!submitCheck(id, isPassword)) {
                    allValid = false;
                }
            });

            if (!allValid) {
                event.preventDefault();
            }
        });
    }

    // Nach einem Validierungsfehler das passende Modal automatisch wieder öffnen.
    var openModalSelector = document.body.dataset.openModal;
    var openModal = openModalSelector ? document.querySelector(openModalSelector) : null;
    if (openModal) {
        bootstrap.Modal.getOrCreateInstance(openModal).show();
    }
});
