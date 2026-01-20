import 'package:flutter/material.dart';

class MytransparentTextField extends StatefulWidget {
  // final TextEditingController? controller;
  final IconData prefixIcone;
  final String labeltext;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  const MytransparentTextField({
    super.key,
    //this.controller,
    this.prefixIcone = Icons.fiber_manual_record_rounded,
    this.labeltext = "pas de label",
    this.hintText = "pas de hint",
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<MytransparentTextField> createState() => _MytransparentTextFieldState();
}

class _MytransparentTextFieldState extends State<MytransparentTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        // controller: widget.controller,
        obscureText: widget.isPassword,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w400,
        ),
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          prefixIcon: Icon(widget.prefixIcone, color: Colors.white, size: 30),
          label: Text(
            widget.labeltext,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          hintText: widget.hintText,
          hintStyle: const TextStyle(
            color: Colors.white60,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
