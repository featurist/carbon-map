import L from "leaflet";
import "leaflet.markercluster";
import { GestureHandling } from "leaflet-gesture-handling";
import http from "httpism";
import "sidebar-v2/js/leaflet-sidebar";
import mobileCheck from "./mobileCheck";

let carbonExplorer, mappedInitiatives, markers;
L.Control.Breadcrumb = L.Control.extend({
  onAdd: function() {
    const div = L.DomUtil.create("div");
    div.style.clear = "none";
    div.classList.add("Explore-header");

    div.appendChild(document.querySelector(".Breadcrumb"));

    return div;
  },

  onRemove: function() {
    // Nothing to do here
  }
});

L.control.breadcrumb = function(opts) {
  return new L.Control.Breadcrumb(opts);
};

function initialiseMap({ initiatives, center }) {
  L.Map.addInitHook("addHandler", "gestureHandling", GestureHandling);
  carbonExplorer = L.map("explore", {
    gestureHandling: true,
    center: center,
    zoom: 13,
    zoomControl: false
  });

  L.control
    .zoom({
      position: "topright"
    })
    .addTo(carbonExplorer);

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 18,
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    id: "mapbox.streets"
  }).addTo(carbonExplorer);

  markers = L.markerClusterGroup();

  mappedInitiatives = initiatives.map(initiative => {
    var marker = L.marker(initiative.location.latlng);
    const initiativeHref = initiative.href;

    marker.on("click", e => {
      http
        .get(initiativeHref, {
          headers: { "content-type": "text/html", accept: "text/html" }
        })
        .then(initiativeHtml => {
          document.querySelector("#initiative").innerHTML = initiativeHtml;
          document.querySelector(".InitiativeSidebar-icon").style.display =
            "inherit";
          sidebar.open("initiative");
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
  const sidebar = L.control.sidebar("sidebar").addTo(carbonExplorer);

  if (document.querySelector(".Breadcrumb")) {
    console.log("add bread");
    L.control.breadcrumb({ position: "topleft" }).addTo(carbonExplorer);
  }

  if (!mobileCheck()) {
    openPaneIfPresent(sidebar, "wards");
    openPaneIfPresent(sidebar, "parishes");
    openPaneIfPresent(sidebar, "initiatives");
  }

  setTimeout(() => carbonExplorer.invalidateSize(true), 100);
}

function openPaneIfPresent(sidebar, pane) {
  if (sidebar._panes.find(p => p.id === pane)) {
    sidebar.open(pane);
  }
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
