import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dunya_ulkeleri/Ulke.dart';
import 'package:url_launcher/url_launcher.dart';

class Ulkedetay extends StatelessWidget {
  Ulke ulke;
  Map<String, double> kurDegerleri;

  Ulkedetay(this.ulke, this.kurDegerleri);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(utf8.decode(ulke.ulke_ad.runes.toList())),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildBayrak(context),
            SizedBox(height: 16,),
            _buildDetayBilgi("Common Name:", ulke.ulke_ad),
            _buildDetayBilgi("Local Name:", ulke.ulke_yerel_ad),
            _buildDetayBilgi("Capital:", ulke.ulke_baskent),
            _buildDetayBilgi("Language:", ulke.ulke_dil),
            _buildDetayBilgi("Population:", ulke.ulke_nufus.toString()),
            _buildDetayBilgi("Region:", ulke.ulke_bolge),
            _buildDetayKurDegeri(),
            _buildHaritaButon()
          ],
        ),
      ),
    );
  }

  Widget _buildBayrak(BuildContext context){
    return Image.network(
      ulke.ulke_bayrak,
      width: MediaQuery.sizeOf(context).width / 2,
    );
  }

  Widget _buildDetayBilgi(String baslik, String detayBilgi){

    return Card(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
                Text(
                  utf8.decode(detayBilgi.runes.toList()),
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white
                  ),
                )
              ],
            ),
          ]
        ),
      ),
    );
  }

  Widget _buildDetayKurDegeri(){

    double? ulkeKurDegeri;
    if (ulke.ulke_para_birim != "-" && kurDegerleri.containsKey(ulke.ulke_para_birim)){
      ulkeKurDegeri = kurDegerleri[ulke.ulke_para_birim];
    }

    return Card(
      color: Colors.blueAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Currency:",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                  Text(
                    ulke.ulke_para_birim,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(ulkeKurDegeri != null)
                    Text(
                      "${ulke.ulke_para_birim} / USD",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    )
                  else
                    Text(
                      ulke.ulke_para_birim,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    ),
                  if(ulkeKurDegeri != null)
                    Text(
                      ulkeKurDegeri!.toStringAsFixed(4),
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                      ),
                    )
                ],
              )
            ]
        ),
      ),
    );
  }

  Widget _buildHaritaButon(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _haritayiAc,
        style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF111DAB),
            foregroundColor: Colors.white
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text("Open Map"),
            Padding(padding: EdgeInsets.all(8)),
            Icon(Icons.map, color: Colors.white,)
          ],
        ),
      ),
    );
  }

  Future<void> _haritayiAc() async {
    Uri uri = Uri.parse(ulke.ulke_map);

    if(await canLaunchUrl(uri)){
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw "Bağlantı açılamadı: ${ulke.ulke_map}";
    }
  }
}
