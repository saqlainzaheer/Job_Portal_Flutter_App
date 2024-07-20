import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/screens/intro_screens/sign_up_page2.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', password = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                height: 350,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/login.png"),
                        fit: BoxFit.fill)),
                child: Column(children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: IconButton(
                          icon: Icon(
                            size: 30,
                            weight: 20,
                            Icons.arrow_back,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontFamily: 'PassionOne',
                              color: Colors.blue,
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              height: 0.8),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Row(
                      children: [
                        Positioned(
                            child: Container(
                          width: 30,
                          height: 4.5,
                          decoration: BoxDecoration(color: Colors.blue),
                        )),
                        SizedBox(
                          width: 2,
                        ),
                        Positioned(
                            child: Container(
                          width: 25,
                          height: 4,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(148, 33, 149, 243)),
                        )),
                      ],
                    ),
                  )
                ]),
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                          height: 350), // To give space for the image and text
                      _buildInputField(
                        labelText: 'Name',
                        hintText: 'Your name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          name = value ?? '';
                        },
                        prefixIcon: Icons.person,
                      ),
                      _buildInputField(
                        labelText: 'Email',
                        hintText: 'Your email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          email = value ?? '';
                        },
                        prefixIcon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildInputField(
                        labelText: 'Password',
                        hintText: 'Your password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          password = value ?? '';
                        },
                        prefixIcon: Icons.lock,
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  _formKey.currentState?.save();
                                  _checkEmailAndProceed();
                                }
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(vertical: 20)),
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 201, 185, 250)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              child: Text(
                                "PROCEED",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    letterSpacing: 1.1),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String labelText,
    required String hintText,
    required FormFieldValidator<String>? validator,
    required FormFieldSetter<String>? onSaved,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.next,
        cursorColor: Color.fromARGB(255, 159, 129, 247),
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          hintStyle: TextStyle(
            color: Color.fromARGB(150, 130, 129, 131),
            fontStyle: FontStyle.italic,
            fontSize: 16,
          ),
          filled: true,
          fillColor: Color.fromARGB(255, 241, 230, 255),
          prefixIcon: Padding(
            padding: EdgeInsets.all(14),
            child: Icon(
              prefixIcon,
              color: Color.fromARGB(255, 159, 129, 247),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  void _checkEmailAndProceed() async {
    setState(() {
      _isLoading = true;
    });
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      QuerySnapshot result = await users.where('email', isEqualTo: email).get();

      if (result.docs.isEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionalInfoPage(
              name: name,
              email: email,
              password: password,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email is already in use')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking email: $e')),
      );
      print('Error checking email: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
