(function() {
  var ACS, acs, area_23, area_no_23, modulePath, path, _;

  path = require("path");

  _ = require("underscore");

  modulePath = path.resolve(__dirname, "lib/acs.js");

  ACS = require(modulePath);

  acs = new ACS();

  area_23 = [];

  area_no_23 = [];

  acs.fetch_places("東京都", function(result) {
    var place, places, _i, _len;
    if (result.success) {
      places = result.places;
      for (_i = 0, _len = places.length; _i < _len; _i++) {
        place = places[_i];
        if (place.address.match(/^[^\x00-\x7F]+区/)) {
          area_23.push(place.address + place.name);
        } else {
          area_no_23.push(place.address + place.name);
        }
      }
      console.log("東京23区は" + area_23.length);
      return console.log("23区以外は" + area_no_23.length);
    }
  });

}).call(this);
