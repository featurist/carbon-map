document.querySelector(".Help a").addEventListener("click", e => {
  e.target.closest(".Help").classList.toggle("Help--open");
});
