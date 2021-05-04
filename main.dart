import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:camera/camera.dart';
import 'package:tez1fl/camera_screen.dart';
import 'package:tez1fl/assistantMethods.dart';
import 'package:tez1fl/requestAssistant.dart';
import 'package:oktoast/oktoast.dart';
import 'package:http/http.dart';

List<CameraDescription> cameras;
Future<void> main() async {
WidgetsFlutterBinding.ensureInitialized();
cameras = await availableCameras();
runApp(MyApp());
}
class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return OKToast(
child: MaterialApp(
title: 'Flutter İzinler',
theme: ThemeData(
primarySwatch: Colors.deepPurple,visualDensity: VisualDensity.adaptivePlatformDensity,
),
home: MyHomePage(title: 'Flutter İzinler'),
),
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
int _counter = 0;
void _incrementCounter() {
setState(() {
_counter++;
});
}
openCamera() {
Navigator.push(
context,
MaterialPageRoute(
builder: (context) => CameraScreen(
camera: cameras.first,
),
),
);
}
String _locationMessage = "";
Future<void> yeriGetir() async {
final position = await Geolocator()
.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);print(position);
setState(() {
_locationMessage = "${position.latitude}, ${position.longitude}";
String address = assistantMethods.searchCoordinateAddress(position);
print("This is your Address :: " + address);
});
}
izinKontrol_Lokasyon() async {
// LOKASYON FONKSİYONU BURADADIR.
var locationStatus = await Permission.location.status;
print(locationStatus);
if (!locationStatus.isGranted) await Permission.location.request();
//showToast(_locationMessage, position: ToastPosition.bottom);
}
checkallpermission_opencamera() async {
Map<Permission, PermissionStatus> statuses = await [
Permission.camera,
Permission.microphone,
].request();
if (statuses[Permission.camera].isGranted) {
if (statuses[Permission.microphone].isGranted) {
openCamera();
} else {
showToast("Kamera mikrofonunuza erişmek istiyor, lütfen izin verin.",
position: ToastPosition.bottom);
}
} else {
showToast("Kamerayı kullanabilmek için lütfen izin verin.",
position: ToastPosition.bottom);
}
}
checkpermission_opencamera() async {
var cameraStatus = await Permission.camera.status;
var microphoneStatus = await Permission.microphone.status;print(cameraStatus);
print(microphoneStatus);
if (!cameraStatus.isGranted) await Permission.camera.request();
if (!microphoneStatus.isGranted) await Permission.microphone.request();
if (await Permission.camera.isGranted) {
if (await Permission.microphone.isGranted) {
openCamera();
} else {
showToast("Kamera izni gerekiyor, lütfen izin verin.",
position: ToastPosition.bottom);
}
} else {
showToast("Kamerayı kullanmak için lütfen izin verin.",
position: ToastPosition.bottom);
}
}
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: Text(widget.title),
),
body: Center(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: <Widget>[
Container(
child: IconButton(
onPressed: checkpermission_opencamera,
icon: Icon(Icons.camera),
iconSize: 42,
color: Colors.white,
),
color: Colors.amber,
width: MediaQuery.of(context).size.width,
height: (MediaQuery.of(context).size.height - 80) / 2,),
Text("Lokasyonunuz şudur: " + address),
Container(
child: IconButton(
onPressed: () => {izinKontrol_Lokasyon, yeriGetir()},
icon: Icon(Icons.location_city),
iconSize: 42,
color: Colors.white),
color: Colors.deepPurple,
width: MediaQuery.of(context).size.width,
height: (MediaQuery.of(context).size.height - 80) / 2,
),
],
),
) // This trailing comma makes auto-formatting nicer for build methods.
);
}
}
