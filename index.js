(function() {
  var ACS, acs, compiled, fs, modulePath, path, template, _;

  path = require("path");

  _ = require("underscore");

  modulePath = path.resolve(__dirname, "lib/acs.js");

  ACS = require(modulePath);

  fs = require('fs');

  template = fs.readFileSync('baseTemplate.txt', 'utf-8');

  compiled = _.template(template);

  acs = new ACS();

  acs.fetch_places(function(result) {
    var place, places, _data, _i, _len, _results;
    if (result.success) {
      places = result.places;
      _results = [];
      for (_i = 0, _len = places.length; _i < _len; _i++) {
        place = places[_i];
        if (typeof place.website === "undefined") {
          place.website = "調査中";
        }
        _data = compiled(place);
        _results.push(fs.writeFile("html/" + place.id + ".html", _data, function(err) {
          if (err) {
            return console.log(err);
          } else {
            return console.log("ファイル出力完了");
          }
        }));
      }
      return _results;
    }
  });

}).call(this);
