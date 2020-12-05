part of 'updater_cubit.dart';

abstract class UpdaterState extends Equatable {
  const UpdaterState();

  @override
  List<Object> get props => [];
}

class UpdaterUninitialized extends UpdaterState {}

class UpdaterInitial extends UpdaterState {}

class UpdaterError extends UpdaterState {
  final Map<String, dynamic> message;

  const UpdaterError(this.message);

  @override
  List<Object> get props => [message];
}
