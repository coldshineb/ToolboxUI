import 'package:flutter/material.dart';

/// A small helper that ensures clicks on empty areas request focus
/// and can host local Shortcuts/Actions for per-page bindings.
class FocusableBackground extends StatefulWidget {
  final Widget child;
  final FocusNode? focusNode;
  final bool autofocus;
  final Map<ShortcutActivator, Intent>? shortcuts;
  final Map<Type, Action<Intent>>? actions;
  final bool requestFocusOnPointerDown;

  const FocusableBackground({
    super.key,
    required this.child,
    this.focusNode,
    this.autofocus = true,
    this.shortcuts,
    this.actions,
    this.requestFocusOnPointerDown = true,
  });

  @override
  FocusableBackgroundState createState() => FocusableBackgroundState();
}

class FocusableBackgroundState extends State<FocusableBackground> {
  late FocusNode _node;
  late bool _ownNode;

  @override
  void initState() {
    super.initState();
    if (widget.focusNode == null) {
      _node = FocusNode();
      _ownNode = true;
    } else {
      _node = widget.focusNode!;
      _ownNode = false;
    }
  }

  @override
  void dispose() {
    if (_ownNode) _node.dispose();
    super.dispose();
  }

  void _requestMyFocus() {
    if (!_node.hasFocus) {
      FocusScope.of(context).requestFocus(_node);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget subtree = Focus(
      focusNode: _node,
      autofocus: widget.autofocus,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.requestFocusOnPointerDown ? _requestMyFocus : null,
        onSecondaryTap:
            widget.requestFocusOnPointerDown ? _requestMyFocus : null,
        child: widget.child,
      ),
    );

    if (widget.actions != null && widget.actions!.isNotEmpty) {
      subtree = Actions(actions: widget.actions!, child: subtree);
    }

    if (widget.shortcuts != null && widget.shortcuts!.isNotEmpty) {
      subtree = Shortcuts(shortcuts: widget.shortcuts!, child: subtree);
    }

    return subtree;
  }
}
