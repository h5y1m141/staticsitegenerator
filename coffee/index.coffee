path = require("path")
_ = require("underscore")
modulePath = path.resolve(__dirname, "lib/acs.js")
ACS = require(modulePath)

# templateのファイルを読み込んでおく
fs = require('fs')
template = fs.readFileSync('baseTemplate.txt', 'utf-8');
compiled = _.template(template)

acs = new ACS()
acs.fetch_places( (result) ->
  if result.success
    places = result.places
    for place in places
      if typeof place.website is "undefined"
        place.website = "調査中"
          
      _data =  compiled(place)
      fs.writeFile("html/#{place.id}.html", _data , (err)->
        if err
          console.log(err)
        else
          console.log "ファイル出力完了"  
      )

)



