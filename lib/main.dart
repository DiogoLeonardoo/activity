import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/home/home_page.dart';
import 'screens/materia/materia_list_page.dart';
import 'screens/auth/login_page.dart';
import 'screens/auth/register_page.dart';
import 'screens/auth/profile_page.dart';
import 'screens/firebase_debug_page.dart';
import 'screens/firebase_test_page.dart';
import 'services/auth_service.dart';
import 'services/auth_wrapper.dart';
import 'config/firebase_config.dart';

Future<void> main() async {
  // Garante que o widget binding seja inicializado
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializa o Firebase com configuração específica para a plataforma
  try {
    await Firebase.initializeApp(
      options: FirebaseConfig.currentPlatformOptions,
    );
    print('Firebase inicializado com sucesso');
  } catch (e) {
    print('Erro ao inicializar o Firebase: $e');
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService().user,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Gerenciador de Atividades',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => AuthWrapper(),
          '/home': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/profile': (context) => ProfilePage(),
          '/materias': (context) => MateriaListPage(),
          '/debug': (context) => FirebaseDebugPage(),
          '/firebase_test': (context) => FirebaseTestPage(),
        },
      ),
    );
  }
}