displayNone = () => {
  alert = document.querySelector(".alert");
  alert.classList.add("d-none");
}

hideAlert = () => {
  alert = document.querySelector(".alert");
  alert.classList.add("fadeOut");
  setTimeout(function() {
    displayNone();
}, 1500);
}

setTimeout(function() {
    hideAlert();
}, 1500);
