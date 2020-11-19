import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/repositories/authentication_repository.dart';
import 'package:kayaya_flutter/screens/login/phone_auth_error.dart';
import 'package:kayaya_flutter/screens/login/phone_auth_verify.dart';
import 'package:kayaya_flutter/widgets/country_code_picker/country_code_picker.dart';
import 'package:kayaya_flutter/widgets/spinner_button.dart';

class LoginPhoneAuthPage extends StatefulWidget {
  LoginPhoneAuthPage({Key key}) : super(key: key);

  @override
  _LoginPhoneAuthPageState createState() => _LoginPhoneAuthPageState();
}

class _LoginPhoneAuthPageState extends State<LoginPhoneAuthPage> {
  final _formKey = GlobalKey<FormState>();
  AuthenticationRepository _authRepo;
  FirebaseAuthException _authException;
  String _phoneNumber;
  String _dialCode = '+976';
  bool _sendingCode = false;

  String get phoneNumber => '$_dialCode$_phoneNumber';

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
                'Sign up using your phone number',
                style: _theme.textTheme.headline4.apply(
                  color: _theme.textTheme.bodyText1.color,
                ),
              ),
              SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CountryCodePicker(
                    defaultSelection: 'MN',
                    favorites: ['MN', 'US'],
                    onChanged: (value) {
                      setState(() {
                        _dialCode = value;
                      });
                    },
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Phone number',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Phone number required';
                        }
                        if (num.tryParse(value) == null) {
                          return 'Please enter a correct phone number';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (_authException != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FirebaseAuthError(_authException),
                ),
              SizedBox(height: 20),
              SpinnerButton(
                label: Text('Send SMS code'),
                loading: _sendingCode,
                onPressed: _sendCode,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendCode() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _sendingCode = true;
        _authException = null;
      });
      _authRepo.signInWithPhoneNumberSend(
        phoneNumber: phoneNumber,
        verificationCompleted: () {
          // We don't need to do anything here.
          // AuthenticationBloc does popping/pushing screens
          // based on login state automatically
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _sendingCode = false;
            _authException = e;
          });
        },
        codeSent: (verificationId) {
          setState(() {
            _sendingCode = false;
            _authException = null;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPhoneAuthVerifyPage(
                phoneNumber: phoneNumber,
                verificationId: verificationId,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (_) => {},
      );
    }
  }
}
