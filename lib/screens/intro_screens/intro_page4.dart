import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_portal/screens/admin_screens/admin.dart';
import 'package:job_portal/screens/intro_screens/sign_up.dart';
import 'package:job_portal/screens/user_screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroPage4 extends StatefulWidget {
  final String initialEmail;
  const IntroPage4({Key? key, this.initialEmail = ''}) : super(key: key);

  @override
  _IntroPage4State createState() => _IntroPage4State();
}

class _IntroPage4State extends State<IntroPage4> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail;
  }

  void _showSnackBar(String message, {Color color = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 350,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage("assets/login.png"))),
                        child: Column(children: [
                          Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, top: 40),
                                child: Text(
                                  'SIGN IN',
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
                            padding: const EdgeInsets.only(left: 20),
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
                                      color: const Color.fromARGB(
                                          148, 33, 149, 243)),
                                )),
                              ],
                            ),
                          )
                        ]),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: form(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t have an Account ? ",
                            style: const TextStyle(
                                color: Color.fromARGB(255, 159, 129, 247)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpPage()),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: const TextStyle(
                                color: Color.fromARGB(255, 159, 129, 247),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1.5,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                "OR",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          socialButton("assets/facebook.png"),
                          SizedBox(width: 10),
                          socialButton("assets/google.png"),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget socialButton(String assetPath) {
    return GestureDetector(
      onTap: () {
        // Add your onTap functionality here
      },
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          border:
              Border.all(width: 1.0, color: Color.fromARGB(255, 159, 129, 247)),
          borderRadius: BorderRadius.circular(100),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Image.asset(assetPath, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: Color.fromARGB(255, 159, 129, 247),
            decoration: InputDecoration(
              hintText: "name@gmail.com",
              hintStyle: TextStyle(
                color: Color.fromARGB(150, 130, 129, 131),
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 241, 230, 255),
              prefixIcon: const Padding(
                padding: EdgeInsets.all(14),
                child: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 159, 129, 247),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            cursorColor: Color.fromARGB(255, 159, 129, 247),
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              hintText: "Password",
              hintStyle: TextStyle(
                color: Color.fromARGB(150, 130, 129, 131),
                fontStyle: FontStyle.italic,
                fontSize: 16,
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 241, 230, 255),
              prefixIcon: const Padding(
                padding: EdgeInsets.all(14),
                child: Icon(
                  Icons.lock,
                  color: Color.fromARGB(255, 159, 129, 247),
                ),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Color.fromARGB(255, 159, 129, 247),
                  ),
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(40.0),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        _isLoading = true;
                      });
                      try {
                        final UserCredential userCredential =
                            await _auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        User? user = userCredential.user;
                        if (user != null) {
                          DocumentSnapshot userDoc = await FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(user.uid)
                              .get();

                          String role = userDoc['role'];
                          String name = userDoc['name'];
                          String email = user.email ?? '';

                          // Save user info to shared preferences
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setString('userID', user.uid);
                          await prefs.setString('email', email);
                          await prefs.setString('name', name);
                          await prefs.setString('role', role);
                          await prefs.setBool('isFirstTime', false);

                          // Navigate to appropriate page based on role
                          setState(() {
                            _isLoading = false;
                          });
                          _showSnackBar('Login successful',
                              color: Colors.green);
                          if (role == 'user') {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UserMainScreen(userId: user.uid)),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AdminMainScreen(adminId: user.uid)),
                            );
                          }
                        }
                      } catch (e) {
                        setState(() {
                          _isLoading = false;
                        });
                        _showSnackBar('Login error: $e');
                      }
                    }
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 20)),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 201, 185, 250)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, letterSpacing: 1.1),
                  ),
                ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
