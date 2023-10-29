import 'package:djangoconafrica/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class ScanPage extends StatefulWidget {
  final String token; //
  const ScanPage({super.key, required this.token});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String _extractedInformation = "No QR code scanned yet.";

  Future<void> _scanQRCode() async {
    try {
      String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );
        String token = widget.token;
      

      if (barcodeScanResult != '-1') {
        // Construct a Uri object with the API endpoint and query parameter.
        Uri apiUrl = Uri.parse(
            'https://djc-africa-api.vercel.app/get-ticket-details/$barcodeScanResult');

        // Make an API call using the Uri object.
        http.Response response = await http.get(apiUrl);

        // Check if the API call was successful.
        if (response.statusCode == 200) {
          // Parse the response from the API call.
          _extractedInformation = response.body;
        } else {
          _extractedInformation = "Failed to fetch data from API.";
        }
      } else {
        _extractedInformation = "QR code scan was canceled.";
      }
    } catch (e) {
      _extractedInformation = "Error occurred: $e";
    } finally {
      setState(
          () {}); // Update UI to show the extracted information or error message.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: primaryColor,
                size: 20,
              )),
          centerTitle: true,
          backgroundColor: transparentColor,
          elevation: 0,
          title: Text(
            "DjangoCon Africa",
            style: TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 23),
          )),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(MediaQuery.of(context).size.width / 1.2,
                      50), // Set width and height as needed
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(44)),
                  backgroundColor: secondaryColor,
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontStyle: FontStyle.normal),
                ),
                onPressed: _scanQRCode,
                child: Text("Scan")),
          ],
        ),
        SizedBox(height: 20),
        Text(
          _extractedInformation,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ]),
    );
  }
}
