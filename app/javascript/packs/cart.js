import axios from "axios";

var formatter = new Intl.NumberFormat("en-US", {
  style: "currency",
  currency: "USD",
});

const cartItems = JSON.parse(sessionStorage.getItem("cartItems"));
const cartItemsContainer = document.getElementById(
  "profile-cart__cart-items-container"
);
const cartItemsSubtotal1 = document.getElementById(
  "profile-cart__cart-items-subtotal1"
);
const cartItemsSubtotal2 = document.getElementById(
  "profile-cart__cart-items-subtotal2"
);
const cartItemsSubtotal3 = document.getElementById(
  "profile-cart__cart-items-subtotal3"
);

if (cartItems && cartItems.length > 0) {
  const promises = [];
  const quantities = [];
  const prices = [];
  cartItems.forEach((cartItem) => {
    promises.push(axios.get(`/products/${cartItem.productId}`));
    quantities.push(cartItem.quantity);
  });
  Promise.all(promises).then((products) => {
    const articles = [];
    let count = 0;
    let index = 0;
    products.forEach((product) => {
      if (product.data) {
        prices.push(product.data.price);
      } else {
        prices.push(0);
      }

      if (product.data) {
        count += 1;
        const article = document.createElement("article");
        article.className = "border-t";
        article.dataset.productId = `${product.data.id}`;
        article.innerHTML = `
          <div class="flex flex-col sm:flex-row py-6 text-gray-900">
            <img src="https://via.placeholder.com/150" class="w-36 h-36">
            <div class="flex flex-col justify-between sm:ml-4 w-full">
                <div class="py-4 sm:py-0">
                    <div class="flex justify-between mb-2">
                        <p class="font-medium">${formatter.format(
                          product.data.price / 100
                        )}</p>
                        <button class="font-medium w-8 h-8 hover:bg-gray-100 transition ease-in-out duration-150 rounded-md"><i class="fas fa-times"></i></button>
                    </div>
                    <a href="/all/products/${
                      product.data.slug
                    }" class="text-sm mb-2 font-bold hover:underline">${
          product.data.title
        }</a>
                    <div class="mb-4 text-sm flex items-center">
                        <label class="">Quantity: </label>
                        <input type="number" class="mx-4 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 text-sm w-20" value=${
                          quantities[index]
                        } min=1>
                        <p>${product.data.stock} available</p>
                    </div>
                </div>
            </div>
          </div>
        `;
        article
          .querySelector('input[type="number"]')
          .addEventListener("change", (e) => {
            const productId = Number(article.dataset.productId);
            const cartItem = cartItems.find(
              (item) => item.productId == productId
            );
            cartItem.quantity = Number(e.target.value);
            sessionStorage.setItem("cartItems", JSON.stringify(cartItems));
            updateSubTotal();
          });
        article
          .querySelector('input[type="number"]')
          .addEventListener("keyup", (e) => {
            const productId = Number(article.dataset.productId);
            const cartItem = cartItems.find(
              (item) => item.productId == productId
            );
            cartItem.quantity = Number(e.target.value);
            sessionStorage.setItem("cartItems", JSON.stringify(cartItems));
            updateSubTotal();
          });
        article
          .querySelector('input[type="number"]')
          .addEventListener("focusout", (e) => {
            const productId = Number(article.dataset.productId);
            const cartItem = cartItems.find(
              (item) => item.productId == productId
            );
            cartItem.quantity = Number(e.target.value);
            sessionStorage.setItem("cartItems", JSON.stringify(cartItems));
            updateSubTotal();

            if (Number(e.target.value) < 1) {
              const div = document.createElement("div");
              div.className =
                "rounded-md bg-red-400 p-4 mt-3 text-white px-5 text-sm";
              div.textContent = "Quantity you've entered can't be less than 1!";
              article.prepend(div);
              setTimeout(() => {
                div.remove();
              }, 2000);
            }
          });
        article.querySelector("button").addEventListener("click", (e) => {
          const cartItems = JSON.parse(sessionStorage.getItem("cartItems"));
          const productId = Number(article.dataset.productId);
          const filteredCartItems = cartItems.filter((item) => {
            return item.productId !== productId;
          });
          sessionStorage.setItem(
            "cartItems",
            JSON.stringify(filteredCartItems)
          );
          article.remove();
          const navbarCart = document.getElementById("navbar__cart");
          navbarCart.textContent = filteredCartItems.length;
          if (cartItemsContainer.children.length === 0) {
            cartItemsContainer.innerHTML = `
              <article class="flex flex-col sm:flex-row py-6 text-gray-900 border-t">
                No products found in your cart.
              </article>
            `;
          }
          updateSubTotal();
        });
        articles.push(article);
      }
      index += 1;
    });
    if (count === 0) {
      cartItemsContainer.innerHTML = `
        <article class="flex flex-col sm:flex-row py-6 text-gray-900 border-t">
            No products found in your cart.
        </article>
      `;
      cartItemsSubtotal1.textContent = `${formatter.format(0)}`;
      cartItemsSubtotal2.textContent = `${formatter.format(0)}`;
      cartItemsSubtotal3.textContent = `${formatter.format(0)}`;
    } else {
      cartItemsContainer.innerHTML = "";
      articles.forEach((article) => {
        cartItemsContainer.appendChild(article);
      });

      let subTotal = 0;
      for (let i = 0; i < quantities.length; i++) {
        subTotal += quantities[i] * prices[i];
      }
      cartItemsSubtotal1.textContent = `${formatter.format(subTotal / 100)}`;
      cartItemsSubtotal2.textContent = `${formatter.format(subTotal / 100)}`;
      cartItemsSubtotal3.textContent = `${formatter.format(subTotal / 100)}`;
    }
  });
} else {
  cartItemsContainer.innerHTML = `
    <article class="flex flex-col sm:flex-row py-6 text-gray-900 border-t">
        No products found in your cart.
    </article>
  `;
  cartItemsSubtotal1.textContent = `${formatter.format(0)}`;
  cartItemsSubtotal2.textContent = `${formatter.format(0)}`;
  cartItemsSubtotal3.textContent = `${formatter.format(0)}`;
}

function updateSubTotal() {
  const cartItems = JSON.parse(sessionStorage.getItem("cartItems"));
  let subTotal = 0;
  cartItems.forEach((cartItem) => {
    subTotal += cartItem.quantity * cartItem.price;
  });
  cartItemsSubtotal1.textContent = `${formatter.format(subTotal / 100)}`;
  cartItemsSubtotal2.textContent = `${formatter.format(subTotal / 100)}`;
  cartItemsSubtotal3.textContent = `${formatter.format(subTotal / 100)}`;
}

const checkoutBtns = document.querySelectorAll(".profile-cart__checkout");
checkoutBtns.forEach((btn) => {
  btn.addEventListener("click", (e) => {
    const cartItems = JSON.parse(sessionStorage.getItem("cartItems"));
    let proceedCheckout = true;
    cartItems.forEach((cartItem) => {
      if (cartItem.quantity < 1) {
        proceedCheckout = false;
        const article = document.querySelector(
          `[data-product-Id='${cartItem.productId}']`
        );
        const div = document.createElement("div");
        div.className =
          "rounded-md bg-red-400 p-4 mt-3 text-white px-5 text-sm";
        div.textContent = "Quantity you've entered can't be less than 1!";
        article.prepend(div);
        setTimeout(() => {
          div.remove();
        }, 2000);
      }
    });
    if (proceedCheckout) {
      alert("CHECKOUT PROCEEDING!");
    }
  });
});
