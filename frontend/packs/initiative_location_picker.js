import L from "leaflet";
import { GestureHandling } from "leaflet-gesture-handling";
import mobileCheck from "./mobileCheck";
let locationMap;

function initialiseMap(id, location) {
  const isMobile = mobileCheck();
  let isDefaultLocation = true;
  if (!isMobile) {
    L.Map.addInitHook("addHandler", "gestureHandling", GestureHandling);
  }
  locationMap = L.map(id, {
    gestureHandling: !isMobile,
    center: [location.lat, location.lng],
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
  ).addTo(locationMap);

  const center = locationMap.getCenter();
  let marker = L.marker(center, { draggable: true, autoPan: true });
  marker.addTo(locationMap);

  marker.on("dragend", () => {
    const location = marker._latlng;
    document.querySelector('[name="initiative[latitude]"]').value =
      location.lat;
    document.querySelector('[name="initiative[longitude]"]').value =
      location.lng;
    locationMap.panTo(marker._latlng);
    isDefaultLocation = false;
  });

  return {
    isDefaultLocation() {
      return isDefaultLocation;
    },
    markerAt(latlng) {
      marker.setLatLng(latlng);
      locationMap.panTo(marker._latlng);
    }
  };
}
window.addEventListener("load", function() {
  const lat = document.querySelector('[name="initiative[latitude]"]').value;
  const lng = document.querySelector('[name="initiative[longitude]"]').value;
  initialiseMap("location", { lat, lng });
});
