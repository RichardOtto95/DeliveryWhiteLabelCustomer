import 'package:delivery_customer/app/modules/cart/cart_module.dart';
import 'package:delivery_customer/app/modules/home/home_module.dart';
import 'package:delivery_customer/app/modules/orders/orders_module.dart';
import 'package:delivery_customer/app/modules/profile/profile_module.dart';
import 'package:delivery_customer/app/modules/search/search_module.dart';
import 'package:delivery_customer/app/shared/color_theme.dart';
import 'package:delivery_customer/app/shared/utilities.dart';
import 'package:delivery_customer/app/shared/widgets/custom_nav_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core/modules/root/root_store.dart';
import 'main_store.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends ModularState<MainPage, MainStore> {
  final RootStore rootStore = Modular.get();
  @override
  void initState() {
    if(!kIsWeb){
      FirebaseMessaging.instance.onTokenRefresh.listen(store.saveTokenToDatabase);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        store.setVisibleNav(true);
        return false;
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: getOverlayStyleFromColor(white),
        child: Observer(
          builder: (context) {
            return MaterialApp(
              theme: MyThemes.lightTheme,
              darkTheme: MyThemes.darkTheme,
              // themeMode: rootStore.themeMode,
              home: Scaffold(
                // backgroundColor: getColors(context).background,
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ScrollConfiguration(
                      behavior: ScrollBehaviorModified(),
                      child: Container(
                        height: maxHeight(context),
                        width: maxWidth(context),
                        child: PageView(
                          controller: store.pageController,
                          scrollDirection: Axis.horizontal,
                          children: [
                            HomeModule(),
                            CartModule(),
                            SearchModule(),
                            OrdersModule(),
                            ProfileModule(),
                          ],
                          onPageChanged: (value) {
                            store.page = value;
                            store.setVisibleNav(true);
                          },
                        ),
                      ),
                    ),
                    Observer(
                      builder: (context) {
                        return AnimatedPositioned(
                          duration: Duration(seconds: 2),
                          curve: Curves.bounceOut,
                          bottom: store.visibleNav ? 0 : wXD(-85, context),
                          child: CustomNavBar(),
                        );
                      },
                    ),
                    // Observer(
                    //   builder: (context) {
                    //     return AnimatedPositioned(
                    //       duration: Duration(seconds: 1),
                    //       curve: Curves.bounceOut,
                    //       bottom:
                    //           store.visibleNav ? wXD(42, context) : wXD(-68, context),
                    //       child: Observer(
                    //         builder: (context) {
                    //           // print('page: ${store.page}');
                    //           return FloatingCircleButton(
                    //             onTap: () => store.setPage(2),
                    //             // onTap: () async {
                    //             // final response = await cloudFunction(
                    //             //     function: "sendProduct", object: {});
                    //             // print("Response: $response");
                    //             // FirebaseFunctions.instance
                    //             //     .useFunctionsEmulator("localhost", 5001);
                    //             // HttpsCallable callable = FirebaseFunctions.instance
                    //             //     .httpsCallable("sendProduct");
                    //             // HttpsCallableResult result = await callable.call();
                    //             // print(result.data);

                    //             // final kmPerGrado = 6371 / 360;
                    //             // Map p0 = {
                    //             //   "latitude": -15.792025,
                    //             //   "longitude": -48.051446
                    //             // };
                    //             // Map p = {
                    //             //   "latitude": -15.787080,
                    //             //   "longitude": -48.007115
                    //             // };
                    //             // // final storePosition = {
                    //             // //     "latitude": -15.814885,
                    //             // //     "longitude": -48.066853,
                    //             // // };
                    //             // double latDg = p0["latitude"] - p["latitude"];
                    //             // if (latDg < 0) {
                    //             //   latDg = latDg * -1;
                    //             // }
                    //             // double lngDg = p0["longitude"] - p["longitude"];
                    //             // if (lngDg < 0) {
                    //             //   lngDg = lngDg * -1;
                    //             // }

                    //             // print("latDg: $latDg");
                    //             // print("lngDg: $lngDg");

                    //             // double d = sqrt(
                    //             //     (pow((latDg * 1852), 2) + pow(lngDg * 1852, 2)));

                    //             // print("d: $d");
                    //             // },
                    //             iconColor: store.page == 2 ?getColors(context).primary : white,
                    //           );
                    //         },
                    //       ),
                    //     );
                    //   },
                    // )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ScrollBehaviorModified extends ScrollBehavior {
  const ScrollBehaviorModified();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics());
    // switch (getPlatform(context)) {
    //   case TargetPlatform.iOS:
    //   case TargetPlatform.macOS:
    //   case TargetPlatform.android:
    //     return const BouncingScrollPhysics();
    //   case TargetPlatform.fuchsia:
    //   case TargetPlatform.linux:
    //   case TargetPlatform.windows:
    //     return const ClampingScrollPhysics();
    // }
  }
}
