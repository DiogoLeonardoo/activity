import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream de alterações no estado de autenticação
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
  
  // Retornar o usuário atual
  User? get currentUser => _auth.currentUser;
  
  // Retornar o ID do usuário atual
  String? get currentUserId => _auth.currentUser?.uid;
  
  // Verificar se o usuário está autenticado
  bool get isAuthenticated => _auth.currentUser != null;

  // Método para registro com e-mail e senha
  Future<UserCredential?> registerWithEmailAndPassword(String email, String password, String nome) async {
    try {
      print('Tentando registrar usuário com email: $email e nome: $nome');
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Adicionar informações do usuário no Firestore
      if (result.user != null) {
        print('Usuário criado com UID: ${result.user!.uid}');
        try {
          await _firestore.collection('users').doc(result.user!.uid).set({
            'email': email,
            'nome': nome,
            'criado_em': FieldValue.serverTimestamp(),
          });
          print('Dados do usuário salvos no Firestore');
          
          // Atualizar o displayName do usuário
          await result.user!.updateDisplayName(nome);
          print('Nome de exibição atualizado para: $nome');
        } catch (firestoreError) {
          print('Erro ao salvar dados do usuário no Firestore: $firestoreError');
          // Não anular o resultado, pois o usuário já foi criado
        }
      }
      
      return result;
    } catch (e) {
      print('Erro no registro: $e');
      throw e; // Propagar o erro para ser tratado na UI
    }
  }

  // Método para login com e-mail e senha
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      print('Tentando fazer login com email: $email');
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('Login bem-sucedido para usuário: ${result.user?.email}');
      return result;
    } catch (e) {
      print('Erro no login: $e');
      throw e; // Propagar o erro para ser tratado na UI
    }
  }

  // Método para logout
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Erro no logout: $e');
      return;
    }
  }
  
  // Método para atualizar o perfil do usuário
  Future<void> updateProfile(String nome) async {
    try {
      User? user = _auth.currentUser;
      
      if (user != null) {
        // Atualizar o displayName
        await user.updateDisplayName(nome);
        
        // Atualizar as informações no Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'nome': nome,
          'atualizado_em': FieldValue.serverTimestamp(),
        });
        
        print('Perfil atualizado com sucesso para $nome');
      } else {
        throw Exception('Usuário não autenticado');
      }
    } catch (e) {
      print('Erro ao atualizar perfil: $e');
      throw e;
    }
  }
  
  // Método para login com o Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print('Iniciando login com Google...');
      
      // Inicia o processo de login do Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('Login com Google cancelado pelo usuário');
        return null;
      }
      
      // Obtém os detalhes da autenticação do Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Cria as credenciais para o Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      // Realiza o login no Firebase com as credenciais do Google
      final UserCredential userCredential = 
          await _auth.signInWithCredential(credential);
      
      print('Login com Google bem-sucedido para ${userCredential.user?.email}');
      
      // Verifica se o usuário é novo ou existente
      if (userCredential.additionalUserInfo?.isNewUser == true) {
        print('Novo usuário criado via Google Sign-In');
        // Salva informações do usuário no Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'email': userCredential.user!.email,
          'nome': userCredential.user!.displayName,
          'foto_url': userCredential.user!.photoURL,
          'provedor': 'google',
          'criado_em': FieldValue.serverTimestamp(),
        });
      } else {
        // Atualiza último login
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'ultimo_login': FieldValue.serverTimestamp(),
        });
      }
      
      return userCredential;
    } catch (e) {
      print('Erro no login com Google: $e');
      throw e;
    }
  }
}
