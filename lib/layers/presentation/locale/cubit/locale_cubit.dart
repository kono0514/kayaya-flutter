import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/services/preferences_service.dart';

part 'locale_state.dart';

@Injectable()
class LocaleCubit extends Cubit<LocaleState> {
  final PreferencesService pref;

  LocaleCubit({@required this.pref}) : super(LocaleState('mn'));

  void resolveLocale() async {
    String languageCode = pref.languageCode;
    emit(LocaleState(languageCode));
  }

  void changeLocale(String locale) async {
    await pref.setLanguage(locale);
    emit(LocaleState(locale));
  }
}
