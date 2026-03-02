import 'package:flutter/material.dart';

class AppBreadcrumb extends StatelessWidget {
  const AppBreadcrumb({
    super.key,
    required this.items,
    this.compact = false,
  });

  final List<String> items;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final effectiveItems = items.where((e) => e.trim().isNotEmpty).toList();
    if (effectiveItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < effectiveItems.length; i++) ...[
            Text(
              effectiveItems[i],
              style: TextStyle(
                fontSize: compact ? 13 : 14,
                fontWeight: i == effectiveItems.length - 1
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: i == effectiveItems.length - 1
                    ? Theme.of(context).colorScheme.onSurface
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            if (i != effectiveItems.length - 1) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                size: compact ? 16 : 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
            ],
          ],
        ],
      ),
    );
  }
}
