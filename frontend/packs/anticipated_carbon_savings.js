window.addEventListener("load", function() {
  const carbon_saving_anticipated = document.querySelector(
    "label[for=initiative_carbon_saving_anticipated]"
  );
  const carbon_saving_quantified = document.querySelector(
    "label[for=initiative_carbon_saving_quantified]"
  );
  const carbon_saving_amount = document.querySelector(
    "label[for=initiative_carbon_saving_amount]"
  );

  carbon_saving_anticipated.addEventListener("click", e => {
    console.log(e.target);
    if (e.target.checked) {
      carbon_saving_quantified.classList.remove("u-hidden");
    } else {
      carbon_saving_quantified.classList.add("u-hidden");
    }
  });

  carbon_saving_quantified.addEventListener("click", e => {
    if (e.target.checked) {
      carbon_saving_amount.classList.remove("u-hidden");
    } else {
      carbon_saving_amount.classList.add("u-hidden");
    }
  });
});
