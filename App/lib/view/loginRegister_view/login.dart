import 'package:flutter/material.dart';
import 'package:flutter_application_1/client/UserClient.dart';
import 'package:flutter_application_1/utilities/constant.dart';
import 'package:flutter_application_1/component/formComponent.dart';
import 'package:flutter_application_1/view/loginRegister_view/register.dart';
import 'package:flutter_application_1/view/home_view/home.dart';
import 'package:flutter_application_1/view/loginRegister_view/startPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  bool _showPassword = false;

  Map<String, dynamic>? dataForm;

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const StartPageView()),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 90),
                  SizedBox(
                    width: 500,
                    height: 200,
                    child:
                        Image.asset('images/loadLogo.png', fit: BoxFit.contain),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                        hintText: "user@gmail.com",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .white54), // Warna border saat tidak aktif
                          borderRadius:
                              BorderRadius.circular(8.0), // Radius sudut border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  lightColor), // Warna border saat input aktif
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Email tidak boleh kosong!';
                        }
                        if (!p0.contains('@')) {
                          return 'Email harus menggunakan @';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      style: const TextStyle(color: Colors.white),
                      controller: passwordController,
                      obscureText: !_showPassword,  // Add this line to control visibility
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password, color: Colors.white),
                        hintText: "********",
                        hintStyle: TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: lightColor),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        suffixIcon: IconButton(  // Add this part for password visibility toggle
                          icon: Icon(
                            _showPassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: _togglePasswordVisibility,  // Call the toggle function
                        ),
                      ),
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return 'Password tidak boleh kosong!';
                        }
                        if (p0.length < 8) {
                          return 'Password minimal 8 karakter';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, top: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFCC434),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(84),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      createAccount(context);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text.rich(
                        TextSpan(
                          text: "Haven't got account? ",
                          style: TextStyle(
                            color: Color(0xCCFFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text: 'Register here',
                              style: TextStyle(
                                color: Color(0xCCFFF500),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 150, horizontal: 20),
                    child: Text(
                      'By signing in or signing up, you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void loginSuccess(BuildContext context, Map<String, dynamic> userData) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => HomeView(userData: userData),
      ),
    );
  }

  void showLoginError(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Login Gagal'),
        content: const Text('Email atau password salah. Silahkan coba lagi.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void createAccount(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RegisterView(),
      ),
    );
  }

  Future<void> _login() async {
    try {
      var userClient = UserClient();
      var response =
          await userClient.login(emailController.text, passwordController.text);
      if (response.containsKey("token")) {
        String token = response['token'];

        Map<String, dynamic> user =
            response['user']; // Data user yang diambil dari API

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        Fluttertoast.showToast(
          msg: "Login successfully !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        // Navigasi ke HomeView dengan data user
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeView(userData: user)),
        );
      } else {
        showLoginError(context); // Menampilkan error jika token tidak ada
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to login!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      print("Login Error: $e");
      showLoginError(context); // Menampilkan error jika terjadi exception
    }
  }
}


