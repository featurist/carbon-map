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
        'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' +
        '<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
        'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
      id: "mapbox.streets"
    }
  ).addTo(carbonExplorer);

  markers = L.markerClusterGroup();
  const explorePanel = document.querySelector(".Explore-panel");

  mappedInitiatives = initiatives.map(initiative => {
    var marker = L.marker(initiative.location.latlng);
    const initiativeHtml = `<h1>${initiative.name}</h1>
          <p>${initiative.summary}</p>
          <p>Group: ${initiative.group}</p>
          <p>Contact Name: ${initiative.contactName}</p>
          <p>Status: ${initiative.status}</p>
          ${
            initiative.website
              ? `<p>Website: <a target="_blank" href="${initiative.website}">${initiative.website}</a></p>`
              : ""
          }
          ${
            initiative.email
              ? `<p>Email: <a href="mailto:${initiative.email}">${initiative.email}</a></p>`
              : ""
          }
          ${initiative.solutions
            .map(item => {
              return `<p>Sector: ${item.sector}</p>
              <p>Theme: ${item.theme}</p>
              <p>Class: ${item.class}</p>
              <p>Solution: ${item.solution}</p>`;
            })
            .join("")}
          <p>Notes: ${initiative.notes}</p>
          <p>Added By: ${initiative.addedBy}</p>
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
  filter: function(attribute, value) {
    mappedInitiatives.forEach(init => markers.removeLayer(init.marker));

    mappedInitiatives
      .filter(init => {
        return init.initiative.solutions.find(
          solution => solution[attribute] === value
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
