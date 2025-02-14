import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dunya_ulkeleri/Ulke.dart';
import 'package:http/http.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final String _apiURL = "https://restcountries.com/v3.1/all?fields=name,flags,"
      "cca2,independent,currencies,capital,region,languages,area,"
      "maps,population,continents";

  final List<Ulke> _ulkeler = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getUlkeler();
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: _ulkeler.isNotEmpty ? _buildBody() : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBody(){
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8),
        child: FloatingActionButton(
          backgroundColor: Colors.indigo,
          splashColor: Colors.blue,
          onPressed: (){},
          child: Icon(
            Icons.favorite,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _ulkeler.length,
              itemBuilder: _buildListViewBuilder,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildListViewBuilder(BuildContext context, int index){
    return Card(
      child: ListTile(
        title: Text(_ulkeler[index].ulke_ad),
        subtitle: Text("Başkent: ${_ulkeler[index].ulke_baskent}"),
        leading: CircleAvatar(backgroundImage: NetworkImage(_ulkeler[index].ulke_bayrak),),
        trailing: Icon(Icons.favorite_border, color: Colors.red,),
      ),
    );
  }

  void _getUlkeler() async {
    Uri uri = Uri.parse(_apiURL);
    Response response = await get(uri);

    List<dynamic> parsedResponse = jsonDecode(response.body);

    for(int i = 0; i < parsedResponse.length; i++){
      Map<String, dynamic> ulkeMap = parsedResponse[i];
      Ulke ulke = Ulke.fromMap(ulkeMap);

      _ulkeler.add(ulke);
    }
    _ulkeler.sort((a, b) => a.ulke_ad.compareTo(b.ulke_ad));
    setState(() {});
  }

}

