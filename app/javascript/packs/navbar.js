const navbarBtn = document.getElementById("navbar__btn");
const navbarMenu1 = document.getElementById("navbar__menu1");
const navbarMenu2 = document.getElementById("navbar__menu2");

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

const userBtn = document.getElementById("user__btn");
const userDropdown = document.getElementById("user__dropdown");
if (userBtn) {
  userBtn.addEventListener("click", (e) => {
    userDropdown.classList.toggle("hidden");
  });
  window.onclick = function (e) {
    if (e.target.closest("#user__dropdown") || e.target.closest("#user__btn")) {
    } else {
      userDropdown.classList.add("hidden");
    }
  };
  userDropdown.querySelectorAll("a").forEach((element) => {
    element.addEventListener("click", () => {
      userDropdown.classList.toggle("hidden");
    });
  });
}

const navbarCart = document.getElementById("navbar__cart");
const cartItems = JSON.parse(sessionStorage.getItem("cartItems"));
if (cartItems && cartItems.length > 0) {
  navbarCart.textContent = cartItems.length;
} else {
  navbarCart.textContent = 0;
}
