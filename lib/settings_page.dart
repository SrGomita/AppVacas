import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  final Function(String) onLanguageChange;

  const SettingsPage({super.key, required this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cambiar idioma:', style: TextStyle(fontSize: 18)),
            ListTile(
              title: Text('Español'),
              onTap: () => onLanguageChange('es'),
            ),
            ListTile(
              title: Text('English'),
              onTap: () => onLanguageChange('en'),
            ),
          ],
        ),
      ),
    );
  }
}
