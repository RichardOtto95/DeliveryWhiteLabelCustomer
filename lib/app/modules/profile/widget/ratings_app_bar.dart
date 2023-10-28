import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RatingsAppbar extends StatelessWidget {
  const RatingsAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: wXD(104, context),
          padding: EdgeInsets.symmetric(horizontal: wXD(30, context)),
          width: maxWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
            color: white,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                offset: Offset(0, 3),
                color: getColors(context).shadow,
              ),
            ],
          ),
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Avaliações',
                style: textFamily(
                  context,
                  fontSize: 20,
                  color: darkBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: wXD(10, context)),
              DefaultTabController(
                length: 2,
                child: TabBar(
                  indicatorColor: getColors(context).primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.symmetric(vertical: 8),
                  labelColor: getColors(context).primary,
                  labelStyle: textFamily(context, fontWeight: FontWeight.bold),
                  unselectedLabelColor: getColors(context).onBackground,
                  indicatorWeight: 3,
                  tabs: [
                    Text('Pendentes'),
                    Text('Concluídas'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: wXD(30, context),
          top: wXD(33, context),
          child: GestureDetector(
            onTap: () => Modular.to.pop(),
            child: Icon(Icons.arrow_back,
                color: getColors(context).onBackground, size: wXD(25, context)),
          ),
        )
      ],
    );
  }
}
