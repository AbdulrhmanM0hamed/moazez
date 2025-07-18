import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moazez/core/services/service_locator.dart';
import 'package:moazez/core/utils/constant/styles_manger.dart';
import 'package:moazez/core/utils/theme/app_colors.dart';
import 'package:moazez/feature/search/presentation/cubit/search_cubit.dart';
import 'package:moazez/feature/search/presentation/widgets/search_results_bottom_sheet.dart';
import 'home_header.dart';

class HomeTopSection extends StatelessWidget {
  const HomeTopSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SearchCubit>(),
      child: const _HomeTopSectionContent(),
    );
  }
}

class _HomeTopSectionContent extends StatefulWidget {
  const _HomeTopSectionContent();

  @override
  State<_HomeTopSectionContent> createState() => _HomeTopSectionContentState();
}

class _HomeTopSectionContentState extends State<_HomeTopSectionContent> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSearchBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return BlocProvider.value(
          value: context.read<SearchCubit>(),
          child: const SearchResultsBottomSheet(),
        );
      },
    ).whenComplete(() {
      context.read<SearchCubit>().resetSearch();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HomeHeader(),

          const SizedBox(height: 8),
          Text(
            'ابحث عن اتفاقياتك أو تابع تقدم مشاركيك لتحقيق أهدافهم',
            style: getRegularStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _showSearchBottomSheet,
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ابحث عن هدف...',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const Icon(
                    Icons.search,
                    size: 30,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
