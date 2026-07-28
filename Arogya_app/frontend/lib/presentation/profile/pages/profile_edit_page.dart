import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // Initial dummy data
  final String _defaultAssetPath = "assets/images/sreerag.jpg";
  
  // State variables for dynamic updates
  File? _selectedImageFile;
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial data
    _nameController = TextEditingController(text: "SREERAG V S");
    _phoneController = TextEditingController(text: "9526147049");
    _emailController = TextEditingController(text: "sreeragvs2004@gmail.com");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Helper to dynamically get the current image provider
  ImageProvider? _getProfileImage() {
    if (_selectedImageFile != null) {
      return FileImage(_selectedImageFile!);
    }
    return AssetImage(_defaultAssetPath);
  }

  // Pick image from Camera or Gallery
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 247, 252, 251),
      appBar: AppBar(
        toolbarHeight: 60,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.2),
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 250, 251, 250),
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: Color.fromARGB(255, 49, 114, 51),
            fontSize: 25,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _buildProfilePictureSection(),
              const SizedBox(height: 30),
              CustomInputField(
                controller: _nameController, 
                label: "FULL NAME",
              ),
              CustomInputField(
                controller: _emailController, 
                label: "EMAIL",
                keyboardType: TextInputType.emailAddress,
              ),
              CustomInputField(
                controller: _phoneController, 
                label: "PHONE NUMBER",
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _buildSaveButton(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    final imageProvider = _getProfileImage();

    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 70,
              backgroundColor: const Color.fromARGB(255, 245, 245, 244),
              backgroundImage: imageProvider,
              child: imageProvider == null
                  ? const Icon(
                      Icons.person,
                      size: 60,
                      color: Color.fromARGB(255, 82, 79, 79),
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showChangePhotoSheet(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Update your profile photo',
          style: TextStyle(
            fontSize: 15,
            color: Color.fromARGB(221, 65, 63, 63),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: () {
        // Collect edited values
        final updatedName = _nameController.text;
        final updatedEmail = _emailController.text;
        final updatedPhone = _phoneController.text;

        // Save logic here...
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 79, 157, 37),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14),
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle_outline, size: 22, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Save Changes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePhotoSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                "Change Profile Photo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 245, 245, 244),
                backgroundImage: _getProfileImage(),
              ),
              const SizedBox(height: 24),
              _ActionTile(
                icon: Icons.camera_alt_outlined,
                label: "Take Photo",
                backgroundColor: const Color.fromARGB(255, 27, 94, 32),
                textColor: Colors.white,
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 12),
              _ActionTile(
                icon: Icons.image_outlined,
                label: "Upload from Gallery",
                backgroundColor: const Color.fromARGB(255, 220, 237, 217),
                textColor: Colors.black87,
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _selectedImageFile = null;
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Remove Current Photo",
                        style: TextStyle(
                          color: Colors.red, 
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Extracted Input Widget
class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromARGB(255, 130, 130, 130),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromARGB(255, 169, 169, 169)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromARGB(255, 49, 114, 51)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color.fromARGB(255, 169, 169, 169)),
            ),
          ),
          style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

// Extracted Action Tile Widget
class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: textColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.chevron_right, color: textColor, size: 20),
          ],
        ),
      ),
    );
  }
}