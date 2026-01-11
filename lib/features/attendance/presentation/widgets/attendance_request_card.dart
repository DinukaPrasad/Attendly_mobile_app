import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gap/gap.dart';

/// Status of an attendance request.
enum AttendanceRequestStatus { pending, approved, rejected }

/// Model for an attendance request.
class AttendanceRequest {
  final String id;
  final String courseName;
  final String sessionInfo;
  final DateTime date;
  final AttendanceRequestStatus status;
  final String? lecturerName;

  const AttendanceRequest({
    required this.id,
    required this.courseName,
    required this.sessionInfo,
    required this.date,
    required this.status,
    this.lecturerName,
  });
}

/// A card widget displaying an attendance request with swipe actions.
class AttendanceRequestCard extends StatelessWidget {
  final AttendanceRequest request;
  final VoidCallback? onTap;
  final VoidCallback? onView;
  final VoidCallback? onDelete;

  const AttendanceRequestCard({
    super.key,
    required this.request,
    this.onTap,
    this.onView,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Slidable(
      key: ValueKey(request.id),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: 0.4,
        children: [
          SlidableAction(
            onPressed: (_) => onView?.call(),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: Icons.visibility_outlined,
            label: 'View',
            borderRadius: BorderRadius.horizontal(left: Radius.circular(12.r)),
          ),
          SlidableAction(
            onPressed: (_) => onDelete?.call(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete_outline,
            label: 'Delete',
            borderRadius: BorderRadius.horizontal(right: Radius.circular(12.r)),
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Status indicator
                _buildStatusIndicator(theme),
                Gap(12.w),
                // Course details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.courseName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(4.h),
                      Text(
                        request.sessionInfo,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (request.lecturerName != null) ...[
                        Gap(2.h),
                        Text(
                          request.lecturerName!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Gap(8.w),
                // Date and status
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatDate(request.date),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Gap(4.h),
                    _buildStatusChip(theme),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(ThemeData theme) {
    final color = _getStatusColor(theme);

    return Container(
      width: 4.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  Widget _buildStatusChip(ThemeData theme) {
    final color = _getStatusColor(theme);
    final label = _getStatusLabel();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _getStatusColor(ThemeData theme) {
    return switch (request.status) {
      AttendanceRequestStatus.pending => Colors.orange,
      AttendanceRequestStatus.approved => Colors.green,
      AttendanceRequestStatus.rejected => Colors.red,
    };
  }

  String _getStatusLabel() {
    return switch (request.status) {
      AttendanceRequestStatus.pending => 'Pending',
      AttendanceRequestStatus.approved => 'Approved',
      AttendanceRequestStatus.rejected => 'Rejected',
    };
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Today';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
