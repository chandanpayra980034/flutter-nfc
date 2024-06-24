import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:namer_app/widgets/nfc_info.dart';

class NFC extends StatefulWidget {
  @override
  State<NFC> createState() => _NFC();
}

class _NFC extends State<NFC> {
  late final LocalAuthentication auth;
  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => {
          if (isSupported) {_authenticate()}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'NFC Tag Reader',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.grey[200], // Background color
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(6), // Rounded border
              ),
              child: IconButton(
                icon: Icon(Icons.more_vert),
                color: Colors.black,
                onPressed: () {
                  // Handle the more_vert button press
                },
              ),
            ),
          ),
        ],
        iconTheme:
            IconThemeData(color: Colors.black), // Set the icon color to black
      ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => {onPressButton("Read Tags")},
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0), // Text color
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      shadowColor: Colors.white,
                      textStyle: TextStyle(fontSize: 13)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.nfc),
                      SizedBox(height: 6),
                      const Text("Read Tags")
                    ],
                  ),
                )),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => {onPressButton("Card Reader")},
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0), // Text color
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      shadowColor: Colors.white,
                      textStyle: TextStyle(fontSize: 13)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.credit_card),
                      SizedBox(height: 6),
                      const Text("Card Reader")
                    ],
                  ),
                ))
              ],
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: 0, left: 16.0, right: 16.0, bottom: 16.0),
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => {onPressButton("Write Tags")},
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0), // Text color
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      shadowColor: Colors.white,
                      textStyle: TextStyle(fontSize: 13)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.draw_outlined),
                      SizedBox(height: 6),
                      const Text("Write Tags")
                    ],
                  ),
                )),
                SizedBox(
                  width: 16,
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () => {onPressButton("COPY")},
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16.0), // Text color
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      shadowColor: Colors.white,
                      textStyle: TextStyle(fontSize: 13)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.copy_all),
                      SizedBox(height: 6),
                      const Text("Copy Tags")
                    ],
                  ),
                ))
              ],
            ),
          )
        ],
      )),
    );
  }

  void onPressButton(String type) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NFCInformation(type: type),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool isAuthenticate = await auth.authenticate(
        localizedReason: "Please authenticate to access NFC",
        options: const AuthenticationOptions(
            stickyAuth: true, biometricOnly: false, useErrorDialogs: true),
      );
      if (isAuthenticate) {
        await auth.stopAuthentication();
      } else {
        _authenticate();
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
