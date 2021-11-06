navbarBtn = document.getElementById("navbar__btn");
navbarMenu1 = document.getElementById("navbar__menu1");
navbarMenu2 = document.getElementById("navbar__menu2");

navbarBtn.addEventListener("click", (e) => {
  if (
    e.target.closest("#navbar__btn").querySelector("i").className ===
    "fas fa-bars"
  ) {
    e.target.closest("#navbar__btn").querySelector("i").className =
      "fas fa-times";
    navbarMenu1.classList.remove("hidden");
    navbarMenu1.classList.add("flex");
    navbarMenu2.classList.remove("hidden");
    navbarMenu2.classList.add("flex");
  } else {
    e.target.closest("#navbar__btn").querySelector("i").className =
      "fas fa-bars";
    navbarMenu1.classList.remove("flex");
    navbarMenu1.classList.add("hidden");
    navbarMenu2.classList.remove("flex");
    navbarMenu2.classList.add("hidden");
  }
});
