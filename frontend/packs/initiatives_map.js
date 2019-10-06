import initiatives from "./initiatives_data.json";
import L from "leaflet";
import "leaflet.markercluster";
import { GestureHandling } from "leaflet-gesture-handling";
import mobileCheck from "./mobileCheck";

let carbonExplorer, mappedInitiatives, markers;

function initialiseMap() {
  const isMobile = mobileCheck();
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
          <p>Sector: ${initiative.sector}</p>
          <p>Theme: ${initiative.theme}</p>
          <p>Solution: ${initiative.solution}</p>
          <p>Notes: ${initiative.notes}</p>
          <p>Added By: ${initiative.addedBy}</p>
          <p>Added On: ${initiative.timestamp}</p>
           `;
    if (isMobile) {
      marker.on("click", () => {
        const initiative = document.createElement("section");
        initiative.className = "InitiativeView";
        initiative.innerHTML = `
          <button class="InitiativeView-close">X</button>
          ${initiativeHtml}
        `;
        document.body.appendChild(initiative);
        document.body.classList.add("InitiativeView-disableScrolling");
        initiative
          .querySelector(".InitiativeView-close")
          .addEventListener("click", () => {
            document.body.removeChild(initiative);
            document.body.classList.remove("InitiativeView-disableScrolling");
          });
      });
    } else {
      marker.bindPopup(
        `<div class="InitiativeView-scroll">${initiativeHtml}</div>`
      );
    }
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
        return init.initiative[attribute] === value;
      })
      .forEach(init => {
        markers.addLayer(init.marker);
      });
  },

  showAll: function() {
    mappedInitiatives.forEach(init => {
      markers.addLayer(init.marker);
    });
  },

  getCenter: function() {
    console.log(carbonExplorer.getCenter());
  }
};

window.addEventListener("load", function() {
  initialiseMap();
});
