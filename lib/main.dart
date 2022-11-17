import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gfresh_delivery_app/providers/auth_provider.dart';
import 'package:gfresh_delivery_app/screens/home_screen.dart';
import 'package:gfresh_delivery_app/screens/login_screen.dart';
import 'package:gfresh_delivery_app/screens/register_screen.dart';
import 'package:gfresh_delivery_app/screens/reset_password_screen.dart';
import 'package:gfresh_delivery_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main()async{
  Provider.debugCheckInvalidValueType=null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ListenableProvider (create: (_)=>AuthProvider()),
    ],
    child: const MyApp(),
  ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'G-Fresh Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=> const SplashScreen(),
        LoginScreen.id:(context)=> const LoginScreen(),
        HomeScreen.id:(context)=> const HomeScreen(),
        ResetPassword.id:(context)=> const ResetPassword(),
        RegisterScreen.id:(context)=> const RegisterScreen(),
      },
    );
  }
}

