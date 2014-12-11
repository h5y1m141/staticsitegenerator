path = require("path")
_ = require("underscore")
modulePath = path.resolve(__dirname, "lib/acs.js")
ACS = require(modulePath)

# templateのファイルを読み込んでおく
fs = require('fs')

top_page_template = fs.readFileSync('toppageTemplate.txt', 'utf-8')
top_compiled = _.template(top_page_template)

detail_page_template = fs.readFileSync('baseTemplate.txt', 'utf-8')
compiled = _.template(detail_page_template)

category_template = fs.readFileSync('indexTemplate.txt', 'utf-8')
category_compiled = _.template(category_template)

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
prefecture_data = []
prefecture_counter = 0
for prefecture in prefecture_list
  place_query = ((item) ->
    acs.fetch_places(item.name, (result) ->
      if result.success
        places = result.places
        tbody = []
        # トップページの元データを準備
        htmlData = "<tr><td><a href='./prefecture/#{item.prefecture_code}/index.html'>#{item.name}</a></td><td>登録件数：#{places.length}件</td></tr>\n"
        prefecture_data.push({
          index:item.prefecture_code
          htmlData: htmlData
        }) 
        prefecture_counter++
        toppage(prefecture_data) if prefecture_counter is 47
        
        if item.name is "東京都"
          tbody = divide_tokyo_23area(places) 
        else
          for place in places
            place = revise_place_data(place)
            prefecture_code = item.prefecture_code if typeof place.prefecture_cd is "undefined"            
  
            # お店の詳細情報ページの生成
            place.prefecture_cd = prefecture_code  
            _data =  compiled(place)
            fs.writeFile("html/prefecture/#{item.prefecture_code}/#{place.id}.html", _data , (err)->
              if err
                console.log(err)
              else
                # console.log "ファイル出力完了"  
            )
  
            # 都道府県のインデックスページの元データを準備
            tbody.push "<tr><td><a href='./#{place.id}.html'>#{place.name}</a></td><td>#{place.address}</td><td>#{place.category}</td></tr>\n"


          
        # 都道府県のインデックスページ生成
        category = ( (tbody, state, prefecture_cd) ->
          console.log "start category state is #{state}"
          category_data =  category_compiled({
            tbody         : tbody.join("\n")
            state         : state
            prefecture_cd : prefecture_code
          })

          fs.writeFile("html/prefecture/#{item.prefecture_code}/index.html", category_data , (err)->
            if err
              console.log(err)
            else
              # console.log "インデックスページの生成完了"  
          )                   
        )(tbody, item.name, item.prefecture_code)
   
    )

  )(prefecture)


# CraftBeerFanのトップページを生成
toppage = (prefecture_data) ->
  console.log "CraftBeerFanのトップページを生成"
  prefecture_data.sort( (a, b) ->
    (if a.index > b.index then -1 else 1)
  ).reverse()


  item = []
  for d in prefecture_data
    item.push d.htmlData
    
  toppage_data = top_compiled ({data: item.join("\n")})

  fs.writeFile("html/index.html", toppage_data , (err)->
    if err
      console.log(err)
    else
      console.log "トップページ生成完了"  
  )                   

revise_place_data = (place) ->
  place.website = "調査中" if typeof place.website is "undefined"

  if place.custom_fields.shopFlg is "true"
    category = "買えるお店"
  else
    category = "飲めるお店"
    
  place.category = category
  if typeof place.website is "undefined"
    place.shop_data = "特に無し"
  else  
    place.shop_data = place.custom_fields.shopInfo
    
  if place.website is "調査中"
    place.website = "調査中"
  else
    place.website = "<a href='#{place.website}'>#{place.website}</a>"
  return place
  
divide_tokyo_23area = (places) ->
  tokyo_district_23 = []
  tokyo_district_others = []
  tbody = []
  for place in places
    # 23区のいづれかにマッチ
    # [^\x00-\x7F]でアスキー文字以外、つまり全角文字にマッチさせてそれが1文字以上続き区が含まれる
    if place.address.match(/^[^\x00-\x7F]+区/)
      tokyo_district_23.push place
    else
      tokyo_district_others.push place
      
  console.log "東京23区は#{tokyo_district_23.length}"
  console.log "23区以外は#{tokyo_district_others.length}"
  result = tokyo_district_23.concat(tokyo_district_others)

  for place in result
    prefecture_code = 13
    place = revise_place_data(place)
    console.log place.name + place.address.match(/^(千代田区|中央区|港区|新宿区|文京区|渋谷区|豊島区|台東区|墨田区|江東区|荒川区|足立区|葛飾区|江戸川区|品川区|目黒区|大田区|世田谷区|中野区|杉並区|練馬区|北区|板橋区)/)

    # お店の詳細情報ページの生成
    place.prefecture_cd = prefecture_code  
    _data =  compiled(place)
    fs.writeFile("html/prefecture/#{prefecture_code}/#{place.id}.html", _data , (err)->
      if err
        console.log(err)
      else
        # console.log "ファイル出力完了"  
    )

    # 都道府県のインデックスページの元データを準備
    tbody.push "<tr><td><a href='./#{place.id}.html'>#{place.name}</a></td><td>#{place.address}</td><td>#{place.category}</td></tr>\n"
  
  return tbody
