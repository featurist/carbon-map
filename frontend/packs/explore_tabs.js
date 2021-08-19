window.addEventListener("load", function() {
  document.querySelectorAll(".Explore-tab").forEach(el => {
    el.addEventListener("click", e => {
      e.preventDefault();

      focusTab(el);
    });
  });
});
function focusTab(tab) {
  const name = tab.getAttribute("data-content");
  document.querySelectorAll(".Explore-tab").forEach(el => {
    el.classList.remove("Explore-tab_selected");
  });
  document.querySelectorAll(".Tab").forEach(el => {
    el.classList.remove("Explore-tab_displayed");
  });
  tab.classList.add("Explore-tab_selected");
  document
    .querySelector(`[data-content=${name}-tab]`)
    .classList.add("Explore-tab_displayed");
  return false;
}
