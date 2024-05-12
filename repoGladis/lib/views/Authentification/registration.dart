

import 'package:flutter/material.dart';
import 'package:repo/views/Authentification/widget/custom_button.dart';
import 'package:repo/views/Authentification/widget/custom_scaffold.dart';
import 'package:repo/views/Authentification/widget/custom_textfield.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _userNameController=TextEditingController();
  final _emailController=TextEditingController();
  final _passController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;

    return   CustomScaffold(
      child: Center(
        child: Container(
          width: size.width*0.8 ,
          height: size.height *0.5,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              const Text('Registration', style: TextStyle(fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),),
              const SizedBox(height: 50,),

              CustomTextField(controller: _userNameController, hintText: 'username',prefixIcon: Icon(Icons.person),),
              const SizedBox(height: 10,),
              CustomTextField(controller: _emailController, hintText: 'email',prefixIcon: Icon(Icons.email_outlined),),
              const SizedBox(height: 10,),

              CustomTextField(controller: _passController, hintText: 'password',prefixIcon: Icon(Icons.password),),
              const SizedBox(height: 10,),

              CustomButtonBig(text: 'Register', onPressed: (){},borderRadius: 50,color: Colors.blue,textColor: Colors.white,)

            ],
          ),
        ),
      ),
    );
  }
}
