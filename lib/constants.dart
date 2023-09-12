import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;

Future<dynamic> navigateWithoutBack(BuildContext context,Widget screen) =>
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => screen), (route) => false);

Future<dynamic> navigateWithBack(BuildContext context,Widget screen) =>
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => screen));

myLogo(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  final isDarkMode = brightness == Brightness.dark;

  return Image.asset(
    isDarkMode ? 'assets/images/Logo_dark.png' : 'assets/images/logo_light.png',
    height: 100,
    width: 100,
  );
}


class AuthFormField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?) validator;
  final Widget? suffixIcon;

  const AuthFormField({
    super.key,
    this.obscureText = false,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
