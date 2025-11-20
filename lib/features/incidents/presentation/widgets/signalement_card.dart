// dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/signalement.dart';
import '../pages/signalement_detail_page.dart';
import 'signalement_thumbnail.dart';
import 'small_status_badge.dart';

class SignalementCard extends StatelessWidget {
  final Signalement signalement;

  const SignalementCard({super.key, required this.signalement});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignalementDetailPage(signalement: signalement))),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignalementThumbnail(url: signalement.url, size: 80),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(signalement.titre, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  if (signalement.description != null && signalement.description!.isNotEmpty)
                    Text(signalement.description!, style: TextStyle(fontSize: 14, color: Colors.grey.shade700), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(DateFormat('dd/MM/yyyy').format(signalement.dateSignalement), style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    const Spacer(),
                    SmallStatusBadge(status: signalement.statut ?? 'en_attente'),
                  ]),
                ]),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}