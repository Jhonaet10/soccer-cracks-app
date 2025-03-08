import 'package:app_project/auth/domain/domain.dart';
import 'package:app_project/auth/infrastructure/infrastructure.dart';
import 'package:app_project/shared/infrastructure/errors/handle_error.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthDataSourceImpl({
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw FirebaseErrorHandler.handleGenericException(
            'Usuario no autenticado');
      }

      final userRef = _firestore.collection('users').doc(firebaseUser.uid);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        await userRef.set({
          'email': firebaseUser.email,
          'fullName': firebaseUser.displayName ?? 'Nuevo Usuario',
          'avatar': firebaseUser.photoURL,
          'rol': 'new_user',
          'createdAt': FieldValue.serverTimestamp(),
          'torneos': [],
        });

        final newUserDoc = await userRef.get();
        final newUserData = newUserDoc.data()!;

        return UserMapper.userJsonToEntity({
          'id': firebaseUser.uid,
          'email': newUserData['email'],
          'fullName': newUserData['fullName'],
          'avatar': newUserData['avatar'],
          'rol': newUserData['rol'],
          'token': await firebaseUser.getIdToken(),
          'torneos': newUserData['torneos'] ?? [],
        });
      }

      final userData = userDoc.data()!;
      return UserMapper.userJsonToEntity({
        'id': firebaseUser.uid,
        'email': userData['email'],
        'fullName': userData['fullName'],
        'avatar': userData['avatar'],
        'rol': userData['rol'],
        'token': await firebaseUser.getIdToken(),
        'torneos': userData['torneos'] ?? [],
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw CustomError('Error al iniciar sesión');
      }

      final userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!userDoc.exists) {
        throw CustomError('El usuario no existe en la base de datos');
      }

      final userData = userDoc.data()!;
      return UserMapper.userJsonToEntity({
        'id': firebaseUser.uid,
        'email': userData['email'],
        'fullName': userData['fullName'],
        'avatar': userData['avatar'],
        'rol': userData['rol'],
        'token': await firebaseUser.getIdToken(),
        'torneos': userData['torneos'],
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<User> register(
      String email, String password, String fullName, String role) async {
    try {
      final validRoles = ['Jugador', 'Árbitro', 'Organizador'];
      if (!validRoles.contains(role)) {
        throw FirebaseErrorHandler.handleGenericException(
            'Rol no válido. Los roles permitidos son: ${validRoles.join(", ")}');
      }

      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) {
        throw FirebaseErrorHandler.handleGenericException(
            'Error al crear el usuario');
      }

      await _firestore.collection('users').doc(firebaseUser.uid).set({
        'email': email,
        'fullName': fullName,
        'avatar': null,
        'rol': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserMapper.userJsonToEntity({
        'id': firebaseUser.uid,
        'email': email,
        'fullName': fullName,
        'avatar': null,
        'rol': role,
        'token': await firebaseUser.getIdToken(),
        'torneos': [],
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<User> loginWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status != LoginStatus.success) {
        throw FirebaseErrorHandler.handleGenericException(
            'Inicio de sesión con Facebook cancelado');
      }

      final accessToken = result.accessToken!;
      final credential = firebase_auth.FacebookAuthProvider.credential(
          accessToken.tokenString);
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw FirebaseErrorHandler.handleGenericException(
            'No se pudo autenticar con Facebook');
      }

      final userRef = _firestore.collection('users').doc(firebaseUser.uid);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        final userData = await FacebookAuth.instance.getUserData();
        await userRef.set({
          'email': firebaseUser.email,
          'fullName': userData['name'] ?? 'Usuario Facebook',
          'avatar':
              userData['picture']?['data']?['url'] ?? firebaseUser.photoURL,
          'rol': 'new_user',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final userData = (await userRef.get()).data()!;
      return UserMapper.userJsonToEntity({
        'id': firebaseUser.uid,
        'email': userData['email'],
        'fullName': userData['fullName'],
        'avatar': userData['avatar'],
        'rol': userData['rol'],
        'token': await firebaseUser.getIdToken(),
        'torneos': userData['torneos'],
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<User> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw FirebaseErrorHandler.handleGenericException(
            'Inicio de sesión con Google cancelado');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw FirebaseErrorHandler.handleGenericException(
            'No se pudo autenticar con Google');
      }

      final userRef = _firestore.collection('users').doc(firebaseUser.uid);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        await userRef.set({
          'email': firebaseUser.email,
          'fullName': firebaseUser.displayName ?? 'Usuario Google',
          'avatar': firebaseUser.photoURL,
          'rol': 'new_user',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      final userData = (await userRef.get()).data()!;
      return UserMapper.userJsonToEntity({
        'id': firebaseUser.uid,
        'email': userData['email'],
        'fullName': userData['fullName'],
        'avatar': userData['avatar'],
        'rol': userData['rol'],
        'token': await firebaseUser.getIdToken(),
        'torneos': userData['torneos'],
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<User> completeRegistration(String userId, String role) async {
    try {
      final validRoles = ['Jugador', 'Árbitro', 'Organizador'];
      if (!validRoles.contains(role)) {
        throw FirebaseErrorHandler.handleGenericException(
            'Rol no válido. Los roles permitidos son: ${validRoles.join(", ")}');
      }

      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw FirebaseErrorHandler.handleGenericException(
            'Usuario no autenticado');
      }

      await _firestore.collection('users').doc(userId).update({
        'rol': role,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final userData = userDoc.data()!;

      return UserMapper.userJsonToEntity({
        'id': userId,
        'email': userData['email'],
        'fullName': userData['fullName'],
        'avatar': userData['avatar'],
        'rol': userData['rol'],
        'token': await firebaseUser.getIdToken(),
        'torneos': userData['torneos'],
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseAuthException(e);
    } on FirebaseException catch (e) {
      throw FirebaseErrorHandler.handleFirebaseException(e);
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw FirebaseErrorHandler.handleGenericException(e);
    }
  }
}
