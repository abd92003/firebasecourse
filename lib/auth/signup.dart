import 'package:firebasecourse/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';
import '../components/textformfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  

  // ✅ صح: formKey (مو formkey)
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // ✅ صح: formKey (مو formkey)
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50),
                  const CustomLogoAuth(),
                  Container(height: 20),
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  const Text(
                    "Sign Up To Continue Using The App",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Container(height: 20),
                  const Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter Your Username",
                    mycontroller: username,
                    // ✅ أضف validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  Container(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter Your Email",
                    mycontroller: email,
                    // ✅ أضف validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  Container(height: 10),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  CustomTextForm(
                    hinttext: "Enter Your Password",
                    mycontroller: password,
                    // ✅ أضف validation
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  Container(height: 20),
                ],
              ),
            ),
            CustomButtonAuth(
              title: "Sign Up",
              onPressed: () async {
                // ✅ صح: formKey (مو formkey)
                if (formKey.currentState!.validate()) {
                  AppDialogs.loading(context);

                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );

                    AppDialogs.hideLoading(context);

                    if (mounted) {
                      AppDialogs.success(
                        context,
                        'Account created successfully!',
                      );
                      Future.delayed(const Duration(milliseconds: 1500), () {
                        if (mounted) {
                          Navigator.of(
                            context,
                          ).pushReplacementNamed("homepage");
                        }
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    AppDialogs.hideLoading(context);

                    if (mounted) {
                      String message = _getSignUpErrorMessage(e);
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          AppDialogs.error(context, message);
                        }
                      });
                    }
                  } catch (e) {
                    AppDialogs.hideLoading(context);
                    if (mounted) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          AppDialogs.error(
                            context,
                            'An unexpected error occurred: ${e.toString()}',
                          );
                        }
                      });
                    }
                  }
                }
              },
            ),
            Container(height: 20),
            InkWell(
              onTap: () {
                if (mounted) {
                  Navigator.of(context).pushNamed("login");
                }
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Have An Account ? "),
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getSignUpErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already in use.\n\nIf you have an account, please login instead.';

      case 'invalid-email':
        return 'The email address is not valid.\n\nPlease enter a valid email (e.g., user@example.com).';

      case 'weak-password':
        return 'The password is too weak.\n\nPassword must contain:\n• At least 6 characters\n• Uppercase and lowercase letters\n• Numbers and special characters';

      case 'operation-not-allowed':
        return 'Account creation is not enabled.\n\nPlease contact support for assistance.';

      case 'network-request-failed':
        return 'No internet connection.\n\nPlease check your network and try again.';

      default:
        return 'An error occurred during sign up: ${e.message}\n\nPlease try again or contact support.';
    }
  }
}
