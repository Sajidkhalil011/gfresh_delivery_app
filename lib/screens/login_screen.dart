import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gfresh_delivery_app/screens/register_screen.dart';
import 'package:gfresh_delivery_app/screens/reset_password_screen.dart';
import 'package:gfresh_delivery_app/services/firebase_services.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'home_screen.dart';


class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseServices _services=FirebaseServices();
  final _formKey = GlobalKey<FormState>();
  Icon? icon;
  bool _visible = false;
  final _emailTextController = TextEditingController();
  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/logo-1.png', height: 100,
                              width: 100,
                            ),
                            FittedBox(
                              child: Text('DELIVERY BOY - LOGIN', style: TextStyle(fontFamily: 'Anton',
                                 fontWeight: FontWeight.bold,fontSize: 20),),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _emailTextController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Email';
                          }
                          final bool _isvalid = EmailValidator.validate(
                              _emailTextController.text);
                          if (!_isvalid) {
                            return 'Invalid Email Format';
                          }
                          setState(() {
                            email = value;
                          });
                          return null;
                        },
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Email',
                            prefixIcon: Icon(Icons.email_outlined),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme
                                  .of(context)
                                  .primaryColor, width: 2),
                            ),
                            focusColor: Theme
                                .of(context)
                                .primaryColor
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Password';
                          }
                          if (value.length < 6) {
                            return 'Minimum 6 Characters';
                          }
                          setState(() {
                            password = value;
                          });
                          return null;
                        },
                        obscureText: _visible == false ? true : false,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: _visible ? Icon(Icons.visibility) : Icon(
                                  Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _visible = !_visible;
                                });
                              },),
                            enabledBorder: OutlineInputBorder(),
                            contentPadding: EdgeInsets.zero,
                            hintText: 'Password',
                            prefixIcon: Icon(Icons.vpn_key_outlined),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme
                                  .of(context)
                                  .primaryColor, width: 2),
                            ),
                            focusColor: Theme
                                .of(context)
                                .primaryColor
                        ),
                      ),
                      SizedBox(height: 10,),
                     /* Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, ResetPassword.id);
                              },
                              child: Text('Forgot Password ? ',
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.blue,
                                    fontWeight: FontWeight.bold),)),
                        ],
                      ),*/
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              child: Text('Login', style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  EasyLoading.show(status: 'Please wait...');
                                  _services.validateUser(email).then((value){
                                    if(value.exists){
                                      if(value['password']==password){
                                        _authData.loginBoys(email, password).then((
                                            credential) {
                                          if (credential != null) {
                                            EasyLoading.showSuccess('Logged In Successfully').then((value){
                                              Navigator.pushReplacementNamed(
                                                  context, HomeScreen.id);
                                            });
                                          } else {
                                            EasyLoading.showInfo('Need to complete Registration').then((value){
                                              _authData.getEmail(email);
                                              Navigator.pushNamed(context, RegisterScreen.id);
                                            });
                                            /*ScaffoldMessenger.
                                            of(context)
                                                .showSnackBar(SnackBar(
                                                content: Text(_authData.error)));*/
                                          }
                                        });
                                      }else{
                                        EasyLoading.showError('Invalid password');
                                      }
                                    }else{
                                      EasyLoading.showError('$email does not registered as our Delivery Boy');
                                    }
                                  });
                                }
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xff84c225)),
                            ),
                          ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
