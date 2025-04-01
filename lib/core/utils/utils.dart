import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final Random random = Random();

final dateFormat = DateFormat("yyyy-MM-dd");

String formatDate(String dateStr) => DateFormat('MMM dd, yyyy').format(DateTime.parse(dateStr));

// Function to generate a random string of length between 3 and 20
String generateRandomString(int minLength, int maxLength) {
  int length = (minLength + random.nextInt(maxLength - minLength + 1));
  const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ),
  );
}

String formattedDate(String dateString,{String? inputFormatString="MMM dd, yyyy"}) {
  try {
    var inputFormat = DateFormat(inputFormatString);
    DateTime parsedDate = inputFormat.parse(dateString);
    return DateFormat('yyyy-MM-dd').format(parsedDate);
  } catch (e) {
    return "Invalid Date"; // Handle invalid date input
  }
}

String dateTime2String(DateTime? date) {
  if(date==null) {
    return "Invalid Date"; // Handle invalid date input
  }
  try {
  return DateFormat('MMM dd, yyyy').format(date);
  } catch (e) {
    return "Invalid Date"; // Handle invalid date input
  }// Change format as needed
}

double generateRandomDouble() {
  Random random = Random();
  return 0.2 +
      random.nextDouble() *
          (0.7 - 0.2); // Generates a number between 0.2 and 0.7
}

int generateRandomNumber() {
  Random random = Random();
  return 20 +
      random.nextInt(71); // Generates a number between 20 and 90 (inclusive)
}

final List<Color> predefinedColors = [
  const Color(0xfffdcb6e), // Yellow
  const Color(0xff0984e3), // Blue
  const Color(0xfffd79a8), // Pink
  const Color(0xffe17055), // Orange
  const Color(0xff6c5ce7), // Purple
  const Color(0xff00cec9), // Cyan
  const Color(0xffd63031), // Red
  const Color(0xff74b9ff), // Light Blue
  const Color(0xff55efc4), // Mint
  const Color(0xfffab1a0), // Soft Red
  const Color(0xff636e72), // Dark Gray
  const Color(0xffa29bfe), // Light Purple
  const Color(0xffffeaa7), // Light Yellow
  const Color(0xfffd9644), // Bright Orange
  const Color(0xff2d98da), // Deep Blue
  const Color(0xff26de81), // Green
  const Color(0xffff6b81), // Coral
  const Color(0xffa55eea), // Deep Purple
  const Color(0xff778ca3), // Muted Blue Gray
  const Color(0xff4b6584), // Steely Blue
  const Color(0xff20bf6b), // Forest Green
  const Color(0xfff7b731), // Sunflower
  const Color(0xffeb3b5a), // Bright Red
  const Color(0xfffa8231), // Vivid Orange
  const Color(0xff3867d6), // Royal Blue
  const Color(0xff45aaf2), // Soft Blue
  const Color(0xffd1d8e0), // Light Gray
  const Color(0xff8e44ad), // Deep Violet
  const Color(0xffc0392b), // Dark Red
  const Color(0xff1abc9c), // Turquoise
  const Color(0xfff39c12), // Golden Yellow
  const Color(0xffe84393), // Magenta
  const Color(0xff2ecc71), // Emerald Green
  const Color(0xff3498db), // Strong Blue
  const Color(0xff9b59b6), // Amethyst
  const Color(0xff34495e), // Midnight Blue
  const Color(0xff16a085), // Deep Teal
  const Color(0xff27ae60), // Green Leaf
  const Color(0xfff1c40f), // Bright Yellow
  const Color(0xffe74c3c), // Scarlet
  const Color(0xff7f8c8d), // Concrete Gray
  const Color(0xffbdc3c7), // Silver Gray
  const Color(0xff2c3e50), // Dark Night Blue
  const Color(0xff95a5a6), // Subtle Gray
  const Color(0xffffbe76), // Warm Orange
  const Color(0xff6ab04c), // Fresh Green
  const Color(0xff130f40), // Deep Navy
  const Color(0xff4834d4), // Electric Blue
  const Color(0xffbe2edd), // Vivid Purple
  const Color(0xff22a6b3), // Aquamarine
  const Color(0xff30336b), // Dark Indigo
];


const List<Color> defaultColorList = [
  Color(0xFFff7675),
  Color(0xFF74b9ff),
  Color(0xFF55efc4),
  Color(0xFFffeaa7),
  Color(0xFFa29bfe),
  Color(0xFFfd79a8),
  Color(0xFFe17055),
  Color(0xFF00b894),
];

Color getColor(List<Color> colorList, int index) {
  if (index > (colorList.length - 1)) {
    final newIndex = index % (colorList.length - 1);
    return colorList.elementAt(newIndex);
  }
  return colorList.elementAt(index);
}

List<Color> getGradient(List<List<Color>> gradientList, int index,
    {required bool isNonGradientElementPresent,
      required List<Color> emptyColorGradient}) {
  index = isNonGradientElementPresent ? index - 1 : index;
  if (index == -1) {
    return emptyColorGradient;
  } else if (index > (gradientList.length - 1)) {
    final newIndex = index % gradientList.length;
    return gradientList.elementAt(newIndex);
  }
  return gradientList.elementAt(index);
}


String calculateDuration({required String startDate, required String endDate}) {
  // DateFormat format = DateFormat("MMM d, yyyy");

  DateTime start = dateFormat.parse(startDate);
  DateTime end = dateFormat.parse(endDate);

  int difference = end.difference(start).inDays;

  return difference > 0 ? '$difference Days' : '1 Day';
}

int calculateDurationInDays({
  required String startDate,
  required String endDate,
}) {
  // DateFormat format = DateFormat("MMM d, yyyy");

  DateTime start = dateFormat.parse(startDate);
  DateTime end = dateFormat.parse(endDate);

  int difference = end.difference(start).inDays;
  if (difference > 0) {
    return difference;
  } else {
    return 1;
  }
}

String formatDateRange({required String startDate, required String endDate}) {
  // DateFormat inputFormat = DateFormat("MMM d, yyyy");
  DateTime start = dateFormat.parse(startDate);
  DateTime end = dateFormat.parse(endDate);

  DateFormat sameYearFormat = DateFormat("MMM d");
  DateFormat differentYearFormat = DateFormat("MMM d, yyyy");

  if (start.year == end.year) {
    return "${sameYearFormat.format(start)} - ${sameYearFormat.format(end)}, ${end.year}";
  } else {
    return "${differentYearFormat.format(start)} - ${differentYearFormat.format(end)}";
  }
}


