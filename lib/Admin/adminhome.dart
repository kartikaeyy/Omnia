import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:omnia/Resources/Theme/theme.dart';
// import 'package:omnia/Screens/Events/events.dart';
import 'package:omnia/Screens/Events/latest.dart';
import 'package:omnia/Screens/Home/events_desc.dart';
import 'package:omnia/Screens/Menu/menu.dart';
import 'package:omnia/cardvalues.dart';
// import 'package:url_launcher/url_launcher_string.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  String upcomingImageUrl = "https://firebasestorage.googleapis.com/v0/b/omnia-acm.appspot.com/o/Upcoming%20Events%2FTechoween.png?alt=media&token=6972ace8-67b1-46ac-9ab4-541b141b816a";

  void _navigateToDetailsPage(String heading, String subheading, String imageUrl,
      String eventsDescription, List<String> eventsgallery) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsPage(
          heading: heading,
          subheading: subheading,
          imageUrl: imageUrl,
          eventsDescription: eventsDescription,
          eventsgallery: eventsgallery,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const Menu(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: primaryColor,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Image.asset(
            "assets/name.png",
            height: 50,
          ),
        ),
        centerTitle: false,
      ),
      backgroundColor: primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  color: Colors.transparent,
                  child: const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Make Events PLIS",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: LatestEvent(),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Popular Events",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: homeCardNo,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _navigateToDetailsPage(
                        homeHeadings[index],
                        homeSubheadings[index],
                        homeImagesList[index],
                        eventsDescription[index],
                        eventsgallery[index],
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [
                            gradientColor2,
                            gradientColor1,
                          ]),
                          border: Border.all(color: itemColor),
                          borderRadius: BorderRadius.circular(10),
                          color: cardColor,
                        ),
                        height: 120,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.asset(
                                      homeImagesList[index],
                                      alignment: Alignment.center,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                                      child: Container(
                                        color: Colors.black.withValues(alpha: 0.3),
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          homeHeadings[index],
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          homeSubheadings[index],
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            
          },  
          label: const Text('Add Event'),
          icon: const Icon(Icons.add),
        ),
    );
  }
}
