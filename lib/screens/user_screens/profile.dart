import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  _UserProfileState createState() => _UserProfileState();
}

String userId = '';

class _UserProfileState extends State<UserProfile> {
  Map<String, dynamic> userProfile = {};

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userID') ?? '';
    });
    if (userId.isNotEmpty) {
      _loadUserProfile();
    }
  }

  Future<void> _loadUserProfile() async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    setState(() {
      userProfile = userDoc.data() as Map<String, dynamic>;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: Icon(Icons.account_box),
        backgroundColor: Color.fromARGB(255, 159, 129, 247),
        title: const Text('Profile Details'),
      ),
      body: userProfile.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  _buildProfileHeader(),
                  const SizedBox(height: 20),
                  _buildProfileTile('Name', userProfile['name'], Icons.person),
                  _buildProfileTile('Email', userProfile['email'], Icons.email),
                  _buildProfileTile(
                      'Phone', userProfile['phoneNumber'], Icons.phone),
                  _buildProfileTile(
                      'City', userProfile['city'], Icons.location_city),
                  _buildProfileTile(
                      'Country', userProfile['country'], Icons.public),
                  _buildProfileTile('Job Titles',
                      userProfile['jobTitles'].join(', '), Icons.work),
                  _buildProfileTile(
                      'Job Type', userProfile['jobType'], Icons.work_outline),
                  _buildProfileTile('Work Preference',
                      userProfile['workPreference'], Icons.access_time),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfile(userProfile: userProfile),
            ),
          );
          if (result == true) {
            // <-- Added this block
            // If the profile was updated, reload the user profile
            _loadUserProfile(); // <-- Added this line
          }
        },
        child: const Icon(Icons.edit),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          // Placeholder image or actual user image can be used here
          backgroundImage: AssetImage('assets/profile.png'),
        ),
        const SizedBox(height: 10),
        Text(
          userProfile['name'],
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildProfileTile(String label, String value, IconData icon) {
    return Column(
      children: [
        ListTile(
          iconColor: Color.fromARGB(255, 159, 129, 247),
          // textColor: Color.fromARGB(255, 159, 129, 247),
          leading: Icon(icon),
          titleTextStyle: TextStyle(color: Color.fromARGB(255, 159, 129, 247)),
          subtitleTextStyle: TextStyle(color: Colors.black.withOpacity(0.6)),
          title: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(value),
        ),
        const Divider(
          color: Colors.grey,
          height: 0,
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
        ),
      ],
    );
  }
}

class EditProfile extends StatefulWidget {
  final Map<String, dynamic> userProfile;

  const EditProfile({required this.userProfile, super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> updatedProfile;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;
  late TextEditingController _jobTitlesController;
  late TextEditingController _jobTypeController;
  late TextEditingController _workPreferenceController;

  @override
  void initState() {
    super.initState();
    updatedProfile = Map.from(widget.userProfile);
    _nameController = TextEditingController(text: updatedProfile['name']);
    _emailController = TextEditingController(text: updatedProfile['email']);
    _phoneNumberController =
        TextEditingController(text: updatedProfile['phoneNumber']);
    _cityController = TextEditingController(text: updatedProfile['city']);
    _countryController = TextEditingController(text: updatedProfile['country']);
    _jobTitlesController =
        TextEditingController(text: updatedProfile['jobTitles'].join(', '));
    _jobTypeController = TextEditingController(text: updatedProfile['jobType']);
    _workPreferenceController =
        TextEditingController(text: updatedProfile['workPreference']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _jobTitlesController.dispose();
    _jobTypeController.dispose();
    _workPreferenceController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Color.fromARGB(150, 130, 129, 131),
        fontStyle: FontStyle.italic,
        fontSize: 16,
      ),
      filled: true,
      fillColor: const Color.fromARGB(255, 241, 230, 255),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(14),
        child: Icon(
          icon,
          color: const Color.fromARGB(255, 159, 129, 247),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(40.0),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 159, 129, 247),
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Name', Icons.person),
                onChanged: (value) {
                  updatedProfile['name'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                enabled: false,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                cursorColor: const Color.fromARGB(255, 159, 129, 247),
                decoration: _inputDecoration('name@gmail.com', Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onChanged: (value) {
                  updatedProfile['email'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneNumberController,
                decoration: _inputDecoration('Phone Number', Icons.phone),
                onChanged: (value) {
                  updatedProfile['phoneNumber'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cityController,
                decoration: _inputDecoration('City', Icons.location_city),
                onChanged: (value) {
                  updatedProfile['city'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _countryController,
                decoration: _inputDecoration('Country', Icons.public),
                onChanged: (value) {
                  updatedProfile['country'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jobTitlesController,
                decoration: _inputDecoration('Job Titles', Icons.work),
                onChanged: (value) {
                  updatedProfile['jobTitles'] =
                      value.split(',').map((title) => title.trim()).toList();
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _jobTypeController,
                decoration: _inputDecoration('Job Type', Icons.work_outline),
                onChanged: (value) {
                  updatedProfile['jobType'] = value;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _workPreferenceController,
                decoration:
                    _inputDecoration('Work Preference', Icons.access_time),
                onChanged: (value) {
                  updatedProfile['workPreference'] = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Show loader while update is in progress
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // Prevent user from dismissing dialog
                      builder: (BuildContext context) {
                        return Center(
                          child:
                              CircularProgressIndicator(), // Or any other loader widget
                        );
                      },
                    );

                    try {
                      // Perform update operation
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .update(updatedProfile);

                      // Hide loader
                      Navigator.of(context).pop();
                      // Navigator.of(context).pop();

                      // Navigate to UserProfile after successful update
                      Navigator.of(context).pop(true);
                    } catch (error) {
                      // Hide loader
                      Navigator.of(context).pop();

                      // Handle error
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Error"),
                            content: Text("An error occurred: $error"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          );
                        },
                      );
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
                  "UPDATE",
                  style: TextStyle(
                      color: Colors.white, fontSize: 18, letterSpacing: 1.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
