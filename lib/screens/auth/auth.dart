import 'dart:async';

import 'package:abetterme/common/enums/units.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:validators/validators.dart';

import '../../common/classes/clippy.dart';
import '../../providers/auth.dart';
import 'password_recovery.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_dialog.dart';
import '../../widgets/common/form_container.dart';
import '../overview.dart';
import '../../widgets/common/centered_logo.dart';

enum AuthMode {
  Login,
  Register,
}

class AuthFormData {
  String email;
  String password;
  double weight;
  Units units = Units.Metric;
}

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  static const double _margin = 20;

  final _authFormKey = GlobalKey<FormState>();
  final _weightFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _authFormData = AuthFormData();

  AuthMode _authMode = AuthMode.Login;
  bool _isLoading = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _weightFocusNode.dispose();
    super.dispose();
  }

  Future<void> _resend(BuildContext ctx) async {
    final authProvider = Provider.of<Auth>(context, listen: false);
    await authProvider.resendVerificationEmail();
    Navigator.pop(ctx);
  }

  Future<void> _submit(BuildContext ctx) async {
    String title;
    String description;
    Function onTap = () => Navigator.of(context).pop();

    if (!_authFormKey.currentState.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authProvider = Provider.of<Auth>(context, listen: false);
    if (_authMode == AuthMode.Login) {
      try {
        final success = await authProvider.login(
          _authFormData.email,
          _authFormData.password,
        );
        if (!success) {
          CustomDialog(
            title: const Text("Email verification"),
            description: const Text(
                "To access the application you must verify your email first."),
            actions: <Widget>[
              CustomButton(
                child: const Text("Resend Email"),
                onTap: () => _resend(ctx),
              ),
              CustomButton(
                child: const Text("Ok"),
                onTap: onTap,
              ),
            ],
          ).show(context);
        } else {
          Navigator.of(context).pushReplacementNamed(OverviewScreen.routeName);
          return;
        }
        setState(() {
          _isLoading = false;
        });
        return;
      } catch (e) {
        title = "Invalid Credentials";
        description =
            "The credentials you have provided are invalid. Please try again.";
      }
    } else {
      try {
        await authProvider.register(
          _authFormData.email,
          _authFormData.password,
          _authFormData.weight,
          _authFormData.units,
        );
        setState(() {
          _authMode = AuthMode.Login;
        });
        title = "Sign Up successful";
        description =
            "Sign Up has been successful. To complete the Sign Up process please verify your email.";
      } catch (e) {
        title = "Sign Up error";
        description = e.message;
      }
    }
    setState(() {
      _isLoading = false;
    });
    CustomDialog.appDialog(
      titleText: title,
      descriptionText: description,
      onTap: onTap,
    ).show(context);
  }

  void _changeAuthMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.Register;
      } else {
        _authMode = AuthMode.Login;
      }
    });
  }

  String _validateEmail(String email) {
    if (email.isEmpty) {
      return 'Please enter your email.';
    }

    if (!isEmail(email)) {
      return 'The inputed value must be a valid email';
    }

    return null;
  }

  String _validatePassword(String password) {
    if (password.isEmpty) {
      return 'Please enter your password.';
    }

    if (!isLength(password, 6)) {
      return 'Password must be at least 6 characters long.';
    }

    return null;
  }

  String _validateWeight(String weight) {
    if (weight.isEmpty) {
      return 'Please enter your weight';
    }

    if (!isNumeric(weight)) {
      return 'Please enter a valid number';
    }

    if (double.parse(weight) <= 0) {
      return 'Please enter a valid weight';
    }

    return null;
  }

  Widget _buildLogoContainer({Widget child, double screenHeight}) {
    return ClipPath(
      clipper: HalfOvalClipper(),
      child: Container(
        width: double.infinity,
        height: screenHeight * 0.35,
        decoration: BoxDecoration(
          color: Colors.orange,
        ),
        child: child,
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
                decoration: BoxDecoration(
                  color: Color.fromRGBO(247, 247, 247, 1),
                ),
                child: Column(
                  children: <Widget>[
                    _buildLogoContainer(
                      screenHeight: screenHeight,
                      child: CenteredLogo(),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: _margin,
                        bottom: _margin,
                        left: _margin,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _authMode == AuthMode.Login ? "Sign In" : "Sign Up",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Form(
                      key: _authFormKey,
                      child: FormChildContainer(
                        margin: const EdgeInsets.symmetric(horizontal: _margin),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: "Email ID",
                                suffixIcon: Icon(Icons.email),
                                isDense: true,
                              ),
                              validator: _validateEmail,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              onFieldSubmitted: (_) =>
                                  _authMode == AuthMode.Login
                                      ? _passwordFocusNode.requestFocus()
                                      : _weightFocusNode.requestFocus(),
                              onChanged: (value) => _authFormData.email = value,
                            ),
                            if (_authMode == AuthMode.Register) ...[
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Weight",
                                  isDense: true,
                                ),
                                keyboardType: TextInputType.number,
                                validator: _validateWeight,
                                focusNode: _weightFocusNode,
                                onChanged: (value) => _authFormData.weight =
                                    double.tryParse(value),
                              ),
                              DropDownFormField(
                                titleText: 'Unit of measurement',
                                value: _authFormData.units,
                                onChanged: (value) {
                                  setState(() {
                                    _authFormData.units = value as Units;
                                  });
                                },
                                dataSource: [
                                  {
                                    "display": "Metric",
                                    "value": Units.Metric,
                                  },
                                  {
                                    "display": "Imperic",
                                    "value": Units.Imperic,
                                  },
                                ],
                                textField: 'display',
                                valueField: 'value',
                              ),
                            ],
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: "Password",
                                isDense: true,
                                suffixIcon: InkWell(
                                  onTap: () => setState(
                                      () => _hidePassword = !_hidePassword),
                                  child: Icon(
                                    _hidePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                              ),
                              validator: _validatePassword,
                              obscureText: _hidePassword,
                              focusNode: _passwordFocusNode,
                              onChanged: (value) =>
                                  _authFormData.password = value,
                              onFieldSubmitted: (_) => _submit(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: _margin),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          if (_authMode == AuthMode.Login)
                            GestureDetector(
                              onTap: () => Navigator.of(context)
                                  .pushReplacementNamed(
                                      PasswordRecoveryScreen.routeName),
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          CustomButton(
                            onTap: () => _submit(context),
                            child: Text(_authMode == AuthMode.Login
                                ? "Sign In"
                                : "Sign Up"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: GestureDetector(
                        onTap: () => _changeAuthMode(),
                        child: Text(
                          _authMode == AuthMode.Login
                              ? "Don't have an account? Sign Up."
                              : "Already have an account? Sign In.",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
