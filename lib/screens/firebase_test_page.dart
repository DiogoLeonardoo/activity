import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/firebase_config.dart';

class FirebaseTestPage extends StatefulWidget {
  @override
  _FirebaseTestPageState createState() => _FirebaseTestPageState();
}

class _FirebaseTestPageState extends State<FirebaseTestPage> {
  String _status = 'Testando conexão com o Firebase...';
  String _error = '';
  bool _testingAuth = false;
  bool _testingFirestore = false;

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    try {
      // Testar configuração
      setState(() {
        _status = 'Verificando configuração do Firebase...';
      });

      final firebaseConfig = FirebaseConfig.currentPlatformOptions;
      setState(() {
        _status = 'Configuração carregada: ${firebaseConfig.projectId}';
      });

      await _testAuth();
      await _testFirestore();
      
      setState(() {
        _status = 'Firebase conectado com sucesso!';
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao conectar com o Firebase: ${e.toString()}';
        _status = 'Falha ao conectar com o Firebase';
      });
    }
  }

  Future<void> _testAuth() async {
    setState(() {
      _testingAuth = true;
      _status = 'Testando Firebase Authentication...';
    });

    try {
      // Tenta pegar o usuário atual - isso deve funcionar mesmo sem login
      final currentUser = FirebaseAuth.instance.currentUser;
      setState(() {
        _status = 'Firebase Authentication OK. Usuário: ${currentUser?.email ?? 'Nenhum'}';
      });
    } catch (e) {
      setState(() {
        _error = 'Erro no Firebase Authentication: ${e.toString()}';
      });
      throw e;
    } finally {
      setState(() {
        _testingAuth = false;
      });
    }
  }

  Future<void> _testFirestore() async {
    setState(() {
      _testingFirestore = true;
      _status = 'Testando Firebase Firestore...';
    });

    try {
      // Tenta fazer uma leitura simples
      await FirebaseFirestore.instance.collection('_test_collection').get();
      setState(() {
        _status = 'Firebase Firestore OK';
      });
    } catch (e) {
      setState(() {
        _error = 'Erro no Firebase Firestore: ${e.toString()}';
      });
      throw e;
    } finally {
      setState(() {
        _testingFirestore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste de Conexão Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(_status),
                    if (_testingAuth || _testingFirestore)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    if (_error.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.red.shade100,
                          child: Text(
                            _error,
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _testFirebaseConnection,
              child: Text('Testar Novamente'),
            ),
            SizedBox(height: 24),
            Text(
              'Configuração Firebase:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('API Key: ${FirebaseConfig.currentPlatformOptions.apiKey}'),
                    SizedBox(height: 4),
                    Text('Project ID: ${FirebaseConfig.currentPlatformOptions.projectId}'),
                    SizedBox(height: 4),
                    Text('App ID: ${FirebaseConfig.currentPlatformOptions.appId}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
