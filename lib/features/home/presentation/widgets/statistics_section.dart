import 'package:flutter/material.dart';
import 'numbers_report_widget.dart';

/// Section des statistiques de signalements (utilisateur + commune)
class StatisticsSection extends StatelessWidget {
  final int userSignalementsCount;
  final int communeSignalementsCount;

  const StatisticsSection({
    super.key,
    required this.userSignalementsCount,
    required this.communeSignalementsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 120),
            child: NumbersReportWidget(
              value: userSignalementsCount,
              label: 'Votre nombre de déclarations',
              backgroundColor: Colors.grey.shade50,
              textColor: Colors.grey.shade700,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 120),
            child: NumbersReportWidget(
              value: communeSignalementsCount,
              label: 'Déclarations de la commune',
              backgroundColor: Colors.grey.shade50,
              textColor: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }
}

