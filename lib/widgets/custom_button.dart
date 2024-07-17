import 'package:chitthi/colors.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onpressed;
  const CustomButton({super.key , required this.text, required this.onpressed}); 

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        
        backgroundColor: tabColor,
        minimumSize: const Size(double.infinity, 50)
      ),
      onPressed: onpressed,
      child: Text(text,style: const TextStyle(color: blackcolor),)
    );
  }
}