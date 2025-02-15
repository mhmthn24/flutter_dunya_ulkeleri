import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dunya_ulkeleri/Ulke.dart';
import 'package:flutter_dunya_ulkeleri/UlkeDetay.dart';

class Favorilerlistelemeekrani extends StatefulWidget {
  List<Ulke> favoriler;
  Map<String, double> kurDegerleri;

  Favorilerlistelemeekrani(this.favoriler, this.kurDegerleri);

  @override
  State<Favorilerlistelemeekrani> createState() => _FavorilerlistelemeekraniState();
}

class _FavorilerlistelemeekraniState extends State<Favorilerlistelemeekrani> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context){
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.favoriler.length,
            itemBuilder: _buildListView,
          ),
        )
      ],
    );
  }

  Widget _buildListView(BuildContext context, int index){
    return Card(
      child: ListTile(
        title: Text(utf8.decode(widget.favoriler[index].ulke_ad.runes.toList())),
        subtitle: Text("Capital: ${utf8.decode(widget.favoriler[index].ulke_baskent.runes.toList())}"),
        leading: CircleAvatar(backgroundImage: NetworkImage(widget.favoriler[index].ulke_bayrak),),
        onTap: (){
          setState(() {
            _gitUlkeDetay(widget.favoriler[index], widget.kurDegerleri);
          });
        },
      ),
    );
  }

  AppBar _buildAppBar(){
    return AppBar(
      title: Text("Favourite Countries"),
    );
  }

  void _gitUlkeDetay(Ulke ulke, Map<String, double> kurDegerleri){
    MaterialPageRoute gidilecekSayfa = MaterialPageRoute(builder: (BuildContext context){
      return Ulkedetay(ulke, kurDegerleri);
    });
    Navigator.push(context, gidilecekSayfa);
  }
}
