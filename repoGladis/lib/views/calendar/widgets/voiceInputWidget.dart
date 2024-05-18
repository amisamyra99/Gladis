import 'package:flutter/material.dart';

class VoiceInputWidget extends StatelessWidget {
  final VoidCallback onTap;
  final double size; // Add a size property for customization
  const VoiceInputWidget({super.key, required this.onTap, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(size / 2), // Dynamic radius
        ),
        child: Icon(Icons.mic_rounded,
            color: Colors.white, size: size * 0.6), // Dynamic icon size
      ),
    );
  }
}