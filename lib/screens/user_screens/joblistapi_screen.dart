import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobListApi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  bool remoteJobsOnly = false;
  String workType = 'Any';
  bool isLoading = false;
  bool isLoadingMore = false;
  int page = 1;
  List<dynamic> jobData = [];
  final ScrollController _scrollController = ScrollController();

  bool isFullTime = false;
  bool isContractor = false;
  bool isPartTime = false;
  bool isIntern = false;

  String datePosted = 'All';

  List<String> jobTitles = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initializeUserData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _jobTitleController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !isLoadingMore) {
      _fetchJobs(loadMore: true);
    }
  }

  void _initializeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        setState(() {
          workType = userData['jobType'] == 'Remote' ? 'Remote' : 'On-site';
          isFullTime = userData['workPreference'] == 'Full-time';
          jobTitles = List<String>.from(userData['jobTitles'] ?? []);
          // _searchController.text = jobTitles.join(' ') +
          //     ' in ${userData['city']}, ${userData['country']}';
          _searchController.text =
              (jobTitles.isNotEmpty ? jobTitles.first : '') +
                  ' in ${userData['city']}, ${userData['country']}';
        });

        _fetchJobs();
      }
    }
  }

  void _fetchJobs({bool loadMore = false}) async {
    if (loadMore) {
      setState(() {
        isLoadingMore = true;
      });
    } else {
      setState(() {
        isLoading = true;
        jobData = [];
        page = 1;
      });
    }

    final query = _searchController.text;
    final url = Uri.parse('https://jsearch.p.rapidapi.com/search');

    String employmentType = '';
    if (isFullTime) employmentType += 'FULLTIME,';
    if (isContractor) employmentType += 'CONTRACTOR,';
    if (isPartTime) employmentType += 'PARTTIME,';
    if (isIntern) employmentType += 'INTERN,';
    if (employmentType.isNotEmpty) {
      employmentType = employmentType.substring(
          0, employmentType.length - 1); // Remove trailing comma
    }

    String jobTitlesString = jobTitles.join(',');

    final response = await http.get(
      url.replace(queryParameters: {
        'query': query,
        'page': page.toString(),
        'num_pages': '1',
        'date_posted': datePosted.toLowerCase(),
        'remote_jobs_only': workType == 'Remote' ? 'true' : 'false',
        'employment_types': employmentType,
        'job_titles': jobTitlesString,
      }),
      headers: {
        // 'X-RapidAPI-Key': '1dd8fbfed8mshc032dfe42181b82p1d22afjsn421e9269f4ec',
        // 'X-RapidAPI-Host': 'jsearch.p.rapidapi.com',
        'X-RapidAPI-Key': 'a7ed720236msh4f499811a182ef9p159ec7jsn92c424eb3f63',
        'X-RapidAPI-Host': 'jsearch.p.rapidapi.com'
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        jobData.addAll(data['data']);
        if (loadMore) {
          isLoadingMore = false;
        } else {
          isLoading = false;
        }
        page++;
      });
    } else {
      setState(() {
        if (loadMore) {
          isLoadingMore = false;
        } else {
          isLoading = false;
        }
      });
      print('Failed to load jobs');
    }
  }

  void _openFilterDrawer() {
    _scaffoldKey.currentState!.openDrawer();
  }

  void _addJobTitle() {
    final title = _jobTitleController.text.trim();
    if (title.isNotEmpty && !jobTitles.contains(title)) {
      setState(() {
        jobTitles.add(title);
        _jobTitleController.clear();
      });
    }
  }

  void _removeJobTitle(String title) {
    setState(() {
      jobTitles.remove(title);
    });
  }

  final List<Color> chipBackgroundColors = [
    Color.fromRGBO(159, 129, 247, 0.15),
    Color.fromRGBO(25, 103, 210, 0.15),
    Color.fromRGBO(52, 168, 83, 0.15),
    Color.fromRGBO(249, 171, 0, 0.15),
    Color.fromRGBO(159, 129, 247, 0.15),
  ];

  final List<Color> chipLabelColors = [
    Color.fromRGBO(159, 129, 247, 1.0),
    Color.fromRGBO(25, 103, 210, 1.0),
    Color.fromRGBO(52, 168, 83, 1.0),
    Color.fromRGBO(249, 171, 0, 1.0),
    Color.fromRGBO(159, 129, 247, 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // DrawerHeader(
              //   decoration: BoxDecoration(
              //     color: Colors.blue,
              //   ),
              //   child: Text(
              //     'Filters',
              //     style: TextStyle(
              //       color: Colors.white,
              //       fontSize: 24,
              //     ),
              //   ),
              //),
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/filter.jpg"),
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4), // Adjust opacity as needed
                      BlendMode
                          .darken, // Choose blend mode for darkening effect
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 0, top: 0),
                      child: Text(
                        'Filters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: "PassionOne",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text('Select Job Work Type',
                    style: TextStyle(
                        color: Color.fromARGB(255, 159, 129, 247),
                        fontWeight: FontWeight.bold)),
                trailing: DropdownButton<String>(
                  value: workType,
                  onChanged: (String? newValue) {
                    setState(() {
                      workType = newValue!;
                    });
                  },
                  items: <String>['On-site', 'Remote', 'Any']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(
                            color: Color.fromARGB(255, 159, 129, 247),
                          )),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Employment Type',
                    style: TextStyle(
                        color: Color.fromARGB(255, 159, 129, 247),
                        fontWeight: FontWeight.bold)),
                subtitle: Column(
                  children: [
                    SwitchListTile(
                      trackOutlineColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              states.contains(MaterialState.dragged)) {
                            return Colors
                                .transparent; // Transparent color for pressed or hovered state
                          }
                          return Color.fromARGB(255, 159, 129,
                              247); // Default color for other states
                        },
                      ),
                      inactiveThumbColor: Color.fromARGB(255, 159, 129, 247),
                      activeColor: Color.fromARGB(255, 159, 129, 247),
                      title: Text('FULLTIME'),
                      value: isFullTime,
                      onChanged: (bool value) {
                        setState(() {
                          isFullTime = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      trackOutlineColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              states.contains(MaterialState.dragged)) {
                            return Colors
                                .transparent; // Transparent color for pressed or hovered state
                          }
                          return Color.fromARGB(255, 159, 129,
                              247); // Default color for other states
                        },
                      ),
                      inactiveThumbColor: Color.fromARGB(255, 159, 129, 247),
                      activeColor: Color.fromARGB(255, 159, 129, 247),
                      title: Text('CONTRACTOR'),
                      value: isContractor,
                      onChanged: (bool value) {
                        setState(() {
                          isContractor = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      inactiveThumbColor: Color.fromARGB(255, 159, 129, 247),
                      trackOutlineColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              states.contains(MaterialState.dragged)) {
                            return Colors
                                .transparent; // Transparent color for pressed or hovered state
                          }
                          return Color.fromARGB(255, 159, 129,
                              247); // Default color for other states
                        },
                      ),
                      title: Text('PARTTIME'),
                      activeColor: Color.fromARGB(255, 159, 129, 247),
                      value: isPartTime,
                      onChanged: (bool value) {
                        setState(() {
                          isPartTime = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      trackOutlineColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed) ||
                              states.contains(MaterialState.dragged)) {
                            return Colors
                                .transparent; // Transparent color for pressed or hovered state
                          }
                          return Color.fromARGB(255, 159, 129,
                              247); // Default color for other states
                        },
                      ),
                      inactiveThumbColor: Color.fromARGB(255, 159, 129, 247),
                      title: Text('INTERN'),
                      activeColor: Color.fromARGB(255, 159, 129, 247),
                      value: isIntern,
                      onChanged: (bool value) {
                        setState(() {
                          isIntern = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text(
                  'Date Posted',
                  style: TextStyle(
                      color: Color.fromARGB(255, 159, 129, 247),
                      fontWeight: FontWeight.bold),
                ),
                trailing: DropdownButton<String>(
                  value: datePosted,
                  onChanged: (String? newValue) {
                    setState(() {
                      datePosted = newValue!;
                    });
                  },
                  items: <String>['All', 'Today', '3 Days', 'Week', 'Month']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(
                            color: Color.fromARGB(255, 159, 129, 247),
                          )),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                title: Text('Job Titles',
                    style: TextStyle(
                        color: Color.fromARGB(255, 159, 129, 247),
                        fontWeight: FontWeight.bold)),
                subtitle: Column(
                  children: [
                    TextField(
                      controller: _jobTitleController,
                      decoration: InputDecoration(
                        hintText: 'Enter job title',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: _addJobTitle,
                        ),
                      ),
                    ),
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
                            backgroundColor: chipBackgroundColors[index %
                                chipBackgroundColors
                                    .length], // Ensures colors repeat if jobTitles exceeds chipBackgroundColors length
                            deleteIconColor: chipLabelColors[index %
                                chipLabelColors
                                    .length], // Ensures colors repeat if jobTitles exceeds chipLabelColors length
                            labelStyle: TextStyle(
                                color: chipLabelColors[index %
                                    chipLabelColors
                                        .length]), // Ensures colors repeat if jobTitles exceeds chipLabelColors length
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  width: 0.0,
                                  color: chipBackgroundColors[index %
                                      chipBackgroundColors
                                          .length]), // Ensures colors repeat if jobTitles exceeds chipBackgroundColors length
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: ElevatedButton(
                  onPressed: _fetchJobs,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 15)),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 201, 185, 250)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                  ),
                  child: Text(
                    "APPLY FILTERS",
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, letterSpacing: 1.1),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: _openFilterDrawer,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF1E6FF),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search jobs...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        onSubmitted: (value) => _fetchJobs(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _fetchJobs,
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : jobData.isEmpty
                      ? Center(child: Text('No jobs found'))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: jobData.length + 1,
                          itemBuilder: (context, index) {
                            if (index == jobData.length) {
                              return isLoadingMore
                                  ? Center(child: CircularProgressIndicator())
                                  : SizedBox.shrink();
                            }
                            final job = jobData[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        JobDetailPage(job: job),
                                  ),
                                );
                              },
                              child: JobCard(
                                remoteJobsOnly: job['job_is_remote'],
                                jobTitle: job['job_title'] ?? 'No Title',
                                companyName:
                                    job['employer_name'] ?? 'No Company',
                                jobType: job['job_employment_type'] ?? 'N/A',
                                // location:
                                //     '${job['job_city'] ?? 'No City'}, ${job['job_state'] ?? 'No State'}',
                                location: job['job_city'] != null &&
                                        job['job_state'] != null
                                    ? '${job['job_city']}, ${job['job_state']}'
                                    : 'n/a',
                                salary: job['job_highlights']?['Benefits']
                                        ?[0] ??
                                    'n/a',
                                jobDescription:
                                    job['job_description'] ?? 'No Description',
                                jobApplyLink: job['job_apply_link'] ??
                                    job['job_google_link'] ??
                                    '',
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class JobCard extends StatelessWidget {
  final String jobTitle;
  final String companyName;
  final String jobType;
  final String location;
  final String salary;
  final bool remoteJobsOnly;
  final String jobDescription;
  final String jobApplyLink;

  JobCard({
    required this.jobTitle,
    required this.companyName,
    required this.jobType,
    required this.location,
    required this.salary,
    required this.remoteJobsOnly,
    required this.jobDescription,
    required this.jobApplyLink,
  });

  final List<Color> chipBackgroundColors = [
    Color.fromRGBO(159, 129, 247, 0.15),
    Color.fromRGBO(25, 103, 210, 0.15),
    Color.fromRGBO(52, 168, 83, 0.15),
    Color.fromRGBO(249, 171, 0, 0.15),
    Color.fromRGBO(159, 129, 247, 0.15),
  ];

  final List<Color> chipLabelColors = [
    Color.fromRGBO(159, 129, 247, 1.0),
    Color.fromRGBO(25, 103, 210, 1.0),
    Color.fromRGBO(52, 168, 83, 1.0),
    Color.fromRGBO(249, 171, 0, 1.0),
    Color.fromRGBO(159, 129, 247, 1.0),
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

  String _truncateDescription(String description) {
    return description.split('\n').take(5).join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(width: 1.0, color: Color(0xFFECECEC)),
      ),
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jobTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'Jost',
              ),
            ),
            SizedBox(height: 8),
            Text(
              companyName,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Jost',
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildLabel(
                    jobType, chipBackgroundColors[0], chipLabelColors[0]),
                if (location != "n/a")
                  _buildLabel(
                      location, chipBackgroundColors[2], chipLabelColors[2]),
                if (location != "n/a")
                  _buildLabel(salary, chipBackgroundColors[2], Colors.green),
                _buildLabel(remoteJobsOnly == true ? "Remote" : "On Site",
                    chipBackgroundColors[1], chipLabelColors[1]),
              ],
            ),
            SizedBox(height: 8),
            Text(
              _truncateDescription(jobDescription),
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontFamily: 'Jost',
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class JobDetailPage extends StatelessWidget {
  final dynamic job;

  JobDetailPage({required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(159, 129, 247, 1.0),
        title: Text(job['job_title'] ?? 'Job Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              job['job_title'] ?? 'No Title',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Jost',
              ),
            ),
            SizedBox(height: 8),
            Text(
              job['employer_name'] ?? 'No Company',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontFamily: 'Jost',
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(job['job_employment_type'] ?? 'N/A'),
                  backgroundColor: Color.fromRGBO(159, 129, 247, 0.15),
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(159, 129, 247, 1.0),
                    fontFamily: 'Jost',
                  ),
                ),
                Chip(
                  label: Text('${job['job_city']}, ${job['job_state']}'),
                  backgroundColor: Color.fromRGBO(52, 168, 83, 0.15),
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(52, 168, 83, 1.0),
                    fontFamily: 'Jost',
                  ),
                ),
                Chip(
                  label: Text(job['job_highlights']?['Benefits']?[0] ?? 'N/A'),
                  backgroundColor: Color.fromRGBO(249, 171, 0, 0.15),
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontFamily: 'Jost',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              job['job_description'] ?? 'No Description',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: 'Jost',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Job ID: ${job['job_id']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'Jost',
              ),
            ),
            Text(
              'Publisher: ${job['job_publisher']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'Jost',
              ),
            ),
            Text(
              'Employment Type: ${job['job_employment_type']}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontFamily: 'Jost',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (job['job_apply_link'] != null &&
                    job['job_apply_link'].isNotEmpty) {
                  _launchUrl(job['job_apply_link']);
                } else if (job['job_google_link'] != null &&
                    job['job_google_link'].isNotEmpty) {
                  _launchUrl(job['job_google_link']);
                }
              },
              child: Text('Apply Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
  // Future<void> _launchUrl(String url) async {
  //   final Uri _url = Uri.parse(url);
  //   if (!await launchUrl(_url)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }
}
