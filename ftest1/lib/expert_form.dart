import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ftest1/utils.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ExpertForm extends StatelessWidget {
  ExpertForm({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  final controllerMessage = TextEditingController();
  final hintEmail = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Consulta a experto'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            buildTextField(title: 'Escribe tu consulta:', controller: controllerMessage, maxLines: 8),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), textStyle: const TextStyle(fontSize: 20)),
              child: const Text('Enviar'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                showDialog(context: context, builder: (context) => AlertDialog(
                  title: const Text('Confirmación de envío'),
                  content: Text('¿Seguro que quieres enviar la consulta? Un experto te responderá a tu correo: $hintEmail'),
                  actions: <Widget>[
                    TextButton(onPressed: () => Navigator.of(context).pop('Yes'), child: const Text('SÍ')),
                    TextButton(onPressed: () => Navigator.of(context).pop('No'), child: const Text('NO')),
                  ],
                )).then((result) => result == 'Yes' ? sendEmail(name: 'Usuario de Algrary', email: hintEmail, subject: 'Consulta de usuario de Algrary', message: controllerMessage.text) : null);
                }
              }
            ),
          ],
        )
      ),

    );
  }

  Future sendEmail({required String name, required String? email, required String subject, required String message}) async {
    const serviceId = 'service_3hurvcp';
    const templateId = 'template_ctyks3f';
    const userId = 'WexSQw1nOdiUPFNml';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-type': 'application/json'},
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message
        }
      })
    );

    if (response.body == 'OK') {
      Utils.showSnackBarSuccess('Se envió tu consulta correctamente.');
      DatabaseReference ref = FirebaseDatabase.instance.ref().child('users');

      Map<String, String> query = {
        'email': hintEmail!,
        'query': controllerMessage.text,
        'sent': DateFormat('dd/MM/yyyy').format(DateTime.now()),
        'type': 'expert'
      };
      ref.push().set(query);
      controllerMessage.clear();
    } else {
      Utils.showSnackBarError('Ocurrió un error al enviar tu consulta.');
    }

    debugPrint(response.body);
  }

  Widget buildTextField({required String title, required TextEditingController controller, required int maxLines}) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(controller: controller, textInputAction: TextInputAction.done, decoration: const InputDecoration(border: OutlineInputBorder()),
              maxLines: maxLines, validator: (value) => value != null && value.length < 35 ? 'Por favor brinda más detalles en tu consulta' : null)
        ],
      )
    );
  }
}
