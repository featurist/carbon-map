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
