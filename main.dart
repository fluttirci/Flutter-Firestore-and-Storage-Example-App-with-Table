import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Basic Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'new Flutter App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var url;
  Widget _buildlistItem(BuildContext context, DocumentSnapshot document) {
    void showImage() async {
      final ref = FirebaseStorage.instance.ref().child('erkekyuz.png'); //This is my example image, just change it as you will
      url = await ref.getDownloadURL();
    }
    showImage(); //All this is for the image I will use below.

    String mezunD;
    if (document.data()['mezunDurumu'] == false) {
      mezunD = "Mezun Değil";
    }
    if (document.data()['mezunDurumu'] == true) {
      mezunD = "Mezun";
    }
    String yasString = (document.data()['yas']).toString();
	//this is because the table only accepts string, so therefore I change it to string.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Table(
        border: TableBorder.all(),
        children: [
          TableRow(children: [
            Text("Ad Soyad:  "),
            Text(
              document.data()['adSoyad'],
              textAlign: TextAlign.center,
            ),
          ]),
          TableRow(children: [
            Text("Yaş:  "),
            Text(
              yasString,
              textAlign: TextAlign.center,
            ),
          ]),
          TableRow(children: [
            Text("Doğum Tarihi:  "),
            Text(
              document.data()['dogumTarihi'],
              textAlign: TextAlign.center,
            ),
          ]),
          TableRow(children: [
            Text("Mezun Durumu:  "),
            Text(
              mezunD,
              textAlign: TextAlign.center,
            ),
          ]),
          TableRow(children: [
            Text(
              "Fotoğraf:  ",
            ),
            Image.network(
              url,
              width: 50,
              height: 50,
            ),
          ]),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Öğrenci Durumu"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('tablolar').snapshots(),
          //tablolar is the table name you created.
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            return ListView.builder(
              itemExtent: 100.0,
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) =>
                  _buildlistItem(context, snapshot.data.docs[index]),
            );
          }),
    );
  }
}
