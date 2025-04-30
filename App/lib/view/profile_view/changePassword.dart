import 'package:flutter/material.dart';
import 'package:flutter_application_1/client/UserClient.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/view/profile_view/changePassword.dart';
import 'package:flutter_application_1/view/profile_view/profile.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordView extends StatefulWidget {
  final Map<String, dynamic> data;

  ChangePasswordView({Key? key, required this.data}) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _showOldPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;
  String? _errorMessage;
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = Map<String, dynamic>.from(widget.data);
  }

  void _toggleOldPasswordVisibility() {
    setState(() {
      _showOldPassword = !_showOldPassword;
    });
  }

  void _toggleNewPasswordVisibility() {
    setState(() {
      _showNewPassword = !_showNewPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  Future<void> _saveChanges() async {
    try {
      UserClient userClient = UserClient();

      String old_password = _oldPasswordController.text.isEmpty
          ? ''
          : _oldPasswordController.text;
      String new_password = _newPasswordController.text.isEmpty
          ? ''
          : _newPasswordController.text;
      String confirm_password = _confirmPasswordController.text.isEmpty
          ? ''
          : _confirmPasswordController.text;

      var response = await userClient.changePassword(
          id_user: data["id_user"],
          old_password: old_password,
          new_password: new_password,
          confirm_password: confirm_password);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ShowProfile(data: response['user']),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to change password : $e')),
      );
    }
    // if (_formKey.currentState!.validate()) {
    //   setState(() {
    //     _isLoading = true;
    //     _errorMessage = null;
    //   });

    //   final registeredPassword = widget.data['password'];

    //   // Periksa apakah password lama cocok dengan yang terdaftar
    //   if (_oldPasswordController.text != registeredPassword) {
    //     setState(() {
    //       _isLoading = false;
    //       _errorMessage = 'Old password does not match our records!';
    //     });
    //     return;
    //   }

    //   // Periksa apakah password baru dan konfirmasi cocok
    //   if (_newPasswordController.text != _confirmPasswordController.text) {
    //     setState(() {
    //       _isLoading = false;
    //       _errorMessage = 'New password and confirmation do not match!';
    //     });
    //     return;
    //   }

    //   await Future.delayed(Duration(seconds: 2));

    //   setState(() {
    //     widget.data['password'] = _newPasswordController.text;
    //     _isLoading = false;
    //   });

    //   // Navigasi kembali ke halaman profil
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(
    //       builder: (context) => ShowProfile(data: widget.data),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Change Password',
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
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 3),
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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _oldPasswordController,
                obscureText: !_showOldPassword,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter Old Password :',
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showOldPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: whiteColor,
                    ),
                    onPressed: _toggleOldPasswordVisibility,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your old password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Enter New Password :',
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: whiteColor,
                    ),
                    onPressed: _toggleNewPasswordVisibility,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your new password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Confirm New Password :',
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: whiteColor,
                    ),
                    onPressed: _toggleConfirmPasswordVisibility,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: lightColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please re-enter your new password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 60),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: lightColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                  ),
                  onPressed: _saveChanges,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.black)
                      : Text(
                          'Save Changes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 10),
                Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
