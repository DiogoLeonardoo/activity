import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseDebugPage extends StatefulWidget {
  @override
  _FirebaseDebugPageState createState() => _FirebaseDebugPageState();
}

class _FirebaseDebugPageState extends State<FirebaseDebugPage> {
  String _status = "Aguardando...";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFirebaseConnection();
  }

  Future<void> _checkFirebaseConnection() async {
    setState(() {
      _isLoading = true;
      _status = "Verificando conexão com Firebase...";
    });

    try {
      // Verificar se o Firebase está inicializado
      bool isInitialized = Firebase.apps.isNotEmpty;
      _addStatus("Firebase inicializado: $isInitialized");
      
      if (!isInitialized) {
        _addStatus("ERRO: Firebase não está inicializado!");
        return;
      }

      // Verificar app
      _addStatus("Firebase app name: ${Firebase.app().name}");
      _addStatus("Firebase options: ${Firebase.app().options.projectId}");
      
      // Testar escrita
      await _testWriteToFirestore();
      
      // Testar leitura
      await _testReadFromFirestore();

    } catch (e) {
      _addStatus("ERRO durante a verificação: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _testWriteToFirestore() async {
    _addStatus("Testando escrita no Firestore...");
    try {
      // Criar uma coleção de testes
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('testes')
          .add({
            'teste': true,
            'timestamp': FieldValue.serverTimestamp(),
            'mensagem': 'Teste de conexão em ${DateTime.now().toIso8601String()}'
          });
      
      _addStatus("✅ Documento criado com sucesso! ID: ${docRef.id}");
    } catch (e) {
      _addStatus("❌ ERRO na escrita: $e");
    }
  }

  Future<void> _testReadFromFirestore() async {
    _addStatus("Testando leitura no Firestore...");
    try {
      // Ler a coleção de testes
      QuerySnapshot snapshot = 
          await FirebaseFirestore.instance.collection('testes').limit(5).get();
      
      _addStatus("✅ Leitura bem-sucedida! Documentos: ${snapshot.docs.length}");
      
      for (var doc in snapshot.docs) {
        _addStatus(" - Doc ${doc.id}: ${doc.data()}");
      }
    } catch (e) {
      _addStatus("❌ ERRO na leitura: $e");
    }
  }

  void _addStatus(String message) {
    print(message);
    setState(() {
      _status += "\n$message";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagnóstico do Firebase'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Status da Conexão',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    if (_isLoading) LinearProgressIndicator(),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      height: 300,
                      child: SingleChildScrollView(
                        child: Text(
                          _status,
                          style: TextStyle(
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Verificar Novamente'),
              onPressed: _checkFirebaseConnection,
            ),
            SizedBox(height: 8),
            ElevatedButton(
              child: Text('Tentar Adicionar Matéria Diretamente'),
              onPressed: _tentarAdicionarMateria,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _tentarAdicionarMateria() async {
    setState(() {
      _isLoading = true;
      _addStatus("\nTentando adicionar matéria diretamente...");
    });

    try {
      // Criar uma matéria diretamente sem usar o service
      String id = FirebaseFirestore.instance.collection('materias').doc().id;
      
      await FirebaseFirestore.instance.collection('materias').doc(id).set({
        'nome': 'Teste Direto ${DateTime.now().second}',
        'descricao': 'Matéria de teste criada em ${DateTime.now().toIso8601String()}',
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      _addStatus("✅ Matéria criada com sucesso! ID: $id");
    } catch (e) {
      _addStatus("❌ ERRO ao criar matéria: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
