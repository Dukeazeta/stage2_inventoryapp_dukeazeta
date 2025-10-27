import 'package:flutter/material.dart';

class DetailInfoCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final String? customIcon;
  final VoidCallback onTap;
  final Widget? trailing;

  const DetailInfoCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.customIcon,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.zero,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              _buildIcon(context),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      content,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 12),
                trailing!,
              ] else ...[
                Icon(
                  Icons.copy,
                  size: 20,
                  color: Colors.grey[400],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (customIcon != null) {
      return Text(
        customIcon!,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1A1A1A),
        ),
      );
    } else if (icon != null) {
      return Icon(
        icon!,
        color: Theme.of(context).colorScheme.primary,
        size: 24,
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}