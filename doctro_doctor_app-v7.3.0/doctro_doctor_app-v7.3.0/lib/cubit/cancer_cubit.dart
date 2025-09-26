import 'package:bloc/bloc.dart';
import 'package:doctro/model/cancer_detection_model/cancer_model.dart';
import 'package:doctro/repo/cancer_service_repo.dart';
import 'package:meta/meta.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'cancer_state.dart';

class CancerCubit extends Cubit<CancerState> {
  final CancerServiceRepo _cancerServiceRepo = CancerServiceRepo();
  CancerCubit() : super(CancerInitial());
  void processImage(String file) async {
    try {
      emit(CancerLoading());
      final res = await _cancerServiceRepo.processImageFromUrl(file);
      emit(CancerSuccess(cancerResult: res));
    } catch (e) {
      emit(CancerFailure(message: e.toString()));
    }
  }

  void reset() {
    emit(CancerInitial());
  }
}
