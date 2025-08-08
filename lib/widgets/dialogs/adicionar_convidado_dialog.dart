import 'package:flutter/material.dart';
import '../../models/convidado.dart';

class AdicionarConvidadoDialog extends StatefulWidget {
  @override
  _AdicionarConvidadoDialogState createState() => _AdicionarConvidadoDialogState();
}

class _AdicionarConvidadoDialogState extends State<AdicionarConvidadoDialog> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Novo Convidado'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nomeController,
            decoration: InputDecoration(
              labelText: 'Nome',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
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
            if (_nomeController.text.isNotEmpty && _emailController.text.isNotEmpty) {
              final convidado = Convidado(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nome: _nomeController.text,
                email: _emailController.text,
              );
              Navigator.pop(context, convidado);
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
    _emailController.dispose();
    super.dispose();
  }
}