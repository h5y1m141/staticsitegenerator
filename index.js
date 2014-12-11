(function() {
  var ACS, acs, category_compiled, category_template, compiled, detail_page_template, divide_tokyo_23area, fs, modulePath, path, place_query, prefecture, prefecture_counter, prefecture_data, prefecture_list, revise_place_data, top_compiled, top_page_template, toppage, _, _i, _len;

  path = require("path");

  _ = require("underscore");

  modulePath = path.resolve(__dirname, "lib/acs.js");

  ACS = require(modulePath);

  fs = require('fs');

  top_page_template = fs.readFileSync('toppageTemplate.txt', 'utf-8');

  top_compiled = _.template(top_page_template);

  detail_page_template = fs.readFileSync('baseTemplate.txt', 'utf-8');

  compiled = _.template(detail_page_template);

  category_template = fs.readFileSync('indexTemplate.txt', 'utf-8');

  category_compiled = _.template(category_template);

  prefecture_list = [
    {
      prefecture_code: 1,
      name: "北海道"
    }, {
      prefecture_code: 2,
      name: "青森県"
    }, {
      prefecture_code: 3,
      name: "岩手県"
    }, {
      prefecture_code: 4,
      name: "宮城県"
    }, {
      prefecture_code: 5,
      name: "秋田県"
    }, {
      prefecture_code: 6,
      name: "山形県"
    }, {
      prefecture_code: 7,
      name: "福島県"
    }, {
      prefecture_code: 8,
      name: "茨城県"
    }, {
      prefecture_code: 9,
      name: "栃木県"
    }, {
      prefecture_code: 10,
      name: "群馬県"
    }, {
      prefecture_code: 11,
      name: "埼玉県"
    }, {
      prefecture_code: 12,
      name: "千葉県"
    }, {
      prefecture_code: 13,
      name: "東京都"
    }, {
      prefecture_code: 14,
      name: "神奈川県"
    }, {
      prefecture_code: 15,
      name: "新潟県"
    }, {
      prefecture_code: 16,
      name: "富山県"
    }, {
      prefecture_code: 17,
      name: "石川県"
    }, {
      prefecture_code: 18,
      name: "福井県"
    }, {
      prefecture_code: 19,
      name: "山梨県"
    }, {
      prefecture_code: 20,
      name: "長野県"
    }, {
      prefecture_code: 21,
      name: "岐阜県"
    }, {
      prefecture_code: 22,
      name: "静岡県"
    }, {
      prefecture_code: 23,
      name: "愛知県"
    }, {
      prefecture_code: 24,
      name: "三重県"
    }, {
      prefecture_code: 25,
      name: "滋賀県"
    }, {
      prefecture_code: 26,
      name: "京都府"
    }, {
      prefecture_code: 27,
      name: "大阪府"
    }, {
      prefecture_code: 28,
      name: "兵庫県"
    }, {
      prefecture_code: 29,
      name: "奈良県"
    }, {
      prefecture_code: 30,
      name: "和歌山県"
    }, {
      prefecture_code: 31,
      name: "鳥取県"
    }, {
      prefecture_code: 32,
      name: "島根県"
    }, {
      prefecture_code: 33,
      name: "岡山県"
    }, {
      prefecture_code: 34,
      name: "広島県"
    }, {
      prefecture_code: 35,
      name: "山口県"
    }, {
      prefecture_code: 36,
      name: "徳島県"
    }, {
      prefecture_code: 37,
      name: "香川県"
    }, {
      prefecture_code: 38,
      name: "愛媛県"
    }, {
      prefecture_code: 39,
      name: "高知県"
    }, {
      prefecture_code: 40,
      name: "福岡県"
    }, {
      prefecture_code: 41,
      name: "佐賀県"
    }, {
      prefecture_code: 42,
      name: "長崎県"
    }, {
      prefecture_code: 43,
      name: "熊本県"
    }, {
      prefecture_code: 44,
      name: "大分県"
    }, {
      prefecture_code: 45,
      name: "宮崎県"
    }, {
      prefecture_code: 46,
      name: "鹿児島県"
    }, {
      prefecture_code: 47,
      name: "沖縄県"
    }
  ];

  acs = new ACS();

  prefecture_data = [];

  prefecture_counter = 0;

  for (_i = 0, _len = prefecture_list.length; _i < _len; _i++) {
    prefecture = prefecture_list[_i];
    place_query = (function(item) {
      return acs.fetch_places(item.name, function(result) {
        var category, htmlData, place, places, prefecture_code, tbody, _data, _j, _len1;
        if (result.success) {
          places = result.places;
          tbody = [];
          htmlData = "<tr><td><a href='./prefecture/" + item.prefecture_code + "/index.html'>" + item.name + "</a></td><td>登録件数：" + places.length + "件</td></tr>\n";
          prefecture_data.push({
            index: item.prefecture_code,
            htmlData: htmlData
          });
          prefecture_counter++;
          if (prefecture_counter === 47) {
            toppage(prefecture_data);
          }
          if (item.name === "東京都") {
            tbody = divide_tokyo_23area(places);
          } else {
            for (_j = 0, _len1 = places.length; _j < _len1; _j++) {
              place = places[_j];
              place = revise_place_data(place);
              if (typeof place.prefecture_cd === "undefined") {
                prefecture_code = item.prefecture_code;
              }
              place.prefecture_cd = prefecture_code;
              _data = compiled(place);
              fs.writeFile("html/prefecture/" + item.prefecture_code + "/" + place.id + ".html", _data, function(err) {
                if (err) {
                  return console.log(err);
                } else {

                }
              });
              tbody.push("<tr><td><a href='./" + place.id + ".html'>" + place.name + "</a></td><td>" + place.address + "</td><td>" + place.category + "</td></tr>\n");
            }
          }
          return category = (function(tbody, state, prefecture_cd) {
            var category_data;
            console.log("start category state is " + state);
            category_data = category_compiled({
              tbody: tbody.join("\n"),
              state: state,
              prefecture_cd: prefecture_code
            });
            return fs.writeFile("html/prefecture/" + item.prefecture_code + "/index.html", category_data, function(err) {
              if (err) {
                return console.log(err);
              } else {

              }
            });
          })(tbody, item.name, item.prefecture_code);
        }
      });
    })(prefecture);
  }

  toppage = function(prefecture_data) {
    var d, item, toppage_data, _j, _len1;
    console.log("CraftBeerFanのトップページを生成");
    prefecture_data.sort(function(a, b) {
      if (a.index > b.index) {
        return -1;
      } else {
        return 1;
      }
    }).reverse();
    item = [];
    for (_j = 0, _len1 = prefecture_data.length; _j < _len1; _j++) {
      d = prefecture_data[_j];
      item.push(d.htmlData);
    }
    toppage_data = top_compiled({
      data: item.join("\n")
    });
    return fs.writeFile("html/index.html", toppage_data, function(err) {
      if (err) {
        return console.log(err);
      } else {
        return console.log("トップページ生成完了");
      }
    });
  };

  revise_place_data = function(place) {
    var category;
    if (typeof place.website === "undefined") {
      place.website = "調査中";
    }
    if (place.custom_fields.shopFlg === "true") {
      category = "買えるお店";
    } else {
      category = "飲めるお店";
    }
    place.category = category;
    if (typeof place.website === "undefined") {
      place.shop_data = "特に無し";
    } else {
      place.shop_data = place.custom_fields.shopInfo;
    }
    if (place.website === "調査中") {
      place.website = "調査中";
    } else {
      place.website = "<a href='" + place.website + "'>" + place.website + "</a>";
    }
    return place;
  };

  divide_tokyo_23area = function(places) {
    var place, prefecture_code, result, tbody, tokyo_district_23, tokyo_district_others, _data, _j, _k, _len1, _len2;
    tokyo_district_23 = [];
    tokyo_district_others = [];
    tbody = [];
    for (_j = 0, _len1 = places.length; _j < _len1; _j++) {
      place = places[_j];
      if (place.address.match(/^[^\x00-\x7F]+区/)) {
        tokyo_district_23.push(place);
      } else {
        tokyo_district_others.push(place);
      }
    }
    console.log("東京23区は" + tokyo_district_23.length);
    console.log("23区以外は" + tokyo_district_others.length);
    result = tokyo_district_23.concat(tokyo_district_others);
    for (_k = 0, _len2 = result.length; _k < _len2; _k++) {
      place = result[_k];
      prefecture_code = 13;
      place = revise_place_data(place);
      console.log(place.name + place.address.match(/^(千代田区|中央区|港区|新宿区|文京区|渋谷区|豊島区|台東区|墨田区|江東区|荒川区|足立区|葛飾区|江戸川区|品川区|目黒区|大田区|世田谷区|中野区|杉並区|練馬区|北区|板橋区)/));
      place.prefecture_cd = prefecture_code;
      _data = compiled(place);
      fs.writeFile("html/prefecture/" + prefecture_code + "/" + place.id + ".html", _data, function(err) {
        if (err) {
          return console.log(err);
        } else {

        }
      });
      tbody.push("<tr><td><a href='./" + place.id + ".html'>" + place.name + "</a></td><td>" + place.address + "</td><td>" + place.category + "</td></tr>\n");
    }
    return tbody;
  };

}).call(this);
