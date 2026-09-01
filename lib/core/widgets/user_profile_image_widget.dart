import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';

class UserProfileImageWidget extends StatelessWidget {
  const UserProfileImageWidget({
    super.key,
    this.width,
    this.height,
    required this.photoUrl,
    required this.name,
  });

  final double? width;
  final double? height;
  final String? photoUrl;
  final String name;

  String get _initials {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();

    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  Color _backgroundColorFromName(BuildContext context) {
    // Deterministic color per user — same name always gets the same color.
    final colors = [
      context.theme.appColors.primary,
      Colors.teal,
      Colors.indigo,
      Colors.deepOrange,
      Colors.purple,
    ];
    final index = name.isEmpty ? 0 : name.codeUnitAt(0) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return ClipOval(
      child: SizedBox(
        width: width ?? 56,
        height: height ?? 56,
        child: hasPhoto
            ? Image.network(
                photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _InitialsAvatar(
                  initials: _initials,
                  color: _backgroundColorFromName(context),
                ),
              )
            : _InitialsAvatar(
                initials: _initials,
                color: _backgroundColorFromName(context),
              ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.initials, required this.color});

  final String initials;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      alignment: Alignment.center,
      child: Text(
        initials,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }
}
