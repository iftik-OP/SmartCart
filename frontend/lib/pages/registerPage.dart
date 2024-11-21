import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:smart_cart/classes/user.dart';
import 'package:smart_cart/consts.dart';
import 'package:smart_cart/pages/loginPage.dart';
import 'package:smart_cart/services/userServices.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

TextEditingController _nameController = TextEditingController();
TextEditingController _emailcontroller = TextEditingController();
TextEditingController _phoneNumberController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
TextEditingController _confirmPasswordController = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool _isLoading = false;

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'Header',
              child: Container(
                width: double.infinity,
                height: h * 0.15,
                decoration: const BoxDecoration(
                  color: primaryYellow,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(21),
                      bottomLeft: Radius.circular(21)),
                ),
                child: SafeArea(
                  child: Center(
                    child: Image.asset(
                      'assets/images/Logos/Square logo.png',
                      height: 108,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Signup',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 36),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (_nameController.text.length <= 0) {
                          return 'Enter Your Name';
                        }
                      },
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        hintText: 'John Doe',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailcontroller.text)) {
                          return 'Enter valid email';
                        }
                      },
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: 'johndoe@gmail.com',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (_phoneNumberController.text.length != 10) {
                          return 'Enter valid phone number';
                        }
                      },
                      controller: _phoneNumberController,
                      decoration: InputDecoration(
                        labelText: "Phone Number",
                        hintText: '+91',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (_passwordController.text.length <= 6) {
                          return 'The password length must be greater than 6';
                        } else if (_passwordController.text.length !=
                            _confirmPasswordController.text.length) {
                          return 'Password doesn\'t match';
                        }
                      },
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: '********',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          return 'Password doesn\'t match';
                        } else if (_passwordController.text.length <= 6) {
                          return 'The password length must be greater than 6';
                        }
                      },
                      obscureText: true,
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        hintText: '********',
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });
                          User newUser = await User(
                              id: '',
                              name: _nameController.text,
                              email: _emailcontroller.text,
                              phoneNumber: _phoneNumberController.text);
                          await UserServices()
                              .registerUser(newUser, _passwordController.text);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      style: ButtonStyle(
                          minimumSize: WidgetStatePropertyAll(
                              Size(double.infinity, 50))),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Signup',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(color: primaryYellow),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
