import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  late String _nome;
  late String _email;
  bool _isLoading = false;
  String _error = '';
  
  @override
  void initState() {
    super.initState();
    _nome = _authService.currentUser?.displayName ?? '';
    _email = _authService.currentUser?.email ?? '';
  }
  
  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _error = '';
      });
      
      try {
        await _authService.updateProfile(_nome);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        setState(() {
          _error = 'Erro ao atualizar perfil: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Perfil'),
        backgroundColor: Colors.blue[600],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _authService.currentUser?.photoURL != null
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(_authService.currentUser!.photoURL!),
                      radius: 50,
                    )
                  : CircleAvatar(
                      backgroundColor: Colors.blue[800],
                      radius: 50,
                      child: Text(
                        _nome.isNotEmpty ? _nome[0].toUpperCase() : 'U',
                        style: TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
              ),
              SizedBox(height: 24),
              if (_error.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.only(bottom: 16),
                  color: Colors.red[100],
                  child: Text(
                    _error,
                    style: TextStyle(color: Colors.red[900]),
                  ),
                ),
              Text(
                'Nome',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                initialValue: _nome,
                decoration: InputDecoration(
                  hintText: 'Seu nome completo',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe seu nome';
                  }
                  return null;
                },
                onChanged: (value) => _nome = value,
              ),
              SizedBox(height: 16),
              Text(
                'E-mail',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(
                  hintText: 'Seu e-mail',
                ),
                enabled: false, // E-mail não pode ser alterado
              ),
              SizedBox(height: 24),
              Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _updateProfile,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Text(
                            'Atualizar Perfil',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                        ),
                      ),
              ),
              SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () async {
                    // Mostrar diálogo de confirmação
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Sair da conta'),
                        content: Text('Tem certeza que deseja sair da sua conta?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _authService.signOut();
                              // O AuthWrapper redirecionará automaticamente para a página de login
                            },
                            child: Text('Sair'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'Sair da Conta',
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
