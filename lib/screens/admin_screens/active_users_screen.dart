import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActiveUsersScreen extends StatelessWidget {
  const ActiveUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Users'),
        backgroundColor: Color.fromARGB(255, 159, 129, 247),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data?.docs
                  .where((doc) => doc['role'] != 'admin')
                  .toList() ??
              [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final name = user['name'] as String? ?? 'Unknown';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(name.isNotEmpty
                        ? name[0]
                        : 'U'), // Display 'U' if name is empty
                  ),
                  title: Text(name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(Icons.phone,
                              size: 16,
                              color: Color.fromARGB(255, 159, 129, 247)),
                          SizedBox(width: 5),
                          Text(user['phoneNumber'] ?? 'N/A'),
                        ],
                      ),
                      SizedBox(height: 5),
                      if (user['city'] != null && user['country'] != null)
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16,
                                color: Color.fromARGB(255, 159, 129, 247)),
                            SizedBox(width: 5),
                            Text('${user['city']}/${user['country']}'),
                          ],
                        ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.email,
                          size: 16, color: Color.fromARGB(255, 159, 129, 247)),
                      SizedBox(width: 5),
                      Text(
                        user['email'] ?? 'N/A',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
