import 'package:flutter/material.dart';
import 'package:job_portal/screens/intro_screens/intro_page4.dart';
import 'package:job_portal/screens/user_screens/joblist_screen.dart';
import 'package:job_portal/screens/user_screens/joblistapi_screen.dart';
import 'package:job_portal/screens/user_screens/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMainScreen extends StatefulWidget {
  final String? userId;

  const UserMainScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    JobList(),
    JobListApi(),
    UserProfile(),
  ];

  final List<String> _titles = [
    'Home',
    'Job Posting',
    'Profile',
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.work,
    Icons.people,
  ];

  void _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all SharedPreferences

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => IntroPage4(),
      ),
      (Route<dynamic> route) => false,
    ).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout successful'),
          duration: Duration(seconds: 5),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _titles.length) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Logout"),
                  content: Text("Are you sure you want to logout?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        _logout(context);
                      },
                      child: Text("Logout"),
                    ),
                  ],
                );
              },
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          for (int i = 0; i < _titles.length; i++)
            BottomNavigationBarItem(
              icon: Icon(_icons[i]),
              activeIcon: Icon(
                _icons[i],
                color: Color.fromARGB(
                    255, 159, 129, 247), // Icon color same as navigation
              ),
              label: _titles[i],
              backgroundColor: Color.fromARGB(
                  255, 201, 185, 250), // Background color same as navigation
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
            backgroundColor: Color.fromARGB(
                255, 201, 185, 250), // Background color same as navigation
          ),
        ],
      ),
    );
  }
}
