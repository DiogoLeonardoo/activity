import 'atividade.dart';

class Materia {
  String id;
  String nome;
  String descricao;
  List<Atividade> atividades;

  Materia({
    required this.id,
    required this.nome,
    required this.descricao,
    List<Atividade>? atividades,
  }) : atividades = atividades ?? [];
}