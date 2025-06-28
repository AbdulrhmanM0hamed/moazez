import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/utils/animations/custom_progress_indcator.dart';
import 'package:moazez/core/utils/common/custom_text_field.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/core/widgets/empty_view.dart';
import 'package:moazez/feature/search/presentation/cubit/search_cubit.dart';
import 'package:moazez/feature/search/presentation/cubit/search_state.dart';
import 'package:moazez/feature/search/presentation/widgets/search_task_card.dart';

class SearchResultsBottomSheet extends StatelessWidget {
  const SearchResultsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search header with close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.close, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                'البحث عن المهام',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(width: 48), // For balance
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Search field
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: CustomTextField(
              hint: 'ابحث عن مهمة...',
              prefix: const Icon(Icons.search, color: AppColors.textSecondary),
              onChanged: (value) {
                context.read<SearchCubit>().performSearch(value);
              },
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
          ),
          
          // Search results section
          BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              return _buildStateContent(context, state);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStateContent(BuildContext context, SearchState state) {
    if (state is SearchLoading) {
      return const Expanded(
        child: Center(child: CustomProgressIndcator()),
      );
    }
    
    if (state is SearchError) {
      return Expanded(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'حدث خطأ: ${state.message}',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ),
      );
    }
    
    if (state is SearchLoaded) {
      final tasks = state.searchResult.tasks;
      
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (tasks.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
                child: Text(
                  '${tasks.length} نتيجة بحث',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).hintColor,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: SearchTaskCard(task: task),
                    );
                  },
                ),
              ),
            ] else
              const Expanded(
                child: EmptyView(
                  imagePath: 'assets/images/tasksEmpty.png',
                  message: 'لم يتم العثور على نتائج',
                ),
              ),
          ],
        ),
      );
    }
    
    // Initial state - show empty state
    return const Expanded(
      child: EmptyView(
        imagePath: 'assets/images/tasksEmpty.png',
        message: 'ابحث عن المهام',
      ),
    );
  }
}
