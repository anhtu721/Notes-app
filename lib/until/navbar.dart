import 'package:flutter/material.dart';
import 'package:notes_app/page/category_page.dart';
import 'package:notes_app/page/change_pasword_page.dart';
import 'package:notes_app/page/dashboard_page.dart';
import 'package:notes_app/page/editprofile_page.dart';
import 'package:notes_app/page/notes_page.dart';
import 'package:notes_app/page/priority_page.dart';
import 'package:notes_app/page/signin_page.dart';
import 'package:notes_app/page/status_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  String emailShow = '';
  String firstNameShow = '';
  String lastNameShow = '';
  Future<void> initValue() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      firstNameShow = pref.getString('FirstName')!;
      lastNameShow = pref.getString('LastName')!;
      emailShow = pref.getString('email')!;
    });
  }

  @override
  void initState() {
    super.initState();
    initValue();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('Name: $firstNameShow $lastNameShow'),
            accountEmail: Text('Email: $emailShow'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const DashBoardPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Category'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const CategoryPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.priority_high),
            title: const Text('Priority'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const PriorityPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Status'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const StatusPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text('Note'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const NotesPage(),
                ),
              );
            },
          ),
          const Divider(
            height: 1.5,
            color: Colors.black,
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Account'),
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Profile'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const EditProfilePage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.change_circle),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const ChangePasswordPage(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Exit'),
            onTap: () {
              Navigator.pushReplacement<void, void>(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SignInPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
