import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:siris/navbar.dart';
import 'package:siris/class/JadwalIRS.dart';
import 'package:logging/logging.dart';

final loggerIRS = Logger('IRSPageState');

class IRSPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const IRSPage({super.key, required this.userData});


  @override
  IRSPageState createState() => IRSPageState();
}


class IRSPageState extends State<IRSPage> {  
  List<JadwalIRS> jadwalIRS = [];
  int? selectedSemester;
  
  late int semester;
  
  get userData => widget.userData;

  @override
  void initState() {
    super.initState();

    // Set semester default, misalnya dari userData["semester"]
    selectedSemester = userData["semester"];
    fetchIRSJadwal(selectedSemester!);

  }
  Future<void> fetchIRSJadwal(int semester) async {
    final nim = widget.userData["identifier"];
    final url = 'http://localhost:8080/mahasiswa/$nim/jadwal-irs?semester=$semester';
    loggerIRS.info('Fetching jadwal for semester: $semester at URL: $url');

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        jadwalIRS = data.map((item) => JadwalIRS.fromJson(item)).toList();
      });
    } else {
      // Handle error
      Map<String, dynamic> e = json.decode(response.body);
      loggerIRS.severe('Status Code: ${response.statusCode}, Error Message: ${e['message']}');
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengambil data jadwal IRS')),
        );
      }
    }
  }

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    home: Scaffold(
      appBar: Navbar(userData: userData),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  margin: const EdgeInsets.only(top: 32),
                  child: const Text(
                    'Isian Rencana Studi',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                // Dropdown and Button Row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _DropdownSelection(
                        currentSemester: widget.userData["semester"],
                        onSemesterChanged: (int semester) {
                          setState(() {
                            selectedSemester = semester;
                          });
                          fetchIRSJadwal(semester);
                        },
                      ),
                      _buildEditButton()
                    ],
                  ),
                ),
                // Table with horizontal scrolling
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: constraints.maxWidth),
                      child: DataTable(
                        columnSpacing: 16.0,
                        headingRowColor: MaterialStateProperty.resolveWith(
                          (states) => const Color(0xFF162953),
                        ),
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Kode MK',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nama MK',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Ruangan',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Hari',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jam Mulai',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Jam Selesai',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Kelas',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'SKS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Dosen Pengampu',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                        rows: jadwalIRS.map((jadwal) {
                          return DataRow(cells: [
                            DataCell(Text('${jadwal.KodeMK} - ${jadwal.NamaMK}')),
                            DataCell(Text(jadwal.NamaMK)),
                            DataCell(Text(jadwal.Ruangan)),
                            DataCell(Text(jadwal.Hari)),
                            DataCell(Text(jadwal.JamMulai)),
                            DataCell(Text(jadwal.JamSelesai)),
                            DataCell(Text(jadwal.Kelas)),
                            DataCell(Text(jadwal.SKS.toString())),
                            DataCell(Text(jadwal.DosenPengampu.join(", "))),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

}


  

  Widget _buildEditButton(){
    return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24), // Rounded edges
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onPressed: () {
              // Add button action here
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min, // Keeps the button compact
              children: [
                Icon(
                  Icons.edit, // Edit icon
                  color: Colors.white,
                ),
                SizedBox(width: 8), // Space between icon and text
                Text(
                  'Edit IRS',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
  }

class _DropdownSelection extends StatefulWidget {
  final int currentSemester;
  final Function(int) onSemesterChanged;

  const _DropdownSelection({required this.currentSemester, required this.onSemesterChanged});

  @override
  _DropdownSelectionState createState() => _DropdownSelectionState();
}

class _DropdownSelectionState extends State<_DropdownSelection> {
  // Define a list of options
  late List<int> semesterItems;
  int? selectedSemester;

  @override
  void initState() {
    super.initState();
    selectedSemester = widget.currentSemester;
    semesterItems = List<int>.generate(widget.currentSemester, (index) => index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedSemester,
      hint: const Text('Pilih Semester'),
      isExpanded: false,
      menuWidth: 240,
      icon: const Icon(Icons.arrow_drop_down),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      items: semesterItems.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text('Semester $value'),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          selectedSemester = newValue;
        });
        widget.onSemesterChanged(newValue!);
      },
    );
  }
}