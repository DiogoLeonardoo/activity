import 'package:flutter/material.dart';
import '../../models/convidado.dart';

class ConvidadoCard extends StatelessWidget {
  final Convidado convidado;
  final VoidCallback onDelete;

  const ConvidadoCard({
    Key? key,
    required this.convidado,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.person, color: Colors.blue[600]),
        title: Text(convidado.nome),
        subtitle: Text(convidado.email),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ),
    );
  }
}