import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class JobList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Job Listings',
      home: JobListScreen(),
    );
  }
}

class JobListScreen extends StatefulWidget {
  @override
  _JobListScreenState createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  Future<void>? _fetchingData;
  List<DocumentSnapshot> jobs = [];
  String? name = " ";
  String? userId = " ";
  String searchQuery = '';
  int selectedCategoryIndex = 0; // Initially selecting "All" category

  final List<Color> chipBackgroundColors = [
    Color.fromRGBO(159, 129, 247, 0.15), // I.T
    Color.fromRGBO(25, 103, 210, 0.15), // Consulting
    Color.fromRGBO(255, 0, 0, 0.15), // All
    Color.fromRGBO(52, 168, 83, 0.15), // Engineering
    Color.fromRGBO(249, 171, 0, 0.15), // Healthcare
  ];

  final List<Color> chipLabelColors = [
    Color.fromRGBO(159, 129, 247, 1.0), // I.T
    Color.fromRGBO(25, 103, 210, 1.0), // Consulting
    Color.fromRGBO(255, 0, 0, 1.0), // All
    Color.fromRGBO(52, 168, 83, 1.0), // Engineering
    Color.fromRGBO(249, 171, 0, 1.0), // Healthcare
  ];

  @override
  void initState() {
    super.initState();
    _fetchingData = fetchJobs();
  }

  Future<void> fetchJobs() async {
    final prefs = await SharedPreferences.getInstance();

    userId = prefs.getString('userID');
    if (userId != null) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      setState(() {
        name = userSnapshot['name'];
      });
    }
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('job_postings').get();
    setState(() {
      jobs = snapshot.docs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchingData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error fetching data'),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
                body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hello, ${name}', // Replace with user's name
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 159, 129, 247),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Welcome Back!',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Color.fromARGB(255, 159, 129, 247)
                                        .withOpacity(0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.account_circle,
                                color: Color.fromARGB(255, 159, 129, 247)),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: Color.fromARGB(255, 241, 230, 255),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1), // Adjusted padding here
                          child: TextField(
                            cursorColor: Color.fromARGB(
                                255, 159, 129, 247), // Set cursor color here
                            decoration: InputDecoration(
                              hintText: 'Search jobs...',
                              prefixIcon: Icon(Icons.search,
                                  color: Color.fromARGB(255, 159, 129,
                                      247)), // Set search icon color here
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 159, 129, 247),
                                    width: 2), // Set outline color when focused
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.toLowerCase();
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    'Popular Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 159, 129, 247).withOpacity(1),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SizedBox(
                  height: 100, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5, // Number of categories
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          _filterByCategory(index);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: chipBackgroundColors[index],
                            border: Border.all(
                              color: _getCategoryColor(index),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getCategoryIcon(index),
                                color: chipLabelColors[index],
                                size: 32,
                              ),
                              SizedBox(height: 8),
                              Text(
                                _getCategoryTitle(index),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: chipLabelColors[index],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Jobs For You',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 159, 129, 247).withOpacity(1),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      var job = jobs[index].data() as Map<String, dynamic>;
                      String companyName = job['company_name'] ?? 'N/A';
                      String jobCountry = job['job_country'] ?? 'N/A';
                      String jobCity = job['job_city'] ?? 'N/A';
                      String jobCategory = job['job_category'] ?? 'N/A';
                      String jobName = job['job_name'] ?? 'N/A';
                      List<String> jobTitles = job['job_title'] != null
                          ? List<String>.from(job['job_title'])
                          : [];
                      String jobType = job['job_type'] ?? 'N/A';
                      String estimatedSalary = job['estimated_salary'] ?? 'N/A';
                      String experience = job['experience'] ?? 'N/A';
                      String jobApplyLink = job['job_apply_link'] ?? 'N/A';
                      String description =
                          job['description'] ?? 'No description available';

                      if (searchQuery.isNotEmpty &&
                          !jobName.toLowerCase().contains(searchQuery) &&
                          !companyName.toLowerCase().contains(searchQuery)) {
                        return Container();
                      }

                      if (selectedCategoryIndex != 0 &&
                          jobTitles.indexOf(
                                  _getCategoryTitle(selectedCategoryIndex)) ==
                              -1) {
                        return Container();
                      }

                      return JobListCard(
                        companyName: companyName,
                        jobCountry: jobCountry,
                        jobCity: jobCity,
                        jobCategory: jobCategory,
                        jobName: jobName,
                        jobTitles: jobTitles,
                        jobType: jobType,
                        estimatedSalary: estimatedSalary,
                        experience: experience,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailScreen(
                                companyName: companyName,
                                jobCountry: jobCountry,
                                jobCity: jobCity,
                                jobCategory: jobCategory,
                                jobName: jobName,
                                jobTitles: jobTitles,
                                jobType: jobType,
                                estimatedSalary: estimatedSalary,
                                experience: experience,
                                description: description,
                                jobApplyLink: jobApplyLink,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            )),
          );
        }
      },
    );
  }

  Color _getCategoryColor(int index) {
    if (index == selectedCategoryIndex ||
        (selectedCategoryIndex == 0 && index == 0)) {
      return chipLabelColors[
          index]; // Active color for selected category or "All" category
    } else {
      return chipBackgroundColors[index]; // Inactive color for other categories
    }
  }

  IconData _getCategoryIcon(int index) {
    switch (index) {
      case 0:
        return Icons.category; // All category
      case 1:
        return Icons.computer; // I.T category
      case 2:
        return Icons.business; // Consulting category
      case 3:
        return Icons.build; // Engineering category
      case 4:
        return Icons.local_hospital; // Healthcare category
      default:
        return Icons.category; // Default category icon
    }
  }

  String _getCategoryTitle(int index) {
    switch (index) {
      case 0:
        return 'All'; // All category
      case 1:
        return 'I.T'; // I.T category
      case 2:
        return 'Consulting'; // Consulting category
      case 3:
        return 'Engineering'; // Engineering category
      case 4:
        return 'Healthcare'; // Healthcare category
      default:
        return 'Category'; // Default category title
    }
  }

  void _filterByCategory(int index) {
    setState(() {
      selectedCategoryIndex = index;
    });
  }
}

class JobListCard extends StatelessWidget {
  final String companyName;
  final String jobCountry;
  final String jobCity;
  final String jobCategory;
  final String jobName;
  final List<String> jobTitles;
  final String jobType;
  final String estimatedSalary;
  final String experience;
  final VoidCallback onTap;

  JobListCard({
    required this.companyName,
    required this.jobCountry,
    required this.jobCity,
    required this.jobCategory,
    required this.jobName,
    required this.jobTitles,
    required this.jobType,
    required this.estimatedSalary,
    required this.experience,
    required this.onTap,
  });

  final List<Color> chipBackgroundColors = [
    Color.fromRGBO(159, 129, 247, 0.15),
    Color.fromRGBO(52, 168, 83, 0.15),
    Color.fromRGBO(249, 171, 0, 0.15),
    Color.fromRGBO(25, 103, 210, 0.15),
    Color.fromRGBO(255, 0, 1, 0.15),
  ];

  final List<Color> chipLabelColors = [
    Color.fromRGBO(159, 129, 247, 1.0),
    Color.fromRGBO(52, 168, 83, 1.0),
    Color.fromRGBO(249, 171, 0, 1.0),
    Color.fromRGBO(25, 103, 210, 1.0),
    Color.fromRGBO(255, 0, 0, 1.0),
  ];

  Widget _buildLabel(String text, Color bgColor, Color labelColor) {
    return Chip(
      label: Text(text),
      backgroundColor: bgColor,
      labelStyle: TextStyle(color: labelColor, fontFamily: 'Jost'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(width: 0.0, color: bgColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(width: 1.0, color: Color(0xFFFecedf2)),
      ),
      elevation: 0, // Remove elevation to make it flat
      color: Colors.white, // Pure white background
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                jobName,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Jost',
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.business, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    companyName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontFamily: 'Jost',
                    ),
                  ),
                  SizedBox(width: 16),
                  Icon(Icons.location_on, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$jobCity, $jobCountry',
                      style: TextStyle(fontSize: 16, fontFamily: 'Jost'),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.work, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    experience,
                    style: TextStyle(fontSize: 16, fontFamily: 'Jost'),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SizedBox(width: 8),
                  Text(
                    estimatedSalary,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.green,
                      fontFamily: 'Jost',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  if (jobTitles.isNotEmpty)
                    _buildLabel(
                      jobType,
                      chipBackgroundColors[0],
                      chipLabelColors[0],
                    ),
                  _buildLabel(
                    jobCategory,
                    chipBackgroundColors[1],
                    chipLabelColors[1],
                  ),
                  _buildLabel(
                    jobTitles.first,
                    chipBackgroundColors[2],
                    chipLabelColors[2],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JobDetailScreen extends StatelessWidget {
  final String companyName;
  final String jobCountry;
  final String jobCity;
  final String jobCategory;
  final String jobName;
  final List<String> jobTitles;
  final String jobType;
  final String estimatedSalary;
  final String experience;
  final String description;
  final String jobApplyLink;

  JobDetailScreen({
    required this.companyName,
    required this.jobCountry,
    required this.jobCity,
    required this.jobCategory,
    required this.jobName,
    required this.jobTitles,
    required this.jobType,
    required this.estimatedSalary,
    required this.experience,
    required this.description,
    required this.jobApplyLink,
  });

  final List<Color> chipBackgroundColors = [
    Color.fromRGBO(159, 129, 247, 0.15),
    Color.fromRGBO(25, 103, 210, 0.15),
    Color.fromRGBO(255, 0, 0, 0.15),
    Color.fromRGBO(52, 168, 83, 0.15),
    Color.fromRGBO(249, 171, 0, 0.15),
  ];

  final List<Color> chipLabelColors = [
    Color.fromRGBO(159, 129, 247, 1.0),
    Color.fromRGBO(25, 103, 210, 1.0),
    Color.fromRGBO(255, 0, 0, 1.0),
    Color.fromRGBO(52, 168, 83, 1.0),
    Color.fromRGBO(249, 171, 0, 1.0),
  ];

  Widget buildChip(
      String label, IconData icon, Color backgroundColor, Color labelColor) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: labelColor),
          SizedBox(height: 4),
          Text(
            label,
            style:
                TextStyle(color: labelColor, fontFamily: 'Jost', fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  "assets/jobdetail.png",
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: double.infinity,
                  height: 250,
                  color: Colors.black.withOpacity(0.3),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 70,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        jobName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Jost',
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        companyName,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Jost',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 16.0,
                          runSpacing: 16.0,
                          children: [
                            buildChip(
                              'Location: $jobCity, $jobCountry',
                              Icons.location_on,
                              chipBackgroundColors[1],
                              chipLabelColors[1],
                            ),
                            buildChip(
                              'Category: $jobCategory',
                              Icons.category,
                              chipBackgroundColors[2],
                              chipLabelColors[2],
                            ),
                            buildChip(
                              'Experience: $experience',
                              Icons.work,
                              chipBackgroundColors[3],
                              chipLabelColors[3],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Center(
                        child: Column(
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Jost',
                                  color: Color.fromARGB(255, 159, 129, 247)),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 8),
                            Text(
                              description,
                              style:
                                  TextStyle(fontSize: 16, fontFamily: 'Jost'),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    _launchUrl(jobApplyLink);
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 201, 185, 250),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: Text(
                    "APPLY NOW",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _launchUrl(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    throw Exception('Could not launch $_url');
  }
}
