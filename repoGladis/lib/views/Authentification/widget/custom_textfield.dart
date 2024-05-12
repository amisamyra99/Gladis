



import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscureText;
  final String? obscureCharacter;
  final String hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  const CustomTextField({super.key,
    required this.controller,
    this.keyboardType=TextInputType.text,
     this.isObscureText=false,
     this.obscureCharacter='*',
     required this.hintText,
    this.prefixIcon,
    this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return  TextFormField(
      controller:controller ,
      keyboardType: keyboardType,
      obscureText:isObscureText! ,
      obscuringCharacter: obscureCharacter!,
      //style:
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.only(top: 12),
        constraints: BoxConstraints(
          maxHeight: size.height*0.065,
          maxWidth: size.width*0.9 ,
        ),
        filled: true,
       fillColor: Colors.white,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 1.0
          ),

        ),
        prefixIcon: prefixIcon ,
        suffixIcon:suffixIcon ,

      ),
    );
  }
}


class AgendaTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;


  const AgendaTextField({super.key, required this.controller, required this.labelText});

  @override
  Widget build(BuildContext context) {
    return    TextFormField(
      controller: controller,
      decoration:  InputDecoration(
          labelText: labelText!,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }
}

