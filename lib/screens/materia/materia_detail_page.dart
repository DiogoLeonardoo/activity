import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/materia.dart';
import '../../models/atividade.dart';
import '../../services/firestore_service.dart';
import '../atividade/atividade_detail_page.dart';

class MateriaDetailPage extends StatefulWidget {
  final Materia materia;

  const MateriaDetailPage({Key? key, required this.materia}) : super(key: key);

  @override
  _MateriaDetailPageState createState() => _MateriaDetailPageState();
}

class _MateriaDetailPageState extends State<MateriaDetailPage> {
  final FirestoreService _firestoreService = FirestoreService();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.materia.nome),
        backgroundColor: Colors.blue[600],
      ),
      body: StreamBuilder<List<Atividade>>(
        stream: _firestoreService.getAtividades(widget.materia.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar atividades: ${snapshot.error}'));
          }
          
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          
          List<Atividade> atividades = snapshot.data ?? [];
          
          if (atividades.isEmpty) {
            return _buildEmptyState();
          }
          
          return _buildAtividadesList(atividades);
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _adicionarAtividade,
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
          Icon(Icons.assignment, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'Nenhuma atividade cadastrada',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildAtividadesList(List<Atividade> atividades) {
    return ListView.builder(
      itemCount: atividades.length,
      itemBuilder: (context, index) {
        final atividade = atividades[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(atividade.titulo),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(atividade.descricao),
                SizedBox(height: 4),
                Text(
                  'Data limite: ${_formatDate(atividade.dataLimite)}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    atividade.status == StatusAtividade.concluido
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    color: atividade.status == StatusAtividade.concluido
                        ? Colors.green
                        : Colors.grey,
                  ),
                  onPressed: () => _toggleStatus(atividade),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _excluirAtividade(atividade.id),
                ),
              ],
            ),
            onTap: () => _navegarParaAtividade(atividade),
          ),
        );
      },
    );
  }
  
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _navegarParaAtividade(Atividade atividade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AtividadeDetailPage(atividade: atividade),
      ),
    );
  }

  Future<void> _toggleStatus(Atividade atividade) async {
    StatusAtividade novoStatus = atividade.status == StatusAtividade.pendente
        ? StatusAtividade.concluido
        : StatusAtividade.pendente;
    
    try {
      // Criar uma cópia da atividade com o status atualizado
      Atividade atividadeAtualizada = Atividade(
        id: atividade.id,
        titulo: atividade.titulo,
        descricao: atividade.descricao,
        dataLimite: atividade.dataLimite,
        status: novoStatus,
      );
      
      await _firestoreService.atualizarAtividade(
        widget.materia.id, 
        atividadeAtualizada
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status atualizado')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar status: $e')),
      );
    }
  }

  Future<void> _excluirAtividade(String atividadeId) async {
    try {
      await _firestoreService.excluirAtividade(
        widget.materia.id, 
        atividadeId
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Atividade excluída')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao excluir atividade: $e')),
      );
    }
  }

  void _adicionarAtividade() {
    TextEditingController tituloController = TextEditingController();
    TextEditingController descricaoController = TextEditingController();
    DateTime dataLimite = DateTime.now().add(Duration(days: 7));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Adicionar Atividade'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tituloController,
                decoration: InputDecoration(
                  labelText: 'Título da Atividade',
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
              SizedBox(height: 16),
              ListTile(
                title: Text('Data Limite'),
                subtitle: Text('${dataLimite.day}/${dataLimite.month}/${dataLimite.year}'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dataLimite,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dataLimite = pickedDate;
                    });
                  }
                },
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
              if (tituloController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Título da atividade não pode estar vazio')),
                );
                return;
              }
              
              // Criar ID único
              String id = FirebaseFirestore.instance
                  .collection('materias')
                  .doc(widget.materia.id)
                  .collection('atividades')
                  .doc()
                  .id;
              
              Atividade novaAtividade = Atividade(
                id: id,
                titulo: tituloController.text,
                descricao: descricaoController.text,
                dataLimite: dataLimite,
                status: StatusAtividade.pendente,
              );
              
              try {
                await _firestoreService.adicionarAtividade(
                  widget.materia.id, 
                  novaAtividade
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Atividade adicionada com sucesso')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao adicionar atividade: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}