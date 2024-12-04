import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget{
  final Map<String, dynamic> userData; // Tambahkan parameter untuk userData
  Navbar({required this.userData}); // Konstruktor untuk menerima userData
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF162953),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 32),
          child: Row (
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'SIRIS',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

              const SizedBox(width: 8),

                  const Text(
                    'Sistem Informasi Isian Rencana Studi',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              
              // Actions Section
              Row(
                children: _buildButtons(context),
              ),
            ],
          ),
        )
      ),
    );
  }

  List<Widget> _buildButtons(BuildContext context){
    List<Widget> buttons = [];

    // Role based buttons
    if(userData['role'] == 'Mahasiswa'){
      // Button IRS
      buttons.add(_buildMenuItem(Icons.book, 'IRS', onTap: (){
        Navigator.pushNamed(context, '/irs', arguments: userData);
      }));

      // Button Jadwal
      buttons.add(_buildMenuItem(Icons.schedule, 'Jadwal', onTap: (){
        Navigator.pushNamed(context, '/Jadwal', arguments: userData);
      }));
    }
    else if(userData['role'] == 'Dosen'){
      //Button Mhs Wali
      buttons.add(_buildMenuItem(Icons.person, 'Daftar Mahasiswa Perwalian', onTap: (){
        Navigator.pushNamed(context, '/Perwalian', arguments: userData);
      }));
    }

    // Universal Buttons
    buttons.add(_buildMenuItem(Icons.settings, 'Settings', onTap: (){

    }));

    buttons.add(_buildLogoutButton());
    return buttons;
  }

  Widget _buildMenuItem(IconData icon, String label, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize:18)),
          const SizedBox(width: 16),
        ],
      )
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle logout
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      child: const Text('Logout', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}