// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class JobPostingPage extends StatefulWidget {
//   final String? jobId;

//   JobPostingPage({this.jobId});

//   @override
//   _JobPostingPageState createState() => _JobPostingPageState();
// }

// class _JobPostingPageState extends State<JobPostingPage> {
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController companyNameController = TextEditingController();
//   TextEditingController jobCountryController = TextEditingController();
//   TextEditingController jobCategoryController = TextEditingController();
//   TextEditingController jobCityController = TextEditingController();
//   TextEditingController jobNameController = TextEditingController();
//   TextEditingController jobTitlesController = TextEditingController();
//   TextEditingController jobTypeController = TextEditingController();
//   TextEditingController estimatedSalaryController = TextEditingController();
//   TextEditingController experienceController = TextEditingController();

//   String? selectedJobCategory;
//   String? selectedJobType;

//   List<String> jobCategories = ["On site", "Remote"];
//   List<String> jobTypes = ["Fulltime", "Part time", "Contract", "Intern"];
//   List<String> jobTitles = [];

//   bool isLoading = false;

//   List<Color> chipBackgroundColors = [
//     Color.fromRGBO(159, 129, 247, 0.15),
//     Color.fromRGBO(52, 168, 83, 0.15),
//     Color.fromRGBO(249, 171, 0, 0.15),
//     Color.fromRGBO(25, 103, 210, 0.15),
//     Color.fromRGBO(159, 129, 247, 0.15),
//   ];

//   List<Color> chipLabelColors = [
//     Color.fromRGBO(159, 129, 247, 1.0),
//     Color.fromRGBO(52, 168, 83, 1.0),
//     Color.fromRGBO(249, 171, 0, 1.0),
//     Color.fromRGBO(25, 103, 210, 1.0),
//     Color.fromRGBO(159, 129, 247, 1.0),
//   ];
//   @override
//   void initState() {
//     super.initState();
//     if (widget.jobId != null) {
//       fetchJobDetails();
//     }
//   }

//   Future<void> fetchJobDetails() async {
//     setState(() {
//       isLoading = true;
//     });

//     try {
//       DocumentSnapshot jobDoc = await FirebaseFirestore.instance
//           .collection('job_postings')
//           .doc(widget.jobId)
//           .get();

//       setState(() {
//         companyNameController.text = jobDoc['company_name'];
//         jobCountryController.text = jobDoc['job_country'];
//         selectedJobCategory = jobDoc['job_category'];
//         jobCityController.text = jobDoc['job_city'];
//         jobNameController.text = jobDoc['job_name'];
//         jobTitles = List<String>.from(jobDoc['job_title']);
//         jobTitlesController.text = jobTitles.join(', ');
//         selectedJobType = jobDoc['job_type'];
//         estimatedSalaryController.text = jobDoc['estimated_salary'];
//         experienceController.text = jobDoc['experience'];
//         isLoading = false;
//       });
//     } catch (error) {
//       print('Error fetching job details: $error');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   Future<void> saveJobPosting() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         isLoading = true;
//       });

//       Map<String, dynamic> jobData = {
//         'company_name': companyNameController.text,
//         'job_country': jobCountryController.text,
//         'job_category': selectedJobCategory,
//         'job_city': jobCityController.text,
//         'job_name': jobNameController.text,
//         'job_title': jobTitles,
//         'job_type': selectedJobType,
//         'estimated_salary': estimatedSalaryController.text,
//         'experience': experienceController.text,
//       };

//       try {
//         if (widget.jobId == null) {
//           await FirebaseFirestore.instance
//               .collection('job_postings')
//               .add(jobData);
//         } else {
//           await FirebaseFirestore.instance
//               .collection('job_postings')
//               .doc(widget.jobId)
//               .update(jobData);
//         }

//         Navigator.pop(context);
//       } catch (error) {
//         print('Error saving job posting: $error');
//       } finally {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       filled: true,
//       fillColor: Color.fromARGB(255, 241, 230, 255),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(8.0),
//         borderSide: BorderSide.none,
//       ),
//       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//             widget.jobId == null ? 'Create Job Posting' : 'Update Job Posting'),
//       ),
//       body: isLoading
//           ? Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     TextFormField(
//                       controller: companyNameController,
//                       decoration: _inputDecoration('Company Name'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter company name';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: jobCountryController,
//                       decoration: _inputDecoration('Job Country'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter job country';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     DropdownButtonFormField<String>(
//                       value: selectedJobCategory,
//                       decoration: _inputDecoration('Job Category'),
//                       items: jobCategories.map((String category) {
//                         return DropdownMenuItem<String>(
//                           value: category,
//                           child: Text(category),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedJobCategory = newValue;
//                         });
//                       },
//                       validator: (value) =>
//                           value == null ? 'Please select job category' : null,
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: jobCityController,
//                       decoration: _inputDecoration('Job City'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter job city';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: jobNameController,
//                       decoration: _inputDecoration('Job Name'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter job name';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: jobTitlesController,
//                       enabled: jobTitles.length <= 5,
//                       maxLines: null,
//                       decoration:
//                           _inputDecoration('Job Titles (comma separated)'),
//                       onChanged: (value) {
//                         setState(() {
//                           jobTitles = value
//                               .split(',')
//                               .map((title) => title.trim())
//                               .toList();
//                         });
//                       },
//                     ),
//                     // Wrap(
//                     //   spacing: 8.0,
//                     //   children: jobTitles.map((title) {
//                     //     return Chip(
//                     //       label: Text(title),
//                     //       onDeleted: () {
//                     //         setState(() {
//                     //           jobTitles.remove(title);
//                     //         });
//                     //       },
//                     //     );
//                     //   }).toList(),
//                     // ),

//                     Container(
//                       margin: const EdgeInsets.all(8.0),
//                       width: double.infinity,
//                       child: Wrap(
//                         alignment: WrapAlignment.start,
//                         direction: Axis.horizontal,
//                         spacing: 7.0,
//                         runSpacing: 7.0,
//                         children: jobTitles.asMap().entries.map((entry) {
//                           int index = entry.key;
//                           if (index == 5) {
//                             return Text("✔️");
//                           }
//                           String title = entry.value;

//                           return Chip(
//                             label: Text(title),
//                             onDeleted: () {
//                               setState(() {
//                                 jobTitles.remove(title);
//                                 jobTitlesController.text = jobTitles.join(', ');
//                               });
//                             },
//                             padding: const EdgeInsets.symmetric(vertical: 2),
//                             backgroundColor: chipBackgroundColors[index],
//                             deleteIconColor: chipLabelColors[index],
//                             labelStyle:
//                                 TextStyle(color: chipLabelColors[index]),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                               side: BorderSide(
//                                   width: 0.0,
//                                   color: chipBackgroundColors[index]),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                     DropdownButtonFormField<String>(
//                       value: selectedJobType,
//                       decoration: _inputDecoration('Job Type'),
//                       items: jobTypes.map((String type) {
//                         return DropdownMenuItem<String>(
//                           value: type,
//                           child: Text(type),
//                         );
//                       }).toList(),
//                       onChanged: (newValue) {
//                         setState(() {
//                           selectedJobType = newValue;
//                         });
//                       },
//                       validator: (value) =>
//                           value == null ? 'Please select job type' : null,
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: estimatedSalaryController,
//                       decoration: _inputDecoration('Estimated Salary'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter estimated salary';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 10),
//                     TextFormField(
//                       controller: experienceController,
//                       decoration: _inputDecoration('Experience'),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Please enter experience';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(height: 20),
//                     ElevatedButton(
//                       onPressed: saveJobPosting,
//                       child: Text('Save'),
//                       style: ElevatedButton.styleFrom(
//                         primary: Color.fromARGB(255, 159, 129, 247),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
// --------------

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobPostingPage extends StatefulWidget {
  final String? jobId;

  JobPostingPage({this.jobId});

  @override
  _JobPostingPageState createState() => _JobPostingPageState();
}

class _JobPostingPageState extends State<JobPostingPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController jobCountryController = TextEditingController();
  TextEditingController jobCategoryController = TextEditingController();
  TextEditingController jobCityController = TextEditingController();
  TextEditingController jobNameController = TextEditingController();
  TextEditingController jobTitlesController = TextEditingController();
  TextEditingController jobTypeController = TextEditingController();
  TextEditingController estimatedSalaryController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController jobApplyLinkController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String? selectedJobCategory;
  String? selectedJobType;

  List<String> jobCategories = ["On site", "Remote", "Hybrid"];
  List<String> jobTypes = ["Fulltime", "Part time", "Contract", "Intern"];
  List<String> jobTitles = [];

  bool isLoading = false;

  List<Color> chipBackgroundColors = [
    Color.fromRGBO(159, 129, 247, 0.15),
    Color.fromRGBO(52, 168, 83, 0.15),
    Color.fromRGBO(249, 171, 0, 0.15),
    Color.fromRGBO(25, 103, 210, 0.15),
    Color.fromRGBO(159, 129, 247, 0.15),
  ];

  List<Color> chipLabelColors = [
    Color.fromRGBO(159, 129, 247, 1.0),
    Color.fromRGBO(52, 168, 83, 1.0),
    Color.fromRGBO(249, 171, 0, 1.0),
    Color.fromRGBO(25, 103, 210, 1.0),
    Color.fromRGBO(159, 129, 247, 1.0),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.jobId != null) {
      fetchJobDetails();
    }
  }

  Future<void> fetchJobDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot jobDoc = await FirebaseFirestore.instance
          .collection('job_postings')
          .doc(widget.jobId)
          .get();

      setState(() {
        companyNameController.text = jobDoc['company_name'];
        jobCountryController.text = jobDoc['job_country'];
        selectedJobCategory = jobDoc['job_category'];
        jobCityController.text = jobDoc['job_city'];
        jobNameController.text = jobDoc['job_name'];
        jobTitles = List<String>.from(jobDoc['job_title']);
        jobTitlesController.text = jobTitles.join(', ');
        selectedJobType = jobDoc['job_type'];
        estimatedSalaryController.text = jobDoc['estimated_salary'];
        experienceController.text = jobDoc['experience'];
        jobApplyLinkController.text = jobDoc['job_apply_link'];
        descriptionController.text = jobDoc['description'];
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching job details: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveJobPosting() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      Map<String, dynamic> jobData = {
        'company_name': companyNameController.text,
        'job_country': jobCountryController.text,
        'job_category': selectedJobCategory,
        'job_city': jobCityController.text,
        'job_name': jobNameController.text,
        'job_title': jobTitles,
        'job_type': selectedJobType,
        'estimated_salary': estimatedSalaryController.text,
        'experience': experienceController.text,
        'job_apply_link': jobApplyLinkController.text,
        'description': descriptionController.text,
      };

      try {
        if (widget.jobId == null) {
          await FirebaseFirestore.instance
              .collection('job_postings')
              .add(jobData);
        } else {
          await FirebaseFirestore.instance
              .collection('job_postings')
              .doc(widget.jobId)
              .update(jobData);
        }

        Navigator.pop(context);
      } catch (error) {
        print('Error saving job posting: $error');
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Color.fromARGB(255, 241, 230, 255),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(159, 129, 247, 1.0),
        title: Text(
            widget.jobId == null ? 'Create Job Posting' : 'Update Job Posting'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: companyNameController,
                      decoration: _inputDecoration('Company Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter company name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: jobCountryController,
                      decoration: _inputDecoration('Job Country'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter job country';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedJobCategory,
                      decoration: _inputDecoration('Job Category'),
                      items: jobCategories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedJobCategory = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select job category' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: jobCityController,
                      decoration: _inputDecoration('Job City'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter job city';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: jobNameController,
                      decoration: _inputDecoration('Job Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter job name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: jobTitlesController,
                      enabled: jobTitles.length <= 5,
                      maxLines: null,
                      decoration:
                          _inputDecoration('Job Titles (comma separated)'),
                      onChanged: (value) {
                        setState(() {
                          jobTitles = value
                              .split(',')
                              .map((title) => title.trim())
                              .toList();
                        });
                      },
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
                          if (index == 5) {
                            return Text("✔️");
                          }
                          String title = entry.value;

                          return Chip(
                            label: Text(title),
                            onDeleted: () {
                              setState(() {
                                jobTitles.remove(title);
                                jobTitlesController.text = jobTitles.join(', ');
                              });
                            },
                            padding: const EdgeInsets.symmetric(vertical: 2),
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
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedJobType,
                      decoration: _inputDecoration('Job Type'),
                      items: jobTypes.map((String type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedJobType = newValue;
                        });
                      },
                      validator: (value) =>
                          value == null ? 'Please select job type' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: estimatedSalaryController,
                      decoration: _inputDecoration('Estimated Salary'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter estimated salary';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: experienceController,
                      decoration: _inputDecoration('Experience'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter experience';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: jobApplyLinkController,
                      decoration: _inputDecoration('Job Apply Link'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter job apply link';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: descriptionController,
                      decoration: _inputDecoration('Description'),
                      maxLines: null,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: saveJobPosting,
                      child: Text('Save'),
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 159, 129, 247),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
