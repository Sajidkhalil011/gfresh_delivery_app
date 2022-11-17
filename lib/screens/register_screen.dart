import 'package:flutter/material.dart';
import 'package:gfresh_delivery_app/providers/auth_provider.dart';
import 'package:gfresh_delivery_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/image_picker.dart';
import '../widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  static const String id= 'register-screen';
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authData=Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                ShopPicCard(),
                RegisterForm(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
