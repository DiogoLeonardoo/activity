import 'package:flutter/material.dart';
import '../../models/atividade.dart';
import '../../models/convidado.dart';
import '../../widgets/cards/convidado_card.dart';
import '../../widgets/dialogs/adicionar_convidado_dialog.dart';
import '../../utils/date_formatter.dart';

class AtividadeDetailPage extends StatefulWidget {
  final Atividade atividade;

  const AtividadeDetailPage({Key? key, required this.atividade}) : super(key: key);

  @override
  _AtividadeDetailPageState createState() => _AtividadeDetailPageState();
}

class _AtividadeDetailPageState extends State<AtividadeDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.atividade.titulo),
        backgroundColor: Colors.blue[600],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAtividadeInfo(),
            SizedBox(height: 16),
            _buildConvidadosHeader(),
            SizedBox(height: 8),
            Expanded(child: _buildConvidadosList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAtividadeInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Descrição:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(widget.atividade.descricao),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.schedule, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  'Prazo: ${DateFormatter.formatarData(widget.atividade.dataLimite)}',
                  style: TextStyle(
                    color: DateFormatter.isAtrasada(widget.atividade.dataLimite) 
                        ? Colors.red 
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  widget.atividade.status == StatusAtividade.concluido
                      ? Icons.check_circle
                      : Icons.schedule,
                  color: widget.atividade.status == StatusAtividade.concluido
                      ? Colors.green
                      : Colors.orange,
                ),
                SizedBox(width: 8),
                Text(
                  'Status: ${widget.atividade.status == StatusAtividade.concluido ? 'Concluído' : 'Pendente'}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConvidadosHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Convidados (${widget.atividade.convidados.length})',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        ElevatedButton(
          onPressed: _adicionarConvidado,
          child: Text('Adicionar'),
        ),
      ],
    );
  }

  Widget _buildConvidadosList() {
    if (widget.atividade.convidados.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 60, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Nenhum convidado adicionado',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: widget.atividade.convidados.length,
      itemBuilder: (context, index) {
        final convidado = widget.atividade.convidados[index];
        return ConvidadoCard(
          convidado: convidado,
          onDelete: () => _excluirConvidado(convidado),
        );
      },
    );
  }

  void _excluirConvidado(Convidado convidado) {
    setState(() {
      widget.atividade.convidados.remove(convidado);
    });
  }

  void _adicionarConvidado() {
    showDialog(
      context: context,
      builder: (context) => AdicionarConvidadoDialog(),
    ).then((convidado) {
      if (convidado != null) {
        setState(() {
          widget.atividade.convidados.add(convidado);
        });
      }
    });
  }
}