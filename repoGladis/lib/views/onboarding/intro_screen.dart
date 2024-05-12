import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:repo/views/Authentification/login_screen.dart';
import 'package:repo/views/Authentification/widget/custom_button.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return  Scaffold(

      body: SafeArea(
          child:Stack(
            children: [
              Positioned(
              bottom: 0,
                  child: Container(
                    height: size.height/2,
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.blue,

                    ),
                  )
              ),
              Center(child:
               Container(
                height: size.height,
                width:size.width,
                child: Column(
                  children: [
                    Image.asset('images/logo.png'),
                     SizedBox(height: 20,),
                   Text('Welcome to Synchrononize, where you can seamlessly integrate and synchronize all your calendars,'
                       ' ensuring optimal time management at your fingertips',style: TextStyle(color: Colors.white,fontSize: 16,),textAlign: TextAlign.center,)

                   ],



                )



              ), ),
              Positioned(
                left: size.width/4,
                bottom: 50,
                  child:CustomButtonBig(text: 'Get Started',onPressed: (){
                    Get.to(const Login());
                  },borderRadius: 20,color: Colors.white,textColor: Colors.blue)


              )

            ],
        
      )),
    );
  }
}
