$(document).on('show.bs.modal','#loginModal', function () {

    var modal = $(this)
    // modal.find('.modal-title').text('New message to ' + recipient)
    // modal.find('.modal-body input').val(recipient)

    $('#login-btn').on("click", function() {
        $.post("/login",
            {
                password: modal.find('#password').val(),
                email: modal.find('#email').val()
            },
            function(data, status){
                if(data.length>0){
                    modal.find('.error-message').text(data)
                }else{
                    $('#loginModal').modal('hide')
                }
            });
    } );
})