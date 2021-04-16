window.addEventListener("load", function() {
  const carbon_saving_anticipated = document.querySelector(
    "label[for=initiative_carbon_saving_anticipated]"
  );
  const carbon_saving_amount = document.querySelector(
    "label[for=initiative_carbon_saving_amount]"
  );
  const carbon_saving_strategy = document.querySelector(
    "label[for=initiative_carbon_saving_strategy]"
  );

  carbon_saving_anticipated.addEventListener("click", e => {
    console.log(e.target);
    if (e.target.checked) {
      carbon_saving_amount.classList.remove("u-hidden");
      carbon_saving_strategy.classList.remove("u-hidden");
    } else {
      carbon_saving_amount.classList.add("u-hidden");
      carbon_saving_strategy.classList.add("u-hidden");
    }
  });
});
