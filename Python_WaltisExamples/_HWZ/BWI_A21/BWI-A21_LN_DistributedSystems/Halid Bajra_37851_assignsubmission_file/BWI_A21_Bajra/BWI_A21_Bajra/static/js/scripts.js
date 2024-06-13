$(document).ready(function () {
    function showAlert(selector, message, modalId) {
        $(modalId + ' ' + selector).text(message).removeClass('d-none');
        setTimeout(function () {
            $(modalId + ' ' + selector).addClass('d-none');
        }, 5000);
    }

    $('#loginForm').submit(function (event) {
        event.preventDefault();
        $.post($(this).attr('action'), $(this).serialize(), function (data) {
            if (data.success) {
                showAlert('#loginSuccess', data.message, '#loginModal');
                $('#loginForm input, #loginForm button').prop('disabled', true);
                $('#loginModal .modal-content').append('<div class="modal-overlay"></div>');

                setTimeout(function () {
                    $('#loginModal').modal('hide');
                    $('#loginForm input, #loginForm button').prop('disabled', false);
                    $('#loginModal .modal-overlay').remove();
                    location.reload();
                }, 1500);
            } else {
                showAlert('#loginError', data.message, '#loginModal');
            }
        });
    });

    $('#logoutForm').submit(function (event) {
        event.preventDefault();
        $.post($(this).attr('action'), $(this).serialize(), function (data) {
            if (data.success) {
                showAlert('#logoutSuccess', data.message, '#logoutModal');
                $('#logoutForm button').prop('disabled', true);
                $('#logoutModal .modal-content').append('<div class="modal-overlay"></div>');

                setTimeout(function () {
                    $('#logoutModal').modal('hide');
                    $('#logoutForm button').prop('disabled', false);
                    $('#logoutModal .modal-overlay').remove();
                    location.reload();
                }, 1500);
            } else {
                // Fehlerbehandlung falls nötig
            }
        });
    });

    $('#forgotPasswordForm').submit(function (event) {
        event.preventDefault();
        $.post($(this).attr('action'), $(this).serialize(), function (data) {
            if (data.success) {
                showAlert('#forgotPasswordSuccess', data.message, '#forgotPasswordModal');
                $('#forgotPasswordForm input, #forgotPasswordForm button').prop('disabled', true);
                $('#forgotPasswordModal .modal-content').append('<div class="modal-overlay"></div>');

                setTimeout(function () {
                    $('#forgotPasswordModal').modal('hide');
                    $('#forgotPasswordForm')[0].reset();
                    $('#forgotPasswordForm input, #forgotPasswordForm button').prop('disabled', false);
                    $('#forgotPasswordModal .modal-overlay').remove();
                }, 2000);
            } else {
                showAlert('#forgotPasswordError', data.message, '#forgotPasswordModal');
            }
        });
    });

    $('#registerForm').submit(function (event) {
        event.preventDefault();
        $.post($(this).attr('action'), $(this).serialize(), function (data) {
            if (data.success) {
                showAlert('#registerSuccess', data.message, '#registerModal');
                $('#registerForm input, #registerForm button').prop('disabled', true);
                $('#registerModal .modal-content').append('<div class="modal-overlay"></div>');

                setTimeout(function () {
                    $('#registerModal').modal('hide');
                    $('#registerForm')[0].reset();
                    $('#registerForm input, #registerForm button').prop('disabled', false);
                    $('#registerModal .modal-overlay').remove();
                }, 2000);
            } else {
                showAlert('#registerError', data.message, '#registerModal');
            }
        });
    });

    $('#loginModal').on('hidden.bs.modal', function () {
        $('#loginError').addClass('d-none');
        $('#loginSuccess').addClass('d-none');
    });

    $('#forgotPasswordModal').on('hidden.bs.modal', function () {
        $('#forgotPasswordError').addClass('d-none');
        $('#forgotPasswordSuccess').addClass('d-none');
    });

    $('#registerModal').on('hidden.bs.modal', function () {
        $('#registerError').addClass('d-none');
        $('#registerSuccess').addClass('d-none');
    });

    $('#logoutModal').on('hidden.bs.modal', function () {
        $('#logoutSuccess').addClass('d-none');
    });

    setTimeout(function () {
        $('.alert-dismissible').alert('close');
    }, 5000);
});
