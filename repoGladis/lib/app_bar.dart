import 'package:flutter/material.dart';
import 'package:repo/views/calendar/monthly_screen.dart';
import 'package:repo/views/calendar/weekly_screen.dart';
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
        actions: [
          PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,),
              itemBuilder: (context)=>[
                PopupMenuItem(child: Text("Day"), value: "day",),
                PopupMenuItem(child: Text("Week"), value: "week",),
                PopupMenuItem(child: Text("Month"), value: "month",),
                PopupMenuItem(child: Text("Schedules"), value: "schedule",)
              ],
            onSelected: (String value){
                if(value == "day"){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>MonthlyScreen()),
                  );
                }
                else if(value == "week"){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>WeeklyScreen()),
                  );
                }
                else if(value == "month"){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>MonthlyScreen()),
                  );
                }
            },
          )
        ],
      ),
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

