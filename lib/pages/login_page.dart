import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Variables pour la validation
  bool _isUsernameValid = true;
  bool _isPasswordValid = true;

  // Méthode de connexion
  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    // Réinitialiser les validations
    setState(() {
      _isUsernameValid = username.isNotEmpty;
      _isPasswordValid = password.isNotEmpty;
    });

    // Si l'un des champs est vide, on ne continue pas
    if (username.isEmpty || password.isEmpty) {
      return; // Ne pas continuer si l'un des champs est vide
    }

    setState(() {
      _isLoading = true; // Afficher l'indicateur de chargement
    });

    try {
      final authService = AuthService();
      final user = await authService.login(username, password);

      setState(() {
        _isLoading = false; // Masquer l'indicateur de chargement
      });

      if (user != null) {
        // Rediriger en fonction du rôle de l'utilisateur
        if (user.role == 'admin') {
          Navigator.pushReplacementNamed(context, '/adminHome',
              arguments: user);
        } else {
          Navigator.pushReplacementNamed(context, '/userHome', arguments: user);
        }
      } else {
        // Si le login échoue, marquer les champs comme invalides
        setState(() {
          _isUsernameValid = false;
          _isPasswordValid = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog(
          'Erreur lors de la connexion. Veuillez réessayer plus tard.');
    }
  }

  // Affichage du message d'erreur
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page de Connexion'),
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
                      'Bienvenue',
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
                        errorText: _isUsernameValid
                            ? null
                            : 'Nom d\'utilisateur incorrect',
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
                            _isPasswordValid ? null : 'Mot de passe incorrect',
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
                        ? Center(
                            child:
                                CircularProgressIndicator()) // Affichage du loader
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors
                                  .deepPurple, // Couleur de fond du bouton
                              minimumSize: Size(double.infinity, 50),
                            ),
                            onPressed: _login,
                            child: Text(
                              'Se connecter',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Couleur du texte
                              ),
                            ),
                          ),
                    SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Rediriger vers la page d'inscription
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text(
                        'Créer un compte',
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
