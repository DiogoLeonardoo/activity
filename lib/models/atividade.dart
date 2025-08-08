import 'convidado.dart';

enum StatusAtividade { pendente, concluido }

class Atividade {
  String id;
  String titulo;
  String descricao;
  DateTime dataLimite;
  StatusAtividade status;
  List<Convidado> convidados;

  Atividade({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.dataLimite,
    this.status = StatusAtividade.pendente,
    List<Convidado>? convidados,
  }) : convidados = convidados ?? [];
}