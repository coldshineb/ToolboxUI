import 'dart:ui';

import 'package:flutter/material.dart';

class BlurDialog extends StatelessWidget {
  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;
  final MainAxisAlignment? actionsMainAxisAlignment;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final double borderRadius;

  const BlurDialog({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.actionsMainAxisAlignment,
    this.contentPadding,
    this.actionsPadding,
    this.borderRadius = 20,
  });

  @override
  Widget build(BuildContext context) {
    final maxDialogHeight = MediaQuery.of(context).size.height * 0.7;
    return Align(
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: IntrinsicWidth(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: maxDialogHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (title != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                          child: DefaultTextStyle(
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                            child: title!,
                          ),
                        ),
                      if (content != null)
                        Flexible(
                          child: SingleChildScrollView(
                            padding: contentPadding ??
                                const EdgeInsets.fromLTRB(24, 20, 24, 24),
                            child: DefaultTextStyle(
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(color: Colors.white70),
                              child: content!,
                            ),
                          ),
                        ),
                      if (actions != null)
                        Padding(
                          padding: actionsPadding ??
                              const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                          child: Row(
                            mainAxisAlignment: actionsMainAxisAlignment ??
                                MainAxisAlignment.end,
                            children: actions!,
                          ),
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
}
