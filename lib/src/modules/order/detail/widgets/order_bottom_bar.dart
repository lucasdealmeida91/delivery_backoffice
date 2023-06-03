import 'package:flutter/material.dart';

import '../../../../core/ui/styles/text_styles.dart';
import '../../../../dto/order/order_dto.dart';
import '../../../../model/orders/order_status.dart';
import '../../order.controller.dart';

class OrderBottomBar extends StatelessWidget {
  final OrderController controller;
  final OrderDto order;
  const OrderBottomBar({
    super.key,
    required this.controller,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BottomBarButton(
          onPressed: order.status == OrderStatus.confirmado
              ? () {
                  controller.changeStatus(OrderStatus.finalizado);
                }
              : null,
          buttonLabel: 'Finalizar',
          image: 'assets/images/icons/finish_order_white_ico.png',
          buttonColor: Colors.blue,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        BottomBarButton(
          buttonLabel: 'Confirmar',
          image: 'assets/images/icons/confirm_order_white_icon.png',
          buttonColor: Colors.green,
          borderRadius: BorderRadius.zero,
          onPressed: order.status == OrderStatus.pendente
              ? () {
                  controller.changeStatus(OrderStatus.confirmado);
                }
              : null,
        ),
        BottomBarButton(
          buttonLabel: 'Cancelar',
          image: 'assets/images/icons/cancel_order_white_icon.png',
          buttonColor: Colors.red,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
          onPressed: order.status != OrderStatus.cancelado &&
                  order.status != OrderStatus.finalizado
              ? () {
                  controller.changeStatus(OrderStatus.cancelado);
                }
              : null,
        )
      ],
    );
  }
}

class BottomBarButton extends StatelessWidget {
  final BorderRadius borderRadius;
  final Color buttonColor;
  final String image;
  final String buttonLabel;
  final VoidCallback? onPressed;

  const BottomBarButton({
    super.key,
    required this.borderRadius,
    required this.image,
    required this.buttonLabel,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            backgroundColor: buttonColor,
            side: BorderSide(
              color: onPressed != null ? buttonColor : Colors.transparent,
            ),
          ),
          onPressed: onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(image),
              const SizedBox(
                width: 5,
              ),
              Text(
                buttonLabel,
                style:
                    context.textStyles.textBold.copyWith(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
