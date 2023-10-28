import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_customer/app/core/modules/splash/splash_store.dart';
import 'package:flutter/material.dart';

import '../../../shared/utilities.dart';

class SplashPage extends StatefulWidget {
  final String title;
  const SplashPage({Key? key, this.title = 'SplashPage'}) : super(key: key);
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final SplashStore store = Modular.get();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FirebaseAuth _auth = FirebaseAuth.instance;
      Future.delayed(Duration(seconds: 4), () {
        User? _user = _auth.currentUser;
        if (_user == null) {
          Modular.to.pushReplacementNamed('/sign-phone');
        } else {
          Modular.to.pushReplacementNamed('/main');
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getColors(context).surface,
      body: Container(
        padding: EdgeInsets.symmetric(vertical: wXD(100, context)),
        alignment: Alignment.center,
        child: Image.asset(
          brightness == Brightness.light
              ? "./assets/images/logo.png"
              : "./assets/images/logo_dark.png",
          fit: BoxFit.fitHeight,
          width: maxWidth(context),
        ),
      ),
    );
  }
}
