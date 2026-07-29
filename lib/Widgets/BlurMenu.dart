import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 菜单弹窗组件
class BlurMenu extends StatelessWidget {
  final double itemHeight;
  final List<BlurMenuItem> items;
  final void Function(String value) onSelect;

  const BlurMenu({
    super.key,
    required this.items,
    required this.onSelect,
    this.itemHeight = 48,
  });

  @override
  Widget build(BuildContext context) {
    final double height = itemHeight * items.length;
    final double width = 180;
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            alignment: Alignment.center,
            width: width,
            height: height,
            child: Material(
              color: Colors.black45,
              child: ListView(
                padding: EdgeInsets.zero,
                itemExtent: itemHeight,
                shrinkWrap: true,
                children: [
                  for (final item in items)
                    Theme(
                      data: Get.theme.copyWith(
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: ListTile(
                        onTap: () => onSelect(item.value),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)),
                        title: item,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 菜单项组件
class BlurMenuItem extends StatelessWidget {
  final String text;
  final String value;
  final IconData icon;

  const BlurMenuItem(this.text, this.icon, {super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}

class ContextMenuOverlay {
  static OverlayEntry? _currentEntry;
  static AnimationController? _controller;
  static Animation<double>? _fadeAnimation;

  static void show({
    required BuildContext context,
    required Offset position,
    required List<BlurMenuItem> items,
    required void Function(String value) onSelect,
    Duration animationDuration = const Duration(milliseconds: 200),
  }) {
    if (_currentEntry != null) return;

    // 获取屏幕宽度和高度
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    const double menuWidth = 180;
    final double menuHeight = items.length * 50;
    double left = position.dx;
    double top = position.dy;
    // 如果菜单会溢出右侧边界，则向左偏移
    if (left + menuWidth > screenWidth) {
      left = screenWidth - menuWidth;
      if (left < 0) left = 0;
    }
    // 如果菜单距离底部不足40像素，则向上弹出
    if (top + menuHeight > screenHeight - 40) {
      top = position.dy - menuHeight;
      if (top < 0) top = 0;
    }
    final Offset fixedPosition = Offset(left, top);

    _controller = AnimationController(
      duration: animationDuration,
      vsync: Navigator.of(context),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );
    _currentEntry = OverlayEntry(
      builder: (context) {
        return Listener(
          behavior: HitTestBehavior.opaque,
          onPointerUp: (event) {
            _controller?.reverse();
            Future.delayed(animationDuration, () {
              if (_currentEntry != null && _currentEntry!.mounted) {
                _currentEntry!.remove();
                _currentEntry = null;
                _controller?.dispose();
                _controller = null;
              }
            });
          },
          child: Stack(
            children: [
              Positioned(
                left: fixedPosition.dx,
                top: fixedPosition.dy,
                child: FadeTransition(
                  opacity: _fadeAnimation!,
                  child: BlurMenu(
                    items: items,
                    onSelect: (value) {
                      onSelect(value);
                      _controller?.reverse();
                      Future.delayed(animationDuration, () {
                        if (_currentEntry != null && _currentEntry!.mounted) {
                          _currentEntry!.remove();
                          _currentEntry = null;
                          _controller?.dispose();
                          _controller = null;
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Overlay.of(context).insert(_currentEntry!);
    _controller?.forward();
  }
}
