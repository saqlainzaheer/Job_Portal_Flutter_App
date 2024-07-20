import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  late int totalJobPostings = 0;
  late int totalUsers = 0;
  late String? name = " ";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  void fetchStats() async {
    try {
      // Fetch total job postings count
      final prefs = await SharedPreferences.getInstance();
      name = prefs.getString('name');
      QuerySnapshot jobPostingsSnapshot =
          await FirebaseFirestore.instance.collection('job_postings').get();
      setState(() {
        totalJobPostings = jobPostingsSnapshot.docs.length;
      });

      // Fetch total users count
      QuerySnapshot usersSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        totalUsers = usersSnapshot.docs.length;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching stats: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 159, 129, 247),
                        Color.fromARGB(255, 135, 115, 191),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Image.asset(
                          "assets/admin.png",
                          width: 600,
                          height: 250,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Text(
                          'Welcome back, ${name}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      _buildStatCard('Total Job Postings', totalJobPostings),
                      SizedBox(height: 20),
                      _buildStatCard('Total Users', totalUsers),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatCard(String label, int value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 201, 185, 250),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 159, 129, 247),
            ),
          ),
          SizedBox(height: 10),
          Text(
            '$value',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
