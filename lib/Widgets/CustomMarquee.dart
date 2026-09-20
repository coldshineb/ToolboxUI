import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomMarquee extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double velocity;
  final double blankSpace;
  final double startPadding;

  const CustomMarquee({
    super.key,
    required this.text,
    required this.style,
    required this.velocity,
    required this.blankSpace,
    required this.startPadding,
  });

  @override
  _CustomMarqueeState createState() => _CustomMarqueeState();
}

class _CustomMarqueeState extends State<CustomMarquee> with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  double _textWidth = 0.0;
  
  // We keep track of the positions of two identical text blocks.
  double _x1 = 0.0;
  double _x2 = 0.0;
  bool _isInitialized = false;
  Duration _lastElapsed = Duration.zero;
  
  // Track pausing
  bool _wasPaused = false;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _calculateTextWidth();
  }

  @override
  void didUpdateWidget(CustomMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text || oldWidget.style != widget.style) {
      _calculateTextWidth();
    }
  }

  void _calculateTextWidth() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    setState(() {
      _textWidth = textPainter.size.width;
      // Initialize positions
      _x1 = widget.startPadding;
      _x2 = _x1 + _textWidth + widget.blankSpace;
      _isInitialized = true;
      _lastElapsed = Duration.zero;
      _wasPaused = false;
    });

    if (!_ticker.isTicking) {
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (!_isInitialized) return;
    
    // When ticker resumes from being muted, elapsed time does not include muted time,
    // but we can be extra safe against large dt jumps by ignoring frames > 100ms.
    final double dt = (elapsed - _lastElapsed).inMicroseconds / 1000000.0;
    _lastElapsed = elapsed;

    if (dt > 0.1 || dt <= 0) {
      // Ignore huge jumps in delta time (e.g., when the app is backgrounded)
      return;
    }

    setState(() {
      double move = widget.velocity * dt;
      _x1 -= move;
      _x2 -= move;

      // When a text block moves completely off-screen,
      // we wrap it around to the end of the other text block.
      if (_x1 <= -_textWidth) {
        _x1 = _x2 + _textWidth + widget.blankSpace;
      }
      if (_x2 <= -_textWidth) {
        _x2 = _x1 + _textWidth + widget.blankSpace;
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const SizedBox.shrink();
    }

    return ClipRect(
      child: Stack(
        children: [
          Positioned(
            left: _x1,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.text,
                style: widget.style,
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          Positioned(
            left: _x2,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.text,
                style: widget.style,
                softWrap: false,
                overflow: TextOverflow.visible,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

