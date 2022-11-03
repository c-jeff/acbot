import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class UserInfoScreen extends StatelessWidget {
  UserInfoScreen({Key? key}) : super(key: key);

  final email = FirebaseAuth.instance.currentUser?.email;

  @override
  Widget build(BuildContext context) {
    var reg = FirebaseAuth.instance.currentUser?.metadata.creationTime;
    final name = FirebaseAuth.instance.currentUser?.displayName;
    final registerDate = DateFormat('dd/MM/yyyy').format(reg!);

    Query ref = FirebaseDatabase.instance.ref().child('users');

    return Scaffold(
        appBar: AppBar(title: const Text('Información de la cuenta'), centerTitle: true),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.green,
          child: Column(
              children: [
                Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(top: 20.0),
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(name!, style: const TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 20),
                    Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Colors.green.shade700,
                        ),
                        child: Column(
                            children: [
                              const SizedBox(height: 8.0),
                              Text('Registrado en: $registerDate', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                              const SizedBox(height: 12.0),
                              Text('Email: $email', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16)),
                            ]
                        )
                    ),
                    const SizedBox(height: 20.0),
                    const Text("Historial de Consultas", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8.0),
                    SizedBox(height: MediaQuery.of(context).size.height - 280, child: FirebaseAnimatedList(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        scrollDirection: Axis.vertical,
                        query: ref,
                        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                          Map user = snapshot.value as Map;
                          return listItem(user: user, context: context);
                        }
                      )
                    )
                    //ListView.separated(itemBuilder: (context, index) {}, separatorBuilder: (context, index) {}, itemCount: 100)
                  ],
                ),
              ]
          ),
        )
    );
  }

  Widget listItem({required Map user, context}) {
    var date = user['sent'];
    if (user['email'] == email) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        height: MediaQuery.of(context).size.height * 0.185,
        color: Colors.green.shade700,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user['type'] == 'expert' ? 'Consulta a experto:' : 'Solicitud de soporte técnico:',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
            Text(
              user['query'],
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 5),
            Text(
              'Enviado el $date',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
    }
    return const SizedBox(height: 0);
  }
}
