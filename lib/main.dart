import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<MyHomePage> {
  String girilenDers;
  int dersKredi = 1;
  double dersHarfDegeri = 4;
  List<Ders> tumDersler;
  var formKey = GlobalKey<FormState>();
  double ortalama = 0;
  static int sayac = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tumDersler = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Ortalama Hesapla"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (formKey.currentState.validate()) formKey.currentState.save();
        },
        child: Icon(Icons.add),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait)
          return uygulamaGovdesi();
        else
          return uygulamaGovdesiLandspace();
      }),
    );
  }

  Widget uygulamaGovdesi() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "Ders Adı",
                        labelStyle: TextStyle(color: Colors.blue, fontSize: 20),
                        hintStyle: TextStyle(fontSize: 16),
                        hintText: "Ders Adını Giriniz",
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2)),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                    validator: (girilenDeger) {
                      if (girilenDeger.length > 0)
                        return null;
                      else
                        return "Ders Adı boş bırakılamaz";
                    },
                    onSaved: (kaydedilecekDeger) {
                      girilenDers = kaydedilecekDeger;

                      setState(() {
                        tumDersler
                            .add(Ders(girilenDers, dersHarfDegeri, dersKredi));
                        ortalama = 0;
                        ortalamayiHesapla();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                              items: dersKredileriItems(),
                              value: dersKredi,
                              onChanged: (secilenKredi) {
                                setState(() {
                                  dersKredi = secilenKredi;
                                });
                              }),
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<double>(
                              items: dersHarfNotlari(),
                              value: dersHarfDegeri,
                              onChanged: (secilenHarf) {
                                setState(() {
                                  dersHarfDegeri = secilenHarf;
                                });
                              }),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: BorderDirectional(
                top: BorderSide(color: Colors.blue, width: 2),
                bottom: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                    text: "Ortalama: ",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  TextSpan(
                      text: tumDersler.length == 0
                          ? "0.00"
                          : "${ortalama.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold))
                ]),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView.builder(
                itemBuilder: _listeElemanlariniOlustur,
                itemCount: tumDersler.length,
              ),
            ),
          )
        ],
      ),
    );
  }

  dersKredileriItems() {
    List<DropdownMenuItem<int>> krediler = [];
    for (int i = 1; i < 21; i++) {
      krediler.add(
        DropdownMenuItem<int>(
          value: i,
          child: Text(
            "$i kredi",
            style: TextStyle(fontSize: 30),
          ),
        ),
      );
    }

    return krediler;
  }

  dersHarfNotlari() {
    List<DropdownMenuItem<double>> harfNotlari = [];
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        "AA",
        style: TextStyle(fontSize: 30),
      ),
      value: 4,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        "BA",
        style: TextStyle(fontSize: 30),
      ),
      value: 3.5,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        "BB",
        style: TextStyle(fontSize: 30),
      ),
      value: 3,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        "CB",
        style: TextStyle(fontSize: 30),
      ),
      value: 2.5,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        "CC",
        style: TextStyle(fontSize: 30),
      ),
      value: 2,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        "DC",
        style: TextStyle(fontSize: 30),
      ),
      value: 1.5,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        "DD",
        style: TextStyle(fontSize: 30),
      ),
      value: 1,
    ));
    harfNotlari.add(DropdownMenuItem(
      child: Text(
        "FF",
        style: TextStyle(fontSize: 30),
      ),
      value: 0,
    ));
    return harfNotlari;
  }

  Widget _listeElemanlariniOlustur(BuildContext context, int index) {
    sayac++;
    return Dismissible(
      key: Key(sayac.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        setState(() {
          tumDersler.removeAt(index);
          ortalama = 0;
          ortalamayiHesapla();
        });
      },
      child: Card(
        color: index % 2 == 0 ? Colors.blue.shade100 : Colors.white,
        margin: EdgeInsets.all(5),
        child: ListTile(
          leading: Icon(
            Icons.archive,
            size: 30,
            color: Colors.blue,
          ),
          title: Text(tumDersler[index].ad),
          trailing: Icon(
            Icons.chevron_right,
            size: 32,
          ),
          subtitle: Text(tumDersler[index].kredi.toString() +
              " kredi Ders Not Değer " +
              tumDersler[index].harfDegeri.toString()),
        ),
      ),
    );
  }

  void ortalamayiHesapla() {
    double toplamKredi = 0;
    double toplamNot = 0;
    for (var oankiDers in tumDersler) {
      toplamKredi += oankiDers.kredi;
      toplamNot += oankiDers.harfDegeri * oankiDers.kredi;
    }
    ortalama = toplamNot / toplamKredi;
  }

  Widget uygulamaGovdesiLandspace() {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                //color: Colors.pink.shade200,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Ders Adı",
                          hintText: "Ders adını giriniz",
                          hintStyle: TextStyle(fontSize: 18),
                          labelStyle: TextStyle(fontSize: 22),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        validator: (girilenDeger) {
                          if (girilenDeger.length > 0) {
                            return null;
                          } else
                            return "Ders adı boş olamaz";
                        },
                        onSaved: (kaydedilecekDeger) {
                          girilenDers = kaydedilecekDeger;
                          setState(() {
                            tumDersler.add(Ders(
                              girilenDers,
                              dersHarfDegeri,
                              dersKredi,
                            ));
                            ortalama = 0;
                            ortalamayiHesapla();
                          });
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int>(
                                items: dersKredileriItems(),
                                value: dersKredi,
                                onChanged: (secilenKredi) {
                                  setState(() {
                                    dersKredi = secilenKredi;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<double>(
                                items: dersHarfNotlari(),
                                value: dersHarfDegeri,
                                onChanged: (secilenHarf) {
                                  setState(() {
                                    dersHarfDegeri = secilenHarf;
                                  });
                                },
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 4),
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.blue, width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: BorderDirectional(
                        top: BorderSide(color: Colors.blue, width: 2),
                        bottom: BorderSide(color: Colors.blue, width: 2),
                      )),
                  child: Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text: "Ortalama: ",
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                        TextSpan(
                            text: tumDersler.length == 0
                                ? "0.00"
                                : "${ortalama.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold))
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
          flex: 1,
        ),
        Expanded(
          child: Container(
            child: ListView.builder(
              itemBuilder: _listeElemanlariniOlustur,
              itemCount: tumDersler.length,
            ),
          ),
        ),
      ],
    ));
  }
}

class Ders {
  String ad;
  double harfDegeri;
  int kredi;

  Ders(this.ad, this.harfDegeri, this.kredi);
}
