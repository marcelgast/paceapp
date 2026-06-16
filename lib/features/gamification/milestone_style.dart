import 'package:flutter/material.dart';

import '../../domain/milestones.dart';
import '../../theme/pace_colors.dart';

/// UI mapping for a milestone kind — kept out of the pure domain layer.
class MilestoneStyle {
  const MilestoneStyle(this.icon, this.color, this.label);

  final IconData icon;
  final Color color;
  final String label;

  static MilestoneStyle of(MilestoneKind kind) {
    return switch (kind) {
      MilestoneKind.time =>
        MilestoneStyle(Icons.timer_outlined, PaceColors.neonCyan, 'ZEIT'),
      MilestoneKind.money =>
        MilestoneStyle(Icons.savings_outlined, PaceColors.neonLime, 'BUDGET'),
      MilestoneKind.avoided => MilestoneStyle(
          Icons.smoke_free, PaceColors.neonMagenta, 'VERMIEDEN'),
    };
  }
}
