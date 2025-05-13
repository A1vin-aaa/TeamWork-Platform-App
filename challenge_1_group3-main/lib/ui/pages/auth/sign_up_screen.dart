import 'package:challenge1_group3/main.dart';
import 'package:challenge1_group3/styling/custom_theme.dart';
import 'package:challenge1_group3/styling/text_styles.dart';
import 'package:challenge1_group3/ui/pages/auth/login_screen.dart';
import 'package:challenge1_group3/ui/pages/dashboard/home_page.dart';
import 'package:challenge1_group3/ui/widgets/custom_textfied.dart';
import 'package:challenge1_group3/ui/widgets/primary_button.dart';
import 'package:challenge1_group3/ui/widgets/square_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool password = true;
  bool _loading = false;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: Colors.transparent,
        backgroundColor: CustomTheme.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SquareButton(
              icon: Icons.keyboard_backspace,
              bgColor: CustomTheme.white,
              contentColor: CustomTheme.black,
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(builder: (context, constraint) {
        return Row(children: [
          if (constraint.maxWidth > 600)
            Expanded(
                child: Container(
              color: CustomTheme.accentColor,
            )),
          Expanded(
            child: Column(
              children: [
                Divider(
                  color: CustomTheme.black.withValues(alpha: .2),
                  height: 1,
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      padding:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Create a new account',
                              style: CustomTextStyle.title16SemiBold,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              required: true,
                              hintText: 'Full Name',
                              controller: fullNameController,
                              verticalPadding: 18,
                              inputType: TextInputType.text,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextField(
                              required: true,
                              hintText: 'Email',
                              onValidate: (String? v) {
                                final isValid =
                                    RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$")
                                        .hasMatch(v!);

                                if (!isValid) {
                                  return 'Please enter valid email address';
                                }
                              },
                              controller: emailController,
                              verticalPadding: 18,
                              inputType: TextInputType.emailAddress,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Stack(
                              children: [
                                CustomTextField(
                                  required: true,
                                  hintText: 'Password',
                                  controller: passwordController,
                                  verticalPadding: 18,
                                  maxLine: 1,
                                  password: password,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  top: 0,
                                  child: IconButton(
                                      onPressed: () {
                                        password = !password;
                                        setState(() {});
                                      },
                                      icon: Icon(password
                                          ? Icons.visibility_off
                                          : Icons.visibility)),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Hero(
                              tag: "button",
                              child: PrimaryButton(
                                  label: 'Sign Up',
                                  color: CustomTheme.accentColor,
                                  textColor: CustomTheme.white,
                                  loading: _loading,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      setState(() => _loading = true);

                                      try {
                                        UserCredential userCredential =
                                            await FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        );

                                        final user = userCredential.user;

                                        if (user != null) {
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(user.uid)
                                              .set({
                                            'uid': user.uid,
                                            'full_name':
                                                fullNameController.text.trim(),
                                            'email':
                                                emailController.text.trim(),
                                            'createdAt':
                                                FieldValue.serverTimestamp(),
                                          });

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Account created successfully!')),
                                          );

                                          await FirebaseAuth.instance.signOut();
                                          await Navigator.pushReplacement(
                                            navKey.currentContext!,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()),
                                            result: true,
                                          );
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(e.message ??
                                                  'Signup failed')),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Some thing went wrong')),
                                        );
                                      } finally {
                                        setState(() => _loading = false);
                                      }
                                    }
                                  }),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: 'Already have an account? ',
                                      style: CustomTextStyle.title13Regular,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {}),
                                  TextSpan(
                                      text: 'Sign in',
                                      style: CustomTextStyle.title13Regular
                                          .copyWith(
                                        color: CustomTheme.accentColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()));
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
            ),
          )
        ]);
      }),
    );
  }
}
