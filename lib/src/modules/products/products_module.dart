import 'package:flutter_modular/flutter_modular.dart';

import 'home/products_page.dart';
import '../products/home/products_controller.dart';

class ProductsModule extends Module {
  @override
  List<Bind> get binds => [
        Bind.lazySingleton(
          (i) => ProductsController(i()),
        ),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute('/', child: (context, args) => ProductsPage()),
        // ChildRoute('/detail', child: (context, args) => ProductsPage()),
      ];
}
