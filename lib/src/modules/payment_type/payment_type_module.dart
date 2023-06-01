import 'package:flutter_modular/flutter_modular.dart';
import './payment_type_controller.dart';
import './payment_type_page.dart';

class PaymentTypeModule extends Module {
    @override
    final List<Bind> binds = [
      Bind.lazySingleton((i) => PaymentTypeController(i())),
    ];
 
    @override
    final List<ModularRoute> routes = [
      ChildRoute('/', child: (context, args) => PaymentTypePage(controller: Modular.get())),
    ];
 
}