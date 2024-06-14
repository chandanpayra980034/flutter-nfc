import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:provider/provider.dart';
import 'package:local_auth/local_auth.dart';

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
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final LocalAuthentication auth;
  bool _isSupportedFingerPrint = false;
  bool _isAuthenticated = false;
  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => setState(() {
          _isSupportedFingerPrint = isSupported;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
          body: SafeArea(
              child: _isAuthenticated
                  ? NFCPage()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_isSupportedFingerPrint)
                          const Text(
                              "This device is supported biometric authentication.")
                        else
                          const Text(
                              "This device is not supported biometric authentication."),
                        const Divider(height: 40),
                        ElevatedButton(
                            onPressed: _authenticate,
                            child: const Text("Authenticate Biometric"))
                      ],
                    )));
    });
  }

  // Future<void> _getAvailableBiometrics() async {
  //   List<BiometricType> list = await auth.getAvailableBiometrics();
  //   print("List of available biometrics : $list");
  //   if (!mounted) return;
  // }

  Future<void> _authenticate() async {
    try {
      bool authenticate = await auth.authenticate(
        localizedReason: "Please authenticate to access NFC",
        options: const AuthenticationOptions(
            stickyAuth: true, biometricOnly: false, useErrorDialogs: false),
      );
      setState(() {
        _isAuthenticated = authenticate;
      });
      print(authenticate);
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticated = false;
      });
      print(e);
    }
  }
}

class NFCPage extends StatefulWidget {
  @override
  State<NFCPage> createState() => _NFCPage();
}

class _NFCPage extends State<NFCPage> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: NfcManager.instance.isAvailable(),
        builder: (context, ss) => ss.data != true
            ? Center(child: Text("NfcManager.isAvailable(): ${ss.data}"))
            : Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(4),
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(border: Border.all()),
                      child: SingleChildScrollView(
                        child: ValueListenableBuilder<dynamic>(
                            valueListenable: result,
                            builder: (context, value, _) =>
                                Text('${value ?? ''}')),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: GridView.count(
                      crossAxisCount: 2,
                      padding: EdgeInsets.all(4),
                      childAspectRatio: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      children: [
                        ElevatedButton(
                            onPressed: _tagRead, child: Text("Tag Read")),
                        ElevatedButton(
                            onPressed: _ndefWrite, child: Text("Ndef Write")),
                        ElevatedButton(
                            onPressed: _ndefWriteLock,
                            child: Text("Ndef Write Lock"))
                      ],
                    ),
                  )
                ],
              ));
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }

  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = "Tag is not ndef writable";
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
      NdefMessage msg = NdefMessage([
        NdefRecord.createText("Hello World!"),
        NdefRecord.createUri(Uri.parse("https://flutter.dev")),
        NdefRecord.createMime(
            'text/plain', Uint8List.fromList('Hello'.codeUnits)),
        NdefRecord.createExternal(
            'com.example', 'mytype', Uint8List.fromList('mydata'.codeUnits))
      ]);
      try {
        await ndef.write(msg);
        result.value = 'Success to "Ndef Write"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  void _ndefWriteLock() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null) {
        result.value = "Tag is not ndef";
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
      try {
        await ndef.writeLock();
        result.value = 'Success to "Ndef Write Lock"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }
}
