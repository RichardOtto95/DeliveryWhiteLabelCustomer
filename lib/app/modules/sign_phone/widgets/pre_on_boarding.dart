import 'dart:ui';

import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/side_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PreOnBoarding extends StatelessWidget {
  const PreOnBoarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: maxHeight(context),
        width: maxWidth(context),
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(
            children: [
              SizedBox(height: viewPaddingTop(context) + wXD(17, context)),
              Text(
                "Nome da loja",
                textAlign: TextAlign.center,
                style: textFamily(
                  context,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: getColors(context).onBackground,
                ),
              ),
              Text(
                "Lorem ipsum  dolor sit amet itsumo",
                textAlign: TextAlign.center,
                style: textFamily(
                  context,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: getColors(context).onSurface,
                ),
              ),
              SizedBox(height: wXD(20, context)),
              Text(
                "Do que você precisa?",
                textAlign: TextAlign.center,
                style: textFamily(
                  context,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: getColors(context).onBackground.withOpacity(.9),
                ),
              ),
              SizedBox(height: wXD(30, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OnBoardingCard(
                    imagePath: "./assets/images/customer.png",
                    text: "Preciso de um serviço.",
                    buttonText: "Sou cliente",
                    onTap: () {
                      Modular.to.pushNamed("/sign-phone/sign-phone");
                    },
                  ),
                  SizedBox(width: wXD(30, context)),
                  OnBoardingCard(
                    imagePath: "./assets/images/seller.png",
                    text: "Busco novos clientes.",
                    buttonText: "Sou vendedor",
                    onTap: () {
                      late OverlayEntry sellerAppOverlay;
                      sellerAppOverlay = OverlayEntry(
                        builder: (context) => NewAppPopup(
                          onBack: () => sellerAppOverlay.remove(),
                          onTap: () => sellerAppOverlay.remove(),
                          title: "Novo app para\ncriar vendedores",
                          text:
                              "Melhoramos a experiência de criar\num vendedor. Agora temos um aplicativo\npara cada necessidade",
                        ),
                      );
                      Overlay.of(context)!.insert(sellerAppOverlay);
                    },
                  ),
                ],
              ),
              SizedBox(height: wXD(30, context)),
              OnBoardingCard(
                imagePath: "./assets/images/agent.png",
                text: "Busco uma renda.",
                buttonText: "Sou agente",
                onTap: () {
                  late OverlayEntry agentAppOverlay;
                  agentAppOverlay = OverlayEntry(
                    builder: (context) => NewAppPopup(
                      onBack: () => agentAppOverlay.remove(),
                      onTap: () => agentAppOverlay.remove(),
                      title: "Novo app para\ncontratar agentes",
                      text:
                          "Melhoramos a experiência de contratar um\n agente. Agora temos um aplicativo\npara cada necessidade",
                    ),
                  );
                  Overlay.of(context)!.insert(agentAppOverlay);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnBoardingCard extends StatelessWidget {
  final String imagePath;
  final String text;
  final String buttonText;
  final void Function() onTap;

  const OnBoardingCard({
    Key? key,
    required this.imagePath,
    required this.text,
    required this.buttonText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(9)),
      color: getColors(context).surface,
      elevation: 3,
      child: Container(
        height: wXD(226, context),
        width: wXD(139, context),
        padding: EdgeInsets.symmetric(vertical: wXD(15, context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              imagePath,
              height: wXD(105, context),
              fit: BoxFit.fitHeight,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: wXD(31, context)),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: textFamily(
                  context,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: getColors(context).onSurface,
                ),
              ),
            ),
            SideButton(
              onTap: onTap,
              width: wXD(100, context),
              height: wXD(28, context),
              title: buttonText,
              fontSize: 10,
            )
          ],
        ),
      ),
    );
  }
}

class NewAppPopup extends StatefulWidget {
  final void Function() onBack;
  final void Function() onTap;
  final String title;
  final String text;

  const NewAppPopup({
    Key? key,
    required this.onBack,
    required this.onTap,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  State<NewAppPopup> createState() => _NewAppPopupState();
}

class _NewAppPopupState extends State<NewAppPopup>
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
                    height: wXD(392, context),
                    width: wXD(308, context),
                    padding: EdgeInsets.only(
                      top: wXD(38, context),
                      bottom: wXD(17, context),
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
                        Image.asset(
                          "./assets/images/hand_card.png",
                          height: wXD(102, context),
                          fit: BoxFit.fitHeight,
                        ),
                        Spacer(flex: 4),
                        Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: textFamily(
                            context,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: getColors(context).onBackground,
                          ),
                        ),
                        Spacer(flex: 4),
                        Text(
                          widget.text,
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
                          title: "Baixar novo app",
                          onTap: widget.onTap,
                        ),
                        Spacer(flex: 3),
                        SideButton(
                          fontColor: getColors(context).primary,
                          color: getColors(context).surface,
                          width: wXD(248, context),
                          height: wXD(38, context),
                          fontSize: 14,
                          title: "Permanecer aqui",
                          onTap: () async {
                            await animateTo(0);
                            widget.onBack();
                          },
                        ),
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
