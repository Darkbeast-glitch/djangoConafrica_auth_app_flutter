import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:djangoconafrica/pages/scan_page.dart';
import 'package:djangoconafrica/components/colors.dart';

class UserDetailPage extends StatefulWidget {
  final String data;
  final String barcodeResult;
  final String token;

  const UserDetailPage({
    Key? key,
    required this.data,
    required this.barcodeResult,
    required this.token,
  });

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Map<String, dynamic>? userData;
  late List<dynamic>? tickets;
  bool _isLoading = false;
  String _extractedInformation = "No QR code scanned yet.";

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> decodedData = jsonDecode(widget.data);
    userData = decodedData['data']['profile'];
    tickets = decodedData['data']['tickets'];
  }

  Future<void> _toggleEnrollment(bool value, int index) async {
    if (tickets != null) {
      final ticketUuid = tickets![index]['uuid'];

      try {
        final response = await http.patch(
          Uri.parse(
              'https://djc-africa-api.vercel.app/enroll-attendee/$ticketUuid'),
          body: jsonEncode({'enrolled': value}),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
        );

        print('UUID: $ticketUuid');
        print('API Response Status Code: ${response.statusCode}');
        print('API Response Body: ${response.body}');

        if (response.statusCode == 200) {
          setState(() {
            tickets![index]['status'] = value;
          });
        } else {
          print('Failed to update enrollment status');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update enrollment status')),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error occurred while updating enrollment status')),
        );
      }
    }
  }

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
          Map<String, dynamic> responseData = json.decode(response.body);

          if (responseData.containsKey('data') &&
              responseData['data'] != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailPage(
                  data: response.body,
                  barcodeResult: barcodeScanResult,
                  token: widget.token,
                ),
              ),
            );
          } else {
            setState(() {
              _extractedInformation = "Invalid ticket data. Please try again.";
            });
          }
        } else {
          setState(() {
            _extractedInformation = "Invalid QR code. Please try again.";
          });
        }
      } else {
        setState(() {
          _extractedInformation = "QR code scan was canceled.";
        });
      }
    } catch (e) {
      setState(() {
        _extractedInformation = "Error occurred: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = userData?['fullname']?.toString() ?? '';
    final String country = userData?['country']?.toString() ?? '';
    final String email = userData?['email']?.toString() ?? '';

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => ScanPage(token: widget.token),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => ScanPage(token: widget.token),
                ),
              );
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
              fontSize: 20,
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              width: 368,
              height: MediaQuery.of(context).size.height / 5.5,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        fullName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        country,
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Tickets:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (tickets?.isEmpty ??
                      true) // Check if tickets is empty or null
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'No tickets found',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  Column(
                    children: tickets
                            ?.asMap()
                            .entries
                            .map(
                              (entry) => ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      entry.value['ticket_name'] != null
                                          ? entry.value['ticket_name']
                                          : 'Ticket Name Unavailable',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (entry.value['ticket_name'] !=
                                        'Donation')
                                      Row(
                                        children: [
                                          Text(
                                            entry.value['status']
                                                ? 'Enrolled'
                                                : 'Enroll',
                                            style: TextStyle(
                                                color: entry.value['status']
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Switch(
                                            value: entry.value['status'],
                                            onChanged: entry.value['status']
                                                ? null
                                                : (value) {
                                                    _toggleEnrollment(
                                                        value, entry.key);
                                                  },
                                            activeColor: primaryColor,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            )
                            .toList() ??
                        [], // Provide an empty list if tickets is null
                  ),
                  SizedBox(height: 60),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _scanQRCode,
                        style: ElevatedButton.styleFrom(
                          minimumSize:
                              Size(MediaQuery.of(context).size.width / 1.8, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(44),
                          ),
                          backgroundColor: secondaryColor,
                        ),
                        child: Text("Scan New Ticket 🎫"),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/djangocon.png",
                        height: 75,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("DjangoCon Africa © 2023"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
