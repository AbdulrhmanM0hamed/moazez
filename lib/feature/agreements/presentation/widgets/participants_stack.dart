import 'package:flutter/material.dart';
import 'package:moazez/core/utils/common/cached_network_image.dart';

class ParticipantsStack extends StatelessWidget {
  final List<String> imageUrls;
  final double avatarSize;

  const ParticipantsStack({
    super.key,
    required this.imageUrls,
    this.avatarSize = 36,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <Widget>[];

    for (int i = 0; i < imageUrls.length; i++) {
      items.add(
        Positioned(
          right: i * (avatarSize * 0.65),
          child: _buildParticipantAvatar(imageUrls[i], theme),
        ),
      );
    }

    items.add(
      Positioned(
        right: imageUrls.length * (avatarSize * 0.65),
        child: _buildAddButton(theme),
      ),
    );

    return SizedBox(
      height: avatarSize,
      width: (imageUrls.length + 1) * (avatarSize * 0.65) + (avatarSize * 0.35),
      child: Stack(
        children: items,
      ),
    );
  }

  Widget _buildParticipantAvatar(String url, ThemeData theme) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
      ),
      child: ClipOval(
        child: CustomCachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: Icon(Icons.person, size: avatarSize * 0.6),
          errorWidget: Icon(Icons.person, size: avatarSize * 0.6),
        ),
      ),
    );
  }

  Widget _buildAddButton(ThemeData theme) {
    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: theme.primaryColor.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
      ),
      child: Icon(
        Icons.add,
        color: theme.primaryColor,
        size: avatarSize * 0.6,
      ),
    );
  }
}
