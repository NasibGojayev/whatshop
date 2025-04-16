import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatShop haqqında'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WhatShop nədir?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'WhatShop, Azərbaycandaki mikro-satıcılar üçün yaradılmış onlayn satış optimizasiya platformasıdır. Məhsullarınızı daha tez idarə etməyinizə yardımcı olur.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Text(
                'Niyə WhatShop?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildBulletPoint('Bulud saxlanması: Məhsullarınız telefonunuzda yer tutmaz.'),
              _buildBulletPoint('Ağıllı axtarış və filtrasiya.'),
              _buildBulletPoint('Bir kliklə məhsul paylaşımı.'),
              _buildBulletPoint('Satıcı və vendor tərəfli ayrı app strukturu.'),
              const SizedBox(height: 24),
              const Text(
                'Kimlər üçün?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              _buildBulletPoint('Instagram, WhatsApp, Telegram üzərindən satış edənlər.'),
              _buildBulletPoint('Kiçik və orta biznes sahibləri.'),
              _buildBulletPoint('Yeni başlayan onlayn satıcılar.'),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  'Satışınızı WhatShop ilə daha asan edin!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 20)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
