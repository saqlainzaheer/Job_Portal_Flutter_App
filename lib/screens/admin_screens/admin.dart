import 'package:flutter/material.dart';
import 'package:job_portal/screens/intro_screens/intro_page4.dart';
import 'admin_home_screen.dart';
import 'job_posting_screen.dart';
import 'active_users_screen.dart';
import 'settings_screen.dart';

// class AdminMainScreen extends StatefulWidget {
//   final String? adminId;

//   const AdminMainScreen({Key? key, required this.adminId}) : super(key: key);

//   @override
//   _AdminMainScreenState createState() => _AdminMainScreenState();
// }

// class _AdminMainScreenState extends State<AdminMainScreen> {
//   int _currentIndex = 0;

//   final List<Widget> _screens = [
//     AdminHomePage(),
//     JobListPage(),
//     ActiveUsersScreen(),
//     SettingsScreen(),
//   ];

//   final List<String> _titles = [
//     'Home',
//     'Job Posting',
//     'Active Users',
//     'Settings',
//   ];

//   final List<IconData> _icons = [
//     Icons.home,
//     Icons.work,
//     Icons.people,
//     Icons.settings,
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromARGB(
//             255, 201, 185, 250), // Background color same as navigation
//         title: Row(
//           children: [
//             Icon(
//               _icons[_currentIndex],
//               size: 28,

//               // Icon of the selected navigation item
//               color: Color.fromARGB(
//                   255, 159, 129, 247), // Icon color same as navigation
//             ),
//             SizedBox(width: 8),
//             Text(
//               _titles[_currentIndex], // Title of the selected navigation item
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w500,
//                 color: Color.fromARGB(
//                     255, 249, 249, 249), // Text color same as navigation
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: _screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         items: [
//           for (int i = 0; i < _titles.length; i++)
//             BottomNavigationBarItem(
//               icon: Icon(_icons[i]),
//               activeIcon: Icon(
//                 _icons[i],
//                 color: Color.fromARGB(
//                     255, 159, 129, 247), // Icon color same as navigation
//               ),
//               label: _titles[i],
//               backgroundColor: Color.fromARGB(
//                   255, 201, 185, 250), // Background color same as navigation
//             ),
//         ],
//       ),
//     );
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class AdminMainScreen extends StatefulWidget {
  final String? adminId;

  const AdminMainScreen({Key? key, required this.adminId}) : super(key: key);

  @override
  _AdminMainScreenState createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    AdminHomePage(),
    JobListPage(),
    ActiveUsersScreen(),
    SettingsScreen(),
  ];

  final List<String> _titles = [
    'Home',
    'Job Posting',
    'Active Users',
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
