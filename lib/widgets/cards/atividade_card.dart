import 'package:flutter/material.dart';
import '../../models/atividade.dart';
import '../../utils/date_formatter.dart';

class AtividadeCard extends StatelessWidget {
  final Atividade atividade;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;
  final VoidCallback onDelete;

  const AtividadeCard({
    Key? key,
    required this.atividade,
    required this.onTap,
    required this.onToggleStatus,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(
          atividade.status == StatusAtividade.concluido
              ? Icons.check_circle
              : Icons.schedule,
          color: atividade.status == StatusAtividade.concluido
              ? Colors.green
              : Colors.orange,
        ),
        title: Text(atividade.titulo),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(atividade.descricao),
            SizedBox(height: 4),
            Text(
              'Prazo: ${DateFormatter.formatarData(atividade.dataLimite)}',
              style: TextStyle(
                color: DateFormatter.isAtrasada(atividade.dataLimite) ? Colors.red : null,
              ),
            ),
            if (atividade.convidados.isNotEmpty)
              Text('${atividade.convidados.length} convidados'),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'toggle_status') {
              onToggleStatus();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'toggle_status',
              child: Text(
                atividade.status == StatusAtividade.pendente
                    ? 'Marcar como Concluído'
                    : 'Marcar como Pendente',
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Excluir'),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}