import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors_theme.dart';

class CustomTextTheme {
  static final primaryTitleStyle = GoogleFonts.montserrat(
    color: ColorsTheme.titleLabel,
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static final secundaryTitleStyle = GoogleFonts.montserrat(
    color: ColorsTheme.titleLabel,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  static final categoryTextStyle = GoogleFonts.montserrat(
    color: ColorsTheme.titleLabel,
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );

  static final descriptionStyle = GoogleFonts.montserrat(
    color: ColorsTheme.descriptionLabel,
    fontSize: 11,
    fontWeight: FontWeight.w500,
  );
  static final priceStyle = GoogleFonts.montserrat(
    color: ColorsTheme.titleColorLabel,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}
