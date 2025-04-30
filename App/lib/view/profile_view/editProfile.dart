import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_application_1/view/profile_view/profile.dart';
import 'package:flutter_application_1/client/UserClient.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EditProfileView extends StatefulWidget {
  final Map<String, dynamic> data;

  const EditProfileView({Key? key, required this.data}) : super(key: key);

  @override
  _EditProfileViewState createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late Map<String, dynamic> data;
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  File? _imageFile; // We will use this to store the profile image temporarily

  @override
  void initState() {
    super.initState();
    data = Map<String, dynamic>.from(widget.data);
    usernameController = TextEditingController(text: data['username']);
    emailController = TextEditingController(text: data['email']);
    phoneController = TextEditingController(text: data['nomor_telepon']);
  }

  // This function will pick an image from the camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // This function simulates fetching the profile picture URL
  Future<String> fetchProfilePicture() async {
    // await Future.delayed(const Duration(seconds: 2)); // Simulating network delay
    return 'https://cinema88.fun/storage/app/public/profile_pictures/' + data['profile_picture'];
  }

  // Show options for choosing a photo from camera or gallery
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.black,
          child: SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: const Text('Take a picture',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.white),
                  title: const Text('Choose from gallery',
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // This function will handle saving the changes (including updating the profile)
  Future<void> _saveChanges() async {
    try {
      // Create an instance of UserClient
      UserClient userClient = UserClient();

      // Get values from controllers, use empty strings if null
      String username =
          usernameController.text.isEmpty ? '' : usernameController.text;
      String email = emailController.text.isEmpty ? '' : emailController.text;
      String phoneNumber =
          phoneController.text.isEmpty ? '' : phoneController.text;

      // Call the updateUser method
      var response = await userClient.updateUser(
        id_user : data['id_user'], // Make sure to pass the user ID
        username: username,
        email: email,
        nomor_telepon: phoneNumber,
        profilePicture: _imageFile!, // Send the picked profile image (if any)
      );

      // Show success toast
      Fluttertoast.showToast(
        msg: "Profile updated successfully!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate to the profile view with updated data
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShowProfile(data: response['user']),
        ),
      );
    } catch (e) {
      // Handle the error
      // Show failure toast
      Fluttertoast.showToast(
        msg: "Failed to update profile!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: whiteColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Icon(Icons.arrow_back_ios, color: lightColor),
            ),
            Text(
              'Back',
              style: TextStyle(color: lightColor),
            ),
          ],
        ),
      ),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  FutureBuilder<String>(
                    future: fetchProfilePicture(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircleAvatar(
                          radius: 58,
                          backgroundColor: Colors.grey,
                        );
                      } else if (snapshot.hasError) {
                        return const CircleAvatar(
                          radius: 58,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.error, color: Colors.white),
                        );
                      } else if (snapshot.hasData) {
                        return CircleAvatar(
                          radius: 58,
                          backgroundImage: NetworkImage(snapshot.data!),
                        );
                      } else {
                        return const CircleAvatar(
                          radius: 58,
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.error, color: Colors.white),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 2),
                  TextButton.icon(
                    icon: const Icon(Icons.border_color, color: lightColor),
                    label: const Text(
                      'Edit Photo',
                      style: TextStyle(color: lightColor),
                    ),
                    onPressed: _showImagePickerOptions,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 320,
              child: _buildTextField(
                controller: usernameController,
                label: 'Username',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 320,
              child: _buildTextField(
                controller: emailController,
                label: 'Email',
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: 320,
              child: _buildTextField(
                controller: phoneController,
                label: 'Phone Number',
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: lightColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 120, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: _saveChanges,
              child: const Text('Save Changes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: lightColor),
        ),
      ),
    );
  }
}