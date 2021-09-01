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

window.addEventListener("load", function() {
  document.querySelectorAll(".Explore-tab").forEach(el => {
    el.addEventListener("click", e => {
      e.preventDefault();

      focusTab(el);
    });
  });
});

window.addEventListener("load", () => {
  document
    .querySelector("#search")
    .addEventListener("submit", e => e.preventDefault());
  const initiatives = JSON.parse(
    document.getElementById("map_data_json").innerText
  ).initiatives;
  const searchStrings = {};
  initiatives.forEach(initiative => {
    const initiativeString = Object.values(initiative)
      .map(value => {
        if (value != null && typeof value == "object") {
          Object.values(value)
            .toString()
            .toLowerCase();
        } else {
          return value;
        }
      })
      .toString()
      .toLowerCase();
    searchStrings[initiative.id] = initiativeString;
  });

  document
    .querySelector("[type=search][name=q]")
    .addEventListener("input", e => {
      focusTab(document.querySelector("[data-content=initiatives]"));
      const search = e.target.value.toLowerCase().split(" ");
      const matches = [];

      for (const initiativeId in searchStrings) {
        const initiativeData = searchStrings[initiativeId];

        const partialMatch = [];
        search.forEach(item => {
          if (initiativeData.includes(item)) {
            partialMatch.push(initiativeId);
          }
        });
        if (partialMatch.length == search.length) {
          matches.push(initiativeId);
        }
      }

      document.querySelectorAll(".Initiative").forEach(initiativeEl => {
        initiativeEl.classList.add("u-hidden");
      });
      matches.forEach(initiativeId => {
        document
          .querySelector(`[data-content=initiative_${initiativeId}]`)
          .classList.remove("u-hidden");
      });
    });
});
