import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ftest1/expert_form.dart';
import 'package:ftest1/support_form.dart';
import 'package:ftest1/userinfo_screen.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({Key? key}) : super(key: key);

  final padding = const EdgeInsets.symmetric(horizontal: 5);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Colors.green,
        child: ListView(
          padding: padding,
          children: <Widget>[
            buildHeader(name: FirebaseAuth.instance.currentUser?.displayName, email: FirebaseAuth.instance.currentUser?.email, onClicked: () => {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UserInfoScreen()))
            }),
            const Divider(thickness: 2.0, color: Colors.white70),
            buildMenuItem(
              text: 'Consultar a experto',
              icon: Icons.contact_support_outlined,
              onClicked: () => selectedItem(context, 0)
            ),
            const SizedBox(height: 12),
            buildMenuItem(
                text: 'Soporte técnico',
                icon: Icons.support,
                onClicked: () => selectedItem(context, 1)
            ),
            const SizedBox(height: 192),
            const Divider(thickness: 2.0, color: Colors.white70),
            const SizedBox(height: 5),

            buildMenuItem(
                text: 'Cerrar sesión',
                icon: Icons.logout_outlined,
                onClicked: () => FirebaseAuth.instance.signOut()
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({required String? name, required String? email, required VoidCallback onClicked}) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        padding: padding.add(const EdgeInsets.only(top: 40, bottom: 20)),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sesión iniciada como:', style: TextStyle(fontSize: 14, color: Colors.white)),
                const SizedBox(height: 8),
                Text(name!, style: const TextStyle(fontSize: 22, color: Colors.white)),
                const SizedBox(height: 10),
                Text(email!, style: const TextStyle(fontSize: 12, color: Colors.white))
              ],
            ),
            const SizedBox(width: 40),
            CircleAvatar(radius: 30, backgroundColor: Colors.green.shade400, child: const Icon(Icons.add_comment_outlined, color: Colors.white))
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({required String text, required IconData icon, VoidCallback? onClicked}) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: const TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ExpertForm()));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => SupportForm()));
        break;
    }
  }
}
