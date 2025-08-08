import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/materia.dart';
import '../models/atividade.dart';
import '../models/convidado.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Obter ID do usuário atual
  String? get _userId => _auth.currentUser?.uid;
  
  // Verificar se o usuário está autenticado
  bool get _isAuthenticated => _auth.currentUser != null;
  
  // Referência para a coleção de matérias do usuário atual
  CollectionReference get materiasCollection {
    if (!_isAuthenticated) {
      throw Exception('Usuário não autenticado');
    }
    return _firestore.collection('users').doc(_userId).collection('materias');
  }
  
  // Métodos para Materias
  
  // Adicionar matéria
  Future<void> adicionarMateria(Materia materia) async {
    if (!_isAuthenticated) {
      throw Exception('Usuário não autenticado');
    }
    
    try {
      print('Tentando adicionar matéria: ${materia.nome} para usuário: $_userId');
      await materiasCollection.doc(materia.id).set({
        'nome': materia.nome,
        'descricao': materia.descricao,
        'timestamp': FieldValue.serverTimestamp(), // Adicionar timestamp
      });
      print('Matéria adicionada com sucesso: ${materia.id}');
      return Future.value();
    } catch (e) {
      print('ERRO ao adicionar matéria: $e');
      return Future.error(e);
    }
  }
  
  // Atualizar matéria
  Future<void> atualizarMateria(Materia materia) {
    return materiasCollection.doc(materia.id).update({
      'nome': materia.nome,
      'descricao': materia.descricao,
    });
  }
  
  // Excluir matéria
  Future<void> excluirMateria(String materiaId) {
    return materiasCollection.doc(materiaId).delete();
  }
  
  // Listar todas as matérias
  Stream<List<Materia>> getMaterias() {
    return materiasCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Materia(
          id: doc.id,
          nome: data['nome'] ?? '',
          descricao: data['descricao'] ?? '',
        );
      }).toList();
    });
  }

  // Obter uma matéria específica
  Future<Materia?> getMateria(String materiaId) async {
    DocumentSnapshot doc = await materiasCollection.doc(materiaId).get();
    if (doc.exists) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Materia(
        id: doc.id,
        nome: data['nome'] ?? '',
        descricao: data['descricao'] ?? '',
      );
    }
    return null;
  }

  // Métodos para Atividades
  
  // Adicionar atividade
  Future<void> adicionarAtividade(String materiaId, Atividade atividade) {
    return materiasCollection
        .doc(materiaId)
        .collection('atividades')
        .doc(atividade.id)
        .set({
      'titulo': atividade.titulo,
      'descricao': atividade.descricao,
      'dataLimite': atividade.dataLimite,
      'status': atividade.status.toString(),
    });
  }
  
  // Atualizar atividade
  Future<void> atualizarAtividade(String materiaId, Atividade atividade) {
    return materiasCollection
        .doc(materiaId)
        .collection('atividades')
        .doc(atividade.id)
        .update({
      'titulo': atividade.titulo,
      'descricao': atividade.descricao,
      'dataLimite': atividade.dataLimite,
      'status': atividade.status.toString(),
    });
  }
  
  // Excluir atividade
  Future<void> excluirAtividade(String materiaId, String atividadeId) {
    return materiasCollection
        .doc(materiaId)
        .collection('atividades')
        .doc(atividadeId)
        .delete();
  }
  
  // Listar todas as atividades de uma matéria
  Stream<List<Atividade>> getAtividades(String materiaId) {
    return materiasCollection
        .doc(materiaId)
        .collection('atividades')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Atividade(
          id: doc.id,
          titulo: data['titulo'] ?? '',
          descricao: data['descricao'] ?? '',
          dataLimite: (data['dataLimite'] as Timestamp).toDate(),
          status: _parseStatus(data['status']),
        );
      }).toList();
    });
  }
  
  // Métodos para Convidados
  
  // Adicionar convidado a uma atividade
  Future<void> adicionarConvidado(String materiaId, String atividadeId, Convidado convidado) {
    return materiasCollection
        .doc(materiaId)
        .collection('atividades')
        .doc(atividadeId)
        .collection('convidados')
        .doc(convidado.id)
        .set({
      'nome': convidado.nome,
      'email': convidado.email,
    });
  }
  
  // Remover convidado de uma atividade
  Future<void> removerConvidado(String materiaId, String atividadeId, String convidadoId) {
    return materiasCollection
        .doc(materiaId)
        .collection('atividades')
        .doc(atividadeId)
        .collection('convidados')
        .doc(convidadoId)
        .delete();
  }
  
  // Listar todos os convidados de uma atividade
  Stream<List<Convidado>> getConvidados(String materiaId, String atividadeId) {
    return materiasCollection
        .doc(materiaId)
        .collection('atividades')
        .doc(atividadeId)
        .collection('convidados')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return Convidado(
          id: doc.id,
          nome: data['nome'] ?? '',
          email: data['email'] ?? '',
        );
      }).toList();
    });
  }
  
  // Auxiliar para converter string de status em enum
  StatusAtividade _parseStatus(String statusString) {
    if (statusString.contains('concluido')) {
      return StatusAtividade.concluido;
    }
    return StatusAtividade.pendente;
  }
}
