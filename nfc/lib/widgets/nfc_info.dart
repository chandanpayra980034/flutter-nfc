import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NFCInformation extends StatefulWidget {
  final String type;

  const NFCInformation({super.key, required this.type});

  @override
  // ignore: library_private_types_in_public_api
  _NFCInformationState createState() => _NFCInformationState();
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
  final String? writable;
  final String? readonly;
  final String? size;

  NfcTagData(
      {required this.tagId,
      required this.techList,
      required this.tagType,
      required this.historicalBytes,
      required this.serialNumber,
      required this.atqa,
      required this.sak,
      required this.timeout,
      required this.isExtendedLengthSupported,
      required this.maxTransceiveLength,
      required this.hiLayerResponse,
      this.writable,
      this.readonly,
      this.size});

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
            child: Center(
              // Use Center widget to center the icon
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
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text('Copied to clipboard')),
              // );
            },
            icon: const Icon(Icons.copy),
          ),
        ],
      ),
    );
  }
}

class _NFCInformationState extends State<NFCInformation> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  BuildContext? bottomSheetContext;
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 0)).then((_) {
      _showBottomDialog(context, true);
      widget.type == "Write Tags" ? _ndefWrite() : _tagRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: result,
        builder: (context, dynamic tagType, child) {
          if (tagType != null && tagType is NfcTagData) {
            return Scaffold(
                backgroundColor: Colors.grey[100],
                appBar: AppBar(
                  title: Text(
                    widget.type,
                    style: TextStyle(color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                  iconTheme: IconThemeData(
                      color: Colors.black), // Set the icon color to black
                ),
                body: Container(
                    // height: 760,
                    child: SingleChildScrollView(
                        child: Container(
                            padding: EdgeInsets.all(6),
                            width: double.infinity, // Full width
                            margin: EdgeInsets.all(
                                8), // Margin around the container
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius:
                                  BorderRadius.circular(8), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 2, // Blur radius
                                  offset:
                                      Offset(0, 1), // Offset from the top left
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Aligns children to the left
                                children: [
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .tag, // Use a FontAwesome icon here
                                    label: 'Tag type',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .tagType ??
                                            'Unknown'
                                        : 'Unknown',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .tagType ??
                                            'Unknown'
                                        : 'Unknown',
                                  ),
                                  //  Divider(height: 5),
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .microchip, // Use a FontAwesome icon here
                                    label: 'Technologies available',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                            .techList
                                            .join(', ')
                                        : '',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                            .techList
                                            .join(', ')
                                        : '',
                                  ),
                                  //  Divider(height: 5),
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .key, // Use a FontAwesome icon here
                                    label: 'Serial Number',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .serialNumber ??
                                            ''
                                        : '',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .serialNumber ??
                                            ''
                                        : '',
                                  ),
                                  //  Divider(height: 5),
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .a, // Use a FontAwesome icon here
                                    label: 'ATQA',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData).atqa ??
                                            ''
                                        : '',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData).atqa ??
                                            ''
                                        : '',
                                  ),
                                  //  Divider(height: 5),
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .s, // Use a FontAwesome icon here
                                    label: 'SAK',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData).sak ?? ''
                                        : '',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData).sak ?? ''
                                        : '',
                                  ),
                                  //  Divider(height: 5),
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .h, // Use a FontAwesome icon here
                                    label: 'Historical bytes',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .historicalBytes ??
                                            ''
                                        : '',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .historicalBytes ??
                                            ''
                                        : '',
                                  ),
                                  //  Divider(height: 5),
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .clock, // Use a FontAwesome icon here
                                    label: 'Timeout',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .timeout ??
                                            ''
                                        : '',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .timeout ??
                                            ''
                                        : '',
                                  ),
                                  //  Divider(height: 5),
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .e, // Use a FontAwesome icon here
                                    label: 'Extended Length Apdu Supported',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .isExtendedLengthSupported ??
                                            ''
                                        : '',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .isExtendedLengthSupported ??
                                            ''
                                        : '',
                                  ),
                                  //  Divider(height: 5),
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .m, // Use a FontAwesome icon here
                                    label: 'Max Transceive Length',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .maxTransceiveLength ??
                                            ''
                                        : '',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .maxTransceiveLength ??
                                            ''
                                        : '',
                                  ),
                                  //  Divider(height: 5),
                                  CustomRow(
                                    icon: FontAwesomeIcons
                                        .h, // Use a FontAwesome icon here
                                    label: 'Hi Layer Response',
                                    value: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .hiLayerResponse ??
                                            ''
                                        : '',
                                    copyText: result.value != null &&
                                            result.value is NfcTagData
                                        ? (result.value as NfcTagData)
                                                .hiLayerResponse ??
                                            ''
                                        : '',
                                  ),

                                  ValueListenableBuilder(
                                      valueListenable: result,
                                      builder:
                                          (context, dynamic writable, child) {
                                        if ((result.value as NfcTagData)
                                            .techList
                                            .contains('NDEF')) {
                                          return CustomRow(
                                            icon: FontAwesomeIcons
                                                .w, // Use a FontAwesome icon here
                                            label: 'Writable',
                                            value: result.value != null &&
                                                    result.value is NfcTagData
                                                ? (result.value as NfcTagData)
                                                        .writable ??
                                                    ''
                                                : '',
                                            copyText: result.value != null &&
                                                    result.value is NfcTagData
                                                ? (result.value as NfcTagData)
                                                        .writable ??
                                                    ''
                                                : '',
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),
                                  ValueListenableBuilder(
                                      valueListenable: result,
                                      builder:
                                          (context, dynamic writable, child) {
                                        if ((result.value as NfcTagData)
                                            .techList
                                            .contains('NDEF')) {
                                          return CustomRow(
                                            icon: FontAwesomeIcons
                                                .c, // Use a FontAwesome icon here
                                            label: 'Can Be Made Read Only',
                                            value: result.value != null &&
                                                    result.value is NfcTagData
                                                ? (result.value as NfcTagData)
                                                        .readonly ??
                                                    ''
                                                : '',
                                            copyText: result.value != null &&
                                                    result.value is NfcTagData
                                                ? (result.value as NfcTagData)
                                                        .readonly ??
                                                    ''
                                                : '',
                                          );
                                        } else {
                                          return Container();
                                        }
                                      }),

                                  ValueListenableBuilder(
                                      valueListenable: result,
                                      builder:
                                          (context, dynamic writable, child) {
                                        if ((result.value as NfcTagData)
                                            .techList
                                            .contains('NDEF')) {
                                          return CustomRow(
                                            icon: FontAwesomeIcons
                                                .s, // Use a FontAwesome icon here
                                            label: 'Size',
                                            value: result.value != null &&
                                                    result.value is NfcTagData
                                                ? (result.value as NfcTagData)
                                                        .size ??
                                                    ''
                                                : '',
                                            copyText: result.value != null &&
                                                    result.value is NfcTagData
                                                ? (result.value as NfcTagData)
                                                        .size ??
                                                    ''
                                                : '',
                                          );
                                        } else {
                                          return Container();
                                        }
                                      })
                                ],
                              ),
                            )))));
          } else {
            return Scaffold(
              backgroundColor: Colors.grey[100],
              appBar: AppBar(
                title: Text(
                  widget.type,
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                    color: Colors.black), // Set the icon color to black
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
        });
  }

  void _showBottomDialog(BuildContext context, bool isShow) {
    if (isShow) {
      showModalBottomSheet(
        isDismissible: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        context: context,
        builder: (BuildContext context) {
          bottomSheetContext = context;
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
                ),
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
  void didUpdateWidget(NFCInformation oldWidget) {
    if (oldWidget.type != widget.type) {
      _showBottomDialog(context, true);
    }
    super.didUpdateWidget(oldWidget);
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      // Log the entire tag data for debugging purposes
      print('Tag data: ${tag.data}');

      // Extract the identifier from the nested structures
      var tagId = tag.data['isodep']?['identifier'] ??
          tag.data['nfca']?['identifier'] ??
          'Unknown ID';

      // Convert the identifier to a readable format
      if (tagId is List<int>) {
        tagId = tagId
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':')
            .toUpperCase();
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
      if (tag.data.containsKey('mifareultralight'))
        techList.add('MIFARE Ultralight');

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
          formattedBytes +=
              byte.toRadixString(16).padLeft(2, '0').toUpperCase();
        }
        formattedBytes += ''; // Add additional characters as needed
      } else {
        formattedBytes =
            'Unknown'; // Handle case where historicalBytes is not available
      }
      //historicalBytesEnd

      // Determine the tag type
      String tagType = _getTagType(techList);
      var serialNumber = _extractSerialNumber(tag);
      var atqa = _extractATQA(tag);
      var sak = _extractSAK(tag);
      var timeOut = _extractTimeout(tag);
      var extendedLengthSupported = _extractisExtendedLengthApduSupported(tag);
      var maxTransceiveLength = _extractmaxTransceiveLength(tag);
      var hiLayerResponse = _extractHiLayerResponse(tag);
      var isWritable = "";
      var makeReadOnly = "";
      var size = "";
      if (techList.contains('NDEF')) {
        isWritable = _extractIsWritable(tag);
      }
      if (techList.contains('NDEF')) {
        makeReadOnly = _extractMakeReadOnly(tag);
      }
      if (techList.contains('NDEF')) {
        size = _extractSize(tag);
      }

      // print('maxTransceiveLength: $maxTransceiveLength');
      // Create an instance of NfcTagData
      var nfcTagData = NfcTagData(
          tagId: tagId,
          techList: techList,
          tagType: tagType,
          historicalBytes: formattedBytes,
          serialNumber: serialNumber,
          atqa: atqa,
          sak: sak,
          timeout: timeOut,
          isExtendedLengthSupported: extendedLengthSupported,
          maxTransceiveLength: maxTransceiveLength,
          hiLayerResponse: hiLayerResponse,
          writable: isWritable,
          readonly: makeReadOnly,
          size: size);

      // Update result.value with the NfcTagData object
      result.value = nfcTagData;
      // _showBottomDialog(context, false);
      // Stop the NFC session
      NfcManager.instance.stopSession();
      if (bottomSheetContext != null) {
        Navigator.of(bottomSheetContext!).pop();
        bottomSheetContext = null;
      }
    });
  }

  String _extractSerialNumber(NfcTag tag) {
    // Example extraction logic; adjust based on your NFC tag data structure
    // Replace with actual extraction logic
    var serialNumber =
        ''; // Replace with actual path to serial number in your tag data
    if (tag.data.containsKey('nfca')) {
      var nfcaData = tag.data['nfca'];

      // Extract and format the identifier as a serial number
      if (nfcaData.containsKey('identifier')) {
        List<int> identifier = nfcaData['identifier'];

        // Convert each byte in identifier to hexadecimal and join with ':'
        serialNumber = identifier
            .map((e) => e.toRadixString(16).padLeft(2, '0'))
            .join(':')
            .toUpperCase();
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
        sak = '0x' + sakByte.toRadixString(16).toUpperCase();
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
        timeout = '${nfcaData['timeout'] ?? ""}';
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
        hiLayerResponse = '${isoDepData['hiLayerResponse'] ?? "Null"}';
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
        maxTransceiveLength = '${nfcaData['maxTransceiveLength'] ?? ""}';
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
        isExtendedLengthApduSupported =
            '${isoDepData['isExtendedLengthApduSupported'] ?? ""}';
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
        atqa = '0x' +
            atqaBytes
                .map((e) => e.toRadixString(16).padLeft(2, '0'))
                .join('')
                .toUpperCase();
      }
    }

    return atqa;
  }

  String _extractIsWritable(NfcTag tag) {
    var writable = '';

    // Check if 'nfca' is present in tag data
    if (tag.data.containsKey('ndef')) {
      var ndefData = tag.data['ndef'];

      // Extract ATQA if available
      if (ndefData.containsKey('isWritable')) {
        writable = '${ndefData['isWritable'] ?? ""}';
      }
    }

    return writable;
  }

  String _extractMakeReadOnly(NfcTag tag) {
    var readOnly = '';

    // Check if 'nfca' is present in tag data
    if (tag.data.containsKey('ndef')) {
      var ndefData = tag.data['ndef'];

      // Extract ATQA if available
      if (ndefData.containsKey('canMakeReadOnly')) {
        readOnly = '${ndefData['canMakeReadOnly'] ?? ""}';
      }
    }

    return readOnly;
  }

  String _extractSize(NfcTag tag) {
    var size = '';

    // Check if 'ndef' is present in tag data
    if (tag.data.containsKey('ndef')) {
      var ndefData = tag.data['ndef'];

      // Check if cachedMessage is present and has records
      if (ndefData.containsKey('cachedMessage')) {
        var cachedMessage = ndefData['cachedMessage'];
        var records = cachedMessage['records'];

        // Calculate the total length of the payloads
        int totalLength = 0;
        if (records is List) {
          for (var record in records) {
            if (record.containsKey('payload')) {
              var payload = record['payload'];
              if (payload is List) {
                totalLength += payload.length;
              }
            }
          }
        }

        // Extract maxSize if available
        if (ndefData.containsKey('maxSize')) {
          size = '${totalLength} / ${ndefData['maxSize']} bytes';
        }
      } else {
        // If cachedMessage is not available, fall back to showing 0 / maxSize
        if (ndefData.containsKey('maxSize')) {
          size = '0 / ${ndefData['maxSize']} bytes';
        }
      }
    }

    return size;
  }

  String formatNfcForumType2(NfcTag tag) {
    StringBuffer buffer = StringBuffer();

    // Check if 'ndef' is present in tag data
    if (tag.data.containsKey('ndef')) {
      var ndefData = tag.data['ndef'];

      // Check if cachedMessage is present and has records
      if (ndefData.containsKey('cachedMessage')) {
        var cachedMessage = ndefData['cachedMessage'];
        var records = cachedMessage['records'];

        if (records is List) {
          for (var record in records) {
            if (record.containsKey('payload')) {
              var payload = record['payload'];
              if (payload is List) {
                // Format and decode each record
                buffer.writeln(_formatRecord(record));
              }
            }
          }
        }
      }
    }

    return buffer.toString();
  }

  String _formatRecord(Map<String, dynamic> record) {
    StringBuffer buffer = StringBuffer();

    // Extract typeNameFormat
    int tnf = record['typeNameFormat'];
    buffer.writeln('Type Name Format: $tnf');

    // Extract type
    var type = record['type'];
    if (type is List<int>) {
      String typeString = String.fromCharCodes(type);
      buffer.writeln('Type: $typeString');
    }

    // Extract identifier
    var identifier = record['identifier'];
    if (identifier is List<int>) {
      String identifierString = String.fromCharCodes(identifier);
      buffer.writeln('Identifier: $identifierString');
    }

    // Extract payload
    var payload = record['payload'];
    if (payload is List<int>) {
      String payloadString = String.fromCharCodes(payload);
      buffer.writeln('Payload: $payloadString');
    }

    buffer.writeln();

    return buffer.toString();
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
