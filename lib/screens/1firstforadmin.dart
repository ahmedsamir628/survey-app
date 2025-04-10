import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'vewdetails.dart';

class FirstForAdmin extends StatefulWidget {
  const FirstForAdmin({super.key});

  @override
  _FirstForAdminState createState() => _FirstForAdminState();
}

class _FirstForAdminState extends State<FirstForAdmin> {
  late Stream<List<DocumentSnapshot>> _surveysStream;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final Set<String> _selectedDepartments = {};

  final List<String> _departments = ['CS', 'Stat', 'Math'];

  @override
  void initState() {
    super.initState();
    _surveysStream = FirebaseFirestore.instance
        .collection('surveys')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  void _refreshSurveys() {
    setState(() {
      _surveysStream = FirebaseFirestore.instance
          .collection('surveys')
          .snapshots()
          .map((snapshot) => snapshot.docs);
    });
  }

  void _clearFilter(String department) {
    setState(() {
      _selectedDepartments.remove(department);
    });
  }

  // ignore: unused_element
  void _showFilterOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter by Departments'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: _departments.map((department) {
              return CheckboxListTile(
                title: Text(department),
                value: _selectedDepartments.contains(department),
                onChanged: (value) {
                  setState(() {
                    if (value!) {
                      _selectedDepartments.add(department);
                    } else {
                      _selectedDepartments.remove(department);
                    }
                  });
                  Navigator.pop(context);
                  _showFilterOptions(context);
                },
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Done'),
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
        title: Text("Home for Admin", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 28, 51, 95),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search surveys...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.filter_list),
                      itemBuilder: (context) => _departments.map((department) {
                        return PopupMenuItem<String>(
                          value: department,
                          child: Row(
                            children: [
                              Checkbox(
                                value:
                                    _selectedDepartments.contains(department),
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      _selectedDepartments.add(department);
                                    } else {
                                      _selectedDepartments.remove(department);
                                    }
                                  });
                                  Navigator.pop(context);
                                },
                              ),
                              Text(department),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                if (_selectedDepartments.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Wrap(
                      spacing: 8.0,
                      children: _selectedDepartments.map((department) {
                        return Chip(
                          label: Text(department),
                          deleteIcon: Icon(Icons.close, size: 16),
                          onDeleted: () => _clearFilter(department),
                        );
                      }).toList(),
                    ),
                  ),
                SizedBox(height: 20),
                Text(
                  'Create a New Survey',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(
                  'Follow the instructions to create your survey.',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 253, 200, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () async {
                        await Navigator.pushNamed(context, '/createsurvv');
                        _refreshSurveys();
                      },
                      child: Row(
                        children: [
                          Icon(Icons.add, color: Colors.black),
                          Text(' Create Survey',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 253, 200, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/groupp');
                  },
                  child: Row(
                    children: [
                      Icon(Icons.remove_red_eye, color: Colors.black),
                      Text(' View groups',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Surveys',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                SizedBox(height: 10),
                Container(
                  height: 330,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    child: StreamBuilder<List<DocumentSnapshot>>(
                      stream: _surveysStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.data == null || snapshot.data!.isEmpty) {
                          return Center(child: Text("No surveys available."));
                        }

                        final filteredSurveys = snapshot.data!.where((doc) {
                          final data = doc.data() as Map<String, dynamic>;
                          final name =
                              data['name']?.toString().toLowerCase() ?? '';
                          final departments =
                              (data['departments'] as List<dynamic>?)
                                      ?.map((d) => d.toString().toLowerCase())
                                      .toSet() ??
                                  {};
                          return name.contains(_searchQuery) &&
                              (_selectedDepartments.isEmpty ||
                                  _selectedDepartments.every((dep) =>
                                      departments.contains(dep.toLowerCase())));
                        }).toList();

                        filteredSurveys.sort((a, b) {
                          final aData = a.data() as Map<String, dynamic>;
                          final bData = b.data() as Map<String, dynamic>;
                          final aTimestamp = aData['timestamp'] as Timestamp?;
                          final bTimestamp = bData['timestamp'] as Timestamp?;
                          if (aTimestamp == null || bTimestamp == null) {
                            return 0;
                          }
                          return bTimestamp.compareTo(aTimestamp);
                        });

                        return Column(
                          children: filteredSurveys.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            final questions = data['questions'] ?? [];
                            final departments =
                                (data['departments'] as List<dynamic>?)
                                        ?.map((d) => d.toString())
                                        .join(', ') ??
                                    'Unknown Departments';
                            final timestamp = data['timestamp'] as Timestamp?;
                            final formattedTime = timestamp != null
                                ? '${timestamp.toDate().day}/${timestamp.toDate().month}/${timestamp.toDate().year}'
                                : 'N/A';

                            return SurveyCard(
                              title: data['name'] ?? 'Unnamed Survey',
                              subtitle: '${questions.length} questions',
                              departments: departments,
                              image: "assets/ansr.png",
                              createdAt: formattedTime,
                              survey: doc,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}

class SurveyCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String departments;
  final String image;
  final String createdAt;
  final DocumentSnapshot survey;

  const SurveyCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.departments,
    required this.image,
    required this.createdAt,
    required this.survey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 2)],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(
                      'Departments: $departments',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    Text(
                      'Created: $createdAt',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 253, 200, 0)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SurveyDetailsScreen(survey: survey),
                            ),
                          );
                        },
                        child: Text('View Details',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 100,
              height: 80,
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavigationBarWidget extends StatelessWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 28, 51, 95),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BottomNavItem(
            icon: Icons.home,
            label: "Home",
            isSelected: true,
            onTap: () {
              Navigator.pushReplacementNamed(context, '/firsrforadminn');
            },
          ),
          BottomNavItem(
            icon: Icons.edit,
            label: "Create Survey",
            onTap: () {
              Navigator.pushReplacementNamed(context, '/createsurvv');
            },
          ),
          BottomNavItem(
            icon: Icons.group,
            label: "Groups",
            onTap: () {
              Navigator.pushReplacementNamed(context, '/groupp');
            },
          ),
          BottomNavItem(
            icon: Icons.navigate_next,
            label: "Add Student",
            onTap: () {
              Navigator.pushNamed(context, '/admin_dashboard');
            },
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const BottomNavItem({
    super.key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon,
              color: isSelected ? Colors.white : Colors.blueGrey, size: 24),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.white : Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
