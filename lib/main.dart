import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_movie/config/palette.dart';
import 'package:flutter_app_movie/models/hive_model.dart';
import 'package:flutter_app_movie/screens/hive_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';


final boxA = Provider<List<Transaction>>((ref){
  throw UnimplementedError();
});


Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
await Hive.initFlutter();
  Hive.registerAdapter(TransactionAdapter());
 final openHive =  await Hive.openBox<Transaction>('transactions');
 SystemChrome.setPreferredOrientations(
   [
     DeviceOrientation.portraitUp,
     DeviceOrientation.portraitDown
   ]
 );

SystemChrome.setSystemUIOverlayStyle(
  SystemUiOverlayStyle(
    statusBarColor: Palette.primaryColor,
  )
);
  runApp(ProviderScope(
      overrides: [
        boxA.overrideWithValue(openHive.values.toList().cast<Transaction>()),
      ],
      child: Home()));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HiveScreen(),
    );
  }
}



