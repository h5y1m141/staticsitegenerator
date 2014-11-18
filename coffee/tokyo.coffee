path = require("path")
_ = require("underscore")
modulePath = path.resolve(__dirname, "lib/acs.js")
ACS = require(modulePath)


acs = new ACS()
area_23 = []
area_no_23 = []
acs.fetch_places("東京都", (result) ->
  if result.success
    places = result.places
    for place in places
      # 23区のいづれかにマッチ
      # [^\x00-\x7F]でアスキー文字以外、つまり全角文字にマッチさせてそれが1文字以上続き区が含まれる
      if place.address.match(/^[^\x00-\x7F]+区/)
        area_23.push(place.address + place.name)
      else
        area_no_23.push(place.address + place.name)          
           
      # console.log place.address + place.name if place.address.match(/^(千代田区|中央区|港区|新宿区|文京区|渋谷区|豊島区|台東区|墨田区|江東区|荒川区|足立区|葛飾区|江戸川区|品川区|目黒区|大田区|世田谷区|中野区|杉並区|練馬区|北区|板橋区)/)

      # # 市のいづれかにマッチ
      # if place.address.match(/^[^\x00-\x7F]+市/)
      #
    console.log "東京23区は#{area_23.length}"
    console.log "23区以外は#{area_no_23.length}"    
)

