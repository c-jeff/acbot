import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ftest1/forgotpassword_screen.dart';
import 'package:ftest1/utils.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onClickRegister;
  const LoginScreen({Key? key, required this.onClickRegister}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isHidden = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 35),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(' AIgrary', textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  SizedBox(width: 25),
                  CircleAvatar(backgroundImage: AssetImage('assets/logo.png'), radius: 35),
                ]),
            const SizedBox(height: 45),
            const Text('Iniciar Sesión', textAlign: TextAlign.center, style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
            const SizedBox(height: 25),
            TextFormField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Correo electrónico", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: const Icon(Icons.email)),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => email != null && !EmailValidator.validate(email) ? 'Correo electrónico no válido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: passwordController,
              obscureText: isHidden,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: "Contraseña", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(icon: isHidden ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), onPressed: () => setState(()=> isHidden = !isHidden))),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6 ? 'Contraseña no válida' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              icon: const Icon(Icons.lock_open, size: 32),
              label: const Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: login,
            ),
            const SizedBox(height: 24),
            GestureDetector(
              child: Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).colorScheme.secondary, fontSize: 20),
              ),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
            ),
            const SizedBox(height: 16),
            RichText(
                text: TextSpan(
                 style: const TextStyle(color: Colors.white, fontSize: 20),
                 text: '¿No tienes una cuenta?  ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = widget.onClickRegister,
                      text: 'Registrarse',
                      style: TextStyle(decoration: TextDecoration.underline, color: Theme.of(context).colorScheme.secondary),
                    ),
                  ],
                ),
            ),
          ],
        )
      )
    );
  }

  Future login() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) return;

    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      Navigator.of(context).popUntil((route) => route.isFirst);
      Utils.showSnackBarSuccess('Inicio de sesión correcto.');
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);

      if (e.message == 'There is no user record corresponding to this identifier. The user may have been deleted.') {
        Navigator.of(context).pop();
        Utils.showSnackBarError('No existe un usuario con el correo electrónico ingresado.');
      } else if (e.message == 'The password is invalid or the user does not have a password.') {
        Navigator.of(context).pop();
        Utils.showSnackBarError('Contraseña incorrecta.');
      } else {
        Navigator.of(context).pop();
        Utils.showSnackBarError(e.message);
      }
    }
  }
}
