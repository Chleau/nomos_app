// dart
import 'dart:convert';
import 'package:flutter/material.dart';

class SignalementThumbnail extends StatelessWidget {
  final String? url;
  final double size;

  const SignalementThumbnail({super.key, this.url, this.size = 80});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.image_not_supported, color: Colors.grey.shade400),
      );
    }

    if (url!.startsWith('data:image')) {
      try {
        final base64String = url!.split(',')[1];
        final bytes = base64.decode(base64String);
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(image: MemoryImage(bytes), fit: BoxFit.cover),
          ),
        );
      } catch (_) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.broken_image, color: Colors.grey.shade400),
        );
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: NetworkImage(url!), fit: BoxFit.cover),
      ),
    );
  }
}