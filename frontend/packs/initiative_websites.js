window.addEventListener("load", () => {
  document
    .querySelector("[data-content=add_initiative_website]")
    .addEventListener("click", e => {
      e.preventDefault();
      let index = 0;
      while (
        document.querySelector(
          `#initiative_websites_attributes_${index}_url`
        ) != null
      ) {
        index++;
      }
      document.querySelector(
        "#initiative_websites"
      ).innerHTML += `<div class="FormField"><input class="FormField-input" placeholder="eg: https://twitter.com/carbon-map" type="text" name="initiative[websites_attributes][${index}][url]" id="initiative_websites_attributes_${index}_url"></div>`;
    });
});
