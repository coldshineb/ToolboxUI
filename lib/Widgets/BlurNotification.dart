import 'dart:ui';

import 'package:flutter/material.dart';

class BlurNotification extends StatefulWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;
  final String title;
  final String message;
  final NotificationLevel level;
  final String sentTime;
  final VoidCallback onClose;
  final ValueChanged<double> onHeightChanged;

  const BlurNotification({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
    required this.title,
    required this.message,
    required this.level,
    required this.sentTime,
    required this.onClose,
    required this.onHeightChanged,
  });

  @override
  State<BlurNotification> createState() => BlurNotificationState();
}

class BlurNotificationState extends State<BlurNotification> {
  final GlobalKey _containerKey = GlobalKey();
  String _title = '';
  String _message = '';
  NotificationLevel _level = NotificationLevel.info;

  @override
  void initState() {
    super.initState();
    _title = widget.title;
    _message = widget.message;
    _level = widget.level;
    WidgetsBinding.instance.addPostFrameCallback((_) => _reportHeight());
  }

  @override
  void didUpdateWidget(covariant BlurNotification oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _reportHeight());
  }

  void _reportHeight() {
    final context = _containerKey.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null) {
        widget.onHeightChanged(box.size.height);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColorByLevel(_level);
    return FadeTransition(
      opacity: widget.fadeAnimation,
      child: SlideTransition(
        position: widget.slideAnimation,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Material(
              type: MaterialType.transparency,
              child: GestureDetector(
                onTap: widget.onClose,
                child: Container(
                  key: _containerKey,
                  width: 320,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(_getIconByLevel(_level), color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            _title,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer(),
                          Text(
                            widget.sentTime,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        _message,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorByLevel(NotificationLevel level) {
    switch (level) {
      case NotificationLevel.info:
        return Colors.black45;
      case NotificationLevel.success:
        return Colors.green.withValues(alpha: 0.5);
      case NotificationLevel.warning:
        return Colors.orange.withValues(alpha: 0.5);
      case NotificationLevel.error:
        return Colors.red.withValues(alpha: 0.5);
    }
  }

  IconData _getIconByLevel(NotificationLevel level) {
    switch (level) {
      case NotificationLevel.info:
        return Icons.info_outline;
      case NotificationLevel.success:
        return Icons.check_circle_outline;
      case NotificationLevel.warning:
        return Icons.warning_amber_rounded;
      case NotificationLevel.error:
        return Icons.error_outline;
    }
  }
}

enum NotificationLevel {
  info,
  success,
  warning,
  error,
}
