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
    alert("Quantity you've entered can't be less than 1!");
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
    alert("Quantity you've entered can't be less than 1!");
    document.getElementById("products-show__quantity2").value = 1;
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
      alert("Quantity you've entered can't be less than 1!");
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
  });
});
