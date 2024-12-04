import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siris/detail_irs_mahasiswa.dart';

class DaftarMahasiswaPerwalianPage extends StatefulWidget {
  final Map<String, dynamic> userData;

  DaftarMahasiswaPerwalianPage({required this.userData});

  @override
  _DaftarMahasiswaPerwalianPageState createState() => _DaftarMahasiswaPerwalianPageState();
}

class _DaftarMahasiswaPerwalianPageState extends State<DaftarMahasiswaPerwalianPage> {
  List<dynamic> mahasiswaList = [];

  @override
  void initState() {
    super.initState();
    fetchMahasiswaPerwalian();
  }

  Future<void> fetchMahasiswaPerwalian() async {
    final nip = widget.userData['identifier']; // Ambil nip dari userData
    final url = 'http://localhost:8080/dosen/$nip/mahasiswa';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        mahasiswaList = json.decode(response.body);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil data mahasiswa')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mahasiswa Perwalian'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text('No')),
              DataColumn(label: Text('Nama')),
              DataColumn(label: Text('NIM')),
              DataColumn(label: Text('Angkatan')),
              DataColumn(label: Text('Aksi')),
            ],
            rows: mahasiswaList.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final mahasiswa = entry.value;
              return DataRow(cells: [
                DataCell(Text(index.toString())),
                DataCell(Text(mahasiswa['nama'])),
                DataCell(Text(mahasiswa['nim'])),
                DataCell(Text(mahasiswa['angkatan'].toString())),
                DataCell(
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IRSDetailPage(
                            mahasiswa: mahasiswa,
                          ),
                        ),
                      );
                    },
                    child: const Text('IRS Detail'),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
    );
  }
}