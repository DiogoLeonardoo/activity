import 'package:flutter/material.dart';
import '../../models/atividade.dart';

class AdicionarAtividadeDialog extends StatefulWidget {
  @override
  _AdicionarAtividadeDialogState createState() => _AdicionarAtividadeDialogState();
}

class _AdicionarAtividadeDialogState extends State<AdicionarAtividadeDialog> {
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  DateTime _dataLimite = DateTime.now().add(Duration(days: 7));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nova Atividade'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: 'Título da Atividade',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Data Limite'),
              subtitle: Text('${_dataLimite.day}/${_dataLimite.month}/${_dataLimite.year}'),
              trailing: Icon(Icons.calendar_today),
              onTap: _selecionarData,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_tituloController.text.isNotEmpty) {
              final atividade = Atividade(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                titulo: _tituloController.text,
                descricao: _descricaoController.text,
                dataLimite: _dataLimite,
              );
              Navigator.pop(context, atividade);
            }
          },
          child: Text('Adicionar'),
        ),
      ],
    );
  }

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dataLimite,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null && picked != _dataLimite) {
      setState(() {
        _dataLimite = picked;
      });
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
}