import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';

import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:delivery_customer/app/shared/widgets/empty_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter/material.dart';

import '../../core/models/message_model.dart';
import '../../core/models/time_model.dart';
import 'messages_store.dart';
import 'widgets/conversation.dart';
import 'widgets/search_messages.dart';

class MessagesPage extends StatefulWidget {
  final String title;
  const MessagesPage({Key? key, this.title = 'MessagesPage'}) : super(key: key);
  @override
  MessagesPageState createState() => MessagesPageState();
}

class MessagesPageState extends State<MessagesPage> {
  final User? _user = FirebaseAuth.instance.currentUser!;
  final MessagesStore store = Modular.get();
  bool searching = false;
  FocusNode searchFocus = FocusNode();

  @override
  void initState() {
    print('_user: ${_user!.uid}');
    store.clearNewMessages();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        store.disposeMessages();
        return true;
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("chats")
                    .where("customer_id", isEqualTo: _user!.uid)
                    .orderBy("updated_at", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CenterLoadCircular();
                  }

                  List<QueryDocumentSnapshot<Map<String, dynamic>>>
                      conversations = snapshot.data!.docs;

                  print('conversations: ${conversations.length}');

                  return Column(
                    children: [
                      SizedBox(
                          height: viewPaddingTop(context) + wXD(60, context)),
                      SearchMessages(
                        onChanged: (txt) =>
                            store.searchMessages(txt, snapshot.data!),
                      ),
                      Container(
                        width: maxWidth(context),
                        height: wXD(41, context),
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: wXD(29, context), top: wXD(15, context)),
                          child: Text(
                            'Minhas conversas',
                            style: textFamily(
                              context,
                              fontSize: 17,
                              color: getColors(context).onBackground,
                            ),
                          ),
                        ),
                      ),
                      Listener(
                        onPointerDown: (_) =>
                            FocusScope.of(context).requestFocus(FocusNode()),
                        child: Observer(
                          builder: (context) {
                            if (store.searchedChats != null ||
                                store.searchedMessages != null) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (store.searchedChats!.isEmpty &&
                                      store.searchedMessages!.isEmpty)
                                    EmptyState(
                                      text:
                                          "Nenhuma mensagem ou conversa foi encontrada",
                                      icon: Icons.message,
                                    ),
                                  // Center(
                                  //   child: Column(
                                  //     children: [
                                  //       SizedBox(height: wXD(90, context)),
                                  //       Icon(
                                  //         Icons.email_outlined,
                                  //         size: wXD(130, context),
                                  //         color: lightGrey,
                                  //       ),
                                  //       Padding(
                                  //         padding: EdgeInsets.symmetric(
                                  //             vertical: wXD(20, context)),
                                  //         child: Text(
                                  //           "Nada semelhante encontrado.",
                                  //           style: textFamily(
                                  //             context,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  if (store.searchedChats!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: wXD(10, context),
                                        top: wXD(10, context),
                                      ),
                                      child: Text(
                                        "Conversas",
                                        style:
                                            textFamily(context, fontSize: 17),
                                      ),
                                    ),
                                  ...store.searchedChats!
                                      .map(
                                        (chat) => Conversation(
                                          conversationData: chat.data()!,
                                        ),
                                      )
                                      .toList(),
                                  if (store.searchedMessages!.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: wXD(10, context),
                                        top: wXD(10, context),
                                      ),
                                      child: Text(
                                        "Mensagens",
                                        style:
                                            textFamily(context, fontSize: 17),
                                      ),
                                    ),
                                  ...store.searchedMessages!.map(
                                    (messageTitle) => MessageSearched(
                                        messageTitle: messageTitle),
                                  ),
                                ],
                              );
                            }
                            if (conversations.isEmpty) {
                              return EmptyState(
                                text: "Nenhuma conversa ainda",
                                icon: Icons.message,
                              );
                              // return Center(
                              //   child: Column(
                              //     children: [
                              //       SizedBox(height: wXD(90, context)),
                              //       Icon(
                              //         Icons.email_outlined,
                              //         size: wXD(130, context),
                              //         color: lightGrey,
                              //       ),
                              //       Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: wXD(20, context)),
                              //         child: Text(
                              //           "Você ainda não possui conversas",
                              //           style: textFamily(
                              //             context,
                              //           ),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // );
                            }
                            return Column(
                              children: conversations
                                  .map(
                                    (conversation) => Conversation(
                                        conversationData: conversation.data()),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: wXD(70, context))
                    ],
                  );
                },
              ),
            ),
            DefaultAppBar('Mensagens')
          ],
        ),
        // floatingActionButton: FloatingCircleButton(
        //   onTap: () {},
        //   size: wXD(56, context),
        //   child: Icon(
        //     Icons.add,
        //     size: wXD(30, context),
        //     color:getColors(context).primary,
        //   ),
        // ),
      ),
    );
  }
}

class MessageSearched extends StatelessWidget {
  final SearchMessage messageTitle;
  const MessageSearched({Key? key, required this.messageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Modular.to.pushNamed('/messages/chat', arguments: {
        "receiverId": messageTitle.receiverId,
        "receiverCollection": messageTitle.receiverCollection,
        "messageId": messageTitle.message.id,
      }),
      child: Container(
        width: maxWidth(context),
        padding: EdgeInsets.symmetric(
          horizontal: wXD(8, context),
          vertical: wXD(10, context),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  messageTitle.title,
                  style: textFamily(context, fontSize: 15),
                ),
                Text(
                  Time(messageTitle.message.createdAt!.toDate()).chatTime(),
                  style: textFamily(context, fontSize: 11),
                )
              ],
            ),
            SizedBox(height: wXD(3, context)),
            Text(
              messageTitle.message.text!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textFamily(context, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
