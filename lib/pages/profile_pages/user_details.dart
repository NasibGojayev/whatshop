import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatshop/bloc_management/user_bloc/user_bloc.dart';
import 'package:whatshop/pages/profile_pages/profile_page.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  UserObject user = UserObject(
    name: "John Doe",
    email: "john.doe@example.com",
    phone: "+1234567890",
    profileImage: null,
  );

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        user = UserObject(
          name: user.name,
          email: user.email,
          phone: user.phone,
          profileImage: image.path,
        );
      });
    }
    }

  void _editField(String field, String currentValue) async {
    String? newValue = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit $field"),
        content: TextField(
          controller: TextEditingController(text: currentValue),
          decoration: InputDecoration(hintText: "Enter new $field"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context,
                  (ModalRoute.of(context)!.settings.arguments
                  as TextEditingController).text
              );
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (newValue != null && newValue != currentValue) {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: user.profileImage != null
                    ? FileImage(File(user.profileImage!))
                    : null,
                child: user.profileImage == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 20),

            // User Details Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildEditableField("Name", user.name, () => _editField("name", user.name)),
                    const Divider(),
                    _buildEditableField("Email", user.email, () => _editField("email", user.email)),
                    const Divider(),
                    _buildEditableField("Phone", user.phone, () => _editField("phone", user.phone)),
                  ],
                ),
              ),
            ),

            // Additional Sections
            const SizedBox(height: 20),
            _buildSectionHeader("Account Settings"),
            _buildListTile("Change Password", Icons.lock, () {}),

            _buildListTile("Addresses", Icons.home, () {}),

            const SizedBox(height: 20),
            _buildSectionHeader("Support"),
            _buildListTile("Help Center", Icons.help, () {}),
            _buildListTile("Contact Us", Icons.email, () {}),

            // Logout Button
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () =>signOut(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
              ),
              child: const Text("Logout", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String value, VoidCallback onEdit) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      trailing: IconButton(
        icon: const Icon(Icons.edit, size: 20),
        onPressed: onEdit,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}