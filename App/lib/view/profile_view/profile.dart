import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/ticket.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/view/home_view/listFnB.dart';
import 'package:flutter_application_1/view/loginRegister_view/startPage.dart';
import 'package:flutter_application_1/view/profile_view/editProfile.dart';
import 'package:flutter_application_1/view/profile_view/changePassword.dart';
import 'package:flutter_application_1/view/ticket_view/ticketView.dart';

class ShowProfile extends StatelessWidget {
  final Map<String, dynamic> data;

  const ShowProfile({Key? key, required this.data}) : super(key: key);

  // Simulate fetching the profile picture URL asynchronously
  Future<String> fetchProfilePicture() async {
    await Future.delayed(
        const Duration(seconds: 2)); // Simulating network delay
    return 'https://cinema88.fun/storage/app/public/profile_pictures/' + data['profile_picture'];
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
              data['username'] ?? 'user1',
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            buildInfoText(
                'Phone Number :', data['nomor_telepon'] ?? 'No Phone Number'),
            const SizedBox(height: 10),
            buildInfoText('Email :', data['email'] ?? 'No Email'),
            const SizedBox(height: 30),
            buildOptionButton(context, Icons.confirmation_number, 'My ticket',
                () {
             Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TicketView(
                      data: data), // Updated constructor parameter
                ),
              );
            }),
            buildOptionButton(context, Icons.edit, 'Edit Profile', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileView(
                      data: data), // Updated constructor parameter
                ),
              );
            }),
            buildOptionButton(context, Icons.lock, 'Change password', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangePasswordView(
                      data: data), // Assuming ChangePasswordView needs formData
                ),
              );
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
