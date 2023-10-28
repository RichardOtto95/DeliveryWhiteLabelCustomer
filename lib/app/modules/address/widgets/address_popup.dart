import 'dart:ui';
import 'package:delivery_customer/app/core/models/address_model.dart';
import 'package:delivery_customer/app/shared/widgets/white_button.dart';
import 'package:flutter/material.dart';

import '../../../shared/utilities.dart';

class AddressPopUp extends StatelessWidget {
  final void Function() onCancel, onEdit, onDelete;
  final Address model;
  const AddressPopUp({
    Key? key,
    required this.onCancel,
    required this.onEdit,
    required this.onDelete,
    required this.model, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: onCancel,
            child: Container(
              height: maxHeight(context),
              width: maxWidth(context),
              color: getColors(context).shadow,
            ),
          ),
          Container(
            width: maxWidth(context),
            height: wXD(164, context),
            decoration: BoxDecoration(
              color: getColors(context).surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  offset: Offset(0, -5),
                  color: getColors(context).shadow,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Material(
              borderRadius: BorderRadius.vertical(top: Radius.circular(56)),
              color: getColors(context).surface,
              child: Column(
                children: [
                  SizedBox(height: wXD(16, context)),
                  Container(
                    width: wXD(300, context),
                    alignment: Alignment.center,
                    child: Text(
                      model.formatedAddress!,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: textFamily(
                        context,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: getColors(context).onBackground,
                      ),
                    ),
                  ),
                  Text(
                    '${model.neighborhood}, ${model.city} - ${model.state}',
                    style: textFamily(
                      context,
                      fontWeight: FontWeight.w400,
                      color: getColors(context).onBackground.withOpacity(.8),
                    ),
                  ),
                  SizedBox(height: wXD(16, context)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WhiteButton(
                        text: 'Excluir',
                        icon: Icons.delete_outline,
                        onTap: onDelete,
                      ),
                      SizedBox(width: wXD(21, context)),
                      WhiteButton(
                        text: 'Editar',
                        icon: Icons.edit_outlined,
                        onTap: onEdit,
                      ),
                    ],
                  ),
                  SizedBox(height: wXD(13, context)),
                  InkWell(
                    onTap: onCancel,
                    child: Text(
                      'Cancelar',
                      style: textFamily(
                        context,
                        fontWeight: FontWeight.w500,
                        color: getColors(context).error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
