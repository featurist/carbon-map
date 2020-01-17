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

  L.tileLayer(
    "https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpejY4NXVycTA2emYycXBndHRqcmZ3N3gifQ.rJcFIG214AriISLbB6B5aw",
    {
      maxZoom: 18,
      attribution:
        '<a href="https://www.mapbox.com/" target="_blank">&copy; Mapbox</a> ' +
        '<a href="https://www.openstreetmap.org/copyright" target="_blank">&copy; OpenStreetMap</a>',
      id: "mapbox.streets"
    }
  ).addTo(animation_map);

  const markers = L.markerClusterGroup();
  animation_map.addLayer(markers);
  const markerList = [];

  const addInitiative = () => {
    const initiative = initiatives.shift();
    if (initiative) {
      document.getElementById("initiative_title").innerHTML = initiative.name;
      var marker = L.marker(initiative.location.latlng);
      markers.addLayer(marker);
      markerList.push(marker);

      const group = new L.featureGroup(markerList);
      animation_map.fitBounds(group.getBounds());

      setTimeout(addInitiative, 1000);
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
