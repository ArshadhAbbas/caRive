import 'package:carive/shared/circular_progress_indicator.dart';
import 'package:carive/shared/constants.dart';
import 'package:carive/shared/custom_elevated_button.dart';
import 'package:carive/shared/custom_text_form_field.dart';
import 'package:carive/shared/logo.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String error = '';
  final formkey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  AuthService auth = AuthService();
  bool isLoading = false; // Add a isLoading state variable

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formkey,
          child: Column(
            children: [
              Row(
                children: [
                  const LogoWidget(30, 30),
                  wSizedBox20,
                  const Text(
                    "Register",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              hSizedBox30,
              CustomTextFormField(
                hintText: 'Email',
                labelText: 'Email',
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Email";
                  }
                  return null;
                },
              ),
              hSizedBox30,
              CustomTextFormField(
                hintText: 'Password',
                labelText: 'Password',
                controller: passwordController,
                obscureText: true,
                isEye: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please Enter Password";
                  }
                  return null;
                },
              ),
              hSizedBox30,
              isLoading
                  ? const CustomProgressIndicator()
                  : CustomElevatedButton(
                      text: "Register Now", onPressed: _registerButtonPressed),
              hSizedBox20,
              Text(
                error,
                style: const TextStyle(color: Colors.red),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _registerButtonPressed() async {
    if (formkey.currentState?.validate() ?? false) {
      FocusScopeNode currentfocus =
          FocusScope.of(context); //get the currnet focus node
      if (!currentfocus.hasPrimaryFocus) {
        //prevent Flutter from throwing an exception
        currentfocus
            .unfocus(); //unfocust from current focust, so that keyboard will dismiss
      }
      setState(() {
        isLoading =
            true; // Set isLoading to true when the registration process starts
      });

      dynamic result = await auth.registerWithEmailAndPAssword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (result == null) {
        setState(() {
          error = 'Invalid email';
          isLoading = false; // Set isLoading to false if registration fails
        });
      } else if (result == 'email-already-in-use') {
        setState(() {
          error = 'User already exists, Please sign In ';
          isLoading = false; // Set isLoading to false if registration fails
        });
      } else {
        try {
          // final fcmToken = await FirebaseMessaging.instance.getToken();
          // await FirebaseFirestore.instance
          //     .collection('FCMTokens')
          //     .doc(result
          //         .uid) // Assuming 'result.uid' is the user's unique ID after registration
          //     .set({'fcmToken': fcmToken, 'UserId': result.uid});
          // print("fcm:$fcmToken");
        } catch (e) {
          print(e.toString());
        }

        // print('Registered');
        Navigator.pop(context);
      }
    }
  }
}
