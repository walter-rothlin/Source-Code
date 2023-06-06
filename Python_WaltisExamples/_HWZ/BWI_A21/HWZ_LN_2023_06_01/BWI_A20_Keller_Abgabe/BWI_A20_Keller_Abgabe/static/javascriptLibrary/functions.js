function checkPasswordLength(password) {
  if (password.length > 5) {
    document.getElementById("submit").disabled = false;
  } else {
    document.getElementById("submit").disabled = true;
    alert("Das Passwort muss mindestens 5 Zeichen beinhalten");
  }
}

function toggleMenu() {
  var menu = document.getElementById("menu");
  var menuToggle = document.querySelector(".menu-toggle");

  menuToggle.classList.toggle("active");
  menu.style.display = menu.style.display === "none" ? "block" : "none";
}

function openPopup(event) {
  event.preventDefault(); // Prevents the default link behavior

  var popup = document.getElementById('passwordLostPopUp');
  popup.style.display = 'block';
}

function closePopup() {
  var popup = document.getElementById('passwordLostPopUp');
  popup.style.display = 'none';
  var popup = document.getElementById('popupWindow');
  popup.style.display = 'none';
}

function openPopupLogout(event) {
  event.preventDefault();

  var popup = document.getElementById('logoutpopup');
  popup.style.display = 'block';
}

function closePopupLogout() {
  var popup = document.getElementById('logoutpopup');
  popup.style.display = 'none';
}

function openPopupRegister(event) {
  event.preventDefault();

  var popup = document.getElementById('registerPopUp');
  popup.style.display = 'block';
}

function closePopupRegister() {
  var popup = document.getElementById('registerPopUp');
  popup.style.display = 'none';
}

function openPopupLogin(event) {
  event.preventDefault();

  var popup = document.getElementById('popupWindow');
  popup.style.display = 'block';
}

function openPopupLogIn() {
  var popup = document.getElementById('popupWindow');
  popup.style.display = 'none';
}