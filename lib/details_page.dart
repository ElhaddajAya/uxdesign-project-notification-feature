import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final String studentId = "2287382";
  final String studentName = "Kaoutar BENNOUR";
  final String grade = "2ème Année - Lycée";
  final DateTime absenceDate = DateTime(2025, 1, 10);
  final String absenceTime = "10h30 - 12h30";
  final String subject = "Mathematiques";
  final String teacher = "Mr. IDRISSI Mohammad";

  String justification = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détails de l'Absence"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              child: Text(
                studentName.split(" ").first.substring(0, 1),
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "$studentName - $grade",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              "Date de l'Absence: ${absenceDate.day}/${absenceDate.month}/${absenceDate.year}",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Horaire Précis: $absenceTime",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Matière: $subject",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              "Enseignant: $teacher",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: justification),
              onChanged: (value) {
                setState(() {
                  justification = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Justifier l'Absence",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle justification submission
              },
              child: Text("Justifier l'Absence"),
            ),
          ],
        ),
      ),
    );
  }
}