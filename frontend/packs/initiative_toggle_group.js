document
  .querySelector("#initiative_lead_group_id")
  .addEventListener("change", e => {
    const showNew = e.target.value === "new";
    if (showNew) {
      document
        .querySelector("#initiative_lead_group_new")
        .classList.remove("u-hidden");
    } else {
      document
        .querySelector("#initiative_lead_group_new")
        .classList.add("u-hidden");
    }
  });
