import 'package:flutter/material.dart';
import '../../models/materia.dart';
import '../../widgets/cards/materia_card.dart';
import '../../widgets/dialogs/adicionar_materia_dialog.dart';
import '../materia/materia_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Materia> materias = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Atividades'),
        backgroundColor: Colors.blue[600],
      ),
      body: materias.isEmpty
          ? _buildEmptyState()
          : _buildMateriasList(),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarMateria,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[600],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Nenhuma matéria cadastrada',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriasList() {
    return ListView.builder(
      itemCount: materias.length,
      itemBuilder: (context, index) {
        final materia = materias[index];
        return MateriaCard(
          materia: materia,
          onTap: () => _navegarParaMateria(materia),
        );
      },
    );
  }

  void _navegarParaMateria(Materia materia) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MateriaDetailPage(materia: materia),
      ),
    ).then((_) => setState(() {}));
  }

  void _adicionarMateria() {
    showDialog(
      context: context,
      builder: (context) => AdicionarMateriaDialog(),
    ).then((materia) {
      if (materia != null) {
        setState(() {
          materias.add(materia);
        });
      }
    });
  }
}