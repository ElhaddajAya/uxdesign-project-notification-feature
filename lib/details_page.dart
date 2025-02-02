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
  File? _selectedFile;
  String? _fileName;
  
  // Variables pour l'aperçu
  Widget? _filePreview;
  bool _isImage = false;

  late Student student;

  @override
  void initState() {
    super.initState();
    // Charger les données de l'étudiant en fonction de l'ID
    student = students.firstWhere((student) => student.id == widget.studentId);

    // Initialisation de l'animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _animationController.dispose();
    justificationController.dispose();
    super.dispose();
  }

  // Méthode pour gérer la sélection et l'aperçu du fichier
  Future<void> _handleFileSelection() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.first.path!);
        _fileName = result.files.first.name;
        
        // Vérifier si c'est une image
        _isImage = ['jpg', 'jpeg', 'png'].contains(
          result.files.first.extension?.toLowerCase()
        );

        // Créer l'aperçu
        if (_isImage) {
          _filePreview = Container(
            height: 190,
            // width: 190,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                _selectedFile!,
                fit: BoxFit.cover,
              ),
            ),
          );
        } else {
          _filePreview = Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  result.files.first.extension?.toLowerCase() == 'pdf' 
                    ? Icons.picture_as_pdf 
                    : Icons.insert_drive_file,
                  color: Colors.blue[700],
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _fileName!,
                    style: TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, size: 16),
                  onPressed: () {
                    setState(() {
                      _selectedFile = null;
                      _fileName = null;
                      _filePreview = null;
                    });
                  },
                ),
              ],
            ),
          );
        }
      });

      Fluttertoast.showToast(
        msg: "Fichier attaché: ${result.files.first.name}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: const Color.fromARGB(255, 201, 225, 244),
        textColor: Colors.blueGrey[700],
        fontSize: 16.0
      );
    } else {
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
  }

  Widget _buildInputSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
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
                    vertical: 12, horizontal: 16
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.attach_file_outlined,
                color: Colors.blue[700], size: 26),
              tooltip: 'Joindre un fichier (ex: Certificat Médical)',
              onPressed: _handleFileSelection,
            ),
            IconButton(
              icon: Icon(Icons.send, color: Colors.blue[700], size: 26),
              onPressed: () {
                if (justificationController.text.isEmpty && _selectedFile == null) {
                  setState(() {
                    _isInputEmpty = true;
                  });
                  Fluttertoast.showToast(
                    msg: "Veuillez saisir une justification ou joindre un fichier",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: const Color.fromARGB(255, 255, 121, 111),
                    textColor: Colors.white,
                    fontSize: 16.0
                  );
                } else {
                  print('Justification envoyée : ${justificationController.text}');
                  if (_selectedFile != null) {
                    print('Fichier envoyé : $_fileName');
                  }

                  Fluttertoast.showToast(
                    msg: "Justification envoyée",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: const Color.fromARGB(255, 201, 225, 244),
                    textColor: Colors.blueGrey.shade700,
                    fontSize: 16.0
                  );

                  justificationController.clear();
                  setState(() {
                    isJustifying = false;
                    _selectedFile = null;
                    _fileName = null;
                    _filePreview = null;
                    _animationController.reverse();
                    _isInputEmpty = false;
                  });
                }
              },
            ),
          ],
        ),
        if (_filePreview != null) ...[
          SizedBox(height: 8),
          _filePreview!,
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          'Détails de l\'Absence',
          style: TextStyle(
            fontSize: 18,
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
                  radius: 35,
                  backgroundColor: Color.fromARGB(255, 207, 234, 255),
                  child: Icon(
                    Icons.person,
                    size: 50,
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
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '${student.name}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                    Text(
                      '${student.grade}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
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
                    child: _buildInputSection(),
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
        currentIndex: 1,
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