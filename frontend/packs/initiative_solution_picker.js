import hyperdom from "hyperdom";

class SolutionPicker {
  constructor({ taxonomy_hierarchy, initial_themes, initial_solutions }) {
    this.isValid = false;
    this.themes = [];
    this.solutions = [];
    this.value = "";
    this.results = [];
    this.navigation = {};
    this.taxonomy_hierarchy = taxonomy_hierarchy;

    this.solution_map = {};
    taxonomy_hierarchy.forEach(sector => {
      sector.themes.forEach(theme => {
        theme.classes.forEach(solution_class => {
          solution_class.solutions.forEach(solution => {
            const key = `${solution.solution_id}-${solution.solution_class_id}`;
            this.solution_map[key] = {
              sector: sector.name,
              theme: theme.name,
              class: solution_class.name,
              solution: solution.name,
              solution_id: solution.solution_id,
              solution_class_id: solution.solution_class_id
            };
          });
        });
      });
    });
    initial_themes.forEach(theme => {
      taxonomy_hierarchy.forEach(sector => {
        const taxonomy_theme = sector.themes.find(t => t.id === theme.theme_id);
        if (taxonomy_theme) {
          this.themes.push({
            theme_id: theme.theme_id,
            sector: sector.name,
            name: taxonomy_theme.name
          });
        }
      });
    });
    this.solutions = initial_solutions.map(sol => {
      const key = `${sol.solution_id}-${sol.solution_class_id}`;
      return this.solution_map[key];
    });
  }

  resetProposedSolution(solution_class_id) {
    this.proposedSolution = { proposed: true, solution_class_id };
  }

  render() {
    return (
      <div class="AddInitiativeSolution-lookup">
        {this.renderChosenSolutions()}
        {this.renderResults()}
      </div>
    );
  }

  navigate({ sector, theme, solutionClass } = {}) {
    if (sector) {
      this.navigation = { sector };
      return;
    }
    if (theme) {
      this.navigation = {
        sector: this.navigation.sector,
        theme
      };
      return;
    }
    if (solutionClass) {
      this.navigation = {
        sector: this.navigation.sector,
        theme: this.navigation.theme,
        solutionClass
      };
      return;
    }
    this.navigation = {};
  }

  renderResults() {
    if (this.value && this.results.length === 0) {
      return <p>No results</p>;
    }
    if (this.results.length > 0) {
      return (
        <ul class="AddInitiativeResults">
          {this.results.map(solution => {
            return (
              <li
                class="AddInitiativeResults-item"
                onclick={() => this.addSolution(solution)}
              >
                {solution.sector} > {solution.theme} > {solution.class} >{" "}
                {solution.solution}
              </li>
            );
          })}
        </ul>
      );
    }
    if (this.navigation) {
      return (
        <div class="AddInitiativeSolution-groupResults">
          {this.renderBreadcrumb()}
          <div class="AddInitiativeSolution-groupContainer">
            {this.renderSectors()}
            {this.renderThemes()}
            {this.renderClasses()}
            {this.renderSolutions()}
          </div>
        </div>
      );
    }
  }

  renderBreadcrumb() {
    const self = this;
    function renderSector() {
      if (self.navigation.sector) {
        return [
          <span>&nbsp;>&nbsp;</span>,
          <span
            onclick={() => self.navigate({ sector: self.navigation.sector })}
          >
            {self.navigation.sector.name}
          </span>
        ];
      }
    }
    function renderTheme() {
      if (self.navigation.theme) {
        return [
          <span>&nbsp;>&nbsp;</span>,
          <span onclick={() => self.navigate({ theme: self.navigation.theme })}>
            {self.navigation.theme.name}
          </span>
        ];
      }
    }
    function renderSolutionClass() {
      if (self.navigation.solutionClass) {
        return [
          <span>&nbsp;>&nbsp;</span>,
          <span
            onclick={() =>
              self.navigate({ solutionClass: self.navigation.solutionClass })
            }
          >
            {self.navigation.solutionClass.name}
          </span>
        ];
      }
    }
    function renderAll() {
      return (
        <span
          class="AddInitiativeSolution-clear"
          onclick={() => self.navigate()}
        >
          All
        </span>
      );
    }
    return (
      <div class="AddInitiativeSolution-breadcrumb">
        {renderAll()}
        {renderSector()}
        {renderTheme()}
        {renderSolutionClass()}
      </div>
    );
  }

  renderSectors() {
    return (
      <ul
        class={{
          "AddInitiativeSolution-group": true,
          "AddInitiativeSolution-groupSelected": this.navigation.sector
        }}
      >
        {this.taxonomy_hierarchy.map(sector => {
          return (
            <li onclick={() => this.navigate({ sector })}>{sector.name}</li>
          );
        })}
      </ul>
    );
  }

  renderThemes() {
    if (this.navigation.sector) {
      return (
        <ul
          class={{
            "AddInitiativeSolution-group": true,
            "AddInitiativeSolution-groupSelected": this.navigation.theme
          }}
        >
          {this.navigation.sector.themes.map(theme => {
            return (
              <li class="Taxonomy-item">
                <span
                  class="Taxonomy-itemName"
                  onclick={() => this.navigate({ theme })}
                >
                  {theme.name}
                </span>
                <span
                  class="AddInitiativeSolution-addSolution Taxonomy-itemAction"
                  onclick={() => {
                    this.addTheme({
                      sector: this.navigation.sector.name,
                      name: theme.name,
                      theme_id: theme.id
                    });
                  }}
                >
                  [ add ]
                </span>
              </li>
            );
          })}
        </ul>
      );
    }
  }

  renderClasses() {
    if (this.navigation.theme) {
      return (
        <ul
          class={{
            "AddInitiativeSolution-group": true,
            "AddInitiativeSolution-groupSelected": this.navigation.solutionClass
          }}
        >
          {this.navigation.theme.classes.map(solutionClass => {
            return (
              <li
                onclick={() => {
                  this.resetProposedSolution(solutionClass.solution_class_id);
                  this.navigate({ solutionClass });
                }}
              >
                {solutionClass.name}
              </li>
            );
          })}
        </ul>
      );
    }
  }

  renderSolutions() {
    if (this.navigation.solutionClass) {
      return (
        <ul class="AddInitiativeSolution-group AddInitiativeSolution-solutionSelector">
          {this.navigation.solutionClass.solutions.map(solution => {
            return this.renderSolution(solution);
          })}

          {this.renderSolution(this.proposedSolution)}
        </ul>
      );
    }
  }

  renderSolutionInput(solution) {
    if (solution.name && !solution.proposed) {
      return solution.name;
    }

    return (
      <label class="AddInitiativeSolution-proposedSolutionLabel">
        <span class="AddInitiativeSolution-proposedSolutionTitle">
          Can't find the solution you are after?
        </span>
        <input
          class="AddInitiativeSolution-proposedSolutionInput"
          type="text"
          binding="solution.name"
          placeholder="Enter your suggestion here"
        />
      </label>
    );
  }

  renderSolution(solution) {
    return (
      <li class="Taxonomy-item">
        <span class="Taxonomy-itemName">
          {this.renderSolutionInput(solution)}{" "}
        </span>
        <span
          class="AddInitiativeSolution-addSolution Taxonomy-itemAction"
          onclick={() => {
            this.addSolution({
              sector: this.navigation.sector.name,
              theme: this.navigation.theme.name,
              class: this.navigation.solutionClass.name,
              solution: solution.name,
              solution_id: solution.solution_id,
              solution_class_id: solution.solution_class_id,
              proposed: solution.proposed
            });
          }}
        >
          [ add ]
        </span>
      </li>
    );
  }

  renderChosenSolutions() {
    if (this.themes.length + this.solutions.length === 0) {
      return (
        <ul class="AddInitiativeSolution-solutions">
          <li>Please select a solution</li>
        </ul>
      );
    } else {
      return (
        <ul class="AddInitiativeSolution-solutions">
          {this.themes.map((theme, index) => {
            return (
              <li>
                {theme.sector} > {theme.name}
                <input
                  type="hidden"
                  name={`initiative[themes_attributes][${index}][theme_id]`}
                  value={theme.theme_id}
                />
              </li>
            );
          })}
          {this.solutions.map((solution, index) => {
            return (
              <li>
                {solution.sector} > {solution.theme} > {solution.class} >{" "}
                {solution.solution}
                &nbsp;
                <span
                  class="AddInitiativeSolution-removeSolution"
                  onclick={() => this.removeSolution(solution)}
                >
                  X
                </span>
                {this.renderSolutionField(solution, index)}
                <input
                  type="hidden"
                  name={`initiative[solutions_attributes][${index}][solution_class_id]`}
                  value={solution.solution_class_id}
                />
              </li>
            );
          })}
        </ul>
      );
    }
  }

  renderSolutionField(solution, index) {
    if (solution.proposed) {
      return (
        <input
          type="hidden"
          name={`initiative[solutions_attributes][${index}][proposed_solution]`}
          value={solution.solution}
        />
      );
    }
    return (
      <input
        type="hidden"
        name={`initiative[solutions_attributes][${index}][solution_id]`}
        value={solution.solution_id}
      />
    );
  }

  addTheme(theme) {
    this.themes.push(theme);
  }

  addSolution(solution) {
    this.solutions.push(solution);
    this.value = "";
    this.results = [];
    this.resetProposedSolution(solution.solution_class_id);
  }

  removeSolution(solution) {
    const solutionIndex = this.solutions.indexOf(solution);
    this.solutions.splice(solutionIndex, 1);
  }
}

function load() {
  const solution_picker = document.querySelector("#solution_picker");
  const initial_themes = JSON.parse(
    document.getElementById("initial_themes").value
  );
  const initial_solutions = JSON.parse(
    document.getElementById("initial_solutions").value
  );
  const taxonomy_hierarchy = JSON.parse(
    document.getElementById("taxonomy_hierarchy_json").innerText
  );
  hyperdom.append(
    solution_picker,
    new SolutionPicker({
      taxonomy_hierarchy,
      initial_themes,
      initial_solutions
    })
  );
}

function unload() {
  document.removeEventListener("turbolinks:load", load);
  document.removeEventListener("turbolinks:click", unload);
}

document.addEventListener("turbolinks:load", load);
document.addEventListener("turbolinks:click", unload);
