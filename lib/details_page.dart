import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:taalim_notify_app/student_model.dart';

class DetailsPage extends StatefulWidget {
  final int studentId;

  DetailsPage({required this.studentId});


  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  bool isJustifying = false;
  TextEditingController justificationController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isInputEmpty = false;

  late Student student;

  @override
  void initState() {
    super.initState();
    // Charger les données de l'étudiant en fonction de l'ID
    student = students.firstWhere((student) => student.id == widget.studentId);

    // Initialisation de l'animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Durée de l'animation
      vsync: this, // Fournit un ticker
    );
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    // Libération de l'AnimationController pour éviter les fuites
    _animationController.dispose();
    justificationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    File? _selectedFile;
    String? _fileName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Détails de l\'Absence',
          style: TextStyle(
            fontSize: 18, // Augmentation de la taille
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white, size: 26),
            onPressed: () {
              // Action for contacting the school
            },
            tooltip: 'Appeler l\'école',
          ),
          PopupMenuButton(
            color: Color(0xFFF3F4F9),
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 26),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 2,
                child: Text("Supprimer l'absence"),
              ),
              const PopupMenuItem(
                value: 3,
                child: Text("Ajouter une note"),
              ),
              const PopupMenuItem(
                value: 4,
                child: Text("Partager les détails"),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 35, // Augmentation de la taille de l'avatar
                  backgroundColor: Color.fromARGB(255, 207, 234, 255),
                  child: Icon(
                    Icons.person,
                    size: 50, // Augmentation de la taille de l'icône
                    color: Color.fromARGB(255, 9, 60, 171),
                  ),
                ),
                const SizedBox(width: 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${student.id}',
                      style: TextStyle(
                        fontSize: 16, // Augmentation de la taille
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${student.name}',
                      style: TextStyle(
                        fontSize: 20, // Augmentation de la taille
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    Text(
                      '${student.grade}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16, // Augmentation de la taille
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            buildDetailRow(Icons.calendar_today_outlined, 'Date de l\'Absence',
                '${student.date}'),
            const SizedBox(height: 10),
            buildDetailRow(
                Icons.access_time_outlined, 'Horaire Précis', '${student.time}'),
            const SizedBox(height: 10),
            buildDetailRow(Icons.book_outlined, 'Matière', '${student.subject}'),
            const SizedBox(height: 10),
            buildDetailRow(
                Icons.person_outline, 'Enseignant', '${student.teacher}'),
            const Spacer(),
            isJustifying
                ? FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: justificationController,
                            cursorColor: Colors.blue[700],
                            decoration: InputDecoration(
                              hintText: 'Justification',
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 126, 135, 139),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: _isInputEmpty ? Colors.red : Colors.blue.shade700),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: _isInputEmpty ? Colors.red : Colors.blue.shade700),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      IconButton(
                          icon: Icon(Icons.attach_file_outlined,
                          color: Colors.blue[700], size: 26),
                          tooltip: 'Joindre un fichier (ex: Certificat Médical)',
                          onPressed: () async {
                            // Simulate file attachment
                            FilePickerResult? result = await FilePicker.platform.pickFiles();

                            if (result != null) {
                              PlatformFile file = result.files.first;
                              setState(() {
                                _selectedFile = File(file.path!);
                                _fileName = file.name;
                              });
                              print('File attached: ${file.name}');
                              
                              // Display a Toast message
                              Fluttertoast.showToast(
                                msg: "Fichier attaché: ${file.name}",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: const Color.fromARGB(255, 201, 225, 244),
                                textColor: Colors.blueGrey[700],
                                fontSize: 16.0
                              );
                            } else {
                              // User canceled the picker
                              Fluttertoast.showToast(
                                msg: "Aucun fichier sélectionné",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: const Color.fromARGB(255, 255, 121, 111),
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.send,
                              color: Colors.blue[700], size: 26),
                          onPressed: () {
                            // Action pour envoyer la justification
                            print('Justification envoyée : ${justificationController.text}');
                            
                            // check if input is empty
                            if (!justificationController.text.isEmpty) {
                              // Display a Toast message
                              Fluttertoast.showToast(
                                msg: "Justification envoyée",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: const Color.fromARGB(255, 201, 225, 244),
                                textColor: Colors.blueGrey.shade700,
                                fontSize: 16.0
                              );

                              // Clear the input field
                              justificationController.clear();

                              // Show the initial button "Justifier..."
                              setState(() {
                                isJustifying = false;
                                _selectedFile = null;
                                _fileName = null;
                                _animationController.reverse();
                                _isInputEmpty = false;
                              });
                            } else {
                              setState(() {
                                _isInputEmpty = true;
                              });

                              Fluttertoast.showToast(
                                msg: "Veuillez saisir une justification",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 2,
                                backgroundColor: const Color.fromARGB(255, 255, 121, 111),
                                textColor: Colors.white,
                                fontSize: 16.0
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isJustifying = true;
                        _animationController.forward();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Justifier l\'Absence',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFF3F4F9),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 26),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 26),
            label: 'Historique',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, size: 26),
            label: 'Compte',
          ),
        ],
        currentIndex: 1, // Highlight "Historique"
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: const Color.fromARGB(255, 126, 126, 126),
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blueGrey.shade700, size: 24), 
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.blueGrey.shade700,
                fontSize: 18, 
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 16, 
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
