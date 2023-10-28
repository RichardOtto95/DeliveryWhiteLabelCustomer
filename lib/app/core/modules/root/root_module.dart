import 'package:delivery_customer/app/core/modules/root/root_Page.dart';
import 'package:delivery_customer/app/core/modules/root/root_store.dart';
import 'package:delivery_customer/app/modules/address/address_module.dart';
import 'package:delivery_customer/app/modules/cart/cart_module.dart';
import 'package:delivery_customer/app/modules/home/widgets/was_invited.dart';
import 'package:delivery_customer/app/modules/main/main_module.dart';
import 'package:delivery_customer/app/modules/messages/messages_module.dart';
import 'package:delivery_customer/app/modules/orders/orders_module.dart';
import 'package:delivery_customer/app/modules/payment/payment_module.dart';
import 'package:delivery_customer/app/modules/payment/widgets/add_card.dart';
import 'package:delivery_customer/app/modules/product/product_module.dart';
import 'package:delivery_customer/app/modules/profile/profile_module.dart';
import 'package:delivery_customer/app/modules/profile/profile_store.dart';
import 'package:delivery_customer/app/modules/sign_email/sign_email_module.dart';
import 'package:delivery_customer/app/modules/sign_phone/sign_phone_module.dart';
import 'package:delivery_customer/app/modules/sign_phone/widgets/on_boarding.dart';
import 'package:delivery_customer/app/modules/sign_up/sign_up_module.dart';
import 'package:delivery_customer/app/modules/support/support_module.dart';
// import 'package:delivery_customer/app/modules/support/widgets/support_image.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../modules/sign_phone/widgets/verify.dart';

class RootModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => RootStore()),
    Bind.lazySingleton((i) => ProfileStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => RootPage()),
    ModuleRoute('/address', module: AddressModule()),
    ModuleRoute('/main', module: MainModule()),
    ModuleRoute('/cart', module: CartModule()),
    ModuleRoute('/orders', module: OrdersModule()),
    ModuleRoute('/profile', module: ProfileModule()),
    ModuleRoute('/messages', module: MessagesModule()),
    ModuleRoute('/payment', module: PaymentModule()),
    ModuleRoute('/product', module: ProductModule()),
    ModuleRoute('/support', module: SupportModule()),
    ModuleRoute('/sign-phone', module: SignPhoneModule()),
    ModuleRoute('/sign-email', module: SignEmailModule()),
    ModuleRoute('/sign-up-email', module: SignUpModule()),
    ChildRoute('/add-card', child: (_, args) => AddCard()),
    ChildRoute('/was-invited', child: (_, args) => WasInvited()),
    ChildRoute('/verify', child: (_, args) => Verify(phoneNumber: args.data)),
    // ChildRoute("/support-image",
    //     child: (_, args) => SupportImage(downloadUrl: args.data)),

    ChildRoute('/on-boarding', child: (_, args) => OnBoarding()),
  ];
}
