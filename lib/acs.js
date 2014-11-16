(function() {
  var ACS, _login;

  ACS = (function() {
    function ACS() {
      var conf;
      this.ACS = require('acs-node');
      conf = require('config');
      this.ACS.init(conf.acs.production);
    }

    ACS.prototype.fetch_places = function(callback) {
      return _login(this.ACS, (function(_this) {
        return function(response) {
          var session_id;
          session_id = response.meta.session_id;
          return _this.ACS.Places.query({
            page: 1,
            per_page: 200,
            session_id: session_id,
            where: {
              state: '神奈川県'
            }
          }, function(respose) {
            return callback(respose);
          });
        };
      })(this));
    };

    return ACS;

  })();

  module.exports = ACS;

  _login = function(ACS, callback) {
    var conf, data;
    conf = require('config');
    data = {
      login: conf.acs.user.id,
      password: conf.acs.user.password
    };
    return ACS.Users.login(data, function(response) {
      console.log(response);
      return callback(response);
    });
  };

}).call(this);
