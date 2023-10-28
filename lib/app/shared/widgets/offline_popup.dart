import 'dart:ui';

import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';

import '../utilities.dart';

class OfflinePopup extends StatefulWidget {
  final void Function() onBack;
  final void Function() onTap;

  const OfflinePopup({
    Key? key,
    required this.onBack,
    required this.onTap,
  }) : super(key: key);

  @override
  State<OfflinePopup> createState() => _OfflinePopupState();
}

class _OfflinePopupState extends State<OfflinePopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    animateTo(1);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> animateTo(double val) => _controller.animateTo(val,
      curve: Curves.easeOutQuad, duration: Duration(milliseconds: 400));

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: maxHeight(context),
      width: maxWidth(context),
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = _controller.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: value * 2 + 0.001,
                    sigmaY: value * 2 + 0.001,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      await animateTo(0);
                      widget.onBack();
                    },
                    child: Container(
                      height: maxHeight(context),
                      width: maxWidth(context),
                      color: getColors(context).shadow.withOpacity(value * .3),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                Transform.scale(
                  alignment: Alignment.center,
                  scale: value,
                  child: Container(
                    height: wXD(307, context),
                    width: wXD(308, context),
                    padding: EdgeInsets.only(
                      top: wXD(25, context),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                      color: getColors(context).surface,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 3,
                          offset: Offset(0, 3),
                          color:
                              getColors(context).shadow.withOpacity(value * .3),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.wifi_off_outlined,
                          size: wXD(102, context),
                        ),
                        Spacer(flex: 2),
                        Text(
                          "Sem sinal de internet",
                          textAlign: TextAlign.center,
                          style: textFamily(
                            context,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getColors(context).onBackground,
                          ),
                        ),
                        Spacer(flex: 2),
                        Text(
                          "Verifique o sinal de internet e tente outra vez",
                          textAlign: TextAlign.center,
                          style: textFamily(
                            context,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:
                                getColors(context).onBackground.withOpacity(.9),
                          ),
                        ),
                        Spacer(flex: 3),
                        SideButton(
                          width: wXD(248, context),
                          height: wXD(38, context),
                          fontSize: 14,
                          title: "Tentar novamente",
                          onTap: () async {
                            late OverlayEntry loadOverlay;
                            loadOverlay = OverlayEntry(
                                builder: (context) => LoadCircularOverlay());
                            Overlay.of(context)!.insert(loadOverlay);
                            await Future.delayed(
                              Duration(seconds: 3),
                              () => loadOverlay.remove(),
                            );
                            await animateTo(0);
                            widget.onBack();
                          },
                        ),
                        Spacer(flex: 3),
                      ],
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
