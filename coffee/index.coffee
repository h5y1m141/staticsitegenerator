path = require("path")
_ = require("underscore")
modulePath = path.resolve(__dirname, "lib/acs.js")
ACS = require(modulePath)

# templateのファイルを読み込んでおく
fs = require('fs')
template = fs.readFileSync('baseTemplate.txt', 'utf-8');
compiled = _.template(template)
prefecture_list = [
  {
    prefecture_code: 1
    name: "北海道"
  }
  {
    prefecture_code: 2
    name: "青森県"
  }
  {
    prefecture_code: 3
    name: "岩手県"
  }
  {
    prefecture_code: 4
    name: "宮城県"
  }
  {
    prefecture_code: 5
    name: "秋田県"
  }
  {
    prefecture_code: 6
    name: "山形県"
  }
  {
    prefecture_code: 7
    name: "福島県"
  }
  {
    prefecture_code: 8
    name: "茨城県"
  }
  {
    prefecture_code: 9
    name: "栃木県"
  }
  {
    prefecture_code: 10
    name: "群馬県"
  }
  {
    prefecture_code: 11
    name: "埼玉県"
  }
  {
    prefecture_code: 12
    name: "千葉県"
  }
  {
    prefecture_code: 13
    name: "東京都"
  }
  {
    prefecture_code: 14
    name: "神奈川県"
  }
  {
    prefecture_code: 15
    name: "新潟県"
  }
  {
    prefecture_code: 16
    name: "富山県"
  }
  {
    prefecture_code: 17
    name: "石川県"
  }
  {
    prefecture_code: 18
    name: "福井県"
  }
  {
    prefecture_code: 19
    name: "山梨県"
  }
  {
    prefecture_code: 20
    name: "長野県"
  }
  {
    prefecture_code: 21
    name: "岐阜県"
  }
  {
    prefecture_code: 22
    name: "静岡県"
  }
  {
    prefecture_code: 23
    name: "愛知県"
  }
  {
    prefecture_code: 24
    name: "三重県"
  }
  {
    prefecture_code: 25
    name: "滋賀県"
  }
  {
    prefecture_code: 26
    name: "京都府"
  }
  {
    prefecture_code: 27
    name: "大阪府"
  }
  {
    prefecture_code: 28
    name: "兵庫県"
  }
  {
    prefecture_code: 29
    name: "奈良県"
  }
  {
    prefecture_code: 30
    name: "和歌山県"
  }
  {
    prefecture_code: 31
    name: "鳥取県"
  }
  {
    prefecture_code: 32
    name: "島根県"
  }
  {
    prefecture_code: 33
    name: "岡山県"
  }
  {
    prefecture_code: 34
    name: "広島県"
  }
  {
    prefecture_code: 35
    name: "山口県"
  }
  {
    prefecture_code: 36
    name: "徳島県"
  }
  {
    prefecture_code: 37
    name: "香川県"
  }
  {
    prefecture_code: 38
    name: "愛媛県"
  }
  {
    prefecture_code: 39
    name: "高知県"
  }
  {
    prefecture_code: 40
    name: "福岡県"
  }
  {
    prefecture_code: 41
    name: "佐賀県"
  }
  {
    prefecture_code: 42
    name: "長崎県"
  }
  {
    prefecture_code: 43
    name: "熊本県"
  }
  {
    prefecture_code: 44
    name: "大分県"
  }
  {
    prefecture_code: 45
    name: "宮崎県"
  }
  {
    prefecture_code: 46
    name: "鹿児島県"
  }
  {
    prefecture_code: 47
    name: "沖縄県"
  }
]    


acs = new ACS()
for prefecture in prefecture_list
  place_query = ((item) ->
    acs.fetch_places(item.name, (result) ->
      if result.success
        places = result.places
        for place in places
          if typeof place.website is "undefined"
            place.website = "調査中"
          if typeof place.prefecture_cd is "undefined"
            place.prefecture_cd = item.prefecture_code
            
          if place.custom_fields.shopFlg is true
            place.category = "買えるお店"
          else
            place.category = "飲めるお店"
            

          if typeof place.website is "undefined"
            place.shop_data = "特に無し"
          else  
            place.shop_data = place.custom_fields.shopInfo
              
          _data =  compiled(place)
          fs.writeFile("html/prefecture/#{item.prefecture_code}/#{place.id}.html", _data , (err)->
            if err
              console.log(err)
            else
              # console.log "ファイル出力完了"  
          )
    )

  )(prefecture)

