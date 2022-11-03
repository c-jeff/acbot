import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:ftest1/utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Restablecer Contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Recibe un correo electrónico\npara restablecer tu contraseña', textAlign: TextAlign.center, style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => email != null && !EmailValidator.validate(email) ? 'Ingresa un correo electrónico válido' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.email_outlined, size: 32),
                label: const Text(
                  'Restablecer contraseña',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: resetPassword,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future resetPassword() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) return;

    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));
    
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
      Navigator.of(context).popUntil((route) => route.isFirst);
      Utils.showSnackBarSuccess('Se ha enviado un mensaje de correo electrónico para restablecer la contraseña.');
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);

      if (e.message == 'There is no user record corresponding to this identifier. The user may have been deleted.') {
        Navigator.of(context).pop();
        Utils.showSnackBarError('No existe un usuario con el correo electrónico ingresado.');
      } else {
        Navigator.of(context).pop();
        Utils.showSnackBarError(e.message);
      }
    }
  }
}
