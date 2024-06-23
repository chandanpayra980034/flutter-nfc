import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
class NfcTagData {
  final String tagId;
  final List<String> techList;
  final String tagType;
  final String historicalBytes;
  final String serialNumber;
  final String atqa;
  final String sak;
  final String timeout;
  final String isExtendedLengthSupported;
  final String maxTransceiveLength;
  final String hiLayerResponse;

  NfcTagData({
    required this.tagId,
    required this.techList,
    required this.tagType,
    required this.historicalBytes,
    required this.serialNumber,
    required this.atqa,
    required this.sak,
    required this.timeout,
    required this.isExtendedLengthSupported,
    required this.maxTransceiveLength,
    required this.hiLayerResponse
  });

  @override
  String toString() {
    return 'Tag ID: $tagId\nTech List: $techList\nTag Type: $tagType';
  }
}



class CustomRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String copyText;

  const CustomRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.copyText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 45, // Set width to 45
            height: 45, // Set height to 45
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Center( // Use Center widget to center the icon
              child: FaIcon(
                icon,
                size: 24, // Set icon size to 24
                color: Colors.black, // Adjust color as needed
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          Expanded(child: Container()), // Spacer to expand the row
          IconButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: copyText));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied to clipboard')),
              );
            },
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
    );
  }
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
                
                // if(result.value!=null)
                ValueListenableBuilder(
  valueListenable: result,
  builder: (context, dynamic tagType, child) {
    if (tagType != null && tagType is NfcTagData) {
               return Visibility(
                visible:true,
                child: 
                Container(
                   width: double.infinity, // Full width
                   margin: EdgeInsets.all(8), // Margin around the container
                   decoration: BoxDecoration(
                     color: Colors.grey[200],
                     borderRadius: BorderRadius.circular(8), // Rounded corners
                     boxShadow: [
                       BoxShadow(
                         color: Colors.grey.withOpacity(0.5), // Shadow color
                         spreadRadius: 2, // Spread radius
                         blurRadius: 2, // Blur radius
                         offset: Offset(0, 1), // Offset from the top left
                        ),
                     ],
                  ),
                 child: Padding(
                 padding: EdgeInsets.all(8.0),
                 child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the left
                  children: [
                           CustomRow(
                                    icon: FontAwesomeIcons.tag, // Use a FontAwesome icon here
                                    label: 'Tag type',
                                    value:  result.value != null && result.value is NfcTagData
                                            ? (result.value as NfcTagData).tagType ?? 'Unknown' : 'Unknown',
                                    copyText: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).tagType ?? 'Unknown' : 'Unknown',
                                        ),
                                       Divider(height: 10),
                                        CustomRow(
                                    icon: FontAwesomeIcons.microchip, // Use a FontAwesome icon here
                                    label: 'Technologies available',
                                    value:  result.value != null && result.value is NfcTagData
                                           ? (result.value as NfcTagData).techList.join(', ') : '',
                                    copyText:  result.value != null && result.value is NfcTagData
                                           ? (result.value as NfcTagData).techList.join(', ') : '',
                                        ),
                                         Divider(height: 10),
                                        CustomRow(
                                    icon: FontAwesomeIcons.key, // Use a FontAwesome icon here
                                    label: 'Serial Number',
                                    value: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).serialNumber ?? '' : '',
                                    copyText: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).serialNumber ?? '' : '',
                                        ),
                                         Divider(height: 10),
                                         CustomRow(
                                    icon: FontAwesomeIcons.a, // Use a FontAwesome icon here
                                    label: 'ATQA',
                                    value: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).atqa ?? '' : '',
                                    copyText: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).atqa ?? '' : '',
                                        ),
                                         Divider(height: 10),
                                        CustomRow(
                                    icon: FontAwesomeIcons.s, // Use a FontAwesome icon here
                                    label: 'SAK',
                                    value: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).sak ?? '' : '',
                                    copyText: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).sak ?? '' : '',
                                        ),
                                         Divider(height: 10),
                                         CustomRow(
                                    icon: FontAwesomeIcons.h, // Use a FontAwesome icon here
                                    label: 'Historical bytes',
                                    value: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).historicalBytes ?? '' : '',
                                    copyText: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).historicalBytes ?? '' : '',
                                        ),
                                         Divider(height: 10),
                                         CustomRow(
                                    icon: FontAwesomeIcons.clock, // Use a FontAwesome icon here
                                    label: 'Timeout',
                                    value: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).timeout ?? '' : '',
                                    copyText: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).timeout ?? '' : '',
                                        ),
                                         Divider(height: 10),
                                        CustomRow(
                                    icon: FontAwesomeIcons.e, // Use a FontAwesome icon here
                                    label: 'Extended Length Apdu Supported',
                                    value: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).isExtendedLengthSupported ?? '' : '',
                                    copyText: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).isExtendedLengthSupported ?? '' : '',
                                        ),
                                         Divider(height: 10),
                                        CustomRow(
                                    icon: FontAwesomeIcons.m, // Use a FontAwesome icon here
                                    label: 'Max Transceive Length',
                                    value: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).maxTransceiveLength ?? '' : '',
                                    copyText: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).maxTransceiveLength ?? '' : '',
                                        ),
                                         Divider(height: 10),
                                         CustomRow(
                                    icon: FontAwesomeIcons.h, // Use a FontAwesome icon here
                                    label: 'Hi Layer Response',
                                    value: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).hiLayerResponse ?? '' : '',
                                    copyText: result.value != null && result.value is NfcTagData
                                               ? (result.value as NfcTagData).hiLayerResponse ?? '' : '',
                                        ),
                            
                           
               
                          
                             
                             
                             ],
                ),
                )
                )
              
                );
                }
                else {
              return Container(); // or some other loading indicator
                 }
                }),
  
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
    // Log the entire tag data for debugging purposes
    print('Tag data: ${tag.data}');
    
    // Extract the identifier from the nested structures
    var tagId = tag.data['isodep']?['identifier'] ?? tag.data['nfca']?['identifier'] ?? 'Unknown ID';
    
    // Convert the identifier to a readable format
    if (tagId is List<int>) {
      tagId = tagId.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
    }
    
    // Determine the tech types by checking the presence of specific keys
    var techList = <String>[];
    if (tag.data.containsKey('isodep')) techList.add('ISO-DEP');
    if (tag.data.containsKey('nfca')) techList.add('NFC-A');
    if (tag.data.containsKey('nfcb')) techList.add('NFC-B');
    if (tag.data.containsKey('nfcf')) techList.add('NFC-F');
    if (tag.data.containsKey('nfcv')) techList.add('NFC-V');
    if (tag.data.containsKey('ndef')) techList.add('NDEF');
    if (tag.data.containsKey('mifareclassic')) techList.add('MIFARE Classic');
    if (tag.data.containsKey('mifareultralight')) techList.add('MIFARE Ultralight');
    
    // Log extracted values for debugging
    print('Tag ID: $tagId');
    print('Tech List: $techList');

    //historicalBytes start
     List<int>? historicalBytes = tag.data['isodep']?['historicalBytes'];
    if (historicalBytes == null) {
      historicalBytes = tag.data['nfca']?['historicalBytes'];
    }

    // Format historicalBytes as hexadecimal string
    String formattedBytes = '0x';
    if (historicalBytes != null) {
      for (int byte in historicalBytes) {
        formattedBytes += byte.toRadixString(16).padLeft(2, '0').toUpperCase();
      }
      formattedBytes += 's@'; // Add additional characters as needed
    } else {
      formattedBytes = 'Unknown'; // Handle case where historicalBytes is not available
    }
    //historicalBytesEnd
    
    // Determine the tag type
    String tagType = _getTagType(techList);
    var serialNumber =  _extractSerialNumber(tag);
     var atqa =  _extractATQA(tag);
      var sak =  _extractSAK(tag);
      var timeOut =  _extractTimeout(tag);
      var extendedLengthSupported= _extractisExtendedLengthApduSupported(tag);
      var maxTransceiveLength= _extractmaxTransceiveLength(tag);
      var hiLayerResponse= _extractHiLayerResponse(tag);
    // print('maxTransceiveLength: $maxTransceiveLength');
    // Create an instance of NfcTagData
    var nfcTagData = NfcTagData(
      tagId: tagId,
      techList: techList,
      tagType: tagType,
      historicalBytes:formattedBytes,
      serialNumber: serialNumber,
      atqa:atqa,
      sak:sak,
      timeout:timeOut,
      isExtendedLengthSupported:extendedLengthSupported,
      maxTransceiveLength:maxTransceiveLength,
      hiLayerResponse:hiLayerResponse
    );
    
    // Update result.value with the NfcTagData object
    result.value = nfcTagData;
    
    // Stop the NFC session
    NfcManager.instance.stopSession();
  });
}


String _extractSerialNumber(NfcTag tag) {
  // Example extraction logic; adjust based on your NFC tag data structure
  // Replace with actual extraction logic
  var serialNumber = ''; // Replace with actual path to serial number in your tag data
    if (tag.data.containsKey('nfca')) {
    var nfcaData = tag.data['nfca'];

    // Extract and format the identifier as a serial number
    if (nfcaData.containsKey('identifier')) {
      List<int> identifier = nfcaData['identifier'];

      // Convert each byte in identifier to hexadecimal and join with ':'
      serialNumber = identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':').toUpperCase();
    }
  }


  return serialNumber;
}
String _extractSAK(NfcTag tag) {
  var sak = '';

  // Check if 'nfca' is present in tag data
  if (tag.data.containsKey('nfca')) {
    var nfcaData = tag.data['nfca'];

    // Extract SAK if available
    if (nfcaData.containsKey('sak')) {
      int sakByte = nfcaData['sak'];
      sak = '0x'+sakByte.toRadixString(16).toUpperCase();
    }
  }

  return sak;
}
String _extractTimeout(NfcTag tag) {
  var timeout = '';

  // Check if 'nfca' is present in tag data
  if (tag.data.containsKey('nfca')) {
    var nfcaData = tag.data['nfca'];

    // Extract timeout if available
    if (nfcaData.containsKey('timeout')) {
      timeout = '${nfcaData['timeout']??""}';
    }
  }
  print('timeout:${timeout}');
  return timeout;
}
String _extractHiLayerResponse(NfcTag tag) {
  var hiLayerResponse = '';

  // Check if 'nfca' is present in tag data
  if (tag.data.containsKey('isodep')) {
    var isoDepData = tag.data['nfca'];

    // Extract timeout if available
    if (isoDepData.containsKey('hiLayerResponse')) {
      hiLayerResponse = '${isoDepData['hiLayerResponse']??"Null"}';
    }
  }
  return hiLayerResponse;
}
String _extractmaxTransceiveLength(NfcTag tag) {
  var maxTransceiveLength = '';

  // Check if 'nfca' is present in tag data
  if (tag.data.containsKey('nfca')) {
    var nfcaData = tag.data['nfca'];

    // Extract timeout if available
    if (nfcaData.containsKey('maxTransceiveLength')) {
      maxTransceiveLength = '${nfcaData['maxTransceiveLength']??""}';
    }
  }
  return maxTransceiveLength;
}

String _extractisExtendedLengthApduSupported(NfcTag tag) {
  var isExtendedLengthApduSupported = '';

  // Check if 'nfca' is present in tag data
  if (tag.data.containsKey('isodep')) {
    var isoDepData = tag.data['isodep'];

    // Extract timeout if available
    if (isoDepData.containsKey('isExtendedLengthApduSupported')) {
      isExtendedLengthApduSupported = '${isoDepData['isExtendedLengthApduSupported']??""}';
    }
  }
  return isExtendedLengthApduSupported;
}

String _extractATQA(NfcTag tag) {
  var atqa = '';

  // Check if 'nfca' is present in tag data
  if (tag.data.containsKey('nfca')) {
    var nfcaData = tag.data['nfca'];

    // Extract ATQA if available
    if (nfcaData.containsKey('atqa')) {
      List<int> atqaBytes = nfcaData['atqa'];
      atqa = '0x'+atqaBytes.map((e) => e.toRadixString(16).padLeft(2, '0')).join('').toUpperCase();
    }
  }

  return atqa;
}
 String _getTagType(List<String> techList) {
  if (techList.contains('ISO-DEP')) {
    return 'ISO 14443-4 (ISO-DEP)';
  } else if (techList.contains('NFC-A')) {
    return 'ISO 14443-3 (NFC-A)';
  } else if (techList.contains('NFC-B')) {
    return 'ISO 14443-3 (NFC-B)';
  } else if (techList.contains('NFC-F')) {
    return 'JIS X 6319-4 (NFC-F)';
  } else if (techList.contains('NFC-V')) {
    return 'ISO 15693 (NFC-V)';
  } else if (techList.contains('NDEF')) {
    return 'NDEF';
  } else if (techList.contains('MIFARE Classic')) {
    return 'MIFARE Classic';
  } else if (techList.contains('MIFARE Ultralight')) {
    return 'MIFARE Ultralight';
  } else {
    return 'Unknown';
  }
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
