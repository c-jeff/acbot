import 'package:flutter/material.dart';
import 'package:ftest1/login_screen.dart';
import 'package:ftest1/register_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin ? LoginScreen(onClickRegister: toggle) : RegisterScreen(onClickLogin: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
