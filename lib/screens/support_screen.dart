// ignore_for_file: prefer_const_constructors

import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/screens/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({Key? key}) : super(key: key);

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          ExpansionTile(
            title: text(title: 'How to Manage Account?', size: 14),
            children: [
              Divider(),
              CupertinoButton(
                onPressed: () {
                  userId == null
                      ? Routes.instance.push(widget: SignUp(), context: context)
                      : Routes.instance.push(widget: widget, context: context);
                },
                child: ListTile(
                  title: text(
                    title: userId != null ? 'Delete Account' : 'Create Account',
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              if (userId != null) Divider(),
              //  if (userId != null)
              CupertinoButton(
                onPressed: () {},
                child: ListTile(
                  title:
                      text(title: 'Edit profile', overflow: TextOverflow.clip),
                ),
              ),
              if (userId != null) Divider(),
              //  if (userId != null)
              CupertinoButton(
                onPressed: () {},
                child: ListTile(
                  title:
                      text(title: 'change photo', overflow: TextOverflow.clip),
                ),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: text(title: 'List of orders History?'),
            children: [
              Divider(),
              ListTile(
                title: text(title: 'Pending orders'),
              ),
              Divider(),
              ListTile(
                title: text(title: 'On delivery orders'),
              ),
              Divider(),
              ListTile(
                title: text(title: 'Completed orders'),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: text(title: 'How to edit profile?', size: 12),
            children: [
              Divider(),
              ListTile(
                title: text(title: 'Instructions for editing your profile'),
              ),
            ],
          ),
          Divider(),
          ExpansionTile(
            title: text(title: 'how to add profile image'),
            children: [
              Divider(),
              ListTile(
                title: text(title: 'Steps to add a profile image'),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }
}
