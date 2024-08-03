import 'package:flutter/material.dart';

class NoteAvisPage extends StatefulWidget {
  @override
  _NoteAvisPageState createState() => _NoteAvisPageState();
}

class _NoteAvisPageState extends State<NoteAvisPage> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 0;
  String _comment = '';
  String _previewComment = '';
  double _previewRating = 0;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _previewRating = _rating;
        _previewComment = _comment;
      });
      _showPreviewDialog();
    }
  }

  void _showPreviewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Prévisualisation'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Note: $_previewRating'),
              SizedBox(height: 10),
              Text('Commentaire: $_previewComment'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Modifier'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendFeedback();
              },
              child: Text('Envoyer'),
            ),
          ],
        );
      },
    );
  }

  void _sendFeedback() {
    // Logique pour envoyer les notes et les avis
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Votre avis a été envoyé !'),
        backgroundColor: Colors.green,
      ),
    );
    setState(() {
      _rating = 0;
      _comment = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg1.jpg', // Change this path to your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlay effect
          Positioned.fill(
            child: Container(
              color:
                  Colors.black.withOpacity(0.5), // Change the opacity as needed
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 60), // Espace pour le bouton flottant
                  Text(
                    'Veuillez laisser votre note et votre avis sur le centre',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Text('Note:', style: TextStyle(color: Colors.white)),
                  Slider(
                    value: _rating,
                    onChanged: (newRating) {
                      setState(() => _rating = newRating);
                    },
                    divisions: 5,
                    label: _rating.toString(),
                    min: 0,
                    max: 5,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Votre avis',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un avis';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _comment = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Prévisualiser'),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
