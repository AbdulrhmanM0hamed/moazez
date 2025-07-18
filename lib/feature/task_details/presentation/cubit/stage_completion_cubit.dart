import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/feature/task_details/domain/usecases/complete_stage_usecase.dart';
import 'package:moazez/feature/task_details/presentation/cubit/stage_completion_state.dart';

class StageCompletionCubit extends Cubit<StageCompletionState> {
  final CompleteStageUseCase completeStageUseCase;
  String? _image;
  String? _notes;

  StageCompletionCubit({required this.completeStageUseCase}) : super(StageCompletionInitial());

  Future<void> completeStage({
    required int stageId,
    String? proofNotes,
    String? proofImage,
  }) async {
    emit(StageCompletionLoading());
    final selectedImage = proofImage ?? _image;
    final result = await completeStageUseCase(
      CompleteStageParams(
        stageId: stageId,
        proofNotes: proofNotes ?? _notes,
        proofImage: selectedImage,
      ),
    );
    result.fold(
      (failure) => emit(StageCompletionError(message: failure.message)),
      (stage) => emit(StageCompletionSuccess(stage: stage)),
    );
  }

  void updateNotes(String notes) {
    _notes = notes;
    emit(StageCompletionUpdated());
  }

  Future<void> updateImage(String imagePath) async {
    try {
      _image = imagePath;
      emit(StageCompletionUpdated(image: imagePath));
    } catch (e) {
    //  print('Error updating image: $e');
      emit(StageCompletionError(message: 'فشل في معالجة الصورة'));
    }
  }

  void removeImage() {
    _image = null;
    emit(StageCompletionUpdated());
  }

  String? get image => _image;

  String? get notes => _notes;

}
