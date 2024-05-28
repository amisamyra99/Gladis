import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:repo/views/Authentification/registration.dart';
import 'package:repo/views/Authentification/widget/custom_button.dart';
import 'package:repo/views/Authentification/widget/custom_scaffold.dart';
import 'package:repo/views/Authentification/widget/custom_textfield.dart';
import 'package:repo/views/calendar/monthly_screen_ami.dart';

import '../calendar/monthly_screen2.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _userNameController=TextEditingController();
  final _passController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return  CustomScaffold(
      child:Center(

        child: Container(
          width: size.width*0.8 ,
          height: size.height *0.5,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              const Text('Login',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
              const SizedBox(height: 50,),

              CustomTextField(
                hintText: 'type your username',
                keyboardType: TextInputType.name,
                controller: _userNameController,
                prefixIcon: const Icon(Icons.person),
              ),
              const SizedBox(height: 10,),
              CustomTextField(
                controller: _passController,
                hintText: 'type your password',
               isObscureText: true,
                prefixIcon: const Icon(Icons.password),
                suffixIcon: const Icon(Icons.key_off_outlined),
              ),

              const SizedBox(height: 10,),
              SizedBox(height: 10,),
              GestureDetector(
                  onTap: () {
                    setState(() {


                    });
                  },
                  child: Text("forget password?",style: TextStyle(color: Colors.blue),)),
              SizedBox(height: 10,),
              GestureDetector(
                  onTap: () {
                    setState(() {

                     Get.to(const Registration());
                    });
                  },

                  child:Text("Create a new account?",style: TextStyle(color: Colors.blue),)),



              SizedBox(height: 10,),

              CustomButtonBig(text: 'Connexion', color: Colors.blue,textColor: Colors.white,borderRadius: 20, onPressed:(){
                 Get.to(MonthlyScreen2());
               })
            ],
          ),
        ),
      ),
    );
  }
}
