import L from "leaflet";
import { GestureHandling } from "leaflet-gesture-handling";
import mobileCheck from "./mobileCheck";
import debounce from "./debounce";
import http from "httpism";

class LocationPicker {
  constructor() {
    const id = "location";
    const lat = document.querySelector('[name="initiative[latitude]"]').value;
    const lng = document.querySelector('[name="initiative[longitude]"]').value;

    this.postcodeElement = document.getElementById("initiative_postcode");
    this.postcodeElement.addEventListener("change", () =>
      this.lookupPostcodeCoordinates()
    );
    const location = { lat, lng };

    const isMobile = mobileCheck();
    this._isDefaultLocation = true;
    if (!isMobile) {
      L.Map.addInitHook("addHandler", "gestureHandling", GestureHandling);
    }
    let locationMap = L.map(id, {
      gestureHandling: !isMobile,
      center: [location.lat, location.lng],
      zoom: 13
    });
    this.locationMap = locationMap;
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
    this.marker = marker;
    marker.addTo(locationMap);

    marker.on("dragend", () => {
      const location = marker._latlng;
      document.querySelector('[name="initiative[latitude]"]').value =
        location.lat;
      document.querySelector('[name="initiative[longitude]"]').value =
        location.lng;
      locationMap.panTo(marker._latlng);
      this._isDefaultLocation = false;
    });
  }

  isDefaultLocation() {
    return this._isDefaultLocation;
  }

  markerAt(latlng) {
    this.marker.setLatLng(latlng);
    this.locationMap.panTo(this.marker._latlng);
  }

  lookupPostcodeCoordinates() {
    if (!this.isDefaultLocation()) {
      return;
    }
    debounce(async () => {
      const {
        status,
        result
      } = await http.get(
        `https://api.postcodes.io/postcodes/${this.postcodeElement.value}`,
        { exceptions: false }
      );
      this.invalidPostcode = status !== 200;
      //this.refresh()
      if (status === 200) {
        this.markerAt([result.latitude, result.longitude]);
        document.querySelector('[name="initiative[latitude]"]').value =
          result.latitude;
        document.querySelector('[name="initiative[longitude]"]').value =
          result.longitude;
      }
    }, 1000)();
  }
}

new LocationPicker();
