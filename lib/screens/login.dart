// ignore_for_file: prefer_const_constructors, use_build_context_synchronously


import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/primary_button.dart';
import 'package:buyers/constants/routes.dart';
import 'package:buyers/constants/top_titles.dart';
import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/screens/sign_up.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isShowPassword = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Icon(Icons.arrow_back),
              TopTitles(title: 'Login', subtitle: 'Welcome back '),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                  hintText: 'E-mail ',
                  labelText: 'ENTER YOUR E-MAIL ADDRESS',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              TextFormField(
                controller: password,
                obscureText: isShowPassword,
                decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'ENTER YOUR PASSWORD',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.blue,
                  ),
                  suffixIcon: CupertinoButton(
                    onPressed: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                      });
                    },
                    child: Icon(
                      Icons.visibility,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              PrimaryButton(
                  title: 'Login',
                  onPressed: () async {
                    bool isValidate =
                        loginValidation(email.text, password.text);
                    if (isValidate) {
                      bool islogined = await FirebaseAuthHelper.instance
                          .login(email.text, password.text, context);
                      if (islogined) {
                        Routes.instance.pushAndRemoveUntil(
                            widget: CustomBottomBar(), context: context);
                      }
                    }
                  }),
              SizedBox(
                height: 20,
              ),
              const Center(
                child: Text('Do not Have An Account'),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    Routes.instance
                        .push(widget: const SignUp(), context: context);
                  },
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
