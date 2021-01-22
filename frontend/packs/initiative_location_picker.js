import L from "leaflet";
import { GestureHandling } from "leaflet-gesture-handling";
import mobileCheck from "./mobileCheck";
import debounce from "./debounce";
import http from "httpism";
import { postcodeValidator } from "postcode-validator";

class LocationPicker {
  constructor() {
    const id = "location";
    const lat = document.querySelector('[name="initiative[latitude]"]').value;
    const lng = document.querySelector('[name="initiative[longitude]"]').value;

    this.postcodeElement = document.getElementById("initiative_postcode");
    this.postcodeUpdatingElement = document.getElementById(
      "initiative_postcode_updating"
    );
    this.postcodeErrorElement = document.getElementById(
      "initiative_postcode_error_message"
    );
    this.postcodeElement.addEventListener("input", () =>
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

    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 18,
      attribution:
        '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
      id: "mapbox.streets"
    }).addTo(locationMap);

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
    if (postcodeValidator(this.postcodeElement.value, "UK")) {
      this.postcodeElement.classList.remove("field_with_errors");
      this.postcodeErrorElement.classList.add("u-hidden");
    } else {
      this.postcodeElement.classList.add("field_with_errors");
      this.postcodeErrorElement.classList.remove("u-hidden");
      return;
    }
    debounce(async () => {
      this.postcodeUpdatingElement.classList.remove("u-hidden");
      const {
        status,
        result
      } = await http.get(
        `https://api.postcodes.io/postcodes/${this.postcodeElement.value}`,
        { exceptions: false }
      );
      this.postcodeUpdatingElement.classList.add("u-hidden");
      this.invalidPostcode = status !== 200;
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
