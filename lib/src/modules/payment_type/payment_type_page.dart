import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../core/ui/helpers/loader.dart';
import '../../core/ui/helpers/messages.dart';
import './payment_type_controller.dart';
import 'widgets/payment_type_form/payment_type_form_modal.dart';
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
      final filterDisposer =
          reaction((_) => widget._controller.filterEnabled, (_) {
        widget._controller.loadPayments();
      });
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
          case PaymentTypeStateStatus.addOrUpdatePayment:
            hideLoader();
            showAddOrUpdatePayment();
            break;
          case PaymentTypeStateStatus.saved:
            hideLoader();
            Navigator.of(context, rootNavigator: true).pop();
            widget._controller.loadPayments();
            showSuccess('Metodo salvo com sucesso');
            break;
        }
      });
      disposers.addAll([statusDisposer, filterDisposer]);
      widget._controller.loadPayments();
    });
  }

  void showAddOrUpdatePayment() {
    showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.black26,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.white,
            elevation: 10,
            child: PaymentTypeFormModal(
              controller: widget._controller,
              model: widget._controller.paymentTypeSelected,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    for (final dispose in disposers) {
      dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.only(left: 40, top: 40, right: 40),
      child: Column(
        children: [
          PaymentTypeHeader(controller: widget._controller),
          const SizedBox(
            height: 50,
          ),
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
                      controller: widget._controller,
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
