import L from "leaflet";
import "leaflet.markercluster";
import { GestureHandling } from "leaflet-gesture-handling";

L.Control.Title = L.Control.extend({
  onAdd: function() {
    const div = L.DomUtil.create("div");
    div.id = "initiative_title";
    div.style.clear = "none";
    div.classList.add("Explore-animationHeader");

    return div;
  },

  onRemove: function() {
    // Nothing to do here
  }
});

L.control.title = function(opts) {
  return new L.Control.Title(opts);
};

function initialiseMap({ initiatives, center }) {
  L.Map.addInitHook("addHandler", "gestureHandling", GestureHandling);
  const animation_map = L.map("animation_map", {
    gestureHandling: true,
    center: center,
    zoom: 13,
    zoomControl: false
  });

  L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
    maxZoom: 18,
    attribution:
      '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
    id: "mapbox.streets"
  }).addTo(animation_map);

  const markers = L.markerClusterGroup();
  animation_map.addLayer(markers);
  const markerList = [];
  const totalInitiatives = initiatives.length;

  const addInitiative = () => {
    const initiative = initiatives.shift();
    if (initiative) {
      document.getElementById("initiative_title").innerHTML = `${
        initiative.name
      } (${totalInitiatives - initiatives.length}/${totalInitiatives})`;
      var marker = L.marker(initiative.location.latlng);
      markers.addLayer(marker);
      markerList.push(marker);

      const group = new L.featureGroup(markerList);
      animation_map.fitBounds(group.getBounds());

      setTimeout(addInitiative, 3000);
    } else {
      setTimeout(() => {
        window.location.reload();
      }, 5000);
    }
  };

  L.control.title({ position: "topleft" }).addTo(animation_map);
  addInitiative();
}

window.addEventListener("load", function() {
  const map_data = JSON.parse(
    document.getElementById("map_data_json").innerText
  );
  initialiseMap(map_data);
});
