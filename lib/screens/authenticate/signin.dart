// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import 'package:carive/screens/authenticate/forgot_password.dart';
import 'package:carive/screens/authenticate/register.dart';
import 'package:carive/services/auth.dart';
import 'package:carive/shared/constants.dart';
import 'package:carive/shared/custom_elevated_button.dart';
import 'package:carive/shared/custom_scaffold.dart';
import 'package:carive/shared/custom_text_form_field.dart';

import '../../shared/circular_progress_indicator.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AuthService auth = AuthService();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 90.0),
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Image.asset(
                    "assets/OnBoardingImg.png",
                    height: MediaQuery.of(context).size.height / 3,
                  ),
                ),
                const Text(
                  "Your Trusted Partner for Flawless Driving Experiences!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 112, 110, 110),
                    fontSize: 18,
                  ),
                ),
                hSizedBox20,
                Form(
                  key: formkey,
                  child: Center(
                    child: Column(
                      children: [
                        CustomTextFormField(
                          keyBoardType: TextInputType.emailAddress,
                          hintText: 'Email',
                          labelText: 'Email',
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter valid Mail";
                            }
                            return null;
                          },
                        ),
                        hSizedBox10,
                        CustomTextFormField(
                          hintText: 'Password',
                          labelText: 'Password',
                          controller: passwordController,
                          obscureText: true,
                          isEye: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please Enter Password containing atleast 6 characters";
                            }
                            return null;
                          },
                        ),
                        hSizedBox20,
                        CustomElevatedButton(
                            text: "Sign In", onPressed: _signInButtonPressed),
                        hSizedBox20,
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(25)),
                              ),
                              backgroundColor: themeColorGrey,
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return const Wrap(
                                  children: [
                                    Register(),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            "New Member? Create Account",
                            style:
                                TextStyle(color: themeColorGreen, fontSize: 15),
                          ),
                        ),
                        hSizedBox30,
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgotPassword()));
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                hSizedBox20,
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Color.fromARGB(255, 165, 165, 165),
                      ),
                    ),
                    Text(
                      "Or",
                      style: TextStyle(color: Colors.white),
                    ),
                    Expanded(
                        child: Divider(
                      color: Color.fromARGB(255, 165, 165, 165),
                    ))
                  ],
                ),
                hSizedBox10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        auth.signInWithGoogle();
                      },
                      child: CircleAvatar(
                        backgroundColor: themeColorGreen,
                        radius: 25,
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 23,
                          child: Image.asset(
                            'assets/icons8-google-30.png',
                            // height: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signInButtonPressed() async {
    dismissKeyboard(context);
    if (formkey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CustomProgressIndicator(),
        ),
      );

      dynamic result = await auth.sigINWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.of(context).pop();

        if (result == null) {
          _showErrorDialog(
              "Sign In Failed!", "Incorrect username or password.");
        } else if (result == 'user-not-found') {
          _showErrorDialog("Sign In Failed", "User not found.");
        }
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          contentTextStyle: const TextStyle(color: Colors.white),
          backgroundColor: const Color(0xFF1E1E1E),
          title: Text(title),
          content: Text(message),
          actions: [
            CustomElevatedButton(
              text: "Ok",
              onPressed: Navigator.of(context).pop,
              paddingHorizontal: 8,
              paddingVertical: 8,
            )
          ],
        );
      },
    );
  }
}
