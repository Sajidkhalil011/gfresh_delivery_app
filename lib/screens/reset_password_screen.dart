import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gfresh_delivery_app/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id='reset-screen';
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey=GlobalKey<FormState>();
  var _emailTextController=TextEditingController();
  String? email;
  bool _loading=false;

  @override
  Widget build(BuildContext context) {
    final _authData=Provider.of<AuthProvider>(context);
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/forgot.png',height: 150,width: 150,),
                SizedBox(height: 20,),
                RichText(text: TextSpan(
                    text: '',
                    children: [
                      TextSpan(text: 'Forgot Password',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red,fontSize: 15)),
                      TextSpan(text: ' Don\'t worry, provide us with your registered Email, we will send you an email to reset your password',
                          style: TextStyle(color: Colors.red,fontSize: 15)),
                    ]
                ),),
                SizedBox(height: 10,),
                TextFormField(
                  controller:_emailTextController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Enter Email';
                    }
                    final bool _isvalid=EmailValidator.validate(_emailTextController.text);
                    if(!_isvalid){
                      return 'Invalid Email Format';
                    }
                    setState(() {
                      email=value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(),
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Theme.of(context).primaryColor,width: 2),
                      ),
                      focusColor: Theme.of(context).primaryColor
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color(0xff84c225))
                        ),
                        onPressed: (){
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              _loading=true;
                            });
                            _authData.resetPassword(email);
                            ScaffoldMessenger
                                .of(context).
                            showSnackBar(SnackBar(content: Text('Check your Email ${_emailTextController.text} for reset link'),));
                          }
                          Navigator.pushReplacementNamed(context, LoginScreen.id);
                        },
                        child: _loading ? LinearProgressIndicator() : Text('Reset Password',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
