import 'package:asisten_buku_kebun/data/model/user_model.dart';
import 'package:asisten_buku_kebun/data/preferences/app_shared_preferences.dart';
import 'package:asisten_buku_kebun/data/request_state.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';

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
    var salt = await FlutterBcrypt.salt();
    String hashedPassword = await FlutterBcrypt.hashPw(password: password, salt: salt);
    // TODO SEND REQUEST HERE
    // registerResult = await dataSource.signUp(
    //   username: username,
    //   name: name,
    //   email: email,
    //   phone: phone,
    //   password: password,
    // );

    requestState = RequestState.loaded;

    if (registerResult != null) {
      requestState = RequestState.success;
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
    var salt = await FlutterBcrypt.salt();
    String hashedPassword = await FlutterBcrypt.hashPw(password: password, salt: salt);

    // loggedInUser = // TODO MAKE REQUEST HERE TO SUPABASE

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
    // Simulate a network call or database query
    // await Future.delayed(const Duration(seconds: 1));
    // TODO MAKE REQUEST HERE TO SUPABASE TO LOGOUT USER
    // TODO DEAUTHENTICATE USER LOCALLY
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