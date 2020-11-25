import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kayaya_flutter/core/widgets/spinner_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../login.dart';

class LoginPhoneAuthVerifyPage extends StatefulWidget {
  const LoginPhoneAuthVerifyPage({Key key}) : super(key: key);

  @override
  _LoginPhoneAuthVerifyPageState createState() =>
      _LoginPhoneAuthVerifyPageState();
}

class _LoginPhoneAuthVerifyPageState extends State<LoginPhoneAuthVerifyPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BlocListener<LoginPhoneCubit, LoginPhoneState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == LoginPhoneStatus.verifyError) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.exception?.message ?? 'Wrong code?'),
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.fromLTRB(36.0, 5.0, 36.0, 10.0),
                ),
              );
          }
        },
        child: Container(
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
                Builder(builder: (context) {
                  final _number = context.select(
                      (LoginPhoneCubit cubit) => cubit.state.phoneNumber);
                  return Text(
                    '$_number дугаарт явуулсан 6 оронтой кодыг оруулна уу',
                  );
                }),
                SizedBox(height: 30),
                _PinInput(),
                SizedBox(height: 20),
                _VerifyButton(
                  formKey: _formKey,
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
      ),
    );
  }
}

class _VerifyButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const _VerifyButton({Key key, @required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status =
        context.select((LoginPhoneCubit cubit) => cubit.state.status);

    return SpinnerButton(
      label: Text('Verify'),
      loading: status == LoginPhoneStatus.verifying,
      onPressed: () {
        if (formKey.currentState.validate()) {
          context.read<LoginPhoneCubit>().verifySMSCode();
        }
      },
    );
  }
}

class _PinInput extends StatefulWidget {
  const _PinInput({Key key}) : super(key: key);

  @override
  __PinInputState createState() => __PinInputState();
}

class __PinInputState extends State<_PinInput> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return BlocListener<LoginPhoneCubit, LoginPhoneState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoginPhoneStatus.verifyError) {
          textEditingController.text = '';
        }
      },
      child: PinCodeTextField(
        appContext: context,
        length: 6,
        controller: textEditingController,
        autoDisposeControllers: true,
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
          context.read<LoginPhoneCubit>().otpChanged(value);
        },
      ),
    );
  }
}
