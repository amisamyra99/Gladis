import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/views/Authentification/login_screen.dart';
import 'package:repo/views/calendar/monthly_screen_chriz.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';


class MyAppBar extends StatelessWidget implements PreferredSizeWidget{
  const MyAppBar({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
            "GladisAI",
            style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 4,
        backgroundColor: Colors.blue,
        leading: PopupMenuButton(
      icon: Icon(
      Icons.more_vert,
        color: Colors.white,),
      itemBuilder: (context)=>[
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.calendar_view_day, color: Colors.black,),
              SizedBox(width: 8),
              Text("Day")
            ],
          ),
          value: "day",
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.calendar_view_week, color: Colors.black,),
              SizedBox(width: 8),
              Text("Week")
            ],
          ),
          value: "week",
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.calendar_view_month, color: Colors.black,),
              SizedBox(width: 8),
              Text("Month")
            ],
          ),
          value: "month",
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.schedule, color: Colors.black,),
              SizedBox(width: 8),
              Text("Schedule")
            ],
          ),
          value: "schedule",
        ),
      ],
      onSelected: (String value){
        if(value == "day"){
         Get.to(Login());
        }
        else if(value == "week"){
          Get.to(Login());

        }
        else if(value == "month"){
          Get.to(MonthlyScreen());
        }
      },
    ),
        actions: [
          _buildUserMenu(context)
        ],


      ),
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

Widget _buildUserMenu(BuildContext context) {
  return PopupMenuButton<String>(
    icon: Icon(Icons.person, color: Colors.white), // Customize the icon for the user menu
    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'Profile',
        child: Row(
          children: [
            Icon(Icons.verified_user, color: Colors.black,),
            SizedBox(width: 8),
            Text("UserName")
          ],
        ),
      ),
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: 'Profile',
        child: Row(
          children: [
            Icon(Icons.person_2_outlined, color: Colors.black,),
            SizedBox(width: 8),
            Text("Profile")
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'Setting',
        child: Row(
          children: [
            Icon(Icons.settings, color: Colors.black,),
            SizedBox(width: 8),
            Text("Setting")
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'Logout',
        child: Row(
          children: [
            Icon(Icons.logout, color: Colors.red,),
            SizedBox(width: 8),
            Text("Logout")
          ],
        ),
      ),
    ],
    onSelected: (String value) {
      if (value == 'Profile') {
        // Add Profile logic here
      } else if (value == 'Settings') {
        // Add settings logic here
      }
      else{
        //Add logout logic here
      }
    },
  );
}

