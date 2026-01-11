import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../widgets/shimmer_loading.dart';
import 'attendance_request_card.dart';

/// A widget that displays a list of attendance requests.
///
/// Shows a section title and a scrollable list of attendance request cards.
class AttendanceRequestList extends StatelessWidget {
  /// The list of attendance requests to display.
  final List<AttendanceRequest> requests;

  /// Callback when a request card is tapped.
  final void Function(AttendanceRequest request)? onRequestTap;

  /// Maximum height for the list (optional constraint).
  final double? maxHeight;

  /// Whether the list is loading.
  final bool isLoading;

  const AttendanceRequestList({
    super.key,
    required this.requests,
    this.onRequestTap,
    this.maxHeight,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Attendance Requests',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (requests.isNotEmpty)
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full history
                  },
                  child: const Text('View All'),
                ),
            ],
          ),
        ),
        Gap(8.h),
        // Request list
        if (isLoading)
          _buildLoadingState()
        else if (requests.isEmpty)
          _buildEmptyState(theme)
        else
          _buildRequestList(),
      ],
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      padding: EdgeInsets.only(bottom: 8.h),
      itemBuilder: (context, index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: ShimmerLoading(
          child: Container(
            height: 88.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 48.sp,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            Gap(12.h),
            Text(
              'No attendance requests',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Gap(4.h),
            Text(
              'Scan a QR code to mark attendance',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestList() {
    final listContent = ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: requests.length,
      padding: EdgeInsets.only(bottom: 8.h),
      itemBuilder: (context, index) {
        final request = requests[index];
        return AttendanceRequestCard(
              request: request,
              onTap: onRequestTap != null ? () => onRequestTap!(request) : null,
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: (50 * index).ms)
            .slideX(begin: 0.05, duration: 300.ms, delay: (50 * index).ms);
      },
    );

    if (maxHeight != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight!),
        child: SingleChildScrollView(child: listContent),
      );
    }

    return listContent;
  }
}
