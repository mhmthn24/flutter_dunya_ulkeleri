import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dunya_ulkeleri/Ulke.dart';
import 'package:flutter_dunya_ulkeleri/UlkeDetay.dart';
import 'package:http/http.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  /*
    Kullanılan Ulke bilgilerinin JSON dokumani icin: https://restcountries.com

    Dokuman sayfasinda da belirttigi gibi
    https://restcountries.com/v3.1/all?fields= alanindan sonra dokumanda
    bulunan name, flags, capital gibi istenilen ozelliklere bakabilirsiniz.

    ************************************************************************

    Kullanılan para birimi JSON dokumani icin:

    Siteye uye olduktan sonra API Key alarak calisabilirsiniz.
   */
  final String _apiUlkeler = "https://restcountries.com/v3.1/all?fields=name,flags,"
      "cca2,independent,currencies,capital,region,languages,area,"
      "maps,population,continents";

  final String _baseCurrencyUrl = "https://api.exchangeratesapi.io/v1/"
      "latest?access_key=";

  /*
                         !!!!!!!!! ONEMLI NOT !!!!!!!!!
    Bu API anahtari calismadan sonra resetlenecektir. Bundan dolayı kendi API
    anahtarinizi buraya girmeniz gerekmektedir.
   */
  final String _apiKeyCurrency = "6cb7566eabbdd26123176016ab2fbd50";

  final List<Ulke> _ulkeler = [];
  Map<String, double> currencies = {};
  bool aramaAktif = false;
  TextEditingController _controllerArama = TextEditingController();
  FocusNode aramaFocus = FocusNode();
  List<Ulke> arananUlkeler = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _getUlkeler();
      _getCurrencies();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: _ulkeler.isNotEmpty
            ? _buildBody()
            : Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildBody(){
    /*
      Ana body tasarimi
     */
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingButton(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: aramaAktif ? arananUlkeler.length : _ulkeler.length,
              itemBuilder: _buildListViewBuilder,
            ),
          )
        ],
      ),
    );
  }

  AppBar _buildAppBar(){
    /*
      App bar tasarimi
      * Burada arama durumuna bagli olarak tasarim yapildi.
      * Arama aktifse, textfield eklemesi yapildi.
     */
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          if(!aramaAktif)
            Text("Countries", style: TextStyle(color: Colors.white),)
          else
            Expanded(
              child: TextField(
                controller: _controllerArama,
                focusNode: aramaFocus,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white)
                  )
                ),
                cursorColor: Colors.white,
                style: TextStyle(
                  color: Colors.white
                ),
                onChanged: _aramaYap,
              ),
            ),
          IconButton(
            onPressed: (){
              setState(() {
                aramaAktif = !aramaAktif;
                if(aramaAktif){
                  // arama true olunca klavyeyi açalım
                  Future.delayed(Duration(milliseconds: 100), (){
                    aramaFocus.requestFocus();
                  });
                }else{
                  // arama false durumuna geçince değerleri temizleyelim
                  arananUlkeler.clear();
                  _controllerArama.clear();
                  aramaFocus.unfocus();
                }
              });
            },
            icon: aramaAktif
                ? Icon(Icons.cancel_outlined, color: Colors.white, size: 30,)
                : Icon(Icons.search, color: Colors.white, size: 30,),
          )
        ],
      ),
      backgroundColor: Color(0xFF111DAB),
    );
  }

  Widget _buildFloatingButton(){
    return Padding(
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
    );
  }

  Widget _buildListViewBuilder(BuildContext context, int index){
    /*
      Eger arama true durumundaysa, kullanıcıya text girişine göre
      ülkeleri gösterelim.
     */
    List<Ulke> gosterilecekUlkeler = aramaAktif ? arananUlkeler : _ulkeler;

    return Card(
      child: ListTile(
        title: Text(utf8.decode(gosterilecekUlkeler[index].ulke_ad.runes.toList())),
        subtitle: Text("Capital: ${utf8.decode(gosterilecekUlkeler[index].ulke_baskent.runes.toList())}"),
        leading: CircleAvatar(backgroundImage: NetworkImage(gosterilecekUlkeler[index].ulke_bayrak),),
        trailing: Icon(Icons.favorite_border, color: Colors.red,),
        onTap: (){
          setState(() {
            _gitUlkeDetay(gosterilecekUlkeler[index], currencies);
          });
        },
      ),
    );
  }

  void _aramaYap(String aramaGiris){
    /*
      Kullanıcının her girdiği harfe karşılık olarak arama yapalım
     */
    setState(() {
      String arananKelime = aramaGiris.trim().toLowerCase();
      if(arananKelime.isNotEmpty){
        arananUlkeler = _ulkeler
            .where((ulke) => ulke.ulke_ad.toLowerCase().contains(arananKelime))
            .toList();
      }else{
        arananUlkeler.clear();
      }
    });
  }

  void _getUlkeler() async {
    /*
      API kullanarak ulke bilgilerini alalim
     */
    Uri uri = Uri.parse(_apiUlkeler);
    Response response = await get(uri);

    // Gelen JSON response Liste türünde gelmekte
    List<dynamic> parsedResponse = jsonDecode(response.body);

    for(int i = 0; i < parsedResponse.length; i++){
      Map<String, dynamic> ulkeMap = parsedResponse[i];
      Ulke ulke = Ulke.fromMap(ulkeMap);

      _ulkeler.add(ulke);
    }
    // Ulke adına göre sıralama yapalım
    _ulkeler.sort((a, b) => a.ulke_ad.compareTo(b.ulke_ad));
    setState(() {});
  }

  void _gitUlkeDetay(Ulke ulke, Map<String, double> kurDegerleri){
    MaterialPageRoute gidilecekSayfa = MaterialPageRoute(builder: (BuildContext context){
      return Ulkedetay(ulke, kurDegerleri);
    });
    Navigator.push(context, gidilecekSayfa);
  }

  void _getCurrencies() async {
    Uri uri = Uri.parse(_baseCurrencyUrl + _apiKeyCurrency);
    Response response = await get(uri);

    Map<String, dynamic> parsedCurrency = jsonDecode(response.body);
    Map<String, dynamic> rates = parsedCurrency["rates"];

    /*
      Burada hangi ulkenin kurunu base almak istersek onun donusumunu
      yapiyoruz. API dan gelen degerler EURO bazında degerlerdir. Burada da
      istedigimiz kur bazinda donusum yapiyoruz.
     */
    double? baseKur = double.tryParse(rates["USD"].toString());
    if (baseKur != null){
      for (String kur_adi in rates.keys){
        double? ulkeKur = double.tryParse(rates[kur_adi].toString());
        if(ulkeKur != null){
          double kurDegeri = baseKur / ulkeKur;
          currencies[kur_adi] = kurDegeri;
        }
      }
    }
    setState(() {});
  }
}

