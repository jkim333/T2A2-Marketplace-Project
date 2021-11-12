const quantity1 = document.getElementById("products-show__quantity1");
const quantity2 = document.getElementById("products-show__quantity2");

quantity1.addEventListener("change", () => {
  quantity2.value = quantity1.value;
});
quantity1.addEventListener("keyup", () => {
  quantity2.value = quantity1.value;
});

quantity2.addEventListener("change", () => {
  quantity1.value = quantity2.value;
});
quantity2.addEventListener("keyup", () => {
  quantity1.value = quantity2.value;
});
