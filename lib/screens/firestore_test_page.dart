import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/materia.dart';
import '../../services/firestore_service.dart';

class FirestoreTestPage extends StatefulWidget {
  @override
  _FirestoreTestPageState createState() => _FirestoreTestPageState();
}

class _FirestoreTestPageState extends State<FirestoreTestPage> {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  
  String _statusMessage = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  // Método para adicionar uma matéria de teste
  Future<void> _adicionarMateriaTeste() async {
    if (_nomeController.text.isEmpty || _descricaoController.text.isEmpty) {
      setState(() {
        _statusMessage = 'Preencha todos os campos';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Adicionando matéria...';
    });

    try {
      // Criar ID único
      String id = FirebaseFirestore.instance.collection('materias').doc().id;
      
      Materia novaMateria = Materia(
        id: id,
        nome: _nomeController.text,
        descricao: _descricaoController.text,
      );

      await _firestoreService.adicionarMateria(novaMateria);
      
      setState(() {
        _statusMessage = 'Matéria adicionada com sucesso!';
        _nomeController.clear();
        _descricaoController.clear();
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Erro ao adicionar matéria: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste do Firestore'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Adicionar Matéria',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome da Matéria',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _adicionarMateriaTeste,
              child: _isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('Adicionar Matéria de Teste'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
            SizedBox(height: 20),
            Text(
              _statusMessage,
              style: TextStyle(
                color: _statusMessage.contains('Erro')
                    ? Colors.red
                    : (_statusMessage.contains('sucesso')
                        ? Colors.green
                        : Colors.black),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Matérias Cadastradas:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<List<Materia>>(
                stream: _firestoreService.getMaterias(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                        child: Text('Erro ao carregar matérias: ${snapshot.error}'));
                  }

                  List<Materia> materias = snapshot.data ?? [];

                  if (materias.isEmpty) {
                    return Center(child: Text('Nenhuma matéria encontrada'));
                  }

                  return ListView.builder(
                    itemCount: materias.length,
                    itemBuilder: (context, index) {
                      Materia materia = materias[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(materia.nome),
                          subtitle: Text(materia.descricao),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () async {
                              try {
                                await _firestoreService.excluirMateria(materia.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Matéria excluída')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Erro ao excluir: $e')),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
