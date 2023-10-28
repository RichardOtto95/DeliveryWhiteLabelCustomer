import 'package:delivery_customer/app/modules/product/product_Page.dart';
import 'package:delivery_customer/app/modules/product/product_store.dart';
import 'package:delivery_customer/app/modules/product/widgets/report_product.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'widgets/all_characteristics.dart';
import 'widgets/all_questions.dart';
import 'widgets/all_ratings.dart';

class ProductModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => ProductStore()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => ProductPage()),
    ChildRoute('/characteristics', child: (_, args) => AllCharacteristics()),
    ChildRoute('/questions',
        child: (_, args) => AllQuestions(adsId: args.data)),
    ChildRoute('/ratings', child: (_, args) => AllRatings(adsId: args.data)),
    ChildRoute('/report-product',
        child: (_, args) => ReportProduct(adsId: args.data)),
  ];
}
