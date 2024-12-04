import 'package:flutter/material.dart';
import '../services/auth_service.dart'; // Le service pour gérer l'inscription.

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  // Variables pour validation
  bool _isPasswordValid = true;

  // Méthode pour s'inscrire
  Future<void> _register() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    setState(() {
      _isPasswordValid = password.length >= 6;
    });

    if (username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog('Tous les champs sont requis');
      return;
    }

    if (!_isPasswordValid) {
      _showErrorDialog('Le mot de passe doit contenir au moins 6 caractères');
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog('Les mots de passe ne correspondent pas');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authService = AuthService();
      final success = await authService.register(username, password);

      setState(() {
        _isLoading = false;
      });

      if (success) {
        _showSuccessDialog('Compte créé avec succès !');
      } else {
        _showErrorDialog('Erreur lors de l\'inscription');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Erreur lors de l\'inscription. Veuillez réessayer.');
    }
  }

  // Affichage des messages d'erreur
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Affichage du message de succès
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Succès'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context); // Fermer le dialogue
              Navigator.pop(context); // Retourner à la page de connexion
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
        backgroundColor: Colors.deepPurple, // Couleur personnalisée de l'AppBar
        elevation: 0, // Enlever l'ombre
      ),
      body: Center(
        child: SingleChildScrollView(
          // Permet de faire défiler si le clavier apparaît
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8, // Ombre autour de la carte
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Coins arrondis
              ),
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Créer un compte',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nom d\'utilisateur',
                        hintText: 'Entrez votre nom d\'utilisateur',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        hintText: 'Entrez votre mot de passe',
                        prefixIcon: Icon(Icons.lock),
                        errorText:
                            _isPasswordValid ? null : 'Au moins 6 caractères',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _isPasswordValid = value.length >= 6;
                        });
                      },
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        hintText: 'Confirmez votre mot de passe',
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.deepPurple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.deepPurple, width: 2),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor:
                                  Colors.deepPurple, // Couleur du bouton
                              minimumSize: Size(double.infinity, 50),
                            ),
                            onPressed: _register,
                            child: Text(
                              'S\'inscrire',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors.white, // Couleur du texte en blanc
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Rediriger vers la page de connexion
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Déjà un compte ? Se connecter',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
