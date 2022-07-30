import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:numberpicker/numberpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Vücut Kitle Endeksi Hesaplama"),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentValue = 120;
  int _currentValue2 = 70;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Baslik("Kilo"),
        KiloNumber(context),
        const SizedBox(
          height: 15,
        ),
        Baslik("Boy"),
        BoyNumber(context),
        HesaplaButonu(context),
      ],
    );
  }

  Widget Baslik(String baslik) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        baslik,
        style: const TextStyle(color: Colors.greenAccent, fontSize: 22),
      ),
    );
  }

  Widget BoyNumber(BuildContext context) {
    return Column(
      children: <Widget>[
        NumberPicker(
          itemWidth: 60,
          itemCount: 8,
          axis: Axis.horizontal,
          value: _currentValue,
          minValue: 20,
          maxValue: 200,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
      ],
    );
  }

  Widget KiloNumber(BuildContext context) {
    return Column(
      children: <Widget>[
        NumberPicker(
          value: _currentValue2,
          minValue: 20,
          maxValue: 200,
          onChanged: (value) => setState(() => _currentValue2 = value),
        ),
      ],
    );
  }

  Widget TextFormFieldKilo() {
    return Row(
      children: [
        const SizedBox(
          width: 5,
        ),
        const Text(
          "Kilo",
          style: TextStyle(color: Colors.blue, fontSize: 18),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              autocorrect: false,
              cursorColor: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }

  Widget HesaplaButonu(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(onPrimary: Colors.white),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              double kitleEndeksiSonuc =
                  KitleEndeksiHesapla(_currentValue2, _currentValue);
              List<String> sonucListesi = KitleEndeksiSonuc(kitleEndeksiSonuc);
              YorumBottomSheet(context, sonucListesi);
            },
            child: const Text(
              "Hesapla",
            ),
          ),
        ),
      ),
    );
  }

  void YorumBottomSheet(BuildContext context, List<String> sonucListesi) {
    showMaterialModalBottomSheet(
      backgroundColor: Colors.blue,
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
        ),
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    KitleEndeksiHesapla(_currentValue2, _currentValue)
                        .round()
                        .toString(),
                    style: TextStyle(fontSize: 22),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    sonucListesi[1].toString(),
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                sonucListesi[0].toString(),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

double KitleEndeksiHesapla(int kilo, int boy) {
  double sonuc =
      kilo.toDouble() / (boy.toDouble() / 100 * boy.toDouble() / 100);
  return sonuc;
}

List<String> KitleEndeksiSonuc(double endeksSonuc) {
  String vucutTipi = "null";
  String vucutYorum = "null";
  List<String> list;
  if (endeksSonuc < 18.5) {
    vucutYorum =
        "Boyunuza göre uygun ağırlıkta olmadığınızı, zayıf olduğunuzu gösterir. Zayıflık, bazı hastalıklar için risk oluşturan ve istenmeyen bir durumdur. Boyunuza uygun ağırlığa erişmeniz için yeterli ve dengeli beslenmeli, beslenme alışkanlıklarınızı geliştirmeye özen göstermelisiniz.";
    vucutTipi = "Zayıf";
  } else if (endeksSonuc > 18.5 && endeksSonuc < 24.9) {
    vucutYorum =
        "Boyunuza göre uygun ağırlıkta olduğunuzu gösterir. Yeterli ve dengeli beslenerek ve düzenli fiziksel aktivite yaparak bu ağırlığınızı korumaya özen gösteriniz.";
    vucutTipi = "Normal";
  } else if (endeksSonuc > 25.0 && endeksSonuc < 29.9) {
    vucutYorum =
        "Boyunuza göre vücut ağırlığınızın fazla olduğunu gösterir. Fazla kilolu olma durumu gerekli önlemler alınmadığı takdirde pek çok hastalık için risk faktörü olan obeziteye (şişmanlık) yol açar";
    vucutTipi = "Fazla Kilolu";
  } else if (endeksSonuc > 30.0 && endeksSonuc < 40.0) {
    vucutYorum =
        "Boyunuza göre vücut ağırlığınızın fazla olduğunu bir başka deyişle şişman olduğunuzun bir göstergesidir. Şişmanlık, kalp-damar hastalıkları, diyabet, hipertansiyon v.b. kronik hastalıklar için risk faktörüdür. Bir sağlık kuruluşuna başvurarak hekim / diyetisyen kontrolünde zayıflayarak normal ağırlığa inmeniz sağlığınız açısından çok önemlidir. Lütfen, sağlık kuruluşuna başvurunuz.";
    vucutTipi = "Şişman(Obez)";
  } else if (endeksSonuc > 40) {
    vucutYorum =
        "Boyunuza göre vücut ağırlığınızın fazla olduğunu bir başka deyişle şişman olduğunuzun bir göstergesidir. Şişmanlık, kalp-damar hastalıkları, diyabet, hipertansiyon v.b. kronik hastalıklar için risk faktörüdür. Bir sağlık kuruluşuna başvurarak hekim / diyetisyen kontrolünde zayıflayarak normal ağırlığa inmeniz sağlığınız açısından çok önemlidir. Lütfen, sağlık kuruluşuna başvurunuz.";
    vucutTipi = "Aşırı Şişman(Aşırı Obez)";
  }
  list = [vucutYorum, vucutTipi];
  return list;
}
