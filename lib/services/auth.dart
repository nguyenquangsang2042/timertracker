import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;

  Future<User?> signInAnonymously();

  Future<void> signOut();

  Stream<User?> authStateChanges();

  Future<User?> signInWithGoogle();

  Future<User?> signInWithFacebook();
  Future<User?> signInWithEmailAndPass(String email,String pass);
  Future<User?> createAccountWithEmailAndPass(String email,String pass);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleSigIn = GoogleSignIn();
    final googleUser = await googleSigIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: 'ERROR_MISING_GOOGLE_ID_TOKEN',
            message: 'Missing Google ID Token');
      }
    } else {
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  @override
  Future<User?> signInWithFacebook() async {
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);
    switch (response.status) {
      case FacebookLoginStatus.success:
        final accessToken = response.accessToken;
        if (accessToken != null) {
          final userCredential = await _firebaseAuth.signInWithCredential(
              FacebookAuthProvider.credential(accessToken.token));
          return userCredential.user;
        } else {
          throw FirebaseAuthException(
              code: 'ACCESS_TOKEN_IS_NULL', message: 'Access token is null');
        }
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            code: 'ERROR_ABORT_BY_USER', message: 'Sign in aborted by user');
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
            code: 'ERROR_FB_LOGIN_FAIL', message: 'Facebook login failed');
    }
  }
  @override
  Future<User?> signInWithEmailAndPass(String email, String pass) async{
    final userCredential= await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(email: email, password: pass));
    return userCredential.user;
  }
  @override
  Future<User?> createAccountWithEmailAndPass(String email, String pass) async {
    final userCredential= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: pass);
    return userCredential.user;
  }
}
