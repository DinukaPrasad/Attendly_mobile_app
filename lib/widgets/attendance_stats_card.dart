import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../data/mock_data.dart';

/// Attendance statistics card with weekly bar chart.
class AttendanceStatsCard extends StatelessWidget {
  const AttendanceStatsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Attendance',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    '${_calculateAverageAttendance().toStringAsFixed(0)}% avg',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Gap(16.h),
            SizedBox(height: 150.h, child: const _WeeklyBarChart()),
            Gap(12.h),
            const _StatsRow(),
          ],
        ),
      ),
    );
  }

  double _calculateAverageAttendance() {
    final data = MockChartData.weeklyAttendance;
    return data.reduce((a, b) => a + b) / data.length;
  }
}

class _WeeklyBarChart extends StatelessWidget {
  const _WeeklyBarChart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = MockChartData.weeklyAttendance;
    final days = MockChartData.weekDays;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        minY: 0,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => theme.colorScheme.inverseSurface,
            tooltipPadding: EdgeInsets.all(8.w),
            tooltipMargin: 8.h,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${days[group.x]}\n${rod.toY.toStringAsFixed(0)}%',
                TextStyle(
                  color: theme.colorScheme.onInverseSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    days[value.toInt()],
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                );
              },
              reservedSize: 28.h,
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(data.length, (index) {
          final value = data[index];
          final isGood = value >= 80;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: value,
                width: 20.w,
                borderRadius: BorderRadius.vertical(top: Radius.circular(6.r)),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: isGood
                      ? [
                          theme.colorScheme.primary.withValues(alpha: 0.7),
                          theme.colorScheme.primary,
                        ]
                      : [
                          theme.colorScheme.error.withValues(alpha: 0.7),
                          theme.colorScheme.error,
                        ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              label: 'Total',
              value: '${MockChartData.totalClasses}',
              color: theme.colorScheme.primary,
            ),
            _StatItem(
              label: 'Attended',
              value: '${MockChartData.attendedClasses}',
              color: Colors.green,
            ),
            _StatItem(
              label: 'Missed',
              value: '${MockChartData.missedClasses}',
              color: theme.colorScheme.error,
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideY(begin: 0.2, duration: 400.ms, delay: 200.ms);
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Gap(2.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Attendance pie chart widget
class AttendancePieChart extends StatelessWidget {
  const AttendancePieChart({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final data = MockChartData.monthlyBreakdown;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This Month',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(16.h),
            SizedBox(
              height: 160.h,
              child: Row(
                children: [
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 30.r,
                        sections: [
                          PieChartSectionData(
                            value: data['Present']!,
                            title: '${data['Present']!.toInt()}%',
                            color: Colors.green,
                            radius: 50.r,
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: data['Excused']!,
                            title: '${data['Excused']!.toInt()}%',
                            color: Colors.orange,
                            radius: 45.r,
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          PieChartSectionData(
                            value: data['Absent']!,
                            title: '${data['Absent']!.toInt()}%',
                            color: theme.colorScheme.error,
                            radius: 40.r,
                            titleStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(16.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendItem(color: Colors.green, label: 'Present'),
                      Gap(8.h),
                      _LegendItem(color: Colors.orange, label: 'Excused'),
                      Gap(8.h),
                      _LegendItem(
                        color: theme.colorScheme.error,
                        label: 'Absent',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3.r),
          ),
        ),
        Gap(8.w),
        Text(label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
