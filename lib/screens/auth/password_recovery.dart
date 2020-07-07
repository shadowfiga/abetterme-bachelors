import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../common/classes/clippy.dart';
import '../../providers/auth.dart';
import 'auth.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_dialog.dart';
import '../../widgets/common/form_container.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  static const routeName = "/password-recovery";

  @override
  _PasswordRecoveryScreenState createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  static const double _margin = 20;
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _errorText;
  Auth _auth;
  bool _isLoading = false;

  @override
  void initState() {
    _auth = Provider.of<Auth>(context, listen: false);
    super.initState();
  }

  String _validateEmail(String email) {
    if (email.isEmpty) {
      return "Please write your email.";
    }

    if (!isEmail(email)) {
      return "Please write a valid email";
    }

    return null;
  }

  Future<void> _submit(BuildContext ctx) async {
    final formState = _formKey.currentState;
    if (!formState.validate()) return;
    setState(() {
      _isLoading = true;
    });
    try {
      await _auth.recoverPassword(_email);
      CustomDialog.appDialog(
        titleText: "Email sent",
        descriptionText: "Email sent to: $_email",
        // This removes all previous routes until only the login screen remains!
        onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
            AuthScreen.routeName, (Route<dynamic> route) => false),
      ).show(ctx);
    } catch (e) {
      CustomDialog.appDialog(
        titleText: "Invalid email",
        descriptionText: e.message,
        onTap: () => Navigator.of(ctx).pop(),
      ).show(ctx);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _clipPathBuilder({
    double screenHeight,
    Alignment begin,
    Alignment end,
  }) {
    return ClipPath(
      clipper: HalfOvalClipper(),
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.3,
        decoration: BoxDecoration(
          color: Colors.orange,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isLoading
          ? Center(
              child: SpinKitWave(
                color: Colors.grey,
              ),
            )
          : SingleChildScrollView(
              child: Container(
                decoration:
                    BoxDecoration(color: Color.fromRGBO(247, 247, 247, 1)),
                height: screenHeight,
                child: Column(
                  children: <Widget>[
                    _clipPathBuilder(
                      screenHeight: screenHeight,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: _margin),
                      child: Wrap(
                        runSpacing: 12,
                        children: <Widget>[
                          const Text(
                            "Password Recovery",
                            style: TextStyle(fontSize: 24),
                          ),
                          if (_errorText != null)
                            Text(
                              _errorText,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          Form(
                            key: _formKey,
                            child: FormChildContainer(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Email ID",
                                  suffixIcon: const Icon(Icons.email),
                                ),
                                validator: _validateEmail,
                                onChanged: (val) => setState(() {
                                  _email = val;
                                }),
                                onFieldSubmitted: (_) => _submit(context),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CustomButton(
                                child: Row(
                                  children: <Widget>[
                                    const Icon(
                                      Icons.arrow_back,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text("Back"),
                                  ],
                                ),
                                onTap: () => Navigator.of(context)
                                    .pushReplacementNamed(AuthScreen.routeName),
                              ),
                              CustomButton(
                                onTap: () => _submit(context),
                                child: const Text("Submit"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Transform.rotate(
                      angle: -math.pi,
                      child: _clipPathBuilder(
                        screenHeight: screenHeight,
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
