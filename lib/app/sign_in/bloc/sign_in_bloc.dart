import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import '../../../services/auth.dart';

class SignInBloc {
  SignInBloc({required this.auth});

  final StreamController<bool> _isLoadController = StreamController<bool>();
  final AuthBase auth;

  Stream<bool> get isLoadStream => _isLoadController.stream;

  void dispose() {
    _isLoadController.close();
  }

  void setIsLoading(bool isLoading) => _isLoadController.add(isLoading);

  Future<User?> _signIn(Future<User?> signInMethod) async {
    try {
      setIsLoading(true);
      return await signInMethod;
    } catch (e) {
      rethrow;
    } finally {
      setIsLoading(false);
    }
  }

  Future<User?> signInAnonymously() async =>await _signIn(auth.signInAnonymously());

  Future<User?> signInWithGoogle() async =>await _signIn(auth.signInWithGoogle());

  Future<User?> signInWithEmailAndPass(String email, String pass) async =>await _signIn(auth.signInWithEmailAndPass(email, pass));

  Future<User?> createAccountWithEmailAndPass(String email, String pass) async =>await _signIn(auth.createAccountWithEmailAndPass(email, pass));
}
