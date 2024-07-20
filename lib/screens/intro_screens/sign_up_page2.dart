import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:job_portal/screens/intro_screens/intro_page4.dart';

class AdditionalInfoPage extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  AdditionalInfoPage({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  _AdditionalInfoPageState createState() => _AdditionalInfoPageState();
}

class _AdditionalInfoPageState extends State<AdditionalInfoPage> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  String country = '';
  String city = '';
  String jobType = '';
  String workPreference = '';
  List<String> jobTitles = [];
  bool isLoading = false;

  TextEditingController jobTitleController = TextEditingController();

  void _addJobTitle(String title) {
    if (jobTitles.length < 5 && title.isNotEmpty) {
      setState(() {
        jobTitles.add(title);
        jobTitleController.clear();
      });
    }
  }

  List<Color> chipBackgroundColors = [
    const Color.fromRGBO(159, 129, 247, 0.15),
    const Color.fromRGBO(52, 168, 83, 0.15),
    const Color.fromRGBO(249, 171, 0, 0.15),
    const Color.fromRGBO(25, 103, 210, 0.15),
    const Color.fromRGBO(159, 129, 247, 0.15),
  ];

  List<Color> chipLabelColors = [
    const Color.fromRGBO(159, 129, 247, 1.0),
    const Color.fromRGBO(52, 168, 83, 1.0),
    const Color.fromRGBO(249, 171, 0, 1.0),
    const Color.fromRGBO(25, 103, 210, 1.0),
    const Color.fromRGBO(159, 129, 247, 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/login.png"),
                        fit: BoxFit.fill)),
                child: Column(children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: IconButton(
                          icon: const Icon(
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
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Job Info',
                          style: TextStyle(
                              fontFamily: 'PassionOne',
                              color: Colors.blue,
                              fontSize: 42,
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
                          decoration: const BoxDecoration(color: Colors.blue),
                        )),
                        const SizedBox(
                          width: 2,
                        ),
                        Positioned(
                            child: Container(
                          width: 25,
                          height: 4,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(148, 33, 149, 243)),
                        )),
                      ],
                    ),
                  )
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        _buildJobTitleField(),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          child: Wrap(
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            spacing: 7.0,
                            runSpacing: 7.0,
                            children: jobTitles.asMap().entries.map((entry) {
                              int index = entry.key;
                              String title = entry.value;
                              return Chip(
                                label: Text(title),
                                onDeleted: () {
                                  setState(() {
                                    jobTitles.remove(title);
                                  });
                                },
                                padding: EdgeInsets.symmetric(vertical: 2),
                                backgroundColor: chipBackgroundColors[index],
                                deleteIconColor: chipLabelColors[index],
                                labelStyle:
                                    TextStyle(color: chipLabelColors[index]),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: BorderSide(
                                      width: 0.0,
                                      color: chipBackgroundColors[index]),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        _buildInputField(
                          labelText: 'Phone Number',
                          hintText: '123456789',
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phoneNumber = value ?? '';
                          },
                          prefixIcon: Icons.phone,
                        ),
                        _buildInputField(
                          labelText: 'Country',
                          hintText: 'Your country',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your country';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            country = value ?? '';
                          },
                          prefixIcon: Icons.location_on,
                          keyboardType: TextInputType.text,
                        ),
                        _buildInputField(
                          labelText: 'City',
                          hintText: 'Your city',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            city = value ?? '';
                          },
                          prefixIcon: Icons.location_city,
                          keyboardType: TextInputType.text,
                        ),
                        _buildDropdownField(
                          labelText: 'Job Type',
                          hintText: const Text(
                            'Select Job Type',
                            style: TextStyle(
                              color: Color.fromARGB(150, 130, 129, 131),
                              fontSize: 14,
                            ),
                          ),
                          value: jobType.isEmpty ? null : jobType,
                          items: ['Remote', 'On-site'],
                          onChanged: (value) {
                            setState(() {
                              jobType = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a job type';
                            }
                            return null;
                          },
                        ),
                        _buildDropdownField(
                          labelText: 'Work Preference',
                          hintText: const Text(
                            'Select Work Preference',
                            style: TextStyle(
                              color: Color.fromARGB(150, 130, 129, 131),
                              fontSize: 14,
                            ),
                          ),
                          value: workPreference.isEmpty ? null : workPreference,
                          items: ['Full-time', 'Part-time', 'Freelance'],
                          onChanged: (value) {
                            setState(() {
                              workPreference = value ?? '';
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a work preference';
                            }
                            return null;
                          },
                        ),
                        !isLoading
                            ? ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    _formKey.currentState?.save();
                                    _signUpAndSaveInfo();
                                  } else {
                                    print("Validation failed");
                                  }
                                },
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 20)),
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 201, 185, 250)),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  "PROCEED",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      letterSpacing: 1.1),
                                ),
                              )
                            : const Center(child: CircularProgressIndicator()),
                      ],
                    ),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
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

  Widget _buildDropdownField({
    required String labelText,
    required Widget hintText,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required FormFieldValidator<String>? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        hint: hintText,
        dropdownColor: Color.fromARGB(255, 241, 230, 255),
        focusColor: Color.fromARGB(255, 241, 230, 255),
        value: value,
        decoration: InputDecoration(
          labelText: labelText,
          hoverColor: Color.fromARGB(255, 241, 230, 255),
          filled: true,
          fillColor: Color.fromARGB(255, 241, 230, 255),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        ),
        icon: Icon(Icons.arrow_drop_down,
            color: Color.fromARGB(255, 159, 129, 247)),
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: TextStyle(
                color: Color.fromARGB(255, 159, 129, 247), // Text color
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildJobTitleField() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: jobTitleController,
        decoration: InputDecoration(
          labelText: 'Add Job Title',
          hintText: 'e.g. Software Developer',
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
              Icons.work,
              color: Color.fromARGB(255, 159, 129, 247),
            ),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.add, color: Color.fromARGB(255, 159, 129, 247)),
            onPressed: () {
              _addJobTitle(jobTitleController.text);
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide.none,
          ),
        ),
        onFieldSubmitted: (value) {
          _addJobTitle(value);
        },
      ),
    );
  }

  void _signUpAndSaveInfo() async {
    try {
      // Create user in Firebase Auth
      setState(() {
        isLoading = true; // Show loader
      });
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: widget.email,
        password: widget.password,
      );
      User? user = userCredential.user;
      // Save additional user info in Firestore
      if (user != null) {
        String role = 'user';
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': widget.name,
          'email': widget.email,
          'phoneNumber': phoneNumber,
          'country': country,
          'city': city,
          'jobType': jobType,
          'workPreference': workPreference,
          'jobTitles': jobTitles,
          'role': role,
        });

        // Navigate to the next screen or show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully')),
        );
        setState(() {
          isLoading = false; // Show loader
        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => IntroPage4(initialEmail: widget.email)),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Show loader
      });
      print('Failed to register user: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to register user: $e')),
      );
    }
  }
}
