import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:namer_app/widgets/nfc.dart';

class Authentication extends StatefulWidget {
  @override
  State<Authentication> createState() => _Authentication();
}

class _Authentication extends State<Authentication> {
  late final LocalAuthentication auth;
  @override
  void initState() {
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) => {
          if (isSupported)
            {_authenticate()}
          else
            {
              Navigator.push(
                // ignore: use_build_context_synchronously
                context,
                MaterialPageRoute(builder: (context) => NFC()),
              )
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [CircularProgressIndicator()],
        ),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool isAuthenticate = await auth.authenticate(
        localizedReason: "Please authenticate to access NFC",
        options: const AuthenticationOptions(
            stickyAuth: true, biometricOnly: false, useErrorDialogs: false),
      );
      if (isAuthenticate) {
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => NFC()),
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
