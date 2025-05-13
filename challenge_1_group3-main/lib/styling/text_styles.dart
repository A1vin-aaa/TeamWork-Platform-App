import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {
  static TextStyle get title16SemiBold => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );

  static TextStyle get title14Bold => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      );

  static TextStyle get title14Regular => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );
  static TextStyle get title14SemiBold => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      );

  static TextStyle get title13Regular => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );

  static TextStyle get title10Regular => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      );

  static TextStyle get title10Medium => GoogleFonts.poppins(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      );
}
