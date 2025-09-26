part of 'cancer_cubit.dart';

@immutable
sealed class CancerState {}

final class CancerInitial extends CancerState {}

final class CancerLoading extends CancerState {}

final class CancerFailure extends CancerState {
  final String message;

  CancerFailure({required this.message});
}

final class CancerSuccess extends CancerState {
  final CancerModel cancerResult;

  CancerSuccess({required this.cancerResult});
}
