import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlurTabBar extends StatefulWidget {
  final List<dynamic> tabs;
  final int currentIndex;
  final Function(int) onTabSelected;
  final VoidCallback onAddTab;
  final Function(int)? onCloseTab;

  const BlurTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAddTab,
    this.onCloseTab,
  });

  @override
  State<BlurTabBar> createState() => _BlurTabBarState();
}

class _BlurTabBarState extends State<BlurTabBar> {
  late List<bool> _tabHover;
  bool _addHover = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabHover = List<bool>.filled(widget.tabs.length, false);
  }

  @override
  void didUpdateWidget(covariant BlurTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs.length != _tabHover.length) {
      _tabHover = List<bool>.filled(widget.tabs.length, false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget tabList = ListView.builder(
      controller: _scrollController,
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.zero,
      itemCount: widget.tabs.length,
      itemBuilder: (context, i) {
        final isActive = i == widget.currentIndex;
        final isHover = _tabHover[i];
        return Padding(
          padding: const EdgeInsets.only(top: 6, bottom: 6, right: 8),
          child: GestureDetector(
            onTap: () => widget.onTabSelected(i),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) {
                setState(() => _tabHover[i] = true);
              },
              onExit: (_) {
                setState(() => _tabHover[i] = false);
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: isHover
                      ? Colors.black.withValues(alpha: 0.4)
                      : (isActive
                          ? Colors.black.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 4.0),
                      child: Text(
                        widget.tabs[i].title ?? '标签 $i',
                        style: TextStyle(
                          color: Colors.white,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    if (widget.onCloseTab != null && widget.tabs.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              widget.onCloseTab!(i);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.2),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

    return SizedBox(
      height: 40,
      child: Row(
        children: [
          Expanded(
            child: GetPlatform.isDesktop
                ? Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    child: tabList,
                  )
                : tabList,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) {
                setState(() => _addHover = true);
              },
              onExit: (_) {
                setState(() => _addHover = false);
              },
              child: GestureDetector(
                onTap: widget.onAddTab,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 180),
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: _addHover
                        ? Colors.black.withValues(alpha: 0.35)
                        : Colors.black.withValues(alpha: 0.2),
                  ),
                  child: Icon(Icons.add, size: 20, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
