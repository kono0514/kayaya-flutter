import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import 'app.dart';
import 'core/utils/simple_bloc_observer.dart';
import 'injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  HydratedBloc.storage = await HydratedStorage.build();
  Bloc.observer = SimpleBlocObserver();

  runApp(AppWrapper());
}
