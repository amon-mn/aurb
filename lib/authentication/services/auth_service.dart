import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Login com Google
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult =
            await _firebaseAuth.signInWithCredential(credential);
        return authResult.user !=
            null; // Retorna true se o usuário foi autenticado com sucesso
      }

      return false; // Retorna false se o usuário cancelar o processo de login
    } catch (error) {
      print("Error signing in with Google: $error");
      return false; // Retorna false se ocorrer um erro durante o login
    }
  }

  Future<String?> loginUser(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "user-not-found":
          return "Usuário não cadastrado";
        case "wrong-password":
          return "Email ou senha incorretos";
      }
      return e.code;
    }
    return null;
  }

/*
  Future<String?> registerUser({
    required String email,
    required String password,
    required String name,
    required String cpf,
    required String state,
    required String city,
    required String propertyName,
    String? cnpj,
    required String cep,
    required String street,
    required String neighborhood,
    required String locality,
    required bool isProducer,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userType = isProducer ? 'Producer' : 'Merchant';

      Map<String, dynamic> userData = {
        'name': name,
        'state': state,
        'city': city,
        'cpf': cpf,
      };

      if (isProducer) {
        userData.addAll({
          'propertyName': propertyName,
          'cep': cep,
          'street': street,
          'neighborhood': neighborhood,
          'locality': locality,
        });
      } else {
        userData.addAll({
          'propertyName': propertyName,
          'cnpj': cnpj,
          'cep': cep,
          'street': street,
          'neighborhood': neighborhood,
          'locality': locality,
        });
      }

      // Salvar informações personalizadas no Firebase Firestore com base no tipo de usuário
      await _firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'userType': userType,
        ...userData,
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "email-already-in-use":
          return "O e-mail já está em uso.";
      }
      return e.code;
    }

    return null;
  }
*/

  // Função de logout
  Future<String?> logout() async {
    try {
      print("Tentando fazer logout...");
      // Faz o logout do Firebase
      await _firebaseAuth.signOut();
      print("Logout realizado com sucesso!");
      return null; // Retornar null significa que o logout foi bem-sucedido.
    } catch (error) {
      print("Erro durante o logout: $error");
      return "Erro durante o logout: $error";
    }
  }

/*
// Função para verificar se o usuario preencheu as informações de cadastro
  Future<bool> hasAdditionalInfo(String userId) async {
    try {
      DocumentSnapshot userSnapshot =
          await _firebaseFirestore.collection('users').doc(userId).get();

      return userSnapshot.exists;
    } catch (error) {
      print("Erro ao verificar informações adicionais: $error");
      return false;
    }
  }
*/
  Future<String?> missPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        return "E-mail não cadastrado.";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> removeAccount({required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _firebaseAuth.currentUser!.email!, password: senha);
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }
}
