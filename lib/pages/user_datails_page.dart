import 'package:djangoconafrica/components/colors.dart';
import 'package:flutter/material.dart';

class UserDetailPage extends StatelessWidget {
  final String data;
  final String barcodeResult; // Add this line

  const UserDetailPage(
      {Key? key, required this.data, required this.barcodeResult})
      : super(key: key);

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
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
            width: MediaQuery.of(context).size.width,
            height: 98,
            decoration: BoxDecoration(color: Colors.grey[100]),
            child: Text(
              barcodeResult,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Center(
            child: Text(data),
          ),
        ],
      ),
    );
  }
}
