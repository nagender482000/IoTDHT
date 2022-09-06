import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IoT DHT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'IoT DHT'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final databaseReference = FirebaseDatabase.instance.ref();
  bool powerstate = true;
  var temp;
  var humd;
  gettemp() async {
    databaseReference
        .child("TempHumd/temp")
        .onValue
        .listen((DatabaseEvent event) {
      setState(() {
        temp = event.snapshot.value.toString();
      });
    });
  }

  gethumd() async {
    databaseReference
        .child("TempHumd/humd")
        .onValue
        .listen((DatabaseEvent event) {
      setState(() {
        humd = event.snapshot.value;
      });
    });
  }

  getalldata() async {
    await gethumd();
    await gettemp();
  }

  @override
  void initState() {
    getalldata();
    super.initState();
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
            // const Text(
            //   'Current switch state is ',
            // ),
            // Text(
            //   powerstate.toString(),
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            // const SizedBox(
            //   height: 50,
            // ),
            // Switch(
            //     value: powerstate,
            //     onChanged: (value) {
            //       setState(() {
            //         powerstate = value as bool;
            //       });
            //       databaseReference
            //           .child("RGBControl")
            //           .set({'powerState': powerstate.toString()});
            //       print(powerstate.toString());
            //     }),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Current Temperature is: ',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              temp.toString(),
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              'Current Humidity is ',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              humd.toString(),
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
