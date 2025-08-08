import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Estados de texto
  String email = '';
  String password = '';
  String error = '';
  bool isLoading = false;
  bool isGoogleLoading = false;

  // Método para fazer login
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        error = '';
      });

      try {
        UserCredential? result = await _auth.signInWithEmailAndPassword(email, password);
        if (result != null) {
          // Login bem-sucedido, a navegação será tratada pelo AuthWrapper
          print('Login bem-sucedido para ${result.user?.email}');
          // Mostrar mensagem de sucesso
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login bem-sucedido! Redirecionando...'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
          // Não precisa definir isLoading como false pois vamos navegar para outra tela
        } else {
          setState(() {
            error = 'Email ou senha incorretos';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          String errorMessage = e.toString();
          if (errorMessage.contains('user-not-found')) {
            error = 'Usuário não encontrado';
          } else if (errorMessage.contains('wrong-password')) {
            error = 'Senha incorreta';
          } else if (errorMessage.contains('invalid-email')) {
            error = 'Email inválido';
          } else {
            error = 'Erro ao fazer login: ${e.toString()}';
          }
          isLoading = false;
        });
        print('Erro ao fazer login: $e');
      }
    }
  }

  // Método para login com Google
  Future<void> _signInWithGoogle() async {
    setState(() {
      isGoogleLoading = true;
      error = '';
    });

    try {
      UserCredential? result = await _auth.signInWithGoogle();
      if (result != null) {
        // Login bem-sucedido, a navegação será tratada pelo AuthWrapper
        print('Login com Google bem-sucedido para ${result.user?.email}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login com Google bem-sucedido! Redirecionando...'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        setState(() {
          error = 'Login com Google cancelado';
          isGoogleLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Erro no login com Google: ${e.toString()}';
        isGoogleLoading = false;
      });
      print('Erro no login com Google: $e');
    }
  }
  
  // Widget do botão de login com Google
  Widget _googleSignInButton() {
    return ElevatedButton.icon(
      icon: isGoogleLoading
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2.0,
              ),
            )
          : FaIcon(FontAwesomeIcons.google, color: Colors.white),
      label: Text(
        'Entrar com Google',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        minimumSize: Size(double.infinity, 50),
      ),
      onPressed: isLoading || isGoogleLoading ? null : _signInWithGoogle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login - Gestão Acadêmica'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? 'Digite um email' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (val) => val!.length < 6 ? 'Digite uma senha com pelo menos 6 caracteres' : null,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                child: isLoading 
                  ? SizedBox(
                      height: 20, 
                      width: 20, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.0)
                    )
                  : Text('Entrar'),
                onPressed: isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'OU',
                style: TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16.0),
              _googleSignInButton(),
              SizedBox(height: 12.0),
              TextButton(
                child: Text('Não tem uma conta? Registre-se'),
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
              ),
              SizedBox(height: 12.0),
              TextButton(
                child: Text('Testar Conexão com Firebase'),
                onPressed: () {
                  Navigator.pushNamed(context, '/firebase_test');
                },
              ),
              SizedBox(height: 12.0),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
