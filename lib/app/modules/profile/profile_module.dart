import 'package:delivery_customer/app/modules/profile/profile_Page.dart';
import 'package:delivery_customer/app/modules/profile/profile_store.dart';
import 'package:delivery_customer/app/modules/profile/widget/answer_rating.dart';
import 'package:delivery_customer/app/modules/profile/widget/edit_profile.dart';
import 'package:delivery_customer/app/modules/profile/widget/favorites.dart';
import 'package:delivery_customer/app/modules/profile/widget/user_pormotional_code.dart';
import 'package:delivery_customer/app/modules/settings/settings_page.dart';
import 'package:delivery_customer/app/modules/settings/widgets/app_info.dart';
// ignore: implementation_imports
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widget/coupons.dart';
import 'widget/notifications.dart';
import 'widget/privacy.dart';
import 'widget/ratings.dart';
import 'widget/terms.dart';

class ProfileModule extends WidgetModule {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ProfileStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    // ChildRoute('/', child: (_, args) => ProfilePage()),
    ChildRoute('/', child: (_, args) => ProfilePage()),
    ChildRoute('/settings', child: (_, args) => SettingsPage()),
    ChildRoute('/app-info', child: (_, args) => AppInfo()),
    ChildRoute('/terms', child: (_, args) => Terms()),
    ChildRoute('/privacy', child: (_, args) => Privacy()),
    ChildRoute('/edit-profile', child: (_, args) => EditProfile()),
    ChildRoute('/answer-rating', child: (_, args) => AnswerRating()),
    ChildRoute('/ratings', child: (_, args) => Ratings()),
    ChildRoute('/notifications', child: (_, args) => Notifications()),
    ChildRoute('/coupons', child: (_, args) => Coupons()),
    ChildRoute('/favorites', child: (_, args) => Favorites()),
    ChildRoute('/user-promotional-code', child: (_, args) => UserPromotionalCode()),
  ];

  @override
  Widget get view => ProfilePage();
}
