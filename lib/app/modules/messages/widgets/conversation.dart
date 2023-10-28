import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../core/models/time_model.dart';
import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';

class Conversation extends StatelessWidget {
  final Map<String, dynamic> conversationData;

  const Conversation({
    Key? key,
    required this.conversationData,
  }) : super(key: key);

  @override
  Widget build(context) {
    String receiverCollection = "";
    String receiverId = "";

    if (conversationData["seller_id"] != null) {
      receiverCollection = "sellers";
      receiverId = conversationData["seller_id"];
    } else {
      receiverCollection = "agents";
      receiverId = conversationData["agent_id"];
    }

    return InkWell(
      onTap: () => Modular.to.pushNamed('/messages/chat', arguments: {
        "receiverId": receiverId,
        "receiverCollection": receiverCollection,
      }),
      child: Container(
        height: wXD(70, context),
        width: maxWidth(context),
        margin: EdgeInsets.only(left: wXD(15, context), right: wXD(6, context)),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: grey.withOpacity(.3)))),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection(receiverCollection)
              .doc(receiverId)
              .snapshots(),
          builder: (context, recSnap) {
            if (!recSnap.hasData) {
              return CircularProgressIndicator();
            }
            DocumentSnapshot recDoc = recSnap.data!;
            return Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2),
                  margin: EdgeInsets.only(right: wXD(10, context)),
                  decoration: BoxDecoration(
                    color: getColors(context).onBackground,
                    shape: BoxShape.circle,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: recDoc["avatar"] == null
                        ? Image.asset(
                            './assets/images/defaultUser.png',
                            fit: BoxFit.cover,
                            height: wXD(45, context),
                            width: wXD(45, context),
                          )
                        : CachedNetworkImage(
                            imageUrl: recDoc["avatar"].toString(),
                            fit: BoxFit.cover,
                            height: wXD(45, context),
                            width: wXD(45, context),
                          ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recDoc["username"],
                        style: textFamily(context, fontSize: 18),
                      ),
                      Text(
                        conversationData["last_update"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textFamily(
                          context,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: wXD(75, context),
                  margin: EdgeInsets.only(left: wXD(6, context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        Time(conversationData["updated_at"].toDate(),
                                capitalize: true)
                            .chatTime(),
                        maxLines: 1,
                        // overflow: TextOverflow.ellipsis,
                        style: textFamily(
                          context,
                          fontWeight: FontWeight.w400,
                          color: getColors(context).onSurface,
                        ),
                      ),
                      Visibility(
                        visible:
                            conversationData["customer_notifications"] != 0,
                        child: Container(
                          height: wXD(22, context),
                          width: wXD(22, context),
                          margin: EdgeInsets.only(top: wXD(4, context)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getColors(context).primary,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            conversationData["customer_notifications"]
                                .toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textFamily(
                              context,
                              fontWeight: FontWeight.w400,
                              color: brightness == Brightness.light
                                  ? white
                                  : black,
                            ),
                          ),
                        ),
                      ),
                    ],
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
