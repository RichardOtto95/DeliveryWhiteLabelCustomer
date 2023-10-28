import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class SearchMessages extends StatefulWidget {
  final void Function(String) onChanged;

  SearchMessages({Key? key, required this.onChanged}) : super(key: key);
  @override
  _SearchMessagesState createState() => _SearchMessagesState();
}

class _SearchMessagesState extends State<SearchMessages> {
  FocusNode searchFocus = FocusNode();
  // bool searching = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: maxWidth(context) - wXD(16, context),
      height: wXD(41, context),
      decoration: BoxDecoration(
        color: getColors(context).surface,
        border: Border(
            bottom: BorderSide(
                color: getColors(context).onSurface.withOpacity(.3))),
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 3,
        //     offset: Offset(0, 3),
        //   ),
        // ],
      ),
      alignment: Alignment.center,
      child: Material(
        color: Colors.transparent,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: wXD(65, context),
              ),
              AnimatedContainer(
                duration: Duration(seconds: 1),
                curve: Curves.easeInOutQuart,
                width: wXD(200, context),
                alignment: Alignment.center,
                child: TextField(
                  onChanged: widget.onChanged,
                  focusNode: searchFocus,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Buscar mensagens',
                    hintStyle: textFamily(
                      context,
                      fontSize: 14,
                      color: getColors(context).onSurface.withOpacity(.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: wXD(65, context),
                child: Padding(
                  padding: EdgeInsets.only(left: wXD(35, context)),
                  child: Icon(
                    Icons.search,
                    size: wXD(26, context),
                    color: getColors(context).onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
