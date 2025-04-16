import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dəstək Xidməti'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Hər hansı bir sualınız varsa, bizə müraciət edin!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Dəstək xətləri və suallar üçün aşağıdakı əlaqə nömrələrindən istifadə edə bilərsiniz.\nEyni zamanda, sorğularınızı da bizə birbaşa yaza bilərsiniz.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            SupportInfoRow(
              icon: Icons.phone_in_talk,
              text: '+994 50 234 56 78',
              label: 'Əlaqə nömrəsi',
            ),
            const SizedBox(height: 16),
            SupportInfoRow(
              icon: Icons.email_outlined,
              text: 'support@whatshop.az',
              label: 'Email',
            ),
            const Spacer(),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Burada məsələn, sual göndərmək funksionallığı əlavə edilə bilər.
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Bizə Yazın'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupportInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final String label;

  const SupportInfoRow({
    Key? key,
    required this.icon,
    required this.text,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
