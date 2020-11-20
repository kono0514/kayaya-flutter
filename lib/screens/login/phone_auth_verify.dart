import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';
import 'package:kayaya_flutter/screens/login/phone_auth_error.dart';
import 'package:kayaya_flutter/widgets/spinner_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class LoginPhoneAuthVerifyPage extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;

  const LoginPhoneAuthVerifyPage({
    Key key,
    @required this.verificationId,
    @required this.phoneNumber,
  }) : super(key: key);

  @override
  _LoginPhoneAuthVerifyPageState createState() =>
      _LoginPhoneAuthVerifyPageState();
}

class _LoginPhoneAuthVerifyPageState extends State<LoginPhoneAuthVerifyPage> {
  final TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthenticationRepository _authRepo;
  FirebaseAuthException _authException;
  bool _verifying = false;
  String _currentCode = '';

  @override
  void initState() {
    super.initState();
    _authRepo = context.read<AuthenticationRepository>();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 36.0, vertical: 60.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Verify SMS code',
                style: _theme.textTheme.headline4.apply(
                  color: _theme.textTheme.bodyText1.color,
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${widget.phoneNumber} дугаарт явуулсан 6 оронтой кодыг оруулна уу',
              ),
              SizedBox(height: 30),
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: textEditingController,
                autoFocus: true,
                autovalidateMode: AutovalidateMode.disabled,
                keyboardType: TextInputType.phone,
                animationType: AnimationType.none,
                backgroundColor: Colors.transparent,
                cursorColor: _theme.cursorColor,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                textStyle: _theme.textTheme.bodyText1.copyWith(fontSize: 20),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'OTP code required';
                  }
                  if (value.length != 6) {
                    return 'Code must be 6 digit long';
                  }
                  if (num.tryParse(value) == null) {
                    return 'Code must contain digits only';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _currentCode = value;
                  });
                },
              ),
              if (_authException != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FirebaseAuthError(_authException),
                ),
              SizedBox(height: 20),
              SpinnerButton(
                label: Text('Verify'),
                loading: _verifying,
                onPressed: _submitCode,
              ),
              TextButton(
                child: Text('Change number'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _submitCode() async {
    if (!_formKey.currentState.validate()) return;

    setState(() {
      _verifying = true;
      _authException = null;
    });
    try {
      await _authRepo.signInWithPhoneNumberVerify(
        verificationId: widget.verificationId,
        code: _currentCode,
      );
    } on FirebaseAuthException catch (e) {
      _formKey.currentState.reset();
      textEditingController.text = '';
      setState(() {
        _currentCode = '';
        _authException = e;
      });
    }
    if (mounted) {
      setState(() {
        _verifying = false;
      });
    }
  }
}
