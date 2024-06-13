$(document).ready(function() {
    // Get the modals
    var loginModal = $('#login-modal');
    var logoutModal = $('#logout-modal');
    var passwordResetModal = $('#password-reset-modal');
    var registerModal = $('#register-modal');

    // When the user clicks on the login link, open the login modal
    $('#login-link').on('click', function() {
        loginModal.modal('show');
    });

    // When the user clicks on the logout link, open the logout modal
    $('#logout-link').on('click', function() {
        logoutModal.modal('show');
    });

    // When the user clicks on the forgot password link, open the password reset modal
    $('#forgot-password-link').on('click', function() {
        loginModal.modal('hide');
        passwordResetModal.modal('show');
    });

    // When the user clicks on the register link, open the register modal
    $('#register-link').on('click', function() {
        loginModal.modal('hide');
        registerModal.modal('show');
    });

    // Handle login form submission
    $('#login-form').on('submit', function(event) {
        event.preventDefault();
        var formData = {
            email: $('#email').val(),
            password: $('#password').val()
        };
        $.ajax({
            type: 'POST',
            url: '/login',
            data: formData,
            success: function(response) {
                if (response.success) {
                    location.reload();
                } else {
                    alert('Login failed. Please try again.');
                }
            }
        });
    });

    // Handle password reset form submission
    $('#password-reset-form').on('submit', function(event) {
        event.preventDefault();
        var formData = {
            email: $('#reset-email').val()
        };
        $.ajax({
            type: 'POST',
            url: '/password_reset',
            data: formData,
            success: function(response) {
                alert(response.message);
                passwordResetModal.modal('hide');
            }
        });
    });

    // Handle register form submission
    $('#register-form').on('submit', function(event) {
        event.preventDefault();
        var formData = {
            salutation: $('#salutation').val(),
            first_name: $('#first-name').val(),
            last_name: $('#last-name').val(),
            email: $('#register-email').val(),
            password: $('#register-password').val()
        };
        $.ajax({
            type: 'POST',
            url: '/register',
            data: formData,
            success: function(response) {
                alert(response.message);
                registerModal.modal('hide');
            }
        });
    });

    // Handle closing the modals
    $('.close').on('click', function() {
        loginModal.modal('hide');
        logoutModal.modal('hide');
        passwordResetModal.modal('hide');
        registerModal.modal('hide');
    });

    $(window).on('click', function(event) {
        if ($(event.target).is(loginModal)) {
            loginModal.modal('hide');
        }
        if ($(event.target).
