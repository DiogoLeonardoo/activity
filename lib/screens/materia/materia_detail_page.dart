import 'package:flutter/material.dart';
import '../../models/materia.dart';
import '../../models/atividade.dart';
import '../../widgets/cards/atividade_card.dart';
import '../../widgets/dialogs/adicionar_atividade_dialog.dart';
import '../atividade/atividade_detail_page.dart';

class MateriaDetailPage extends StatefulWidget {
  final Materia materia;

  const MateriaDetailPage({Key? key, required this.materia}) : super(key: key);

  @override
  _MateriaDetailPageState createState() => _MateriaDetailPageState();
}

class _MateriaDetailPageState extends State<MateriaDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.materia.nome),
        backgroundColor: Colors.blue[600],
      ),
      body: widget.materia.atividades.isEmpty
          ? _buildEmptyState()
          : _buildAtividadesList(),
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

  Widget _buildAtividadesList() {
    return ListView.builder(
      itemCount: widget.materia.atividades.length,
      itemBuilder: (context, index) {
        final atividade = widget.materia.atividades[index];
        return AtividadeCard(
          atividade: atividade,
          onTap: () => _navegarParaAtividade(atividade),
          onToggleStatus: () => _toggleStatus(atividade),
          onDelete: () => _excluirAtividade(atividade),
        );
      },
    );
  }

  void _navegarParaAtividade(Atividade atividade) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AtividadeDetailPage(atividade: atividade),
      ),
    ).then((_) => setState(() {}));
  }

  void _toggleStatus(Atividade atividade) {
    setState(() {
      atividade.status = atividade.status == StatusAtividade.pendente
          ? StatusAtividade.concluido
          : StatusAtividade.pendente;
    });
  }

  void _excluirAtividade(Atividade atividade) {
    setState(() {
      widget.materia.atividades.remove(atividade);
    });
  }

  void _adicionarAtividade() {
    showDialog(
      context: context,
      builder: (context) => AdicionarAtividadeDialog(),
    ).then((atividade) {
      if (atividade != null) {
        setState(() {
          widget.materia.atividades.add(atividade);
        });
      }
    });
  }
}