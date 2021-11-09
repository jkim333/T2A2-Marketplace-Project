const urlSearchParams = new URLSearchParams(window.location.search);
const params = Object.fromEntries(urlSearchParams.entries());

searchInput = document.getElementById("search-input");

if (params.search) {
  searchInput.value = params.search;
}
console.log(params);
