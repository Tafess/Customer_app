import 'package:flutter/material.dart';

Widget text({
  BuildContext? context,
  String? title,
  double? size,
  Color? color,
  FontWeight? fontWeight,
  TextOverflow? overflow, // Corrected to TextOverflow
}) {
  return Text(
    title!,
    style: TextStyle(
      color: color,
      fontWeight: fontWeight ?? FontWeight.w600,
      fontSize: size ?? 14,
    ),
    overflow: overflow ??
        TextOverflow.ellipsis, // Set a default value if not provided
  );
}
