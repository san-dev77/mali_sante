import 'package:flutter/material.dart';
import 'package:hopitalmap/pages/note/note.dart';

class Centre {
  final String name;
  final String address;
  final double rating;

  Centre({required this.name, required this.address, required this.rating});
}

List<Centre> centres = [
  Centre(name: 'Centre Médical 1', address: '123 Rue de la Santé', rating: 4.5),
  Centre(name: 'Hôpital Général', address: '456 Avenue des Soins', rating: 4.0),
  Centre(
      name: 'Clinique du Bien-être',
      address: '789 Boulevard de la Santé',
      rating: 4.8),
];

class CentresListPage_note extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg3.jpg', // Change this path to your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlay effect
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Liste des Centres',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: centres.length,
                    itemBuilder: (context, index) {
                      final centre = centres[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 16),
                        child: ListTile(
                          title: Text(centre.name),
                          subtitle: Text(centre.address),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NoteAvisPage(),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.white,
      ),
    );
  }
}
