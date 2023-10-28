import 'package:delivery_customer/app/modules/search/search_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RecentSearch extends StatelessWidget {
  final String text;
  RecentSearch({Key? key, required this.text}) : super(key: key);

  final SearchStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        store.searchText = text;
        store.textEditingController.text = text;
        store.getSearchedItems();
      },
      onLongPress: () => store.removeRecentSearch(text),
      child: Container(
        width: maxWidth(context),
        height: wXD(61, context),
        margin: EdgeInsets.symmetric(horizontal: wXD(16, context)),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: getColors(context).onBackground.withOpacity(.3)))),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(
              Icons.av_timer,
              color: getColors(context).onBackground.withOpacity(.5),
              size: wXD(22, context),
            ),
            SizedBox(width: wXD(8, context)),
            Expanded(
              child: Text(
                text,
                style: textFamily(
                  context,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: getColors(context).onBackground,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
