import L from "leaflet";
import "leaflet.markercluster";
import { GestureHandling } from "leaflet-gesture-handling";

function initialiseMap({ initiatives, center }) {
  L.Map.addInitHook("addHandler", "gestureHandling", GestureHandling);
  const carbonExplorer = L.map("initiative_location", {
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
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(carbonExplorer);

  const markers = L.markerClusterGroup();
  initiatives.forEach(initiative => {
    var marker = L.marker(initiative.location.latlng);
    markers.addLayer(marker);
  });
  carbonExplorer.addLayer(markers);
}

window.addEventListener("load", function() {
  const map_data = JSON.parse(
    document.getElementById("map_data_json").innerText
  );
  initialiseMap(map_data);
});
