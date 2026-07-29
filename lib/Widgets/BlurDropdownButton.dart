import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlurDropdownButton extends StatefulWidget {
  final List<DropdownMenuItem> items;
  final String? value;
  final String hint;
  final void Function(String?)? onChanged;
  final double itemHeight;
  final double width;
  final double menuWidth;
  final double borderRadius;
  final bool enabled;

  const BlurDropdownButton({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint = '',
    this.itemHeight = 48,
    this.width = 180,
    this.menuWidth = 180,
    this.borderRadius = 10,
    this.enabled = true,
  });

  @override
  State<BlurDropdownButton> createState() => _BlurDropdownButtonState();
}

class _BlurDropdownButtonState extends State<BlurDropdownButton>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final ScrollController _scrollController = ScrollController();
  AnimationController? _animationController;
  Animation<double>? _fadeAnimation;
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController?.dispose();
    super.dispose();
  }

  void _showMenu() {
    if (_overlayEntry != null && _overlayEntry!.mounted) return;
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset(0, -1)); // 减1像素避免有缝隙
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    // 高效测量所有菜单项的内容宽度（只测量Text，Icon/SizedBox用固定宽度）
    double maxTextWidth = 0;
    for (final item in widget.items) {
      double textWidth = 0;
      if (item.child is Row) {
        final row = item.child as Row;
        // 只测量Text部分
        for (final child in row.children) {
          if (child is Text) {
            final TextPainter textPainter = TextPainter(
              text: TextSpan(
                  text: child.data ?? '',
                  style: child.style ?? TextStyle(fontSize: 16)),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout();
            textWidth += textPainter.width;
          } else if (child is Icon) {
            textWidth += 20; // Icon宽度
          } else if (child is SizedBox) {
            textWidth += (child.width ?? 0);
          } else if (child is Expanded) {
            // Expanded里通常是Text
            final expandedChild = child.child;
            if (expandedChild is Text) {
              final TextPainter textPainter = TextPainter(
                text: TextSpan(
                    text: expandedChild.data ?? '',
                    style: expandedChild.style ?? TextStyle(fontSize: 16)),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              )..layout();
              textWidth += textPainter.width;
            }
          }
        }
      } else if (item.child is Text) {
        final Text text = item.child as Text;
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
              text: text.data ?? '',
              style: text.style ?? TextStyle(fontSize: 16)),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();
        textWidth = textPainter.width;
      }
      maxTextWidth = textWidth > maxTextWidth ? textWidth : maxTextWidth;
    }
    // 加上左右padding（16*2），再加Icon和间距（20）
    double menuWidth =
        (maxTextWidth + 16 * 2 + 20).clamp(120, screenWidth - 24);
    double left = offset.dx;
    if (left < 0) left = 0;
    if (left + menuWidth > screenWidth) {
      left = screenWidth - menuWidth;
      if (left < 0) left = 0;
    }
    final double top = offset.dy + renderBox.size.height;

    _animationController?.dispose();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: Navigator.of(context),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController!,
      curve: Curves.easeInOut,
    );

    double menuMaxHeight = screenHeight * 0.6;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _removeMenuWithAnimation,
          child: Stack(
            children: [
              Positioned(
                left: left,
                top: top,
                child: FadeTransition(
                  opacity: _fadeAnimation!,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          width: menuWidth,
                          constraints: BoxConstraints(
                            maxHeight: menuMaxHeight,
                          ),
                          color: Colors.black45,
                          child: Scrollbar(
                            controller: _scrollController,
                            thumbVisibility: true,
                            child: ListView(
                              controller: _scrollController,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(),
                              children: widget.items.map((item) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    splashFactory: NoSplash.splashFactory,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      widget.onChanged?.call(item.value);
                                      _removeMenuWithAnimation();
                                    },
                                    child: Container(
                                      height: widget.itemHeight,
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: item.child,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    Overlay.of(context).insert(_overlayEntry!);
    _animationController?.forward();

    // 弹窗插入后自动滚动到当前选中项
    final selectedIndex =
        widget.items.indexWhere((item) => item.value == widget.value);
    if (selectedIndex >= 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final double targetOffset = selectedIndex * widget.itemHeight;
        final double maxOffset = _scrollController.hasClients
            ? _scrollController.position.maxScrollExtent
            : 0;
        _scrollController
            .jumpTo(targetOffset > maxOffset ? maxOffset : targetOffset);
      });
    }
  }

  void _removeMenuWithAnimation() {
    if (_animationController == null || _overlayEntry == null) return;
    _animationController!.reverse();
    Future.delayed(Duration(milliseconds: 200), () {
      if (_overlayEntry != null && _overlayEntry!.mounted) {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
      _animationController?.dispose();
      _animationController = null;
      _fadeAnimation = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 计算自适应宽度，与菜单弹窗一致
    double screenWidth = MediaQuery.of(context).size.width;
    double maxTextWidth = 0;
    for (final item in widget.items) {
      double textWidth = 0;
      if (item.child is Row) {
        final row = item.child as Row;
        for (final child in row.children) {
          if (child is Text) {
            final TextPainter textPainter = TextPainter(
              text: TextSpan(
                  text: child.data ?? '',
                  style: child.style ?? TextStyle(fontSize: 16)),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            )..layout();
            textWidth += textPainter.width;
          } else if (child is Icon) {
            textWidth += 20;
          } else if (child is SizedBox) {
            textWidth += (child.width ?? 0);
          } else if (child is Expanded) {
            final expandedChild = child.child;
            if (expandedChild is Text) {
              final TextPainter textPainter = TextPainter(
                text: TextSpan(
                    text: expandedChild.data ?? '',
                    style: expandedChild.style ?? TextStyle(fontSize: 16)),
                maxLines: 1,
                textDirection: TextDirection.ltr,
              )..layout();
              textWidth += textPainter.width;
            }
          }
        }
      } else if (item.child is Text) {
        final Text text = item.child as Text;
        final TextPainter textPainter = TextPainter(
          text: TextSpan(
              text: text.data ?? '',
              style: text.style ?? TextStyle(fontSize: 16)),
          maxLines: 1,
          textDirection: TextDirection.ltr,
        )..layout();
        textWidth = textPainter.width;
      }
      maxTextWidth = textWidth > maxTextWidth ? textWidth : maxTextWidth;
    }
    // 先测量 hint 的宽度
    final TextPainter hintPainter = TextPainter(
      text: TextSpan(text: widget.hint, style: TextStyle(fontSize: 14)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    double hintWidth = hintPainter.width;

    // 再测量 selected 的宽度
    final TextPainter selectedPainter = TextPainter(
      text: TextSpan(text: widget.value ?? '', style: TextStyle(fontSize: 16)),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    double selectedWidth = selectedPainter.width;

    // menuWidth 至少为 hintWidth + padding + icon
    double menuWidth = ([maxTextWidth, hintWidth, selectedWidth]
                .reduce((a, b) => a > b ? a : b) +
            16 * 2 +
            20)
        .clamp(120, screenWidth - 24);
    // 主按钮只显示纯文本，不显示Icon/SizedBox等
    String? selectedValue = widget.value;
    Widget selectedText;
    if (selectedValue != null) {
      selectedText = Text(
        selectedValue,
        style: TextStyle(
            color: widget.enabled ? Colors.white : Colors.grey, fontSize: 16),
        overflow: TextOverflow.ellipsis,
      );
    } else {
      selectedText =
          Text(widget.hint, style: TextStyle(color: Colors.grey, fontSize: 14));
    }
    bool hasItems = widget.items.isNotEmpty;
    return MouseRegion(
      cursor: widget.enabled && hasItems
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.enabled && hasItems) setState(() => _isPressed = true);
        },
        onTapUp: (_) {
          if (widget.enabled && hasItems) setState(() => _isPressed = false);
        },
        onTapCancel: () {
          if (widget.enabled && hasItems) setState(() => _isPressed = false);
        },
        onTap: widget.enabled && hasItems ? _showMenu : null,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          width: menuWidth,
          height: widget.itemHeight,
          decoration: BoxDecoration(
            color: !_isPressed
                ? (_isHovering ? Get.theme.hoverColor : Colors.transparent)
                : Get.theme.focusColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: selectedText),
              Icon(Icons.arrow_drop_down,
                  color:
                      widget.enabled && hasItems ? Colors.white : Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
