import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ftest1/utils.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onClickLogin;
  const RegisterScreen({Key? key, required this.onClickLogin}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cPasswordController = TextEditingController();
  bool isHidden = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cPasswordController.dispose();
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
              const SizedBox(height: 20),
              const Text('Registrarse', textAlign: TextAlign.center, style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              TextFormField(
                controller: nameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Nombre y Apellido", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: const Icon(Icons.account_circle)),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 3 ? 'Ingresa un nombre' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Correo electrónico", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: const Icon(Icons.email)),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) => email != null && !EmailValidator.validate(email) ? 'Ingresa un correo electrónico válido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: passwordController,
                obscureText: isHidden,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Contraseña", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(icon: isHidden ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), onPressed: () => setState(()=> isHidden = !isHidden))),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6 ? 'Ingresa una contraseña de 6 caracteres como mínimo' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cPasswordController,
                obscureText: isHidden,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: "Confirmar Contraseña", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)), prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(icon: isHidden ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility), onPressed: () => setState(()=> isHidden = !isHidden))),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value != passwordController.text ? 'La contraseña no coincide' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                icon: const Icon(Icons.app_registration, size: 32),
                label: const Text('Registrarse', style: TextStyle(fontSize: 24)),
                onPressed: register,
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  text: '¿Ya tienes cuenta?  ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()..onTap = widget.onClickLogin,
                      text: 'Iniciar Sesión',
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

  Future register() async {
    final valid = _formKey.currentState!.validate();
    if (!valid) return;

    showDialog(context: context, builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());

      await FirebaseAuth.instance.currentUser?.updateDisplayName(nameController.text);

      Navigator.of(context).popUntil((route) => route.isFirst);
      Utils.showSnackBarSuccess('Se ha registrado correctamente.');
    } on FirebaseAuthException catch (e) {
      debugPrint(e.message);

      if (e.message == 'The email address is already in use by another account.') {
        Navigator.of(context).pop();
        Utils.showSnackBarError('El correo electrónico ingresado ya se encuentra registrado.');
      } else {
        Navigator.of(context).pop();
        Utils.showSnackBarError(e.message);
      }
    }
  }
}