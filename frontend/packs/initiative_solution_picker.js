import hyperdom from "hyperdom";
import closeCircle from "../images/close-circle.svg";
import plusCircle from "../images/plus-circle.svg";

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
                {solution.sector} &gt; {solution.theme} &gt; {solution.class}{" "}
                &gt; {solution.solution}
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
          <span>&nbsp;&gt;&nbsp;</span>,
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
          <span>&nbsp;gt;&nbsp;</span>,
          <span onclick={() => self.navigate({ theme: self.navigation.theme })}>
            {self.navigation.theme.name}
          </span>
        ];
      }
    }
    function renderSolutionClass() {
      if (self.navigation.solutionClass) {
        return [
          <span>&nbsp;&gt;&nbsp;</span>,
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
      <div
        class={{
          "AddInitiativeSolution-group": true,
          "AddInitiativeSolution-groupSelected": this.navigation.sector
        }}
      >
        <h2>Sectors</h2>
        <ul>
          {this.taxonomy_hierarchy.map(sector => {
            return (
              <li>
                <a
                  href="#"
                  onclick={() => {
                    this.navigate({ sector });
                    return false;
                  }}
                >
                  {sector.name}
                </a>
              </li>
            );
          })}
        </ul>
      </div>
    );
  }

  renderThemes() {
    if (this.navigation.sector) {
      return (
        <div
          class={{
            "AddInitiativeSolution-group": true,
            "AddInitiativeSolution-groupSelected": this.navigation.theme
          }}
        >
          <h2>Themes</h2>
          <ul>
            {this.navigation.sector.themes.map(theme => {
              return (
                <li class="Taxonomy-item">
                  <a
                    class="Taxonomy-itemName"
                    href="#"
                    onclick={() => {
                      this.navigate({ theme });
                      return false;
                    }}
                  >
                    {theme.name}
                  </a>
                  <a
                    class="AddInitiativeSolution-add Taxonomy-itemAction"
                    title={`Add ${theme.name}`}
                    onclick={() => {
                      this.addTheme({
                        sector: this.navigation.sector.name,
                        name: theme.name,
                        theme_id: theme.id
                      });
                      return false;
                    }}
                  >
                    <img src={plusCircle} />
                  </a>
                </li>
              );
            })}
          </ul>
        </div>
      );
    }
  }

  renderClasses() {
    if (this.navigation.theme) {
      return (
        <div
          class={{
            "AddInitiativeSolution-group": true,
            "AddInitiativeSolution-groupSelected": this.navigation.solutionClass
          }}
        >
          <h2>Solution Class</h2>
          <ul>
            {this.navigation.theme.classes.map(solutionClass => {
              return (
                <li>
                  <a
                    href="#"
                    onclick={() => {
                      this.resetProposedSolution(
                        solutionClass.solution_class_id
                      );
                      this.navigate({ solutionClass });
                      return false;
                    }}
                  >
                    {solutionClass.name}
                  </a>
                </li>
              );
            })}
          </ul>
        </div>
      );
    }
  }

  renderSolutions() {
    if (this.navigation.solutionClass) {
      return (
        <div class="AddInitiativeSolution-group AddInitiativeSolution-solutionSelector">
          <h2>Solutions</h2>
          <ul>
            {this.navigation.solutionClass.solutions.map(solution => {
              return this.renderSolution(solution);
            })}

            {this.renderSolution(this.proposedSolution)}
          </ul>
        </div>
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
        <a
          class="AddInitiativeSolution-add"
          title={`Add ${solution.name}`}
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
            return false;
          }}
        >
          <img src={plusCircle} />
        </a>
      </li>
    );
  }

  renderChosenSolutions() {
    if (this.themes.length + this.solutions.length === 0) {
      return (
        <ul class="AddInitiativeSolution-solutions u-mb">
          <li>Please select a solution</li>
        </ul>
      );
    } else {
      return (
        <ul class="AddInitiativeSolution-solutions">
          {this.themes.map((theme, index) => {
            return (
              <li class="Solution-item">
                <span class="Solution-itemDescription">
                  {theme.sector} &gt; {theme.name}
                </span>
                <img
                  src={closeCircle}
                  onclick={() => this.removeTheme(theme)}
                  class="AddInitiativeSolution-remove"
                />
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
              <li class="Solution-item">
                <span class="Solution-itemDescription">
                  {solution.sector} &gt; {solution.theme} &gt; {solution.class}{" "}
                  &gt; {solution.solution}
                </span>
                <img
                  src={closeCircle}
                  class="AddInitiativeSolution-remove"
                  onclick={() => this.removeSolution(solution)}
                />
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

  removeTheme(theme) {
    const themeIndex = this.themes.indexOf(theme);
    this.themes.splice(themeIndex, 1);
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
