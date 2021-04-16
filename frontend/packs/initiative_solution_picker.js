import groupBy from "lowscore/groupBy";

window.addEventListener("load", () => {
  const taxonomy_hierarchy = JSON.parse(
    document.getElementById("taxonomy_hierarchy_json").innerText
  );

  const solutions = [];
  let matchingSolutions = solutions;
  taxonomy_hierarchy.forEach(sector => {
    sector.themes.forEach(theme => {
      theme.classes.forEach(solution_class => {
        solution_class.solutions.forEach(solution => {
          const key = `${solution.solution_id},${solution.solution_class_id}`;
          solutions.push({
            key,
            sector: sector.name,
            theme: theme.name,
            class: solution_class.name,
            solution: solution.name,
            solution_id: solution.solution_id,
            solution_class_id: solution.solution_class_id,
            name: `${sector.name} > ${theme.name} > ${solution_class.name} > ${solution.name}`,
            display: `${theme.name}, ${solution_class.name}, ${solution.name}`
          });
        });
      });
    });
  });

  const results = document.getElementById("solution_search_results");
  const chosenSolutions = document.getElementById("chosenSolutions");
  const selectedSolutions = new Set();
  Array.from(chosenSolutions.querySelectorAll(".ChosenSolution input")).forEach(
    selected => {
      selectedSolutions.add({
        key: selected.value,
        name: selected.getAttribute("data-name")
      });
    }
  );

  function renderSelected() {
    if (selectedSolutions.size > 0) {
      chosenSolutions.classList.remove("u-hidden");
    } else {
      chosenSolutions.classList.add("u-hidden");
    }
    chosenSolutions.innerHTML = Array.from(selectedSolutions)
      .map(solution => {
        return `
        <li class="ChosenSolution">
          <input type="hidden" name="initiative[solutions][]" value="${solution.key}" />
          ${solution.name}
        </li>`;
      })
      .join("");
  }
  results.addEventListener("click", e => {
    if (e.target.tagName.toLowerCase() === "input") {
      const item = {
        key: e.target.value,
        name: e.target.getAttribute("data-name")
      };
      const existing = Array.from(selectedSolutions).find(
        s => s.key == item.key
      );
      if (existing) {
        selectedSolutions.delete(existing);
      } else {
        selectedSolutions.add(item);
      }
      renderSelected();
    }
  });

  const searchInput = document.getElementById("solution_search");
  const solutionResultsContainer = document.getElementById(
    "solution_results_container"
  );

  document
    .getElementById("close_solution_results")
    .addEventListener("click", e => {
      e.preventDefault();
      solutionResultsContainer.classList.add("u-hidden");
    });

  searchInput.addEventListener("click", () => {
    solutionResultsContainer.classList.remove("u-hidden");

    renderSolutions();
  });

  searchInput.addEventListener("input", e => {
    const input = e.target.value.toLowerCase();

    matchingSolutions = solutions.filter(solution => {
      return (
        solution.sector.toLowerCase().includes(input) ||
        solution.theme.toLowerCase().includes(input) ||
        solution.class.toLowerCase().includes(input) ||
        solution.solution.toLowerCase().includes(input)
      );
    });

    renderSolutions();
  });

  function renderSolutions() {
    const solutionsBySector = groupBy(matchingSolutions, "sector");
    const selectedKeys = Array.from(selectedSolutions).map(s => s.key);
    results.innerHTML = Object.keys(solutionsBySector)
      .map(sector => {
        return `<div><h3 class="SolutionSearch-sector">${sector}</h3>
        ${solutionsBySector[sector]
          .map(solution => {
            return `<label class="SolutionSearch-result"><span>${
              solution.display
            }</span><input ${
              selectedKeys.indexOf(solution.key) == -1 ? "" : "checked"
            } type="checkbox" value="${solution.key}" data-name="${
              solution.name
            }"/></label>`;
          })
          .join("")}`;
      })
      .join("");
  }
});
