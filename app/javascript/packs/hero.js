searchForm = document.getElementById("search-form");

searchForm.action = `/${searchForm.querySelector("#category").value}/products`;

searchForm.querySelector("#category").addEventListener("change", (e) => {
  console.log(e.target.value);
  searchForm.action = `/${e.target.value}/products`;
});
