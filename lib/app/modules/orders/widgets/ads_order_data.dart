import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../shared/color_theme.dart';
import '../../../shared/utilities.dart';

class AdsOrderData extends StatelessWidget {
  final DocumentSnapshot adsDoc;
  final num totalItems;

  AdsOrderData({
    Key? key,
    required this.adsDoc,
    required this.totalItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: getColors(context).onSurface.withOpacity(.2)))),
      padding: EdgeInsets.only(bottom: wXD(7, context)),
      margin: EdgeInsets.fromLTRB(
        wXD(19, context),
        wXD(18, context),
        wXD(15, context),
        wXD(0, context),
      ),
      alignment: Alignment.center,
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
          .collection("ads")
          .doc(adsDoc["id"])
          .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return adsOrderDataSkeleton(context);
          }
          DocumentSnapshot pdt = snapshot.data!;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: pdt['images'].first,
                  height: wXD(65, context),
                  width: wXD(62, context),
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: wXD(8, context)),
                    width: wXD(220, context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: wXD(3, context)),
                        Text(
                          pdt['title'],
                          style: textFamily(context,
                              color: getColors(context).onBackground),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: wXD(3, context)),
                        SizedBox(
                          height: wXD(35, context),
                          child: Text(
                            pdt['description'],
                            style: textFamily(context, color: lightGrey),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(height: wXD(3, context)),
                        Text(
                          totalItems > 1
                              ? "$totalItems itens"
                              : '$totalItems item',
                          style: textFamily(context,
                              color: getColors(context).onSurface),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: wXD(10, context)),
                  Icon(
                    Icons.arrow_forward,
                    size: wXD(14, context),
                    color: getColors(context).onSurface,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  adsOrderDataSkeleton(context) => Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: wXD(65, context),
                width: wXD(62, context),
                child: LinearProgressIndicator(
                  backgroundColor: lightGrey.withOpacity(.6),
                  valueColor: AlwaysStoppedAnimation(veryLightGrey),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: wXD(8, context)),
                    width: wXD(220, context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: wXD(3, context)),
                        Container(
                          height: wXD(14, context),
                          width: wXD(130, context),
                          child: LinearProgressIndicator(
                            backgroundColor: lightGrey.withOpacity(.6),
                            valueColor: AlwaysStoppedAnimation(veryLightGrey),
                          ),
                        ),
                        SizedBox(height: wXD(3, context)),
                        Container(
                          height: wXD(14, context),
                          width: wXD(130, context),
                          child: LinearProgressIndicator(
                            backgroundColor: lightGrey.withOpacity(.6),
                            valueColor: AlwaysStoppedAnimation(veryLightGrey),
                          ),
                        ),
                        SizedBox(height: wXD(3, context)),
                        Container(
                          height: wXD(14, context),
                          width: wXD(130, context),
                          child: LinearProgressIndicator(
                            backgroundColor: lightGrey.withOpacity(.6),
                            valueColor: AlwaysStoppedAnimation(veryLightGrey),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: wXD(10, context)),
                  Icon(
                    Icons.arrow_forward,
                    size: wXD(14, context),
                    color: grey.withOpacity(.7),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
}
