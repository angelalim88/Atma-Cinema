import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/ticket.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/view/home_view/listFnB.dart';
import 'package:flutter_application_1/view/loginRegister_view/startPage.dart';
import 'package:flutter_application_1/view/profile_view/editProfile.dart';
import 'package:flutter_application_1/view/profile_view/changePassword.dart';
import 'package:flutter_application_1/view/ticket_view/ticketView.dart';

class ShowProfile extends StatefulWidget {
  final Map<String, dynamic> data;

  const ShowProfile({Key? key, required this.data}) : super(key: key);

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  late Map<String, dynamic> _profileData;

  @override
  void initState() {
    super.initState();
    _profileData = Map<String, dynamic>.from(widget.data);
  }

  // Simulate fetching the profile picture URL asynchronously
  Future<String> fetchProfilePicture() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulating network delay
    final profilePicture = _profileData['profile_picture'];
    if (profilePicture == null || profilePicture.toString().isEmpty) {
      return '';
    }
    return profilePicture.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 20,
            color: lightColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            FutureBuilder<String>(
              future: fetchProfilePicture(), // Fetch the profile picture URL
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a placeholder while waiting
                  return const CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.grey, // Placeholder color
                  );
                } else if (snapshot.hasError) {
                  // Show an error icon if there was an issue
                  return const CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.error, color: Colors.white),
                  );
                } else if (snapshot.hasData) {
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const CircleAvatar(
                      radius: 58,
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person, color: Colors.white, size: 40),
                    );
                  }
                  // Show the profile picture once it's loaded
                  return CircleAvatar(
                    radius: 58,
                    backgroundImage: NetworkImage(snapshot.data!),
                  );
                } else {
                  // Show an error icon if no data is available
                  return const CircleAvatar(
                    radius: 58,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.error, color: Colors.white),
                  );
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              _profileData['username'] ?? 'user1',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            buildInfoText('Phone Number :',
                _profileData['nomor_telepon'] ?? 'No Phone Number'),
            const SizedBox(height: 10),
            buildInfoText('Email :', _profileData['email'] ?? 'No Email'),
            const SizedBox(height: 30),
            buildOptionButton(context, Icons.confirmation_number, 'My ticket',
                () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketView(
                      data: _profileData), // Updated constructor parameter
                ),
              );
            }),
            buildOptionButton(context, Icons.edit, 'Edit Profile', () async {
              final updatedUser = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileView(
                      data: _profileData), // Updated constructor parameter
                ),
              );

              if (updatedUser != null && mounted) {
                setState(() {
                  _profileData = Map<String, dynamic>.from(updatedUser);
                });
              }
            }),
            buildOptionButton(context, Icons.lock, 'Change password', () async {
              final updatedUser = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordView(
                      data:
                          _profileData), // Assuming ChangePasswordView needs formData
                ),
              );

              if (updatedUser != null && mounted) {
                setState(() {
                  _profileData = Map<String, dynamic>.from(updatedUser);
                });
              }
            }),
            const Spacer(),
            buildLogoutButton(context),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildInfoText(String title, String info) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          info,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const Divider(color: Colors.grey),
      ],
    );
  }

  Widget buildOptionButton(BuildContext context, IconData icon, String text,
      VoidCallback onPressed) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(fontSize: 16, color: Colors.white),
      ),
      trailing:
          const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
      onTap: onPressed,
    );
  }

  Widget buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {
          Navigator.of(context, rootNavigator: true)
              .pushNamedAndRemoveUntil('/start', (route) => false);
        },
        child: const Text(
          'Log Out',
          style: TextStyle(fontSize: 16, color: Colors.red),
        ),
      ),
    );
  }
}
