import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../screens/home/home_page.dart';
import '../screens/auth/login_page.dart';
import '../services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService().user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          
          if (user == null) {
            // Usuário não autenticado, redirecionar para login
            return LoginPage();
          } else {
            // Usuário autenticado, redirecionar para home
            return HomePage();
          }
        } else {
          // Aguardando conexão
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
