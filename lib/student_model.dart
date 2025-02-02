import 'dart:math';

class Student {
  final int id;
  final String name;
  final String grade;
  final String subject;
  final String date;
  final String time;
  final String teacher;

  Student({
    required this.id,
    required this.name,
    required this.grade,
    required this.subject,
    required this.date,
    required this.time,
    required this.teacher,
  });

  static Student random() {
    final students = [
      Student(
        id: 2287382,
        name: 'Kaoutar BENNOUR',
        grade: '2ème Année - Lycée',
        subject: 'Mathématiques',
        date: '25 Janvier 2025',
        time: '10h30 - 12h30',
        teacher: 'Mr. IDRISSI Mohammad',
      ),
      Student(
        id: 2287383,
        name: 'Ahmed BENNOUR',
        grade: '3ème Année - Collège',
        subject: 'Sciences de la Vie et de la Terre',
        date: '25 Janvier 2025',
        time: '14h30 - 16h30',
        teacher: 'Mr. ZAHRAOUI Yassine',
      ),
    ];
    return students[Random().nextInt(students.length)];
  }
}

List<Student> students = [
  Student(id: 2287382, name: 'Kaoutar BENNOUR', grade: '2ème Année - Lycée', date: '25 Janvier 2025', time: '10h30 - 12h30', subject: 'Mathématiques', teacher: 'Mr. IDRISSI Mohammad'),
  Student(id: 2287383, name: 'Ahmed BENNOUR', grade: '3ème Année - Collège', date: '25 Janvier 2025', time: '14h30 - 16h30', subject: 'Sciences de la Vie et de la Terre', teacher: 'Mr. ZAHRAOUI Yassine'),
];
