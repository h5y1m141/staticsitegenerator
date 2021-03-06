class ACS
  constructor: () ->
    @ACS = require('acs-node')
    conf = require('config')
    @ACS.init(conf.acs.production)

  fetch_places:(prefecture_name,callback) ->
    _login(@ACS,(response) =>
      session_id = response.meta.session_id
      @ACS.Places.query
        page: 1
        per_page: 500    
        session_id:session_id
        where:
          state: prefecture_name
      ,(respose) ->
        callback respose
        
    )

module.exports = ACS


#########################
# ここからはprivate method
#########################     
_login = (ACS,callback) ->
  conf = require 'config'
  data =
    login: conf.acs.user.id
    password:conf.acs.user.password     
  
  ACS.Users.login data, (response) ->
    callback response
    
