const year = document.getElementById("year");

window.onload = () => {
  const date = new Date().getFullYear();
  year.innerHTML = date;
};
