import 'dart:io';

import 'package:delivery_customer/app/modules/messages/messages_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/floating_circle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart' as mobx;

import 'message.dart';
import 'message_bar.dart';

class Chat extends StatefulWidget {
  final String receiverId;
  final String receiverCollection;
  final String messageId;
  const Chat({
    Key? key,
    required this.receiverId,
    required this.receiverCollection,
    this.messageId = "",
  }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final MessagesStore store = Modular.get();

  final PageController pageController = PageController();

  GlobalKey messageKey = GlobalKey();

  FocusNode focusNode = FocusNode();

  String messageId = "";

  @override
  void initState() {
    messageId = widget.messageId;
    // print("messageId: ${widget.messageId}");
    // print("receiverCollection: ${widget.receiverCollection}");
    // print("receiverId: ${widget.receiverId}");
    store.textChatController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    store.disposeChat();
    pageController.dispose();
    super.dispose();
  }

  Future scrollToItem() async {
    // print("Pelo menos entrou no scroll to item");
    if (messageKey.currentContext != null) {
      final context = messageKey.currentContext!;
      // print("Ensure de item visibleee");
      await Scrollable.ensureVisible(
        context,
        alignment: .9,
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      );
      messageId = "";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.images.isNotEmpty) {
          store.cancelImages();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: FutureBuilder<String>(
          future:
              store.loadChatData(widget.receiverId, widget.receiverCollection),
          builder: (context, data) {
            if (!data.hasData) {
              return CenterLoadCircular();
            }
            return Observer(
              builder: (context) {
                return Stack(
                  children: [
                    Listener(
                      onPointerDown: (event) => focusNode.unfocus(),
                      child: SizedBox(
                        height: maxHeight(context),
                        width: maxWidth(context),
                        child: SingleChildScrollView(
                          reverse: true,
                          physics: BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          child: Observer(
                            builder: (context) {
                              WidgetsBinding.instance
                                  .addPostFrameCallback(((timeStamp) {
                                scrollToItem();
                              }));
                              return Column(
                                children: [
                                  SizedBox(
                                      height: viewPaddingTop(context) +
                                          wXD(60, context)),
                                  ...List.generate(
                                    store.messages.length,
                                    (i) => MessageWidget(
                                      key: store.messages[i].id == messageId
                                          ? messageKey
                                          : null,
                                      isAuthor: store.getIsAuthor(i),
                                      rightName: store.customer!.username!,
                                      leftName: store.seller != null
                                          ? store.seller!.username!
                                          : store.agent!.username!,
                                      messageData: store.messages[i],
                                      showUserData: i == 0
                                          ? true
                                          : store.getShowUserData(i),
                                      messageBold: store.messages[i].id ==
                                          widget.messageId,
                                    ),
                                  ),
                                  SizedBox(height: wXD(80, context)),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    DefaultAppBar(data.data!),
                    Positioned(
                      bottom: 0,
                      child: MessageBar(
                        controller: store.textChatController,
                        focus: focusNode,
                        onChanged: (val) => store.text = val,
                        onEditingComplete: () => store.sendMessage(),
                        onSend: () => store.sendMessage(),
                        takePictures: () async {
                          Map? response = await pickMultiImage();
                          if (response != null) {
                            setState(() {
                              store.images = response['xFile'];
                              store.bytesImages = response['bytes'];                              
                            });
                          }
                        },
                        getCameraImage: () async {
                          Map? response = await pickCameraImage();
                          if (response != null) {
                            store.imageCam = response["xFile"];
                            store.bytesImageCam = response["bytes"];
                            store.sendImage(context);
                          }
                        },
                      ),
                    ),
                    Visibility(
                      visible: store.images.isNotEmpty,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            color: white,
                            height: maxHeight(context),
                            width: maxWidth(context),
                            child: Container(
                              height: wXD(800, context),
                              width: maxWidth(context),
                              margin: EdgeInsets.symmetric(
                                  vertical: wXD(58, context)),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                              ),
                              alignment: Alignment.center,
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(18)),
                                child: Observer(builder: (context) {
                                  return PageView(
                                    children: List.generate(
                                      store.images.length,
                                      (index) => Image.memory(
                                        store.bytesImages[index],
                                      ),
                                    ),
                                    onPageChanged: (page) =>
                                        store.imagesPage = page,
                                    controller: pageController,
                                  );
                                }),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: SizedBox(
                              width: maxWidth(context),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                      right: wXD(10, context),
                                      bottom: wXD(10, context),
                                    ),
                                    alignment: Alignment.centerRight,
                                    child: FloatingCircleButton(
                                      onTap: () => store.sendImage(context),
                                      icon: Icons.send_outlined,
                                      iconColor: getColors(context).primary,
                                      size: wXD(55, context),
                                      iconSize: 30,
                                    ),
                                  ),
                                  Observer(
                                    builder: (context) {
                                      return SizedBox(
                                        width: maxWidth(context),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(
                                              store.images.length,
                                              (index) => InkWell(
                                                onTap: () => pageController
                                                    .jumpToPage(index),
                                                child: Container(
                                                  height: wXD(70, context),
                                                  width: wXD(70, context),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                    width: 2,
                                                    color: index ==
                                                            store.imagesPage
                                                        ? getColors(context)
                                                            .primary
                                                        : Colors.transparent,
                                                  )),
                                                  child: Image.memory(
                                                    store.bytesImages[index],
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: wXD(10, context) +
                                MediaQuery.of(context).viewPadding.top,
                            child: Container(
                              width: maxWidth(context),
                              padding: EdgeInsets.symmetric(
                                  horizontal: wXD(10, context)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      store.cancelImages();
                                    },
                                    icon: Icon(Icons.close_rounded,
                                        size: wXD(30, context)),
                                  ),
                                  IconButton(
                                    onPressed: () => store.removeImage(),
                                    icon: Icon(Icons.delete_outline_rounded,
                                        size: wXD(30, context)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
