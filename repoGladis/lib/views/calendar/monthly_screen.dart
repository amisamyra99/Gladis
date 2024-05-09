import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class MonthlyScreen extends StatelessWidget {
  const MonthlyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    var size= MediaQuery.of(context).size;
    final isDialOpen=ValueNotifier(false);
    return  WillPopScope(
      onWillPop: ()async {
        if(isDialOpen.value){
          isDialOpen.value=false;
          return false;
        }
        else{
          return true;
        }
      },
      child: Scaffold(
      
        body: SafeArea(
          child: SfCalendar(
            view: CalendarView.month,
      
            showTodayButton: true,
            showDatePickerButton: true,
            monthViewSettings: const MonthViewSettings(
              agendaStyle: AgendaStyle(
      
              ),
              showTrailingAndLeadingDates: false,
              showAgenda: true,
              agendaViewHeight: 400,
      
            ),
      
          ),
        ),
        floatingActionButton: Row(
                  children: [
                    InkWell(
      
      
                      onTap: (){
      
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(50,0,0,5),
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Icon(Icons.mic_rounded,color: Colors.white,),
                      ),
      
      
                    ),
                    SizedBox(width: size.width * 0.60,),
                    SpeedDial(
                      animatedIcon: AnimatedIcons.add_event,
                      animatedIconTheme: const IconThemeData(color: Colors.white),

                      activeBackgroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      closeManually: true,
                      openCloseDial: isDialOpen,
                      curve: Curves.bounceIn,
                      children: [
                        SpeedDialChild(
                          elevation: 0,
                          child: const Icon(Icons.event,color: Colors.white,),
                          backgroundColor: Colors.blue,
                          label: 'Create Event',
                          labelBackgroundColor: Colors.blue,
                          labelStyle: const TextStyle(color: Colors.white),
                          onTap: (){
      
                          }
      
      
      
                        ),

                      ],
                    )
                    /*InkWell(
                      onTap: (){
      
                      },
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(0,0,0,5),
                        height: 50,
                        width: 50,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.blue,borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Icon(Icons.add,color: Colors.white,),
                      ),
      
      
                    )*/
      
      
      
      
                  ],
                ),
      ),
    );
  }
}
