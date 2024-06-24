import 'package:flutter/material.dart';

class NFCInformation extends StatefulWidget {
  final String type;

  const NFCInformation({super.key, required this.type});

  @override
  // ignore: library_private_types_in_public_api
  _NFCInformationState createState() => _NFCInformationState();
}

class _NFCInformationState extends State<NFCInformation> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then((_) {
      _showBottomDialog(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          widget.type,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme:
            IconThemeData(color: Colors.black), // Set the icon color to black
      ),
      body: Center(
        child: Image.asset(
          'lib/assets/nfc_wrap.png',
          height: 240,
          width: 240,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Method to show bottom dialog
  void _showBottomDialog(bool isShow) {
    if (isShow) {
      showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Read from NFC Tag',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  textAlign: TextAlign.start,
                ), // Show type variable in dialog
                SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/nfc.png',
                      height: 120,
                      fit: BoxFit.cover,
                    )
                  ],
                ),
                SizedBox(height: 16.0),
                const Text(
                  "Try Moving Your NFC around to find the NFC Reader on Your Device",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          );
        },
      );
    }
  }

  @override
  void didUpdateWidget(covariant NFCInformation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.type != oldWidget.type) {
      _showBottomDialog(true); // Trigger dialog when type variable changes
    }
  }
}
