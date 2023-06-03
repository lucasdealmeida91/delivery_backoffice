import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import 'detail/order_detail_modal.dart';
import 'order.controller.dart';
import 'widget/order_header.dart';
import 'widget/order_item.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({
    Key? key,
  }) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with Loader, Messages {
  final controller = Modular.get<OrderController>();
  late final ReactionDisposer statusDisposer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      statusDisposer = reaction((_) => controller.status, (status) {
        switch (status) {
          case OrderStateStatus.initial:
            break;
          case OrderStateStatus.loading:
            showLoader();
            break;
          case OrderStateStatus.loaded:
            hideLoader();
            break;
          case OrderStateStatus.error:
            hideLoader();
            showError(
              controller.errorMessage!,
            );
            break;
          case OrderStateStatus.showDetailsModal:
            hideLoader();
            showOrderDetail();
            break;
          case OrderStateStatus.statusChanged:
            hideLoader();
            Navigator.of(context, rootNavigator: true).pop();
            controller.findOrders();
            break;
        }
      });
      controller.findOrders();
    });
  }

  void showOrderDetail() {
    showDialog(
      context: context,
      builder: (context) {
        return OrderDetailModal(
          controller: controller,
          order: controller.orderSelected!,
        );
      },
    );
  }

  @override
  void dispose() {
    statusDisposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Colors.grey[50],
          padding: const EdgeInsets.only(left: 40, top: 40, right: 40),
          child: Column(
            children: [
              OrderHeader(controller: controller),
              const SizedBox(
                height: 50,
              ),
              Expanded(
                child: Observer(
                  builder: (_) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisExtent: 91,
                        maxCrossAxisExtent: 600,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return OrderItem(order: controller.orders[index]);
                      },
                      itemCount: controller.orders.length,
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
