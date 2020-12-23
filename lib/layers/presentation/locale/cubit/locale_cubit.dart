import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

import '../../../../core/services/preferences_service.dart';

part 'locale_state.dart';

@Injectable()
class LocaleCubit extends Cubit<LocaleState> {
  final PreferencesService pref;

  LocaleCubit({@required this.pref}) : super(const LocaleState('mn'));

  Future<void> resolveLocale() async {
    final String languageCode = pref.languageCode;
    emit(LocaleState(languageCode));
  }

  Future<void> changeLocale(String locale) async {
    await pref.setLanguage(locale);
    emit(LocaleState(locale));
  }
}
