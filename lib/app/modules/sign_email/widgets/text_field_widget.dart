import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final void Function()? onComplete;
  final String? Function(String) validator;
  final void Function(String) onChanged;
  final TextInputType? keyboardType;
  final bool password;
  final FocusNode focusNode;
  const TextFieldWidget({
    Key? key,
    required this.title,
    required this.controller,
    required this.validator,
    required this.onChanged,
    required this.focusNode,
    this.onComplete,
    this.keyboardType,
    this.password = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int index = 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textFamily(
            context,
            fontSize: 20,
            color: getColors(context).onBackground.withOpacity(.5),
            fontWeight: FontWeight.w400,
          ),
        ),
        StatefulBuilder(builder: (context, setState) {
          return Row(
            children: [
              Expanded(
                child: TextFormField(
                  focusNode: focusNode,
                  style: textFamily(context, fontSize: 20),
                  keyboardType: keyboardType,
                  obscureText: index == 0
                      ? password
                      : index == 1
                          ? true
                          : false,
                  decoration: InputDecoration.collapsed(hintText: ''),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (val) {
                    print('val: $val');
                    onChanged(val);
                  },
                  validator: (value) {
                    print('value validator: $value');

                    return validator(value!);
                  },
                  onEditingComplete: onComplete,
                  controller: controller,
                ),
              ),
              password
                  ? Container(
                      child: InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          setState(() {
                            if (index == 0) {
                              index = 2;
                            } else if (index == 1) {
                              index = 2;
                            } else {
                              index = 1;
                            }
                          });
                        },
                        child: Icon(
                          index == 2 ? Icons.visibility : Icons.visibility_off,
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        }),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: black.withOpacity(.3)),
            ),
          ),
        ),
      ],
    );
  }
}
