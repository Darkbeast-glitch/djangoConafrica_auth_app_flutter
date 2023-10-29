import 'package:djangoconafrica/components/colors.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserDetailPage extends StatefulWidget {
  final String data;
  final String barcodeResult;
  final String token; //

  const UserDetailPage(
      {super.key,
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

  void _toggleEnrollment(bool value, int index) async {
    // Perform API request to toggle attendee enrollment state
    final ticketUuid = tickets[index]['uuid'];

    try {
      final response = await http.patch(
        Uri.parse(
            'https://djc-africa-api.vercel.app/enroll-attendee/$ticketUuid'), // Include ticket UUID in the URL
        body: jsonEncode({'enrolled': value}),
        headers: {'Content-Type': 'application/json', 'x-auth': widget.token},
      );

      print("uuid:$ticketUuid");
      if (response.statusCode == 200) {
        setState(() {
          // Update the status in the local data
          tickets[index]['status'] = value;
        });
      } else {
        // Handle the error, e.g., show an error message to the user
        print('Failed to update enrollment status');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    }

    // You can use the 'tickets[index]['uuid']' to identify the ticket
    // and 'value' to determine if the attendee is being enrolled or unenrolled
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userData = jsonDecode(widget.data);

    final List<String> ticketNames = (userData['data']['tickets'] as List)
        .map((ticket) => ticket['ticket_name'].toString())
        .toList();

    final String fullName = userData['data']['profile']['fullname'].toString();
    final String country = userData['data']['profile']['country'].toString();

    // List<String> formattedData = [
    //   'Barcode Result: $barcodeResult',
    //   'Full Name: $fullName',
    //   'Country: $country',
    //   'Tickets: ${ticketNames.join(', ')}'
    // ];
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
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            width: MediaQuery.of(context).size.width,
            height: 98,
            decoration: BoxDecoration(
              color: Colors.grey[100],
            ),
            child: Text(
              widget.barcodeResult,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Full Name:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  fullName,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Country:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  country,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
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
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                entry.value['ticket_name'],
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              Spacer(),
                              Text(
                                entry.value['status'] ? 'Enrolled' : 'Enroll',
                                style: TextStyle(
                                    color: entry.value['status']
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold),
                              ), // Add spacer to separate ticket name from switches
                              Switch(
                                value: entry.value['status'],
                                onChanged: entry.value['status']
                                    ? null // If already enrolled, disable the switch
                                    : (value) {
                                        _toggleEnrollment(value, entry.key);
                                      },
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


































// import 'package:djangoconafrica/components/colors.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';

// class UserDetailPage extends StatelessWidget {
//   final String data;
//   final String barcodeResult;

//   const UserDetailPage(
//       {Key? key, required this.data, required this.barcodeResult})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Map<String, dynamic> userData = jsonDecode(data);

//     final List<String> ticketNames = (userData['data']['tickets'] as List)
//         .map((ticket) => ticket['ticket_name'].toString())
//         .toList();

//     final String fullName = userData['data']['profile']['fullname'].toString();
//     final String country = userData['data']['profile']['country'].toString();

//     List<String> formattedData = [
//       'Barcode Result: $barcodeResult',
//       'Full Name: $fullName',
//       'Country: $country',
//       'Tickets: ${ticketNames.join(', ')}'
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios,
//             color: primaryColor,
//             size: 20,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: transparentColor,
//         elevation: 0,
//         title: Text(
//           "DjangoCon Africa",
//           style: TextStyle(
//             color: secondaryColor,
//             fontWeight: FontWeight.bold,
//             fontSize: 23,
//           ),
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: formattedData.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(formattedData[index]),
//           );
//         },
//       ),
//     );
//   }
// }
