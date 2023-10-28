import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/messages/widgets/message_bar.dart';
import 'package:delivery_customer/app/modules/profile/profile_store.dart';
import 'package:delivery_customer/app/modules/support/support_store.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
// import 'package:image_picker/image_picker.dart';
import '../../core/models/message_model.dart';
// import '../../shared/color_theme.dart';
import '../../shared/widgets/floating_circle_button.dart';
import '../messages/widgets/message.dart';

class SupportChat extends StatefulWidget {
  @override
  State<SupportChat> createState() => _SupportChatState();
}

class _SupportChatState extends ModularState<SupportChat, SupportStore> {
  final MainStore mainStore = Modular.get();
  final ProfileStore profileStore = Modular.get();
  final User? _user = FirebaseAuth.instance.currentUser;
  final PageController pageController = PageController();
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    store.clearNewSupportMessages();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (store.images.isNotEmpty || store.imageCam != null) {
          store.images.clear();
          store.bytesImages.clear();
          store.imageCam = null;
          store.bytesImageCam = null;
          return false;
        }
        return true;
      },
      child: Listener(
        onPointerDown: (_) => FocusScope.of(context).requestFocus(FocusNode()),
        child: Scaffold(
          body: Observer(builder: (context) {
            return Stack(
              children: [
                SizedBox(
                  height: maxHeight(context),
                  width: maxWidth(context),
                  child: SingleChildScrollView(
                    reverse: true,
                    padding: EdgeInsets.symmetric(
                        vertical: viewPaddingTop(context) + wXD(60, context)),
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("supports")
                          .where("user_id", isEqualTo: _user!.uid)
                          .where("user_collection", isEqualTo: "CUSTOMERS")
                          .snapshots(),
                      builder: (context, supportSnap) {
                        if (!supportSnap.hasData) {
                          return CenterLoadCircular();
                        }

                        if (supportSnap.data!.docs.isEmpty) {
                          return Container();
                        }

                        final supportDoc = supportSnap.data!.docs.first;

                        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection("supports")
                              .doc(supportDoc.id)
                              .collection("messages")
                              .orderBy("created_at")
                              .snapshots(),
                          builder: (context, messagesSnap) {
                            if (!messagesSnap.hasData) {
                              return CenterLoadCircular();
                            }

                            List<Message> messages = [];
                            messagesSnap.data!.docs.forEach((messageDoc) {
                              messages.add(Message.fromDoc(messageDoc));
                            });

                            return Column(
                              children: List.generate(messages.length, (index) {
                                Message _message = messages[index];
                                Message? _previousMessage;
                                if (index > 0) {
                                  _previousMessage = messages[index - 1];
                                }

                                return MessageWidget(
                                  isAuthor: _message.author == _user!.uid,
                                  rightName: mainStore.customer!.username!,
                                  leftName: "Suporte",
                                  messageData: _message,
                                  showUserData: index == 0
                                      ? true
                                      : _message.author !=
                                          _previousMessage!.author,
                                  messageBold: false,
                                );
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                DefaultAppBar('Suporte'),
                Positioned(
                  bottom: 0,
                  child: MessageBar(
                    focus: focusNode,
                    controller: store.textController,
                    onSend: () => store.sendSupportMessage(),
                    onEditingComplete: () => store.sendSupportMessage(),
                    // takePicture: () => store.sendSupportMessage(isImage: true),
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
                        color: getColors(context).background,
                        height: maxHeight(context),
                        width: maxWidth(context),
                        child: Container(
                          height: wXD(800, context),
                          width: maxWidth(context),
                          margin:
                              EdgeInsets.symmetric(vertical: wXD(58, context)),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                          alignment: Alignment.center,
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(18)),
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
                                            onTap: () => pageController.jumpToPage(index),
                                            child: Container(
                                              height: wXD(70, context),
                                              width: wXD(70, context),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 2,
                                                  color: index == store.imagesPage
                                                    ? getColors(context).primary
                                                    : Colors.transparent,
                                                ),
                                              ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  store.cancelImages();
                                },
                                icon: Icon(
                                  Icons.close_rounded,
                                  size: wXD(30, context),
                                  color: getColors(context).onBackground,
                                ),
                              ),
                              IconButton(
                                onPressed: () => store.removeImage(),
                                icon: Icon(
                                  Icons.delete_outline_rounded,
                                  size: wXD(30, context),
                                  color: getColors(context).onBackground,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // AnimatedPositioned(
                //   duration: Duration(milliseconds: 500),
                //   top: store.imagesBool ? 0 : maxHeight(context),
                //   child: Stack(
                //     alignment: Alignment.center,
                //     children: [
                //       GestureDetector(
                //         onTap: () {
                //           store.imagesBool = false;
                //           Future.delayed(Duration(milliseconds: 500),
                //               () => store.images = []);
                //         },
                //         child: Container(
                //           color: Colors.transparent,
                //           height: maxHeight(context),
                //           width: maxWidth(context),
                //         ),
                //       ),
                //       Container(
                //         height: hXD(550, context),
                //         width: wXD(300, context),
                //         margin:
                //             EdgeInsets.symmetric(vertical: wXD(58, context)),
                //         decoration: BoxDecoration(
                //           borderRadius: BorderRadius.all(Radius.circular(18)),
                //         ),
                //         alignment: Alignment.center,
                //         child: ClipRRect(
                //           borderRadius: BorderRadius.all(Radius.circular(18)),
                //           child: SingleChildScrollView(
                //             child: Column(
                //               mainAxisSize: MainAxisSize.max,
                //               children: List.generate(
                //                 store.images!.length,
                //                 (index) => Image.file(
                //                   store.images![index],
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         bottom: wXD(10, context),
                //         right: wXD(10, context),
                //         child: GestureDetector(
                //           onTap: () => store.sendImage(context),
                //           child: Container(
                //             height: wXD(50, context),
                //             width: wXD(50, context),
                //             decoration: BoxDecoration(
                //               color: getColors(context).primary,
                //               shape: BoxShape.circle,
                //             ),
                //             child: Icon(
                //               Icons.send_outlined,
                //               color: white,
                //               size: wXD(23, context),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Positioned(
                //         top: wXD(10, context) +
                //             MediaQuery.of(context).viewPadding.top,
                //         left: wXD(45, context),
                //         child: InkWell(
                //           onTap: () {
                //             store.imagesBool = false;
                //             Future.delayed(
                //               Duration(milliseconds: 500),
                //               () => store.images!.clear(),
                //             );
                //           },
                //           child: Stack(
                //             alignment: Alignment.center,
                //             children: [
                //               Icon(
                //                 Icons.close_rounded,
                //                 size: wXD(35, context),
                //                 color: white,
                //               ),
                //               Icon(Icons.close_rounded, size: wXD(30, context)),
                //             ],
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
