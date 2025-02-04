import 'package:app_project/auth/domain/domain.dart';
import 'package:app_project/auth/infrastructure/infrastructure.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthDataSourceImpl extends AuthDataSource {
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
      // Verifica si el token aún es válido
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) {
        throw Exception('Usuario no autenticado.');
      }

      final userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!userDoc.exists) throw Exception("El usuario no existe en Firestore");

      final userData = userDoc.data()!;
      return UserMapper.userJsonToEntity({
        'id': firebaseUser.uid,
        'email': userData['email'],
        'fullName': userData['fullName'],
        'avatar': userData['avatar'],
        'rol': userData['rol'],
        'token': await firebaseUser.getIdToken(),
      });
    } catch (e) {
      throw Exception('Error al verificar el estado de autenticación: $e');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      // Inicio de sesión con Firebase Authentication
      print('Iniciando sesión: $email, $password');
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) throw Exception("Firebase user is null");

      // Recuperar datos desde Firestore
      final userDoc =
          await _firestore.collection('users').doc(firebaseUser.uid).get();
      if (!userDoc.exists) throw Exception("El usuario no existe en Firestore");

      final userData = userDoc.data()!;
      return UserMapper.userJsonToEntity({
        'id': firebaseUser.uid,
        'email': userData['email'],
        'fullName': userData['fullName'],
        'avatar': userData['avatar'],
        'rol': userData['rol'],
        'token': await firebaseUser.getIdToken(),
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No se encontró un usuario con ese correo.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Contraseña incorrecta.');
      } else {
        throw Exception('Error desconocido: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) async {
    try {
      print('Registrando usuario: $email, $password, $fullName');
      // Registro con Firebase Authentication
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = credential.user;
      if (firebaseUser == null) throw Exception("Firebase user is null");

      // Guardar datos adicionales en Firestore
      final userDoc = _firestore.collection('users').doc(firebaseUser.uid);
      await userDoc.set({
        'email': email,
        'fullName': fullName,
        'avatar': null, // Se puede agregar un avatar predeterminado
        'rol': 'user', // Rol por defecto
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Retornar usuario transformado
      return UserMapper.userJsonToEntity({
        'id': firebaseUser.uid,
        'email': email,
        'fullName': fullName,
        'avatar': null,
        'rol': 'user',
        'token': await firebaseUser.getIdToken(),
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('La contraseña es muy débil.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('El correo ya está registrado.');
      } else {
        throw Exception('Error desconocido: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }

  @override
  Future<User> loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<User> loginWithGoogle() async {
    try {
      // Inicia sesión con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Inicio de sesión con Google cancelado.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Credenciales de Firebase
      final firebase_auth.AuthCredential credential =
          firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Inicia sesión en Firebase con las credenciales de Google
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw Exception('No se pudo autenticar con Google.');
      }

      // Verifica si el usuario ya existe en Firestore
      final userRef = _firestore.collection('users').doc(firebaseUser.uid);
      final userDoc = await userRef.get();

      if (!userDoc.exists) {
        // Si el usuario no existe en Firestore, crea su registro
        await userRef.set({
          'email': firebaseUser.email,
          'fullName': firebaseUser.displayName ?? 'Usuario Google',
          'avatar': firebaseUser.photoURL,
          'rol': 'user', // Rol por defecto
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Obtén los datos desde Firestore
      final userData = (await userRef.get()).data()!;

      // Retorna la entidad User usando el mapper
      return UserMapper.userJsonToEntity({
        'id': firebaseUser.uid,
        'email': userData['email'],
        'fullName': userData['fullName'],
        'avatar': userData['avatar'],
        'rol': userData['rol'],
        'token': await firebaseUser.getIdToken(),
      });
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw Exception('Error en FirebaseAuth: ${e.message}');
    } catch (e) {
      throw Exception('Error al iniciar sesión con Google: $e');
    }
  }
}
