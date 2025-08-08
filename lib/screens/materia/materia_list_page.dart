import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/materia.dart';
import '../../services/firestore_service.dart';
import 'materia_detail_page.dart';

class MateriaListPage extends StatefulWidget {
  @override
  _MateriaListPageState createState() => _MateriaListPageState();
}

class _MateriaListPageState extends State<MateriaListPage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matérias'),
      ),
      body: StreamBuilder<List<Materia>>(
        stream: _firestoreService.getMaterias(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar matérias: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Materia> materias = snapshot.data ?? [];

          if (materias.isEmpty) {
            return Center(
              child: Text('Nenhuma matéria encontrada'),
            );
          }

          return ListView.builder(
            itemCount: materias.length,
            itemBuilder: (context, index) {
              Materia materia = materias[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(materia.nome),
                  subtitle: Text(materia.descricao),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _excluirMateria(materia.id),
                  ),
                  onTap: () {
                    _navegarParaMateria(materia);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _adicionarMateria,
      ),
    );
  }
  
  void _navegarParaMateria(Materia materia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MateriaDetailPage(materia: materia),
      ),
    );
  }

  void _excluirMateria(String id) async {
    try {
      await _firestoreService.excluirMateria(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Matéria excluída com sucesso')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir matéria: $e')),
      );
    }
  }

  void _adicionarMateria() {
    TextEditingController nomeController = TextEditingController();
    TextEditingController descricaoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Matéria'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome da Matéria',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Adicionar'),
            onPressed: () async {
              if (nomeController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Nome da matéria não pode estar vazio')),
                );
                return;
              }
              
              // Criar ID único
              String id = FirebaseFirestore.instance.collection('materias').doc().id;
              
              Materia novaMateria = Materia(
                id: id,
                nome: nomeController.text,
                descricao: descricaoController.text,
              );
              
              try {
                await _firestoreService.adicionarMateria(novaMateria);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Matéria adicionada com sucesso')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao adicionar matéria: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
