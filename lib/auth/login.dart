import 'package:firebasecourse/widgets/dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import '../components/custombuttonauth.dart';
import '../components/customlogoauth.dart';
import '../components/textformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // ✅ Form Key
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoding = false;

  // ✅ Google Sign-In
  Future<void> signInWithGoogle() async {
    try {
      AppDialogs.loading(context);

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        AppDialogs.hideLoading(context);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      AppDialogs.hideLoading(context);

      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil("homepage", (route) => false);
      }
    } catch (e) {
      AppDialogs.hideLoading(context);
      if (mounted) {
        AppDialogs.error(context, 'Google sign-in failed: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isLoding ? Center(child: CircularProgressIndicator()) : Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            // ✅ Form with validation
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 50),
                  const CustomLogoAuth(),
                  Container(height: 20),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  const Text(
                    "Login To Continue Using The App",
                    style: TextStyle(color: Colors.grey),
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
                  InkWell(
                    onTap: () async {
                      if (email.text.isEmpty || email.text.trim().isEmpty) {
                        AppDialogs.error(
                          context,
                          'Please enter your email to reset password.',
                        );
                        return;
                      }
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                          email: email.text.trim(),
                        );
                        AppDialogs.success(
                          context,
                          'Password reset email sent to ${email.text.trim()}. Please check your inbox.',
                        );
                      } on Exception catch (e) {
                        AppDialogs.error(
                          context,
                          'Failed to send password reset email: ${e.toString()}',
                        );
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            CustomButtonAuth(
              title: "Login",
              onPressed: () async {
                // ✅ تحقق من صحة الحقول
                if (formKey.currentState!.validate()) {
                  AppDialogs.loading(context);

                  try {
                    isLoding = true;
                    setState(() {});
                    final credential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: email.text.trim(),
                          password: password.text.trim(),
                        );

                    isLoding = false;
                    setState(() {});
                    AppDialogs.hideLoading(context);

                    // ✅ تحقق من تفعيل الإيميل
                    if (credential.user!.emailVerified) {
                      if (mounted) {
                        Future.delayed(const Duration(milliseconds: 1500), () {
                          if (mounted) {
                            Navigator.of(
                              context,
                            ).pushReplacementNamed("homepage");
                          }
                        });
                      }
                    } else {
                      // ❌ الإيميل غير مفعل
                      AppDialogs.error(
                        context,
                        'Email Not Verified.\n\n'
                        'A verification email was sent to:\n'
                        '${email.text.trim()}\n\n'
                        'Please check your inbox and click the verification link.\n\n'
                        'After verification, try logging in again.',
                      );
                      // ✅ تسجيل خروج المستخدم
                      await FirebaseAuth.instance.signOut();
                    }
                  } on FirebaseAuthException catch (e) {
                    AppDialogs.hideLoading(context);

                    if (mounted) {
                      String message = _getLoginErrorMessage(e);
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

            // ✅ زر تسجيل الدخول بجوجل
            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.red[700],
              textColor: Colors.white,
              onPressed: () async {
                await signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login With Google  "),
                  Image.asset("images/4.png", width: 20),
                ],
              ),
            ),

            Container(height: 20),
            InkWell(
              onTap: () {
                if (mounted) {
                  Navigator.of(context).pushReplacementNamed("signup");
                }
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Don't Have An Account ? "),
                      TextSpan(
                        text: "Register",
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

  String _getLoginErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.\n\nPlease check your email or create a new account.';

      case 'wrong-password':
        return 'Wrong password provided.\n\nPlease check your password and try again.';

      case 'invalid-email':
        return 'The email address is not valid.\n\nPlease enter a valid email (e.g., user@example.com).';

      case 'user-disabled':
        return 'This account has been disabled.\n\nPlease contact support for assistance.';

      case 'too-many-requests':
        return 'Too many requests sent.\n\nPlease try again in a few minutes.';

      case 'network-request-failed':
        return 'No internet connection.\n\nPlease check your network and try again.';

      default:
        return 'An error occurred during login: ${e.message}\n\nPlease try again or contact support.';
    }
  }
}
