import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

import 'question.dart';

class AllQuestions extends StatelessWidget {
  final String adsId;

  AllQuestions({Key? key, required this.adsId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection("ads")
                .doc(adsId)
                .collection("questions")
                .orderBy("created_at", descending: true)
                .limit(5)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              }
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: wXD(24, context),
                  right: wXD(24, context),
                  // right: wXD(24, context),
                  top: viewPaddingTop(context) + wXD(60, context),
                  bottom: wXD(25, context),
                ),
                child: Column(
                  children: snapshot.data!.docs
                      .map((questionDoc) => Question(
                            answeredAt: questionDoc['answered_at'],
                            question: questionDoc['question'],
                            answer: questionDoc['answer'],
                          ))
                      .toList(),
                ),
              );
              // return Column(children: [
              //   Padding(
              //     padding: EdgeInsets.only(top: wXD(12, context)),
              //     child: Text(
              //       'Mais recentes',
              //       style: textFamily(context,
              //         fontSize: 17,
              //         fontWeight: FontWeight.w600,
              //         color: getColors(context).onBackground,
              //       ),
              //     ),
              //   ),
              //   ...snapshot.data!.docs
              //       .map((questionDoc) => Question(
              //             answeredAt: questionDoc['answered_at'],
              //             question: questionDoc['question'],
              //             answer: questionDoc['answer'],
              //           ))
              //       .toList(),
              //   SizedBox(height: wXD(13, context)),
              //   snapshot.data!.docs.length > 5
              //       ? SeeAllButton(
              //           title: 'Ver todas as perguntas',
              //           onTap: () => Modular.to.pushNamed('/product/questions'))
              //       : Container(),
              // ]);
            },
          ),
          DefaultAppBar('Perguntas'),
        ],
      ),
    );
  }
}
