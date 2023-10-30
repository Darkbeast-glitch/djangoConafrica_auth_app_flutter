import 'package:djangoconafrica/components/colors.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserDetailPage extends StatefulWidget {
  final String data;
  final String barcodeResult;
  final String token;

  const UserDetailPage(
      {Key? key,
      required this.data,
      required this.barcodeResult,
      required this.token});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
  late Map<String, dynamic> userData;
  late List<dynamic> tickets;

  @override
  void initState() {
    super.initState();
    userData = jsonDecode(widget.data);
    tickets = userData['data']['tickets'];
  }

  Future<void> _toggleEnrollment(bool value, int index) async {
    final ticketUuid = tickets[index]['uuid'];

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
          tickets[index]['status'] = value;
        });
      } else {
        print('Failed to update enrollment status');
        // Handle the error, e.g., show a snackbar or an alert dialog to the user
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Failed to update enrollment status')),
        // );
      }
    } catch (e) {
      print('Error: $e');
      // Handle network or other errors
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Error occurred while updating enrollment status')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String fullName = userData['data']['profile']['fullname'].toString();
    final String country = userData['data']['profile']['country'].toString();
    final String email = userData['data']['profile']['email'].toString();

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
            width: 332,
            height: 131,
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
                        fontSize: 23,
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
                        fontSize: 18,
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
                      style: TextStyle(fontSize: 18, color: Colors.white),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text(
                  'Tickets:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Column(
                  children: tickets
                      .asMap()
                      .entries
                      .map(
                        (entry) => ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                entry.value['ticket_name'] != null
                                    ? entry.value['ticket_name']
                                    : 'Ticket Name Unavailable',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              if (entry.value['ticket_name'] != 'Donation')
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
                                      onChanged: (value) {
                                        _toggleEnrollment(value, entry.key);
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
                SizedBox(height: 60),
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
    );
  }
}
