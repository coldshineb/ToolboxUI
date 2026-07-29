import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WindowTitleBar {
  static WindowButtonColors buttonColors = WindowButtonColors(
      iconNormal: Colors.grey,
      mouseOver: Colors.grey.withAlpha(50),
      mouseDown: Colors.grey.withAlpha(70),
      iconMouseOver: Colors.white,
      iconMouseDown: Colors.white);

  static WindowButtonColors closeButtonColors = WindowButtonColors(
      mouseOver: Colors.red,
      mouseDown: Colors.red[700],
      iconNormal: Colors.grey,
      iconMouseOver: Colors.white);

  static Widget windowTitleBarBox({
    required VoidCallback onMenuButtonPressed,
    String title = 'Starlane City 工具箱',
    Widget? iconWidget,
  }) {
    return !GetPlatform.isWeb
        ? SafeArea(
            bottom: false,
            left: false,
            right: false,
            child: SizedBox(
              height: 55,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MoveWindow(child: SizedBox(width: 18)),
                  Theme(
                      data: Get.theme
                          .copyWith(splashFactory: NoSplash.splashFactory),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          SizedBox(
                              width: 40,
                              height: 40,
                              child: ExcludeFocus(
                                excluding: true,
                                child: IconButton(
                                  icon: Icon(Icons.menu),
                                  iconSize: 20,
                                  style: ButtonStyle(
                                    shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                  onPressed: onMenuButtonPressed,
                                ),
                              )),
                        ],
                      )),
                  MoveWindow(
                    onDoubleTap: () {
                      appWindow.maximizeOrRestore();
                    },
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            if (iconWidget != null) ...[
                              iconWidget,
                              const SizedBox(width: 10),
                            ],
                            Text(title),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GetPlatform.isDesktop
                      ? Expanded(child: MoveWindow())
                      : Container(),
                  GetPlatform.isDesktop
                      ? Row(
                          children: [
                            WindowButton(
                              colors: buttonColors,
                              iconBuilder: (WindowButtonContext buttonContext) {
                                return Icon(Icons.remove, size: 15);
                              },
                              onPressed: () {
                                appWindow.minimize();
                              },
                            ),
                            WindowButton(
                              colors: buttonColors,
                              iconBuilder: (WindowButtonContext buttonContext) {
                                return Icon(Icons.crop_square, size: 15);
                              },
                              onPressed: () {
                                appWindow.maximizeOrRestore();
                              },
                            ),
                            WindowButton(
                              colors: closeButtonColors,
                              iconBuilder: (WindowButtonContext buttonContext) {
                                return Icon(Icons.close, size: 15);
                              },
                              onPressed: () {
                                appWindow.close();
                              },
                            ),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          )
        : SizedBox();
  }
}
