import 'package:challenge1_group3/models/user_model.dart';
import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:challenge1_group3/ui/pages/auth/sign_up_screen.dart';
import 'package:challenge1_group3/ui/pages/dashboard/home_page.dart';
import 'package:challenge1_group3/ui/widgets/custom_textfied.dart';
import 'package:challenge1_group3/ui/widgets/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _loading = false;
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    _loading = true;
    setState(() {});
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          final data = doc.data()!;
          final fetchedUser = UserModel.fromJson({
            ...data,
            'uid': user.uid,
          });
          await context.read<UserProvider>().updateUser(fetchedUser);
        } else {
          await context.read<UserProvider>().updateUser(UserModel(
                uid: user.uid,
                fullName: user.displayName ?? "No Name",
                email: user.email ?? "",
              ));
        }

        setState(() => _error = null);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      if (e.code == 'user-not-found') {
        errorMessage = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Wrong password provided.';
      } else {
        errorMessage = 'Login failed: ${e.message}';
      }

      setState(() => _error = errorMessage);
    } catch (e) {
      setState(() => _error = 'An unexpected error occurred.');
    }

    _loading = false;
    setState(() {});
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.white,
      body: LayoutBuilder(builder: (context, constraint) {
        return Row(
          children: [
            if (constraint.maxWidth > 600)
              Expanded(
                  child: Container(
                color: CustomTheme.accentColor,
              )),
            Expanded(
              child: Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Trello Like App",
                          style: CustomTextStyle.title16SemiBold,
                        ),
                        Text("Developed by Group 3"),
                        const SizedBox(height: 20),
                        Text(
                          'Login into your account',
                          style: CustomTextStyle.title16SemiBold,
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          required: true,
                          hintText: "Email address",
                          controller: _usernameController,
                          onValidate: (String? v) {
                            final isValid =
                                RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                    .hasMatch(v!);

                            if (!isValid) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          verticalPadding: 16,
                          inputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          required: true,
                          hintText: "Password",
                          password: true,
                          controller: _passwordController,
                          // onValidate: (v) {},
                          verticalPadding: 16,
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _error!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                            width: double.infinity,
                            child: PrimaryButton(
                              label: "Log In",
                              onPressed: _login,
                              color: CustomTheme.accentColor,
                              textColor: CustomTheme.white,
                              loading: _loading,
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'Don\'t have an account? ',
                                  style: CustomTextStyle.title13Regular,
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {}),
                              TextSpan(
                                  text: 'Sign up',
                                  style:
                                      CustomTextStyle.title13Regular.copyWith(
                                    color: CustomTheme.accentColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpScreen()));
                                    }),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
