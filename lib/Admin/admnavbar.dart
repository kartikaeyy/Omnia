import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:omnia/Resources/Theme/theme.dart';
import 'package:omnia/Screens/Community/community.dart';
import 'package:omnia/Admin/adminhome.dart';
import 'package:omnia/Screens/Profile/profile.dart';
import 'package:omnia/Screens/Work/work.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnia/Screens/Signup/auth.dart';

class AdminNav extends StatefulWidget {
  const AdminNav({super.key});

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {

  final User? user = Auth().currentUser;

  final List<Widget> pages = [
    const AdminHome(),
    const Community(),
    const Work(),
    const Profile(),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: Container(
        color: primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: GNav(
            backgroundColor: navColor,
            gap: 8,
            activeColor: itemColor,
            color: Colors.white,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            duration: const Duration(milliseconds: 800),
            tabs: const [
              GButton(
                icon: Icons.home,
                iconSize: 30.0,
              ),
              GButton(
                icon: Icons.people,
                iconSize: 30.0,
              ),
              GButton(
                icon: Icons.work,
                iconSize: 30.0,
              ),
              GButton(
                icon: Icons.person,
                iconSize: 30.0,
              ),
            ],
            selectedIndex: currentPage,
            onTabChange: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
