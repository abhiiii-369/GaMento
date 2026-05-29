import 'package:flutter/material.dart';

import '../services/auth_service.dart';

class AuthProvider
extends ChangeNotifier{

final AuthService auth=
AuthService();

bool loading=false;

login() async{

loading=true;

notifyListeners();

await auth.signIn();

loading=false;

notifyListeners();

}

logout() async{

await auth.logout();

}

}