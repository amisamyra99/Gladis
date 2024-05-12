import 'package:flutter/material.dart';
import 'package:repo/views/Authentification/login_screen.dart';

import 'package:get/get.dart';
import 'package:repo/views/calendar/monthly_screen.dart';
import 'package:repo/views/calendar/monthly_screen2.dart';
import 'package:repo/views/onboarding/intro_screen.dart';




Future<void> main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {

    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gladis Ai',
      theme: ThemeData(


      ),
      // this the first screen that show app when you start the app
      home: const IntroScreen(),
    // this the code use to show floating button on every pages
    builder: (context,child){
        return Scaffold(
          body: child,
              /*floatingActionButton: Row(
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
                  InkWell(
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


                  )
                ],
              ),*/

        );
    },
      // this is where  we add all our app pages
  getPages: const [

  ],

    );
  }
}
