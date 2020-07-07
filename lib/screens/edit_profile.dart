import 'package:abetterme/common/enums/units.dart';
import 'package:abetterme/models/profile/profile.dart';
import 'package:after_init/after_init.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../providers/profiles.dart';
import '../widgets/drawer/app_drawer.dart';
import '../widgets/common/custom_button.dart';
import '../widgets/common/form_container.dart';

class EditProfileScreen extends StatefulWidget {
  static const routeName = "/edit-profile";

  EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with AfterInitMixin<EditProfileScreen> {
  final _editProfileForm = GlobalKey<FormState>();
  Profile _profile;
  bool _isLoading = false;

  @override
  void didInitState() {
    final authProvider = Provider.of<Auth>(context);
    _profile = authProvider.profile;
  }

  TextFormField _buildTFF({
    @required String label,
    @required String initial,
    @required Function valCb,
    Icon icon = const Icon(Icons.email),
    TextInputType tit,
    Function validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: icon,
        isDense: true,
      ),
      readOnly: readOnly,
      initialValue: initial,
      keyboardType: tit ?? TextInputType.text,
      validator: validator,
      onChanged: valCb,
    );
  }

  String _validateNumber(String value) {
    if (double.tryParse(value) == null) return "Please provide a valid number.";
    return null;
  }

  Future<void> _submit() async {
    if (!_editProfileForm.currentState.validate()) return;
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    await Provider.of<Profiles>(context, listen: false).updateProfile(_profile);
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildForm() {
    return Form(
      key: _editProfileForm,
      child: FormChildContainer(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _buildTFF(
              label: "Email ID",
              icon: const Icon(Icons.email),
              initial: _profile.email,
              readOnly: true,
              valCb: (_) {},
            ),
            _buildTFF(
              label: "Weight",
              icon: const Icon(Icons.healing),
              tit: TextInputType.number,
              initial: _profile.weight.toString(),
              validator: _validateNumber,
              valCb: (String value) => setState(
                () => _profile.weight = double.tryParse(value),
              ),
            ),
            DropDownFormField(
              titleText: 'Unit of measurement',
              value: _profile.units,
              onChanged: (value) {
                setState(() {
                  _profile.units = value as Units;
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit profile"),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: SpinKitWave(
                color: Colors.grey,
              ),
            )
          : Consumer<Auth>(
              builder: (ctx, authProvider, _) {
                return SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        _buildForm(),
                        CustomButton(
                          child: const Text("Update"),
                          onTap: _submit,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
