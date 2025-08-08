import 'package:flutter/material.dart';
import '../../models/materia.dart';

class MateriaCard extends StatelessWidget {
  final Materia materia;
  final VoidCallback onTap;

  const MateriaCard({
    Key? key,
    required this.materia,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: Icon(Icons.book, color: Colors.blue[600]),
        title: Text(materia.nome),
        subtitle: Text(materia.descricao),
        trailing: Text('${materia.atividades.length} atividades'),
        onTap: onTap,
      ),
    );
  }
}