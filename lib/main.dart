import 'package:calculator/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  // RequestConfiguration requestConfiguration = RequestConfiguration(
  //   testDeviceIds:
  // );
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext){
   return const MaterialApp(
     debugShowCheckedModeBanner: false,
     home:HomeScreen()
     // home: homepage(),
   );
  }
}


