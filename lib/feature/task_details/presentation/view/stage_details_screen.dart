import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';
import 'package:moazez/core/utils/common/custom_app_bar.dart';
import 'package:moazez/core/utils/common/unauthenticated_widget.dart';
import 'package:moazez/core/utils/constant/font_manger.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/task_details/domain/entities/task_details_entity.dart';
import 'package:moazez/feature/task_details/presentation/cubit/stage_completion_cubit.dart';
import 'package:moazez/feature/task_details/presentation/cubit/stage_completion_state.dart';
import 'package:moazez/feature/task_details/presentation/widgets/status_chip_ar.dart';
import 'package:moazez/core/services/service_locator.dart' as di;

class StageDetailsScreen extends StatelessWidget {
  final StageEntity stage;

  const StageDetailsScreen({Key? key, required this.stage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<StageCompletionCubit>(),
      child: Scaffold(
        appBar: CustomAppBar(title: stage.title),
        body: BlocBuilder<StageCompletionCubit, StageCompletionState>(
          builder: (context, state) {
            if (state is StageCompletionError) {
              if (state.message.contains('Unauthenticated.')) {
                return const UnauthenticatedWidget();
              }
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status and Title Section
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: (StatusChipAr.statusColor[stage.status
                                          .toLowerCase()] ??
                                      Colors.grey)
                                  .withValues(alpha: 0.1),
                              child: Icon(
                                stage.status.toLowerCase() == 'completed'
                                    ? Icons.check_circle_outline
                                    : stage.status.toLowerCase() == 'in_progress'
                                    ? Icons.hourglass_top_outlined
                                    : Icons.pending_outlined,
                                color:
                                    StatusChipAr.statusColor[stage.status
                                        .toLowerCase()] ??
                                    Colors.grey,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stage.title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'الحالة: ${StatusChipAr.statusText[stage.status.toLowerCase()] ?? "غير معروف"}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Details Section
                    if (stage.completedAt != null ||
                        stage.proofNotes != null ||
                        stage.proofFiles != null)
                      Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'تفاصيل الإكمال',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              SizedBox(height: 12),
                              if (stage.completedAt != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today,
                                        color: Colors.grey,
                                        size: 20,
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          'تاريخ الإكمال: ${stage.completedAt ?? "غير متوفر"}',
                                          style: getMediumStyle(
                                            fontSize: 14,
                                            fontFamily: FontConstant.cairo,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              if (stage.proofNotes != null &&
                                  stage.proofNotes!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.note,
                                            color: Colors.grey,
                                            size: 20,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'ملاحظات الإثبات:',
                                            style: getMediumStyle(
                                              fontSize: 14,
                                              fontFamily: FontConstant.cairo,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 6),
                                      Text(
                                        stage.proofNotes ?? "غير متوفر",
                                        style: getMediumStyle(
                                          fontSize: 14,
                                          fontFamily: FontConstant.cairo,
                                          color: AppColors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: 16),

                    // Image Preview Section
                    Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'صورة الإثبات',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(height: 12),
                            if (stage.proofFiles != null &&
                                stage.proofFiles!.isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: GestureDetector(
                                  onTap: () {
                                    // Open full-screen image viewer
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => Dialog(
                                        insetPadding: EdgeInsets.zero,
                                        child: Stack(
                                          children: [
                                            Center(
                                              child: InteractiveViewer(
                                                panEnabled: true,
                                                minScale: 0.5,
                                                maxScale: 4.0,
                                                child: CustomCachedNetworkImage(
                                                  imageUrl: stage.proofFiles!,
                                                  fit: BoxFit.contain,
                                                  errorWidget: Center(
                                                    child: Text(
                                                      'لا يوجد صورة',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 40,
                                              right: 20,
                                              child: IconButton(
                                                icon: Icon(
                                                  Icons.close,
                                                  color: Colors.white,
                                                  size: 30,
                                                ),
                                                onPressed:
                                                    () =>
                                                        Navigator.of(
                                                          context,
                                                        ).pop(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Hero(
                                    tag: 'stage_image_${stage.id}',
                                    child: CustomCachedNetworkImage(
                                      imageUrl: stage.proofFiles!,
                                      height: 250,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorWidget: Container(
                                        height: 250,
                                        color: Colors.grey[200],
                                        child: Center(
                                          child: Text(
                                            'لا يوجد صورة',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            else
                              Container(
                                height: 250,
                                color: Colors.grey[200],
                                child: Center(
                                  child: Text(
                                    'لا توجد صورة',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            if (stage.proofFiles != null &&
                                stage.proofFiles!.isNotEmpty)
                              SizedBox(height: 8),
                            if (stage.proofFiles != null &&
                                stage.proofFiles!.isNotEmpty)
                              Center(
                                child: Text(
                                  'اضغط على الصورة للتكبير',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
