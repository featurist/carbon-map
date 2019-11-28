import L from "leaflet";
import "leaflet.markercluster";
import { GestureHandling } from "leaflet-gesture-handling";

let carbonExplorer, mappedInitiatives, markers;

function initialiseMap(initiatives) {
  L.Map.addInitHook("addHandler", "gestureHandling", GestureHandling);
  carbonExplorer = L.map("explore", {
    gestureHandling: true,
    center: [51.742, -2.222],
    zoom: 13
  });
  L.tileLayer(
    "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",
    {
      maxZoom: 18,
      attribution:
        '<a href="https://www.mapbox.com/" target="_blank">&copy; Mapbox</a> ' +
        '<a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap</a>',
      id: "mapbox.streets"
    }
  ).addTo(carbonExplorer);

  markers = L.markerClusterGroup();
  const explorePanel = document.querySelector(".Explore-panel");

  mappedInitiatives = initiatives.map(initiative => {
    var marker = L.marker(initiative.location.latlng);
    function item(title, value) {
      if (value) {
        return `<p>${title}: ${value}</p>`;
      }

      return "";
    }
    const initiativeHtml = `<h1>${initiative.name}</h1>
          ${
            initiative.images.length
              ? `
          <div class="Initiative-images_scroller">
            <div class="Initiative-images">
            ${initiative.images.map(imageUrl => {
              return `<img src=${imageUrl}" />`;
            })}
            </div>
          </div>`
              : ""
          }
          <p>${initiative.summary}</p>
          ${item("Group", initiative.group)}
          ${item("Contact Name", initiative.contactName)}
          ${item("Contact Email", initiative.contactEmail)}
          ${item("Contact Phone", initiative.contactPhone)}
          ${item("Status", initiative.status)}
          ${initiative.websites
            .map(
              website =>
                `<p>Website: <a target="_blank" href="${website}">${website}</a></p>`
            )
            .join("")}
          ${
            initiative.email
              ? `<p>Email: <a href="mailto:${initiative.email}">${initiative.email}</a></p>`
              : ""
          }
          ${initiative.themes
            .map(item => {
              return `<p>Sector: ${item.sector}</p>
              <p>Theme: ${item.theme}</p>`;
            })
            .join("")}
          ${initiative.solutions
            .map(item => {
              return `<p>Sector: ${item.sector}</p>
              <p>Theme: ${item.theme}</p>
              <p>Class: ${item.class}</p>
              <p>Solution: ${item.solution}</p>`;
            })
            .join("")}
          <p>Added On: ${initiative.timestamp}</p>
           `;

    marker.on("click", e => {
      const initiative = document.createElement("section");
      initiative.className = "InitiativeView";
      initiative.innerHTML = `
          <button class="InitiativeView-close">X</button>
          ${initiativeHtml}
        `;
      const initiativeContainer = document.querySelector(".Explore-initiative");
      while (initiativeContainer.firstChild) {
        initiativeContainer.removeChild(initiativeContainer.firstChild);
      }
      explorePanel.classList.add("Explore-panel_initiative_visible");
      initiativeContainer.appendChild(initiative);
      initiative
        .querySelector(".InitiativeView-close")
        .addEventListener("click", () => {
          initiativeContainer.removeChild(initiative);
          explorePanel.classList.remove("Explore-panel_initiative_visible");
          carbonExplorer.invalidateSize();
        });

      carbonExplorer.invalidateSize();
      carbonExplorer.panTo(e.latlng);
    });

    markers.addLayer(marker);

    return {
      initiative,
      marker
    };
  });
  carbonExplorer.addLayer(markers);
}

window.exploreMap = {
  select: function(el) {
    document.querySelectorAll(".Explore-navigation-selected").forEach(a => {
      a.classList.remove("Explore-navigation-selected");
    });
    el.classList.add("Explore-navigation-selected");
  },
  filter: function(attribute, value) {
    mappedInitiatives.forEach(init => markers.removeLayer(init.marker));

    mappedInitiatives
      .filter(init => {
        return (
          init.initiative.solutions.find(
            solution => solution[attribute] === value
          ) || init.initiative.themes.find(theme => theme[attribute] === value)
        );
      })
      .forEach(init => {
        markers.addLayer(init.marker);
      });
  },

  showAll: function() {
    mappedInitiatives.forEach(init => {
      markers.addLayer(init.marker);
    });
  }
};

window.addEventListener("load", function() {
  const initiatives = JSON.parse(
    document.getElementById("initiatives_json").innerText
  );
  initialiseMap(initiatives);
});
