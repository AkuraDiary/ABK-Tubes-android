import 'dart:convert';

import 'package:asisten_buku_kebun/data/model/user_model.dart';
import 'package:asisten_buku_kebun/data/preferences/app_shared_preferences.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:crypto/crypto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPresenter{

  RequestState requestState = RequestState.initial;

  UserModel? registerResult;

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // set registerResult
    registerResult = null;
    requestState = RequestState.loading;

    var bytes = utf8.encode(password); // data being hashed
    String hashedPassword  = sha1.convert(bytes).toString();
    var result = Supabase.instance.client.from('users').insert(
      {
        'name': name,
        'email': email,
        'password': hashedPassword,
      },
    ).select().single();

    registerResult = await result.then((value) {
      return UserModel.fromJson(value);
    });

    requestState = RequestState.loaded;

    if (registerResult != null) {
      requestState = RequestState.success;
      loggedInUser = registerResult;
      // If the registration is successful, return true
      return true;
    } else {
      requestState = RequestState.error;
      // If the registration fails, return false
      return false;
    }
  }


  UserModel? loggedInUser;

  // This variable holds the currently logged-in user, if any.
  Future<bool> login(String email, String password) async {
    // set loggedInUser
    loggedInUser = null;

    requestState = RequestState.loading;
    var bytes = utf8.encode(password); // data being hashed
    String hashedPassword  = sha1.convert(bytes).toString();

    var result = Supabase.instance.client.from('users').select().eq('email', email).eq('password', hashedPassword).single();

    loggedInUser= await result.then((value) {
      return UserModel.fromJson(value);
    });


    requestState = RequestState.loaded;
    if (loggedInUser != null) {
      requestState = RequestState.success;
      // If the login is successful, return true
      return true;
    } else {
      requestState = RequestState.error;
      // If the login fails, return false
      return false;
    }
  }

  Future<void> logout() async {
    loggedInUser = null;
    registerResult = null;
    requestState = RequestState.initial;
    deauthenticate();
    // For demonstration purposes, let's assume the logout is always successful
  }

  Future<void> authenticate() async{
    // save the logged in user to local storage
    if (loggedInUser != null) {
      await AppSharedPreferences.setUserModel(
        loggedInUser!,
      );
      // return loggedInUser!.token;
    } else {
      throw Exception('User not logged in');
    }
  }

  Future<void> deauthenticate() async {
    // Clear user data from local storage
    await AppSharedPreferences.clearPreferences();
    await AppSharedPreferences.removeKey(AppSharedPreferences.userModelKey);
  }

  Future<bool> checkLogin() async {
    final hasAccount = await AppSharedPreferences.containsKey(AppSharedPreferences.userModelKey);
    return hasAccount;
  }


}