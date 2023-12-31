import 'dart:convert';

import 'package:djangoconafrica/components/colors.dart';
import 'package:djangoconafrica/pages/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _authenticateUser(
    String enteredCode,
  ) async {
    setState(() {
      _isLoading = true;
    });

    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json', // Specify content type as JSON
      };

      Map<String, String> body = {
        'vendor_id': enteredCode,
      };

      http.Response response = await http.post(
        Uri.parse('https://djc-africa-api.vercel.app/authorize'),
        headers: headers,
        body: jsonEncode(body), // Encode the request body as JSON
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the entered code matches the hardcoded value or the vendor_id in the response
        if (enteredCode == "ab1232" ||
            enteredCode == responseData['vendor_id']) {
          // Authentication successful, navigate to ScanPage
          String token =
              responseData['token']; // Assuming the token is in the response
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScanPage(token: token)),
          );

          // Show Snackbar with success message after navigating to ScanPage
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Authentication Successful'),
              backgroundColor: Colors.green, // Change color if needed
            ),
          );
        } else {
          // Invalid code entered, show message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid code. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Authentication failed, show message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication Failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle network or other errors, show error message
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: transparentColor,
        elevation: 0,
        title: Text(
          "DjangoCon Africa",
          style: TextStyle(
              color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 250),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.1,
                  height: 78,
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _codeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '\u26A0 You cannot leave this blank';
                        }
                        return null;
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 214, 214, 214),
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 197, 190, 190),
                          ),
                        ),
                        filled: true,
                        hintText: " Enter your authentication code",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              if (_isLoading)
                CircularProgressIndicator(
                  color: Colors.blue, // Set color as needed
                ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _authenticateUser(_codeController.text);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize:
                      Size(MediaQuery.of(context).size.width / 1.2, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(44),
                  ),
                  backgroundColor: secondaryColor,
                ),
                child: Text("Login"),
              ),
              // SizedBox(height: 20),
              SizedBox(height: 250),
              Text("DjangoCon Africa © 2023"),
            ],
          ),
        ),
      ),
    );
  }
}

// class ScanPage extends StatelessWidget {
//   final String token;

//   const ScanPage({Key? key, required this.token}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Scan Page"),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: Text("Token: $token"),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: AuthPage(),
//   ));
// }
