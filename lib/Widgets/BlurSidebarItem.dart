import 'package:flutter/material.dart';

class BlurSidebarItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback? onTap;
  final bool dense;
  final double minHeight;
  final Color selectedColor;

  const BlurSidebarItem({
    super.key,
    required this.icon,
    required this.title,
    this.selectedColor = Colors.blue,
    this.selected = false,
    this.onTap,
    this.dense = false,
    this.minHeight = 30.0,
  });

  @override
  State<BlurSidebarItem> createState() => _BlurSidebarItemState();
}

class _BlurSidebarItemState extends State<BlurSidebarItem> {
  bool _hovered = false;
  bool _pressed = false;

  Color? get _bgColor {
    if (widget.selected) {
      return Colors.grey.withValues(alpha: 0.2);
    } else if (_pressed) {
      return Colors.grey.withValues(alpha: 0.2);
    } else if (_hovered) {
      return Colors.grey.withValues(alpha: 0.1);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          constraints: BoxConstraints(minHeight: widget.minHeight),
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: widget.dense ? 4 : 8),
          child: Row(
            children: [
              Icon(widget.icon,
                  color: widget.selected
                      ? widget.selectedColor
                      : theme.iconTheme.color),
              SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 3.0),
                  // Align text better
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          color: widget.selected
                              ? widget.selectedColor
                              : theme.textTheme.bodyMedium?.color,
                          fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SidebarExpansion extends StatefulWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;
  final bool? expanded;
  final ValueChanged<bool>? onExpansionChanged;
  final bool initiallyExpanded;
  final double minHeight;

  const SidebarExpansion({
    super.key,
    required this.icon,
    required this.title,
    required this.children,
    this.expanded,
    this.onExpansionChanged,
    this.initiallyExpanded = false,
    this.minHeight = 30.0,
  });

  @override
  State<SidebarExpansion> createState() => _SidebarExpansionState();
}

class _SidebarExpansionState extends State<SidebarExpansion>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late bool _internalExpanded; // 内部状态，仅在未受控时使用
  late AnimationController _controller;
  late Animation<double> _sizeAnimation;
  bool _hovered = false;
  bool _pressed = false;

  @override
  bool get wantKeepAlive => true;

  Color? get _bgColor {
    if (_pressed) {
      return Colors.grey.withValues(alpha: 0.2);
    } else if (_hovered) {
      return Colors.grey.withValues(alpha: 0.1);
    } else {
      return null;
    }
  }

  bool get expanded => widget.expanded ?? _internalExpanded;

  @override
  void initState() {
    super.initState();
    _internalExpanded = widget.initiallyExpanded;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _sizeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    if (expanded) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(covariant SidebarExpansion oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 受控模式下，expanded变化时动画同步
    if (expanded != oldWidget.expanded) {
      if (expanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    final newExpanded = !expanded;
    if (widget.expanded != null) {
      // 受控模式，通知父组件
      widget.onExpansionChanged?.call(newExpanded);
    } else {
      // 非受控模式，自己管理
      setState(() {
        _internalExpanded = newExpanded;
      });
    }
    if (newExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // 保持 keepAlive 正常工作
    final theme = Theme.of(context);

    final lineColor = theme.dividerColor.withValues(alpha: 0.5);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
            onTap: _toggle,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 180),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _bgColor,
              ),
              constraints: BoxConstraints(minHeight: widget.minHeight),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(widget.icon, color: theme.iconTheme.color),
                  SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 3.0),
                      // Align text better
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                              fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  RotationTransition(
                    turns:
                        Tween<double>(begin: 0, end: 0.5).animate(_controller),
                    child: Icon(
                      Icons.expand_more,
                      size: 18,
                      color: theme.iconTheme.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        ClipRect(
          child: SizeTransition(
            sizeFactor: _sizeAnimation,
            axisAlignment: -1.0,
            child: Padding(
              // 整体缩进，对应父级图标的位置
              padding: const EdgeInsets.only(left: 27.0),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    // 左侧连接线
                    Positioned(
                      left: 0,
                      top: 12.0,
                      // 顶部留白距离
                      bottom: 12.0,
                      // 底部留白距离
                      width: 1.0,
                      // 线条粗细
                      child: Container(
                        color: lineColor,
                      ),
                    ),
                    Padding(
                      // 控制子菜单内容离左侧线条的距离
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.children,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
