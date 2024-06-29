import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namer_app/widgets/authentication.dart';
import 'package:namer_app/widgets/nfc.dart';
import 'package:namer_app/widgets/nfc_details.dart';
import 'package:namer_app/widgets/nfc_info.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
          title: 'Namer App',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          ),
          routes: {
            "/": (context) => NFC(),
            //  "/nfc_details": (context) => NFCdetails(),
            "/nfc_info": (context) => NFCInformation(type: "")
          }),
    );
  }
}

class MyAppState extends ChangeNotifier {}
