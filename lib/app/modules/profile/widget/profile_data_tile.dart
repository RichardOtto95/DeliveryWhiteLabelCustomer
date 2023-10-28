import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ProfileDataTile extends StatelessWidget {
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputFormatter? inputFormatter;
  final MaskTextInputFormatter? mask;
  final void Function()? onPressed;
  final void Function()? onComplete;
  final FocusNode focusNode;
  final String title, hint;
  final bool? validate;
  final String? data;
  final int? length;
  final TextInputType? textInputType;
  final bool? enabled;

  const ProfileDataTile({
    Key? key,
    required this.focusNode,
    required this.title,
    required this.hint,
    this.onComplete,
    this.validator,
    this.onChanged,
    this.onPressed,
    this.validate,
    this.length,
    this.mask,
    this.data,
    this.textInputType,
    this.enabled,
    this.inputFormatter,
  }) : super(key: key);

  @override
  Widget build(context) {
    print("$title pressed null ${onPressed == null}");
    return Listener(
      onPointerDown: (abc) => FocusScope.of(context).requestFocus(FocusNode()),
      child: Stack(
        children: [
          Container(
            width: maxWidth(context),
            margin: EdgeInsets.symmetric(horizontal: wXD(23, context)),
            padding: EdgeInsets.fromLTRB(
              wXD(11, context),
              wXD(18, context),
              0,
              wXD(18, context),
            ),
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color:
                            getColors(context).onBackground.withOpacity(.2)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textFamily(
                    context,
                    color: getColors(context).onBackground,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                onPressed == null
                    ? Container(
                        width: wXD(321, context),
                        child: TextFormField(
                          enabled: enabled,
                          keyboardType: textInputType,
                          cursorColor: getColors(context).primary,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          initialValue: data,
                          focusNode: focusNode,
                          inputFormatters: mask != null
                              ? [mask!]
                              : inputFormatter != null
                                  ? [inputFormatter!]
                                  : [],
                          decoration: InputDecoration.collapsed(
                            hintText: hint,
                            hintStyle: textFamily(
                              context,
                              color: getColors(context)
                                  .onBackground
                                  .withOpacity(.4),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          validator: (val) {
                            print("Title: $title   Val: $val");
                            String _text = '';
                            if (mask != null) {
                              _text = mask!.unmaskText(val ?? '');
                            } else {
                              _text = val ?? '';
                            }
                            print("Text: $_text");
                            if (_text == '') {
                              return "Este campo não pode ser vazio";
                            }
                            if (length != null && length != _text.length) {
                              return "Preencha o campo $title por completo";
                            }
                            if (validator != null) {
                              return validator!(val);
                            }
                          },
                          onChanged: (txt) {
                            String _text = txt;
                            if (mask != null) {
                              // print("unmasked: ${mask!.unmaskText(txt)}");
                              _text = mask!.unmaskText(txt);
                            }
                            // print("_text: $_text");
                            onChanged!(_text);
                          },
                          onEditingComplete: onComplete,
                        ),
                      )
                    : GestureDetector(
                        onTap: onPressed,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Focus(
                              focusNode: focusNode,
                              child: Container(
                                width: wXD(321, context),
                                child: Text(
                                  data ?? hint,
                                  style: textFamily(
                                    context,
                                    color: data != null
                                        ? getColors(context).onSurface
                                        : getColors(context)
                                            .onSurface
                                            .withOpacity(.4),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            // validate != null && validate!
                            //     ?
                            Visibility(
                              visible: validate != null && validate!,
                              child: Text(
                                "Este campo não pode ser vazio",
                                style: TextStyle(
                                  color: Colors.red[600],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            // : Container(),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          Positioned(
            top: wXD(18, context),
            right: wXD(20, context),
            child: InkWell(
              onTap: () =>
                  onPressed == null ? focusNode.requestFocus() : onPressed!(),
              child: Icon(
                Icons.edit_outlined,
                color: getColors(context).primary,
                size: wXD(19, context),
              ),
            ),
          )
        ],
      ),
    );
  }
}
