import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_portal/screens/admin_screens/job_postings.dart';

class JobListPage extends StatefulWidget {
  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  bool isLoading = true;
  List<DocumentSnapshot> jobs = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    setState(() {
      isLoading = true;
    });

    try {
      QuerySnapshot jobsSnapshot =
          await FirebaseFirestore.instance.collection('job_postings').get();
      setState(() {
        jobs = jobsSnapshot.docs;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching jobs: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteJob(String jobId) async {
    try {
      await FirebaseFirestore.instance
          .collection('job_postings')
          .doc(jobId)
          .delete();
      fetchJobs();
    } catch (error) {
      print('Error deleting job: $error');
    }
  }

  void confirmDelete(BuildContext context, String jobId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this job posting?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteJob(jobId);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(159, 129, 247, 1.0),
        title: Text('Job Listings'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => JobPostingPage()),
              ).then((_) {
                fetchJobs();
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (ctx, index) {
                final job = jobs[index];
                return JobListCard(
                  companyName: job['company_name'],
                  jobCountry: job['job_country'],
                  jobCity: job['job_city'],
                  jobCategory: job['job_category'],
                  jobName: job['job_name'],
                  jobTitles: List<String>.from(job['job_title']),
                  jobType: job['job_type'],
                  estimatedSalary: job['estimated_salary'],
                  experience: job['experience'],
                  onDelete: () => confirmDelete(context, job.id),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JobPostingPage(jobId: job.id),
                      ),
                    ).then((_) {
                      fetchJobs();
                    });
                  },
                );
              },
            ),
    );
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
  final VoidCallback onDelete;
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
    required this.onDelete,
    required this.onTap,
  });

  final List<Color> chipBackgroundColors = [
    Color.fromRGBO(159, 129, 247, 0.15),
    Color.fromRGBO(52, 168, 83, 0.15),
    Color.fromRGBO(249, 171, 0, 0.15),
    Color.fromRGBO(25, 103, 210, 0.15),
    Color.fromRGBO(159, 129, 247, 0.15),
  ];

  final List<Color> chipLabelColors = [
    Color.fromRGBO(159, 129, 247, 1.0),
    Color.fromRGBO(52, 168, 83, 1.0),
    Color.fromRGBO(249, 171, 0, 1.0),
    Color.fromRGBO(25, 103, 210, 1.0),
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
                  Icon(Icons.attach_money, color: Colors.green),
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
                      jobTitles.first,
                      chipBackgroundColors[0],
                      chipLabelColors[0],
                    ),
                  _buildLabel(
                    jobType,
                    chipBackgroundColors[1],
                    chipLabelColors[1],
                  ),
                  _buildLabel(
                    jobCategory,
                    chipBackgroundColors[2],
                    chipLabelColors[2],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
