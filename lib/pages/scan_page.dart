import 'package:djangoconafrica/components/colors.dart';
import 'package:djangoconafrica/pages/user_datails_page.dart';
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
  bool _isLoading = false;
  String _extractedInformation = "No QR code scanned yet.";

  Future<void> _scanQRCode() async {
    setState(() {
      _isLoading = true;
      _extractedInformation = "Scanning QR code...";
    });

    try {
      String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (barcodeScanResult != '-1') {
        Uri apiUrl = Uri.parse(
            'https://djc-africa-api.vercel.app/get-ticket-details/$barcodeScanResult');

        http.Response response = await http.get(
          apiUrl,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
        );

        if (response.statusCode == 200) {
          String extractedInformation = response.body;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserDetailPage(
                data: extractedInformation,
                barcodeResult: barcodeScanResult,
                token: widget.token,
              ),
            ),
          );
        } else {
          // Show error message for invalid QR code.
          _showErrorMessage("Invalid QR code. Please try again.");
        }
      } else {
        // Show message for canceled scan.
        _showErrorMessage("QR code scan was canceled.");
      }
    } catch (e) {
      // Handle other errors that might occur during scanning.
      _showErrorMessage("Error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorMessage(String message) {
    setState(() {
      _extractedInformation = message;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
          ),
        ),
        centerTitle: true,
        backgroundColor: transparentColor,
        elevation: 0,
        title: Text(
          "DjangoCon Africa",
          style: TextStyle(
            color: secondaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 23,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                      fontStyle: FontStyle.normal,
                    )),
                onPressed: _scanQRCode,
                child: Text("Scan"),
              ),
            ],
          ),
          SizedBox(height: 20),
          if (_isLoading)
            CircularProgressIndicator(
              color: Colors.blue,
            ),
          Text(
            _extractedInformation,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
