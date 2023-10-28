import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_customer/app/modules/profile/widget/ratings_app_bar.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Ratings extends StatelessWidget {
  const Ratings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List ratings = [
      {
        'name': 'Samsung Falaxy A51+aaaaaa aaaaaa aaaaa',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'image': '',
        'grade': 5.0,
      },
      {
        'name': 'Samsung Falaxy A51+',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'grade': 4.0,
        'image': 'https://t2.tudocdn.net/518979?w=660&h=643',
      },
      {
        'name': 'Samsung Falaxy A51+',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'grade': 3.0,
        'image': 'https://t2.tudocdn.net/518979?w=660&h=643',
      },
      {
        'name': 'Samsung Falaxy A51+',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'grade': 2.0,
        'image': 'https://t2.tudocdn.net/518979?w=660&h=643',
      },
      {
        'name': 'Samsung Falaxy A51+',
        'description':
            'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum ',
        'grade': 1.0,
        'image': 'https://t2.tudocdn.net/518979?w=660&h=643',
      },
    ];
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: wXD(123, context)),
                ...ratings.map(
                  (rating) => Rating(
                    requestDate: 'Qua 25 outubro 2020',
                    name: rating['name'],
                    image: rating['image'],
                    grade: rating['grade'],
                    description: rating['description'],
                    onTap: () => Modular.to.pushNamed('/profile/answer-rating'),
                  ),
                ),
                SizedBox(height: wXD(120, context))
              ],
            ),
          ),
          RatingsAppbar(),
        ],
      ),
    );
  }
}

class Rating extends StatelessWidget {
  final String name, description, image, requestDate;
  final double grade;
  final void Function() onTap;
  Rating({
    Key? key,
    required this.name,
    required this.image,
    required this.grade,
    required this.description,
    required this.requestDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              bottom: wXD(6, context),
              left: wXD(4, context),
              top: wXD(20, context),
            ),
            child: Text(
              requestDate,
              style: textFamily(
                context,
                fontSize: 14,
                color: getColors(context).onBackground,
              ),
            ),
          ),
          Container(
            height: wXD(105, context),
            width: wXD(352, context),
            padding: EdgeInsets.fromLTRB(
              wXD(19, context),
              wXD(15, context),
              wXD(15, context),
              wXD(7, context),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Color(0xffF1F1F1)),
              borderRadius: BorderRadius.all(Radius.circular(11)),
              color: white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  offset: Offset(0, 3),
                  color: getColors(context).shadow,
                )
              ],
            ),
            child: InkWell(
              onTap: onTap,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: wXD(12, context)),
                    child: ClipRRect(
                      child: image == ''
                          ? Image.asset(
                              'assets/images/no-image-icon.png',
                              height: wXD(65, context),
                              width: wXD(62, context),
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              imageUrl: image,
                              height: wXD(65, context),
                              width: wXD(62, context),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: wXD(8, context)),
                    width: wXD(220, context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: textFamily(context, color: black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: wXD(3, context)),
                        Text(
                          description,
                          style: textFamily(context,
                              color: lightGrey, fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        // SizedBox(height: wXD(3, context)),
                        // Text(
                        //   '${grade.toString()} item',
                        //   style: textFamily(context,
                        //       color: grey.withOpacity(.7)),
                        //   maxLines: 2,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                        RatingBar(
                          initialRating: grade,
                          onRatingUpdate: (value) {},
                          ignoreGestures: true,
                          glowColor: getColors(context).primary.withOpacity(.4),
                          unratedColor:
                              getColors(context).primary.withOpacity(.4),
                          allowHalfRating: true,
                          itemSize: wXD(25, context),
                          ratingWidget: RatingWidget(
                            full: Icon(Icons.star_rounded,
                                color: getColors(context).primary),
                            empty: Icon(Icons.star_outline_rounded,
                                color: getColors(context).primary),
                            half: Icon(Icons.star_half_rounded,
                                color: getColors(context).primary),
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
            ),
          )
        ],
      ),
    );
  }
}
