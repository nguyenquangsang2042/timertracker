import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../services/auth.dart';

class SignInManager {
  SignInManager({required this.auth,required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

  Future<User?> _signIn(Future<User?> signInMethod) async {
    try {
      isLoading.value=true;
      return await signInMethod;
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value=false;
    }
  }
  Future<User?> signInAnonymously() async =>await _signIn(auth.signInAnonymously());

  Future<User?> signInWithGoogle() async =>await _signIn(auth.signInWithGoogle());

  Future<User?> signInWithEmailAndPass(String email, String pass) async =>await _signIn(auth.signInWithEmailAndPass(email, pass));

  Future<User?> createAccountWithEmailAndPass(String email, String pass) async =>await _signIn(auth.createAccountWithEmailAndPass(email, pass));
}
