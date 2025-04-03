import 'package:flutter/material.dart';

class ComplaintsView extends StatelessWidget {
  ComplaintsView({super.key});

  final List<Map<String, String>> complaints = [
    {
      'subject': 'Caravans',
      'description': 'Very slow delivery.',
      'status': 'Pending',
      'userName': 'Abhinandh'
    },
    {
      'subject': 'Sign',
      'description': 'Food was cold.',
      'status': 'Resolved',
      'userName': 'Akash'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        //backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.black,
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.deepPurple.shade300, Colors.deepPurple.shade700],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: complaints.isEmpty
            ? const Center(
                child: Text(
                  'No complaints found.',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: complaints.length,
                itemBuilder: (context, index) {
                  final complaint = complaints[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 6,
                    color: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Restaurant: ${complaint['subject']}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Complaint: ${complaint['description']}',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Text(
                              //   'Status: ${complaint['status']}',
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     fontWeight: FontWeight.w600,
                              //     color: complaint['status'] == 'Resolved'
                              //         ? Colors.green
                              //         : Colors.red,
                              //   ),
                              // ),
                              Text(
                                'User: ${complaint['userName']}',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black54),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
