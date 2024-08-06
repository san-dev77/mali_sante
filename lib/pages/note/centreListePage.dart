import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hopitalmap/centre_api.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hopitalmap/pages/note/note.dart';

class CentresListPage_note extends StatefulWidget {
  @override
  _CentresListPage_noteState createState() => _CentresListPage_noteState();
}

class _CentresListPage_noteState extends State<CentresListPage_note> {
  late Future<List<Etablissement>> futureEtablissements;

  @override
  void initState() {
    super.initState();
    futureEtablissements = fetchEtablissements();
  }

  Future<List<Etablissement>> fetchEtablissements() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.43.18:8000/api/etablissement'));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> etablissementsJson = jsonResponse['items'];
        return etablissementsJson
            .map((etablissement) => Etablissement.fromJson(etablissement))
            .toList();
      } else {
        print(
            'Failed to load centres: ${response.statusCode} ${response.reasonPhrase}');
        throw Exception('Failed to load centres');
      }
    } catch (e) {
      print('Failed to load centres: $e');
      throw Exception('Failed to load centres: $e');
    }
  }

  void _showContactOptions(Etablissement etablissement) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Contact ${etablissement.nom}"),
          content: Text("Choisissez une option pour contacter le centre."),
          actions: <Widget>[
            TextButton(
              child: Text("Appeler"),
              onPressed: () {
                Navigator.of(context).pop();
                _makePhoneCall(etablissement.telephone);
              },
            ),
            TextButton(
              child: Text("Envoyer un e-mail"),
              onPressed: () {
                Navigator.of(context).pop();
                _sendEmail(etablissement.email);
              },
            ),
            TextButton(
              child: Text("Annuler"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  Future<void> _sendEmail(String emailAddress) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
    );
    await launch(launchUri.toString());
  }

  Widget _buildPlaceCard(Etablissement etablissement) {
    return GestureDetector(
      onTap: () => _showContactOptions(etablissement),
      child: Card(
        color: Colors.white,
        elevation: 5,
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                etablissement.nom,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 5),
                  Text(
                    etablissement.localite,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.green),
                  SizedBox(width: 5),
                  Text(
                    etablissement.telephone,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 5),
                  Text(
                    etablissement.email,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    icon: Icon(Icons.rate_review, color: Colors.white),
                    label: Text(
                      'Laisser une note',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteAvisPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Liste des Centres'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                Expanded(
                  child: FutureBuilder<List<Etablissement>>(
                    future: futureEtablissements,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text(
                                'Failed to load centres: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No centres available'));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final etablissement = snapshot.data![index];
                            return _buildPlaceCard(etablissement);
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
