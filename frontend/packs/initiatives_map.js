import L from "leaflet";
import "leaflet.markercluster";
import { GestureHandling } from "leaflet-gesture-handling";

let carbonExplorer, mappedInitiatives, markers;

function initialiseMap({ initiatives, center }) {
  L.Map.addInitHook("addHandler", "gestureHandling", GestureHandling);
  carbonExplorer = L.map("explore", {
    gestureHandling: true,
    center: center,
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
    const initiativeHtml = `<div class="InitiativeView-title">
            <h1 class="InitiativeView-titleText"><a href="${initiative.href}">${
      initiative.name
    }</a></h1>
            <button class="InitiativeView-close">X</button>
          </div>
          ${
            initiative.images.length
              ? `
          <div class="Initiative-images_scroller">
            <div class="Initiative-images">
            ${initiative.images
              .map(imageUrl => {
                return `<img src=${imageUrl}" />`;
              })
              .join("")}
            </div>
          </div>`
              : ""
          }
          ${item("What?", initiative.description_what)}
          ${item("How?", initiative.description_how)}
          ${item(
            "Further Information",
            initiative.description_further_information
          )}
          ${item("Group", initiative.group)}
          ${item("Contact Name", initiative.contact_name)}
          ${item("Contact Email", initiative.contact_email)}
          ${item("Contact Phone", initiative.contact_phone)}
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
              return `<p>Theme: ${item.sector}, ${item.theme}</p>`;
            })
            .join("")}
          ${initiative.solutions
            .map(item => {
              return `<p>Solution: ${item.sector}, ${item.theme}, ${item.class}, ${item.solution}</p>`;
            })
            .join("")}
          <p>Last updated: ${initiative.last_updated}</p>
          <p><a href="${initiative.href}">View full details</a></p>
           `;

    marker.on("click", e => {
      const initiative = document.createElement("section");
      initiative.className = "InitiativeView";
      initiative.innerHTML = initiativeHtml;
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
  const group = new L.featureGroup(mappedInitiatives.map(x => x.marker));

  carbonExplorer.fitBounds(group.getBounds());
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
  const map_data = JSON.parse(
    document.getElementById("map_data_json").innerText
  );
  initialiseMap(map_data);
});
