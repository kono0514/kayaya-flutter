import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kayaya_flutter/app.dart';
import 'package:kayaya_flutter/shared/services/shared_preferences_service.dart';
import 'package:kayaya_flutter/utils/simple_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  GetIt.I.registerSingletonAsync(() => SharedPreferencesService().init());
  await GetIt.I.allReady();

  Bloc.observer = SimpleBlocObserver();
  runApp(AppWrapper());
}
