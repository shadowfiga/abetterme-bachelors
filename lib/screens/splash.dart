import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/common/centered_logo.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CenteredLogo(),
          SizedBox(
            height: 30,
          ),
          SpinKitWave(
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
