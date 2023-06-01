import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import './payment_type_controller.dart';
import 'widgets/payment_type_header.dart';
import 'widgets/payment_type_item.dart';

class PaymentTypePage extends StatefulWidget {
  final PaymentTypeController _controller;

  const PaymentTypePage({
    super.key,
    required PaymentTypeController controller,
  }) : _controller = controller;

  @override
  State<PaymentTypePage> createState() => _PaymentTypePageState();
}

class _PaymentTypePageState extends State<PaymentTypePage>
    with Loader, Messages {
  final disposers = <ReactionDisposer>[];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final statusDisposer =
          reaction((_) => widget._controller.status, (status) {
        switch (status) {
          case PaymentTypeStateStatus.initial:
            break;
          case PaymentTypeStateStatus.loading:
            showLoader();
            break;
          case PaymentTypeStateStatus.loaded:
            hideLoader();
            break;
          case PaymentTypeStateStatus.error:
            hideLoader();
            showError(
              widget._controller.errorMessage ??
                  'Erro ao buscar formas de pagamento',
            );

            break;
        }
      });
      disposers.addAll([statusDisposer]);
    });
  }

  @override
  void dispose() {
    disposers;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.only(left: 40, top: 40, right: 40),
      child: Column(
        children: [
          const PaymentTypeHeader(),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
              onPressed: () {
                widget._controller.loadPayments();
              },
              child: Text('data')),
          Expanded(
            child: Observer(
              builder: (_) {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 680,
                    mainAxisExtent: 120,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final paymentTypeModel =
                        widget._controller.paymentTypes[index];
                    return PaymentTypeItem(
                      payment: paymentTypeModel,
                    );
                  },
                  itemCount: widget._controller.paymentTypes.length,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
