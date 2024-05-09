import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                  child: Container(
                                  height: 50,
                                  width: 200,
                                  decoration: BoxDecoration(
                                  color: Colors.white,
                                      borderRadius: BorderRadius.circular(50)
                                   

                                ),
                    child: Center(child: Text('Get Started',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),)),
                  )
              )

            ],
        
      )),
    );
  }
}
