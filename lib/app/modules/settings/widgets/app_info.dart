import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppInfo extends StatelessWidget {
  const AppInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: viewPaddingTop(context) + wXD(60, context)),
                Text(
                  'Lorem ipsum',
                  style: textFamily(
                    context,
                    color: getColors(context).primary,
                    fontSize: 23,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Container(
                  width: maxWidth(context),
                  padding: EdgeInsets.symmetric(
                    horizontal: wXD(15, context),
                    vertical: wXD(17, context),
                  ),
                  child: Text(
                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd guergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. \nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.\nLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore',
                    style: textFamily(
                      context,
                      color: getColors(context).onBackground,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Link(
                      icon: FontAwesomeIcons.facebookSquare,
                      name: "Facebook",
                      description: "facebook.com.br",
                    ),
                    Link(
                      icon: FontAwesomeIcons.instagram,
                      name: "Instagram",
                      description: "Instagram.com.br",
                    ),
                    Link(
                      icon: FontAwesomeIcons.twitter,
                      name: "Twitter",
                      description: "Twitter.com.br",
                    ),
                    Link(
                      icon: FontAwesomeIcons.youtube,
                      name: "YouTube",
                      description: "YouTube.com.br",
                    ),
                    Link(
                      icon: FontAwesomeIcons.linkedin,
                      name: "Linkedin",
                      description: "facebook.com.br",
                    ),
                  ],
                ),
              ],
            ),
          ),
          DefaultAppBar('Informações do app'),
        ],
      ),
    );
  }
}

class Link extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;

  const Link({
    Key? key,
    required this.icon,
    required this.name,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Row(
          children: [
            Container(
              // padding: EdgeInsets.only(left: wXD(15, context)),
              child: IconButton(icon: FaIcon(icon), onPressed: () {}),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(top: wXD(1, context)),
                  child: Text(
                    '$name',
                    style: TextStyle(
                        color: Color(0xff707070),
                        fontSize: wXD(13, context),
                        fontWeight: FontWeight.w800),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '$description',
                    style: textFamily(context,
                        color: getColors(context).primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
