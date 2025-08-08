import 'package:flutter/material.dart';
import '../../models/materia.dart';
import '../../services/firestore_service.dart';
import '../../services/auth_service.dart';
import '../materia/materia_list_page.dart';
import '../materia/materia_detail_page.dart';
import 'user_profile_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Atividades'),
        backgroundColor: Colors.blue[600],
        actions: [
          IconButton(
            icon: Icon(Icons.school),
            tooltip: 'Matérias',
            onPressed: () {
              Navigator.pushNamed(context, '/materias');
            },
          ),
          IconButton(
            icon: Icon(Icons.bug_report),
            tooltip: 'Firebase Debug',
            onPressed: () {
              Navigator.pushNamed(context, '/debug');
            },
          ),
          IconButton(
            icon: Icon(Icons.wifi_tethering),
            tooltip: 'Testar Firebase',
            onPressed: () {
              Navigator.pushNamed(context, '/firebase_test');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Widget do perfil do usuário
          UserProfileWidget(),
          // Lista de matérias
          Expanded(
            child: StreamBuilder<List<Materia>>(
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
                  return _buildEmptyState();
                }
                
                return _buildMateriasList(materias);
              },
            ),
          ),
        ],
      ),
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

  Widget _buildMateriasList(List<Materia> materias) {
    return ListView.builder(
      itemCount: materias.length,
      itemBuilder: (context, index) {
        final materia = materias[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            title: Text(materia.nome),
            subtitle: Text(materia.descricao),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => _navegarParaMateria(materia),
          ),
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
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => MateriaListPage(),
      )
    );
  }
}