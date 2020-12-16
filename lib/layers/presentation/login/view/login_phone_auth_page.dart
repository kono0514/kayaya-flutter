import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/widgets/spinner_button.dart';
import '../../../../locale/generated/l10n.dart';
import '../cubit/login_phone_cubit.dart';
import '../widget/country_code_picker.dart';
import 'login_phone_auth_verify_page.dart';

class LoginPhoneAuthPage extends StatefulWidget {
  LoginPhoneAuthPage({Key key}) : super(key: key);

  @override
  _LoginPhoneAuthPageState createState() => _LoginPhoneAuthPageState();
}

class _LoginPhoneAuthPageState extends State<LoginPhoneAuthPage> {
  final _formKey = GlobalKey<FormState>();
  String _phoneNumber;
  String _dialCode = '+976';

  String get phoneNumber => '$_dialCode$_phoneNumber';

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: BlocProvider(
        create: (context) => GetIt.I<LoginPhoneCubit>(),
        child: BlocListener<LoginPhoneCubit, LoginPhoneState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: (context, state) {
            if (state.status == LoginPhoneStatus.sent) {
              final _cubit = context.read<LoginPhoneCubit>();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: _cubit,
                    child: LoginPhoneAuthVerifyPage(),
                  ),
                ),
              );
            }
            if (state.status == LoginPhoneStatus.sendError) {
              Scaffold.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error ?? 'SMS send failure'),
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
                    TR.of(context).phone_auth_header_text,
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
                        child: _PhoneNumberInput(dialCode: _dialCode),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _SendSMSButton(formKey: _formKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SendSMSButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const _SendSMSButton({Key key, @required this.formKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final status =
        context.select((LoginPhoneCubit cubit) => cubit.state.status);

    return SpinnerButton(
      label: Text(TR.of(context).phone_auth_send_sms),
      loading: status == LoginPhoneStatus.sending,
      onPressed: () {
        if (formKey.currentState.validate()) {
          context.read<LoginPhoneCubit>().sendSMSCode();
        }
      },
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  final String dialCode;

  const _PhoneNumberInput({Key key, @required this.dialCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
        context.read<LoginPhoneCubit>().numberChanged('$dialCode$value');
      },
    );
  }
}
