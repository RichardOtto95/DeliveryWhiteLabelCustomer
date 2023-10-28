import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_customer/app/modules/profile/profile_store.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

class ProfileAppBar extends StatelessWidget {
  final ProfileStore store = Modular.get();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: getOverlayStyleFromColor(getColors(context).surface),
      child: GestureDetector(
        onTap: () => Modular.to.pushNamed('/profile/edit-profile'),
        child: Container(
          // height: wXD(91, context),
          width: maxWidth(context),
          padding: EdgeInsets.only(
            bottom: wXD(5, context),
            top: MediaQuery.of(context).viewPadding.top,
          ),
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(48)),
            color: getColors(context).surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 3,
                color: getColors(context).shadow,
                offset: Offset(0, 3),
              ),
            ],
          ),
          alignment: Alignment.bottomLeft,
          child: Observer(builder: (context) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: wXD(53, context),
                  width: wXD(53, context),
                  margin: EdgeInsets.only(
                      left: wXD(30, context), right: wXD(20, context)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // color:getColors(context).primary.withOpacity(.8),
                  ),
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(300),
                    child: store.profileEdit.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                getColors(context).primary,
                              ),
                            ),
                          )
                        : store.profileEdit['avatar'] == null ||
                                store.profileEdit['avatar'] == ''
                            ? Image.asset(
                                "./assets/images/defaultUser.png",
                                fit: BoxFit.fill,
                              )
                            : CachedNetworkImage(
                                imageUrl: store.profileEdit['avatar'],
                                fit: BoxFit.fill,
                              ),
                  ),
                ),
                Container(
                  height: wXD(53, context),
                  width: wXD(270, context),
                  padding: EdgeInsets.symmetric(vertical: wXD(4, context)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      store.profileEdit.isEmpty
                          ? Container(
                              height: wXD(14, context),
                              width: wXD(130, context),
                              child: LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  getColors(context).primary.withOpacity(.7),
                                ),
                                backgroundColor:
                                    getColors(context).primary.withOpacity(.5),
                              ),
                            )
                          : Text(
                              store.profileEdit['username'],
                              style: textFamily(
                                context,
                                color: getColors(context).onBackground,
                                fontSize: 18,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                      Spacer(),
                      Text(
                        'Editar perfil',
                        style: textFamily(
                          context,
                          color: getColors(context).primary,
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
