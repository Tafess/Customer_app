// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/primary_button.dart';
import 'package:buyers/constants/routes.dart';
import 'package:buyers/constants/top_titles.dart';
import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/screens/login.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isShowPassword = false;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              //Icon(Icons.arrow_back),
              TopTitles(
                title: 'Create Account',
                subtitle: 'Welcome ',
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: name,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: 'Name ',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'E-mail ',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: password,
                obscureText: isShowPassword,
                decoration: InputDecoration(
                  hintText: 'Password',
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
                title: 'Register',
                onPressed: () async {
                  bool isValidate = signValidation(
                      email.text, password.text, name.text, phone.text);
                  if (isValidate) {
                    bool islogined = await FirebaseAuthHelper.instance
                        .signUp(name.text, email.text, password.text, context);
                    if (islogined) {
                      Routes.instance.pushAndRemoveUntil(
                          widget: CustomBottomBar(), context: context);
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              const Center(
                child: Text('Do You Have An Account'),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: CupertinoButton(
                  onPressed: () {
                    Routes.instance.push(widget: Login(), context: context);
                  },
                  child: Text(
                    'Login',
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
