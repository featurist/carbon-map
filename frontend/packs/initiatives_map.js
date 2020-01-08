import L from "leaflet";
import "leaflet.markercluster";
import { GestureHandling } from "leaflet-gesture-handling";
import http from "httpism";
import "sidebar-v2/js/leaflet-sidebar";

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
    const initiativeHref = initiative.href;

    marker.on("click", e => {
      http
        .get(initiativeHref, {
          headers: { "content-type": "text/html", accept: "text/html" }
        })
        .then(initiativeHtml => {
          const initiative = document.createElement("section");
          initiative.className = "InitiativeView";
          initiative.innerHTML = initiativeHtml;
          const initiativeContainer = document.querySelector(
            ".Explore-initiative"
          );
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
  L.control.sidebar("sidebar").addTo(carbonExplorer);
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
