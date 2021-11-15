import Splide from "@splidejs/splide";
import "@splidejs/splide/dist/css/splide.min.css";

try {
  const main = new Splide("#main-slider", {
    type: "fade",
    rewind: true,
    pagination: false,
    arrows: false,
  });

  const thumbnails = new Splide("#thumbnail-slider", {
    fixedWidth: 100,
    fixedHeight: 60,
    gap: 10,
    rewind: true,
    pagination: false,
    cover: true,
    isNavigation: true,
    breakpoints: {
      600: {
        fixedWidth: 60,
        fixedHeight: 44,
      },
    },
  });

  main.sync(thumbnails);
  main.mount();
  thumbnails.mount();

  const quantity1 = document.getElementById("products-show__quantity1");
  const quantity2 = document.getElementById("products-show__quantity2");

  quantity1.addEventListener("change", () => {
    quantity2.value = quantity1.value;
  });
  quantity1.addEventListener("keyup", () => {
    quantity2.value = quantity1.value;
  });
  quantity1.addEventListener("focusout", () => {
    const quantity = Number(
      document.getElementById("products-show__quantity1").value
    );
    if (quantity < 1) {
      const div = document.createElement("div");
      const div2 = document.createElement("div");
      div.className = "rounded-md bg-red-400 p-4 mb-3 text-white px-5 text-sm";
      div2.className = "rounded-md bg-red-400 p-4 mb-3 text-white px-5 text-sm";
      div.textContent = "Quantity you've entered can't be less than 1!";
      div2.textContent = "Quantity you've entered can't be less than 1!";
      quantity1.parentElement.parentElement.parentElement.prepend(div);
      quantity2.parentElement.parentElement.parentElement.prepend(div2);
      setTimeout(() => {
        div.remove();
        div2.remove();
      }, 2000);
      return;
    }
  });

  quantity2.addEventListener("change", () => {
    quantity1.value = quantity2.value;
  });
  quantity2.addEventListener("keyup", () => {
    quantity1.value = quantity2.value;
  });
  quantity2.addEventListener("focusout", () => {
    const quantity = Number(
      document.getElementById("products-show__quantity2").value
    );
    if (quantity < 1) {
      const div = document.createElement("div");
      const div2 = document.createElement("div");
      div.className = "rounded-md bg-red-400 p-4 mb-3 text-white px-5 text-sm";
      div2.className = "rounded-md bg-red-400 p-4 mb-3 text-white px-5 text-sm";
      div.textContent = "Quantity you've entered can't be less than 1!";
      div2.textContent = "Quantity you've entered can't be less than 1!";
      quantity1.parentElement.parentElement.parentElement.prepend(div);
      quantity2.parentElement.parentElement.parentElement.prepend(div2);
      setTimeout(() => {
        div.remove();
        div2.remove();
      }, 2000);
      return;
    }
  });

  const addToCartBtns = document.querySelectorAll(".add-to-cart");
  const navbarCart = document.getElementById("navbar__cart");
  addToCartBtns.forEach((btn) => {
    btn.addEventListener("click", (e) => {
      const productId = Number(document.getElementById("product_id").value);
      const quantity = Number(
        document.getElementById("products-show__quantity1").value
      );
      const price = Number(
        document.querySelector(".products-show__price").dataset.price
      );

      if (quantity < 1) {
        const div = document.createElement("div");
        const div2 = document.createElement("div");
        div.className =
          "rounded-md bg-red-400 p-4 mb-3 text-white px-5 text-sm";
        div2.className =
          "rounded-md bg-red-400 p-4 mb-3 text-white px-5 text-sm";
        div.textContent = "Quantity you've entered can't be less than 1!";
        div2.textContent = "Quantity you've entered can't be less than 1!";
        quantity1.parentElement.parentElement.parentElement.prepend(div);
        quantity2.parentElement.parentElement.parentElement.prepend(div2);
        setTimeout(() => {
          div.remove();
          div2.remove();
        }, 2000);
        return;
      }

      if (sessionStorage.getItem("cartItems")) {
        const cartItems = JSON.parse(sessionStorage.getItem("cartItems"));
        const found = cartItems.find((item) => item.productId == productId);

        if (found) {
          found.quantity = quantity;
        } else {
          cartItems.push({
            productId: productId,
            quantity: quantity,
            price: price,
          });
          navbarCart.textContent = cartItems.length;
        }

        sessionStorage.setItem("cartItems", JSON.stringify(cartItems));
      } else {
        const cartItems = [
          { productId: productId, quantity: quantity, price: price },
        ];
        sessionStorage.setItem("cartItems", JSON.stringify(cartItems));
        navbarCart.textContent = 1;
      }

      const div = document.createElement("div");
      const div2 = document.createElement("div");
      div.className =
        "rounded-md bg-green-200 p-4 mb-3 text-gray-900 px-5 text-sm";
      div2.className =
        "rounded-md bg-green-200 p-4 mb-3 text-gray-900 px-5 text-sm";
      div.textContent = "You've added this item to the cart.";
      div2.textContent = "You've added this item to the cart.";
      quantity1.parentElement.parentElement.parentElement.prepend(div);
      quantity2.parentElement.parentElement.parentElement.prepend(div2);
      setTimeout(() => {
        div.remove();
        div2.remove();
      }, 2000);
    });
  });

  const replyBtns = document.querySelectorAll(".reply-btn");
  replyBtns.forEach((replyBtn) => {
    replyBtn.addEventListener("click", (e) => {
      const replyForm = document.querySelector(
        `.reply-form-${e.target.dataset.comment_id}`
      );
      replyForm.classList.toggle("hidden");
    });
  });
} catch (err) {}
