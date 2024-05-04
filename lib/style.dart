import 'package:flutter/material.dart';

const LIGHT_PURPLE = Color(0xFFDABFFF);
const PURPLE = Color(0xFF907AD6);
const BLUE = Color(0xFF4F518C);
const INDIGO = Color(0xFF2C2A4A);
const LIGHT = Color(0xFFF4F4F5);
const DARK = Color(0xFF161616);
const LIGHT_GREY = Color(0xFFBDBDBD);
const DANGER = Color(0xFFFC515D);
const WARNING = Color(0xFFFFCA2A);
const SUCCESS = Color(0xFF00D06B);

final CustomOutlineBorder = (Color color) => OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 2),
      borderRadius: BorderRadius.circular(8.0),
    );

final InputDecoration LightTextFieldStyle = InputDecoration(
  isDense: true,
  counterText: "",
  filled: true,
  fillColor: Colors.white,
  border: CustomOutlineBorder(LIGHT),
  enabledBorder: CustomOutlineBorder(LIGHT),
  focusedBorder: CustomOutlineBorder(PURPLE),
  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
);

ButtonStyle lightButtonStyle = TextButton.styleFrom(
  backgroundColor: Colors.white,
  shadowColor: Colors.grey,
  elevation: 3,
  side: BorderSide(color: LIGHT, width: 1.5),
);

ButtonStyle primaryButtonStyle = TextButton.styleFrom(
  elevation: 3,
  backgroundColor: BLUE,
  shadowColor: Colors.grey,
);
