import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery_customer/app/core/services/auth/auth_store.dart';
import 'package:delivery_customer/app/modules/main/main_store.dart';
import 'package:delivery_customer/app/modules/profile/widget/profile_app_bar.dart';
import 'package:delivery_customer/app/modules/profile/widget/profile_tile.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/center_load_circular.dart';
import 'package:delivery_customer/app/shared/widgets/confirm_popup.dart';
import 'package:delivery_customer/app/shared/widgets/load_circular_overlay.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:delivery_customer/app/modules/profile/profile_store.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String title;
  const ProfilePage({Key? key, this.title = 'ProfilePage'}) : super(key: key);
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final ProfileStore store = Modular.get();
  final MainStore mainStore = Modular.get();
  final AuthStore authStore = Modular.get();
  final ScrollController scrollController = ScrollController();
  late OverlayEntry overlayEntry;
  OverlayEntry? overlayCircular;

  @override
  initState() {
    // store.setProfileEditFromDoc();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
              ScrollDirection.reverse &&
          mainStore.visibleNav) {
        mainStore.setVisibleNav(false);
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          !mainStore.visibleNav) {
        mainStore.setVisibleNav(true);
      }
    });
    super.initState();
  }

  @override
  dispose() {
    scrollController.dispose();
    super.dispose();
  }

  bool canBack = true;

  OverlayEntry getOverlay() {
    return OverlayEntry(
      builder: (context) => ConfirmPopup(
        text: 'Tem certeza que deseja sair?',
        onConfirm: () async {
          overlayCircular =
              OverlayEntry(builder: (context) => LoadCircularOverlay());
          overlayEntry.remove();

          Overlay.of(context)!.insert(overlayCircular!);
          if(kIsWeb){
            User? _user = FirebaseAuth.instance.currentUser;
            String? token = await FirebaseMessaging.instance.getToken();
            await FirebaseFirestore.instance
                .collection('customers')
                .doc(_user!.uid)
                .update({
              'token_id': FieldValue.arrayRemove([token]),
            });
          }

          authStore.signout();
          mainStore.page = 0;
          canBack = true;

          overlayCircular!.remove();
          overlayCircular = null;
          Modular.to.pushReplacementNamed("/sign-phone");
          // mainStore.dispose();
        },
        onCancel: () {
          overlayEntry.remove();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => canBack,
      child: Observer(builder: (context) {
        if (store.profileEdit.isEmpty) {
          return CenterLoadCircular();
        }
        return Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(height: viewPaddingTop(context) + wXD(53, context)),
                  ProfileTile(
                    // icon: Icons.monetization_on,
                    icon: Icons.people,
                    title: 'Convide amigos',
                    onTap: () =>
                        Modular.to.pushNamed('/profile/user-promotional-code'),
                    // onTap: (){},
                  ),
                  ProfileTile(
                    icon: Icons.list_alt,
                    title: 'Cupons',
                    onTap: () => Modular.to.pushNamed('/profile/coupons'),
                    // notifications: store.profileEdit['new_coupons'],
                  ),
                  ProfileTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notificações',
                    onTap: () => Modular.to.pushNamed('/profile/notifications'),
                    notifications: store.profileEdit['new_notifications'],
                  ),
                  ProfileTile(
                    icon: Icons.email_outlined,
                    title: 'Mensagens',
                    onTap: () => Modular.to.pushNamed('/messages'),
                    notifications: store.profileEdit['new_messages'],
                  ),
                  ProfileTile(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Pagamento',
                    onTap: () => Modular.to.pushNamed('/payment'),
                  ),
                  ProfileTile(
                    icon: Icons.favorite_outline,
                    title: 'Favoritos',
                    onTap: () => Modular.to.pushNamed('/profile/favorites'),
                  ),
                  ProfileTile(
                    icon: Icons.headset_mic_outlined,
                    title: 'Suporte',
                    onTap: () {
                      Modular.to.pushNamed('/support');
                    },
                    notifications: store.profileEdit['new_support_messages'],
                  ),
                  ProfileTile(
                    icon: Icons.settings_outlined,
                    title: 'Configurações',
                    onTap: () => Modular.to.pushNamed('/profile/settings'),
                  ),
                  ProfileTile(
                    icon: Icons.exit_to_app_outlined,
                    title: 'Sair',
                    onTap: () {
                      overlayEntry = getOverlay();
                      Overlay.of(context)?.insert(overlayEntry);
                    },
                  ),
                  SizedBox(height: wXD(120, context))
                ],
              ),
            ),
            Positioned(top: 0, child: ProfileAppBar()),
          ],
        );
      }),
    );
  }
}
