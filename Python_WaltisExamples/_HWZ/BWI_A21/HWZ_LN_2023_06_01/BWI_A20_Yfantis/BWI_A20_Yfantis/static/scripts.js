// Diese Funktion wurde durch ChatGPT geschrieben und durch mich validiert und getestet. //

function showConfirmation() {
    if (confirm('Are you sure you want to logout?')) {
        document.getElementById('logout-form').submit();
    }
}
