import 'package:flutter/material.dart';
import 'package:guccigang/config/palette.dart';
import 'package:guccigang/widgets/text_field_container.dart';

class RoundedPasswordField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    Key key,
    this.onChanged,
  }) : super(key: key);

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _passwordVisible = false;

  @override
  void initState() {
    _passwordVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: !_passwordVisible,
        onChanged: widget.onChanged,
        cursorColor: Palette.kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Enter Password",
          icon: Icon(
            Icons.lock,
            color: Palette.kPrimaryColor,
          ),
          suffixIcon: IconButton(
              icon: Icon(
                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: Palette.kPrimaryColor,
              ),
              color: Theme.of(context).primaryColorDark,
              onPressed: () {
                setState(() {
                  _passwordVisible = !_passwordVisible;
                });
              }),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
