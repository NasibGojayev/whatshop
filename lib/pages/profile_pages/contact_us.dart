import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bizimlə Əlaqə'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Əlaqə məlumatları',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            ContactInfoRow(
              icon: Icons.email_outlined,
              text: 'whatshop@gmail.com',
            ),
            const SizedBox(height: 16),
            ContactInfoRow(
              icon: Icons.phone_outlined,
              text: '+994 50 123 45 67',
            ),
            const SizedBox(height: 16),
            ContactInfoRow(
              icon: Icons.location_on_outlined,
              text: 'Bakı, Azərbaycan',
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Burada e.g. email göndərmək və ya başqa funksiya əlavə edə bilərsən
                },
                icon: const Icon(Icons.send_outlined),
                label: const Text('Bizə Yazın'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactInfoRow({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
