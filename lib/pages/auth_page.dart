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
  String? _token;

  Future<void> _authenticateUser(String enteredCode) async {
    try {
      Map<String, dynamic> requestBody = {
        'vendor_id': enteredCode,
      };
      http.Response response = await http.post(
          Uri.parse('https://djc-africa-api.vercel.app/authorize'),
          body: {'vendor_id': enteredCode});

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        _token = response.body;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ScanPage(token: _token!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication Failed. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
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
                        } else if (value !=
                            _authenticateUser(_codeController.text)) {
                          return '\u26A0 Invalid Code. Please try again';
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
              SizedBox(height: 250),
              Text("DjangoCon Africa © 2023"),
            ],
          ),
        ),
      ),
    );
  }
}
