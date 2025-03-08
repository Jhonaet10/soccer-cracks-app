import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/services.dart';
import 'custom_error.dart';

class FirebaseErrorHandler {
  static Never handleFirebaseAuthException(
      firebase_auth.FirebaseAuthException e) {
    print(e.code);
    switch (e.code) {
      case 'invalid-email':
        throw CustomError('El correo electrónico no es válido.', code: e.code);
      case 'user-disabled':
        throw CustomError('El usuario ha sido deshabilitado.', code: e.code);
      case 'user-not-found':
        throw CustomError('No se encontró una cuenta con este correo.',
            code: e.code);
      case 'wrong-password':
        throw CustomError('Contraseña incorrecta.', code: e.code);
      case 'email-already-in-use':
        throw CustomError('Este correo ya está en uso.', code: e.code);
      case 'weak-password':
        throw CustomError('La contraseña es demasiado débil.', code: e.code);
      case 'operation-not-allowed':
        throw CustomError('Esta operación no está permitida.', code: e.code);
      case 'too-many-requests':
        throw CustomError('Demasiados intentos. Inténtelo más tarde.',
            code: e.code);
      case 'invalid-credential':
        print("Si entro");
        throw CustomError(
            'Las credenciales proporcionadas son incorrectas o han expirado.',
            code: e.code);
      case 'invalid-verification-code':
        throw CustomError('El código de verificación es inválido.',
            code: e.code);
      case 'invalid-verification-id':
        throw CustomError('El ID de verificación es inválido.', code: e.code);
      case 'recaptcha-error':
      case 'missing-recaptcha-token':
        throw CustomError(
            'Error de verificación de seguridad. Por favor, inténtelo de nuevo.',
            code: e.code);
      default:
        throw CustomError(
            'Error de autenticación: ${e.message ?? 'Credenciales inválidas'}',
            code: e.code);
    }
  }

  static Never handleFirebaseException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        throw CustomError('No tienes permisos para realizar esta acción.',
            code: e.code);
      case 'not-found':
        throw CustomError('El documento solicitado no existe.', code: e.code);
      case 'unavailable':
        throw CustomError('El servicio no está disponible temporalmente.',
            code: e.code);
      case 'deadline-exceeded':
        throw CustomError('El tiempo de espera ha expirado.', code: e.code);
      case 'already-exists':
        throw CustomError('El documento ya existe en Firestore.', code: e.code);
      case 'cancelled':
        throw CustomError('La operación fue cancelada.', code: e.code);
      case 'invalid-argument':
        throw CustomError('El argumento proporcionado no es válido.',
            code: e.code);
      default:
        throw CustomError('Error de Firestore: ${e.message}', code: e.code);
    }
  }

  static Never handlePlatformException(PlatformException e) {
    throw CustomError('Error del sistema: ${e.message}',
        code: e.code ?? "platform-error");
  }

  static Never handleGenericException(dynamic e) {
    throw CustomError('Error desconocido: ${e.toString()}', code: "unknown");
  }
}
