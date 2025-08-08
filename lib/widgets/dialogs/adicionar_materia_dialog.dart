import 'package:flutter/material.dart';
import '../../models/materia.dart';

class AdicionarMateriaDialog extends StatefulWidget {
  @override
  _AdicionarMateriaDialogState createState() => _AdicionarMateriaDialogState();
}

class _AdicionarMateriaDialogState extends State<AdicionarMateriaDialog> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nova Matéria'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nomeController,
            decoration: InputDecoration(
              labelText: 'Nome da Matéria',
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
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nomeController.text.isNotEmpty) {
              final materia = Materia(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nome: _nomeController.text,
                descricao: _descricaoController.text,
              );
              Navigator.pop(context, materia);
            }
          },
          child: Text('Adicionar'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }
}