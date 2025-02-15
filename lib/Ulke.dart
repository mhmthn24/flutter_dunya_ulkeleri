class Ulke{
  String ulke_kod;
  String ulke_ad;
  String ulke_yerel_ad;
  String ulke_baskent;
  String ulke_bayrak;
  int ulke_nufus;
  String ulke_bagimsizlik;
  String ulke_bolge;
  String ulke_map;
  String ulke_dil;
  String ulke_para_birim;

  Ulke.fromMap(Map<String, dynamic> ulkeMap):
    ulke_kod = ulkeMap["cca2"] ?? "-",
    ulke_ad = ulkeMap["name"]?["common"] ?? "-",
    ulke_yerel_ad = (ulkeMap["name"]["nativeName"] as Map<String, dynamic>?)
        ?.values
        .map((e) => e["common"])
        .firstWhere((element) => element != null, orElse: () => "-"),
    ulke_dil = ((ulkeMap["languages"] ?? {}) as Map<String, dynamic>)
        .values.join(", ") ?? "-",
    ulke_bayrak = ulkeMap["flags"]?["png"] ?? "-",
    ulke_baskent = (ulkeMap["capital"] as List<dynamic>).isNotEmpty ? ulkeMap["capital"][0] : "-",
    ulke_nufus = ulkeMap["population"] ?? 0,
    ulke_bagimsizlik = ulkeMap["independent"].toString() ?? "-",
    ulke_bolge = ulkeMap["region"] ?? "-",
    ulke_map = ulkeMap["maps"]?["googleMaps"] ?? "-",
    ulke_para_birim = (ulkeMap["currencies"] is Map<String, dynamic> &&
        (ulkeMap["currencies"] as Map<String, dynamic>).isNotEmpty)
        ? (ulkeMap["currencies"] as Map<String, dynamic>).keys.first
        : "-";
}
/*
[
   {
      "flags":{
         "png":"https://flagcdn.com/w320/tr.png",
         "svg":"https://flagcdn.com/tr.svg",
         "alt":"The flag of Turkey has a red field bearing a large fly-side facing white crescent and a smaller five-pointed white star placed just outside the crescent opening. The white crescent and star are offset slightly towards the hoist side of center."
      },
      "name":{
         "common":"Turkey",
         "official":"Republic of Turkey",
         "nativeName":{
            "tur":{
               "official":"Türkiye Cumhuriyeti",
               "common":"Türkiye"
            }
         }
      },
      "cca2":"TR",
      "independent":true,
      "currencies":{
         "TRY":{
            "name":"Turkish lira",
            "symbol":"₺"
         }
      },
      "capital":[
         "Ankara"
      ],
      "region":"Asia",
      "languages":{
         "tur":"Turkish"
      },
      "area":783562.0,
      "maps":{
         "googleMaps":"https://goo.gl/maps/dXFFraiUDfcB6Quk6",
         "openStreetMaps":"https://www.openstreetmap.org/relation/174737"
      },
      "population":84339067,
      "continents":[
         "Europe",
         "Asia"
      ]
   }
]
 */